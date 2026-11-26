<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';

$session = require_login();
$userId = (int)$session['user_id'];
$db = get_db();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true) ?? [];
    $action = (string)($input['action'] ?? '');

    if ($action === 'mark_read') {
        $db->prepare('UPDATE notifications SET read_at = NOW() WHERE user_id = ? AND read_at IS NULL')
           ->execute([$userId]);
        json_out(['success' => true]);
    }

    if ($action === 'clear') {
        $db->prepare('DELETE FROM notifications WHERE user_id = ?')
           ->execute([$userId]);
        json_out(['success' => true]);
    }

    json_out(['success' => false, 'message' => 'Invalid notification action.'], 400);
}

$stmt = $db->prepare(
    'SELECT id, category, title, body, entity_type, entity_id, read_at, created_at
     FROM notifications
     WHERE user_id = ?
     ORDER BY created_at DESC, id DESC
     LIMIT 30'
);
$stmt->execute([$userId]);
$rows = $stmt->fetchAll();

$unreadCount = 0;
foreach ($rows as $row) {
    if ($row['read_at'] === null) {
        $unreadCount++;
    }
}

json_out([
    'success'       => true,
    'unread_count'  => $unreadCount,
    'notifications' => $rows,
]);
