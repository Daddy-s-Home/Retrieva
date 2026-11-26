<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/../dashboard/rbac.php';

/**
 * Returns report definitions allowed for the given role.
 */
function report_definitions(string $role): array {
    $defs = [
        'lost_items' => [
            'title'    => 'Lost Items Report',
            'statuses' => ['searching', 'matched', 'resolved'],
            'columns'  => ['ID', 'Item Name', 'Category', 'Last Seen', 'Date Lost', 'Status', 'Reported By', 'Created At'],
        ],
        'found_items' => [
            'title'    => 'Found Items Report',
            'statuses' => ['unclaimed', 'pending_verification', 'claimed', 'disposed'],
            'columns'  => ['ID', 'Item Name', 'Category', 'Location Found', 'Date Found', 'Status', 'Logged By', 'Created At'],
        ],
        'claims' => [
            'title'    => 'Claims & Claim Status Report',
            'statuses' => ['pending', 'manual_review', 'approved', 'rejected'],
            'columns'  => ['Claim ID', 'Found Item', 'Category', 'Claimant', 'Status', 'Reviewed By', 'Submitted At', 'Reviewed At'],
        ],
        'pickups' => [
            'title'    => 'Pickups & QR Verification Report',
            'statuses' => ['pending_pickup', 'completed'],
            'columns'  => ['Pickup ID', 'Claim ID', 'Item Name', 'Claimant', 'Student ID', 'Pickup Status', 'Verified By', 'Scanned At'],
        ],
        'inventory' => [
            'title'    => 'Item Inventory Summary',
            'statuses' => [],
            'columns'  => ['Category', 'Total Found', 'Unclaimed', 'Pending Verification', 'Claimed', 'Disposed', 'Total Lost'],
        ],
    ];

    if ($role === 'admin') {
        $defs['audit_trail'] = [
            'title'    => 'Security & System Audit Trail Report',
            'statuses' => [],
            'columns'  => ['ID', 'Timestamp', 'User', 'Role', 'Action', 'Details', 'IP Address'],
        ];
    }

    return $defs;
}

/**
 * Validates Y-m-d date filter string.
 */
function report_valid_date(?string $val): ?string {
    $val = trim((string) $val);
    if ($val === '') {
        return null;
    }
    $dt = DateTime::createFromFormat('Y-m-d', $val);
    if ($dt instanceof DateTime && $dt->format('Y-m-d') === $val) {
        return $val;
    }
    return null;
}

/**
 * Prevents CSV/spreadsheet formula injection (=, +, -, @, tab, CR).
 */
function csv_safe_cell(mixed $value): string {
    $str = (string) ($value ?? '');
    if ($str !== '' && preg_match('/^[=+\-@\t\r]/', $str)) {
        return "'" . $str;
    }
    return $str;
}

/**
 * Executes a validated, RBAC-scoped report query and returns metadata + rows.
 */
