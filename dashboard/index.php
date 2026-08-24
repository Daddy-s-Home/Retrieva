<?php
declare(strict_types=1);
$currentPage = 'dashboard';
require_once __DIR__ . '/_bootstrap.php';
// $user, $role, $avatarSrc, $currentPage are now available.
$db = get_db();
$isAdminSide = role_is_admin_side($role);
$userId = (int) $user['id'];
if ($isAdminSide) {
  $totalFound = (int) $db->query('SELECT COUNT(*) FROM found_items')->fetchColumn();
  $totalLost = (int) $db->query('SELECT COUNT(*) FROM lost_items')->fetchColumn();
  $totalClaims = (int) $db->query('SELECT COUNT(*) FROM claims')->fetchColumn();
  $itemsReturned = (int) $db->query("SELECT COUNT(*) FROM found_items WHERE status = 'claimed'")->fetchColumn();
} else {
  $stmt = $db->prepare('SELECT COUNT(*) FROM lost_items WHERE reported_by = ?'); $stmt->execute([$userId]); $totalLost = (int) $stmt->fetchColumn();
  $stmt = $db->prepare('SELECT COUNT(*) FROM claims WHERE claimant_id = ?'); $stmt->execute([$userId]); $totalClaims = (int) $stmt->fetchColumn();
  $totalFound = (int) $db->query("SELECT COUNT(*) FROM found_items WHERE status = 'unclaimed'")->fetchColumn();
  $stmt = $db->prepare("SELECT COUNT(*) FROM claims WHERE claimant_id = ? AND status = 'approved'"); $stmt->execute([$userId]); $itemsReturned = (int) $stmt->fetchColumn();
}
$recentFound = $db->query('SELECT item_name, location_found, date_found, status FROM found_items ORDER BY created_at DESC LIMIT 5')->fetchAll();
$pendingCount = (int) $db->query("SELECT COUNT(*) FROM claims WHERE status IN ('pending', 'manual_review')")->fetchColumn();
$categories = ['Electronics', 'Clothing', 'IDs & Cards', 'Accessories', 'Books & Papers', 'Others'];
$categoryCounts = array_fill_keys($categories, 0);
foreach ($db->query('SELECT category, COUNT(*) AS total FROM found_items GROUP BY category')->fetchAll() as $row) if (isset($categoryCounts[$row['category']])) $categoryCounts[$row['category']] = (int) $row['total'];
$days = []; $foundSeries = []; $lostSeries = [];
for ($i = 6; $i >= 0; $i--) { $day = date('Y-m-d', strtotime("-{$i} days")); $days[] = date('M j', strtotime($day)); $stmt = $db->prepare('SELECT COUNT(*) FROM found_items WHERE date_found = ?'); $stmt->execute([$day]); $foundSeries[] = (int) $stmt->fetchColumn(); $stmt = $db->prepare('SELECT COUNT(*) FROM lost_items WHERE date_lost = ?'); $stmt->execute([$day]); $lostSeries[] = (int) $stmt->fetchColumn(); }
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard — Retrieva</title>
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>
</head>
<body data-page="<?= htmlspecialchars($currentPage) ?>" data-role="<?= htmlspecialchars($role) ?>">

<?php include __DIR__ . '/components/sidebar.php'; ?>

