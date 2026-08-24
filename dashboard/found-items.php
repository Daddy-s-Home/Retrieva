<?php
declare(strict_types=1);
$currentPage = 'found-items';
require_once __DIR__ . '/_bootstrap.php';
require_role_page(['admin', 'security']);

$db = get_db();
$categories = ['Electronics', 'Clothing', 'IDs & Cards', 'Accessories', 'Books & Papers', 'Others'];
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
                $location = trim((string) ($_POST['location_found'] ?? ''));
                $dateFound = (string) ($_POST['date_found'] ?? '');
                if ($name === '' || strlen($name) > 150 || $location === '' || strlen($location) > 150 || !in_array($category, $categories, true) || !valid_date($dateFound)) {
                    throw new InvalidArgumentException('Enter valid item, category, location, and date details.');
                }
                $stmt = $db->prepare('INSERT INTO found_items (logged_by, item_name, category, location_found, date_found) VALUES (?, ?, ?, ?, ?)');
                $stmt->execute([$user['id'], $name, $category, $location, $dateFound]);
                log_audit((int) $user['id'], 'found_item_logged', $name);
                $success = 'Found item logged successfully.';
            } elseif ($action === 'update_status') {
                $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT);
                $status = (string) ($_POST['new_status'] ?? '');
                if (!$id || !in_array($status, $statuses, true)) throw new InvalidArgumentException('Invalid item status.');
                $stmt = $db->prepare('UPDATE found_items SET status = ? WHERE id = ?');
                $stmt->execute([$status, $id]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Item was not found or already had that status.');
                log_audit((int) $user['id'], 'found_item_status_changed', "item={$id} status={$status}");
                $success = 'Item status updated.';
            } elseif ($action === 'delete') {
                $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT);
                if (!$id) throw new InvalidArgumentException('Invalid item.');
                $stmt = $db->prepare('DELETE FROM found_items WHERE id = ?');
                $stmt->execute([$id]);
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Item was not found.');
                log_audit((int) $user['id'], 'found_item_deleted', "item={$id}");
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
$counts = [];
foreach ($statuses as $status) { $stmt = $db->prepare('SELECT COUNT(*) FROM found_items WHERE status = ?'); $stmt->execute([$status]); $counts[$status] = (int) $stmt->fetchColumn(); }
?>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Found Items — Retrieva</title><link rel="stylesheet" href="../assets/theme.css"><link rel="stylesheet" href="styles.css"></head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?><div class="main-col"><?php include __DIR__ . '/components/header.php'; ?><main class="page-content">
<div class="page-header"><h1>Found Items</h1><p>Log items turned in to Security and track their status.</p></div>
<?php if ($error): ?><div class="alert alert-error"><?= h($error) ?></div><?php endif; ?><?php if ($success): ?><div class="alert alert-success"><?= h($success) ?></div><?php endif; ?>
<section class="stat-grid"><?php foreach ([['unclaimed','Unclaimed','blue'],['pending_verification','Pending Verification','gold'],['claimed','Claimed','green'],['disposed','Disposed','purple']] as [$key,$label,$variant]): ?><div class="stat-card stat-card--<?= $variant ?>"><div class="stat-card__value"><?= $counts[$key] ?></div><div class="stat-card__label"><?= h($label) ?></div></div><?php endforeach; ?></section>
<div class="section-title">Log a Found Item</div><div class="card"><form method="post"><?= csrf_field() ?><input type="hidden" name="action" value="create"><div class="field-row"><div class="field"><label for="item_name">Item name</label><input maxlength="150" type="text" id="item_name" name="item_name" required></div><div class="field"><label for="category">Category</label><select id="category" name="category" required><?php foreach ($categories as $category): ?><option value="<?= h($category) ?>"><?= h($category) ?></option><?php endforeach; ?></select></div></div><div class="field-row"><div class="field"><label for="location_found">Location found</label><input maxlength="150" type="text" id="location_found" name="location_found" required></div><div class="field"><label for="date_found">Date found</label><input type="date" id="date_found" name="date_found" max="<?= date('Y-m-d') ?>" value="<?= date('Y-m-d') ?>" required></div></div><button class="btn btn-primary" type="submit">Log Found Item</button></form></div>
<div class="section-title"><span>All Found Items</span><form method="get"><select name="status" onchange="this.form.submit()"><option value="all">All statuses</option><?php foreach ($statuses as $status): ?><option value="<?= h($status) ?>" <?= $statusFilter === $status ? 'selected' : '' ?>><?= h(ucwords(str_replace('_', ' ', $status))) ?></option><?php endforeach; ?></select></form></div><div class="card"><div class="data-table-wrap"><table class="data-table"><thead><tr><th>Item</th><th>Category</th><th>Location</th><th>Date Found</th><th>Logged By</th><th>Status</th><th>Actions</th></tr></thead><tbody><?php if (!$items): ?><tr class="empty-row"><td colspan="7">No found items logged yet.</td></tr><?php endif; ?><?php foreach ($items as $item): ?><tr><td><strong><?= h($item['item_name']) ?></strong></td><td><?= h($item['category']) ?></td><td><?= h($item['location_found']) ?></td><td><?= h(date('M j, Y', strtotime($item['date_found']))) ?></td><td><?= h($item['logged_by_name']) ?></td><td><?= found_status_pill($item['status']) ?></td><td><div class="actions-cell"><?php if ($item['status'] === 'unclaimed'): ?><form method="post" onsubmit="return confirm('Mark this item as disposed?');"><?= csrf_field() ?><input type="hidden" name="action" value="update_status"><input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>"><input type="hidden" name="new_status" value="disposed"><button class="btn btn-sm btn-gold">Dispose</button></form><?php elseif ($item['status'] === 'pending_verification'): ?><a class="btn btn-sm btn-primary" href="pending-verifications.php">Review Claim</a><?php endif; ?><form method="post" onsubmit="return confirm('Delete this found item permanently?');"><?= csrf_field() ?><input type="hidden" name="action" value="delete"><input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>"><button class="btn btn-sm btn-danger">Delete</button></form></div></td></tr><?php endforeach; ?></tbody></table></div></div>
</main></div><script src="dashboard.js"></script></body></html>
