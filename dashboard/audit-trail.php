<?php
declare(strict_types=1);
$currentPage = 'audit-trail';
require_once __DIR__ . '/_bootstrap.php';
require_role_page(['admin']);

$db = get_db();

$actionFilter = trim((string) ($_GET['action'] ?? ''));
$searchQuery  = trim((string) ($_GET['q'] ?? ''));
$page         = max(1, (int) ($_GET['p'] ?? 1));
$perPage      = 25;
$offset       = ($page - 1) * $perPage;

$actionsList = $db->query('SELECT DISTINCT action FROM audit_trail ORDER BY action ASC')->fetchAll(PDO::FETCH_COLUMN);

$where  = [];
$params = [];

if ($actionFilter !== '') {
    $where[]  = 'a.action = ?';
    $params[] = $actionFilter;
}
if ($searchQuery !== '') {
    $like     = '%' . $searchQuery . '%';
    $where[]  = '(u.full_name LIKE ? OR u.email LIKE ? OR a.details LIKE ? OR a.ip_address LIKE ? OR a.action LIKE ?)';
    array_push($params, $like, $like, $like, $like, $like);
}

$whereSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';

$countStmt = $db->prepare("SELECT COUNT(*) FROM audit_trail a LEFT JOIN users u ON u.id = a.user_id {$whereSql}");
$countStmt->execute($params);
$totalRows  = (int) $countStmt->fetchColumn();
$totalPages = max(1, (int) ceil($totalRows / $perPage));
if ($page > $totalPages) {
    $page   = $totalPages;
    $offset = ($page - 1) * $perPage;
}

$sql = "SELECT a.id, a.user_id, a.action, a.details, a.ip_address, a.created_at,
               u.full_name, u.email, u.role
        FROM audit_trail a
        LEFT JOIN users u ON u.id = a.user_id
        {$whereSql}
        ORDER BY a.created_at DESC, a.id DESC
        LIMIT {$perPage} OFFSET {$offset}";
$stmt = $db->prepare($sql);
$stmt->execute($params);
$logs = $stmt->fetchAll();

function audit_action_pill(string $action): string {
    $lower = strtolower($action);
    if (str_contains($lower, 'failed') || str_contains($lower, 'locked') || str_contains($lower, 'blocked') || str_contains($lower, 'rejected') || str_contains($lower, 'deleted')) {
        $cls = 'pill--red';
    } elseif (str_contains($lower, 'approved') || str_contains($lower, 'success') || str_contains($lower, 'verified') || str_contains($lower, 'resolved')) {
        $cls = 'pill--green';
    } elseif (str_contains($lower, 'review') || str_contains($lower, 'password') || str_contains($lower, 'totp')) {
        $cls = 'pill--amber';
    } else {
        $cls = 'pill--blue';
    }
    return '<span class="pill ' . $cls . '">' . h($action) . '</span>';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Audit Trail — Retrieva</title>
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
      <h1>Audit Trail</h1>
      <p>Monitor authentication attempts, item logs, claim decisions, and security activity across Retrieva.</p>
    </div>

    <div class="card" style="margin-bottom: 18px;">
      <form method="get" class="field-row" style="margin-bottom: 0; align-items: end;">
        <div class="field">
          <label for="audit-search">Search logs</label>
          <input type="text" id="audit-search" name="q" value="<?= h($searchQuery) ?>" placeholder="User, email, details, or IP address">
        </div>
        <div class="field">
          <label for="audit-action">Action</label>
          <div style="display: flex; gap: 8px;">
            <select id="audit-action" name="action" style="flex: 1;">
              <option value="">All actions</option>
              <?php foreach ($actionsList as $act): ?>
                <option value="<?= h($act) ?>" <?= $actionFilter === $act ? 'selected' : '' ?>><?= h($act) ?></option>
              <?php endforeach; ?>
            </select>
            <button type="submit" class="btn btn-primary">Filter</button>
            <?php if ($actionFilter !== '' || $searchQuery !== ''): ?>
              <a href="audit-trail.php" class="btn btn-ghost">Reset</a>
            <?php endif; ?>
          </div>
        </div>
      </form>
    </div>

    <div class="section-title">
      <span>Activity Logs</span>
      <span style="font-size: 12.5px; font-weight: 500; color: var(--c-text-muted);"><?= $totalRows ?> total event(s)</span>
    </div>

    <div class="card">
      <div class="data-table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>User</th>
              <th>Action</th>
              <th>Details</th>
              <th>IP Address</th>
            </tr>
          </thead>
          <tbody>
            <?php if (!$logs): ?>
              <tr class="empty-row"><td colspan="5">No audit trail events match your filters.</td></tr>
            <?php endif; ?>
            <?php foreach ($logs as $log): ?>
              <tr>
                <td style="white-space: nowrap;"><?= h(date('M j, Y g:i:s A', strtotime((string) $log['created_at']))) ?></td>
                <td>
                  <?php if ($log['full_name']): ?>
                    <strong><?= h($log['full_name']) ?></strong><br>
                    <small><?= h($log['email']) ?> · <?= h(ucfirst((string) $log['role'])) ?></small>
                  <?php else: ?>
                    <span style="color: var(--c-text-muted);">System / Guest</span>
                  <?php endif; ?>
                </td>
                <td><?= audit_action_pill((string) $log['action']) ?></td>
                <td><?= h($log['details'] ?: '—') ?></td>
                <td><code><?= h($log['ip_address'] ?: '—') ?></code></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>

      <?php if ($totalPages > 1): ?>
        <div class="actions-cell" style="justify-content: space-between; margin-top: 16px; padding-top: 14px; border-top: 1px solid var(--c-border);">
          <small style="color: var(--c-text-muted);">Page <?= $page ?> of <?= $totalPages ?></small>
          <div class="actions-cell">
            <?php if ($page > 1): ?>
              <a class="btn btn-sm btn-ghost" href="?<?= h(http_build_query(['q' => $searchQuery, 'action' => $actionFilter, 'p' => $page - 1])) ?>">Previous</a>
            <?php endif; ?>
            <?php if ($page < $totalPages): ?>
              <a class="btn btn-sm btn-ghost" href="?<?= h(http_build_query(['q' => $searchQuery, 'action' => $actionFilter, 'p' => $page + 1])) ?>">Next</a>
            <?php endif; ?>
          </div>
        </div>
      <?php endif; ?>
    </div>
  </main>
</div>
<script src="dashboard.js"></script>
</body>
</html>
