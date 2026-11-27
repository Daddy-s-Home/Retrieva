<?php
declare(strict_types=1);

require_once __DIR__ . '/../client/lib.php';

const ADMIN_PAGES = [
    'dashboard' => 'index.php',
    'lost-reports' => 'admin-lost-reports.php',
    'found-items' => 'admin-found-items.php',
    'log-found' => 'admin-log-found.php',
    'matching' => 'admin-matching.php',
    'claims' => 'admin-claims.php',
    'pickup' => 'admin-pickup.php',
    'returned' => 'admin-returned.php',
    'users' => 'admin-users.php',
    'reports' => 'admin-reports.php',
    'audit' => 'admin-audit.php',
    'settings' => 'settings.php',
];
const ADMIN_FOUND_STATUSES = ['unclaimed', 'pending_verification', 'claimed', 'returned', 'disposed'];
const ADMIN_ROLES = ['admin', 'security', 'professor', 'student'];
const ADMIN_USER_STATUSES = ['active', 'blocked'];

function admin_guard(): array {
    return require_role(RETRIEVA_ADMIN_ROLES);
}

function admin_page_name(string $module): string {
    return ADMIN_PAGES[$module] ?? 'index.php';
}

function admin_filters(array $query): array {
    $status = (string) ($query['status'] ?? '');
    $tab = (string) ($query['tab'] ?? 'overview');
    $tabs = ['overview', 'lost', 'found', 'claims', 'users'];
    return [
        'q' => client_text($query),
        'category' => client_category($query),
        'status' => $status,
        'tab' => in_array($tab, $tabs, true) ? $tab : 'overview',
        'token' => substr(preg_replace('/[^a-f0-9]/i', '', (string) ($query['token'] ?? '')) ?? '', 0, 64),
        'page' => max(1, (int) ($query['page'] ?? 1)),
    ];
}

function admin_like(string $q): string {
    return '%' . str_replace(['%', '_'], ['\\%', '\\_'], $q) . '%';
}

function admin_date_range(array $query): array {
    $today = date('Y-m-d');
    $end = (string) ($query['end'] ?? '');
    $start = (string) ($query['start'] ?? '');
    $endDate = DateTime::createFromFormat('!Y-m-d', $end);
    if (!$endDate || $endDate->format('Y-m-d') !== $end || $end > $today) {
        $end = $today;
    }
    $startDate = DateTime::createFromFormat('!Y-m-d', $start);
    if ($start === '' || !$startDate || $startDate->format('Y-m-d') !== $start || $start > $end) {
        $start = '';
    }
    return ['start' => $start, 'end' => $end];
}

function admin_range_label(array $range): string {
    $end = date('M j, Y', strtotime($range['end']));
    if ($range['start'] === '') {
        return 'Through ' . $end;
    }
    return date('M j, Y', strtotime($range['start'])) . ' - ' . $end;
}

function admin_date_sql(string $column, array $range, bool $isDate = false): array {
    $end = $isDate ? $range['end'] : $range['end'] . ' 23:59:59';
    if ($range['start'] === '') {
        return [$column . ' <= ?', [$end]];
    }
    $start = $isDate ? $range['start'] : $range['start'] . ' 00:00:00';
    return [$column . ' BETWEEN ? AND ?', [$start, $end]];
}

