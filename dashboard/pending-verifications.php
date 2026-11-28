<?php
declare(strict_types=1);
$currentPage = 'pending-verifications';
require_once __DIR__ . '/_bootstrap.php';
require_once __DIR__ . '/../database/notify_helper.php';
require_once __DIR__ . '/../database/pickup_helper.php';
require_role_page(['admin', 'security']);
$db = get_db(); $error = null; $success = null;
function pending_pill(string $status): string { $map = ['pending'=>['pill--amber','Pending'],'manual_review'=>['pill--blue','Manual Review']]; [$class,$label] = $map[$status] ?? ['pill--gray',ucfirst($status)]; return '<span class="pill '.$class.'">'.h($label).'</span>'; }
function pending_answer(?string $json): string { $values = json_decode((string) $json, true); return is_array($values) && isset($values[0]) ? (string) $values[0] : '—'; }
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf($_POST['csrf_token'] ?? null)) $error = 'Your session expired. Please try again.';
    else {
        $action = (string) ($_POST['action'] ?? ''); $claimId = filter_var($_POST['claim_id'] ?? null, FILTER_VALIDATE_INT);
        if (!$claimId || !in_array($action, ['approve','reject','manual_review'], true)) $error = 'Invalid review request.';
        else try {
            if ($action === 'manual_review') {
                $stmt = $db->prepare("UPDATE claims SET status = 'manual_review' WHERE id = ? AND status = 'pending'"); $stmt->execute([$claimId]); if ($stmt->rowCount() !== 1) throw new RuntimeException('Claim is no longer pending.'); log_audit((int) $user['id'], 'claim_manual_review', "claim={$claimId}"); $cStmt = $db->prepare('SELECT claimant_id FROM claims WHERE id = ?'); $cStmt->execute([$claimId]); if ($cRow = $cStmt->fetch()) { notify_users([(int) $cRow['claimant_id']], 'claim', 'Claim Under Manual Review', 'Your claim has been flagged for manual review by security.', 'claim', (int) $claimId, 'warning'); broadcast_event('private-user-' . (int) $cRow['claimant_id'], 'claim:updated', ['claim_id' => (int) $claimId, 'status' => 'manual_review']); } broadcast_event('private-staff', 'claim:updated', ['claim_id' => (int) $claimId, 'status' => 'manual_review']); $success = 'Claim flagged for manual review.';
            } else {
                $pickupLocation = $action === 'approve' ? retrieva_pickup_location($_POST) : '';
                $db->beginTransaction();
                $stmt = $db->prepare("SELECT found_item_id, claimant_id FROM claims WHERE id = ? AND status IN ('pending','manual_review') FOR UPDATE");
                $stmt->execute([$claimId]);
                $claim = $stmt->fetch();
                if (!$claim) throw new RuntimeException('This claim has already been reviewed.');
                $newStatus = $action === 'approve' ? 'approved' : 'rejected';
                $itemStatus = $action === 'approve' ? 'claimed' : 'unclaimed';
                $stmt = $db->prepare("UPDATE claims SET status = ?, reviewed_by = ?, reviewed_at = NOW() WHERE id = ? AND status IN ('pending','manual_review')");
                $stmt->execute([$newStatus, $user['id'], $claimId]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Review could not be applied.');
                $stmt = $db->prepare('UPDATE found_items SET status = ? WHERE id = ?');
                $stmt->execute([$itemStatus, $claim['found_item_id']]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Related item could not be updated.');
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
            }
        } catch (Throwable $e) { if ($db->inTransaction()) $db->rollBack(); $error = $e instanceof InvalidArgumentException || $e instanceof RuntimeException ? $e->getMessage() : 'The review could not be processed. Please try again.'; }
    }
}
$claims = $db->query("SELECT c.*, f.item_name, f.category, f.location_found, u.full_name AS claimant_name FROM claims c JOIN found_items f ON f.id = c.found_item_id JOIN users u ON u.id = c.claimant_id WHERE c.status IN ('pending','manual_review') ORDER BY FIELD(c.status, 'manual_review', 'pending'), c.created_at ASC")->fetchAll();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pending Verifications — Retrieva</title>
  <link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
  <link rel="stylesheet" href="../assets/theme.css">
  <link rel="stylesheet" href="styles.css">
  <link rel="stylesheet" href="pickup-location-dialog.css">
</head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?>
<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>
  <main class="page-content">
    <div class="page-header"><h1>Pending Verifications</h1><p>Review claims waiting for a decision. Flagged claims appear first.</p></div>
    <?php if ($error): ?><div class="alert alert-error"><?= h($error) ?></div><?php endif; ?>
    <?php if ($success): ?><div class="alert alert-success"><?= h($success) ?></div><?php endif; ?>
    <div class="card"><div class="data-table-wrap"><table class="data-table">
      <thead><tr><th>Item</th><th>Claimant</th><th>Answer</th><th>Filed</th><th>Status</th><th>Actions</th></tr></thead>
      <tbody>
      <?php if (!$claims): ?><tr class="empty-row"><td colspan="6">Nothing pending. All caught up.</td></tr><?php endif; ?>
      <?php foreach ($claims as $claim): ?>
        <tr>
          <td><strong><?= h($claim['item_name']) ?></strong><br><small><?= h($claim['category']) ?> · <?= h($claim['location_found']) ?></small></td>
          <td><?= h($claim['claimant_name']) ?></td>
          <td><?= h(pending_answer($claim['claimant_answers'])) ?></td>
          <td><?= h(date('M j, Y', strtotime($claim['created_at']))) ?></td>
          <td><?= pending_pill($claim['status']) ?></td>
          <td><div class="actions-cell">
            <button class="btn btn-sm btn-success" type="button" data-open-pickup-location data-claim-id="<?= (int) $claim['id'] ?>" data-approval-endpoint="pending-verifications.php" data-approval-action="approve">Approve</button>
            <form method="post"><?= csrf_field() ?><input type="hidden" name="action" value="reject"><input type="hidden" name="claim_id" value="<?= (int) $claim['id'] ?>"><button class="btn btn-sm btn-danger">Reject</button></form>
            <?php if ($claim['status'] === 'pending'): ?><form method="post"><?= csrf_field() ?><input type="hidden" name="action" value="manual_review"><input type="hidden" name="claim_id" value="<?= (int) $claim['id'] ?>"><button class="btn btn-sm btn-gold">Flag</button></form><?php endif; ?>
          </div></td>
        </tr>
      <?php endforeach; ?>
      </tbody>
    </table></div></div>
  </main>
</div>
<?php include __DIR__ . '/components/pickup-location-dialog.php'; ?>
<script src="dashboard.js"></script>
<script src="pickup-location-dialog.js"></script>
</body>
</html>
