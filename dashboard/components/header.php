<?php
/** 
 * @var array  $user
 * @var string $avatarSrc
 * @var string $role
 */

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$pendingNotif = $_SESSION['pending_notif'] ?? null;
if ($pendingNotif) {
    unset($_SESSION['pending_notif']);
}
?>
<header class="topbar">
  <button class="topbar__menu-toggle" id="sidebar-toggle" type="button" aria-controls="dashboard-sidebar" aria-expanded="false" aria-label="Open navigation menu">☰</button>

  <?php if (($currentPage ?? '') === 'dashboard'): ?>
  <div class="topbar__search" role="search">
    <span aria-hidden="true">🔎</span>
    <label class="visually-hidden" for="global-search">Search core records</label>
    <input id="global-search" type="search" autocomplete="off" placeholder="Search items or claims…" aria-controls="global-search-results" aria-expanded="false">
    <div id="global-search-results" class="search-results" role="listbox" hidden></div>
  </div>
  <?php endif; ?>

  <div class="topbar__actions">
    <div class="notif-wrapper" style="position: relative;">
      <button class="icon-btn" id="notif-bell-btn" aria-label="Notifications" aria-expanded="false">
        🔔
        <span class="icon-btn__dot" id="notif-badge" style="display: none;">0</span>
      </button>

      <div id="notif-dropdown" class="notif-dropdown" hidden>
        <div class="notif-dropdown__header">
          <strong>Notifications</strong>
          <button id="notif-clear-btn" class="notif-dropdown__clear">Clear all</button>
        </div>
        <div id="notif-list" class="notif-dropdown__list" aria-live="polite">
          <div class="notif-empty">No new notifications</div>
        </div>
      </div>
    </div>

    <div class="user-menu">
      <button class="user-menu__trigger" id="user-menu-trigger">
        <img src="<?= htmlspecialchars($avatarSrc ?? '../assets/images/default-avatar.svg') ?>" 
             referrerpolicy="no-referrer"
             onerror="this.onerror=null; this.src='../assets/images/default-avatar.svg';"
             alt="<?= htmlspecialchars(($user['full_name'] ?? 'User')) ?>'s avatar" 
             class="user-menu__avatar">
        <span class="user-menu__text">
          <strong><?= htmlspecialchars($user['full_name'] ?? '') ?></strong>
          <small><?= htmlspecialchars(function_exists('role_label') ? role_label($role ?? '') : ($role ?? '')) ?></small>
        </span>
        <span class="user-menu__caret">▾</span>
      </button>

      <div class="user-menu__dropdown" id="user-menu-dropdown">
        <a href="settings.php#profile" class="user-menu__item">👤 Profile overview</a>
        <a href="settings.php" class="user-menu__item">⚙️ Settings</a>
        <button class="user-menu__item user-menu__item--danger" id="logout-btn">↩️ Log out</button>
      </div>
    </div>
  </div>
</header>

<div id="toast-container" class="toast-container"></div>

<div class="modal-overlay" id="confirm-action-modal" role="dialog" aria-modal="true" aria-labelledby="confirm-action-title">
  <div class="modal-card">
    <div class="modal-card__badge modal-card__badge--danger" aria-hidden="true">🗑️</div>
    <h2 id="confirm-action-title">Confirm Action</h2>
    <p class="modal-subtitle" id="confirm-action-message">Are you sure you want to proceed?</p>
    <div class="modal-actions modal-actions--end">
      <button type="button" class="btn btn-ghost" id="confirm-action-cancel">Cancel</button>
      <button type="button" class="btn btn-danger" id="confirm-action-submit">Confirm</button>
    </div>
  </div>
</div>

<!-- Pusher Client Library -->
<script>window.RETRIEVA_USER_ID = <?= isset($user['id']) ? (int)$user['id'] : 'null' ?>;</script>
<script src="https://js.pusher.com/8.2.0/pusher.min.js"></script>
<?php if ($pendingNotif): ?>
<script>
document.addEventListener('DOMContentLoaded', () => {
  if (typeof window.addNotification === 'function') {
    window.addNotification(
      <?= json_encode($pendingNotif['title'] ?? 'Notification') ?>,
      <?= json_encode($pendingNotif['message'] ?? '') ?>,
      <?= json_encode($pendingNotif['type'] ?? 'info') ?>
    );
  }
});
</script>
<?php endif; ?>