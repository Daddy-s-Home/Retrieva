<?php
declare(strict_types=1);

require_once __DIR__ . '/../database/db.php';
require_once __DIR__ . '/../database/recaptcha_config.php';
start_session();

// Already signed in? Skip straight to the dashboard.
if (session_id_present('user_id')) {
    header('Location: ../dashboard/index.php');
    exit;
}

$login_error = (string) ($_SESSION['login_error'] ?? '');
unset($_SESSION['login_error']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign In — Retrieva</title>
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

      <?php if (!empty($login_error)): ?>
        <div class="alert alert-danger" role="alert" style="color: var(--c-danger, #d9534f); margin-bottom: 12px; font-size: 13px;">
          <?= h($login_error) ?>
        </div>
      <?php endif; ?>

      <form id="login-form" action="../database/login.php" method="POST">
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
          <label class="remember-me">
            <input type="checkbox" id="remember-me-checkbox" name="remember"> 
            <span>Remember Me</span>
          </label>
          <a href="forgot-password.php">Forgot Password?</a>
        </div>
        
        <div id="lockout-banner" class="lockout-banner" style="display: none;">
          <div class="lockout-banner__header">
            <span class="lockout-banner__icon">🔒</span>
            <div class="lockout-banner__titles">
              <strong>Security Cooldown Active</strong>
              <p>Multiple failed attempts detected. System locked for protection.</p>
            </div>
          </div>
          <div class="lockout-banner__timer-row">
            <span class="lockout-banner__hint">Time remaining before retry:</span>
            <span id="lockout-timer-clock" class="lockout-banner__clock">15:00</span>
          </div>
          <div class="lockout-banner__bar">
            <div id="lockout-progress" class="lockout-banner__progress" style="width: 100%;"></div>
          </div>
        </div>

        <div class="recaptcha-wrap">
          <div class="g-recaptcha" data-sitekey="<?= h(RECAPTCHA_SITE_KEY) ?>"></div>
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

<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<script src="../assets/effects/particles/particles.min.js"></script>
<script src="../assets/effects/particles/auth-particles.js"></script>
<script src="auth.js"></script>
</body>
</html>