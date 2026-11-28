<?php
declare(strict_types=1);

$currentPage = 'dashboard';
require_once __DIR__ . '/_bootstrap.php';

$db = get_db();
$isAdminSide = role_is_admin_side($role);
$userId = (int) $user['id'];
$firstName = explode(' ', trim((string) $user['full_name']))[0] ?: 'there';

/**
 * Security Helper: Smart Masking for Sensitive Item Names on Student Dashboard
 */
if (!function_exists('mask_item_name')) {
    function mask_item_name(string $name, bool $isAdmin): string {
        if ($isAdmin) {
            return $name;
        }
        $masked = preg_replace_callback('/\b([A-Z0-9]{2})[A-Z0-9]{3,}([A-Z0-9]{2})\b/i', function ($matches) {
            return $matches[1] . str_repeat('*', strlen($matches[0]) - 4) . $matches[2];
        }, $name);

        return $masked ?? $name;
    }
}

// -------------------------------------------------------------------------
// 1. STAT METRICS
// -------------------------------------------------------------------------
if ($isAdminSide) {
    $totalFound    = (int) $db->query('SELECT COUNT(*) FROM found_items')->fetchColumn();
    $totalLost     = (int) $db->query('SELECT COUNT(*) FROM lost_items')->fetchColumn();
    $totalClaims   = (int) $db->query('SELECT COUNT(*) FROM claims')->fetchColumn();
    $itemsReturned = (int) $db->query("SELECT COUNT(*) FROM found_items WHERE status = 'claimed'")->fetchColumn();
} else {
    $stmt = $db->prepare('SELECT COUNT(*) FROM lost_items WHERE reported_by = ?');
    $stmt->execute([$userId]);
    $totalLost = (int) $stmt->fetchColumn();

    $stmt = $db->prepare('SELECT COUNT(*) FROM claims WHERE claimant_id = ?');
    $stmt->execute([$userId]);
    $totalClaims = (int) $stmt->fetchColumn();

    $totalFound = (int) $db->query("SELECT COUNT(*) FROM found_items WHERE status = 'unclaimed'")->fetchColumn();

    $stmt = $db->prepare("SELECT COUNT(*) FROM claims WHERE claimant_id = ? AND status = 'approved'");
    $stmt->execute([$userId]);
    $itemsReturned = (int) $stmt->fetchColumn();
}

$recentFound = $db->query('SELECT item_name, location_found, date_found, status FROM found_items ORDER BY created_at DESC LIMIT 5')->fetchAll();
$pendingCount = (int) $db->query("SELECT COUNT(*) FROM claims WHERE status IN ('pending', 'manual_review')")->fetchColumn();

// -------------------------------------------------------------------------
// 2. CATEGORY BREAKDOWN
// -------------------------------------------------------------------------
$categoryPalette = ['#2E6FF2', '#F5A623', '#7C5CFC', '#17A673', '#C44747', '#5C6B7A', '#16A0A8', '#BA4C96', '#A06D2C', '#507D2B', '#7A6E5B', '#8E6C8A'];
$foundCategoryRows = $isAdminSide ? dashboard_category_rows($db, 'found_items') : [];
$lostCategoryRows = dashboard_category_rows($db, 'lost_items');
$initialCategoryType = $isAdminSide ? 'found' : 'lost';
$initialCategoryRows = $isAdminSide ? $foundCategoryRows : $lostCategoryRows;
$initialCategoryHasData = array_sum(array_column($initialCategoryRows, 'total')) > 0;
$categoryChartData = json_encode(
    ['found' => $foundCategoryRows, 'lost' => $lostCategoryRows],
    JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_SLASHES
);
if ($categoryChartData === false) {
    throw new RuntimeException('Unable to encode category chart data.');
}

// -------------------------------------------------------------------------
// 3. OPTIMIZED 7-DAY TREND QUERIES
// -------------------------------------------------------------------------
$startDate = date('Y-m-d', strtotime('-6 days'));
$endDate   = date('Y-m-d');

$stmtFound = $db->prepare('SELECT date_found, COUNT(*) AS cnt FROM found_items WHERE date_found BETWEEN ? AND ? GROUP BY date_found');
$stmtFound->execute([$startDate, $endDate]);
$foundMap = $stmtFound->fetchAll(PDO::FETCH_KEY_PAIR) ?: [];

