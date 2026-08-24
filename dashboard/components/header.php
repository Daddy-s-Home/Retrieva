<?php
/**
 * Expects $user (array) and $avatarSrc (string) from _bootstrap.php,
 * which must be included before this file.
 */
?>
<header class="topbar">
  <button class="topbar__menu-toggle" id="sidebar-toggle" aria-label="Toggle sidebar">☰</button>

  <div class="topbar__search" role="search">
    <span aria-hidden="true">🔎</span>
    <label class="visually-hidden" for="global-search">Search core records</label>
    <input id="global-search" type="search" autocomplete="off" placeholder="Search items or claims…" aria-controls="global-search-results" aria-expanded="false">
    <div id="global-search-results" class="search-results" role="listbox" hidden></div>
  </div>

  <div class="topbar__actions">
    <button class="icon-btn" aria-label="Notifications">
      🔔
      <span class="icon-btn__dot"></span>
    </button>

    <div class="user-menu">
      <button class="user-menu__trigger" id="user-menu-trigger">
        <img src="<?= htmlspecialchars($avatarSrc) ?>" alt="" class="user-menu__avatar">
        <span class="user-menu__text">
          <strong><?= htmlspecialchars($user['full_name']) ?></strong>
          <small><?= htmlspecialchars(role_label($role)) ?></small>
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
