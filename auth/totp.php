<?php
declare(strict_types=1);
require_once __DIR__ . '/../database/db.php';

start_session();

// Already fully signed in? Nothing to verify — go straight to the dashboard.
if (session_id_present('user_id')) {
    header('Location: ../dashboard/index.php');
    exit;
}

// No pending login or password-reset challenge? Send them back to start the flow properly.
if (!session_id_present('pending_totp_user_id') && !session_id_present('pending_reset_user_id')) {
    header('Location: login.php');
    exit;
}

$rawPrefill = trim((string) ($_GET['code'] ?? ''));
$prefillDigits = preg_match('/^\d{6}$/', $rawPrefill) ? str_split($rawPrefill) : [];
$factor = ($_SESSION['pending_login_factor'] ?? 'email') === 'totp' ? 'totp' : 'email';
$isReset = session_id_present('pending_reset_user_id');
$canSwitch = !$isReset;
$showResend = $factor === 'email' && !$isReset;
$switchTo = $factor === 'totp' ? 'email' : 'totp';
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Two-Factor Security — Retrieva</title>
<link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
</head>
<body class="login-page">

<main class="gateway">
  <!-- Interactive Background Particles -->
  <div class="auth-particles">
    <canvas id="particle-canvas"></canvas>
  </div>

  <div class="auth-layout" style="grid-template-columns: 1fr; max-width: 480px; min-height: auto;">
    <div class="auth-card">
      <div class="auth-card__brand">
        <img src="../assets/icons/logo.svg" alt="Retrieva Logo" width="36" height="36">
        <div>
          <strong>RETRIEVA</strong>
          <span>LOST & FOUND SYSTEM</span>
        </div>
      </div>

      <h1>Two-Factor Security</h1>
      <p class="subtitle"><?= $factor === 'totp' ? 'Enter the 6-digit code from your authenticator app' : 'Enter the 6-digit verification code sent to your email' ?></p>

      <form id="totp-form">
        <div class="totp-boxes">
          <?php for ($i = 0; $i < 6; $i++): $digit = $prefillDigits[$i] ?? ''; ?>
            <input
              type="text"
              inputmode="numeric"
              maxlength="1"
              aria-label="Digit <?= $i + 1 ?>"
              value="<?= h($digit) ?>"
              class="<?= $digit !== '' ? 'filled' : '' ?>"
              <?= $i === 0 ? 'autofocus' : '' ?>
            >
          <?php endfor; ?>
        </div>

        <?php if ($showResend): ?>
        <p class="totp-resend"><button type="button" class="text-link" id="resend-code">Resend</button></p>
        <?php endif; ?>
        <p class="totp-sync-note" style="margin-top: 14px; margin-bottom: 14px;">⏱ <?= $factor === 'totp' ? 'The authenticator code refreshes every 30 seconds' : 'Code expires in 5 minutes' ?></p>
        <button type="submit" class="btn btn-primary" style="margin-bottom: 10px;">Verify Code</button>
        <button type="button" id="totp-paste-btn" class="btn btn-oauth" style="margin-bottom: 0;">Paste Code</button>
      </form>

      <?php if ($canSwitch): ?>
      <p class="auth-card__footer-note" style="text-align: center; margin-top: 16px;">
        <button type="button" class="text-link" id="switch-factor" data-factor="<?= h($switchTo) ?>"><?= $factor === 'totp' ? 'Use Email OTP for Authentication' : 'Use TOTP for Authentication' ?></button>
      </p>
      <?php endif; ?>

      <p class="auth-card__footer-note" style="text-align: center; margin-top: 16px;">
        <a href="login.php" class="text-link">Back to login</a>
      </p>
    </div>
  </div>

  <p class="gateway__footer">© 2026 Retrieva System. All rights reserved. &nbsp;|&nbsp; UMak Security Division</p>
</main>

<!-- Verification & Loading Modal -->
<div id="totp-modal" class="auth-modal" style="display: none;">
  <div class="auth-modal__overlay"></div>
  <div class="auth-modal__content">
    <div id="modal-spinner" style="margin-bottom: 16px;">
      <div class="spinner-ring"></div>
    </div>
    
    <div id="modal-success-icon" class="auth-modal__badge" style="display: none; background: #ecfdf5; color: #10b981;">
      <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"></path>
      </svg>
    </div>

    <h3 id="modal-title">Verifying Code...</h3>
    <p id="modal-desc" style="margin-bottom: 0;">Authenticating your security session, please wait.</p>
  </div>
</div>

<script src="auth.js?v=<?= filemtime(__DIR__ . '/auth.js') ?>"></script>
</body>
</html>