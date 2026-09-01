<?php
declare(strict_types=1);
require_once __DIR__ . '/../database/db.php';

start_session();

if (!empty($_SESSION['user_id'])) {
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
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
</head>
<body>

<main class="gateway">
  <div class="gateway__badge">Secure Campus Gateway</div>

  <div class="auth-card" id="forgot-password-flow">
    <div class="auth-card__brand">
      <img src="../assets/icons/logo.svg" alt="" width="32" height="32">
      <span>Retrieva</span>
    </div>

    <div class="step-indicator">
      <span class="active"></span><span></span><span></span>
    </div>

    <!-- STEP 1: email -->
    <section class="step active" data-step="email">
      <h1>Reset your password</h1>
      <p class="subtitle">Enter your UMak email to receive a code</p>
      <form id="fp-email-form" novalidate>
        <div class="field">
          <label for="fp-email">UMak email</label>
          <input type="email" id="fp-email" name="email" placeholder="juan.delacruz@umak.edu.ph" required>
        </div>
        <button type="submit" class="btn btn-primary">Send Code</button>
      </form>
      <p class="auth-card__footer-note"><a href="login.php" class="text-link">Back to sign in</a></p>
    </section>

    <!-- STEP 2: totp code -->
    <section class="step" data-step="code">
      <h1>Check your email</h1>
      <p class="subtitle">Enter the 6-digit code we just sent you</p>
      <form id="fp-code-form">
        <div class="totp-boxes">
          <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 1">
          <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 2">
          <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 3">
          <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 4">
          <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 5">
          <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 6">
        </div>
        <button type="submit" class="btn btn-primary">Verify Code</button>
      </form>
    </section>

    <!-- STEP 3: new password + confirm -->
    <section class="step" data-step="reset">
      <h1>Set a new password</h1>
      <p class="subtitle">Choose something you haven't used before</p>
      <form id="fp-reset-form" novalidate>
        <div class="field">
          <label for="fp-new-pw">New password</label>
          <input type="password" id="fp-new-pw" name="password" placeholder="At least 8 characters" required>
        </div>
        <div class="field">
          <label for="fp-confirm-pw">Confirm new password</label>
          <input type="password" id="fp-confirm-pw" name="confirm_password" placeholder="Re-type password" required>
        </div>
        <button type="submit" class="btn btn-primary">Confirm New Password</button>
      </form>
    </section>
  </div>

  <p class="gateway__footer">© 2026 Retrieva System. All rights reserved. &nbsp;|&nbsp; UMak Security Division</p>
</main>

<script src="auth.js"></script>
</body>
</html>