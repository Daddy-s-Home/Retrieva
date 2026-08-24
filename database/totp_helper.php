<?php
declare(strict_types=1);

/**
 * Minimal RFC 6238 TOTP implementation — no Composer dependency needed.
 * Retrieva uses this both for login 2FA and the forgot-password flow.
 * Codes are 6 digits, 30-second step, delivered by email (or shown
 * on-screen in dev mode — see EMAIL integration note in README).
 */

function totp_base32_decode(string $b32): string {
    $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    $b32 = strtoupper(preg_replace('/[^A-Z2-7]/', '', $b32));
    $bits = '';
    foreach (str_split($b32) as $char) {
        $bits .= str_pad(decbin((int)strpos($alphabet, $char)), 5, '0', STR_PAD_LEFT);
    }
    $bytes = '';
    foreach (str_split($bits, 8) as $byte) {
        if (strlen($byte) === 8) {
            $bytes .= chr((int)bindec($byte));
        }
    }
    return $bytes;
}

function totp_generate_secret(int $length = 16): string {
    $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    $secret = '';
    for ($i = 0; $i < $length; $i++) {
        $secret .= $alphabet[random_int(0, strlen($alphabet) - 1)];
    }
    return $secret;
}

function totp_code(string $secret, ?int $timestamp = null, int $step = 30, int $digits = 6): string {
    $timestamp = $timestamp ?? time();
    $counter = intdiv($timestamp, $step);
    $binaryCounter = pack('N*', 0) . pack('N*', $counter); // 8-byte big-endian counter
    $key = totp_base32_decode($secret);
    $hash = hash_hmac('sha1', $binaryCounter, $key, true);
    $offset = ord($hash[19]) & 0x0F;
    $truncated = ((ord($hash[$offset]) & 0x7F) << 24)
        | ((ord($hash[$offset + 1]) & 0xFF) << 16)
        | ((ord($hash[$offset + 2]) & 0xFF) << 8)
        | (ord($hash[$offset + 3]) & 0xFF);
    return str_pad((string)($truncated % (10 ** $digits)), $digits, '0', STR_PAD_LEFT);
}

/** Allows the previous/current/next 30s window to tolerate clock drift. */
function totp_verify(string $secret, string $code, int $step = 30, int $window = 1): bool {
    $now = time();
    for ($i = -$window; $i <= $window; $i++) {
        if (hash_equals(totp_code($secret, $now + ($i * $step), $step), $code)) {
            return true;
        }
    }
    return false;
}
