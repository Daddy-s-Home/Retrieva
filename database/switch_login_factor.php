<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
require_once __DIR__ . '/mailer.php';

start_session();
header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true) ?? [];
$factor = ($input['factor'] ?? '') === 'totp' ? 'totp' : 'email';
$userId = $_SESSION['pending_totp_user_id'] ?? null;
if ($userId === null || $userId === '' || !is_numeric($userId) || session_id_present('pending_reset_user_id')) {
    json_out(['success' => false, 'message' => 'Session expired — please start again.'], 401);
}

$db = get_db();
$stmt = $db->prepare('SELECT id, email, totp_enabled FROM users WHERE id = ?');
$stmt->execute([$userId]);
$user = $stmt->fetch();
if (!$user) {
    json_out(['success' => false, 'message' => 'Session expired — please start again.'], 401);
}

if ($factor === 'totp') {
    if ((int) $user['totp_enabled'] !== 1) {
        json_out(['success' => false, 'message' => 'Set up an authenticator app before using that sign-in code.'], 400);
    }
    $_SESSION['pending_login_factor'] = 'totp';
    json_out(['success' => true, 'factor' => 'totp']);
}

$secret = totp_generate_secret();
$code = totp_code($secret);
$db->prepare(
    'INSERT INTO totp_challenges (user_id, code_hash, purpose, expires_at) VALUES (?, ?, "login", DATE_ADD(NOW(), INTERVAL 5 MINUTE))'
)->execute([$user['id'], password_hash($code, PASSWORD_BCRYPT)]);
try {
    send_totp_email($user['email'], $code);
} catch (Throwable $e) {
    error_log('Failed to dispatch TOTP email: ' . $e->getMessage());
}
$_SESSION['pending_login_factor'] = 'email';
json_out(['success' => true, 'factor' => 'email']);
