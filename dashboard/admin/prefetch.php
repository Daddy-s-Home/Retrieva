<?php
declare(strict_types=1);

function admin_asset_map(): array {
    return [
        'dashboard' => ['css' => 'admin/admin.css', 'js' => 'admin/modules/dashboard.js', 'api' => '../database/admin/dashboard.php', 'page' => 'index.php', 'search' => 'Search found items by name, category, or location'],
        'lost-reports' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/lost-reports.php', 'page' => 'admin-lost-reports.php', 'search' => 'Search lost reports by item, code, or reporter'],
        'found-items' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/found-items.php', 'page' => 'admin-found-items.php', 'search' => 'Search found items by name, code, or location'],
        'log-found' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/log-found.php', 'page' => 'admin-log-found.php', 'search' => 'Search found items by name, code, or location'],
        'matching' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/matching.php', 'page' => 'admin-matching.php', 'search' => 'Search matches by item name'],
        'claims' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/claims.php', 'page' => 'admin-claims.php', 'search' => 'Search claims by item, claimant, or code'],
        'pickup' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/pickup.php', 'page' => 'admin-pickup.php', 'search' => 'Search the pickup queue'],
        'returned' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/returned.php', 'page' => 'admin-returned.php', 'search' => 'Search returned items'],
        'users' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/users.php', 'page' => 'admin-users.php', 'search' => 'Search accounts by name, email, or student ID'],
        'reports' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/reports.php', 'page' => 'admin-reports.php', 'search' => 'Search reports'],
        'audit' => ['css' => 'admin/admin.css', 'js' => 'admin/admin.js', 'api' => '../database/admin/audit.php', 'page' => 'admin-audit.php', 'search' => 'Search audit logs by action, person, or detail'],
        'settings' => ['css' => 'settings.css', 'js' => 'settings.js', 'api' => '../database/admin/settings.php', 'page' => 'settings.php', 'search' => 'Search settings'],
    ];
}

function admin_visible_modules(string $role): array {
    $modules = admin_asset_map();
    if (!role_is_administrator($role)) {
        unset($modules['users']);
    }
    return $modules;
}

function admin_prefetch_head(string $current, string $role): void {
    $modules = admin_visible_modules($role);
    echo '<link rel="preload" href="client/client.css" as="style">' . "\n";
    echo '<link rel="preload" href="client/client.js" as="script">' . "\n";
    foreach ($modules as $name => $meta) {
        $rel = $name === $current ? 'preload' : 'prefetch';
        echo '<link rel="' . $rel . '" href="' . h($meta['css']) . '" as="style">' . "\n";
        echo '<link rel="' . $rel . '" href="' . h($meta['js']) . '" as="script">' . "\n";
    }
    $boot = ['current' => $current, 'modules' => $modules];
    echo '<script>window.RetrievaWarm=' . json_encode($boot, JSON_UNESCAPED_SLASHES) . ';window.RetrievaPrefetch={};Object.keys(window.RetrievaWarm.modules).forEach(function(name){if(name===window.RetrievaWarm.current)return;window.RetrievaPrefetch[name]=fetch(window.RetrievaWarm.modules[name].api,{credentials:"same-origin",headers:{Accept:"application/json"}}).then(function(response){return response.json();});});</script>' . "\n";
}
