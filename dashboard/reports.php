<?php
declare(strict_types=1);
$currentPage = 'reports';
require_once __DIR__ . '/_bootstrap.php';
require_once __DIR__ . '/../database/report_helper.php';
require_role_page(['admin', 'security']);

$defs       = report_definitions($role);
$reportType = (string) ($_GET['report_type'] ?? 'lost_items');
if (!isset($defs[$reportType])) {
    $reportType = 'lost_items';
}
$dateFrom = (string) ($_GET['date_from'] ?? '');
$dateTo   = (string) ($_GET['date_to'] ?? '');
$status   = (string) ($_GET['status'] ?? '');

$report = fetch_report_data($role, $reportType, $dateFrom, $dateTo, $status);

$exportParams = [
    'report_type' => $report['type'],
    'date_from'   => $report['date_from'] ?? '',
    'date_to'     => $report['date_to'] ?? '',
    'status'      => $report['status'],
];
$csvUrl = '../database/export_report.php?' . http_build_query($exportParams + ['format' => 'csv']);
$pdfUrl = '../database/export_report.php?' . http_build_query($exportParams + ['format' => 'pdf']);

$isAjax = strtolower((string) ($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '')) === 'xmlhttprequest'
    || (($_GET['ajax'] ?? '') === '1');

if ($isAjax) {
    json_out([
        'success'      => true,
        'type'         => $report['type'],
        'title'        => $report['title'],
        'columns'      => $report['columns'],
        'statuses'     => $report['statuses'],
        'status'       => $report['status'],
        'date_from'    => $report['date_from'] ?? '',
        'date_to'      => $report['date_to'] ?? '',
        'rows'         => $report['rows'],
        'count'        => count($report['rows']),
        'generated_at' => date('M j, Y g:i A'),
        'csv_url'      => $csvUrl,
        'pdf_url'      => $pdfUrl,
    ]);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports &amp; Export — Retrieva</title>
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
      <h1>Reports &amp; Export</h1>
      <p>Filter, view real-time records, and download official PDF or CSV reports.</p>
    </div>

    <div class="card" style="margin-bottom: 18px;">
      <form method="get" id="reports-filter-form">
        <div class="field-row">
          <div class="field">
            <label for="report_type">Report type</label>
            <select id="report_type" name="report_type">
              <?php foreach ($defs as $key => $meta): ?>
                <option value="<?= h($key) ?>" <?= $reportType === $key ? 'selected' : '' ?>><?= h($meta['title']) ?></option>
              <?php endforeach; ?>
            </select>
          </div>
          <div class="field">
            <label for="report_status">Status filter</label>
            <select id="report_status" name="status" <?= !$report['statuses'] ? 'disabled' : '' ?>>
              <option value="">All statuses</option>
              <?php foreach ($report['statuses'] as $st): ?>
                <option value="<?= h($st) ?>" <?= $report['status'] === $st ? 'selected' : '' ?>><?= h(ucwords(str_replace('_', ' ', $st))) ?></option>
              <?php endforeach; ?>
            </select>
          </div>
        </div>

        <div class="field-row">
          <div class="field">
            <label for="date_from">Date from</label>
            <input type="date" id="date_from" name="date_from" value="<?= h((string) ($report['date_from'] ?? '')) ?>">
          </div>
          <div class="field">
            <label for="date_to">Date to</label>
            <input type="date" id="date_to" name="date_to" value="<?= h((string) ($report['date_to'] ?? '')) ?>">
          </div>
        </div>

        <div class="actions-cell" style="justify-content: space-between; margin-top: 6px;">
          <div class="actions-cell">
            <button type="button" id="report-reset-btn" class="btn btn-ghost">Reset Filters</button>
          </div>
          <div class="actions-cell">
            <a href="<?= h($csvUrl) ?>" id="export-csv-link" class="btn btn-success">⬇ Export CSV</a>
            <a href="<?= h($pdfUrl) ?>" id="export-pdf-link" class="btn btn-danger">📄 Export PDF</a>
          </div>
        </div>
      </form>
    </div>

    <div class="section-title">
      <span id="report-section-title"><?= h($report['title']) ?></span>
      <span id="report-section-meta" style="font-size: 12.5px; font-weight: 500; color: var(--c-text-muted);">
        <?= count($report['rows']) ?> record(s) · Generated <?= h(date('M j, Y g:i A')) ?>
      </span>
    </div>

    <div class="card">
      <div class="data-table-wrap">
        <table class="data-table">
          <thead>
            <tr id="report-table-head">
              <?php foreach ($report['columns'] as $col): ?>
                <th><?= h($col) ?></th>
              <?php endforeach; ?>
            </tr>
          </thead>
          <tbody id="report-table-body">
            <?php if (!$report['rows']): ?>
              <tr class="empty-row"><td colspan="<?= count($report['columns']) ?>">No records match the selected filters.</td></tr>
            <?php endif; ?>
            <?php foreach ($report['rows'] as $row): ?>
              <tr>
                <?php foreach ($row as $idx => $cell): ?>
                  <td><?= $idx === 1 ? '<strong>' . h((string) $cell) . '</strong>' : h((string) $cell) ?></td>
                <?php endforeach; ?>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script>
document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('reports-filter-form');
  const typeSelect = document.getElementById('report_type');
  const statusSelect = document.getElementById('report_status');
  const dateFromInput = document.getElementById('date_from');
  const dateToInput = document.getElementById('date_to');
  const resetBtn = document.getElementById('report-reset-btn');
  const titleEl = document.getElementById('report-section-title');
  const metaEl = document.getElementById('report-section-meta');
  const headRow = document.getElementById('report-table-head');
  const tbody = document.getElementById('report-table-body');
  const csvLink = document.getElementById('export-csv-link');
  const pdfLink = document.getElementById('export-pdf-link');

  let activeController = null;

  const esc = (val) => {
    const s = document.createElement('span');
    s.textContent = val ?? '';
    return s.innerHTML;
  };

  const formatStatusLabel = (st) => st.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());

  const syncStatusesDropdown = (statuses, selectedStatus) => {
    if (!statusSelect) return;
    const opts = ['<option value="">All statuses</option>'];
    (statuses || []).forEach((st) => {
      const sel = st === selectedStatus ? ' selected' : '';
      opts.push(`<option value="${esc(st)}"${sel}>${esc(formatStatusLabel(st))}</option>`);
    });
    statusSelect.innerHTML = opts.join('');
    statusSelect.disabled = !statuses || statuses.length === 0;
  };

  const loadReport = async (resetStatus = false) => {
    if (!form) return;
    if (resetStatus && statusSelect) {
      statusSelect.value = '';
    }

    activeController?.abort();
    activeController = new AbortController();

    const params = new URLSearchParams({
      report_type: typeSelect?.value || 'lost_items',
      status: resetStatus ? '' : (statusSelect?.value || ''),
      date_from: dateFromInput?.value || '',
      date_to: dateToInput?.value || '',
    });

    try {
      const res = await fetch(`reports.php?${params.toString()}&ajax=1`, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        credentials: 'same-origin',
        signal: activeController.signal,
      });
      const data = await res.json();
      if (!data.success) return;

      syncStatusesDropdown(data.statuses, data.status);

      if (titleEl) titleEl.textContent = data.title;
      if (metaEl) metaEl.textContent = `${data.count} record(s) · Generated ${data.generated_at}`;
      if (csvLink) csvLink.href = data.csv_url;
      if (pdfLink) pdfLink.href = data.pdf_url;

      if (headRow) {
        headRow.innerHTML = (data.columns || []).map((col) => `<th>${esc(col)}</th>`).join('');
      }
      if (tbody) {
        if (!data.rows || data.rows.length === 0) {
          const cols = (data.columns || []).length || 1;
          tbody.innerHTML = `<tr class="empty-row"><td colspan="${cols}">No records match the selected filters.</td></tr>`;
        } else {
          tbody.innerHTML = data.rows.map((row) => `<tr>${row.map((cell, idx) => `<td>${idx === 1 ? `<strong>${esc(cell)}</strong>` : esc(cell)}</td>`).join('')}</tr>`).join('');
        }
      }

      window.history.replaceState({}, '', `reports.php?${params.toString()}`);
    } catch (err) {
      if (err.name !== 'AbortError') {
        window.showToast?.('Filter Error', 'Could not refresh report.', 'danger');
      }
    }
  };

  window.refreshReportsLive = () => loadReport(false);

  form?.addEventListener('submit', (e) => {
    e.preventDefault();
    loadReport(false);
  });

  typeSelect?.addEventListener('change', () => loadReport(true));
  statusSelect?.addEventListener('change', () => loadReport(false));
  dateFromInput?.addEventListener('change', () => loadReport(false));
  dateToInput?.addEventListener('change', () => loadReport(false));

  resetBtn?.addEventListener('click', () => {
    if (statusSelect) statusSelect.value = '';
    if (dateFromInput) dateFromInput.value = '';
    if (dateToInput) dateToInput.value = '';
    loadReport(true);
  });
});
</script>
<script src="dashboard.js"></script>
</body>
</html>
