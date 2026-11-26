<?php
declare(strict_types=1);

require_once __DIR__ . '/lib.php';

function client_emit(string $module): void {
    $session = client_guard();
    json_out(client_module($module, (int) $session['user_id'], $_GET));
}
