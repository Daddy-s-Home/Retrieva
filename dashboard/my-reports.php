<?php
declare(strict_types=1);
$currentPage = 'my-reports';
require_once __DIR__ . '/_bootstrap.php';
require_once __DIR__ . '/../database/notify_helper.php';
require_role_page(['student']);

$db = get_db();
$error = null;
$success = null;

function my_report_status_pill(string $status): string {
    $map = [
        'searching' => ['pill--amber', 'Searching'],
        'matched'   => ['pill--blue', 'Matched'],
        'resolved'  => ['pill--green', 'Resolved'],
    ];
    [$class, $label] = $map[$status] ?? ['pill--gray', ucfirst($status)];
    return '<span class="pill ' . $class . '">' . h($label) . '</span>';
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf($_POST['csrf_token'] ?? null)) {
        $error = 'Your session expired. Please try again.';
    } else {
        $action = (string) ($_POST['action'] ?? '');
        $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT);
        try {
            if (!$id) {
                throw new InvalidArgumentException('Invalid report.');
            }
            if ($action === 'update_status') {
                $status = (string) ($_POST['new_status'] ?? '');
                if ($status !== 'resolved') {
                    throw new InvalidArgumentException('You may only mark your own report resolved.');
                }
                $stmt = $db->prepare('UPDATE lost_items SET status = ? WHERE id = ? AND reported_by = ?');
                $stmt->execute([$status, $id, $user['id']]);
                if ($stmt->rowCount() !== 1) {
                    throw new RuntimeException('Report was not found or already resolved.');
                }
                log_audit((int) $user['id'], 'lost_item_status_changed', "item={$id} status=resolved");
                broadcast_event('private-staff', 'item:updated', ['entity' => 'lost_item', 'id' => (int) $id, 'status' => 'resolved']);
                broadcast_event('private-updates', 'item:updated', ['entity' => 'lost_item', 'id' => (int) $id, 'status' => 'resolved']);
                $success = 'Report marked as resolved.';
            } elseif ($action === 'delete') {
                $stmt = $db->prepare("DELETE FROM lost_items WHERE id = ? AND reported_by = ? AND status = 'searching'");
                $stmt->execute([$id, $user['id']]);
                if ($stmt->rowCount() !== 1) {
                    throw new RuntimeException('Report was not found or cannot be deleted.');
                }
                log_audit((int) $user['id'], 'lost_item_deleted', "item={$id}");
                broadcast_event('private-staff', 'item:updated', ['entity' => 'lost_item', 'id' => (int) $id, 'status' => 'deleted']);
                $success = 'Lost item report removed.';
            }
        } catch (InvalidArgumentException | RuntimeException $e) {
            $error = $e->getMessage();
        } catch (Throwable $e) {
            $error = 'Could not update the report. Please try again.';
        }
    }
}

$stmt = $db->prepare('SELECT * FROM lost_items WHERE reported_by = ? ORDER BY created_at DESC');
$stmt->execute([$user['id']]);
$items = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Reports — Retrieva</title>
  <link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
  <link rel="stylesheet" href="../assets/theme.css">
  <link rel="stylesheet" href="styles.css">
</head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?>
<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>
  <main class="page-content">
    <div class="page-header">
      <h1>My Reports</h1>
      <p>Track and manage the lost item reports you have submitted.</p>
    </div>

    <?php if ($error): ?><div class="alert alert-error"><?= h($error) ?></div><?php endif; ?>
    <?php if ($success): ?><div class="alert alert-success"><?= h($success) ?></div><?php endif; ?>

    <div class="section-title">
      <span>Submitted Lost Reports</span>
      <a href="lost-items.php" class="btn btn-sm btn-primary">+ Report a Lost Item</a>
    </div>

    <div class="card">
      <div class="data-table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>Item</th>
              <th>Category</th>
              <th>Last Seen</th>
              <th>Date Lost</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <?php if (!$items): ?>
              <tr class="empty-row">
                <td colspan="6">
                  <div style="font-size: 1.75rem; margin-bottom: 0.4rem;">📭</div>
                  You haven't submitted any lost item reports yet.
                </td>
              </tr>
            <?php endif; ?>
            <?php foreach ($items as $item): ?>
              <tr>
                <td>
                  <strong><?= h($item['item_name']) ?></strong>
                  <?php if ($item['description']): ?>
                    <div><small><?= h($item['description']) ?></small></div>
                  <?php endif; ?>
                </td>
                <td>
                  <?= h($item['category']) ?>
                  <?php if ($item['category'] === 'Others' && !empty($item['other_category'])): ?>
                    <div><small><?= h($item['other_category']) ?></small></div>
                  <?php endif; ?>
                </td>
                <td><?= h($item['last_seen_location'] ?: '—') ?></td>
                <td style="white-space: nowrap;"><?= h(date('M j, Y', strtotime($item['date_lost']))) ?></td>
                <td><?= my_report_status_pill($item['status']) ?></td>
                <td>
                  <div class="actions-cell">
                    <?php if ($item['status'] !== 'resolved'): ?>
                      <form method="post">
                        <?= csrf_field() ?>
                        <input type="hidden" name="action" value="update_status">
                        <input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>">
                        <input type="hidden" name="new_status" value="resolved">
                        <button class="btn btn-sm btn-success">Mark Resolved</button>
                      </form>
                    <?php endif; ?>
                    <?php if ($item['status'] === 'searching'): ?>
                      <form method="post" data-confirm="Are you sure you want to delete this lost item report? This cannot be undone." data-confirm-title="Delete Report?" data-confirm-btn="Delete Report">
                        <?= csrf_field() ?>
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>">
                        <button class="btn btn-sm btn-danger">Delete</button>
                      </form>
                    <?php endif; ?>
                  </div>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script src="dashboard.js"></script>
</body>
</html>
