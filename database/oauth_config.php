<?php
declare(strict_types=1);

/**
 * Google OAuth client config (league/oauth2-google).
 *
 * Create credentials at https://console.cloud.google.com/apis/credentials
 * — an "OAuth 2.0 Client ID" of type "Web application" — and set the
 * authorized redirect URI to match GOOGLE_REDIRECT_URI below exactly.
 *
 * Fill these in before testing Google sign-in; local/password login and
 * TOTP already work without them.
 */

const GOOGLE_CLIENT_ID     = '465366791629-5k5hhgt1fj64ph5ou78278kj0ogd9340.apps.googleusercontent.com';
const GOOGLE_CLIENT_SECRET = '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';
const GOOGLE_REDIRECT_URI  = 'http://localhost/Retrieva/database/google_oauth_callback.php';

// Only accounts on this domain may sign in / sign up.
const ALLOWED_EMAIL_DOMAIN = 'umak.edu.ph';

function get_google_provider(): \League\OAuth2\Client\Provider\Google {
    return new \League\OAuth2\Client\Provider\Google([
        'clientId'     => GOOGLE_CLIENT_ID,
        'clientSecret' => GOOGLE_CLIENT_SECRET,
        'redirectUri'  => GOOGLE_REDIRECT_URI,
        // Restricts Google's account chooser to the campus Workspace domain.
        'hostedDomain' => ALLOWED_EMAIL_DOMAIN,
    ]);
}
