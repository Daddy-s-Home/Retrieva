<?php
declare(strict_types=1);
$currentPage = 'found-items';
require_once __DIR__ . '/_bootstrap.php';
require_once __DIR__ . '/../database/notify_helper.php';
require_once __DIR__ . '/../database/client/lib.php';
require_once __DIR__ . '/components/photo-picker.php';
require_once __DIR__ . '/components/item-photo-gallery.php';
require_role_page(['admin', 'security']);

$db = get_db();
$categories = ITEM_CATEGORY_OPTIONS;
$statuses = ['unclaimed', 'pending_verification', 'claimed', 'disposed'];
$error = null;
$success = null;

function valid_date(string $value): bool {
    $date = DateTime::createFromFormat('Y-m-d', $value);
    return $date instanceof DateTime && $date->format('Y-m-d') === $value && $value <= date('Y-m-d');
}
function found_status_pill(string $status): string {
    $map = [
        'unclaimed' => ['pill--amber', 'Unclaimed'],
        'pending_verification' => ['pill--blue', 'Pending Verification'],
        'claimed' => ['pill--green', 'Claimed'],
        'disposed' => ['pill--gray', 'Disposed'],
    ];
    [$class, $label] = $map[$status] ?? ['pill--gray', ucfirst($status)];
    return '<span class="pill ' . $class . '">' . h($label) . '</span>';
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf($_POST['csrf_token'] ?? null)) {
        $error = 'Your session expired. Please try again.';
    } else {
        $action = (string) ($_POST['action'] ?? '');
        try {
            if ($action === 'create') {
                $name = trim((string) ($_POST['item_name'] ?? ''));
                $category = (string) ($_POST['category'] ?? '');
                $otherCategory = trim((string) ($_POST['other_category'] ?? ''));
                $location = trim((string) ($_POST['location_found'] ?? ''));
                $dateFound = (string) ($_POST['date_found'] ?? '');
                if ($name === '' || strlen($name) > 150 || $location === '' || strlen($location) > 150 || !in_array($category, $categories, true) || !valid_date($dateFound) || ($category === 'Others' && ($otherCategory === '' || strlen($otherCategory) > 150))) {
                    throw new InvalidArgumentException('Enter valid item, category, location, and date details.');
                }
                $stmt = $db->prepare('INSERT INTO found_items (logged_by, item_name, category, other_category, location_found, date_found) VALUES (?, ?, ?, ?, ?, ?)');
                $stmt->execute([$user['id'], $name, $category, $category === 'Others' ? $otherCategory : null, $location, $dateFound]);
                $newFoundId = (int) $db->lastInsertId();
                try {
                    retrieva_save_photos('found', $newFoundId, $_POST);
                } catch (Throwable $photoError) {
                    retrieva_delete_photos('found', $newFoundId);
                    $db->prepare('DELETE FROM found_items WHERE id = ? AND logged_by = ?')->execute([$newFoundId, $user['id']]);
                    throw $photoError;
                }
                log_audit((int) $user['id'], 'found_item_logged', $name);
                notify_roles(['admin', 'security', 'professor', 'student'], 'report', 'New Found Item Logged', "A {$category} item was turned in at {$location}.", 'found_item', $newFoundId, 'info');
                broadcast_event('private-updates', 'item:updated', ['entity' => 'found_item', 'id' => $newFoundId, 'status' => 'unclaimed']);
                broadcast_event('private-staff', 'item:updated', ['entity' => 'found_item', 'id' => $newFoundId, 'status' => 'unclaimed']);
                $success = 'Found item logged successfully.';
            } elseif ($action === 'update_status') {
                $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT);
                $status = (string) ($_POST['new_status'] ?? '');
                if (!$id || !in_array($status, $statuses, true)) throw new InvalidArgumentException('Invalid item status.');
                $stmt = $db->prepare('UPDATE found_items SET status = ? WHERE id = ?');
                $stmt->execute([$status, $id]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Item was not found or already had that status.');
                log_audit((int) $user['id'], 'found_item_status_changed', "item={$id} status={$status}");
                broadcast_event('private-updates', 'item:updated', ['entity' => 'found_item', 'id' => (int) $id, 'status' => $status]);
                broadcast_event('private-staff', 'item:updated', ['entity' => 'found_item', 'id' => (int) $id, 'status' => $status]);
                $success = 'Item status updated.';
            } elseif ($action === 'delete') {
                $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT);
                if (!$id) throw new InvalidArgumentException('Invalid item.');
                retrieva_delete_photos('found', (int) $id);
                $stmt = $db->prepare('DELETE FROM found_items WHERE id = ?');
                $stmt->execute([$id]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Item was not found.');
                log_audit((int) $user['id'], 'found_item_deleted', "item={$id}");
                broadcast_event('private-updates', 'item:updated', ['entity' => 'found_item', 'id' => (int) $id, 'status' => 'deleted']);
                broadcast_event('private-staff', 'item:updated', ['entity' => 'found_item', 'id' => (int) $id, 'status' => 'deleted']);
                $success = 'Found item removed.';
            }
        } catch (InvalidArgumentException | RuntimeException $e) {
            $error = $e->getMessage();
        } catch (Throwable $e) {
            $error = 'The item could not be saved. Please try again.';
        }
    }
}

