<?php
declare(strict_types=1);

$currentPage = 'pickup-verification';
require_once __DIR__ . '/_bootstrap.php';
require_role_page(['admin', 'security']);

$db = get_db();

$pickups = $db->query(
    'SELECT p.id, p.qr_token, p.scanned_at, p.created_at,
            f.item_name, f.category, f.location_found,
            u.full_name AS claimant_name, u.student_id,
            v.full_name AS verified_by_name
     FROM pickups p
     JOIN claims c ON c.id = p.claim_id
     JOIN found_items f ON f.id = c.found_item_id
     JOIN users u ON u.id = c.claimant_id
     LEFT JOIN users v ON v.id = p.verified_by
     ORDER BY (p.scanned_at IS NULL) DESC, p.scanned_at DESC, p.created_at DESC
     LIMIT 30'
)->fetchAll();

$csrfToken = csrf_token();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>QR Pickup Verification — Retrieva</title>
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
      <h1>QR Pickup Verification</h1>
      <p>Scan a claimant's single-use pickup QR code with your camera or enter the token manually.</p>
    </div>

    <div class="pickup-grid">
      <section class="card">
        <div class="card__header">
          <h3>📷 Camera QR Scanner</h3>
          <span id="scanner-status" class="pill pill--gray">Camera Idle</span>
        </div>

        <div class="qr-controls">
          <button type="button" id="start-scan-btn" class="btn btn-primary">Start Camera</button>
          <button type="button" id="stop-scan-btn" class="btn btn-ghost" disabled>Stop Camera</button>
          <select id="camera-select" class="qr-camera-select" aria-label="Select camera" hidden></select>
        </div>

        <div id="qr-reader" class="qr-reader-box">
          <div class="qr-reader-placeholder">
            <span>📷</span>
            <p>Click <strong>Start Camera</strong> to scan a pickup QR code.</p>
          </div>
        </div>

        <form id="manual-qr-form" class="qr-manual-form">
          <label for="manual-qr-token">Manual QR Token Fallback</label>
          <div class="qr-manual-row">
            <input
              type="text"
              id="manual-qr-token"
              name="qr_token"
              maxlength="64"
              placeholder="Paste 64-character hex QR token"
              autocomplete="off"
              required
            >
            <button type="submit" class="btn btn-gold">Verify Token</button>
          </div>
        </form>
      </section>

      <section class="card">
        <div class="card__header">
          <h3>Verification Result</h3>
        </div>
        <div id="verify-result" class="qr-result-empty">
          <p>Scan a QR code or submit a token to verify item release.</p>
        </div>
      </section>
    </div>

    <div class="section-title">Pickup Queue &amp; Recent Verifications</div>
    <div class="card">
      <div class="data-table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>Item</th>
              <th>Claimant</th>
              <th>Status</th>
              <th>Verified By</th>
              <th>Scanned At</th>
            </tr>
          </thead>
          <tbody id="pickups-table-body">
            <?php if (!$pickups): ?>
              <tr class="empty-row"><td colspan="5">No approved pickups queued yet.</td></tr>
            <?php endif; ?>
            <?php foreach ($pickups as $p): ?>
              <tr>
                <td>
                  <strong><?= h($p['item_name']) ?></strong><br>
                  <small><?= h($p['category']) ?> · <?= h($p['location_found']) ?></small>
                </td>
                <td>
                  <?= h($p['claimant_name']) ?>
                  <?php if (!empty($p['student_id'])): ?>
                    <br><small><?= h($p['student_id']) ?></small>
                  <?php endif; ?>
                </td>
                <td>
                  <?php if ($p['scanned_at']): ?>
                    <span class="pill pill--green">Picked Up</span>
                  <?php else: ?>
                    <span class="pill pill--amber">Awaiting Pickup</span>
                  <?php endif; ?>
                </td>
                <td><?= h($p['verified_by_name'] ?? '—') ?></td>
                <td><?= $p['scanned_at'] ? h(date('M j, Y g:i A', strtotime($p['scanned_at']))) : '—' ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<script src="dashboard.js"></script>
