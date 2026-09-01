<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
require_once __DIR__ . '/mailer.php';

start_session();
header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true) ?? [];
$email = trim((string)($input['email'] ?? ''));

$stmt = get_db()->prepare('SELECT id, email FROM users WHERE email = ? AND auth_provider = "local"');
$stmt->execute([$email]);
$user = $stmt->fetch();

// Always respond success (even for unknown emails) so the form can't be
// used to check which addresses are registered.
if ($user) {
    $secret = totp_generate_secret();
    $code   = totp_code($secret);

    $db = get_db();
    $db->prepare('UPDATE users SET totp_secret = ? WHERE id = ?')->execute([$secret, $user['id']]);
    $db->prepare(
        'INSERT INTO totp_challenges (user_id, code_hash, purpose, expires_at) VALUES (?, ?, "password_reset", DATE_ADD(NOW(), INTERVAL 5 MINUTE))'
    )->execute([$user['id'], password_hash($code, PASSWORD_BCRYPT)]);

    try {
        send_totp_email($user['email'], $code);
    } catch (Throwable $e) {
        error_log("Failed to dispatch password reset TOTP email: " . $e->getMessage());
    }

    $_SESSION['pending_reset_user_id'] = $user['id'];
}

json_out(['success' => true, 'message' => 'If that email is registered, a code has been sent.']);