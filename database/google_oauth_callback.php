<?php
declare(strict_types=1);
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/oauth_config.php';
require_once __DIR__ . '/notify_helper.php';

start_session();

$provider = get_google_provider();

// -- CSRF / state check --
$state = $_GET['state'] ?? null;
if (!$state || !isset($_SESSION['oauth2state']) || $state !== $_SESSION['oauth2state']) {
    unset($_SESSION['oauth2state']);
    header('Location: ../auth/login.php?error=oauth_state');
    exit;
}
unset($_SESSION['oauth2state']);

if (!isset($_GET['code'])) {
    header('Location: ../auth/login.php?error=oauth_denied');
    exit;
}

try {
    // -- exchange the authorization code for an access token --
    $token = $provider->getAccessToken('authorization_code', ['code' => $_GET['code']]);
    /** @var \League\OAuth2\Client\Provider\GoogleUser $googleUser */
    $googleUser = $provider->getResourceOwner($token);
} catch (\Throwable $e) {
    header('Location: ../auth/login.php?error=oauth_failed');
    exit;
}

$email = strtolower($googleUser->getEmail());

// Hard block: only official campus accounts may sign in, regardless of
// what the 'hostedDomain' hint on the consent screen already filtered.
if (!str_ends_with($email, '@' . ALLOWED_EMAIL_DOMAIN)) {
    header('Location: ../auth/login.php?error=domain_not_allowed');
    exit;
}

$db   = get_db();
$stmt = $db->prepare('SELECT * FROM users WHERE email = ? OR google_id = ?');
$stmt->execute([$email, $googleUser->getId()]);
$user = $stmt->fetch();

if (!$user) {
    // No matching record -> treat as a new sign-up.
    $insert = $db->prepare(
        'INSERT INTO users (email, full_name, role, auth_provider, google_id, avatar_url, password_is_set)
         VALUES (?, ?, "student", "google", ?, ?, 0)'
    );
    $insert->execute([
        $email,
        $googleUser->getName() ?: $email,
        $googleUser->getId(),
        $googleUser->getAvatar(),
    ]);
    $userId = (int)$db->lastInsertId();
    $role   = 'student';
    log_audit($userId, 'google_signup', $email);
} else {
    if ($user['status'] === 'blocked') {
        header('Location: ../auth/login.php?error=blocked');
        exit;
    }
    // Keep Google identity fields fresh (avatar can change over time).
    $db->prepare('UPDATE users SET google_id = ?, avatar_url = ? WHERE id = ?')
       ->execute([$googleUser->getId(), $googleUser->getAvatar() ?: $user['avatar_url'], $user['id']]);
    $userId = (int)$user['id'];
    $role   = $user['role'];
    log_audit($userId, 'google_login', $email);
}

// Google sign-in skips TOTP entirely, as specified.
$db->prepare('UPDATE users SET email_verified = 1, last_login_at = NOW() WHERE id = ?')->execute([$userId]);
$_SESSION['user_id'] = $userId;
$_SESSION['role']    = $role;
$_SESSION['name']    = $googleUser->getName() ?: $email;

notify_roles(['admin'], 'system', 'User Signed In', "{$_SESSION['name']} ({$role}) signed in via Google.", 'user', $userId, 'info');

header('Location: ../dashboard/index.php');
exit;