function admin_report_chart(array $range): array {
    $endDay = new DateTimeImmutable($range['end']);
    $startValue = $range['start'];
    if ($startValue === '') {
        $lostMin = get_db()->prepare('SELECT MIN(date_lost) FROM lost_items WHERE date_lost IS NOT NULL AND date_lost <= ?');
        $lostMin->execute([$range['end']]);
        $foundMin = get_db()->prepare('SELECT MIN(date_found) FROM found_items WHERE date_found IS NOT NULL AND date_found <= ?');
        $foundMin->execute([$range['end']]);
        $dates = array_filter([(string) $lostMin->fetchColumn(), (string) $foundMin->fetchColumn()]);
        sort($dates);
        $startValue = $dates[0] ?? $range['end'];
    }
    $startDay = new DateTimeImmutable($startValue);
    if ($startDay > $endDay) {
        $startDay = $endDay;
    }
    $lostMap = [];
    foreach (admin_rows('SELECT date_lost AS day, COUNT(*) AS total FROM lost_items WHERE date_lost BETWEEN ? AND ? GROUP BY date_lost', [$startDay->format('Y-m-d'), $range['end']]) as $row) {
        $lostMap[(string) $row['day']] = (int) $row['total'];
    }
    $foundMap = [];
    foreach (admin_rows('SELECT date_found AS day, COUNT(*) AS total FROM found_items WHERE date_found BETWEEN ? AND ? GROUP BY date_found', [$startDay->format('Y-m-d'), $range['end']]) as $row) {
        $foundMap[(string) $row['day']] = (int) $row['total'];
    }
    $span = (int) $startDay->diff($endDay)->days;
    $labels = [];
    $lostSeries = [];
    $foundSeries = [];
    if ($span <= 62) {
        for ($day = $startDay; $day <= $endDay; $day = $day->modify('+1 day')) {
            $key = $day->format('Y-m-d');
            $labels[] = $day->format('M j');
            $lostSeries[] = $lostMap[$key] ?? 0;
            $foundSeries[] = $foundMap[$key] ?? 0;
        }
    } else {
        for ($cursor = $startDay; $cursor <= $endDay; $cursor = $cursor->modify('+7 days')) {
            $bucketEnd = $cursor->modify('+6 days');
            if ($bucketEnd > $endDay) {
                $bucketEnd = $endDay;
            }
            $labels[] = $cursor->format('M j');
            $lostTotal = 0;
            $foundTotal = 0;
            for ($day = $cursor; $day <= $bucketEnd; $day = $day->modify('+1 day')) {
                $key = $day->format('Y-m-d');
                $lostTotal += $lostMap[$key] ?? 0;
                $foundTotal += $foundMap[$key] ?? 0;
            }
            $lostSeries[] = $lostTotal;
            $foundSeries[] = $foundTotal;
        }
    }
    [$lostSql, $lostParams] = admin_date_sql('date_lost', $range, true);
    [$foundSql, $foundParams] = admin_date_sql('date_found', $range, true);
    $lostBy = [];
    foreach (admin_rows("SELECT category, COUNT(*) AS total FROM lost_items WHERE $lostSql GROUP BY category", $lostParams) as $row) {
        $lostBy[(string) $row['category']] = (int) $row['total'];
    }
    $foundBy = [];
    foreach (admin_rows("SELECT category, COUNT(*) AS total FROM found_items WHERE $foundSql GROUP BY category", $foundParams) as $row) {
        $foundBy[(string) $row['category']] = (int) $row['total'];
    }
    $categoryLost = [];
    $categoryFound = [];
    foreach (CLIENT_CATEGORIES as $category) {
        $categoryLost[] = $lostBy[$category] ?? 0;
        $categoryFound[] = $foundBy[$category] ?? 0;
    }
    return [
        'days' => $labels,
        'lost' => $lostSeries,
        'found' => $foundSeries,
        'categories' => CLIENT_CATEGORIES,
        'category_lost' => $categoryLost,
        'category_found' => $categoryFound,
    ];
}

function admin_report_table(string $tab, array $range): array {
    if ($tab === 'lost') {
        [$sql, $params] = admin_date_sql('date_lost', $range, true);
        $rows = [];
        foreach (admin_rows("SELECT public_code, item_name, category, status, date_lost FROM lost_items WHERE $sql ORDER BY date_lost DESC LIMIT 1000", $params) as $row) {
            $rows[] = [$row['public_code'], $row['item_name'], $row['category'], admin_label((string) $row['status']), (string) $row['date_lost']];
        }
        return ['headers' => ['Code', 'Item', 'Category', 'Status', 'Date lost'], 'rows' => $rows];
    }
    if ($tab === 'found') {
        [$sql, $params] = admin_date_sql('date_found', $range, true);
        $rows = [];
        foreach (admin_rows("SELECT public_code, item_name, category, status, location_found, date_found FROM found_items WHERE $sql ORDER BY date_found DESC LIMIT 1000", $params) as $row) {
            $rows[] = [$row['public_code'], $row['item_name'], $row['category'], admin_label((string) $row['status']), $row['location_found'], (string) $row['date_found']];
        }
        return ['headers' => ['Code', 'Item', 'Category', 'Status', 'Location', 'Date found'], 'rows' => $rows];
    }
    if ($tab === 'claims') {
        [$sql, $params] = admin_date_sql('c.created_at', $range, false);
        $rows = [];
        foreach (admin_rows("SELECT c.public_code, f.item_name, u.full_name, c.status, c.created_at FROM claims c INNER JOIN found_items f ON f.id = c.found_item_id INNER JOIN users u ON u.id = c.claimant_id WHERE $sql ORDER BY c.created_at DESC LIMIT 1000", $params) as $row) {
            $rows[] = [$row['public_code'], $row['item_name'], $row['full_name'], admin_label((string) $row['status']), (string) $row['created_at']];
        }
        return ['headers' => ['Code', 'Item', 'Claimant', 'Status', 'Filed'], 'rows' => $rows];
    }
    if ($tab === 'users') {
        [$sql, $params] = admin_date_sql('created_at', $range, false);
        $rows = [];
        foreach (admin_rows("SELECT full_name, email, role, status, student_id, program_department FROM users WHERE $sql ORDER BY created_at DESC LIMIT 1000", $params) as $row) {
            $rows[] = [$row['full_name'], $row['email'], $row['role'], $row['status'], (string) $row['student_id'], (string) $row['program_department']];
        }
        return ['headers' => ['Name', 'Email', 'Role', 'Status', 'Student ID', 'Program'], 'rows' => $rows];
    }
    [$sql, $params] = admin_date_sql('c.created_at', $range, false);
    $rows = [];
    foreach (admin_rows("SELECT c.public_code, f.item_name, u.full_name, c.status, c.created_at FROM claims c INNER JOIN found_items f ON f.id = c.found_item_id INNER JOIN users u ON u.id = c.claimant_id WHERE $sql ORDER BY c.created_at DESC LIMIT 8", $params) as $row) {
        $rows[] = [$row['public_code'], $row['item_name'], $row['full_name'], admin_label((string) $row['status']), (string) $row['created_at']];
    }
    return ['headers' => ['Code', 'Item', 'Claimant', 'Status', 'Filed'], 'rows' => $rows];
}

