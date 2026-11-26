<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/notify_helper.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_out(['success' => false, 'message' => 'Method not allowed.'], 405);
}

$session = require_role(['admin', 'security']);

$raw = file_get_contents('php://input');
$body = json_decode((string) $raw, true);
if (!is_array($body)) {
    $body = $_POST;
}

$csrf = isset($body['csrf_token']) ? (string) $body['csrf_token'] : ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? null);
if (!verify_csrf($csrf)) {
    json_out(['success' => false, 'message' => 'Your session expired. Refresh the page and try again.'], 403);
}

$qrToken = strtolower(trim((string) ($body['qr_token'] ?? '')));
if (!preg_match('/^[a-f0-9]{64}$/', $qrToken)) {
    json_out(['success' => false, 'message' => 'Invalid QR token format.'], 422);
}

$db = get_db();

try {
    $db->beginTransaction();

    $stmt = $db->prepare(
        'SELECT p.id, p.claim_id, p.scanned_at, c.claimant_id, c.status AS claim_status,
                f.item_name, f.category, f.location_found,
                u.full_name AS claimant_name, u.student_id
         FROM pickups p
         JOIN claims c ON c.id = p.claim_id
         JOIN found_items f ON f.id = c.found_item_id
         JOIN users u ON u.id = c.claimant_id
         WHERE p.qr_token = ?
         FOR UPDATE'
    );
    $stmt->execute([$qrToken]);
    $pickup = $stmt->fetch();

    if (!$pickup) {
        $db->rollBack();
        json_out(['success' => false, 'message' => 'QR code not recognized.'], 404);
    }

    if ($pickup['claim_status'] !== 'approved') {
        $db->rollBack();
        json_out(['success' => false, 'message' => 'Associated claim is not approved for pickup.'], 409);
    }

    if ($pickup['scanned_at'] !== null) {
        $db->rollBack();
        $when = date('M j, Y g:i A', strtotime((string) $pickup['scanned_at']));
        json_out([
            'success' => false,
            'message' => "This QR code was already used on {$when}.",
        ], 409);
    }

    $update = $db->prepare('UPDATE pickups SET scanned_at = NOW(), verified_by = ? WHERE id = ? AND scanned_at IS NULL');
    $update->execute([(int) $session['user_id'], (int) $pickup['id']]);
    if ($update->rowCount() !== 1) {
        $db->rollBack();
        json_out(['success' => false, 'message' => 'Could not complete pickup verification.'], 409);
    }

    $db->commit();
    log_audit((int) $session['user_id'], 'pickup_verified', "pickup={$pickup['id']} claim={$pickup['claim_id']}");
    notify_users(
        [(int) $pickup['claimant_id']],
        'claim',
        'Item Picked Up',
        "Your pickup for \"{$pickup['item_name']}\" has been verified.",
        'pickup',
        (int) $pickup['id'],
        'success'
    );
    broadcast_event('private-staff', 'pickup:verified', ['pickup_id' => (int) $pickup['id'], 'claim_id' => (int) $pickup['claim_id']]);
    broadcast_event('private-user-' . (int) $pickup['claimant_id'], 'pickup:verified', ['pickup_id' => (int) $pickup['id'], 'claim_id' => (int) $pickup['claim_id']]);
    broadcast_event('private-updates', 'pickup:verified', ['pickup_id' => (int) $pickup['id'], 'claim_id' => (int) $pickup['claim_id']]);

    json_out([
        'success' => true,
        'message' => 'Pickup verified successfully.',
        'pickup' => [
            'id' => (int) $pickup['id'],
            'claim_id' => (int) $pickup['claim_id'],
            'item_name' => $pickup['item_name'],
            'category' => $pickup['category'],
            'location_found' => $pickup['location_found'],
            'claimant_name' => $pickup['claimant_name'],
            'student_id' => $pickup['student_id'],
            'verified_at' => date('M j, Y g:i A'),
        ],
    ]);
} catch (Throwable $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }
    json_out(['success' => false, 'message' => 'Server error while verifying pickup QR.'], 500);
}
