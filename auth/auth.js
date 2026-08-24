/**
 * auth.js — shared front-end logic for the auth module.
 * Talks to the PHP endpoints in /database/*.php.
 * Each page (login.php, totp.php, forgot-password.php) calls into
 * whichever of these it needs; unused functions are simply unused.
 */

const API = '../database';

function showToast(message, type = '') {
  let toast = document.querySelector('.toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.className = 'toast';
    document.body.appendChild(toast);
  }
  toast.textContent = message;
  toast.className = `toast show ${type ? 'toast-' + type : ''}`;
  clearTimeout(toast._timer);
  toast._timer = setTimeout(() => toast.classList.remove('show'), 3200);
}

async function postJSON(url, body) {
  try {
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'same-origin',
      body: JSON.stringify(body),
    });
    const data = await res.json().catch(() => ({ success: false, message: 'Unexpected server response.' }));
    return { ok: res.ok, ...data };
  } catch (err) {
    return { ok: false, success: false, message: 'Network error — check that XAMPP/Apache is running.' };
  }
}

/* ---------------------------------------------------------------------
   LOGIN PAGE (login.php)
--------------------------------------------------------------------- */
function initLoginForm() {
  const form = document.getElementById('login-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = form.email.value.trim();
    const password = form.password.value;
    const btn = form.querySelector('button[type="submit"]');

    if (!email || !password) {
      showToast('Email and password are required.', 'error');
      return;
    }

    if (!email.endsWith('@umak.edu.ph')) {
      showToast('Please use your official @umak.edu.ph email.', 'error');
      return;
    }

    btn.disabled = true;
    btn.textContent = 'Signing in…';

    const res = await postJSON(`${API}/login.php`, { email, password });

    btn.disabled = false;
    btn.textContent = 'Sign In';

    if (res.success) {
      sessionStorage.setItem('retrieva_totp_purpose', 'login');
      window.location.href = 'totp.php';
    } else {
      showToast(res.message || 'Sign in failed.', 'error');
    }
  });
}

/* Google sign-in now happens via a full-page redirect to
   database/google_oauth_redirect.php (league/oauth2-google on the
   server side) — see initLoginForm below for the ?error= toast. */

/* ---------------------------------------------------------------------
   TOTP PAGE (totp.php) — used for both login 2FA and password reset
--------------------------------------------------------------------- */
function initTotpForm() {
  const boxes = document.querySelectorAll('.totp-boxes input');
  if (!boxes.length) return;

  const submitBtn = document.getElementById('totp-submit');
  const purpose = sessionStorage.getItem('retrieva_totp_purpose') || 'login';

  const getCode = () => Array.from(boxes).map((b) => b.value).join('');

  const updateState = () => {
    const code = getCode();
    boxes.forEach((b) => b.classList.toggle('filled', b.value !== ''));
    submitBtn.disabled = code.length !== 6;
    return code;
  };

  boxes.forEach((box, i) => {
    box.addEventListener('input', () => {
      box.value = box.value.replace(/\D/g, '').slice(0, 1);
      box.classList.remove('error');
      if (box.value && boxes[i + 1]) boxes[i + 1].focus();
      const code = updateState();
      // Auto-submit the moment all 6 digits are present.
      if (code.length === 6) submitCode(code);
    });
    box.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && !box.value && boxes[i - 1]) {
        boxes[i - 1].focus();
      }
    });
    box.addEventListener('paste', (e) => {
      e.preventDefault();
      const digits = (e.clipboardData.getData('text').match(/\d/g) || []).slice(0, 6);
      digits.forEach((d, idx) => { if (boxes[idx]) boxes[idx].value = d; });
      const code = updateState();
      if (code.length === 6) submitCode(code);
    });
  });

  async function submitCode(code) {
    submitBtn.disabled = true;
    submitBtn.textContent = 'Verifying…';

    const res = await postJSON(`${API}/totp_verify.php`, { code, purpose });

    if (res.success) {
      showToast('Verified!', 'success');
      window.location.href = res.redirect || '../dashboard/index.php';
    } else {
      boxes.forEach((b) => { b.classList.add('error'); b.value = ''; });
      boxes[0].focus();
      submitBtn.textContent = 'Verify Security Key';
      showToast(res.message || 'Incorrect code.', 'error');
      updateState();
    }
  }

  document.getElementById('totp-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const code = getCode();
    if (code.length === 6) submitCode(code);
  });

  boxes[0].focus();
}

