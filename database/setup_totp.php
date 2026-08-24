<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
$session = require_login();
header('Content-Type: application/json');
$input = json_decode(file_get_contents('php://input'), true) ?? [];
$action = (string)($input['action'] ?? 'start');
$db = get_db();
if ($action === 'start') {
    $secret = totp_generate_secret();
    $_SESSION['pending_totp_setup_secret'] = $secret;
    json_out(['success' => true, 'secret' => $secret]);
}
if ($action === 'verify') {
    $secret = (string)($_SESSION['pending_totp_setup_secret'] ?? '');
    $code = trim((string)($input['code'] ?? ''));
    if ($secret === '' || !preg_match('/^\d{6}$/', $code) || !totp_verify($secret, $code)) json_out(['success' => false, 'message' => 'That authenticator code is invalid or expired.'], 400);
    $stmt = $db->prepare('UPDATE users SET totp_secret = ?, totp_enabled = 1 WHERE id = ?');
    $stmt->execute([$secret, $session['user_id']]);
    unset($_SESSION['pending_totp_setup_secret']);
    log_audit((int)$session['user_id'], 'totp_enabled', 'Authenticator app enabled from account settings.');
    json_out(['success' => true, 'message' => 'Authenticator enabled.']);
}
if ($action === 'disable') {
    $stmt = $db->prepare('UPDATE users SET totp_secret = NULL, totp_enabled = 0 WHERE id = ?');
    $stmt->execute([$session['user_id']]);
    unset($_SESSION['pending_totp_setup_secret']);
    log_audit((int)$session['user_id'], 'totp_disabled', 'Authenticator app disabled from account settings.');
    json_out(['success' => true, 'message' => 'Authenticator disabled.']);
}
json_out(['success' => false, 'message' => 'Unsupported TOTP action.'], 400);
