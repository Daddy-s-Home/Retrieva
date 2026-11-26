<?php
declare(strict_types=1);

require_once __DIR__ . '/recaptcha_config.php';

/**
 * Verifies a Google reCAPTCHA v2 response token against Google's siteverify API.
 */
function verify_recaptcha_token(?string $token): bool {
    $token = trim((string) $token);
    if ($token === '' || !defined('RECAPTCHA_SECRET_KEY') || RECAPTCHA_SECRET_KEY === '') {
        return false;
    }

    $postFields = http_build_query([
        'secret'   => RECAPTCHA_SECRET_KEY,
        'response' => $token,
        'remoteip' => $_SERVER['REMOTE_ADDR'] ?? '',
    ]);

    $ch = curl_init('https://www.google.com/recaptcha/api/siteverify');
    if ($ch === false) {
        return false;
    }

    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $postFields,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 10,
        CURLOPT_SSL_VERIFYPEER => false, // XAMPP local CA compatibility
    ]);

    $raw = curl_exec($ch);
    curl_close($ch);

    if (!is_string($raw) || $raw === '') {
        return false;
    }

    $decoded = json_decode($raw, true);
    return is_array($decoded) && !empty($decoded['success']);
}
