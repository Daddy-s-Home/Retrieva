<?php
declare(strict_types=1);

function retrieva_pickup_location(array $input): string {
    $location = trim((string) ($input['pickup_location'] ?? ''));
    if (
        $location === ''
        || preg_match('/\A.{1,255}\z/us', $location) !== 1
        || preg_match('/[\x00-\x1F\x7F]/', $location) === 1
    ) {
        throw new InvalidArgumentException('Enter the current pickup location using 1-255 characters.');
    }

    return $location;
}

function retrieva_claim_approved_message(string $location): string {
    return 'Your claim was approved! Your pickup QR code is ready in Claims. Pickup location: ' . $location;
}