<script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  const CSRF_TOKEN = <?= json_encode($csrfToken) ?>;
  const startBtn = document.getElementById('start-scan-btn');
  const stopBtn = document.getElementById('stop-scan-btn');
  const cameraSelect = document.getElementById('camera-select');
  const statusEl = document.getElementById('scanner-status');
  const readerEl = document.getElementById('qr-reader');
  const resultEl = document.getElementById('verify-result');
  const manualForm = document.getElementById('manual-qr-form');
  const manualInput = document.getElementById('manual-qr-token');

  let html5Qr = null;
  let isScanning = false;
  let isVerifying = false;
  let lastScannedToken = '';

  function setStatus(text, pillClass) {
    if (!statusEl) return;
    statusEl.textContent = text;
    statusEl.className = 'pill ' + pillClass;
  }

  function renderResult(ok, title, message, pickup = null) {
    if (!resultEl) return;
    const esc = (v) => String(v ?? '').replace(/[&<>"']/g, (c) => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    })[c]);

    if (!ok) {
      resultEl.innerHTML = `
        <div class="alert alert-error" style="margin:0;">
          <strong>${esc(title)}</strong><br>
          <span>${esc(message)}</span>
        </div>`;
      return;
    }

    const sid = pickup?.student_id ? ` (${esc(pickup.student_id)})` : '';
    resultEl.innerHTML = `
      <div class="alert alert-success" style="margin-bottom:14px;">
        <strong>${esc(title)}</strong> — ${esc(message)}
      </div>
      <dl class="qr-result-meta">
        <div><dt>Item</dt><dd>${esc(pickup?.item_name)}</dd></div>
        <div><dt>Category</dt><dd>${esc(pickup?.category)}</dd></div>
        <div><dt>Location Found</dt><dd>${esc(pickup?.location_found)}</dd></div>
        <div><dt>Claimant</dt><dd>${esc(pickup?.claimant_name)}${sid}</dd></div>
        <div><dt>Verified At</dt><dd>${esc(pickup?.verified_at)}</dd></div>
      </dl>`;
  }

  async function verifyToken(token) {
    const clean = token.trim().toLowerCase();
    if (!clean || isVerifying) return;
    isVerifying = true;
    setStatus('Verifying…', 'pill--blue');

    try {
      const res = await fetch('../database/verify_pickup_qr.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ qr_token: clean, csrf_token: CSRF_TOKEN })
      });
      const data = await res.json();
      if (res.ok && data.success) {
        renderResult(true, 'Pickup Verified', data.message, data.pickup);
        setStatus('Verified', 'pill--green');
        if (isScanning) {
          await stopCamera();
        }
        setTimeout(() => window.location.reload(), 1800);
      } else {
        renderResult(false, 'Verification Failed', data.message || 'Unable to verify QR code.');
        setStatus(isScanning ? 'Scanning' : 'Camera Idle', isScanning ? 'pill--blue' : 'pill--gray');
      }
    } catch {
      renderResult(false, 'Network Error', 'Could not reach verification endpoint.');
      setStatus(isScanning ? 'Scanning' : 'Camera Idle', isScanning ? 'pill--blue' : 'pill--gray');
    } finally {
      isVerifying = false;
    }
  }

  async function startCamera(cameraId = null) {
    if (typeof Html5Qrcode === 'undefined') {
      renderResult(false, 'Scanner Unavailable', 'QR scanner library failed to load. Use the manual token input.');
      return;
    }

    if (isScanning) {
      await stopCamera();
    }

    readerEl.innerHTML = '';
    html5Qr = new Html5Qrcode('qr-reader');

    try {
      const devices = await Html5Qrcode.getCameras();
      if (devices && devices.length > 0 && cameraSelect) {
        cameraSelect.innerHTML = devices.map((d, idx) =>
          `<option value="${d.id}">${d.label || 'Camera ' + (idx + 1)}</option>`
        ).join('');
        cameraSelect.hidden = devices.length <= 1;
        if (cameraId) cameraSelect.value = cameraId;
      }

      const target = cameraId || (devices && devices.length > 0 ? { facingMode: 'environment' } : { facingMode: 'environment' });
      await html5Qr.start(
        target,
        { fps: 10, qrbox: { width: 240, height: 240 } },
        (decodedText) => {
          if (decodedText && decodedText !== lastScannedToken) {
            lastScannedToken = decodedText;
            verifyToken(decodedText);
          }
        },
        () => {}
      );

      isScanning = true;
      startBtn.disabled = true;
      stopBtn.disabled = false;
      setStatus('Scanning', 'pill--blue');
    } catch (err) {
      renderResult(false, 'Camera Error', 'Could not access camera. Check browser permissions or use manual token fallback.');
      setStatus('Camera Error', 'pill--red');
      readerEl.innerHTML = '<div class="qr-reader-placeholder"><span>📷</span><p>Camera unavailable. Use manual token input below.</p></div>';
    }
  }

  async function stopCamera() {
    if (html5Qr && isScanning) {
      try {
        await html5Qr.stop();
        html5Qr.clear();
      } catch {}
    }
    isScanning = false;
    lastScannedToken = '';
    startBtn.disabled = false;
    stopBtn.disabled = true;
    setStatus('Camera Idle', 'pill--gray');
    readerEl.innerHTML = '<div class="qr-reader-placeholder"><span>📷</span><p>Click <strong>Start Camera</strong> to scan a pickup QR code.</p></div>';
  }

  startBtn?.addEventListener('click', () => startCamera(cameraSelect && !cameraSelect.hidden ? cameraSelect.value : null));
  stopBtn?.addEventListener('click', stopCamera);
  cameraSelect?.addEventListener('change', () => {
    if (isScanning) startCamera(cameraSelect.value);
  });

  manualForm?.addEventListener('submit', (e) => {
    e.preventDefault();
    if (manualInput) verifyToken(manualInput.value);
  });
});
</script>
</body>
</html>
