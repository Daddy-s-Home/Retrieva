<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';

start_session();
header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input') ?: '', true);
$input = is_array($input) ? $input : [];
$factor = (string) ($input['factor'] ?? '');
if (!in_array($factor, ['email', 'totp'], true)) {
    json_out(['success' => false, 'message' => 'Choose a valid sign-in method.'], 400);
}
$csrfToken = $input['csrf_token'] ?? null;
if (!is_string($csrfToken) || !verify_csrf($csrfToken)) {
    json_out(['success' => false, 'message' => 'Your session expired. Please sign in again.'], 400);
}

$userId = $_SESSION['pending_totp_user_id'] ?? null;
if ($userId === null || $userId === '' || !is_numeric($userId) || session_id_present('pending_reset_user_id')) {
    json_out(['success' => false, 'message' => 'Session expired — please start again.'], 401);
}

$db = get_db();
$stmt = $db->prepare('SELECT id, totp_enabled, status FROM users WHERE id = ?');
$stmt->execute([$userId]);
$user = $stmt->fetch();
if (!$user || $user['status'] !== 'active') {
    json_out(['success' => false, 'message' => 'Session expired — please start again.'], 401);
}

if ($factor === 'totp') {
    if ((int) $user['totp_enabled'] !== 1) {
        json_out(['success' => false, 'message' => 'Set up an authenticator app before using that sign-in code.'], 400);
    }
    $_SESSION['pending_login_factor'] = 'totp';
    json_out(['success' => true, 'factor' => 'totp']);
}

$_SESSION['pending_login_factor'] = 'email';
json_out(['success' => true, 'factor' => 'email', 'message' => 'Email verification selected.']);
