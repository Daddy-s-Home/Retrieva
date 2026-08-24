<?php
declare(strict_types=1);
require_once __DIR__ . '/../database/db.php';

start_session();

// Already signed in? Skip straight to the dashboard.
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
<title>Sign In — Retrieva</title>
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
    <h1>Welcome back</h1>
    <p class="subtitle">Sign in with your official UMak account</p>

    <form id="login-form">
      <div class="field">
        <label for="email">UMak email</label>
        <input type="email" id="email" name="email" placeholder="juan.delacruz@umak.edu.ph" required autocomplete="username">
      </div>
      <div class="field">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="••••••••" required autocomplete="current-password">
      </div>
      <div class="link-row">
        <a href="forgot-password.php">Forgot password?</a>
      </div>
      <button type="submit" class="btn btn-primary">Sign In</button>
    </form>

    <div class="divider">or continue with</div>

    <!-- Server-side OAuth flow (league/oauth2-google via Composer) —
         this just sends the browser to Google's consent screen. -->
    <a href="../database/google_oauth_redirect.php" class="btn-oauth">
      <img src="../assets/icons/google-icon.svg" alt=""> Continue with Google
    </a>

    <p class="auth-card__footer-note">
      New here? Just sign in with your <img src="../assets/icons/umak-icon.svg" alt="UMak" width="14" height="14" style="display:inline;vertical-align:-2px;"> @umak.edu.ph Google account — an account is created automatically.
    </p>
  </div>

  <p class="gateway__footer">© 2026 Retrieva System. All rights reserved. &nbsp;|&nbsp; UMak Security Division</p>
</main>

<script src="auth.js"></script>
</body>
</html>
