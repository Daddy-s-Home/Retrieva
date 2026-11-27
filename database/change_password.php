<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
$session = require_login();
header('Content-Type: application/json');
$input = json_decode(file_get_contents('php://input'), true) ?? [];
$current = (string)($input['current_password'] ?? '');
$totpCode = trim((string)($input['totp_code'] ?? ''));
$password = (string)($input['password'] ?? '');
$confirm = (string)($input['confirm_password'] ?? '');
if ($password === '' || $confirm === '') json_out(['success' => false, 'message' => 'New password and confirmation are required.'], 400);
if (strlen($password) < 8 || !preg_match('/[A-Z]/', $password) || !preg_match('/[a-z]/', $password) || !preg_match('/\d/', $password) || !preg_match('/[^A-Za-z0-9]/', $password)) {
    json_out(['success' => false, 'message' => 'Password must be at least 8 characters and include uppercase, lowercase, number, and special character.'], 400);
}
if ($password !== $confirm) json_out(['success' => false, 'message' => 'Passwords do not match.'], 400);
$stmt = get_db()->prepare('SELECT password_hash, totp_enabled, totp_secret FROM users WHERE id = ?');
$stmt->execute([$session['user_id']]);
$user = $stmt->fetch();
if (!$user || !$user['password_hash']) json_out(['success' => false, 'message' => 'Account verification failed.'], 401);
if (!empty($user['totp_enabled'])) {
    if (!preg_match('/^\d{6}$/', $totpCode) || empty($user['totp_secret']) || !totp_verify((string)$user['totp_secret'], $totpCode)) {
        json_out(['success' => false, 'message' => 'Authenticator code is invalid or expired.'], 401);
    }
} else {
    if ($current === '') json_out(['success' => false, 'message' => 'Current password is required.'], 400);
    if (!password_verify($current, $user['password_hash'])) json_out(['success' => false, 'message' => 'Current password is incorrect.'], 401);
}
$update = get_db()->prepare('UPDATE users SET password_hash = ?, password_is_set = 1, auth_provider = "local" WHERE id = ?');
$update->execute([password_hash($password, PASSWORD_BCRYPT), $session['user_id']]);
log_audit((int)$session['user_id'], 'password_changed', 'Password changed from account settings.');
json_out(['success' => true, 'message' => 'Password updated.']);