function admin_label(string $status): string {
    return ucwords(str_replace('_', ' ', $status));
}

function admin_match_score(array $lost, array $found): array {
    $score = 0;
    $checks = [];
    if (($lost['category'] ?? '') === ($found['category'] ?? '')) {
        $score += 40;
        $checks[] = 'Same category';
    }
    $lostName = strtolower((string) ($lost['item_name'] ?? ''));
    $foundName = strtolower((string) ($found['item_name'] ?? ''));
    $percent = 0.0;
    similar_text($lostName, $foundName, $percent);
    if ($lostName !== '' && ($percent >= 50 || str_contains($foundName, $lostName) || str_contains($lostName, $foundName))) {
        $score += (int) min(40, round($percent * 0.4));
        $checks[] = 'Name looks similar';
    }
    $lostLocation = strtolower(trim((string) ($lost['last_seen_location'] ?? '')));
    $foundLocation = strtolower(trim((string) ($found['location_found'] ?? '')));
    if ($lostLocation !== '' && $foundLocation !== '' && ($lostLocation === $foundLocation || str_contains($foundLocation, $lostLocation) || str_contains($lostLocation, $foundLocation))) {
        $score += 20;
        $checks[] = 'Location overlaps';
    }
    return ['score' => min(100, $score), 'checks' => $checks];
}

function admin_store_photo(array $file): ?string {
    $error = (int) ($file['error'] ?? UPLOAD_ERR_NO_FILE);
    if ($error === UPLOAD_ERR_NO_FILE) {
        return null;
    }
    if ($error !== UPLOAD_ERR_OK) {
        throw new InvalidArgumentException('The photo could not be uploaded.');
    }
    if ((int) ($file['size'] ?? 0) > 2000000) {
        throw new InvalidArgumentException('Photos must be 2 MB or smaller.');
    }
    $mime = (new finfo(FILEINFO_MIME_TYPE))->file((string) $file['tmp_name']);
    $ext = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'][$mime] ?? null;
    if ($ext === null) {
        throw new InvalidArgumentException('Use a JPG, PNG, or WebP photo.');
    }
    $dir = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'found';
    if (!is_dir($dir) && !mkdir($dir, 0755, true) && !is_dir($dir)) {
        throw new RuntimeException('Photo storage is unavailable.');
    }
    $name = 'found_' . bin2hex(random_bytes(8)) . '.' . $ext;
    if (!move_uploaded_file((string) $file['tmp_name'], $dir . DIRECTORY_SEPARATOR . $name)) {
        throw new RuntimeException('The photo could not be saved.');
    }
    return 'uploads/found/' . $name;
}

function admin_rows(string $sql, array $params = []): array {
    $stmt = get_db()->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}

