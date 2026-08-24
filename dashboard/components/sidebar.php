<?php
/**
 * Expects $role and $currentPage from _bootstrap.php.
 * A link whose allowed roles don't include $role is never printed at
 * all — this is real server-side RBAC, not CSS hiding.
 *
 * Only implemented core modules are exposed in this release.
 */

$pendingBadge = null;
if (role_is_admin_side($role)) {
  $pendingBadge = (int) get_db()->query("SELECT COUNT(*) FROM claims WHERE status IN ('pending', 'manual_review')")->fetchColumn();
}

function nav_item(string $href, string $page, string $icon, string $label, array $allowedRoles, string $role, string $currentPage, ?string $badge = null): void {
    if (!role_can($role, $allowedRoles)) return;
    $activeClass = $page === $currentPage ? ' active' : '';
    echo '<a href="' . htmlspecialchars($href) . '" class="nav-item' . $activeClass . '">';
    echo '<span class="nav-icon">' . $icon . '</span> ' . htmlspecialchars($label);
    if ($badge !== null) {
        echo '<span class="nav-badge">' . htmlspecialchars($badge) . '</span>';
    }
    echo '</a>';
}
?>
<aside class="sidebar">
  <div class="sidebar__brand">
    <img src="../assets/icons/logo.svg" alt="" width="30" height="30">
    <span>Retrieva</span>
  </div>

  <nav class="sidebar__nav">
    <p class="sidebar__label">MAIN</p>
    <?php
    nav_item('index.php', 'dashboard', '🏠', 'Dashboard', ['admin','security','professor','student'], $role, $currentPage);
    nav_item('found-items.php', 'found-items', '📦', 'Found Items', ['admin','security'], $role, $currentPage);
    nav_item('lost-items.php', 'lost-items', '🔍', 'Lost Items', ['admin','security','professor','student'], $role, $currentPage);
    nav_item('claims.php', 'claims', '🛡️', 'Claims', ['admin','security','professor','student'], $role, $currentPage);
    nav_item('pending-verifications.php', 'pending-verifications', '✅', 'Pending Verifications', ['admin','security'], $role, $currentPage, $pendingBadge > 0 ? (string) $pendingBadge : null);
    ?>
  </nav>

  <?php nav_item('settings.php', 'settings', '⚙️', 'Settings', ['admin','security','professor','student'], $role, $currentPage); ?>

  <div class="sidebar__footer">
    <img src="../assets/icons/umak-icon.svg" alt="" width="22" height="22">
    <span>University of Makati<br><small>Security Office</small></span>
  </div>
</aside>
