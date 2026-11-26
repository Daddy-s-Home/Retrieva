/**
 * auth.js — shared front-end logic for the auth module.
 * Talks to the PHP endpoints in /database/*.php.
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
   PASSWORD VISIBILITY TOGGLE (AUTO-HIDE AFTER 5 SECONDS)
--------------------------------------------------------------------- */
function initPasswordVisibilityToggle() {
  const toggleBtn = document.getElementById('toggle-password');
  const passwordInput = document.getElementById('password');
  const eyeIcon = document.getElementById('eye-icon');

  if (!toggleBtn || !passwordInput || !eyeIcon) return;

  let hideTimeout = null;

  const showEyeIcon = () => {
    eyeIcon.innerHTML = `
      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
      <circle cx="12" cy="12" r="3"></circle>
    `;
  };

  const showEyeOffIcon = () => {
    eyeIcon.innerHTML = `
      <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
      <line x1="1" y1="1" x2="23" y2="23"></line>
    `;
  };

  const hidePassword = () => {
    passwordInput.type = 'password';
    showEyeIcon();
    if (hideTimeout) {
      clearTimeout(hideTimeout);
      hideTimeout = null;
    }
  };

  toggleBtn.addEventListener('click', () => {
    if (toggleBtn.disabled) return;
    const isPassword = passwordInput.type === 'password';

    if (hideTimeout) clearTimeout(hideTimeout);

    if (isPassword) {
      passwordInput.type = 'text';
      showEyeOffIcon();

      hideTimeout = setTimeout(() => {
        hidePassword();
      }, 5000);
    } else {
      hidePassword();
    }
  });

  passwordInput.addEventListener('blur', hidePassword);
}

/* ---------------------------------------------------------------------
   LOGIN PAGE (login.php)
--------------------------------------------------------------------- */
function initLoginForm() {
  const form = document.getElementById('login-form');
  if (!form) return;

  const emailInput = form.email;
  const passwordInput = form.password;
  const rememberCheckbox = form.remember;
  const toggleBtn = document.getElementById('toggle-password');

  const modal = document.getElementById('lockout-modal');
  const modalMsg = document.getElementById('modal-message');
  const modalCloseBtn = document.getElementById('modal-close-btn');

  const lockoutBanner = document.getElementById('lockout-banner');
  const lockoutClock = document.getElementById('lockout-timer-clock');
  const lockoutProgress = document.getElementById('lockout-progress');

  function showLockoutModal(message) {
    if (!modal) return;
    if (modalMsg && message) modalMsg.textContent = message;
    modal.style.display = 'flex';
    modal.setAttribute('aria-hidden', 'false');
  }

  if (modalCloseBtn && modal) {
    modalCloseBtn.addEventListener('click', () => {
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');
    });
  }

  // -- PRE-FILL LOGIC: Check localStorage for saved email --
  const savedEmail = localStorage.getItem('retrieva_remembered_email');
  if (savedEmail && emailInput) {
    emailInput.value = savedEmail;
    if (rememberCheckbox) {
      rememberCheckbox.checked = true;
    }

    emailInput.dispatchEvent(new Event('input', { bubbles: true }));
    emailInput.dispatchEvent(new Event('change', { bubbles: true }));
  }

  let lockoutInterval = null;

  function clearAndDisableInputs() {
    if (emailInput) {
      emailInput.value = '';
      emailInput.disabled = true;
    }
    if (passwordInput) {
      passwordInput.value = '';
      passwordInput.type = 'password';
      passwordInput.disabled = true;
    }
    if (toggleBtn) {
      toggleBtn.disabled = true;
      toggleBtn.style.opacity = '0.4';
      toggleBtn.style.pointerEvents = 'none';
    }
  }

  function enableInputs() {
    if (emailInput) emailInput.disabled = false;
    if (passwordInput) passwordInput.disabled = false;
    if (toggleBtn) {
      toggleBtn.disabled = false;
      toggleBtn.style.opacity = '1';
      toggleBtn.style.pointerEvents = 'auto';
    }
  }

  function startLockoutTimer(seconds) {
    const btn = form.querySelector('button[type="submit"]');

    clearAndDisableInputs();
    btn.disabled = true;
    btn.textContent = 'Sign In';

    if (lockoutBanner) lockoutBanner.style.display = 'block';

    clearInterval(lockoutInterval);

    const totalDuration = seconds;
    let remaining = seconds;

    const updateUI = () => {
      const mins = Math.floor(remaining / 60);
      const secs = remaining % 60;
      const formattedTime = `${mins}:${secs < 10 ? '0' : ''}${secs}`;

      if (lockoutClock) lockoutClock.textContent = formattedTime;
      if (lockoutProgress) {
        const percent = Math.max(0, (remaining / totalDuration) * 100);
        lockoutProgress.style.width = `${percent}%`;
      }
    };

    updateUI();

    lockoutInterval = setInterval(() => {
      remaining -= 1;
      if (remaining <= 0) {
        clearInterval(lockoutInterval);
        enableInputs();
        btn.disabled = false;
        btn.textContent = 'Sign In';

        if (lockoutBanner) lockoutBanner.style.display = 'none';

        showToast('Lockout period ended. You may attempt to sign in again.', 'success');
      } else {
        updateUI();
      }
    }, 1000);
  }

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = emailInput.value.trim();
    const password = passwordInput.value;
    const btn = form.querySelector('button[type="submit"]');

    if (!email || !password) {
      showToast('Email and password are required.', 'error');
      return;
    }

    if (!email.endsWith('@umak.edu.ph')) {
      showToast('Please use your official @umak.edu.ph email.', 'error');
      return;
    }

    const recaptchaToken = typeof grecaptcha !== 'undefined' ? grecaptcha.getResponse() : '';
    if (!recaptchaToken) {
      showToast('Please complete the reCAPTCHA verification.', 'error');
      return;
    }

    const rememberMe = rememberCheckbox ? rememberCheckbox.checked : false;

    if (rememberMe) {
      localStorage.setItem('retrieva_remembered_email', email);
    } else {
      localStorage.removeItem('retrieva_remembered_email');
    }

    btn.disabled = true;
    btn.textContent = 'Signing in…';

    const res = await postJSON(`${API}/login.php`, { email, password, remember: rememberMe, recaptcha_token: recaptchaToken });

    if (res.locked) {
      const lockoutMsg = res.message || 'Multiple failed attempts detected. Your account access is temporarily restricted.';
      if (typeof grecaptcha !== 'undefined') grecaptcha.reset();
      startLockoutTimer(res.remaining_seconds || 900);
      showLockoutModal(lockoutMsg);
      return;
    }

    btn.disabled = false;
    btn.textContent = 'Sign In';

    if (res.success) {
      sessionStorage.setItem('retrieva_totp_purpose', 'login');
      window.location.href = 'totp.php';
    } else {
      if (typeof grecaptcha !== 'undefined') grecaptcha.reset();
      showToast(res.message || 'Sign in failed.', 'error');
    }
  });
}