/* ---------------------------------------------------------------------
   FORGOT PASSWORD PAGE (forgot-password.php) — 3 steps, one page:
   1) enter email  2) enter TOTP  3) new password + confirm
--------------------------------------------------------------------- */
function initForgotPasswordFlow() {
  const root = document.getElementById('forgot-password-flow');
  if (!root) return;

  const steps = Array.from(root.querySelectorAll('.step'));
  const dots = Array.from(root.querySelectorAll('.step-indicator span'));

  function goToStep(stepName) {
    steps.forEach((s) => s.classList.toggle('active', s.dataset.step === stepName));
    const idx = steps.findIndex((s) => s.dataset.step === stepName);
    dots.forEach((d, i) => {
      d.classList.toggle('active', i === idx);
      d.classList.toggle('done', i < idx);
    });
  }

  // Deep-link support: totp_verify.php redirects here with ?step=reset
  const params = new URLSearchParams(window.location.search);
  if (params.get('step') === 'reset') goToStep('reset');
  else goToStep('email');

  // -- Step 1: email --
  const emailForm = document.getElementById('fp-email-form');
  emailForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = emailForm.email.value.trim();
    const btn = emailForm.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.textContent = 'Sending…';

    const res = await postJSON(`${API}/forgot_password.php`, { email });

    btn.disabled = false;
    btn.textContent = 'Send Code';

    // Always advance — the endpoint never reveals whether the email exists.
    showToast(res.message || 'Check your email for a code.', 'success');
    sessionStorage.setItem('retrieva_totp_purpose', 'password_reset');
    goToStep('code');
  });

  // -- Step 2: TOTP code --
  const codeForm = document.getElementById('fp-code-form');
  const codeBoxes = codeForm.querySelectorAll('input');
  codeBoxes.forEach((box, i) => {
    box.addEventListener('input', () => {
      box.value = box.value.replace(/\D/g, '').slice(0, 1);
      if (box.value && codeBoxes[i + 1]) codeBoxes[i + 1].focus();
    });
    box.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && !box.value && codeBoxes[i - 1]) codeBoxes[i - 1].focus();
    });
  });
  codeForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const code = Array.from(codeBoxes).map((b) => b.value).join('');
    if (code.length !== 6) { showToast('Enter all 6 digits.', 'error'); return; }

    const res = await postJSON(`${API}/totp_verify.php`, { code, purpose: 'password_reset' });
    if (res.success) {
      goToStep('reset');
    } else {
      codeBoxes.forEach((b) => { b.classList.add('error'); b.value = ''; });
      showToast(res.message || 'Incorrect code.', 'error');
    }
  });

  // -- Step 3: new password + confirm --
  const resetForm = document.getElementById('fp-reset-form');
  resetForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const password = resetForm.password.value;
    const confirm = resetForm.confirm_password.value;

    if (password.length < 8) { showToast('Password must be at least 8 characters.', 'error'); return; }
    if (password !== confirm) { showToast('Passwords do not match.', 'error'); return; }

    const btn = resetForm.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.textContent = 'Saving…';

    const res = await postJSON(`${API}/save_password.php`, {
      password,
      confirm_password: confirm,
    });

    btn.disabled = false;
    btn.textContent = 'Confirm New Password';

    if (res.success) {
      showToast('Password updated — please sign in again.', 'success');
      setTimeout(() => { window.location.href = 'login.php'; }, 1200);
    } else {
      showToast(res.message || 'Could not update password.', 'error');
    }
  });
}

/* ---------------------------------------------------------------------
   Surfaces ?error= from google_oauth_callback.php redirects on login.php
--------------------------------------------------------------------- */
function initOAuthErrorToast() {
  const params = new URLSearchParams(window.location.search);
  const error = params.get('error');
  if (!error) return;

  const messages = {
    oauth_state: 'Sign-in session expired — please try again.',
    oauth_denied: 'Google sign-in was cancelled.',
    oauth_failed: 'Could not complete Google sign-in.',
    domain_not_allowed: 'Only @umak.edu.ph accounts are allowed.',
    blocked: 'This account has been blocked. Contact the security office.',
  };
  showToast(messages[error] || 'Google sign-in failed.', 'error');

  // Clean the URL so a refresh doesn't re-show the toast.
  window.history.replaceState({}, '', window.location.pathname);
}

document.addEventListener('DOMContentLoaded', () => {
  initLoginForm();
  initTotpForm();
  initForgotPasswordFlow();
  initOAuthErrorToast();
});
