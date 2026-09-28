<?php
declare(strict_types=1);
require_once __DIR__ . '/../database/db.php';

start_session();

// Already signed in? Skip straight to the dashboard.
if (session_id_present('user_id')) {
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
<body class="login-page">

<main class="gateway">
  <div id="auth-particles" class="auth-particles" aria-hidden="true"></div>

  <div class="auth-layout">
    <section class="auth-visual" aria-label="Retrieva lost and found">
      <img src="../assets/icons/login.png" alt="University of Makati campus and a box of found items" onerror="this.hidden=true">
      <div class="auth-visual__overlay">
        <p class="auth-visual__eyebrow">University of Makati</p>
        <h2>Find what matters.<br>Return what’s found.</h2>
        <p>Retrieva connects the UMak community with the things they thought they had lost.</p>
      </div>
    </section>

    <section class="auth-card" aria-labelledby="login-heading">
      <div class="auth-card__brand">
        <img src="../assets/icons/logo.svg" alt="" width="100" height="100">
        <div>
          <strong>RETRIEVA</strong>
          <span>LOST &amp; FOUND SYSTEM</span>
        </div>
      </div>
      <h1 id="login-heading">Welcome Back!</h1>
      <p class="subtitle">Sign in to continue to your account</p>

      <form id="login-form">
        <div class="field">
          <label for="email">Email Address</label>
          <div class="input-wrap">
            <span class="input-icon" aria-hidden="true">&#9993;</span>
            <input type="email" id="email" name="email" placeholder="Enter your email" required autocomplete="username">
          </div>
        </div>
        <div class="field">
          <label for="password">Password</label>
          <div class="input-wrap password-field-wrapper">
            <span class="input-icon" aria-hidden="true">&#128274;</span>
            <input type="password" id="password" name="password" placeholder="Enter your password" required autocomplete="current-password">
            <button type="button" id="toggle-password" class="toggle-password-btn" aria-label="Toggle password visibility">
              <svg id="eye-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>
        </div>
        <div class="login-options">
          <label class="remember-me"><input type="checkbox" name="remember"> <span>Remember me</span></label>
          <a href="forgot-password.php">Forgot Password?</a>
        </div>
        <button type="submit" class="btn btn-primary">Sign In</button>
      </form>

      <div class="divider">or continue with</div>

      <a href="../database/google_oauth_redirect.php" class="btn-oauth">
        <img src="../assets/icons/google-icon.svg" alt=""> Sign in with Google
      </a>

      <p class="auth-card__footer-note">Don’t have an account? <a href="../database/google_oauth_redirect.php">Register here</a></p>
    </section>
  </div>
</main>

<script src="../assets/effects/particles/particles.min.js"></script>
<script src="../assets/effects/particles/auth-particles.js"></script>
<script src="auth.js"></script>
</body>
</html>