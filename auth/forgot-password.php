<?php
declare(strict_types=1);
require_once __DIR__ . '/../database/db.php';
require_once __DIR__ . '/../database/recaptcha_config.php';

start_session();

if (has_session_id('user_id')) {
    header('Location: ../dashboard/index.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password — Retrieva</title>
<link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
</head>
<body class="login-page">

<main class="gateway">
  <div id="auth-particles" class="auth-particles" aria-hidden="true"></div>

  <div class="auth-layout">
    <section class="auth-visual" aria-label="Retrieva lost and found">
      <img src="../assets/icons/login.png" alt="University of Makati campus and a box of found items" onerror="this.hidden=true">
      <div class="auth-visual__overlay">
        <p class="auth-visual__eyebrow">University of Makati</p>
        <h2>Account Recovery.<br>Restoring Access.</h2>
        <p>Safely regain access to your Retrieva account to manage lost and found reports.</p>
      </div>
    </section>

    <section class="auth-card" id="forgot-password-flow" aria-labelledby="fp-heading">
      <div class="auth-card__brand">
        <img src="../assets/icons/logo.svg" alt="" width="100" height="100">
        <div>
          <strong>RETRIEVA</strong>
          <span>LOST &amp; FOUND SYSTEM</span>
        </div>
      </div>

      <!-- Step Indicator Bar -->
      <div class="step-indicator" aria-label="Progress steps">
        <span class="active"></span>
        <span></span>
        <span></span>
      </div>

      <!-- STEP 1: Email Address -->
      <section class="step active" data-step="email">
        <h1 id="fp-heading">Reset Password</h1>
        <p class="subtitle">Enter your registered email address to receive a 6-digit security code.</p>
        
        <form id="fp-email-form" novalidate>
          <div class="field">
            <label for="fp-email">Email Address</label>
            <div class="input-wrap">
              <span class="input-icon" aria-hidden="true">&#9993;</span>
              <input type="email" id="fp-email" name="email" placeholder="Enter your @umak.edu.ph email" required autocomplete="username">
            </div>
          </div>
          <div class="recaptcha-wrap">
            <div class="g-recaptcha" data-sitekey="<?= h(RECAPTCHA_SITE_KEY) ?>"></div>
          </div>
          <button type="submit" class="btn btn-primary">Send Security Code</button>
        </form>
        
        <p class="auth-card__footer-note">Remembered your credentials? <a href="login.php">Back to Sign In</a></p>
      </section>

      <!-- STEP 2: TOTP Verification Code -->
      <section class="step" data-step="code">
        <h1>Verify Identity</h1>
        <p class="subtitle">Enter the 6-digit verification code sent to your inbox.</p>
        
        <form id="fp-code-form">
          <div class="totp-boxes">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 1" autofocus>
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 2">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 3">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 4">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 5">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 6">
          </div>
          <button type="submit" class="btn btn-primary">Verify Code</button>
          <a href="login.php" class="btn btn-oauth" style="margin-top: 10px; text-decoration: none; color: var(--c-text);">Back to Sign In</a>
        </form>

        <p class="auth-card__footer-note" style="text-align: center;">Didn’t receive a code? <a href="forgot-password.php" class="text-link">Resend email</a></p>
      </section>

      <!-- STEP 3: New Password Creation -->
      <section class="step" data-step="reset">
        <h1>Set New Password</h1>
        <p class="subtitle">Create a strong, unique password for your account.</p>
        
        <form id="fp-reset-form" novalidate>
          <div class="field">
            <label for="fp-new-pw">New Password</label>
            <div class="input-wrap password-field-wrapper">
              <span class="input-icon" aria-hidden="true">&#128274;</span>
              <input type="password" id="fp-new-pw" name="password" placeholder="At least 8 characters" required autocomplete="new-password">
            </div>
          </div>
          
          <div class="field">
            <label for="fp-confirm-pw">Confirm New Password</label>
            <div class="input-wrap password-field-wrapper">
              <span class="input-icon" aria-hidden="true">&#128274;</span>
              <input type="password" id="fp-confirm-pw" name="confirm_password" placeholder="Re-enter new password" required autocomplete="new-password">
            </div>
          </div>
          
          <button type="submit" class="btn btn-primary">Confirm New Password</button>
        </form>
      </section>
    </section>
  </div>
</main>

<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<script src="../assets/effects/particles/particles.min.js"></script>
<script src="../assets/effects/particles/auth-particles.js"></script>
<script src="auth.js"></script>
</body>
</html>