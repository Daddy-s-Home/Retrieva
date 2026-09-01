<?php
declare(strict_types=1);
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/oauth_config.php';

start_session();

$provider = get_google_provider();

// Force Google to prompt for account selection and credentials every time
$authUrl = $provider->getAuthorizationUrl([
    'scope'   => ['openid', 'email', 'profile'],
    'prompt'  => 'select_account consent',
    'max_age' => 0,
]);

// CSRF protection — verified against the same session in the callback.
$_SESSION['oauth2state'] = $provider->getState();

header('Location: ' . $authUrl);
exit;