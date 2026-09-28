<?php
declare(strict_types=1);
require_once __DIR__ . '/_bootstrap.php';
if (!role_is_admin_side($role)) {
    header('Location: client-dashboard.php');
    exit;
}
header('Location: admin-claims.php?status=pending');
exit;