$stmtLost = $db->prepare('SELECT date_lost, COUNT(*) AS cnt FROM lost_items WHERE date_lost BETWEEN ? AND ? GROUP BY date_lost');
$stmtLost->execute([$startDate, $endDate]);
$lostMap = $stmtLost->fetchAll(PDO::FETCH_KEY_PAIR) ?: [];

$days = [];
$foundSeries = [];
$lostSeries = [];

for ($i = 6; $i >= 0; $i--) {
    $dayKey = date('Y-m-d', strtotime("-{$i} days"));
    $days[] = date('M j', strtotime($dayKey));
    $foundSeries[] = (int) ($foundMap[$dayKey] ?? 0);
    $lostSeries[]  = (int) ($lostMap[$dayKey] ?? 0);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard — Retrieva</title>
<link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>
</head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>" data-user-id="<?= $userId ?>">

<?php include __DIR__ . '/components/sidebar.php'; ?>

<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>

  <main class="page-content">
    <div class="page-header">
      <h1 data-local-greeting data-first-name="<?= h($firstName) ?>">Welcome, <?= h($firstName) ?>!</h1>
      <p>Here's what's happening with Retrieva today.</p>
    </div>

    <section class="stat-grid">
      <div class="stat-card stat-card--blue">
        <div class="stat-card__icon">📦</div>
        <div>
          <div class="stat-card__value" id="stat-total-found"><?= $totalFound ?></div>
          <div class="stat-card__label"><?= $isAdminSide ? 'Total Found Items' : 'Available Unclaimed' ?></div>
          <div class="stat-card__delta">System Active</div>
        </div>
      </div>

      <div class="stat-card stat-card--gold">
        <div class="stat-card__icon">🔍</div>
        <div>
          <div class="stat-card__value" id="stat-total-lost"><?= $totalLost ?></div>
          <div class="stat-card__label"><?= $isAdminSide ? 'Total Lost Reports' : 'My Lost Reports' ?></div>
          <div class="stat-card__delta">System Active</div>
        </div>
      </div>

      <div class="stat-card stat-card--purple">
        <div class="stat-card__icon">🛡️</div>
        <div>
          <div class="stat-card__value" id="stat-total-claims"><?= $totalClaims ?></div>
          <div class="stat-card__label"><?= $isAdminSide ? 'Total Claims' : 'My Total Claims' ?></div>
          <div class="stat-card__delta">System Active</div>
        </div>
      </div>

      <div class="stat-card stat-card--blue">
        <div class="stat-card__icon">✅</div>
        <div>
          <div class="stat-card__value" id="stat-items-returned"><?= $itemsReturned ?></div>
          <div class="stat-card__label"><?= $isAdminSide ? 'Items Returned' : 'Successful Claims' ?></div>
          <div class="stat-card__delta">Verified Returns</div>
        </div>
      </div>
    </section>

    <section class="dash-grid<?= $isAdminSide ? '' : ' dash-grid--2col' ?>" style="margin-bottom:16px;">
      <div class="card">
        <div class="card__header">
          <h3>Items Overview</h3>
          <span style="font-size:12px; color:var(--c-text-muted);">Last 7 Days</span>
        </div>
        <div style="position: relative; width: 100%; height: 220px;">
          <canvas id="itemsOverviewChart"></canvas>
        </div>
      </div>

      <div class="card">
        <div class="card__header">
          <h3>Recent Found Items</h3>
          <?php if ($isAdminSide): ?>
            <a href="found-items.php" class="card__link">View All</a>
          <?php endif; ?>
        </div>
        
        <div id="recent-found-list">
        <?php if (empty($recentFound)): ?>
          <div style="text-align:center; padding: 24px 0; color:var(--c-text-muted); font-size:13px;">
            <div style="font-size:24px; margin-bottom:4px;">📥</div>
            No recently found items recorded.
          </div>
        <?php else: ?>
          <?php foreach ($recentFound as $item): ?>
            <div class="found-item-row">
              <div class="found-item-row__thumb">📦</div>
              <div class="found-item-row__meta">
                <strong><?= h(mask_item_name($item['item_name'], $isAdminSide)) ?></strong>
                <small><?= h($item['location_found']) ?> · <?= h(date('M j', strtotime($item['date_found']))) ?></small>
              </div>
              <span class="badge <?= $item['status'] === 'claimed' ? 'badge--green' : 'badge--amber' ?>">
                <?= h(ucwords(str_replace('_', ' ', $item['status']))) ?>
              </span>
            </div>
          <?php endforeach; ?>
        <?php endif; ?>
        </div>
      </div>

      <?php if ($isAdminSide): ?>
      <div class="card">
        <div class="card__header">
          <h3><a href="pending-verifications.php" class="card__title-link">Pending Verifications</a></h3>
          <a href="pending-verifications.php" class="card__link">View All</a>
        </div>
        <div class="verif-row">
          <div class="verif-row__icon" style="background:var(--c-info-bg);">🔐</div>
          <div class="verif-row__meta">
            <strong>Claims Awaiting Review</strong>
            <small id="pending-claims-count"><?= $pendingCount ?> claim(s) need a decision</small>
          </div>
        </div>
        <div class="verif-row">
          <div class="verif-row__icon" style="background:var(--c-gold-soft);">🔤</div>
          <div class="verif-row__meta">
            <strong>Manual Review</strong>
            <small>Security can inspect submitted answers</small>
          </div>
        </div>
        <div class="verif-row">
          <div class="verif-row__icon" style="background:var(--c-purple-bg);">👤</div>
          <div class="verif-row__meta">
            <strong>Protected Workflow</strong>
            <small>Claim decisions are recorded securely</small>
          </div>
        </div>
      </div>
      <?php endif; ?>
    </section>

    <section class="dash-grid<?= $isAdminSide ? '' : ' dash-grid--2col' ?>">
      <div class="card category-chart-card">
        <div class="card__header">
          <h3>Items by Category</h3>
        </div>
        <?php if ($isAdminSide): ?>
        <div class="legacy-category-tabs" id="legacy-category-tabs" role="tablist" aria-label="Choose item type">
          <button class="legacy-category-tab" id="legacy-category-tab-found" type="button" role="tab" aria-selected="true" aria-controls="legacy-category-panel" tabindex="0" data-category-tab="found">Found Items</button>
          <button class="legacy-category-tab" id="legacy-category-tab-lost" type="button" role="tab" aria-selected="false" aria-controls="legacy-category-panel" tabindex="-1" data-category-tab="lost">Lost Items</button>
        </div>
        <?php endif; ?>
        <div class="category-chart-layout" <?= $isAdminSide ? 'id="legacy-category-panel" role="tabpanel" aria-labelledby="legacy-category-tab-found" tabindex="0"' : '' ?>>
          <div class="category-chart-layout__content">
            <div class="category-chart-layout__chart">
              <canvas id="categoryChart" role="img" aria-label="<?= $initialCategoryType === 'found' ? 'Found items by category' : 'Lost items by category' ?>"></canvas>
            </div>
            <ul class="category-chart-layout__legend legacy-category-legend" id="legacy-category-legend" aria-label="<?= $initialCategoryType === 'found' ? 'Found category totals' : 'Lost category totals' ?>" <?= $initialCategoryHasData ? '' : 'hidden' ?>>
              <?php foreach ($initialCategoryRows as $index => $row): ?>
                <li>
                  <span class="legacy-category-legend-label">
                    <span class="legacy-category-legend-swatch" style="background-color:<?= $categoryPalette[$index % count($categoryPalette)] ?>" aria-hidden="true"></span>
                    <span class="legacy-category-legend-name"><?= h((string) $row['label']) ?></span>
                  </span>
                  <strong class="legacy-category-legend-count"><?= (int) $row['total'] ?></strong>
                </li>
              <?php endforeach; ?>
            </ul>
          </div>
        </div>
        <p class="legacy-category-empty-state" id="legacy-category-empty-state" role="status" aria-live="polite" <?= $initialCategoryHasData ? 'hidden' : '' ?>>No <?= $initialCategoryType ?> item categories have been recorded yet.</p>
      </div>

      <div class="card">
        <div class="card__header">
          <h3>Quick Actions</h3>
        </div>
        <div class="quick-actions-grid">
          <?php if ($isAdminSide): ?>
            <a href="found-items.php?action=new" class="quick-action">
              <span class="qa-icon">📦</span>Log Found Item
            </a>
          <?php endif; ?>
          <a href="lost-items.php?action=new" class="quick-action">
            <span class="qa-icon">🔍</span>Log Lost Item
          </a>
          <?php if ($isAdminSide): ?>
            <a href="claims.php" class="quick-action">
              <span class="qa-icon">🛡️</span>Review Claims
            </a>
          <?php endif; ?>
        </div>
      </div>

      <?php if ($isAdminSide): ?>
      <div class="dash-status-stack">
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
          <div class="integration-row" style="margin-top:8px;">
            <span class="integration-row__name">⚡ Pusher WebSockets</span>
            <span class="status-connected" id="pusher-status"><span class="status-dot"></span> Active</span>
          </div>
        </div>
        <?php endif; ?>
      </div>
      <?php endif; ?>
    </section>
  </main>
</div>

<?php
if ($role === 'student' && empty($user['student_id'])) {
    include __DIR__ . '/components/student-id-modal.php';
} elseif ($user['auth_provider'] === 'google' && !$user['password_is_set'] && !$user['skip_password_prompt']) {
    include __DIR__ . '/components/password-setup-modal.php';
}
?>

<script src="dashboard.js"></script>

<script>
  window.addEventListener('DOMContentLoaded', () => {
    // 1. Line Chart rendering
    const ctx1 = document.getElementById('itemsOverviewChart');
    if (ctx1 && window.Chart) {
      window.retrievaLineChart = new Chart(ctx1, {
        type: 'line',
        data: {
          labels: <?= json_encode($days) ?>,
          datasets: [
            { 
              label: 'Found Items', 
              data: <?= json_encode($foundSeries) ?>, 
              borderColor: '#2E6FF2', 
              backgroundColor: 'rgba(46,111,242,0.10)', 
              tension: 0.35, 
              fill: true,
              pointBackgroundColor: '#2E6FF2',
              pointBorderColor: '#FFFFFF'
            },
            { 
              label: 'Lost Items', 
              data: <?= json_encode($lostSeries) ?>, 
              borderColor: '#F5A623', 
              backgroundColor: 'rgba(245,166,35,0.10)', 
              tension: 0.35, 
              fill: true,
              pointBackgroundColor: '#F5A623',
              pointBorderColor: '#FFFFFF'
            },
          ],
        },
        options: { 
          responsive: true,
          maintainAspectRatio: false,
          resizeDelay: 100,
          animation: { duration: 600, easing: 'easeOutQuart' },
          interaction: { mode: 'index', intersect: false },
          elements: {
            point: { radius: 3, hoverRadius: 7, hoverBorderWidth: 2, hitRadius: 12 }
          },
          plugins: {
            legend: { position: 'top', align: 'end', labels: { boxWidth: 10, usePointStyle: true } },
            tooltip: { backgroundColor: '#1F2A3D', padding: 10, cornerRadius: 8, displayColors: true }
          }, 
          scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } 
        },
      });
    }

    // 2. Category chart and role-specific tabs
    const categoryCanvas = document.getElementById('categoryChart');
    const categoryData = <?= $categoryChartData ?>;
    const adminCategoryTabsEnabled = <?= $isAdminSide ? 'true' : 'false' ?>;
    const categoryTabs = Array.from(document.querySelectorAll('[data-category-tab]'));
    const categoryTabList = document.getElementById('legacy-category-tabs');
    const categoryPanel = document.getElementById('legacy-category-panel');
    const categoryLegend = document.getElementById('legacy-category-legend');
    const categoryEmptyState = document.getElementById('legacy-category-empty-state');
    const categoryColors = <?= json_encode($categoryPalette) ?>;
    let categoryChart = null;

    function renderCategoryLegend(rows, itemType, hasData) {
      if (!categoryLegend || !categoryEmptyState) return;
      categoryLegend.replaceChildren();

      categoryLegend.hidden = false;
      categoryEmptyState.textContent = `No ${itemType} item categories have been recorded yet.`;
      categoryEmptyState.hidden = hasData;
      rows.forEach((row, index) => {
        const item = document.createElement('li');
        const label = document.createElement('span');
        const swatch = document.createElement('span');
        const name = document.createElement('span');
        const count = document.createElement('strong');

        label.className = 'legacy-category-legend-label';
        swatch.className = 'legacy-category-legend-swatch';
        swatch.style.backgroundColor = categoryColors[index % categoryColors.length];
        swatch.setAttribute('aria-hidden', 'true');
        name.className = 'legacy-category-legend-name';
        name.textContent = String(row.label);
        count.className = 'legacy-category-legend-count';
        count.textContent = String(row.total);

        label.append(swatch, name);
        item.append(label, count);
        categoryLegend.append(item);
      });
    }

    function renderCategoryChart(requestedType) {
      if (!categoryCanvas) return;
      const itemType = adminCategoryTabsEnabled && requestedType === 'lost' ? 'lost' : (adminCategoryTabsEnabled ? 'found' : 'lost');
      const rows = Array.isArray(categoryData[itemType]) ? categoryData[itemType] : [];
      const hasData = rows.some((row) => Number(row.total) > 0);

      if (adminCategoryTabsEnabled) {
        categoryTabs.forEach((tab) => {
          const selected = tab.dataset.categoryTab === itemType;
          tab.setAttribute('aria-selected', String(selected));
          tab.tabIndex = selected ? 0 : -1;
        });
        categoryPanel?.setAttribute('aria-labelledby', `legacy-category-tab-${itemType}`);
      }

      categoryCanvas.setAttribute('aria-label', `${itemType === 'found' ? 'Found' : 'Lost'} items by category`);
      categoryLegend?.setAttribute('aria-label', `${itemType === 'found' ? 'Found' : 'Lost'} category totals`);
      renderCategoryLegend(rows, itemType, hasData);

      if (categoryChart) {
        categoryChart.destroy();
        categoryChart = null;
      }
      if (!window.Chart) {
        categoryCanvas.hidden = true;
        if (categoryEmptyState) {
          categoryEmptyState.textContent = hasData
            ? 'The chart library is unavailable. Reload the page to try again.'
            : `No ${itemType} item categories have been recorded yet. The chart library is unavailable.`;
          categoryEmptyState.hidden = false;
        }
        return;
      }

      categoryCanvas.hidden = false;
      const labels = rows.map((row) => {
        const label = String(row.label);
        if (label === 'Food containers and utensils') return ['Food containers', 'and utensils'];
        if (label === 'Tumbler/Flask/Bottled Water') return ['Tumbler/Flask/', 'Bottled Water'];
        return label;
      });
      const values = rows.map((row) => Number(row.total));
      categoryChart = new window.Chart(categoryCanvas, {
        type: 'bar',
        data: {
          labels,
          datasets: [{
            data: values,
            backgroundColor: rows.map((row, index) => categoryColors[index % categoryColors.length]),
            borderWidth: 0,
            borderRadius: 4,
            maxBarThickness: 22,
          }],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          indexAxis: 'y',
          animation: { duration: 450 },
          plugins: {
            legend: { display: false },
            tooltip: { enabled: hasData, backgroundColor: '#1F2A3D', padding: 10, cornerRadius: 8 },
          },
          scales: {
            x: { beginAtZero: true, ticks: { precision: 0, stepSize: 1 } },
            y: { reverse: true, grid: { display: false }, ticks: { autoSkip: false } },
          },
        },
      });
      window.retrievaCategoryChart = categoryChart;
    }

    categoryTabList?.addEventListener('click', (event) => {
      const target = event.target;
      if (!(target instanceof Element)) return;
      const tab = target.closest('[data-category-tab]');
      if (!tab || !categoryTabList.contains(tab)) return;
      renderCategoryChart(tab.dataset.categoryTab);
    });
    categoryTabList?.addEventListener('keydown', (event) => {
      const currentIndex = categoryTabs.indexOf(event.target);
      if (currentIndex < 0) return;
      let nextIndex = currentIndex;
      if (event.key === 'ArrowRight') nextIndex = (currentIndex + 1) % categoryTabs.length;
      else if (event.key === 'ArrowLeft') nextIndex = (currentIndex - 1 + categoryTabs.length) % categoryTabs.length;
      else if (event.key === 'Home') nextIndex = 0;
      else if (event.key === 'End') nextIndex = categoryTabs.length - 1;
      else return;
      event.preventDefault();
      categoryTabs[nextIndex].focus();
      renderCategoryChart(categoryTabs[nextIndex].dataset.categoryTab);
    });

    window.retrievaUpdateCategoryData = (updatedCategoryData) => {
      if (!updatedCategoryData || typeof updatedCategoryData !== 'object') {
        throw new TypeError('Invalid dashboard category data.');
      }
      if (adminCategoryTabsEnabled && Array.isArray(updatedCategoryData.found)) {
        categoryData.found = updatedCategoryData.found;
      }
      if (Array.isArray(updatedCategoryData.lost)) {
        categoryData.lost = updatedCategoryData.lost;
      }
      const selectedTab = categoryTabs.find((tab) => tab.getAttribute('aria-selected') === 'true');
      renderCategoryChart(selectedTab?.dataset.categoryTab || 'lost');
    };

    renderCategoryChart(adminCategoryTabsEnabled ? 'found' : 'lost');
  });
</script>
</body>
</html>
