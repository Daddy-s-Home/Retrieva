<?php
declare(strict_types=1);
$currentPage = 'claims';
require_once __DIR__ . '/_bootstrap.php';
require_once __DIR__ . '/../database/notify_helper.php';
require_once __DIR__ . '/../database/pickup_helper.php';
require_once __DIR__ . '/../database/client/lib.php';
require_once __DIR__ . '/components/item-photo-gallery.php';
$db = get_db(); $isAdminSide = role_is_admin_side($role); $error = null; $success = null;
function claim_pill(string $status): string { $map = ['pending'=>['pill--amber','Pending'],'manual_review'=>['pill--blue','Manual Review'],'approved'=>['pill--green','Approved'],'rejected'=>['pill--red','Rejected']]; [$class,$label] = $map[$status] ?? ['pill--gray', ucfirst($status)]; return '<span class="pill '.$class.'">'.h($label).'</span>'; }
function claim_answer(?string $json): string { $values = json_decode((string) $json, true); return is_array($values) && isset($values[0]) ? (string) $values[0] : '—'; }
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf($_POST['csrf_token'] ?? null)) $error = 'Your session expired. Please try again.';
    else {
        $action = (string) ($_POST['action'] ?? ''); $claimId = filter_var($_POST['claim_id'] ?? null, FILTER_VALIDATE_INT);
        try {
            if ($action === 'file_claim' && !$isAdminSide) {
                $itemId = filter_var($_POST['found_item_id'] ?? null, FILTER_VALIDATE_INT); $answer = trim((string) ($_POST['answer'] ?? ''));
                if (!$itemId || $answer === '' || strlen($answer) > 1000) throw new InvalidArgumentException('Enter a valid identifying detail.');
                $db->beginTransaction();
                $existing = $db->prepare("SELECT COUNT(*) FROM claims WHERE found_item_id = ? AND status IN ('pending', 'manual_review', 'approved')"); $existing->execute([$itemId]);
                if ((int) $existing->fetchColumn() > 0) throw new RuntimeException('That item already has an active claim.');
                $lock = $db->prepare("UPDATE found_items SET status = 'pending_verification' WHERE id = ? AND status = 'unclaimed'"); $lock->execute([$itemId]);
                if ($lock->rowCount() !== 1) throw new RuntimeException('That item is no longer available to claim.');
                $stmt = $db->prepare("INSERT INTO claims (found_item_id, claimant_id, challenge_questions, claimant_answers, status) VALUES (?, ?, ?, ?, 'pending')"); $stmt->execute([$itemId, $user['id'], json_encode(['Describe an identifying detail about this item.']), json_encode([$answer])]); $newClaimId = (int) $db->lastInsertId(); $db->commit(); log_audit((int) $user['id'], 'claim_filed', "found_item={$itemId}"); notify_roles(['admin', 'security'], 'claim', 'New Claim Pending Verification', "{$user['full_name']} filed a claim that requires verification.", 'claim', $newClaimId, 'warning'); broadcast_event('private-staff', 'claim:updated', ['claim_id' => $newClaimId, 'status' => 'pending']); broadcast_event('private-updates', 'claim:updated', ['claim_id' => $newClaimId, 'status' => 'pending']); $success = 'Your claim was submitted for review.';
            } elseif (in_array($action, ['approve', 'reject'], true) && $isAdminSide && $claimId) {
                $pickupLocation = $action === 'approve' ? retrieva_pickup_location($_POST) : '';
                $db->beginTransaction();
                $stmt = $db->prepare("SELECT found_item_id, claimant_id FROM claims WHERE id = ? AND status IN ('pending', 'manual_review') FOR UPDATE"); $stmt->execute([$claimId]); $claim = $stmt->fetch();
                if (!$claim) throw new RuntimeException('This claim has already been reviewed.');
                $newStatus = $action === 'approve' ? 'approved' : 'rejected'; $itemStatus = $action === 'approve' ? 'claimed' : 'unclaimed';
                $stmt = $db->prepare("UPDATE claims SET status = ?, reviewed_by = ?, reviewed_at = NOW() WHERE id = ? AND status IN ('pending', 'manual_review')"); $stmt->execute([$newStatus, $user['id'], $claimId]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Claim review could not be applied.');
                $stmt = $db->prepare('UPDATE found_items SET status = ? WHERE id = ?'); $stmt->execute([$itemStatus, $claim['found_item_id']]); if ($stmt->rowCount() !== 1) throw new RuntimeException('Related found item could not be updated.');
                if ($action === 'approve') {
                    $qrToken = bin2hex(random_bytes(32));
                    $pickupStmt = $db->prepare('SELECT id FROM pickups WHERE claim_id = ? FOR UPDATE');
                    $pickupStmt->execute([$claimId]);
                    if ($pickupStmt->fetch()) {
                        $pickupStmt = $db->prepare('UPDATE pickups SET pickup_location = ? WHERE claim_id = ?');
                        $pickupStmt->execute([$pickupLocation, $claimId]);
                    } else {
                        $pickupStmt = $db->prepare("INSERT INTO pickups (claim_id, pickup_location, qr_token, status) VALUES (?, ?, ?, 'pending')");
                        $pickupStmt->execute([$claimId, $pickupLocation, $qrToken]);
                    }
                }
                $db->commit();
                log_audit((int) $user['id'], 'claim_' . $newStatus, "claim={$claimId}");
                $notificationBody = $action === 'approve'
                    ? retrieva_claim_approved_message($pickupLocation)
                    : 'Your claim was rejected after verification review.';
                notify_users([(int) $claim['claimant_id']], 'claim', $action === 'approve' ? 'Claim Approved' : 'Claim Rejected', $notificationBody, 'claim', (int) $claimId, $action === 'approve' ? 'success' : 'danger');
                broadcast_event('private-staff', 'claim:updated', ['claim_id' => (int) $claimId, 'status' => $newStatus]);
                broadcast_event('private-user-' . (int) $claim['claimant_id'], 'claim:updated', ['claim_id' => (int) $claimId, 'status' => $newStatus]);
                broadcast_event('private-updates', 'item:updated', ['entity' => 'found_item', 'status' => $itemStatus]);
                $success = $action === 'approve' ? 'Claim approved.' : 'Claim rejected.';
            } elseif ($action === 'manual_review' && $isAdminSide && $claimId) {
                $stmt = $db->prepare("UPDATE claims SET status = 'manual_review' WHERE id = ? AND status = 'pending'"); $stmt->execute([$claimId]); if ($stmt->rowCount() !== 1) throw new RuntimeException('Claim is no longer pending.'); log_audit((int) $user['id'], 'claim_manual_review', "claim={$claimId}"); $cStmt = $db->prepare('SELECT claimant_id FROM claims WHERE id = ?'); $cStmt->execute([$claimId]); if ($cRow = $cStmt->fetch()) { notify_users([(int) $cRow['claimant_id']], 'claim', 'Claim Under Manual Review', 'Your claim has been flagged for manual review by security.', 'claim', (int) $claimId, 'warning'); broadcast_event('private-user-' . (int) $cRow['claimant_id'], 'claim:updated', ['claim_id' => (int) $claimId, 'status' => 'manual_review']); } broadcast_event('private-staff', 'claim:updated', ['claim_id' => (int) $claimId, 'status' => 'manual_review']); $success = 'Claim flagged for manual review.';
            }
        } catch (InvalidArgumentException | RuntimeException $e) { if ($db->inTransaction()) $db->rollBack(); $error = $e->getMessage(); } catch (Throwable $e) { if ($db->inTransaction()) $db->rollBack(); $error = 'The claim could not be processed. Please try again.'; }
    }
}
if ($isAdminSide) {
    $claims = $db->query('SELECT c.*, f.item_name, f.category, f.location_found, u.full_name AS claimant_name FROM claims c JOIN found_items f ON f.id = c.found_item_id JOIN users u ON u.id = c.claimant_id ORDER BY c.created_at DESC')->fetchAll();
} else {
    $browsable = $db->query("SELECT * FROM found_items WHERE status = 'unclaimed' ORDER BY created_at DESC")->fetchAll();
    $stmt = $db->prepare('SELECT c.*, f.item_name, f.category, f.location_found, f.photo_path, p.qr_token, p.pickup_location, p.scanned_at FROM claims c JOIN found_items f ON f.id = c.found_item_id LEFT JOIN pickups p ON p.claim_id = c.id WHERE c.claimant_id = ? ORDER BY c.created_at DESC');
    $stmt->execute([$user['id']]);
    $claims = $stmt->fetchAll();
    $browseCovers = [];
    foreach ($browsable as $item) {
        $browseCovers[(int) $item['id']] = (string) ($item['photo_path'] ?? '');
    }
    $browsePhotos = retrieva_photo_map('found', $browseCovers);
    $claimCovers = [];
    foreach ($claims as $claim) {
        $claimCovers[(int) $claim['found_item_id']] = (string) ($claim['photo_path'] ?? '');
    }
    $myClaimPhotos = retrieva_photo_map('found', $claimCovers);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Claims — Retrieva</title>
  <link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
  <link rel="stylesheet" href="../assets/theme.css">
  <link rel="stylesheet" href="styles.css">
  <link rel="stylesheet" href="item-photo-gallery.css">
  <link rel="stylesheet" href="pickup-location-dialog.css">
</head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?>
<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>
  <main class="page-content">
    <div class="page-header">
      <h1>Claims</h1>
      <p><?= $isAdminSide ? 'Review claims and verify ownership.' : 'Browse unclaimed items and file a claim if one is yours.' ?></p>
    </div>
    <?php if ($error): ?><div class="alert alert-error"><?= h($error) ?></div><?php endif; ?>
    <?php if ($success): ?><div class="alert alert-success"><?= h($success) ?></div><?php endif; ?>
    <div class="card"><div class="data-table-wrap"><table class="data-table">
      <thead><tr>
        <?php if ($isAdminSide): ?>
          <th>Item</th><th>Claimant</th><th>Answer</th><th>Submitted</th><th>Status</th><th>Actions</th>
        <?php else: ?>
          <th>Photo</th><th>Item</th><th>Category</th><th>Location</th><th>Date Found</th><th>Claim</th>
        <?php endif; ?>
      </tr></thead>
      <tbody>
      <?php if ($isAdminSide): ?>
        <?php if (!$claims): ?><tr class="empty-row"><td colspan="6">No claims filed yet.</td></tr><?php endif; ?>
        <?php foreach ($claims as $claim): ?>
          <tr>
            <td><strong><?= h($claim['item_name']) ?></strong><br><small><?= h($claim['category']) ?> · <?= h($claim['location_found']) ?></small></td>
            <td><?= h($claim['claimant_name']) ?></td>
            <td><?= h(claim_answer($claim['claimant_answers'])) ?></td>
            <td><?= h(date('M j, Y', strtotime($claim['created_at']))) ?></td>
            <td><?= claim_pill($claim['status']) ?></td>
            <td>
              <?php if (in_array($claim['status'], ['pending', 'manual_review'], true)): ?>
                <div class="actions-cell">
                  <button class="btn btn-sm btn-success" type="button" data-open-pickup-location data-claim-id="<?= (int) $claim['id'] ?>" data-approval-endpoint="claims.php" data-approval-action="approve">Approve</button>
                  <form method="post"><?= csrf_field() ?><input type="hidden" name="action" value="reject"><input type="hidden" name="claim_id" value="<?= (int) $claim['id'] ?>"><button class="btn btn-sm btn-danger">Reject</button></form>
                  <?php if ($claim['status'] === 'pending'): ?><form method="post"><?= csrf_field() ?><input type="hidden" name="action" value="manual_review"><input type="hidden" name="claim_id" value="<?= (int) $claim['id'] ?>"><button class="btn btn-sm btn-gold">Flag</button></form><?php endif; ?>
                </div>
              <?php endif; ?>
            </td>
          </tr>
        <?php endforeach; ?>
      <?php else: ?>
        <?php if (!$browsable): ?><tr class="empty-row"><td colspan="6">Nothing unclaimed right now.</td></tr><?php endif; ?>
        <?php foreach ($browsable as $item): ?>
          <tr>
            <td><?= dashboard_photo_preview($browsePhotos[(int) $item['id']] ?? [], (string) $item['item_name']) ?></td>
            <td><strong><?= h($item['item_name']) ?></strong></td>
            <td><?= h($item['category']) ?></td>
            <td><?= h($item['location_found']) ?></td>
            <td><?= h(date('M j, Y', strtotime($item['date_found']))) ?></td>
            <td><form method="post" class="claim-form"><?= csrf_field() ?><input type="hidden" name="action" value="file_claim"><input type="hidden" name="found_item_id" value="<?= (int) $item['id'] ?>"><input maxlength="1000" type="text" name="answer" placeholder="Identifying detail" required><button class="btn btn-sm btn-primary">Claim</button></form></td>
          </tr>
        <?php endforeach; ?>
      <?php endif; ?>
      </tbody>
    </table></div></div>
    <?php if (!$isAdminSide): ?>
      <div class="section-title">My Claims</div>
      <div class="card"><div class="data-table-wrap"><table class="data-table">
        <thead><tr><th>Photo</th><th>Item</th><th>Answer</th><th>Submitted</th><th>Status</th><th>Pickup QR</th></tr></thead>
        <tbody>
        <?php if (!$claims): ?><tr class="empty-row"><td colspan="6">You have not filed any claims.</td></tr><?php endif; ?>
        <?php foreach ($claims as $claim): ?>
          <tr>
            <td><?= dashboard_photo_preview($myClaimPhotos[(int) $claim['found_item_id']] ?? [], (string) $claim['item_name']) ?></td>
            <td><strong><?= h($claim['item_name']) ?></strong></td>
            <td><?= h(claim_answer($claim['claimant_answers'])) ?></td>
            <td><?= h(date('M j, Y', strtotime($claim['created_at']))) ?></td>
            <td><?= claim_pill($claim['status']) ?></td>
            <td>
              <?php if ($claim['status'] === 'approved' && !empty($claim['scanned_at'])): ?>
                <span class="pill pill--green">Picked Up</span>
              <?php elseif ($claim['status'] === 'approved' && !empty($claim['qr_token'])): ?>
                <button type="button" class="btn btn-sm btn-primary js-show-qr" data-token="<?= h($claim['qr_token']) ?>" data-item="<?= h($claim['item_name']) ?>" data-location="<?= h((string) ($claim['pickup_location'] ?? '')) ?>">View Pickup QR</button>
              <?php else: ?>—<?php endif; ?>
            </td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table></div></div>
    <?php endif; ?>
  </main>
</div>
<?php if (!$isAdminSide): ?>
<div class="modal-overlay" id="pickup-qr-modal" role="dialog" aria-modal="true" aria-labelledby="pickup-qr-title">
  <div class="modal-card qr-modal-card">
    <div class="modal-card__badge" aria-hidden="true">📱</div>
    <h2 id="pickup-qr-title">Pickup QR Code</h2>
    <p class="modal-subtitle" id="pickup-qr-item"></p>
    <div id="pickup-qr-canvas" class="qr-canvas-box" aria-label="Single-use pickup QR code"></div>
    <p class="pickup-location-label" id="pickup-qr-location"></p>
    <p class="qr-token-hint">Show this single-use QR code to Campus Security at the pickup location listed above.</p>
    <code id="pickup-qr-token-text" class="qr-token-code"></code>
    <div class="modal-actions modal-actions--end" style="margin-top:16px;">
      <button type="button" class="btn btn-ghost" id="pickup-qr-close">Close</button>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  const modal = document.getElementById('pickup-qr-modal');
  const canvas = document.getElementById('pickup-qr-canvas');
  const itemEl = document.getElementById('pickup-qr-item');
  const locationEl = document.getElementById('pickup-qr-location');
  const tokenEl = document.getElementById('pickup-qr-token-text');
  const closeBtn = document.getElementById('pickup-qr-close');

  document.querySelectorAll('.js-show-qr').forEach((btn) => {
    btn.addEventListener('click', () => {
      const token = btn.dataset.token || '';
      const item = btn.dataset.item || 'Approved Item';
      const location = btn.dataset.location || '';
      if (itemEl) itemEl.textContent = item;
      if (locationEl) {
        locationEl.textContent = location
          ? 'Pickup location: ' + location
          : 'Pickup location is not recorded. Contact Campus Security to confirm where to collect your item.';
      }
      if (tokenEl) tokenEl.textContent = token;
      if (canvas) {
        canvas.innerHTML = '';
        if (typeof QRCode !== 'undefined') {
          new QRCode(canvas, { text: token, width: 200, height: 200, colorDark: '#003276', colorLight: '#ffffff' });
        }
      }
      modal?.classList.add('show');
    });
  });

  closeBtn?.addEventListener('click', () => modal?.classList.remove('show'));
  modal?.addEventListener('click', (e) => {
    if (e.target === modal) modal.classList.remove('show');
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && modal?.classList.contains('show')) modal.classList.remove('show');
  });
});
</script>
<?php else: ?>
  <?php include __DIR__ . '/components/pickup-location-dialog.php'; ?>
<?php endif; ?>
<?= dashboard_photo_gallery_dialog() ?>
<script src="dashboard.js"></script>
<script src="item-photo-gallery.js"></script>
<script src="pickup-location-dialog.js"></script>
</body>
</html>
