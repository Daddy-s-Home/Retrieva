<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
require_once __DIR__ . '/mailer.php';

start_session();
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_out(['success' => false, 'message' => 'Method not allowed.'], 405);
}

$input = json_decode(file_get_contents('php://input') ?: '', true);
$input = is_array($input) ? $input : [];
$intent = (string) ($input['intent'] ?? '');
if (!in_array($intent, ['initial', 'resend'], true)) {
    json_out(['success' => false, 'message' => 'Invalid code request.'], 400);
}
$csrfToken = $input['csrf_token'] ?? null;
if (!is_string($csrfToken) || !verify_csrf($csrfToken)) {
    json_out(['success' => false, 'message' => 'Your session expired. Please sign in again.'], 400);
}

$userId = $_SESSION['pending_totp_user_id'] ?? null;
if (
    !is_numeric($userId)
    || session_id_present('user_id')
    || session_id_present('pending_reset_user_id')
    || ($_SESSION['pending_login_factor'] ?? '') !== 'email'
) {
    json_out(['success' => false, 'message' => 'Your sign-in session expired. Please start again.'], 401);
}

$cooldown = 30;
$now = time();
$lastRequest = (int) ($_SESSION['pending_login_email_requested_at'] ?? 0);
$retryAfter = max(0, $cooldown - ($now - $lastRequest));

if ($intent === 'initial' && $lastRequest > 0) {
    json_out([
        'success' => true,
        'already_requested' => true,
        'retry_after' => $retryAfter,
        'message' => 'A code request is already in progress or was recently attempted. Check your email before resending.',
    ]);
}
if ($intent === 'resend' && $retryAfter > 0) {
    json_out([
        'success' => false,
        'retry_after' => $retryAfter,
        'message' => 'Please wait before requesting another code.',
    ], 429);
}

$db = get_db();
$stmt = $db->prepare('SELECT email, status FROM users WHERE id = ?');
$stmt->execute([$userId]);
$user = $stmt->fetch();
if (!$user || $user['status'] !== 'active') {
    json_out(['success' => false, 'message' => 'This account cannot complete sign-in.'], 403);
}

$_SESSION['pending_login_email_requested_at'] = $now;
session_write_close();

$challengeId = null;
try {
    $code = totp_code(totp_generate_secret());
    $db->beginTransaction();
    $db->prepare(
        "UPDATE totp_challenges SET consumed_at = NOW()
         WHERE user_id = ? AND purpose = 'login' AND consumed_at IS NULL"
    )->execute([$userId]);
    $stmt = $db->prepare(
        'INSERT INTO totp_challenges (user_id, code_hash, purpose, expires_at)
         VALUES (?, ?, "login", DATE_ADD(NOW(), INTERVAL 5 MINUTE))'
    );
    $stmt->execute([$userId, password_hash($code, PASSWORD_DEFAULT)]);
    $challengeId = (int) $db->lastInsertId();
    $db->commit();
} catch (Throwable $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Unable to create login verification challenge: ' . $e->getMessage());
    json_out([
        'success' => false,
        'retry_after' => $cooldown,
        'message' => 'The verification code could not be prepared. Please try again shortly.',
    ], 500);
}

try {
    send_totp_email((string) $user['email'], $code);
} catch (Throwable $e) {
    $db->prepare('UPDATE totp_challenges SET consumed_at = NOW() WHERE id = ?')->execute([$challengeId]);
    error_log('Failed to dispatch login verification email: ' . $e->getMessage());
    json_out([
        'success' => false,
        'retry_after' => $cooldown,
        'message' => 'The verification email could not be sent. Please try again shortly.',
    ], 503);
}

json_out([
    'success' => true,
    'retry_after' => $cooldown,
    'message' => 'A verification code was sent. Check your email.',
]);