function admin_dashboard_data(): array {
    $db = get_db();
    $found = client_count('SELECT COUNT(*) FROM found_items');
    $lost = client_count('SELECT COUNT(*) FROM lost_items');
    $pending = client_count("SELECT COUNT(*) FROM claims WHERE status IN ('pending', 'manual_review')");
    $returned = client_count("SELECT COUNT(*) FROM found_items WHERE status = 'returned'")
        + client_count("SELECT COUNT(*) FROM pickups WHERE status = 'verified'");
    $days = [];
    $foundSeries = [];
    $lostSeries = [];
    for ($i = 6; $i >= 0; $i--) {
        $day = date('Y-m-d', strtotime("-{$i} days"));
        $days[] = date('M j', strtotime($day));
        $foundSeries[] = client_count('SELECT COUNT(*) FROM found_items WHERE date_found = ?', [$day]);
        $lostSeries[] = client_count('SELECT COUNT(*) FROM lost_items WHERE date_lost = ?', [$day]);
    }
    $categories = dashboard_category_rows($db, 'found_items');
    $lostCategories = dashboard_category_rows($db, 'lost_items');
    $locations = [];
    foreach ($db->query('SELECT location_found AS label, COUNT(*) AS total FROM found_items GROUP BY location_found ORDER BY total DESC LIMIT 6')->fetchAll() as $row) {
        $locations[] = ['label' => (string) $row['label'], 'total' => (int) $row['total']];
    }
    return [
        'kpis' => [
            ['gold', 'box', (string) $found, 'Found items', 'Logged in inventory', 'flat'],
            ['blue', 'search', (string) $lost, 'Lost reports', 'Open and closed reports', 'flat'],
            ['purple', 'shield', (string) $pending, 'Pending claims', 'Waiting for review', 'flat'],
            ['green', 'check', (string) $returned, 'Returned', 'Verified pickups and returned items', 'flat'],
        ],
        'chart' => [
            'days' => $days,
            'found' => $foundSeries,
            'lost' => $lostSeries,
            'categories' => $categories,
            'categories_lost' => $lostCategories,
            'locations' => $locations,
        ],
        'recent_found' => admin_rows('SELECT id, public_code, item_name, category, location_found, date_found, status, photo_path FROM found_items ORDER BY created_at DESC LIMIT 5'),
        'pending_claims' => admin_rows(
            "SELECT c.id, c.public_code, c.status, c.created_at, f.item_name, u.full_name
             FROM claims c
             INNER JOIN found_items f ON f.id = c.found_item_id
             INNER JOIN users u ON u.id = c.claimant_id
             WHERE c.status IN ('pending', 'manual_review')
             ORDER BY c.created_at DESC LIMIT 5"
        ),
        'activity' => admin_rows(
            'SELECT a.action, a.details, a.created_at, u.full_name
             FROM audit_trail a LEFT JOIN users u ON u.id = a.user_id
             ORDER BY a.created_at DESC LIMIT 6'
        ),
    ];
}

function admin_lost_data(array $query): array {
    $filters = admin_filters($query);
    $where = ['1=1'];
    $params = [];
    if ($filters['q'] !== '') {
        $where[] = '(l.item_name LIKE ? OR l.public_code LIKE ? OR l.last_seen_location LIKE ? OR u.full_name LIKE ?)';
        $like = admin_like($filters['q']);
        array_push($params, $like, $like, $like, $like);
    }
    if ($filters['category'] !== '') {
        $where[] = 'l.category = ?';
        $params[] = $filters['category'];
    }
    if (in_array($filters['status'], CLIENT_LOST_STATUSES, true)) {
        $where[] = 'l.status = ?';
        $params[] = $filters['status'];
    }
    $sqlWhere = implode(' AND ', $where);
    $total = client_count("SELECT COUNT(*) FROM lost_items l INNER JOIN users u ON u.id = l.reported_by WHERE $sqlWhere", $params);
    [, $perPage, $offset] = client_page(['page' => $filters['page']], 10);
    $rows = admin_rows(
        "SELECT l.*, u.full_name, u.email, u.student_id,
                (SELECT COUNT(*) FROM claims c WHERE c.lost_item_id = l.id) AS claim_count
         FROM lost_items l INNER JOIN users u ON u.id = l.reported_by
         WHERE $sqlWhere ORDER BY l.created_at DESC LIMIT $perPage OFFSET $offset",
        $params
    );
    $counts = [];
    foreach (CLIENT_LOST_STATUSES as $status) {
        $counts[$status] = client_count('SELECT COUNT(*) FROM lost_items WHERE status = ?', [$status]);
    }
    return compact('filters', 'rows', 'total', 'perPage', 'counts') + ['pages' => (int) max(1, ceil($total / $perPage))];
}

