<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';
require_once __DIR__ . '/../../database/client/lib.php';
require_once __DIR__ . '/views.php';
require_once __DIR__ . '/prefetch.php';

if (!role_can($role, RETRIEVA_CLIENT_ROLES)) {
    header('Location: index.php');
    exit;
}

$clientModule = $clientModule ?? 'dashboard';
if (!isset(client_asset_map()[$clientModule])) {
    $clientModule = 'dashboard';
}
$payload = client_module($clientModule, (int) $user['id'], $_GET);
$flash = (string) ($_SESSION['client_flash'] ?? '');
unset($_SESSION['client_flash']);
$unread = client_count('SELECT COUNT(*) FROM notifications WHERE user_id = ? AND read_at IS NULL', [(int) $user['id']]);
$meta = client_asset_map()[$clientModule];
$searchAction = $clientModule === 'dashboard' ? 'client-found-items.php' : $meta['page'];
$searchModule = $clientModule === 'dashboard' ? 'found-items' : $clientModule;
$titles = [
    'dashboard' => 'Dashboard',
    'lost-items' => 'Lost Items',
    'found-items' => 'Found Items',
    'my-reports' => 'My Reports',
    'my-claims' => 'My Claims',
    'notifications' => 'Notifications',
    'settings' => 'Settings',
];
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="csrf-token" content="<?= h(csrf_token()) ?>">
<title><?= h($titles[$clientModule]) ?> — Retrieva</title>
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
<link rel="stylesheet" href="client/client.css">
<link rel="stylesheet" href="photo-picker.css">
<link rel="stylesheet" href="item-photo-gallery.css">
<link rel="stylesheet" href="<?= h($meta['css']) ?>">
<?php client_prefetch_head($clientModule); ?>
</head>
<body class="client-shell" data-page="<?= h($clientModule) ?>" data-role="<?= h($role) ?>">
<aside class="sidebar client-sidebar" id="dashboard-sidebar">
  <div class="sidebar__brand client-brand">
    <img src="../assets/icons/logo.png" alt="" width="36" height="36">
    <span><strong>Retrieva</strong><small>University of Makati<br>Lost &amp; Found System</small></span>
    <button class="sidebar__close" id="sidebar-close" type="button" aria-controls="dashboard-sidebar" aria-label="Close navigation menu">×</button>
  </div>
  <nav class="sidebar__nav" aria-label="Client">
    <?php
    $nav = [
        'dashboard' => ['client-dashboard.php', 'home', 'Dashboard'],
        'lost-items' => ['client-lost-items.php', 'search', 'Lost Items'],
        'found-items' => ['client-found-items.php', 'box', 'Found Items'],
        'my-reports' => ['client-my-reports.php', 'report', 'My Reports'],
        'my-claims' => ['client-my-claims.php', 'shield', 'My Claims'],
        'notifications' => ['client-notifications.php', 'bell', 'Notifications'],
        'settings' => ['client-settings.php', 'gear', 'Settings'],
    ];
    foreach ($nav as $id => [$href, $icon, $label]):
    ?>
      <a class="nav-item client-nav<?= $id === $clientModule ? ' active' : '' ?>" href="<?= h($href) ?>" data-module="<?= h($id) ?>">
        <?= client_icon($icon) ?>
        <span><?= h($label) ?></span>
        <?php if ($id === 'notifications' && $unread > 0): ?><span class="nav-badge"><?= $unread ?></span><?php endif; ?>
      </a>
    <?php endforeach; ?>
  </nav>
  <div class="sidebar__footer">
    <img src="../assets/icons/umak-icon.svg" alt="" width="28" height="28">
    <span>University of Makati<br><small>A Safe and Honest Campus Starts with You.</small></span>
  </div>
</aside>
<div class="main-col">
  <header class="topbar client-topbar">
    <button class="topbar__menu-toggle" id="sidebar-toggle" type="button" aria-controls="dashboard-sidebar" aria-expanded="false" aria-label="Open navigation menu">☰</button>
    <form class="topbar__search" id="client-search-form" method="get" action="<?= h($searchAction) ?>" data-search-module="<?= h($searchModule) ?>" role="search">
      <label class="visually-hidden" for="client-search"><?= h($meta['search']) ?></label>
      <input id="client-search" type="search" name="q" placeholder="<?= h($meta['search']) ?>">
    </form>
    <div class="topbar__actions">
      <a class="icon-btn" href="client-notifications.php" aria-label="Notifications"><?= client_icon('bell') ?><?php if ($unread > 0): ?><span class="icon-btn__dot"></span><?php endif; ?></a>
      <div class="user-menu">
        <button class="user-menu__trigger" id="user-menu-trigger" type="button">
          <img src="<?= h($avatarSrc) ?>" alt="" class="user-menu__avatar">
          <span class="user-menu__text">
            <strong><?= h($user['full_name']) ?></strong>
            <small><?= h(role_label($role)) ?><?= !empty($user['student_id']) ? ' · ' . h((string) $user['student_id']) : '' ?></small>
          </span>
        </button>
        <div class="user-menu__dropdown" id="user-menu-dropdown">
          <a href="client-settings.php#account" class="user-menu__item">Account</a>
          <a href="client-settings.php" class="user-menu__item">Settings</a>
          <button class="user-menu__item user-menu__item--danger" id="logout-btn" type="button">Log out</button>
        </div>
      </div>
      <div class="client-clock">
        <span data-local-date>Loading date…</span>
        <strong data-local-time>--:--</strong>
      </div>
    </div>
  </header>
  <main id="client-module" class="client-module module-<?= h($clientModule) ?>">
    <?php if ($flash !== ''): ?><div class="alert alert-error" role="status"><?= h($flash) ?></div><?php endif; ?>
    <?= $payload['html'] ?>
  </main>
</div>
<div id="client-drawer" class="client-drawer" hidden>
  <button class="client-drawer__backdrop" type="button" data-close-drawer aria-label="Close details"></button>
  <div class="client-drawer__panel" role="dialog" aria-modal="true" aria-labelledby="drawer-title">
    <button class="btn btn-ghost" type="button" data-close-drawer>Close</button>
    <div id="client-drawer-body"></div>
  </div>
</div>
<?= dashboard_photo_gallery_dialog() ?>
<?php
if ($role === 'student' && empty($user['student_id'])) {
    include __DIR__ . '/../components/student-id-modal.php';
} elseif ($user['auth_provider'] === 'google' && !$user['password_is_set'] && !$user['skip_password_prompt']) {
    include __DIR__ . '/../components/password-setup-modal.php';
}
?>
<script src="dashboard.js"></script>
<script src="photo-picker.js"></script>
<script src="client/qrcode.js"></script>
<script src="client/client.js"></script>
<script src="item-photo-gallery.js"></script>
<script src="<?= h($meta['js']) ?>"></script>
</body>
</html>
