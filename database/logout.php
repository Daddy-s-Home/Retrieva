<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';

start_session();
header('Content-Type: application/json');

if (!empty($_SESSION['user_id'])) {
    log_audit((int)$_SESSION['user_id'], 'logout', '');
}

$_SESSION = [];
session_destroy();

json_out(['success' => true, 'redirect' => '../auth/login.php']);
