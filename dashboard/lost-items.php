<?php
declare(strict_types=1);
$currentPage = 'lost-items';
require_once __DIR__ . '/_bootstrap.php';
require_once __DIR__ . '/../database/notify_helper.php';
$db = get_db();
$isAdminSide = role_is_admin_side($role);
$categories = ['Electronics', 'Clothing', 'IDs & Cards', 'Accessories', 'Books & Papers', 'Others'];
$statuses = ['searching', 'matched', 'resolved'];
$error = null; 
$success = null;

function lost_date(string $value): bool { 
    $date = DateTime::createFromFormat('Y-m-d', $value); 
    return $date instanceof DateTime && $date->format('Y-m-d') === $value && $value <= date('Y-m-d'); 
}

function lost_status_pill(string $status): string { 
    $map = [
        'searching' => ['pill--amber', 'Searching'],
        'matched'   => ['pill--blue', 'Matched'],
        'resolved'  => ['pill--green', 'Resolved']
    ]; 
    [$class, $label] = $map[$status] ?? ['pill--gray', ucfirst($status)]; 
    return '<span class="pill '.$class.'">'.h($label).'</span>'; 
}

$isAjax = strtolower((string) ($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '')) === 'xmlhttprequest';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf($_POST['csrf_token'] ?? null)) {
        $error = 'Your session expired. Please try again.';
        if ($isAjax) {
            json_out(['success' => false, 'message' => $error], 403);
        }
    } else {
        $action = (string) ($_POST['action'] ?? '');
        try {
            if ($action === 'create') {
                $name = trim((string) ($_POST['item_name'] ?? '')); 
                $category = (string) ($_POST['category'] ?? ''); 
                $otherCategory = trim((string) ($_POST['other_category'] ?? ''));
                $location = trim((string) ($_POST['last_seen_location'] ?? '')); 
                $dateLost = (string) ($_POST['date_lost'] ?? ''); 
                $description = trim((string) ($_POST['description'] ?? ''));
                
                if ($name === '' || strlen($name) > 150 || strlen($location) > 150 || strlen($description) > 1000 || !in_array($category, $categories, true) || !lost_date($dateLost) || ($category === 'Others' && ($otherCategory === '' || strlen($otherCategory) > 150))) {
                    throw new InvalidArgumentException('Enter valid item, category, date, and description details.');
                }
                
                $stmt = $db->prepare('INSERT INTO lost_items (reported_by, item_name, category, other_category, last_seen_location, date_lost, description) VALUES (?, ?, ?, ?, ?, ?, ?)'); 
                $stmt->execute([$user['id'], $name, $category, $category === 'Others' ? $otherCategory : null, $location ?: null, $dateLost, $description ?: null]); 
                $newLostId = (int) $db->lastInsertId();
                log_audit((int) $user['id'], 'lost_item_reported', $name); 
                notify_roles(['admin', 'security'], 'report', 'New Lost Item Report', "{$user['full_name']} reported a lost {$category}: {$name}.", 'lost_item', $newLostId, 'info');
                broadcast_event('private-staff', 'item:updated', ['entity' => 'lost_item', 'id' => $newLostId, 'status' => 'searching']);
                broadcast_event('private-updates', 'item:updated', ['entity' => 'lost_item', 'id' => $newLostId, 'status' => 'searching']);
                $success = 'Lost item report submitted.';
                
            } elseif ($action === 'update_status') {
                $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT); 
                $status = (string) ($_POST['new_status'] ?? ''); 
                
                if (!$id || !in_array($status, $statuses, true)) {
                    throw new InvalidArgumentException('Invalid report status.');
                }
                
                if ($isAdminSide) { 
                    $stmt = $db->prepare('UPDATE lost_items SET status = ? WHERE id = ?'); 
                    $stmt->execute([$status, $id]); 
                } else { 
                    if ($status !== 'resolved') throw new InvalidArgumentException('You may only mark your own report resolved.'); 
                    $stmt = $db->prepare('UPDATE lost_items SET status = ? WHERE id = ? AND reported_by = ?'); 
                    $stmt->execute([$status, $id, $user['id']]); 
                }
                
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Report was not found or already had that status.'); 
                log_audit((int) $user['id'], 'lost_item_status_changed', "item={$id} status={$status}"); 
                $ownerStmt = $db->prepare('SELECT reported_by, item_name FROM lost_items WHERE id = ?');
                $ownerStmt->execute([$id]);
                if ($ownerRow = $ownerStmt->fetch()) {
                    notify_users([(int) $ownerRow['reported_by']], 'report', 'Lost Report Updated', "Your lost item \"{$ownerRow['item_name']}\" is now marked {$status}.", 'lost_item', (int) $id, $status === 'resolved' ? 'success' : 'info');
                    broadcast_event('private-user-' . (int) $ownerRow['reported_by'], 'item:updated', ['entity' => 'lost_item', 'id' => (int) $id, 'status' => $status]);
                }
                broadcast_event('private-staff', 'item:updated', ['entity' => 'lost_item', 'id' => (int) $id, 'status' => $status]);
                broadcast_event('private-updates', 'item:updated', ['entity' => 'lost_item', 'id' => (int) $id, 'status' => $status]);
                $success = 'Report status updated.';
                if ($isAjax) {
                    json_out([
                        'success'   => true,
                        'message'   => $success,
                        'status'    => $status,
                        'pill_html' => lost_status_pill($status),
                    ]);
                }
                
            } elseif ($action === 'delete') {
                $id = filter_var($_POST['item_id'] ?? null, FILTER_VALIDATE_INT); 
                if (!$id) throw new InvalidArgumentException('Invalid report.');
                
                if ($isAdminSide) { 
                    $stmt = $db->prepare('DELETE FROM lost_items WHERE id = ?'); 
                    $stmt->execute([$id]); 
                } else { 
                    $stmt = $db->prepare("DELETE FROM lost_items WHERE id = ? AND reported_by = ? AND status = 'searching'"); 
                    $stmt->execute([$id, $user['id']]); 
                }
                
                if ($stmt->rowCount() !== 1) throw new RuntimeException('Report was not found or cannot be deleted.'); 
                log_audit((int) $user['id'], 'lost_item_deleted', "item={$id}"); 
                $success = 'Lost item report removed.';
            }
        } catch (InvalidArgumentException | RuntimeException $e) { 
            $error = $e->getMessage(); 
            if ($isAjax) {
                json_out(['success' => false, 'message' => $error], 400);
            }
        } catch (Throwable $e) { 
            $error = 'The report could not be saved. Please try again.'; 
            if ($isAjax) {
                json_out(['success' => false, 'message' => $error], 500);
            }
        }
    }
}

