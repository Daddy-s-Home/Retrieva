<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
require_once __DIR__ . '/notify_helper.php';

$autoloader = __DIR__ . '/../vendor/autoload.php';
if (file_exists($autoloader)) {
    require_once $autoloader;
}

start_session();
header('Content-Type: application/json');

$input   = json_decode(file_get_contents('php://input'), true) ?? [];
$code    = trim((string)($input['code'] ?? ''));
$purpose = $input['purpose'] === 'password_reset' ? 'password_reset' : 'login';

if (!preg_match('/^\d{6}$/', $code)) {
    json_out(['success' => false, 'message' => 'Enter all 6 digits.'], 400);
}

$userId = $purpose === 'password_reset'
    ? ($_SESSION['pending_reset_user_id'] ?? null)
    : ($_SESSION['pending_totp_user_id'] ?? null);

if ($userId === null || $userId === '' || !is_numeric($userId)) {
    json_out(['success' => false, 'message' => 'Session expired — please start again.'], 401);
}

$db = get_db();
$factor = $_SESSION['pending_login_factor'] ?? 'email';

if ($purpose === 'login' && $factor === 'totp') {
    $user = $db->prepare('SELECT id, role, full_name, totp_secret, totp_enabled, status FROM users WHERE id = ?');
    $user->execute([$userId]);
    $u = $user->fetch();
    if (!$u || $u['status'] !== 'active' || (int) $u['totp_enabled'] !== 1 || !totp_verify((string) $u['totp_secret'], $code)) {
        json_out(['success' => false, 'message' => 'Incorrect or expired code.'], 401);
    }
    retrieva_start_login_session($db, $u);
}

$stmt = $db->prepare(
    'SELECT * FROM totp_challenges
     WHERE user_id = ? AND purpose = ? AND consumed_at IS NULL AND expires_at > NOW()
     ORDER BY id DESC LIMIT 1'
);
$stmt->execute([$userId, $purpose]);
$challenge = $stmt->fetch();

if (!$challenge || !password_verify($code, $challenge['code_hash'])) {
    json_out(['success' => false, 'message' => 'Incorrect or expired code.'], 401);
}

$db->prepare('UPDATE totp_challenges SET consumed_at = NOW() WHERE id = ?')->execute([$challenge['id']]);

if ($purpose === 'login') {
    $user = $db->prepare('SELECT id, role, full_name, status FROM users WHERE id = ?');
    $user->execute([$userId]);
    $u = $user->fetch();
    if (!$u || $u['status'] !== 'active') {
        json_out(['success' => false, 'message' => 'This account cannot complete sign-in.'], 403);
    }
    retrieva_start_login_session($db, $u);
}

// password_reset purpose: hand off to forgot-password.php's step 3
// (new password / confirm password), which lives on the same page.
unset($_SESSION['pending_reset_user_id']);
$_SESSION['reset_user_id'] = $userId;

json_out(['success' => true, 'redirect' => 'forgot-password.php?step=reset']);

function retrieva_start_login_session(PDO $db, array $u): void {
    $_SESSION['user_id'] = $u['id'];
    $_SESSION['role']    = $u['role'];
    $_SESSION['name']    = $u['full_name'];
    unset(
        $_SESSION['pending_totp_user_id'],
        $_SESSION['pending_login_factor'],
        $_SESSION['pending_login_can_switch'],
        $_SESSION['pending_login_email_requested_at']
    );

    $_SESSION['pending_notif'] = [
        'title'   => 'User Activity',
        'message' => 'You have logged in successfully.',
        'type'    => 'info',
    ];

    $db->prepare('UPDATE users SET email_verified = 1, last_login_at = NOW() WHERE id = ?')->execute([(int) $u['id']]);
    log_audit((int) $u['id'], 'login_success', 'Sign-in code verified, session started.');
    notify_roles(['admin'], 'system', 'User Signed In', "{$u['full_name']} ({$u['role']}) signed in.", 'user', (int) $u['id'], 'info');
    json_out(['success' => true, 'redirect' => '../dashboard/index.php']);
}
