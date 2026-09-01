<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';

start_session();
header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true) ?? [];

$password        = (string)($input['password'] ?? '');
$confirmPassword = (string)($input['confirm_password'] ?? '');

if (strlen($password) < 8) {
    json_out(['success' => false, 'message' => 'Password must be at least 8 characters.'], 400);
}
if ($password !== $confirmPassword) {
    json_out(['success' => false, 'message' => 'Passwords do not match.'], 400);
}

// Two entry points land here:
// 1) Forgot-password flow — user already verified a TOTP, reset_user_id is in session.
// 2) First-login "set a password now" popup for Google sign-ups — user_id is in session.
$userId = $_SESSION['reset_user_id'] ?? $_SESSION['user_id'] ?? null;
if (!$userId) {
    json_out(['success' => false, 'message' => 'No active session for password reset.'], 401);
}

$hash = password_hash($password, PASSWORD_BCRYPT);

$stmt = get_db()->prepare(
    'UPDATE users
     SET password_hash = ?, password_is_set = 1, auth_provider = "local"
     WHERE id = ?'
);
$stmt->execute([$hash, $userId]);

log_audit((int)$userId, 'password_set', 'Password created/updated by user.');

// Clear the one-time reset session flag so it can't be reused.
unset($_SESSION['reset_user_id']);

json_out(['success' => true, 'message' => 'Password saved.']);