if ($isAdminSide) {
    $items = $db->query('SELECT l.*, u.full_name AS reporter_name FROM lost_items l JOIN users u ON u.id = l.reported_by ORDER BY l.created_at DESC')->fetchAll();
} else { 
    $stmt = $db->prepare('SELECT l.*, u.full_name AS reporter_name FROM lost_items l JOIN users u ON u.id = l.reported_by WHERE l.reported_by = ? ORDER BY l.created_at DESC'); 
    $stmt->execute([$user['id']]); 
    $items = $stmt->fetchAll(); 
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lost Items — Retrieva</title>
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
                <h1>Lost Items</h1>
                <p>
                    <?= $isAdminSide ? 'Manage all lost item reports filed by students and faculty.' : 'Report something you lost and track its status here.' ?>
                </p>
            </div>
            
            <?php if ($error): ?>
                <div class="alert alert-error">
                    <?= h($error) ?>
                </div>
            <?php endif; ?>
            
            <?php if ($success): ?>
                <div class="alert alert-success">
                    <?= h($success) ?>
                </div>
            <?php endif; ?>
            
            <!-- Report Form Card -->
            <div class="section-title">Report a Lost Item</div>
            <div class="card">
                <form method="post">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="create">
                    
                    <div class="field-row">
                        <div class="field">
                            <label for="item_name">Item name</label>
                            <input class="form-control" type="text" id="item_name" name="item_name" maxlength="150" placeholder="e.g. Blue Hydro Flask" required>
                        </div>
                        <div class="field">
                            <label for="category">Category</label>
                            <select class="form-control" id="category" name="category" required>
                                <option value="" disabled selected>Select a category...</option>
                                <?php foreach ($categories as $category): ?>
                                    <option value="<?= h($category) ?>"><?= h($category) ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>

                    <div class="field" id="lost-other-category-wrap" hidden>
                        <label for="lost_other_category">Specify item type / description</label>
                        <input class="form-control" type="text" id="lost_other_category" name="other_category" maxlength="150" placeholder="Describe the category or item type...">
                    </div>
                    
                    <div class="field-row">
                        <div class="field">
                            <label for="last_seen_location">Last seen location</label>
                            <input class="form-control" type="text" id="last_seen_location" name="last_seen_location" maxlength="150" placeholder="e.g. Library 2nd Floor">
                        </div>
                        <div class="field">
                            <label for="date_lost">Date lost</label>
                            <input class="form-control" type="date" id="date_lost" name="date_lost" max="<?= date('Y-m-d') ?>" value="<?= date('Y-m-d') ?>" required>
                        </div>
                    </div>
                    
                    <div class="field">
                        <label for="description">Description</label>
                        <textarea class="form-control" id="description" name="description" maxlength="1000" rows="3" placeholder="Provide identifying features (color, brand, serial number, contents)..."></textarea>
                    </div>
                    
                    <button class="btn btn-primary" type="submit">Submit Report</button>
                </form>
            </div>

            <?php if ($isAdminSide): ?>
            <!-- Reports Table Card -->
            <div class="section-title">All Active Reports</div>
            <div class="card">
                <div class="data-table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Category</th>
                                <th>Last Seen</th>
                                <th>Date Lost</th>
                                <th>Reported By</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!$items): ?>
                                <tr class="empty-row">
                                    <td colspan="7">
                                        <div style="font-size: 1.75rem; margin-bottom: 0.4rem;">📭</div>
                                        No lost item reports found.
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
                                    <td><?= h($item['reporter_name']) ?></td>
                                    <td class="js-status-cell"><?= lost_status_pill($item['status']) ?></td>
                                    <td>
                                        <div class="actions-cell">
                                            <form method="post" class="js-ajax-status-form">
                                                <?= csrf_field() ?>
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>">
                                                <select name="new_status" class="js-ajax-status-select" data-prev="<?= h($item['status']) ?>">
                                                    <?php foreach ($statuses as $status): ?>
                                                        <option value="<?= h($status) ?>" <?= $item['status'] === $status ? 'selected' : '' ?>>
                                                            <?= h(ucfirst($status)) ?>
                                                        </option>
                                                    <?php endforeach; ?>
                                                </select>
                                            </form>
                                            <form method="post" data-confirm="Are you sure you want to delete this lost item report?" data-confirm-title="Delete Report?" data-confirm-btn="Delete Report">
                                                <?= csrf_field() ?>
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="item_id" value="<?= (int) $item['id'] ?>">
                                                <button class="btn btn-sm btn-danger">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            <?php else: ?>
            <div class="section-title">
                <span>Your Submitted Reports</span>
                <a href="my-reports.php" class="btn btn-sm btn-ghost">View My Reports →</a>
            </div>
            <?php endif; ?>
            
        </main>
    </div>
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        const catSelect = document.getElementById('category');
        const otherWrap = document.getElementById('lost-other-category-wrap');
        const otherInput = document.getElementById('lost_other_category');
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

        document.querySelectorAll('.js-ajax-status-select').forEach((select) => {
          select.addEventListener('change', async () => {
            const form = select.closest('form');
            const row = select.closest('tr');
            const statusCell = row?.querySelector('.js-status-cell');
            const prevValue = select.dataset.prev || '';
            if (!form) return;

            const formData = new FormData(form);
            select.disabled = true;
            try {
              const res = await fetch(window.location.href, {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                credentials: 'same-origin',
                body: formData,
              });
              const data = await res.json();
              if (!data.success) {
                select.value = prevValue;
                window.showToast?.('Update Failed', data.message || 'Could not update status.', 'danger');
                return;
              }
              select.dataset.prev = data.status || select.value;
              if (statusCell && data.pill_html) {
                statusCell.innerHTML = data.pill_html;
              }
              window.showToast?.('Status Updated', data.message || 'Report status updated.', 'success');
            } catch {
              select.value = prevValue;
              window.showToast?.('Network Error', 'Could not update report status.', 'danger');
            } finally {
              select.disabled = false;
            }
          });
        });
      });
    </script>
    <script src="dashboard.js"></script>
</body>
</html>
