const SETTINGS_API = '../database';
async function settingsPost(endpoint, body) {
  try { const response = await fetch(`${SETTINGS_API}/${endpoint}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, credentials: 'same-origin', body: JSON.stringify(body) }); return await response.json(); }
  catch { return { success: false, message: 'Network error. Please try again.' }; }
}
function setFeedback(element, message, success = false) { element.textContent = message; element.className = `settings-feedback ${success ? 'is-success' : 'is-error'}`; }
document.addEventListener('DOMContentLoaded', () => {
  const passwordForm = document.getElementById('change-password-form'); const passwordFeedback = document.getElementById('password-feedback');
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
    let allMet = true;
    pwCriteriaList?.querySelectorAll('li[data-rule]').forEach((li) => {
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
  const startButton = document.getElementById('totp-start-btn'); const setupPanel = document.getElementById('totp-setup-panel'); const secretInput = document.getElementById('totp-secret'); const totpFeedback = document.getElementById('totp-feedback'); const disableButton = document.getElementById('totp-disable-btn'); const status = document.getElementById('totp-status');
  startButton?.addEventListener('click', async () => { startButton.disabled = true; const result = await settingsPost('setup_totp.php', { action: 'start' }); startButton.disabled = false; if (!result.success) return setFeedback(totpFeedback, result.message || 'Could not start setup.'); secretInput.value = result.secret; setupPanel.hidden = false; startButton.hidden = true; secretInput.focus(); secretInput.select(); setFeedback(totpFeedback, 'Setup key generated. Verify a code to enable it.', true); });
  document.getElementById('totp-verify-form')?.addEventListener('submit', async (event) => { event.preventDefault(); const codeInput = document.getElementById('totp-code'); const code = codeInput.value.trim(); if (!/^\d{6}$/.test(code)) return setFeedback(totpFeedback, 'Enter the six-digit authenticator code.'); const result = await settingsPost('setup_totp.php', { action: 'verify', code }); if (!result.success) return setFeedback(totpFeedback, result.message || 'Could not verify the code.'); status.classList.add('is-enabled'); status.querySelector('strong').textContent = 'Authenticator enabled'; status.querySelector('span').textContent = 'Your account has a verified authenticator secret.'; setupPanel.hidden = true; disableButton.hidden = false; setFeedback(totpFeedback, result.message, true); });
  const disableModal = document.getElementById('totp-disable-modal');
  const disableCancelBtn = document.getElementById('totp-disable-cancel');
  const disableConfirmBtn = document.getElementById('totp-disable-confirm');

  const closeDisableModal = () => disableModal?.classList.remove('show');

  disableButton?.addEventListener('click', () => {
    disableModal?.classList.add('show');
    disableCancelBtn?.focus();
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
});
