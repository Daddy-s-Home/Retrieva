<?php
declare(strict_types=1);
require_once __DIR__ . '/_bootstrap.php';
header('Location: ' . (role_is_admin_side($role) ? 'admin-found-items.php' : 'client-found-items.php'));
exit;
