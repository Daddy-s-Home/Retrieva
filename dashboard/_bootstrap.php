<?php
declare(strict_types=1);

/**
 * Included at the very top of every dashboard/*.php page.
 * Loads the session, enforces login, and fetches the current user's
 * row so header.php / sidebar.php / the page itself can all read it
 * directly — no client-side AJAX round-trip needed just to know who's
 * logged in.
 */

require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../database/db.php';
require_once __DIR__ . '/rbac.php';

// --- Pusher Configuration ---
define('PUSHER_APP_ID', '2190919');
define('PUSHER_KEY', '37ca687c653f5f52a830');
define('PUSHER_SECRET', '3490c00f428c3a676313');
define('PUSHER_CLUSTER', 'eu');

/**
 * Get an initialized Pusher instance.
 */
function get_pusher(): Pusher\Pusher {
    static $pusher = null;
    if ($pusher === null) {
        $pusher = new Pusher\Pusher(
            PUSHER_KEY,
            PUSHER_SECRET,
            PUSHER_APP_ID,
            [
                'cluster' => PUSHER_CLUSTER,
                'useTLS' => true,
            ]
        );
    }
    return $pusher;
}

/**
 * Helper function to trigger real-time notifications via Pusher.
 */
function notify_channel(string $channel, string $event, array $data): void {
    try {
        $pusher = get_pusher();
        $pusher->trigger($channel, $event, $data);
    } catch (\Throwable $e) {
        error_log('Pusher trigger failed: ' . $e->getMessage());
    }
}

// --- Session & User Resolution ---
$session = require_login_page('../auth/login.php');

$stmt = get_db()->prepare(
    'SELECT id, email, student_id, full_name, role, avatar_url, auth_provider,
            password_is_set, skip_password_prompt, totp_enabled
     FROM users WHERE id = ?'
);
$stmt->execute([$session['user_id']]);
$user = $stmt->fetch();

if (!$user) {
    // Session points at a user that no longer exists — force a clean re-login.
    $_SESSION = [];
    session_destroy();
    header('Location: ../auth/login.php');
    exit;
}

$role = $user['role'];

// Offline / no avatar on record -> the header falls back to the custom Retrieva avatar.
$avatarSrc = $user['avatar_url'] ?: '../assets/images/default-avatar.svg';

// The current page's slug, used by sidebar.php to highlight the active link.
$currentPage = $currentPage ?? 'dashboard';