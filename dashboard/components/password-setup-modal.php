<div class="modal-overlay show" id="password-modal-overlay" role="dialog" aria-modal="true" aria-labelledby="password-modal-title">
  <div class="modal-card">
    <div class="modal-card__badge" aria-hidden="true">🔐</div>
    <h2 id="password-modal-title">Set a password for your account</h2>
    <p class="modal-subtitle">
      You signed up with Google. Adding a password lets you sign in even
      when Google isn't available.
    </p>

    <form id="password-setup-form" novalidate>
      <div class="field">
        <label for="ps-password">New password</label>
        <input type="password" id="ps-password" name="password" placeholder="At least 8 characters" required>
      </div>
      <div class="field">
        <label for="ps-confirm">Confirm password</label>
        <input type="password" id="ps-confirm" name="confirm_password" placeholder="Re-type password" required>
      </div>

      <label class="checkbox-row">
        <input type="checkbox" id="ps-skip-next-time">
        Don't ask me again
      </label>

      <div class="modal-actions modal-actions--end">
        <button type="button" class="btn btn-ghost" id="password-modal-later">Later</button>
        <button type="submit" class="btn btn-primary">Save Password</button>
      </div>
    </form>
  </div>
</div>