function admin_found_data(array $query): array {
    $filters = admin_filters($query);
    $where = ['1=1'];
    $params = [];
    if ($filters['q'] !== '') {
        $where[] = '(f.item_name LIKE ? OR f.public_code LIKE ? OR f.location_found LIKE ?)';
        $like = admin_like($filters['q']);
        array_push($params, $like, $like, $like);
    }
    if ($filters['category'] !== '') {
        $where[] = 'f.category = ?';
        $params[] = $filters['category'];
    }
    if (in_array($filters['status'], ADMIN_FOUND_STATUSES, true)) {
        $where[] = 'f.status = ?';
        $params[] = $filters['status'];
    }
    $sqlWhere = implode(' AND ', $where);
    $total = client_count("SELECT COUNT(*) FROM found_items f WHERE $sqlWhere", $params);
    [, $perPage, $offset] = client_page(['page' => $filters['page']], 10);
    $rows = admin_rows(
        "SELECT f.*, u.full_name,
                (SELECT COUNT(*) FROM claims c WHERE c.found_item_id = f.id) AS claim_count
         FROM found_items f INNER JOIN users u ON u.id = f.logged_by
         WHERE $sqlWhere ORDER BY f.created_at DESC LIMIT $perPage OFFSET $offset",
        $params
    );
    $counts = [];
    foreach (ADMIN_FOUND_STATUSES as $status) {
        $counts[$status] = client_count('SELECT COUNT(*) FROM found_items WHERE status = ?', [$status]);
    }
    return compact('filters', 'rows', 'total', 'perPage', 'counts') + ['pages' => (int) max(1, ceil($total / $perPage))];
}

