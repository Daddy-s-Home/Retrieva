<?php
declare(strict_types=1);

/**
 * Included at the very top of every dashboard/*.php page.
 * Loads the session, enforces login, and fetches the current user's
 * row so header.php / sidebar.php / the page itself can all read it
 * directly — no client-side AJAX round-trip needed just to know who's
 * logged in.
 */

require_once __DIR__ . '/../database/db.php';
require_once __DIR__ . '/rbac.php';

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

// Offline / no avatar on record -> the header falls back to the default icon.
$avatarSrc = $user['avatar_url'] ?: '../assets/icons/umak-icon.svg';

// The current page's slug, used by sidebar.php to highlight the active link.
// Every dashboard/*.php page should set $currentPage before including this
// file's sibling includes, or default it here.
$currentPage = $currentPage ?? 'dashboard';