/* ---------------------------------------------------------------------
   TOTP PAGE (totp.php)
--------------------------------------------------------------------- */
function initTotpForm() {
  const totpForm = document.getElementById('totp-form');
  if (!totpForm) return;

  const boxes = document.querySelectorAll('.totp-boxes input');
  if (!boxes.length) return;

  const modal = document.getElementById('totp-modal');
  const modalSpinner = document.getElementById('modal-spinner');
  const modalSuccessIcon = document.getElementById('modal-success-icon');
  const modalTitle = document.getElementById('modal-title');
  const modalDesc = document.getElementById('modal-desc');

  const purpose = sessionStorage.getItem('retrieva_totp_purpose') || 'login';

  const getCode = () => Array.from(boxes).map((b) => b.value).join('');

  const updateState = () => {
    const code = getCode();
    boxes.forEach((b) => b.classList.toggle('filled', b.value !== ''));
    return code;
  };

  const showLoadingModal = () => {
    if (!modal) return;
    if (modalSpinner) modalSpinner.style.display = 'block';
    if (modalSuccessIcon) modalSuccessIcon.style.display = 'none';
    if (modalTitle) modalTitle.textContent = 'Verifying Code...';
    if (modalDesc) modalDesc.textContent = 'Authenticating your security session, please wait.';
    modal.style.display = 'flex';
  };

  const showSuccessModal = () => {
    if (!modal) return;
    if (modalSpinner) modalSpinner.style.display = 'none';
    if (modalSuccessIcon) modalSuccessIcon.style.display = 'flex';
    if (modalTitle) modalTitle.textContent = 'Verification Successful!';
    if (modalDesc) modalDesc.textContent = 'Redirecting to the dashboard...';
  };

  const hideModal = () => {
    if (modal) modal.style.display = 'none';
  };

  boxes.forEach((box, i) => {
    box.addEventListener('input', () => {
      box.value = box.value.replace(/\D/g, '').slice(0, 1);
      box.classList.remove('error');
      if (box.value && boxes[i + 1]) boxes[i + 1].focus();
      const code = updateState();
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
    boxes.forEach((b) => b.blur());
    showLoadingModal();

    const res = await postJSON(`${API}/totp_verify.php`, { code, purpose });

    if (res.success) {
      showSuccessModal();
      setTimeout(() => {
        window.location.href = res.redirect || '../dashboard/index.php';
      }, 800);
    } else {
      hideModal();
      boxes.forEach((b) => { b.classList.add('error'); b.value = ''; });
      boxes[0].focus();
      showToast(res.message || 'Incorrect code.', 'error');
      updateState();
    }
  }

  totpForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const code = getCode();
    if (code.length === 6) submitCode(code);
  });

  const fillCode = (raw, autoSubmit = false) => {
    const digits = (String(raw || '').match(/\d/g) || []).slice(0, 6);
    if (!digits.length) return false;
    digits.forEach((d, idx) => { if (boxes[idx]) boxes[idx].value = d; });
    const code = updateState();
    if (autoSubmit && code.length === 6) {
      submitCode(code);
    } else if (code.length === 6) {
      totpForm.querySelector('button[type="submit"]')?.focus();
    }
    return true;
  };

  document.getElementById('totp-paste-btn')?.addEventListener('click', async () => {
    try {
      const clip = await navigator.clipboard.readText();
      if (!fillCode(clip, false)) showToast('No 6-digit code found in clipboard.', 'error');
    } catch {
      showToast('Clipboard access blocked. Paste directly into the boxes.', 'error');
    }
  });

  document.getElementById('resend-code')?.addEventListener('click', async (event) => {
    const button = event.currentTarget;
    button.disabled = true;
    const res = await postJSON(`${API}/switch_login_factor.php`, { factor: 'email' });
    button.disabled = false;
    showToast(res.success ? 'A new code was sent to your email.' : (res.message || 'The code could not be sent.'), res.success ? 'success' : 'error');
  });

  document.getElementById('switch-factor')?.addEventListener('click', async (event) => {
    const button = event.currentTarget;
    button.disabled = true;
    const res = await postJSON(`${API}/switch_login_factor.php`, { factor: button.dataset.factor });
    if (res.success) {
      window.location.reload();
      return;
    }
    button.disabled = false;
    showToast(res.message || 'That sign-in code is not available.', 'error');
  });

  const urlCode = new URLSearchParams(window.location.search).get('code');
  if (urlCode && /^\d{6}$/.test(urlCode.trim())) {
    fillCode(urlCode.trim(), false);
  } else {
    boxes[0].focus();
  }
}

/* ---------------------------------------------------------------------
   FORGOT PASSWORD PAGE (forgot-password.php)
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

  const params = new URLSearchParams(window.location.search);
  if (params.get('step') === 'reset') goToStep('reset');
  else goToStep('email');

  // -- Step 1: email --
  const emailForm = document.getElementById('fp-email-form');
  if (emailForm) {
    emailForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const email = emailForm.email.value.trim();
      const btn = emailForm.querySelector('button[type="submit"]');

      if (!email) {
        showToast('Please enter your email.', 'error');
        return;
      }

      const recaptchaToken = typeof grecaptcha !== 'undefined' ? grecaptcha.getResponse() : '';
      if (!recaptchaToken) {
        showToast('Please complete the reCAPTCHA verification.', 'error');
        return;
      }

      btn.disabled = true;
      btn.textContent = 'Sending…';

      const res = await postJSON(`${API}/forgot_password.php`, { email, recaptcha_token: recaptchaToken });

      btn.disabled = false;
      btn.textContent = 'Send Security Code';

      if (!res.success) {
        if (typeof grecaptcha !== 'undefined') grecaptcha.reset();
        showToast(res.message || 'reCAPTCHA verification failed.', 'error');
        return;
      }

      showToast(res.message || 'Check your email for a code.', 'success');
      sessionStorage.setItem('retrieva_totp_purpose', 'password_reset');
      goToStep('code');
    });
  }

  // -- Step 2: TOTP code --
  const codeForm = document.getElementById('fp-code-form');
  if (codeForm) {
    const codeBoxes = codeForm.querySelectorAll('input');
    codeBoxes.forEach((box, i) => {
      box.addEventListener('input', () => {
        box.value = box.value.replace(/\D/g, '').slice(0, 1);
        if (box.value && codeBoxes[i + 1]) codeBoxes[i + 1].focus();
      });
      box.addEventListener('keydown', (e) => {
        if (e.key === 'Backspace' && !box.value && codeBoxes[i - 1]) codeBoxes[i - 1].focus();
      });
      box.addEventListener('paste', (e) => {
        e.preventDefault();
        const digits = (e.clipboardData.getData('text').match(/\d/g) || []).slice(0, 6);
        digits.forEach((d, idx) => { if (codeBoxes[idx]) codeBoxes[idx].value = d; });
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
  }

  // -- Step 3: new password + confirm --
  const resetForm = document.getElementById('fp-reset-form');
  if (resetForm) {
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
}

/* ---------------------------------------------------------------------
   OAUTH ERROR TOAST
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

  window.history.replaceState({}, '', window.location.pathname);
}

document.addEventListener('DOMContentLoaded', () => {
  initPasswordVisibilityToggle();
  initLoginForm();
  initTotpForm();
  initForgotPasswordFlow();
  initOAuthErrorToast();
});