<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>

  <main class="page-content">
    <div class="page-header">
      <h1>Good morning, <?= htmlspecialchars(explode(' ', $user['full_name'])[0]) ?>! 👋</h1>
      <p>Here's what's happening with Retrieva today.</p>
    </div>

    <!-- stat cards -->
    <section class="stat-grid">
      <div class="stat-card stat-card--blue">
        <div class="stat-card__icon">📦</div>
        <div>
          <div class="stat-card__value"><?= $totalFound ?></div>
          <div class="stat-card__label">Total Found Items</div>
          <div class="stat-card__delta">▲ 18% from last month</div>
        </div>
      </div>
      <div class="stat-card stat-card--gold">
        <div class="stat-card__icon">🔍</div>
        <div>
          <div class="stat-card__value"><?= $totalLost ?></div>
          <div class="stat-card__label">Total Lost Reports</div>
          <div class="stat-card__delta">▲ 15% from last month</div>
        </div>
      </div>
      <div class="stat-card stat-card--purple">
        <div class="stat-card__icon">🛡️</div>
        <div>
          <div class="stat-card__value"><?= $totalClaims ?></div>
          <div class="stat-card__label">Total Claims</div>
          <div class="stat-card__delta">▲ 22% from last month</div>
        </div>
      </div>
      <div class="stat-card stat-card--green">
        <div class="stat-card__icon">✅</div>
        <div>
          <div class="stat-card__value"><?= $itemsReturned ?></div>
          <div class="stat-card__label">Items Returned</div>
          <div class="stat-card__delta">▲ 19% from last month</div>
        </div>
      </div>
    </section>

    <!-- row 1 -->
    <section class="dash-grid" style="margin-bottom:16px;">
      <div class="card">
        <div class="card__header">
          <h3>Items Overview</h3>
          <select style="border:1px solid var(--c-border); border-radius:8px; padding:4px 8px; font-size:12.5px;">
            <option>This Month</option>
          </select>
        </div>
        <canvas id="itemsOverviewChart" height="180"></canvas>
      </div>

      <div class="card">
        <div class="card__header">
          <h3>Recent Found Items</h3>
          <?php if (role_is_admin_side($role)): ?>
            <a href="found-items.php" class="card__link">View All</a>
          <?php endif; ?>
        </div>
        <?php foreach ($recentFound as $item): ?><div class="found-item-row">
          <div class="found-item-row__thumb">📦</div><div class="found-item-row__meta"><strong><?= h($item['item_name']) ?></strong><small><?= h($item['location_found']) ?> · <?= h(date('M j', strtotime($item['date_found']))) ?></small></div><span class="badge <?= $item['status'] === 'claimed' ? 'badge--green' : 'badge--amber' ?>"><?= h(ucwords(str_replace('_', ' ', $item['status']))) ?></span>
        </div><?php endforeach; ?>
      </div>

      <?php if (role_is_admin_side($role)): ?>
      <div class="card">
        <div class="card__header">
          <h3>Pending Verifications</h3>
          <a href="pending-verifications.php" class="card__link">View All</a>
        </div>
        <div class="verif-row">
          <div class="verif-row__icon" style="background:var(--c-info-bg);">🔐</div>
          <div class="verif-row__meta"><strong>Claims Awaiting Review</strong><small><?= $pendingCount ?> claim(s) need a decision</small></div>
        </div>
        <div class="verif-row">
          <div class="verif-row__icon" style="background:var(--c-gold-soft);">🔤</div>
          <div class="verif-row__meta"><strong>Manual Review</strong><small>Security can inspect submitted answers</small></div>
        </div>
        <div class="verif-row">
          <div class="verif-row__icon" style="background:var(--c-purple-bg);">👤</div>
          <div class="verif-row__meta"><strong>Protected Workflow</strong><small>Claim decisions are recorded securely</small></div>
        </div>
      </div>
      <?php endif; ?>
    </section>

    <!-- row 2 -->
    <section class="dash-grid">
      <div class="card">
        <div class="card__header"><h3>Items by Category</h3></div>
        <div style="display:flex; align-items:center; gap:18px;">
          <div style="position:relative; width:150px; height:150px;">
            <canvas id="categoryChart"></canvas>
          </div>
          <ul style="list-style:none; padding:0; margin:0; font-size:12.5px; flex:1;">
            <?php foreach ($categoryCounts as $category => $count): ?><li><?= h($category) ?> — <?= $count ?></li><?php endforeach; ?>
          </ul>
        </div>
      </div>

      <div class="card">
        <div class="card__header"><h3>Quick Actions</h3></div>
        <div class="quick-actions-grid">
          <?php if (role_is_admin_side($role)): ?>
            <a href="found-items.php" class="quick-action"><span class="qa-icon">📦</span>Log Found Item</a>
          <?php endif; ?>
          <a href="lost-items.php" class="quick-action"><span class="qa-icon">🔍</span>Log Lost Item</a>
          <?php if (role_is_admin_side($role)): ?>
            <a href="claims.php" class="quick-action"><span class="qa-icon">🛡️</span>Review Claims</a>
          <?php endif; ?>
        </div>
      </div>

      <div style="display:flex; flex-direction:column; gap:16px;">
        <div class="system-status-card">
          <div style="font-size:22px;">🛡️</div>
          <h3>All Systems Secure</h3>
          <p>● Core dashboard services are running</p>
        </div>

        <?php if ($role === 'admin'): ?>
        <div class="card">
          <div class="card__header"><h3>Integrations Status</h3></div>
          <div class="integration-row">
            <span class="integration-row__name">🔵 Google Login (OAuth2)</span>
            <span class="status-connected"><span class="status-dot"></span> Connected</span>
          </div>
        </div>
        <?php endif; ?>
      </div>
    </section>

    <div class="bottom-banner">
      <span style="font-size:26px;">🛡️</span>
      <div>
        <strong>Fraud-Proof. Privacy-First. Campus Trusted.</strong>
        <span>Retrieva uses zero-knowledge verification, smart masking, and secure integrations so every item gets back to its rightful owner.</span>
      </div>
    </div>
  </main>
</div>

<?php
// First-login prompts: student ID takes priority over the password
// popup, and only one is ever shown per page load.
if ($role === 'student' && empty($user['student_id'])) {
    include __DIR__ . '/components/student-id-modal.php';
} elseif ($user['auth_provider'] === 'google' && !$user['password_is_set'] && !$user['skip_password_prompt']) {
    include __DIR__ . '/components/password-setup-modal.php';
}
?>

<script src="dashboard.js"></script>
<script>
  // Local chart rendering — decorative only, wire up to real DB totals later.
  window.addEventListener('DOMContentLoaded', () => {
    const ctx1 = document.getElementById('itemsOverviewChart');
    if (ctx1 && window.Chart) {
      new Chart(ctx1, {
        type: 'line',
        data: {
          labels: <?= json_encode($days) ?>,
          datasets: [
            { label: 'Found Items', data: <?= json_encode($foundSeries) ?>, borderColor: '#2E6FF2', backgroundColor: 'rgba(46,111,242,0.08)', tension: 0.35, fill: true },
            { label: 'Lost Items', data: <?= json_encode($lostSeries) ?>, borderColor: '#F5A623', backgroundColor: 'rgba(245,166,35,0.08)', tension: 0.35, fill: true },
          ],
        },
        options: { plugins: { legend: { position: 'top', align: 'end', labels: { boxWidth: 10 } } }, scales: { y: { beginAtZero: true } } },
      });
    }
    const ctx2 = document.getElementById('categoryChart');
    if (ctx2 && window.Chart) {
      new Chart(ctx2, {
        type: 'doughnut',
        data: {
          labels: ['Electronics','Clothing','IDs & Cards','Accessories','Books & Papers','Others'],
          datasets: [{ data: <?= json_encode(array_values($categoryCounts)) ?>, backgroundColor: ['#2E6FF2','#F5A623','#7C5CFC','#17A673','#C7CDD9','#1F2A3D'], borderWidth: 0 }],
        },
        options: { cutout: '68%', plugins: { legend: { display: false } } },
      });
    }
  });
</script>
</body>
</html>
