<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
require_once __DIR__ . '/mailer.php';

start_session();
header('Content-Type: application/json');

$input    = json_decode(file_get_contents('php://input'), true) ?? [];
$email    = trim((string)($input['email'] ?? ''));
$password = (string)($input['password'] ?? '');

if ($email === '' || $password === '') {
    json_out(['success' => false, 'message' => 'Email and password are required.'], 400);
}

$stmt = get_db()->prepare('SELECT * FROM users WHERE email = ?');
$stmt->execute([$email]);
$user = $stmt->fetch();

// Same generic message whether the email is unknown or the password is
// wrong, so login can't be used to enumerate valid campus emails.
$invalidMsg = 'Incorrect email or password.';

if (!$user || $user['auth_provider'] !== 'local' || !$user['password_hash']) {
    json_out(['success' => false, 'message' => $invalidMsg], 401);
}
if ($user['status'] === 'blocked') {
    json_out(['success' => false, 'message' => 'This account has been blocked. Contact the security office.'], 403);
}
if (!password_verify($password, $user['password_hash'])) {
    json_out(['success' => false, 'message' => $invalidMsg], 401);
}

// Password is correct -> issue a fresh TOTP code for the second factor.
$secret = totp_generate_secret();
$code   = totp_code($secret);

$db = get_db();
$db->prepare('UPDATE users SET totp_secret = ? WHERE id = ?')->execute([$secret, $user['id']]);
$db->prepare(
    'INSERT INTO totp_challenges (user_id, code_hash, purpose, expires_at) VALUES (?, ?, "login", DATE_ADD(NOW(), INTERVAL 5 MINUTE))'
)->execute([$user['id'], password_hash($code, PASSWORD_BCRYPT)]);

send_totp_email($user['email'], $code); // see mailer.php — wire in your Email API here

// Stash a pending-login marker; the real session is only granted after TOTP succeeds.
$_SESSION['pending_totp_user_id'] = $user['id'];

log_audit((int)$user['id'], 'login_password_ok', 'Password verified, TOTP sent.');

json_out(['success' => true, 'message' => 'Enter the 6-digit code sent to your email.']);
