function bindClientSettings() {
  const passwordFeedback = document.getElementById('password-feedback');

  async function readJson(response) {
    const text = await response.text();
    if (!text) return { success: false, message: 'The server returned an empty response.' };
    try {
      return JSON.parse(text);
    } catch (error) {
      return { success: false, message: 'The server could not complete that action.' };
    }
  }

  function tell(message, type) {
    if (passwordFeedback) passwordFeedback.textContent = message;
    if (typeof window.showToast === 'function') window.showToast(message, type);
  }

  function bindPassword(form, url, reloadOnSuccess) {
    if (!form || form.dataset.bound) return;
    form.dataset.bound = '1';
    form.addEventListener('submit', async (event) => {
      event.preventDefault();
      const button = form.querySelector('[type="submit"]');
      const fields = new FormData(form);
      const password = String(fields.get('password') || '');
      const confirmPassword = String(fields.get('confirm_password') || '');
      if (password.length < 8) {
        tell('Password must be at least 8 characters.', 'error');
        return;
      }
      if (password !== confirmPassword) {
        tell('Passwords do not match.', 'error');
        return;
      }
      if (button) button.disabled = true;
      try {
        const body = { password: password, confirm_password: confirmPassword };
        if (fields.has('current_password')) body.current_password = fields.get('current_password');
        const response = await fetch(url, {
          method: 'POST',
          credentials: 'same-origin',
          headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
          body: JSON.stringify(body),
        });
        const result = await readJson(response);
        if (result.success) {
          const message = result.message || 'Password saved.';
          if (reloadOnSuccess) {
            try {
              sessionStorage.setItem('retrieva_toast', JSON.stringify({ message: message, type: 'success' }));
            } catch (error) {
              tell(message, 'success');
            }
            window.location.reload();
            return;
          }
          form.reset();
          tell(message, 'success');
        } else {
          tell(result.message || 'Password update failed.', 'error');
        }
      } catch (error) {
        tell('Password update failed.', 'error');
      }
      if (button) button.disabled = false;
    });
  }

  bindPassword(document.getElementById('create-password-form'), '../database/save_password.php', true);
  bindPassword(document.getElementById('change-password-form'), '../database/change_password.php', false);

  const loginNote = document.getElementById('login-method-note');
  document.querySelectorAll('input[name="login_method"]').forEach((input) => {
    if (input.dataset.bound) return;
    input.dataset.bound = '1';
    input.addEventListener('change', () => {
      if (loginNote) loginNote.hidden = input.value !== 'totp' || !input.checked;
    });
  });

  const totpFeedback = document.getElementById('totp-feedback');
  const startButton = document.getElementById('totp-start-btn');
  const disableButton = document.getElementById('totp-disable-btn');
  const setupPanel = document.getElementById('totp-setup-panel');
  const secretInput = document.getElementById('totp-secret');
  async function totp(body) {
    const response = await fetch('../database/setup_totp.php', {
      method: 'POST',
      credentials: 'same-origin',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body: JSON.stringify(body),
    });
    return readJson(response);
  }
  if (secretInput && !secretInput.dataset.copyBound) {
    secretInput.dataset.copyBound = '1';
    secretInput.addEventListener('click', async () => {
      if (!secretInput.value) return;
      try { await navigator.clipboard.writeText(secretInput.value); } catch (error) { secretInput.select(); }
      if (typeof window.showToast === 'function') window.showToast('Setup key copied.', 'success');
    });
  }
  if (startButton && !startButton.dataset.bound) {
    startButton.dataset.bound = '1';
    startButton.addEventListener('click', async () => {
      const result = await totp({ action: 'start' });
      if (!result.success) {
        totpFeedback.textContent = result.message || 'Could not start setup.';
        if (typeof window.showToast === 'function') window.showToast(totpFeedback.textContent, 'error');
        return;
      }
      secretInput.value = result.secret;
      setupPanel.hidden = false;
      const box = document.getElementById('totp-qr');
      if (box && window.QRCode) {
        box.replaceChildren();
        const email = setupPanel?.dataset.email || '';
        const uri = 'otpauth://totp/' + encodeURIComponent('Retrieva:' + email) + '?secret=' + encodeURIComponent(result.secret) + '&issuer=Retrieva';
        new window.QRCode(box, { text: uri, width: 160, height: 160 });
      }
      startButton.hidden = true;
    });
  }
  const verifyForm = document.getElementById('totp-verify-form');
  if (verifyForm && !verifyForm.dataset.bound) {
    verifyForm.dataset.bound = '1';
    verifyForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      const code = document.getElementById('totp-code').value.trim();
      const result = await totp({ action: 'verify', code });
      totpFeedback.textContent = result.message || 'Could not verify the code.';
      if (typeof window.showToast === 'function') window.showToast(totpFeedback.textContent, result.success ? 'success' : 'error');
      if (!result.success) return;
      setupPanel.hidden = true;
      disableButton.hidden = false;
    });
  }
  if (disableButton && !disableButton.dataset.bound) {
    disableButton.dataset.bound = '1';
    disableButton.addEventListener('click', async () => {
      if (!window.confirm('Disable authenticator protection for this account?')) return;
      const result = await totp({ action: 'disable' });
      totpFeedback.textContent = result.message || 'Could not disable authenticator.';
      if (typeof window.showToast === 'function') window.showToast(totpFeedback.textContent, result.success ? 'success' : 'error');
      if (!result.success) return;
      disableButton.hidden = true;
      startButton.hidden = false;
    });
  }
}

document.addEventListener('retrieva:paint', (event) => {
  if (event.detail.module === 'settings') bindClientSettings();
});