function admin_refresh_matches(int $actorId): int {
    $lostRows = admin_rows("SELECT id, item_name, category, last_seen_location FROM lost_items WHERE status = 'searching'");
    $foundRows = admin_rows("SELECT id, item_name, category, location_found FROM found_items WHERE status = 'unclaimed'");
    $inserted = 0;
    $stmt = get_db()->prepare(
        'INSERT INTO item_matches (lost_item_id, found_item_id, score, status, similarity_json)
         VALUES (?, ?, ?, \'potential\', ?)
         ON DUPLICATE KEY UPDATE score = VALUES(score), similarity_json = VALUES(similarity_json), updated_at = CURRENT_TIMESTAMP'
    );
    foreach ($lostRows as $lost) {
        foreach ($foundRows as $found) {
            $scored = admin_match_score($lost, $found);
            if ($scored['score'] < 40) {
                continue;
            }
            $stmt->execute([(int) $lost['id'], (int) $found['id'], $scored['score'], json_encode($scored['checks'])]);
            $inserted++;
        }
    }
    log_audit($actorId, 'matches_refreshed', 'suggestions=' . $inserted);
    return $inserted;
}

function admin_matching_data(): array {
    $rows = admin_rows(
        "SELECT m.*, l.item_name AS lost_name, l.category AS lost_category, l.last_seen_location, l.public_code AS lost_code, l.status AS lost_status, l.reported_by,
                f.item_name AS found_name, f.category AS found_category, f.location_found, f.public_code AS found_code, f.status AS found_status, f.photo_path, f.date_found, l.date_lost, l.photo_path AS lost_photo
         FROM item_matches m
         INNER JOIN lost_items l ON l.id = m.lost_item_id
         INNER JOIN found_items f ON f.id = m.found_item_id
         WHERE m.status IN ('potential', 'needs_review')
         ORDER BY m.score DESC, m.updated_at DESC LIMIT 30"
    );
    return [
        'rows' => $rows,
        'potential' => client_count("SELECT COUNT(*) FROM item_matches WHERE status = 'potential'"),
        'confirmed' => client_count("SELECT COUNT(*) FROM item_matches WHERE status = 'confirmed'"),
        'rejected' => client_count("SELECT COUNT(*) FROM item_matches WHERE status = 'no_match'"),
    ];
}

function admin_claims_data(array $query): array {
    $filters = admin_filters($query);
    $where = ['1=1'];
    $params = [];
    if ($filters['q'] !== '') {
        $where[] = '(c.public_code LIKE ? OR f.item_name LIKE ? OR u.full_name LIKE ? OR u.student_id LIKE ?)';
        $like = admin_like($filters['q']);
        array_push($params, $like, $like, $like, $like);
    }
    $allowed = ['pending', 'manual_review', 'approved', 'rejected'];
    if (in_array($filters['status'], $allowed, true)) {
        $where[] = 'c.status = ?';
        $params[] = $filters['status'];
    }
    $sqlWhere = implode(' AND ', $where);
    $total = client_count("SELECT COUNT(*) FROM claims c INNER JOIN found_items f ON f.id = c.found_item_id INNER JOIN users u ON u.id = c.claimant_id WHERE $sqlWhere", $params);
    [, $perPage, $offset] = client_page(['page' => $filters['page']], 10);
    $rows = admin_rows(
        "SELECT c.*, f.item_name, f.category, f.public_code AS found_code, f.photo_path, f.masked_features, u.full_name, u.email, u.student_id
         FROM claims c
         INNER JOIN found_items f ON f.id = c.found_item_id
         INNER JOIN users u ON u.id = c.claimant_id
         WHERE $sqlWhere ORDER BY c.created_at DESC LIMIT $perPage OFFSET $offset",
        $params
    );
    return [
        'filters' => $filters,
        'rows' => $rows,
        'total' => $total,
        'pages' => (int) max(1, ceil($total / $perPage)),
        'counts' => [
            'pending' => client_count("SELECT COUNT(*) FROM claims WHERE status = 'pending'"),
            'manual_review' => client_count("SELECT COUNT(*) FROM claims WHERE status = 'manual_review'"),
            'approved' => client_count("SELECT COUNT(*) FROM claims WHERE status = 'approved'"),
            'rejected' => client_count("SELECT COUNT(*) FROM claims WHERE status = 'rejected'"),
        ],
    ];
}

function admin_pickup_data(array $query): array {
    $filters = admin_filters($query);
    $lookup = null;
    $lookupMessage = '';
    if ($filters['token'] !== '') {
        $rows = admin_rows(
            "SELECT p.*, c.public_code AS claim_code, c.status AS claim_status, f.item_name, f.category, f.public_code AS found_code, f.status AS found_status,
                    u.full_name, u.student_id, u.email
             FROM pickups p
             INNER JOIN claims c ON c.id = p.claim_id
             INNER JOIN found_items f ON f.id = c.found_item_id
             INNER JOIN users u ON u.id = c.claimant_id
             WHERE p.qr_token = ? LIMIT 1",
            [$filters['token']]
        );
        $lookup = $rows[0] ?? null;
        if (!$lookup) {
            $lookupMessage = 'No pickup matches that code.';
        }
    }
    $queue = admin_rows(
        "SELECT p.id, p.qr_token, p.status, p.created_at, c.public_code AS claim_code, f.item_name, u.full_name, u.student_id
         FROM pickups p
         INNER JOIN claims c ON c.id = p.claim_id
         INNER JOIN found_items f ON f.id = c.found_item_id
         INNER JOIN users u ON u.id = c.claimant_id
         WHERE p.status = 'pending'
         ORDER BY p.created_at ASC LIMIT 20"
    );
    return [
        'filters' => $filters,
        'lookup' => $lookup,
        'lookup_message' => $lookupMessage,
        'queue' => $queue,
        'pending' => client_count("SELECT COUNT(*) FROM pickups WHERE status = 'pending'"),
        'verified' => client_count("SELECT COUNT(*) FROM pickups WHERE status = 'verified'"),
    ];
}

function admin_returned_data(array $query): array {
    $filters = admin_filters($query);
    $where = ["(f.status = 'returned' OR p.status = 'verified')"];
    $params = [];
    if ($filters['q'] !== '') {
        $where[] = '(f.item_name LIKE ? OR f.public_code LIKE ? OR u.full_name LIKE ? OR p.return_code LIKE ?)';
        $like = admin_like($filters['q']);
        array_push($params, $like, $like, $like, $like);
    }
    $sqlWhere = implode(' AND ', $where);
    $rows = admin_rows(
        "SELECT f.id AS found_id, f.item_name, f.category, f.public_code AS found_code, f.status AS found_status, f.photo_path,
                c.id AS claim_id, c.public_code AS claim_code, c.reviewed_at, c.status AS claim_status,
                p.id AS pickup_id, p.scanned_at, p.condition_note, p.return_code, p.status AS pickup_status,
                u.full_name, u.student_id, l.id AS lost_id, l.public_code AS lost_code, l.photo_path AS lost_photo, l.resolved_at
         FROM found_items f
         LEFT JOIN claims c ON c.found_item_id = f.id AND c.status = 'approved'
         LEFT JOIN pickups p ON p.claim_id = c.id
         LEFT JOIN users u ON u.id = c.claimant_id
         LEFT JOIN lost_items l ON l.id = c.lost_item_id
         WHERE $sqlWhere
         ORDER BY COALESCE(p.scanned_at, c.reviewed_at, f.created_at) DESC LIMIT 50",
        $params
    );
    return [
        'filters' => $filters,
        'rows' => $rows,
        'returned' => client_count("SELECT COUNT(*) FROM found_items WHERE status = 'returned'"),
        'verified' => client_count("SELECT COUNT(*) FROM pickups WHERE status = 'verified'"),
    ];
}

function admin_users_data(array $query): array {
    $filters = admin_filters($query);
    $where = ['1=1'];
    $params = [];
    if ($filters['q'] !== '') {
        $where[] = '(full_name LIKE ? OR email LIKE ? OR student_id LIKE ? OR program_department LIKE ?)';
        $like = admin_like($filters['q']);
        array_push($params, $like, $like, $like, $like);
    }
    if (in_array($filters['status'], ADMIN_ROLES, true)) {
        $where[] = 'role = ?';
        $params[] = $filters['status'];
    }
    $sqlWhere = implode(' AND ', $where);
    $total = client_count("SELECT COUNT(*) FROM users WHERE $sqlWhere", $params);
    [, $perPage, $offset] = client_page(['page' => $filters['page']], 10);
    $rows = admin_rows(
        "SELECT id, email, full_name, student_id, program_department, role, status, auth_provider, email_verified, created_at, last_login_at
         FROM users WHERE $sqlWhere ORDER BY created_at DESC LIMIT $perPage OFFSET $offset",
        $params
    );
    $counts = [];
    foreach (ADMIN_ROLES as $role) {
        $counts[$role] = client_count('SELECT COUNT(*) FROM users WHERE role = ?', [$role]);
    }
    return compact('filters', 'rows', 'total', 'counts') + ['pages' => (int) max(1, ceil($total / $perPage))];
}

function admin_reports_data(array $query): array {
    $filters = admin_filters($query);
    $range = admin_date_range($query);
    $filters['start'] = $range['start'];
    $filters['end'] = $range['end'];
    [$lostSql, $lostParams] = admin_date_sql('date_lost', $range, true);
    [$foundSql, $foundParams] = admin_date_sql('date_found', $range, true);
    [$claimSql, $claimParams] = admin_date_sql('created_at', $range, false);
    [$userSql, $userParams] = admin_date_sql('created_at', $range, false);
    [$recentSql, $recentParams] = admin_date_sql('c.created_at', $range, false);
    $recentClaims = admin_rows(
        "SELECT c.public_code, c.status, c.created_at, f.item_name, u.full_name
         FROM claims c
         INNER JOIN found_items f ON f.id = c.found_item_id
         INNER JOIN users u ON u.id = c.claimant_id
         WHERE $recentSql
         ORDER BY c.created_at DESC LIMIT 8",
        $recentParams
    );
    return [
        'filters' => $filters,
        'range' => $range,
        'found' => client_count("SELECT COUNT(*) FROM found_items WHERE $foundSql", $foundParams),
        'lost' => client_count("SELECT COUNT(*) FROM lost_items WHERE $lostSql", $lostParams),
        'claims' => client_count("SELECT COUNT(*) FROM claims WHERE $claimSql", $claimParams),
        'users' => client_count("SELECT COUNT(*) FROM users WHERE $userSql", $userParams),
        'lost_status' => admin_rows("SELECT status, COUNT(*) AS total FROM lost_items WHERE $lostSql GROUP BY status", $lostParams),
        'found_status' => admin_rows("SELECT status, COUNT(*) AS total FROM found_items WHERE $foundSql GROUP BY status", $foundParams),
        'claim_status' => admin_rows("SELECT status, COUNT(*) AS total FROM claims WHERE $claimSql GROUP BY status", $claimParams),
        'role_counts' => admin_rows("SELECT role, COUNT(*) AS total FROM users WHERE $userSql GROUP BY role", $userParams),
        'recent_claims' => $recentClaims,
        'chart' => admin_report_chart($range),
    ];
}

function admin_audit_clause(array $query, bool $withSearch): array {
    $filters = admin_filters($query);
    $range = admin_date_range($query);
    $filters['start'] = $range['start'];
    $filters['end'] = $range['end'];
    $where = [];
    $params = [];
    if ($withSearch && $filters['q'] !== '') {
        $where[] = '(a.action LIKE ? OR a.details LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?)';
        $like = admin_like($filters['q']);
        array_push($params, $like, $like, $like, $like);
    }
    [$dateSql, $dateParams] = admin_date_sql('a.created_at', $range, false);
    $where[] = $dateSql;
    $params = array_merge($params, $dateParams);
    return [$filters, $range, implode(' AND ', $where), $params];
}

function admin_audit_data(array $query): array {
    [$filters, $range, $sqlWhere, $params] = admin_audit_clause($query, true);
    [, , $countWhere, $countParams] = admin_audit_clause($query, false);
    $total = client_count("SELECT COUNT(*) FROM audit_trail a LEFT JOIN users u ON u.id = a.user_id WHERE $sqlWhere", $params);
    [, $perPage, $offset] = client_page(['page' => $filters['page']], 15);
    $rows = admin_rows(
        "SELECT a.id, a.user_id, a.action, a.details, a.ip_address, a.user_agent, a.created_at, u.full_name, u.email
         FROM audit_trail a LEFT JOIN users u ON u.id = a.user_id
         WHERE $sqlWhere ORDER BY a.created_at DESC LIMIT $perPage OFFSET $offset",
        $params
    );
    $count = static function (string $extra) use ($countWhere, $countParams): int {
        return client_count("SELECT COUNT(*) FROM audit_trail a WHERE $countWhere AND ($extra)", $countParams);
    };
    return [
        'filters' => $filters,
        'range' => $range,
        'rows' => $rows,
        'total' => $total,
        'pages' => (int) max(1, ceil($total / $perPage)),
        'counts' => [
            'login' => $count("a.action LIKE 'login%'"),
            'items' => $count("a.action LIKE '%item%' OR a.action LIKE 'found%' OR a.action LIKE 'lost%'"),
            'claims' => $count("a.action LIKE 'claim%'"),
            'users' => $count("a.action LIKE 'user%'"),
        ],
    ];
}

function admin_audit_export_rows(array $query): array {
    [, , $sqlWhere, $params] = admin_audit_clause($query, true);
    $rows = [];
    foreach (admin_rows("SELECT a.created_at, u.full_name, u.email, a.action, a.details, a.ip_address FROM audit_trail a LEFT JOIN users u ON u.id = a.user_id WHERE $sqlWhere ORDER BY a.created_at DESC LIMIT 1000", $params) as $row) {
        $rows[] = [(string) $row['created_at'], (string) ($row['full_name'] ?? 'System'), (string) ($row['email'] ?? ''), (string) $row['action'], (string) $row['details'], (string) $row['ip_address']];
    }
    return $rows;
}

function admin_settings_data(int $userId): array {
    $user = admin_rows(
        'SELECT id, email, full_name, role, student_id, totp_enabled, login_method FROM users WHERE id = ?',
        [$userId]
    )[0] ?? null;
    $history = admin_rows(
        "SELECT record_type, item_name, category, status, event_date FROM (
           SELECT 'Lost report' AS record_type, item_name, category, status, date_lost AS event_date, created_at FROM lost_items WHERE reported_by = ?
           UNION ALL
           SELECT 'Found item', item_name, category, status, date_found, created_at FROM found_items WHERE logged_by = ?
           UNION ALL
           SELECT 'Claim', fi.item_name, fi.category, c.status, DATE(c.created_at), c.created_at
           FROM claims c INNER JOIN found_items fi ON fi.id = c.found_item_id WHERE c.claimant_id = ?
         ) activity ORDER BY event_date DESC LIMIT 20",
        [$userId, $userId, $userId]
    );
    return ['user' => $user, 'history' => $history];
}

function admin_module(string $module, int $userId, array $query): array {
    $data = match ($module) {
        'dashboard' => admin_dashboard_data(),
        'lost-reports' => admin_lost_data($query),
        'found-items' => admin_found_data($query),
        'log-found' => ['categories' => CLIENT_CATEGORIES],
        'matching' => admin_matching_data(),
        'claims' => admin_claims_data($query),
        'pickup' => admin_pickup_data($query),
        'returned' => admin_returned_data($query),
        'users' => admin_users_data($query),
        'reports' => admin_reports_data($query),
        'audit' => admin_audit_data($query),
        'settings' => admin_settings_data($userId),
        default => null,
    };
    if ($data === null) {
        json_out(['success' => false, 'message' => 'Unknown module.'], 404);
    }
    require_once __DIR__ . '/../../dashboard/admin/views.php';
    return [
        'success' => true,
        'module' => $module,
        'html' => admin_render($module, $data),
    ];
}
