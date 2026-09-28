<?php
declare(strict_types=1);

require_once __DIR__ . '/../_bootstrap.php';
require_once __DIR__ . '/../../database/admin/lib.php';
require_once __DIR__ . '/prefetch.php';
require_once __DIR__ . '/../client/views.php';

if (!role_is_admin_side($role)) {
    header('Location: client-dashboard.php');
    exit;
}

$adminModule = $adminModule ?? 'dashboard';
if (!isset(admin_asset_map()[$adminModule])) {
    $adminModule = 'dashboard';
}
$payload = admin_module($adminModule, (int) $user['id'], $_GET);
$flash = (string) ($_SESSION['admin_flash'] ?? '');
unset($_SESSION['admin_flash']);
$pendingClaims = client_count("SELECT COUNT(*) FROM claims WHERE status IN ('pending', 'manual_review')");
$now = new DateTime('now', new DateTimeZone('Asia/Manila'));
$meta = admin_asset_map()[$adminModule];
$searchModule = $adminModule === 'dashboard' || $adminModule === 'log-found' ? 'found-items' : $adminModule;
$searchAction = admin_asset_map()[$searchModule]['page'];
$titles = [
    'dashboard' => 'Dashboard',
    'lost-reports' => 'Lost Reports',
    'found-items' => 'Found Items',
    'log-found' => 'Log Found Item',
    'matching' => 'Matching Center',
    'claims' => 'Claims',
    'pickup' => 'QR Pickup Verification',
    'returned' => 'Returned Items',
    'users' => 'Users',
    'reports' => 'Reports & Analytics',
    'audit' => 'Audit Logs',
    'settings' => 'Settings',
];
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="csrf-token" content="<?= h(csrf_token()) ?>">
<title><?= h($titles[$adminModule]) ?> — Retrieva</title>
<link rel="stylesheet" href="../assets/theme.css">
<link rel="stylesheet" href="styles.css">
<link rel="stylesheet" href="client/client.css">
<link rel="stylesheet" href="admin/admin.css">
<link rel="stylesheet" href="<?= h($meta['css']) ?>">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4"></script>
<?php admin_prefetch_head($adminModule); ?>
</head>
<body class="client-shell admin-shell" data-page="<?= h($adminModule) ?>" data-role="<?= h($role) ?>">
<aside class="sidebar client-sidebar">
  <div class="sidebar__brand client-brand">
    <img src="../assets/icons/logo.svg" alt="" width="36" height="36">
    <span><strong>Retrieva</strong><small>University of Makati<br>Lost &amp; Found System</small></span>
  </div>
  <nav class="sidebar__nav" aria-label="Admin">
    <?php
    $nav = [
        'dashboard' => ['index.php', 'home', 'Dashboard'],
        'lost-reports' => ['admin-lost-reports.php', 'search', 'Lost Reports'],
        'found-items' => ['admin-found-items.php', 'box', 'Found Items'],
        'log-found' => ['admin-log-found.php', 'plus', 'Log Found Item'],
        'matching' => ['admin-matching.php', 'shield', 'Matching Center'],
        'claims' => ['admin-claims.php', 'report', 'Claims'],
        'pickup' => ['admin-pickup.php', 'check', 'QR Pickup Verification'],
        'returned' => ['admin-returned.php', 'box', 'Returned Items'],
        'users' => ['admin-users.php', 'home', 'Users'],
        'reports' => ['admin-reports.php', 'report', 'Reports & Analytics'],
        'audit' => ['admin-audit.php', 'shield', 'Audit Logs'],
        'settings' => ['settings.php', 'gear', 'Settings'],
    ];
    foreach ($nav as $id => [$href, $icon, $label]):
    ?>
      <a class="nav-item client-nav<?= $id === $adminModule ? ' active' : '' ?>" href="<?= h($href) ?>" data-module="<?= h($id) ?>">
        <?= client_icon($icon) ?>
        <span><?= h($label) ?></span>
        <?php if ($id === 'claims' && $pendingClaims > 0): ?><span class="nav-badge"><?= $pendingClaims ?></span><?php endif; ?>
      </a>
    <?php endforeach; ?>
  </nav>
  <div class="sidebar__footer">
    <img src="../assets/icons/umak-icon.svg" alt="" width="28" height="28">
    <span>University of Makati<br><small>Security Office</small></span>
  </div>
</aside>
<div class="main-col">
  <header class="topbar client-topbar">
    <button class="topbar__menu-toggle" id="sidebar-toggle" type="button" aria-label="Toggle sidebar">Menu</button>
    <form class="topbar__search" id="client-search-form" method="get" action="<?= h($searchAction) ?>" data-search-module="<?= h($searchModule) ?>" role="search">
      <label class="visually-hidden" for="client-search"><?= h(admin_asset_map()[$searchModule]['search']) ?></label>
      <input id="client-search" type="search" name="q" placeholder="<?= h(admin_asset_map()[$searchModule]['search']) ?>">
    </form>
    <div class="topbar__actions">
      <div class="user-menu">
        <button class="user-menu__trigger" id="user-menu-trigger" type="button">
          <img src="<?= h($avatarSrc) ?>" alt="" class="user-menu__avatar">
          <span class="user-menu__text">
            <strong><?= h($user['full_name']) ?></strong>
            <small><?= h(role_label($role)) ?></small>
          </span>
        </button>
        <div class="user-menu__dropdown" id="user-menu-dropdown">
          <a href="settings.php" class="user-menu__item">Settings</a>
          <button class="user-menu__item user-menu__item--danger" id="logout-btn" type="button">Log out</button>
        </div>
      </div>
      <div class="client-clock">
        <span><?= h($now->format('l, M j, Y')) ?></span>
        <strong><?= h($now->format('g:i A')) ?></strong>
      </div>
    </div>
  </header>
  <main id="client-module" class="client-module module-<?= h($adminModule) ?>" tabindex="-1">
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
<script src="dashboard.js"></script>
<script src="client/qrcode.js"></script>
<script src="client/client.js"></script>
<script src="<?= h($meta['js']) ?>"></script>
</body>
</html>
