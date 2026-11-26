const SETTINGS_API = '../database';
async function settingsPost(endpoint, body) {
  try { const response = await fetch(`${SETTINGS_API}/${endpoint}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, credentials: 'same-origin', body: JSON.stringify(body) }); return await response.json(); }
  catch { return { success: false, message: 'Network error. Please try again.' }; }
}
function setFeedback(element, message, success = false) { element.textContent = message; element.className = `settings-feedback ${success ? 'is-success' : 'is-error'}`; }
function bindAdminSettings() {
  const passwordForm = document.getElementById('change-password-form'); const passwordFeedback = document.getElementById('password-feedback');
  if (!passwordForm || passwordForm.dataset.bound === '1') return;
  passwordForm.dataset.bound = '1';
  const newPasswordInput = document.getElementById('new-password-input');
  const pwCriteriaList = document.getElementById('pw-criteria');
  const passwordRules = {
    length: (v) => v.length >= 8,
    upper: (v) => /[A-Z]/.test(v),
    lower: (v) => /[a-z]/.test(v),
    number: (v) => /\d/.test(v),
    special: (v) => /[^A-Za-z0-9]/.test(v),
  };
  const updatePasswordChecklist = (value) => {
    if (!pwCriteriaList) return value.length >= 8;
    let allMet = true;
    pwCriteriaList.querySelectorAll('li[data-rule]').forEach((li) => {
      const rule = passwordRules[li.dataset.rule];
      const met = rule ? rule(value) : false;
      li.classList.toggle('is-met', met);
      const icon = li.querySelector('.pw-icon');
      if (icon) icon.textContent = met ? '✓' : '✕';
      if (!met) allMet = false;
    });
    return allMet;
  };
  newPasswordInput?.addEventListener('input', () => updatePasswordChecklist(newPasswordInput.value));
  passwordForm?.addEventListener('submit', async (event) => {
    event.preventDefault(); const button = passwordForm.querySelector('button[type="submit"]'); const fields = new FormData(passwordForm); const password = String(fields.get('password') || ''); const confirmPassword = String(fields.get('confirm_password') || '');
    if (!updatePasswordChecklist(password)) return setFeedback(passwordFeedback, 'Password does not meet all security criteria.'); if (password !== confirmPassword) return setFeedback(passwordFeedback, 'Passwords do not match.');
    button.disabled = true; const result = await settingsPost('change_password.php', { current_password: fields.get('current_password'), password, confirm_password: confirmPassword }); button.disabled = false; setFeedback(passwordFeedback, result.message || 'Password update failed.', result.success); if (result.success) { passwordForm.reset(); updatePasswordChecklist(''); }
  });
  const loginMethodForm = document.getElementById('login-method-form');
  const loginNote = document.getElementById('login-method-note');
  const loginFeedback = document.getElementById('login-method-feedback');
  loginMethodForm?.querySelectorAll('input[name="login_method"]').forEach((input) => {
    input.addEventListener('change', () => { if (loginNote) loginNote.hidden = input.value !== 'totp' || !input.checked; });
  });
  loginMethodForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const button = loginMethodForm.querySelector('button[type="submit"]');
    const selected = loginMethodForm.querySelector('input[name="login_method"]:checked');
    button.disabled = true;
    const result = await settingsPost('save_login_method.php', { login_method: selected ? selected.value : 'email' });
    button.disabled = false;
    setFeedback(loginFeedback, result.message || 'Sign-in method could not be saved.', result.success);
  });
  const startButton = document.getElementById('totp-start-btn'); const setupPanel = document.getElementById('totp-setup-panel'); const secretInput = document.getElementById('totp-secret'); const totpFeedback = document.getElementById('totp-feedback'); const disableButton = document.getElementById('totp-disable-btn'); const status = document.getElementById('totp-status');
  function showSetupKey(secret) {
    secretInput.value = secret;
    setupPanel.hidden = false;
    const box = document.getElementById('totp-qr');
    if (box && window.QRCode) {
      box.replaceChildren();
      const email = setupPanel?.dataset.email || '';
      const uri = 'otpauth://totp/' + encodeURIComponent('Retrieva:' + email) + '?secret=' + encodeURIComponent(secret) + '&issuer=Retrieva';
      new window.QRCode(box, { text: uri, width: 160, height: 160 });
    }
  }
  secretInput?.addEventListener('click', async () => {
    if (!secretInput.value) return;
    try { await navigator.clipboard.writeText(secretInput.value); } catch (error) { secretInput.select(); }
    setFeedback(totpFeedback, 'Setup key copied.', true);
  });
  startButton?.addEventListener('click', async () => { startButton.disabled = true; const result = await settingsPost('setup_totp.php', { action: 'start' }); startButton.disabled = false; if (!result.success) return setFeedback(totpFeedback, result.message || 'Could not start setup.'); showSetupKey(result.secret); startButton.hidden = true; setFeedback(totpFeedback, 'Setup key generated. Verify a code to enable it.', true); });
  document.getElementById('totp-verify-form')?.addEventListener('submit', async (event) => { event.preventDefault(); const codeInput = document.getElementById('totp-code'); const code = codeInput.value.trim(); if (!/^\d{6}$/.test(code)) return setFeedback(totpFeedback, 'Enter the six-digit authenticator code.'); const result = await settingsPost('setup_totp.php', { action: 'verify', code }); if (!result.success) return setFeedback(totpFeedback, result.message || 'Could not verify the code.'); status.classList.add('is-enabled'); status.querySelector('strong').textContent = 'Authenticator enabled'; status.querySelector('span').textContent = 'Your account has a verified authenticator secret.'; setupPanel.hidden = true; disableButton.hidden = false; setFeedback(totpFeedback, result.message, true); });
  const disableModal = document.getElementById('totp-disable-modal');
  const disableCancelBtn = document.getElementById('totp-disable-cancel');
  const disableConfirmBtn = document.getElementById('totp-disable-confirm');

  const closeDisableModal = () => disableModal?.classList.remove('show');

  disableButton?.addEventListener('click', () => {
    if (disableModal) {
      disableModal.classList.add('show');
      disableCancelBtn?.focus();
    } else if (window.confirm('Disable authenticator protection for this account?')) {
      disableConfirmBtn?.click();
    }
  });

  disableCancelBtn?.addEventListener('click', closeDisableModal);
  disableModal?.addEventListener('click', (event) => {
    if (event.target === disableModal) closeDisableModal();
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && disableModal?.classList.contains('show')) closeDisableModal();
  });

  disableConfirmBtn?.addEventListener('click', async () => {
    disableConfirmBtn.disabled = true;
    const result = await settingsPost('setup_totp.php', { action: 'disable' });
    disableConfirmBtn.disabled = false;
    closeDisableModal();
    if (!result.success) return setFeedback(totpFeedback, result.message || 'Could not disable authenticator.');
    status.classList.remove('is-enabled');
    status.querySelector('strong').textContent = 'Authenticator not set up';
    status.querySelector('span').textContent = 'Generate a secret, then confirm a current code.';
    disableButton.hidden = true;
    startButton.hidden = false;
    setFeedback(totpFeedback, result.message, true);
  });
}
document.addEventListener('DOMContentLoaded', bindAdminSettings);
document.addEventListener('retrieva:paint', (event) => {
  if (!event.detail || event.detail.module === 'settings') bindAdminSettings();
});
