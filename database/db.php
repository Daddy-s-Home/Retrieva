<?php
/**
 * db.php — shared PDO connection for the whole app.
 * XAMPP defaults: host=localhost, user=root, password="" (blank).
 * Update the constants below if your MySQL setup differs.
 */

declare(strict_types=1);

const DB_HOST = 'localhost';
const DB_NAME = 'retrieva_db_current';
const DB_USER = 'root';
const DB_PASS = '';

function get_db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        try {
            $pdo = new PDO(
                'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
                DB_USER,
                DB_PASS,
                [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]
            );
        } catch (PDOException $e) {
            http_response_code(500);
            die(json_encode(['success' => false, 'message' => 'Database connection failed.']));
        }
    }
    return $pdo;
}

/** Starts (or resumes) the PHP session with sane cookie defaults. */
function start_session(): void {
    if (session_status() === PHP_SESSION_NONE) {
        session_set_cookie_params([
            'lifetime' => 0,
            'path'     => '/',
            'httponly' => true,
            'samesite' => 'Lax',
        ]);
        session_start();
    }
}

/** True when a session key holds a numeric id, including 0. */
function session_id_present(string $key): bool {
    if (!isset($_SESSION[$key]) || $_SESSION[$key] === '' || $_SESSION[$key] === null) {
        return false;
    }
    return is_numeric($_SESSION[$key]);
}

/** Escapes nullable view values for safe HTML output. */
function h(?string $value): string {
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}

/** Returns the per-session CSRF token used by HTML forms. */
function csrf_token(): string {
    start_session();
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

/** Renders a hidden CSRF field for an HTML form. */
function csrf_field(): string {
    return '<input type="hidden" name="csrf_token" value="' . h(csrf_token()) . '">';
}

/** Verifies an HTML form's submitted CSRF token. */
function verify_csrf(?string $submitted): bool {
    start_session();
    return is_string($submitted)
        && !empty($_SESSION['csrf_token'])
        && hash_equals($_SESSION['csrf_token'], $submitted);
}

/** Sends a JSON response and stops execution. */
function json_out(array $payload, int $code = 200): void {
    http_response_code($code);
    header('Content-Type: application/json');
    echo json_encode($payload);
    exit;
}

/** Checks whether a session ID key is present without rejecting ID 0. */
function has_session_id(string $key = 'user_id'): bool {
    return isset($_SESSION[$key]) && $_SESSION[$key] !== '';
}

function refresh_session_account(): bool {
    if (!session_id_present('user_id')) {
        return false;
    }

    $stmt = get_db()->prepare('SELECT role, status FROM users WHERE id = ?');
    $stmt->execute([$_SESSION['user_id']]);
    $account = $stmt->fetch();
    if (!$account || $account['status'] !== 'active') {
        return false;
    }

    $_SESSION['role'] = $account['role'];
    return true;
}

/** Quick guard for endpoints that require an authenticated session. */
function require_login(): array {
    start_session();
    if (!refresh_session_account()) {
        $_SESSION = [];
        session_destroy();
        json_out(['success' => false, 'message' => 'Not authenticated.'], 401);
    }
    return $_SESSION;
}

/** Quick guard for endpoints restricted to specific RBAC roles. */
function require_role(array $allowed_roles): array {
    $session = require_login();
    if (!in_array($session['role'], $allowed_roles, true)) {
        json_out(['success' => false, 'message' => 'Forbidden — insufficient role.'], 403);
    }
    return $session;
}

/**
 * Guard for full HTML/PHP pages (as opposed to AJAX/JSON endpoints):
 * redirects to the login page instead of returning a JSON 401, since
 * a page can't do anything useful with a raw JSON error body.
 */
function require_login_page(string $loginPath = '../auth/login.php'): array {
    start_session();
    if (!refresh_session_account()) {
        $_SESSION = [];
        session_destroy();
        header('Location: ' . $loginPath);
        exit;
    }
    return $_SESSION;
}

/** Same idea as require_login_page() but also enforces an RBAC role list. */
function require_role_page(array $allowed_roles, string $forbiddenPath = '../dashboard/index.php'): array {
    $session = require_login_page();
    if (!in_array($session['role'], $allowed_roles, true)) {
        header('Location: ' . $forbiddenPath);
        exit;
    }
    return $session;
}

/** Assigns LR-/F-/CL- public codes after an insert. Table names are whitelisted. */
function assign_public_code(string $table, int $id): void {
    $prefixes = [
        'lost_items' => 'LR',
        'found_items' => 'F',
        'claims' => 'CL',
    ];
    if ($id < 1 || !isset($prefixes[$table])) {
        return;
    }
    $code = $prefixes[$table] . '-' . date('Y') . '-' . str_pad((string) $id, 3, '0', STR_PAD_LEFT);
    $stmt = get_db()->prepare("UPDATE {$table} SET public_code = ? WHERE id = ? AND (public_code IS NULL OR public_code = '')");
    $stmt->execute([$code, $id]);
}

function log_audit(?int $user_id, string $action, string $details = ''): void {
    $stmt = get_db()->prepare(
        'INSERT INTO audit_trail (user_id, action, details, ip_address, user_agent) VALUES (?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $user_id, 
        $action, 
        $details, 
        $_SERVER['REMOTE_ADDR'] ?? null,
        $_SERVER['HTTP_USER_AGENT'] ?? null
    ]);
}