$statusFilter = (string) ($_GET['status'] ?? 'all');
if ($statusFilter !== 'all' && !in_array($statusFilter, $statuses, true)) $statusFilter = 'all';
$sql = 'SELECT f.*, u.full_name AS logged_by_name FROM found_items f JOIN users u ON u.id = f.logged_by';
$params = [];
if ($statusFilter !== 'all') { $sql .= ' WHERE f.status = ?'; $params[] = $statusFilter; }
$sql .= ' ORDER BY f.created_at DESC';
$stmt = $db->prepare($sql); $stmt->execute($params); $items = $stmt->fetchAll();
$photoCovers = [];
foreach ($items as $item) {
    $photoCovers[(int) $item['id']] = (string) ($item['photo_path'] ?? '');
}
$itemPhotos = retrieva_photo_map('found', $photoCovers);
$counts = [];
foreach ($statuses as $status) { $stmt = $db->prepare('SELECT COUNT(*) FROM found_items WHERE status = ?'); $stmt->execute([$status]); $counts[$status] = (int) $stmt->fetchColumn(); }
?>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Found Items — Retrieva</title><link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg"><link rel="stylesheet" href="../assets/theme.css"><link rel="stylesheet" href="styles.css"><link rel="stylesheet" href="photo-picker.css"><link rel="stylesheet" href="item-photo-gallery.css"></head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?><div class="main-col"><?php include __DIR__ . '/components/header.php'; ?><main class="page-content">
<div class="page-header"><h1>Found Items</h1><p>Log items turned in to Security and track their status.</p></div>
<?php if ($error): ?><div class="alert alert-error"><?= h($error) ?></div><?php endif; ?><?php if ($success): ?><div class="alert alert-success"><?= h($success) ?></div><?php endif; ?>
<section class="stat-grid"><?php foreach ([['unclaimed','Unclaimed','blue'],['pending_verification','Pending Verification','gold'],['claimed','Claimed','green'],['disposed','Disposed','purple']] as [$key,$label,$variant]): ?><div class="stat-card stat-card--<?= $variant ?>"><div class="stat-card__value"><?= $counts[$key] ?></div><div class="stat-card__label"><?= h($label) ?></div></div><?php endforeach; ?></section>
<div class="section-title">Log a Found Item</div><div class="card"><form method="post" enctype="multipart/form-data"><?= csrf_field() ?><input type="hidden" name="action" value="create"><div class="field-row"><div class="field"><label for="item_name">Item name</label><input maxlength="150" type="text" id="item_name" name="item_name" required></div><div class="field"><label for="category">Category</label><select id="category" name="category" required><option value="" disabled selected>Select a category...</option><?php foreach ($categories as $category): ?><option value="<?= h($category) ?>"><?= h($category) ?></option><?php endforeach; ?></select></div></div><div class="field" id="found-other-category-wrap" hidden><label for="found_other_category">Specify item type / description</label><input maxlength="150" type="text" id="found_other_category" name="other_category" placeholder="Describe the category or item type..."></div><div class="field-row"><div class="field"><label for="location_found">Location found</label><input maxlength="150" type="text" id="location_found" name="location_found" required></div><div class="field"><label for="date_found">Date found</label><input type="date" id="date_found" name="date_found" max="<?= date('Y-m-d') ?>" value="<?= date('Y-m-d') ?>" required></div></div><?= dashboard_photo_picker([]) ?><button class="btn btn-primary" type="submit">Log Found Item</button></form></div>
<div class="section-title"><span>All Found Items</span><form method="get"><select name="status" onchange="this.form.submit()"><option value="all">All statuses</option><?php foreach ($statuses as $status): ?><option value="<?= h($status) ?>" <?= $statusFilter === $status ? 'selected' : '' ?>><?= h(ucwords(str_replace('_', ' ', $status))) ?></option><?php endforeach; ?></select></form></div>
<div class="card"><div class="data-table-wrap"><table class="data-table">
<thead><tr><th>Photo</th><th>Item</th><th>Category</th><th>Location</th><th>Date Found</th><th>Logged By</th><th>Status</th><th>Actions</th></tr></thead>
<tbody>
<?php if (!$items): ?><tr class="empty-row"><td colspan="8">No found items logged yet.</td></tr><?php endif; ?>
<?php foreach ($items as $item): ?>
<tr>
  <td><?= dashboard_photo_preview($itemPhotos[(int) $item['id']] ?? [], (string) $item['item_name']) ?></td>
  <td><strong><?= h($item['item_name']) ?></strong></td>
  <td><?= h($item['category']) ?><?php if (in_array($item['category'], ['Other', 'Others'], true) && !empty($item['other_category'])): ?><div><small><?= h($item['other_category']) ?></small></div><?php endif; ?></td>
  <td><?= h($item['location_found']) ?></td>
  <td><?= h(date('M j, Y', strtotime($item['date_found']))) ?></td>
  <td><?= h($item['logged_by_name']) ?></td>
  <td><?= found_status_pill($item['status']) ?></td>
  <td><div class="actions-cell"><?php if ($item['status'] === 'unclaimed'): ?><form method="post" data-confirm="Mark this item as disposed?" data-confirm-title="Dispose Item?" data-confirm-btn="Mark Disposed"><?= csrf_field() ?><input type="hidden" name="action" value="update_status"><input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>"><input type="hidden" name="new_status" value="disposed"><button class="btn btn-sm btn-gold">Dispose</button></form><?php elseif ($item['status'] === 'pending_verification'): ?><a class="btn btn-sm btn-primary" href="pending-verifications.php">Review Claim</a><?php endif; ?><form method="post" data-confirm="Are you sure you want to delete this found item permanently?" data-confirm-title="Delete Found Item?" data-confirm-btn="Delete Item"><?= csrf_field() ?><input type="hidden" name="action" value="delete"><input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>"><button class="btn btn-sm btn-danger">Delete</button></form></div></td>
</tr>
<?php endforeach; ?>
</tbody></table></div></div>
</main></div><?= dashboard_photo_gallery_dialog() ?><script>
document.addEventListener('DOMContentLoaded', () => {
  const catSelect = document.getElementById('category');
  const otherWrap = document.getElementById('found-other-category-wrap');
  const otherInput = document.getElementById('found_other_category');
  const syncOther = () => {
    const isOthers = catSelect?.value === 'Others';
    if (otherWrap) otherWrap.hidden = !isOthers;
    if (otherInput) {
      otherInput.required = isOthers;
      if (!isOthers) otherInput.value = '';
    }
  };
  catSelect?.addEventListener('change', syncOther);
  syncOther();
});
</script><script src="dashboard.js"></script><script src="photo-picker.js"></script><script src="item-photo-gallery.js"></script></body></html>
