<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';

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

if (!$userId) {
    json_out(['success' => false, 'message' => 'Session expired — please start again.'], 401);
}

$db = get_db();

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
    // Promote the pending login into a real authenticated session.
    $user = $db->prepare('SELECT id, role, full_name FROM users WHERE id = ?');
    $user->execute([$userId]);
    $u = $user->fetch();

    $_SESSION['user_id'] = $u['id'];
    $_SESSION['role']    = $u['role'];
    $_SESSION['name']    = $u['full_name'];
    unset($_SESSION['pending_totp_user_id']);

    log_audit((int)$userId, 'login_success', 'TOTP verified, session started.');
    json_out(['success' => true, 'redirect' => '../dashboard/index.php']);
}

// password_reset purpose: hand off to forgot-password.php's step 3
// (new password / confirm password), which lives on the same page.
unset($_SESSION['pending_reset_user_id']);
$_SESSION['reset_user_id'] = $userId;

json_out(['success' => true, 'redirect' => 'forgot-password.php?step=reset']);
