<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/../dashboard/rbac.php';

$session = require_login();
$db = get_db();
$role = (string) ($session['role'] ?? 'student');
$userId = (int) $session['user_id'];
$isAdminSide = role_is_admin_side($role);

function stats_mask_item_name(string $name, bool $isAdmin): string {
    if ($isAdmin) {
        return $name;
    }
    $masked = preg_replace_callback('/\b([A-Z0-9]{2})[A-Z0-9]{3,}([A-Z0-9]{2})\b/i', function ($m) {
        return $m[1] . str_repeat('*', strlen($m[0]) - 4) . $m[2];
    }, $name);
    return $masked ?? $name;
}

if ($isAdminSide) {
    $totalFound    = (int) $db->query('SELECT COUNT(*) FROM found_items')->fetchColumn();
    $totalLost     = (int) $db->query('SELECT COUNT(*) FROM lost_items')->fetchColumn();
    $totalClaims   = (int) $db->query('SELECT COUNT(*) FROM claims')->fetchColumn();
    $itemsReturned = (int) $db->query("SELECT COUNT(*) FROM found_items WHERE status = 'claimed'")->fetchColumn();
} else {
    $stmt = $db->prepare('SELECT COUNT(*) FROM lost_items WHERE reported_by = ?');
    $stmt->execute([$userId]);
    $totalLost = (int) $stmt->fetchColumn();

    $stmt = $db->prepare('SELECT COUNT(*) FROM claims WHERE claimant_id = ?');
    $stmt->execute([$userId]);
    $totalClaims = (int) $stmt->fetchColumn();

    $totalFound = (int) $db->query("SELECT COUNT(*) FROM found_items WHERE status = 'unclaimed'")->fetchColumn();

    $stmt = $db->prepare("SELECT COUNT(*) FROM claims WHERE claimant_id = ? AND status = 'approved'");
    $stmt->execute([$userId]);
    $itemsReturned = (int) $stmt->fetchColumn();
}

$recentRows = $db->query('SELECT item_name, location_found, date_found, status FROM found_items ORDER BY created_at DESC LIMIT 5')->fetchAll();
$recentFound = array_map(static function (array $row) use ($isAdminSide): array {
    return [
        'item_name'      => stats_mask_item_name((string) $row['item_name'], $isAdminSide),
        'location_found' => (string) $row['location_found'],
        'date_label'     => date('M j', strtotime((string) $row['date_found'])),
        'status'         => (string) $row['status'],
        'status_label'   => ucwords(str_replace('_', ' ', (string) $row['status'])),
    ];
}, $recentRows);

$pendingCount = $isAdminSide
    ? (int) $db->query("SELECT COUNT(*) FROM claims WHERE status IN ('pending', 'manual_review')")->fetchColumn()
    : 0;

$categories = ['Electronics', 'Clothing', 'IDs & Cards', 'Accessories', 'Books & Papers', 'Others'];
$categoryCounts = array_fill_keys($categories, 0);
foreach ($db->query('SELECT category, COUNT(*) AS total FROM found_items GROUP BY category')->fetchAll() as $row) {
    if (isset($categoryCounts[$row['category']])) {
        $categoryCounts[$row['category']] = (int) $row['total'];
    }
}

$days = [];
$foundSeries = [];
$lostSeries = [];
for ($i = 6; $i >= 0; $i--) {
    $d = date('Y-m-d', strtotime("-{$i} days"));
    $days[] = date('M j', strtotime($d));

    $fStmt = $db->prepare('SELECT COUNT(*) FROM found_items WHERE date_found = ?');
    $fStmt->execute([$d]);
    $foundSeries[] = (int) $fStmt->fetchColumn();

    $lStmt = $db->prepare('SELECT COUNT(*) FROM lost_items WHERE date_lost = ?');
    $lStmt->execute([$d]);
    $lostSeries[] = (int) $lStmt->fetchColumn();
}

json_out([
    'success'        => true,
    'totalFound'     => $totalFound,
    'totalLost'      => $totalLost,
    'totalClaims'    => $totalClaims,
    'itemsReturned'  => $itemsReturned,
    'pendingCount'   => $pendingCount,
    'recentFound'    => $recentFound,
    'categoryCounts' => $categoryCounts,
    'days'           => $days,
    'foundSeries'    => $foundSeries,
    'lostSeries'     => $lostSeries,
]);