function fetch_report_data(string $role, string $type, ?string $dateFrom, ?string $dateTo, string $status = ''): array {
    $defs = report_definitions($role);
    if (!isset($defs[$type])) {
        throw new InvalidArgumentException('Selected report type is not permitted or invalid.');
    }

    $def = $defs[$type];
    $from = report_valid_date($dateFrom);
    $to   = report_valid_date($dateTo);
    $status = trim($status);
    if ($status !== '' && !in_array($status, $def['statuses'], true)) {
        $status = '';
    }

    $db = get_db();
    $where = [];
    $params = [];
    $rows = [];

    if ($type === 'lost_items') {
        if ($from) { $where[] = 'l.date_lost >= ?'; $params[] = $from; }
        if ($to)   { $where[] = 'l.date_lost <= ?'; $params[] = $to; }
        if ($status !== '') { $where[] = 'l.status = ?'; $params[] = $status; }
        $wSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
        $stmt = $db->prepare(
            "SELECT l.id, l.item_name, l.category, l.other_category, l.last_seen_location, l.date_lost, l.status,
                    u.full_name AS reporter_name, l.created_at
             FROM lost_items l
             JOIN users u ON u.id = l.reported_by
             {$wSql}
             ORDER BY l.date_lost DESC, l.id DESC"
        );
        $stmt->execute($params);
        foreach ($stmt->fetchAll() as $r) {
            $cat = $r['category'] === 'Others' && !empty($r['other_category']) ? "Others ({$r['other_category']})" : $r['category'];
            $rows[] = [
                (string) $r['id'],
                (string) $r['item_name'],
                $cat,
                (string) ($r['last_seen_location'] ?: '—'),
                (string) $r['date_lost'],
                ucfirst((string) $r['status']),
                (string) $r['reporter_name'],
                (string) $r['created_at'],
            ];
        }
    } elseif ($type === 'found_items') {
        if ($from) { $where[] = 'f.date_found >= ?'; $params[] = $from; }
        if ($to)   { $where[] = 'f.date_found <= ?'; $params[] = $to; }
        if ($status !== '') { $where[] = 'f.status = ?'; $params[] = $status; }
        $wSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
        $stmt = $db->prepare(
            "SELECT f.id, f.item_name, f.category, f.other_category, f.location_found, f.date_found, f.status,
                    u.full_name AS logged_by_name, f.created_at
             FROM found_items f
             JOIN users u ON u.id = f.logged_by
             {$wSql}
             ORDER BY f.date_found DESC, f.id DESC"
        );
        $stmt->execute($params);
        foreach ($stmt->fetchAll() as $r) {
            $cat = $r['category'] === 'Others' && !empty($r['other_category']) ? "Others ({$r['other_category']})" : $r['category'];
            $rows[] = [
                (string) $r['id'],
                (string) $r['item_name'],
                $cat,
                (string) $r['location_found'],
                (string) $r['date_found'],
                ucwords(str_replace('_', ' ', (string) $r['status'])),
                (string) $r['logged_by_name'],
                (string) $r['created_at'],
            ];
        }
    } elseif ($type === 'claims') {
        if ($from) { $where[] = 'DATE(c.created_at) >= ?'; $params[] = $from; }
        if ($to)   { $where[] = 'DATE(c.created_at) <= ?'; $params[] = $to; }
        if ($status !== '') { $where[] = 'c.status = ?'; $params[] = $status; }
        $wSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
        $stmt = $db->prepare(
            "SELECT c.id, f.item_name, f.category, u.full_name AS claimant_name, c.status,
                    rv.full_name AS reviewer_name, c.created_at, c.reviewed_at
             FROM claims c
             JOIN found_items f ON f.id = c.found_item_id
             JOIN users u ON u.id = c.claimant_id
             LEFT JOIN users rv ON rv.id = c.reviewed_by
             {$wSql}
             ORDER BY c.created_at DESC, c.id DESC"
        );
        $stmt->execute($params);
        foreach ($stmt->fetchAll() as $r) {
            $rows[] = [
                (string) $r['id'],
                (string) $r['item_name'],
                (string) $r['category'],
                (string) $r['claimant_name'],
                ucwords(str_replace('_', ' ', (string) $r['status'])),
                (string) ($r['reviewer_name'] ?: '—'),
                (string) $r['created_at'],
                (string) ($r['reviewed_at'] ?: '—'),
            ];
        }
    } elseif ($type === 'pickups') {
        if ($from) { $where[] = 'DATE(COALESCE(p.scanned_at, p.created_at)) >= ?'; $params[] = $from; }
        if ($to)   { $where[] = 'DATE(COALESCE(p.scanned_at, p.created_at)) <= ?'; $params[] = $to; }
        if ($status === 'completed') { $where[] = 'p.scanned_at IS NOT NULL'; }
        elseif ($status === 'pending_pickup') { $where[] = 'p.scanned_at IS NULL'; }
        $wSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
        $stmt = $db->prepare(
            "SELECT p.id, p.claim_id, f.item_name, u.full_name AS claimant_name, u.student_id,
                    p.scanned_at, p.created_at, v.full_name AS verifier_name
             FROM pickups p
             JOIN claims c ON c.id = p.claim_id
             JOIN found_items f ON f.id = c.found_item_id
             JOIN users u ON u.id = c.claimant_id
             LEFT JOIN users v ON v.id = p.verified_by
             {$wSql}
             ORDER BY p.created_at DESC, p.id DESC"
        );
        $stmt->execute($params);
        foreach ($stmt->fetchAll() as $r) {
            $rows[] = [
                (string) $r['id'],
                (string) $r['claim_id'],
                (string) $r['item_name'],
                (string) $r['claimant_name'],
                (string) ($r['student_id'] ?: '—'),
                $r['scanned_at'] ? 'Verified / Picked Up' : 'Awaiting Pickup',
                (string) ($r['verifier_name'] ?: '—'),
                (string) ($r['scanned_at'] ?: '—'),
            ];
        }
    } elseif ($type === 'inventory') {
        $fWhere = []; $fParams = [];
        $lWhere = []; $lParams = [];
        if ($from) { $fWhere[] = 'date_found >= ?'; $fParams[] = $from; $lWhere[] = 'date_lost >= ?'; $lParams[] = $from; }
        if ($to)   { $fWhere[] = 'date_found <= ?'; $fParams[] = $to;   $lWhere[] = 'date_lost <= ?'; $lParams[] = $to; }
        $fwSql = $fWhere ? ('WHERE ' . implode(' AND ', $fWhere)) : '';
        $lwSql = $lWhere ? ('WHERE ' . implode(' AND ', $lWhere)) : '';

        $fStmt = $db->prepare(
            "SELECT category,
                    COUNT(*) AS total_found,
                    SUM(status = 'unclaimed') AS unclaimed,
                    SUM(status = 'pending_verification') AS pending_verification,
                    SUM(status = 'claimed') AS claimed,
                    SUM(status = 'disposed') AS disposed
             FROM found_items {$fwSql} GROUP BY category"
        );
        $fStmt->execute($fParams);
        $foundMap = [];
        foreach ($fStmt->fetchAll() as $fr) {
            $foundMap[$fr['category']] = $fr;
        }

        $lStmt = $db->prepare("SELECT category, COUNT(*) AS total_lost FROM lost_items {$lwSql} GROUP BY category");
        $lStmt->execute($lParams);
        $lostMap = [];
        foreach ($lStmt->fetchAll() as $lr) {
            $lostMap[$lr['category']] = (int) $lr['total_lost'];
        }

        foreach (['Electronics', 'Clothing', 'IDs & Cards', 'Accessories', 'Books & Papers', 'Others'] as $cat) {
            $f = $foundMap[$cat] ?? ['total_found' => 0, 'unclaimed' => 0, 'pending_verification' => 0, 'claimed' => 0, 'disposed' => 0];
            $rows[] = [
                $cat,
                (string) (int) $f['total_found'],
                (string) (int) $f['unclaimed'],
                (string) (int) $f['pending_verification'],
                (string) (int) $f['claimed'],
                (string) (int) $f['disposed'],
                (string) ($lostMap[$cat] ?? 0),
            ];
        }
    } elseif ($type === 'audit_trail') {
        if ($role !== 'admin') {
            throw new RuntimeException('Audit trail report is restricted to administrators.');
        }
        if ($from) { $where[] = 'DATE(a.created_at) >= ?'; $params[] = $from; }
        if ($to)   { $where[] = 'DATE(a.created_at) <= ?'; $params[] = $to; }
        $wSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
        $stmt = $db->prepare(
            "SELECT a.id, a.created_at, u.full_name, u.role, a.action, a.details, a.ip_address
             FROM audit_trail a
             LEFT JOIN users u ON u.id = a.user_id
             {$wSql}
             ORDER BY a.created_at DESC, a.id DESC
             LIMIT 1000"
        );
        $stmt->execute($params);
        foreach ($stmt->fetchAll() as $r) {
            $rows[] = [
                (string) $r['id'],
                (string) $r['created_at'],
                (string) ($r['full_name'] ?: 'System / Guest'),
                (string) ($r['role'] ? ucfirst($r['role']) : '—'),
                (string) $r['action'],
                (string) ($r['details'] ?: '—'),
                (string) ($r['ip_address'] ?: '—'),
            ];
        }
    }

    return [
        'type'      => $type,
        'title'     => $def['title'],
        'columns'   => $def['columns'],
        'statuses'  => $def['statuses'],
        'date_from' => $from,
        'date_to'   => $to,
        'status'    => $status,
        'rows'      => $rows,
    ];
}
