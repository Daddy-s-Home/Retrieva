<?php
declare(strict_types=1);

function client_asset_map(): array {
    return [
        'dashboard' => ['css' => 'client/modules/dashboard.css', 'js' => 'client/modules/dashboard.js', 'api' => '../database/client/dashboard.php', 'page' => 'client-dashboard.php', 'search' => 'Search found items by name, category, or location'],
        'lost-items' => ['css' => 'client/modules/lost-items.css', 'js' => 'client/modules/lost-items.js', 'api' => '../database/client/lost-items.php', 'page' => 'client-lost-items.php', 'search' => 'Search lost items by name, category, location, or description'],
        'found-items' => ['css' => 'client/modules/found-items.css', 'js' => 'client/modules/found-items.js', 'api' => '../database/client/found-items.php', 'page' => 'client-found-items.php', 'search' => 'Search found items by name, category, or location'],
        'my-reports' => ['css' => 'client/modules/my-reports.css', 'js' => 'client/modules/my-reports.js', 'api' => '../database/client/my-reports.php', 'page' => 'client-my-reports.php', 'search' => 'Search your reports by item name, category, or date'],
        'my-claims' => ['css' => 'client/modules/my-claims.css', 'js' => 'client/modules/my-claims.js', 'api' => '../database/client/my-claims.php', 'page' => 'client-my-claims.php', 'search' => 'Search your claims by item name, status, or date'],
        'notifications' => ['css' => 'client/modules/notifications.css', 'js' => 'client/modules/notifications.js', 'api' => '../database/client/notifications.php', 'page' => 'client-notifications.php', 'search' => 'Search notifications, items, or keywords'],
        'settings' => ['css' => 'client/modules/settings.css', 'js' => 'client/modules/settings.js', 'api' => '../database/client/settings.php', 'page' => 'client-settings.php', 'search' => 'Search settings, account, or notifications'],
    ];
}

function client_prefetch_head(string $current): void {
    echo '<link rel="preload" href="client/client.css" as="style">' . "\n";
    echo '<link rel="preload" href="client/client.js" as="script">' . "\n";
    foreach (client_asset_map() as $name => $meta) {
        $rel = $name === $current ? 'preload' : 'prefetch';
        echo '<link rel="' . $rel . '" href="' . h($meta['css']) . '" as="style">' . "\n";
        echo '<link rel="' . $rel . '" href="' . h($meta['js']) . '" as="script">' . "\n";
    }
    $boot = ['current' => $current, 'modules' => client_asset_map()];
    echo '<script>window.RetrievaWarm=' . json_encode($boot, JSON_UNESCAPED_SLASHES) . ';window.RetrievaPrefetch={};Object.keys(window.RetrievaWarm.modules).forEach(function(name){if(name===window.RetrievaWarm.current)return;window.RetrievaPrefetch[name]=fetch(window.RetrievaWarm.modules[name].api,{credentials:"same-origin",headers:{Accept:"application/json"}}).then(function(response){return response.json();});});</script>' . "\n";
}
