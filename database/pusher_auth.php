<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/notify_helper.php';
require_once __DIR__ . '/../dashboard/rbac.php';

$session = require_login();
$userId  = (int) $session['user_id'];
$role    = (string) ($session['role'] ?? 'student');

$raw = file_get_contents('php://input');
$params = $_POST;
if (!$params && is_string($raw) && $raw !== '') {
    parse_str($raw, $params);
}

$socketId    = trim((string) ($params['socket_id'] ?? ''));
$channelName = trim((string) ($params['channel_name'] ?? ''));

if ($socketId === '' || $channelName === '') {
    json_out(['success' => false, 'message' => 'Missing socket_id or channel_name.'], 400);
}

$authorized = false;
if ($channelName === 'private-updates') {
    $authorized = true;
} elseif ($channelName === 'private-staff') {
    $authorized = role_is_admin_side($role);
} elseif (preg_match('/^private-user-(\d+)$/', $channelName, $m)) {
    $authorized = ((int) $m[1] === $userId);
}

if (!$authorized) {
    json_out(['success' => false, 'message' => 'Forbidden channel subscription.'], 403);
}

$pusher = get_pusher_client();
if (!$pusher) {
    json_out(['success' => false, 'message' => 'Pusher service unavailable.'], 500);
}

header('Content-Type: application/json');
echo $pusher->socket_auth($channelName, $socketId);
