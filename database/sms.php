<?php
declare(strict_types=1);

function retrieva_sms_settings(): array {
    $settings = ['url' => '', 'key' => '', 'sender' => 'Retrieva'];
    $file = __DIR__ . '/sms_config.php';
    if (is_file($file)) {
        $loaded = require $file;
        if (is_array($loaded)) {
            $settings['url'] = trim((string) ($loaded['url'] ?? ''));
            $settings['key'] = trim((string) ($loaded['key'] ?? ''));
            $sender = trim((string) ($loaded['sender'] ?? ''));
            if ($sender !== '') {
                $settings['sender'] = $sender;
            }
        }
    }
    return $settings;
}

function retrieva_sms_ready(): bool {
    $settings = retrieva_sms_settings();
    return $settings['url'] !== '' && $settings['key'] !== '';
}

function retrieva_phone(string $raw): string {
    $digits = preg_replace('/\D+/', '', $raw) ?? '';
    if (preg_match('/^09\d{9}$/', $digits) === 1) {
        return '+63' . substr($digits, 1);
    }
    if (preg_match('/^639\d{9}$/', $digits) === 1) {
        return '+' . $digits;
    }
    throw new InvalidArgumentException('Enter a Philippine mobile number, such as 09XXXXXXXXX.');
}

function retrieva_send_sms(string $phone, string $message): bool {
    $settings = retrieva_sms_settings();
    if ($settings['url'] === '' || $settings['key'] === '' || $phone === '' || $message === '') {
        return false;
    }
    $body = http_build_query([
        'apikey' => $settings['key'],
        'number' => ltrim($phone, '+'),
        'message' => $message,
        'sendername' => $settings['sender'],
    ]);
    $context = stream_context_create([
        'http' => [
            'method' => 'POST',
            'header' => "Content-Type: application/x-www-form-urlencoded\r\n",
            'content' => $body,
            'timeout' => 8,
            'ignore_errors' => true,
        ],
    ]);
    $result = @file_get_contents($settings['url'], false, $context);
    if (!is_string($result) || $result === '') {
        return false;
    }
    $decoded = json_decode($result, true);
    if (is_array($decoded) && isset($decoded['error'])) {
        return false;
    }
    return true;
}

function retrieva_sms_user(int $userId, string $message): void {
    $stmt = get_db()->prepare('SELECT phone, phone_verified, notify_sms FROM users WHERE id = ?');
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    if (!$user || (int) $user['notify_sms'] !== 1 || (int) $user['phone_verified'] !== 1) {
        return;
    }
    $phone = (string) ($user['phone'] ?? '');
    if ($phone === '') {
        return;
    }
    retrieva_send_sms($phone, $message);
}
