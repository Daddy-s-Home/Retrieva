<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';

$session = require_login();
header('Content-Type: application/json');
$input = json_decode(file_get_contents('php://input'), true) ?? [];
$method = ($input['login_method'] ?? '') === 'totp' ? 'totp' : 'email';
get_db()->prepare('UPDATE users SET login_method = ? WHERE id = ?')->execute([$method, $session['user_id']]);
log_audit((int) $session['user_id'], 'login_method_updated', $method === 'totp' ? 'Authenticator code is asked first.' : 'Email code is asked first.');
json_out(['success' => true, 'message' => 'Sign-in method saved.']);
