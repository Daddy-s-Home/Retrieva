<?php
declare(strict_types=1);

require_once __DIR__ . '/lib.php';

function admin_emit(string $module): void {
    $session = admin_guard();
    if ($module === 'users') {
        require_role(['admin']);
    }
    json_out(admin_module($module, (int) $session['user_id'], $_GET));
}
