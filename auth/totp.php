<?php
declare(strict_types=1);
require_once __DIR__ . '/../database/db.php';

start_session();
// #region agent log
file_put_contents('C:/xampp/htdocs/debug-5b3ba5.log', json_encode(['sessionId'=>'5b3ba5','hypothesisId'=>'A','location'=>'totp.php:gate','message'=>'pending sign-in gate','data'=>['pendingId'=>$_SESSION['pending_totp_user_id'] ?? null,'pendingEmpty'=>empty($_SESSION['pending_totp_user_id']),'userId'=>$_SESSION['user_id'] ?? null,'userEmpty'=>empty($_SESSION['user_id'])],'timestamp'=>(int) round(microtime(true)*1000)])."\n", FILE_APPEND);
// #endregion

// Already fully signed in? Nothing to verify — go straight to the dashboard.
if (session_id_present('user_id')) {
    header('Location: ../dashboard/index.php');
    exit;
}

// No pending login or password-reset challenge? There's nothing to type a
// code for — send them back to start the flow properly.
if (!session_id_present('pending_totp_user_id') && !session_id_present('pending_reset_user_id')) {
    header('Location: login.php');
    exit;
}
// #region agent log
file_put_contents('C:/xampp/htdocs/debug-5b3ba5.log', json_encode(['sessionId'=>'5b3ba5','runId'=>'post-fix','hypothesisId'=>'A','location'=>'totp.php:gate','message'=>'pending sign-in allowed','data'=>['pendingId'=>$_SESSION['pending_totp_user_id'] ?? null],'timestamp'=>(int) round(microtime(true)*1000)])."\n", FILE_APPEND);
// #endregion
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
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
</head>
<body>

<main class="gateway">
  <div class="gateway__badge">Secure Campus Gateway</div>

  <div class="auth-card">
    <div class="auth-card__brand">
      <img src="../assets/icons/logo.svg" alt="" width="32" height="32">
      <span>Retrieva</span>
    </div>
    <h1>Two-Factor Security</h1>
    <p class="subtitle"><?= $factor === 'totp' ? 'Enter the 6-digit code from your authenticator app' : 'Enter the 6-digit code from your email' ?></p>

    <form id="totp-form">
      <div class="totp-boxes">
        <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 1">
        <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 2">
        <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 3">
        <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 4">
        <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 5">
        <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 6">
      </div>
      <?php if ($showResend): ?>
      <p class="totp-resend"><button type="button" class="text-link" id="resend-code">Resend</button></p>
      <?php endif; ?>
      <p class="totp-sync-note"><?= $factor === 'totp' ? 'The authenticator code refreshes every 30 seconds' : 'Code expires in 5 minutes' ?></p>
      <button type="submit" id="totp-submit" class="btn btn-primary" disabled>Verify Security Key</button>
    </form>
    <?php if ($canSwitch): ?>
    <p class="auth-card__footer-note"><button type="button" class="text-link" id="switch-factor" data-factor="<?= h($switchTo) ?>"><?= $factor === 'totp' ? 'Use Email OTP for Authentication' : 'Use TOTP for Authentication' ?></button></p>
    <?php endif; ?>

    <p class="auth-card__footer-note">
      <a href="login.php" class="text-link">I don't have access to this code</a>
    </p>
  </div>

  <p class="gateway__footer">© 2026 Retrieva System. All rights reserved. &nbsp;|&nbsp; UMak Security Division</p>
</main>

<script src="auth.js"></script>
</body>
</html>
