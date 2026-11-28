<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';

$autoloader = __DIR__ . '/../vendor/autoload.php';
if (file_exists($autoloader)) {
    require_once $autoloader;
}

if (!defined('PUSHER_APP_ID')) {
    define('PUSHER_APP_ID', '2190919');
    define('PUSHER_KEY', '37ca687c653f5f52a830');
    define('PUSHER_SECRET', '3490c00f428c3a676313');
    define('PUSHER_CLUSTER', 'eu');
}

/**
 * Returns a shared Pusher\Pusher instance or null if SDK is unavailable.
 */
function get_pusher_client(): ?Pusher\Pusher {
    static $client = null;
    if ($client === null && class_exists('Pusher\Pusher')) {
        $client = new Pusher\Pusher(
            PUSHER_KEY,
            PUSHER_SECRET,
            PUSHER_APP_ID,
            [
                'cluster' => PUSHER_CLUSTER,
                'useTLS'  => true,
                'curl_options' => [CURLOPT_SSL_VERIFYPEER => false],
            ]
        );
    }
    return $client;
}

/**
 * Broadcasts a non-sensitive synchronization event to a Pusher channel.
 * Should be called only after the corresponding DB transaction succeeds.
 */
function broadcast_event(string $channel, string $event, array $data = []): void {
    $pusher = get_pusher_client();
    if (!$pusher) {
        return;
    }
    try {
        $pusher->trigger($channel, $event, $data);
    } catch (Throwable $e) {
        error_log("Pusher broadcast failed ({$channel} / {$event}): " . $e->getMessage());
    }
}

/**
 * Persists a notification for each target user ID and broadcasts it over their private channel.
 */
function notify_users(
    array $userIds,
    string $category,
    string $title,
    string $body,
    ?string $entityType = null,
    ?int $entityId = null,
    string $toastType = 'info'
): void {
    $ids = array_values(array_unique(array_map('intval', $userIds)));
    if (!$ids) {
        return;
    }

    $allowedCategories = ['match', 'claim', 'report', 'system'];
    if (!in_array($category, $allowedCategories, true)) {
        $category = 'system';
    }

    $notificationIds = [];
    try {
        $db = get_db();
        $stmt = $db->prepare(
            'INSERT INTO notifications (user_id, category, title, body, entity_type, entity_id)
             VALUES (?, ?, ?, ?, ?, ?)'
        );
        foreach ($ids as $uid) {
            $stmt->execute([$uid, $category, mb_substr($title, 0, 180), $body, $entityType, $entityId]);
            $notificationIds[$uid] = (int) $db->lastInsertId();
        }
    } catch (Throwable $e) {
        error_log('Notification DB insert failed: ' . $e->getMessage());
    }

    foreach ($ids as $uid) {
        broadcast_event("private-user-{$uid}", 'notification', [
            'id'          => $notificationIds[$uid] ?? null,
            'category'    => $category,
            'title'       => $title,
            'message'     => $body,
            'type'        => $toastType,
            'entity_type' => $entityType,
            'entity_id'   => $entityId,
        ]);
    }
}

/**
 * Resolves active users matching the given RBAC roles and sends them a notification.
 */
function notify_roles(
    array $roles,
    string $category,
    string $title,
    string $body,
    ?string $entityType = null,
    ?int $entityId = null,
    string $toastType = 'info'
): void {
    $roles = array_values(array_unique(array_filter($roles, 'is_string')));
    if (!$roles) {
        return;
    }

    try {
        $db = get_db();
        $placeholders = implode(',', array_fill(0, count($roles), '?'));
        $stmt = $db->prepare(
            "SELECT id FROM users WHERE role IN ($placeholders) AND status = 'active'"
        );
        $stmt->execute($roles);
        $ids = $stmt->fetchAll(PDO::FETCH_COLUMN);
        if ($ids) {
            notify_users($ids, $category, $title, $body, $entityType, $entityId, $toastType);
        }
    } catch (Throwable $e) {
        error_log('notify_roles failed: ' . $e->getMessage());
    }
}
