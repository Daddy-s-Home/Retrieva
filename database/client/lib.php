<?php
declare(strict_types=1);

require_once __DIR__ . '/../db.php';
require_once __DIR__ . '/../../dashboard/rbac.php';

const CLIENT_CATEGORIES = ['Phone (Android)', 'Phone (Iphone)', 'Tablet', 'ID', 'Lace', 'Tumbler/Flask/Bottled Water', 'Bag', 'Shoes', 'Notebook', 'Book', 'Other'];
const CLIENT_LOST_STATUSES = ['searching', 'matched', 'resolved', 'closed'];
const CLIENT_PAGES = [
    'dashboard' => 'client-dashboard.php',
    'lost-items' => 'client-lost-items.php',
    'found-items' => 'client-found-items.php',
    'my-reports' => 'client-my-reports.php',
    'my-claims' => 'client-my-claims.php',
    'notifications' => 'client-notifications.php',
    'settings' => 'client-settings.php',
];

function client_guard(): array {
    return require_role(RETRIEVA_CLIENT_ROLES);
}

function client_count(string $sql, array $params = []): int {
    $stmt = get_db()->prepare($sql);
    $stmt->execute($params);
    return (int) $stmt->fetchColumn();
}

function client_delta(int $current, int $previous, string $suffix = 'from last month'): array {
    if ($previous === 0 && $current === 0) {
        return ['text' => 'No change ' . $suffix, 'direction' => 'flat'];
    }
    if ($previous === 0) {
        return ['text' => 'New ' . $suffix, 'direction' => 'up'];
    }
    $pct = (int) round((($current - $previous) / $previous) * 100);
    return [
        'text' => ($pct >= 0 ? '▲ ' : '▼ ') . abs($pct) . '% ' . $suffix,
        'direction' => $pct > 0 ? 'up' : ($pct < 0 ? 'down' : 'flat'),
    ];
}

function client_month_window(): array {
    $startThis = date('Y-m-01 00:00:00');
    $startNext = date('Y-m-01 00:00:00', strtotime('first day of next month'));
    $startPrev = date('Y-m-01 00:00:00', strtotime('first day of last month'));
    return [$startPrev, $startThis, $startNext];
}

function client_photo_src(?string $path): string {
    if ($path === null || $path === '') {
        return '';
    }
    $path = str_replace('\\', '/', $path);
    if (str_contains($path, '..') || preg_match('#^[a-z][a-z0-9+.-]*:#i', $path)) {
        return '';
    }
    $path = ltrim($path, '/');
    if (!str_starts_with($path, 'uploads/')) {
        return '';
    }
    return '../' . $path;
}

function retrieva_file_list(string $field): array {
    if (!isset($_FILES[$field]) || !is_array($_FILES[$field])) {
        return [];
    }
    $files = $_FILES[$field];
    if (!is_array($files['name'])) {
        return ((int) ($files['error'] ?? UPLOAD_ERR_NO_FILE)) === UPLOAD_ERR_NO_FILE ? [] : [$files];
    }
    $list = [];
    foreach ($files['name'] as $index => $name) {
        $error = (int) ($files['error'][$index] ?? UPLOAD_ERR_NO_FILE);
        if ($error === UPLOAD_ERR_NO_FILE) {
            continue;
        }
        $list[] = [
            'name' => $name,
            'type' => $files['type'][$index] ?? '',
            'tmp_name' => $files['tmp_name'][$index] ?? '',
            'error' => $error,
            'size' => $files['size'][$index] ?? 0,
        ];
    }
    return $list;
}

function retrieva_store_photo(array $file, string $folder): string {
    if (!in_array($folder, ['lost', 'found'], true)) {
        throw new InvalidArgumentException('The photo could not be saved.');
    }
    $error = (int) ($file['error'] ?? UPLOAD_ERR_NO_FILE);
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
    $dir = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . $folder;
    if (!is_dir($dir) && !mkdir($dir, 0755, true) && !is_dir($dir)) {
        throw new RuntimeException('Photo storage is unavailable.');
    }
    $name = $folder . '_' . bin2hex(random_bytes(8)) . '.' . $ext;
    if (!move_uploaded_file((string) $file['tmp_name'], $dir . DIRECTORY_SEPARATOR . $name)) {
        throw new RuntimeException('The photo could not be saved.');
    }
    return 'uploads/' . $folder . '/' . $name;
}

function retrieva_photo_map(string $type, array $covers): array {
    $map = [];
    foreach ($covers as $id => $cover) {
        $map[(int) $id] = [];
    }
    if ($map === [] || !in_array($type, ['lost', 'found'], true)) {
        return $map;
    }
    $ids = array_keys($map);
    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $stmt = get_db()->prepare(
        "SELECT id, entity_id, photo_path FROM item_images WHERE entity_type = ? AND entity_id IN ($placeholders) ORDER BY sort_order ASC, id ASC"
    );
    $stmt->execute(array_merge([$type], $ids));
    foreach ($stmt->fetchAll() as $row) {
        $src = client_photo_src($row['photo_path'] ?? null);
        if ($src === '') {
            continue;
        }
        $map[(int) $row['entity_id']][] = ['id' => (int) $row['id'], 'src' => $src];
    }
    foreach ($covers as $id => $cover) {
        $id = (int) $id;
        if ($map[$id] === [] && is_string($cover) && $cover !== '') {
            $map[$id][] = ['id' => 0, 'src' => $cover];
        }
    }
    return $map;
}

function retrieva_save_photos(string $type, int $id, array $input): void {
    if (!in_array($type, ['lost', 'found'], true) || $id < 1) {
        throw new InvalidArgumentException('The photo could not be saved.');
    }
    $table = $type === 'found' ? 'found_items' : 'lost_items';
    $folder = $type;
    $db = get_db();
    $coverStmt = $db->prepare("SELECT photo_path FROM {$table} WHERE id = ?");
    $coverStmt->execute([$id]);
    $cover = (string) ($coverStmt->fetchColumn() ?: '');
    $rows = $db->prepare('SELECT id, photo_path FROM item_images WHERE entity_type = ? AND entity_id = ? ORDER BY sort_order ASC, id ASC');
    $rows->execute([$type, $id]);
    $existing = $rows->fetchAll();
    $remove = [];
    foreach ((array) ($input['remove_photos'] ?? []) as $photoId) {
        $photoId = filter_var($photoId, FILTER_VALIDATE_INT);
        if ($photoId) {
            $remove[(int) $photoId] = true;
        }
    }
    $dropLegacy = !empty($input['remove_legacy']);
    $uploads = retrieva_file_list('photos');
    $kept = 0;
    foreach ($existing as $row) {
        if (!isset($remove[(int) $row['id']])) {
            $kept++;
        }
    }
    if ($existing === [] && $cover !== '' && !$dropLegacy) {
        $kept = 1;
    }
    $total = $kept + count($uploads);
    if ($total < 1 || $total > 5) {
        throw new InvalidArgumentException('Add between 1 and 5 photos.');
    }
    if ($existing === [] && $cover !== '' && !$dropLegacy) {
        $insert = $db->prepare('INSERT INTO item_images (entity_type, entity_id, photo_path, sort_order) VALUES (?, ?, ?, 0)');
        $insert->execute([$type, $id, $cover]);
    }
    if ($remove !== []) {
        $ids = array_keys($remove);
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $select = $db->prepare("SELECT id, photo_path FROM item_images WHERE entity_type = ? AND entity_id = ? AND id IN ($placeholders)");
        $select->execute(array_merge([$type, $id], $ids));
        $stored = [];
        foreach ($select->fetchAll() as $row) {
            $stored[] = (int) $row['id'];
            retrieva_unlink_owned($row['photo_path'] ?? '');
        }
        if ($stored !== []) {
            $placeholders = implode(',', array_fill(0, count($stored), '?'));
            $delete = $db->prepare("DELETE FROM item_images WHERE entity_type = ? AND entity_id = ? AND id IN ($placeholders)");
            $delete->execute(array_merge([$type, $id], $stored));
        }
    }
    $sortStmt = $db->prepare('SELECT COALESCE(MAX(sort_order), -1) + 1 FROM item_images WHERE entity_type = ? AND entity_id = ?');
    $sortStmt->execute([$type, $id]);
    $sort = (int) $sortStmt->fetchColumn();
    $insert = $db->prepare('INSERT INTO item_images (entity_type, entity_id, photo_path, sort_order) VALUES (?, ?, ?, ?)');
    foreach ($uploads as $file) {
        $path = retrieva_store_photo($file, $folder);
        $insert->execute([$type, $id, $path, $sort]);
        $sort++;
    }
    $first = $db->prepare('SELECT photo_path FROM item_images WHERE entity_type = ? AND entity_id = ? ORDER BY sort_order ASC, id ASC LIMIT 1');
    $first->execute([$type, $id]);
    $coverPath = $first->fetchColumn();
    $update = $db->prepare("UPDATE {$table} SET photo_path = ? WHERE id = ?");
    $update->execute([$coverPath ?: null, $id]);
}

function retrieva_unlink_owned(?string $path): void {
    $path = str_replace('\\', '/', (string) $path);
    $name = basename($path);
    if (!preg_match('/^(lost|found)_[a-f0-9]{16}\.(jpg|png|webp)$/', $name)) {
        return;
    }
    $full = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . substr($name, 0, strpos($name, '_')) . DIRECTORY_SEPARATOR . $name;
    if (is_file($full)) {
        unlink($full);
    }
}

function retrieva_delete_photos(string $type, int $id): void {
    if (!in_array($type, ['lost', 'found'], true) || $id < 1) {
        return;
    }
    $stmt = get_db()->prepare('SELECT photo_path FROM item_images WHERE entity_type = ? AND entity_id = ?');
    $stmt->execute([$type, $id]);
    foreach ($stmt->fetchAll() as $row) {
        retrieva_unlink_owned($row['photo_path'] ?? '');
    }
    $delete = get_db()->prepare('DELETE FROM item_images WHERE entity_type = ? AND entity_id = ?');
    $delete->execute([$type, $id]);
}

function client_public_summary(?string $summary): string {
    $summary = trim((string) $summary);
    return $summary !== '' ? $summary : 'Some identifying details have been hidden for security purposes.';
}

function client_lost_label(string $status): string {
    return match ($status) {
        'searching' => 'Active',
        'matched' => 'Matched',
        'resolved' => 'Resolved',
        'closed' => 'Closed',
        default => ucfirst($status),
    };
}

function client_claim_label(array $row): string {
    if (!empty($row['scanned_at'])) {
        return 'Collected';
    }
    return match ($row['status']) {
        'pending', 'manual_review' => 'Pending Verification',
        'approved' => 'Approved',
        'rejected' => 'Rejected',
        default => ucfirst((string) $row['status']),
    };
}

function client_date(?string $value, string $format = 'M j, Y'): string {
    if ($value === null || $value === '') {
        return '';
    }
    $time = strtotime($value);
    return $time ? date($format, $time) : '';
}

function client_ago(?string $value): string {
    if ($value === null || $value === '') {
        return '';
    }
    $diff = time() - strtotime($value);
    if ($diff < 60) {
        return 'just now';
    }
    if ($diff < 3600) {
        $mins = (int) floor($diff / 60);
        return $mins . ' minute' . ($mins === 1 ? '' : 's') . ' ago';
    }
    if ($diff < 86400) {
        $hours = (int) floor($diff / 3600);
        return $hours . ' hour' . ($hours === 1 ? '' : 's') . ' ago';
    }
    $days = (int) floor($diff / 86400);
    return $days . ' day' . ($days === 1 ? '' : 's') . ' ago';
}

function client_saved_ids(int $userId, string $type): array {
    $stmt = get_db()->prepare('SELECT entity_id FROM saved_items WHERE user_id = ? AND entity_type = ?');
    $stmt->execute([$userId, $type]);
    $ids = [];
    foreach ($stmt->fetchAll() as $row) {
        $ids[(int) $row['entity_id']] = true;
    }
    return $ids;
}

function client_text(array $query, string $key = 'q'): string {
    $value = trim((string) ($query[$key] ?? ''));
    return strlen($value) > 80 ? substr($value, 0, 80) : $value;
}

function client_category(array $query): string {
    $category = (string) ($query['category'] ?? '');
    return in_array($category, CLIENT_CATEGORIES, true) ? $category : '';
}

function client_sort(array $query): string {
    return (($query['sort'] ?? '') === 'oldest') ? 'ASC' : 'DESC';
}

function client_page(array $query, int $perPage): array {
    $page = max(1, (int) ($query['page'] ?? 1));
    return [$page, $perPage, ($page - 1) * $perPage];
}

function client_valid_date(string $value): ?string {
    $date = DateTime::createFromFormat('Y-m-d', $value);
    return ($date instanceof DateTime && $date->format('Y-m-d') === $value) ? $value : null;
}

function client_notify(int $userId, string $category, string $title, string $body, ?string $entityType = null, ?int $entityId = null): void {
    $stmt = get_db()->prepare(
        'INSERT INTO notifications (user_id, category, title, body, entity_type, entity_id) VALUES (?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([$userId, $category, $title, $body, $entityType, $entityId]);
}

function client_map_found(array $row, bool $saved): array {
    return [
        'id' => (int) $row['id'],
        'public_code' => (string) ($row['public_code'] ?? ''),
        'item_name' => (string) $row['item_name'],
        'category' => (string) $row['category'],
        'location_found' => (string) $row['location_found'],
        'date_found' => client_date($row['date_found'] ?? null),
        'photo' => client_photo_src($row['photo_path'] ?? null),
        'summary' => client_public_summary($row['public_summary'] ?? null),
        'status' => (string) $row['status'],
        'saved' => $saved,
        'can_claim' => $row['status'] === 'unclaimed',
    ];
}

function client_map_lost(array $row, bool $saved): array {
    return [
        'id' => (int) $row['id'],
        'public_code' => (string) ($row['public_code'] ?? ''),
        'item_name' => (string) $row['item_name'],
        'category' => (string) $row['category'],
        'location' => (string) ($row['last_seen_location'] ?? ''),
        'date_lost' => client_date($row['date_lost'] ?? null),
        'date_lost_raw' => substr((string) ($row['date_lost'] ?? ''), 0, 10),
        'date_reported' => client_date($row['created_at'] ?? null),
        'photo' => client_photo_src($row['photo_path'] ?? null),
        'description' => (string) ($row['description'] ?? ''),
        'status' => (string) $row['status'],
        'label' => client_lost_label((string) $row['status']),
        'closed_reason' => (string) ($row['closed_reason'] ?? ''),
        'matched_at' => client_date($row['matched_at'] ?? null, 'M j'),
        'verified_at' => client_date($row['verified_at'] ?? null, 'M j'),
        'resolved_at' => client_date($row['resolved_at'] ?? null, 'M j'),
        'reported_at' => client_date($row['created_at'] ?? null, 'M j'),
        'saved' => $saved,
        'can_edit' => $row['status'] === 'searching',
    ];
}

function client_show_qr(array $row): bool {
    if (($row['status'] ?? '') !== 'approved' || empty($row['pickup_id']) || !empty($row['scanned_at'])) {
        return false;
    }
    if (($row['pickup_status'] ?? 'pending') !== 'pending') {
        return false;
    }
    if (!empty($row['expires_at']) && strtotime((string) $row['expires_at']) <= time()) {
        return false;
    }
    return true;
}

function client_map_claim(array $row, bool $includeSecret): array {
    $showQr = $includeSecret && client_show_qr($row);
    $answers = json_decode((string) ($row['claimant_answers'] ?? ''), true);
    $answer = is_array($answers) && isset($answers[0]) ? (string) $answers[0] : '';
    return [
        'id' => (int) $row['id'],
        'found_id' => (int) ($row['found_item_id'] ?? 0),
        'public_code' => (string) ($row['public_code'] ?? ''),
        'item_name' => (string) $row['item_name'],
        'category' => (string) $row['category'],
        'location' => (string) ($row['location_found'] ?? ''),
        'date_found' => client_date($row['date_found'] ?? null),
        'photo' => client_photo_src($row['photo_path'] ?? null),
        'summary' => client_public_summary($row['public_summary'] ?? null),
        'status' => (string) $row['status'],
        'label' => client_claim_label($row),
        'rejection_reason' => (string) ($row['rejection_reason'] ?? ''),
        'claimed_on' => client_date($row['created_at'] ?? null),
        'submitted_at' => client_date($row['created_at'] ?? null, 'M j'),
        'reviewed_at' => client_date($row['reviewed_at'] ?? null, 'M j'),
        'collected' => !empty($row['scanned_at']),
        'collected_at' => client_date($row['scanned_at'] ?? null, 'M j'),
        'answer' => $includeSecret ? $answer : '',
        'show_qr' => $showQr,
        'qr_token' => $showQr ? (string) $row['qr_token'] : '',
        'pickup_code' => $showQr ? (string) (($row['return_code'] ?? '') !== '' ? $row['return_code'] : ($row['public_code'] ?? '')) : '',
    ];
}

function client_dashboard_data(int $userId): array {
    [$prev, $thisStart, $next] = client_month_window();
    $reports = client_count('SELECT COUNT(*) FROM lost_items WHERE reported_by = ?', [$userId]);
    $activeReports = client_count("SELECT COUNT(*) FROM lost_items WHERE reported_by = ? AND status = 'searching'", [$userId]);
    $resolvedReports = client_count("SELECT COUNT(*) FROM lost_items WHERE reported_by = ? AND status = 'resolved'", [$userId]);
    $activeClaims = client_count("SELECT COUNT(*) FROM claims WHERE claimant_id = ? AND status IN ('pending','manual_review')", [$userId]);
    $matches = client_count(
        "SELECT COUNT(*) FROM item_matches m JOIN lost_items l ON l.id = m.lost_item_id WHERE l.reported_by = ? AND m.status <> 'no_match'",
        [$userId]
    );
    $newMatches = client_count(
        "SELECT COUNT(*) FROM item_matches m JOIN lost_items l ON l.id = m.lost_item_id WHERE l.reported_by = ? AND m.status <> 'no_match' AND m.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)",
        [$userId]
    );
    $unread = client_count('SELECT COUNT(*) FROM notifications WHERE user_id = ? AND read_at IS NULL', [$userId]);
    $user = get_db()->prepare('SELECT full_name, role, student_id FROM users WHERE id = ?');
    $user->execute([$userId]);
    $profile = $user->fetch() ?: ['full_name' => '', 'role' => 'student', 'student_id' => ''];

    $foundStmt = get_db()->prepare(
        "SELECT id, public_code, item_name, category, location_found, date_found, photo_path, public_summary, status, created_at
         FROM found_items WHERE status <> 'disposed' ORDER BY created_at DESC LIMIT 4"
    );
    $foundStmt->execute();
    $savedFound = client_saved_ids($userId, 'found');
    $recentFound = array_map(fn(array $row) => client_map_found($row, isset($savedFound[(int) $row['id']])), $foundStmt->fetchAll());

    $reportStmt = get_db()->prepare(
        'SELECT id, public_code, item_name, category, last_seen_location, date_lost, photo_path, description, status, created_at, closed_reason, matched_at, verified_at, resolved_at, closed_at
         FROM lost_items WHERE reported_by = ? ORDER BY created_at DESC LIMIT 2'
    );
    $reportStmt->execute([$userId]);
    $myReports = array_map(fn(array $row) => client_map_lost($row, false), $reportStmt->fetchAll());

    $claimStmt = get_db()->prepare(
        "SELECT c.id, c.public_code, c.status, c.rejection_reason, c.created_at, c.reviewed_at, c.claimant_answers,
                f.id AS found_item_id, f.item_name, f.category, f.location_found, f.date_found, f.photo_path, f.public_summary,
                p.id AS pickup_id, p.qr_token, p.expires_at, p.scanned_at, p.status AS pickup_status, p.return_code
         FROM claims c
         JOIN found_items f ON f.id = c.found_item_id
         LEFT JOIN pickups p ON p.claim_id = c.id
         WHERE c.claimant_id = ?
         ORDER BY c.created_at DESC LIMIT 2"
    );
    $claimStmt->execute([$userId]);
    $myClaims = array_map(fn(array $row) => client_map_claim($row, false), $claimStmt->fetchAll());

    $noteStmt = get_db()->prepare(
        'SELECT id, category, title, body, entity_type, entity_id, read_at, created_at
         FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 4'
    );
    $noteStmt->execute([$userId]);
    $notes = array_map('client_map_notification', $noteStmt->fetchAll());

    $hour = (int) (new DateTime('now', new DateTimeZone('Asia/Manila')))->format('G');
    $greeting = $hour < 12 ? 'Good morning' : ($hour < 17 ? 'Good afternoon' : 'Good evening');
    return [
        'greeting' => $greeting,
        'first_name' => explode(' ', trim((string) $profile['full_name']))[0] ?: 'there',
        'role_label' => ucfirst((string) $profile['role']),
        'student_id' => (string) ($profile['student_id'] ?? ''),
        'kpis' => [
            'reports' => ['value' => $reports, 'detail' => $activeReports . ' active · ' . $resolvedReports . ' resolved'],
            'claims' => ['value' => $activeClaims, 'detail' => 'Under verification'],
            'matches' => ['value' => $matches, 'detail' => $newMatches . ' new found items'],
            'notifications' => ['value' => $unread, 'detail' => $newMatches . ' new matches'],
        ],
        'recent_found' => $recentFound,
        'my_reports' => $myReports,
        'my_claims' => $myClaims,
        'notifications' => $notes,
        'month' => [$prev, $thisStart, $next],
    ];
}

function client_map_notification(array $row): array {
    return [
        'id' => (int) $row['id'],
        'category' => (string) $row['category'],
        'title' => (string) $row['title'],
        'body' => (string) $row['body'],
        'entity_type' => (string) ($row['entity_type'] ?? ''),
        'entity_id' => (int) ($row['entity_id'] ?? 0),
        'unread' => empty($row['read_at']),
        'ago' => client_ago($row['created_at'] ?? null),
        'when' => client_date($row['created_at'] ?? null, 'F j, Y, g:i A'),
    ];
}

function client_lost_scope_counts(string $where, array $params): array {
    return [
        'all' => client_count("SELECT COUNT(*) FROM lost_items l WHERE $where", $params),
        'active' => client_count("SELECT COUNT(*) FROM lost_items l WHERE $where AND l.status = 'searching'", $params),
        'resolved' => client_count("SELECT COUNT(*) FROM lost_items l WHERE $where AND l.status = 'resolved'", $params),
        'closed' => client_count("SELECT COUNT(*) FROM lost_items l WHERE $where AND l.status = 'closed'", $params),
        'matched' => client_count("SELECT COUNT(*) FROM lost_items l WHERE $where AND l.status = 'matched'", $params),
        'searching' => client_count("SELECT COUNT(*) FROM lost_items l WHERE $where AND l.status = 'searching'", $params),
    ];
}

function client_lost_items_data(int $userId, array $query, bool $mineOnly): array {
    [$prev, $thisStart, $next] = client_month_window();
    $baseWhere = $mineOnly ? 'l.reported_by = ?' : 'l.is_public = 1';
    $baseParams = $mineOnly ? [$userId] : [];
    $counts = client_lost_scope_counts($baseWhere, $baseParams);
    $saved = client_saved_ids($userId, 'lost');
    $perPage = $mineOnly ? 6 : 10;
    [$page, $perPage, $offset] = client_page($query, $perPage);
    $where = [$baseWhere];
    $params = $baseParams;
    $category = client_category($query);
    if ($category !== '') {
        $where[] = 'l.category = ?';
        $params[] = $category;
    }
    $location = trim((string) ($query['location'] ?? ''));
    if ($location !== '' && strlen($location) <= 150) {
        $where[] = 'l.last_seen_location = ?';
        $params[] = $location;
    }
    $status = (string) ($query['status'] ?? '');
    $tab = (string) ($query['tab'] ?? 'all');
    $statusSql = client_lost_status_sql($status !== '' ? $status : $tab);
    if ($statusSql !== null) {
        $where[] = $statusSql;
    }
    $start = client_valid_date((string) ($query['start'] ?? ''));
    $end = client_valid_date((string) ($query['end'] ?? ''));
    if ($start) {
        $where[] = 'DATE(l.created_at) >= ?';
        $params[] = $start;
    }
    if ($end) {
        $where[] = 'DATE(l.created_at) <= ?';
        $params[] = $end;
    }
    $q = client_text($query);
    if ($q !== '') {
        $like = '%' . $q . '%';
        $where[] = '(l.item_name LIKE ? OR l.category LIKE ? OR l.last_seen_location LIKE ? OR l.description LIKE ? OR l.public_code LIKE ?)';
        array_push($params, $like, $like, $like, $like, $like);
    }
    $sqlWhere = implode(' AND ', $where);
    $total = client_count("SELECT COUNT(*) FROM lost_items l WHERE $sqlWhere", $params);
    $pages = max(1, (int) ceil($total / $perPage));
    if ($page > $pages) {
        $page = $pages;
        $offset = ($page - 1) * $perPage;
    }
    $sort = client_sort($query);
    $stmt = get_db()->prepare(
        "SELECT l.id, l.public_code, l.item_name, l.category, l.last_seen_location, l.date_lost, l.photo_path, l.description, l.status, l.created_at, l.closed_reason, l.matched_at, l.verified_at, l.resolved_at, l.closed_at
         FROM lost_items l WHERE $sqlWhere ORDER BY l.created_at $sort LIMIT $perPage OFFSET $offset"
    );
    $stmt->execute($params);
    $items = array_map(fn(array $row) => client_map_lost($row, isset($saved[(int) $row['id']])), $stmt->fetchAll());
    $locations = get_db()->query(
        "SELECT DISTINCT last_seen_location FROM lost_items WHERE last_seen_location IS NOT NULL AND last_seen_location <> '' ORDER BY last_seen_location"
    )->fetchAll(PDO::FETCH_COLUMN);

    $thisMonth = client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND l.created_at >= ? AND l.created_at < ?", array_merge($baseParams, [$thisStart, $next]));
    $lastMonth = client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND l.created_at >= ? AND l.created_at < ?", array_merge($baseParams, [$prev, $thisStart]));
    $today = client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND DATE(l.created_at) = CURDATE()", $baseParams);
    $yesterday = client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND DATE(l.created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)", $baseParams);

    return [
        'counts' => $counts,
        'items' => $items,
        'locations' => array_values(array_filter(array_map('strval', $locations))),
        'page' => $page,
        'pages' => $pages,
        'per_page' => $perPage,
        'total' => $total,
        'from' => $total === 0 ? 0 : $offset + 1,
        'to' => min($offset + $perPage, $total),
        'filters' => [
            'q' => $q,
            'category' => $category,
            'location' => $location,
            'status' => $status,
            'tab' => $tab,
            'start' => $start ?? '',
            'end' => $end ?? '',
            'sort' => $sort === 'ASC' ? 'oldest' : 'latest',
        ],
        'deltas' => [
            'total' => client_delta($thisMonth, $lastMonth),
            'active' => client_delta(
                client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND l.status = 'searching' AND l.created_at >= ? AND l.created_at < ?", array_merge($baseParams, [$thisStart, $next])),
                client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND l.status = 'searching' AND l.created_at >= ? AND l.created_at < ?", array_merge($baseParams, [$prev, $thisStart]))
            ),
            'resolved' => client_delta(
                client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND l.status = 'resolved' AND l.created_at >= ? AND l.created_at < ?", array_merge($baseParams, [$thisStart, $next])),
                client_count("SELECT COUNT(*) FROM lost_items l WHERE $baseWhere AND l.status = 'resolved' AND l.created_at >= ? AND l.created_at < ?", array_merge($baseParams, [$prev, $thisStart]))
            ),
            'today' => client_delta($today, $yesterday, 'from yesterday'),
        ],
        'today' => $today,
    ];
}

function client_lost_status_sql(string $status): ?string {
    return match ($status) {
        'active', 'searching' => "l.status = 'searching'",
        'matched' => "l.status = 'matched'",
        'resolved' => "l.status = 'resolved'",
        'closed' => "l.status = 'closed'",
        default => null,
    };
}

function client_found_items_data(int $userId, array $query): array {
    [$prev, $thisStart, $next] = client_month_window();
    $saved = client_saved_ids($userId, 'found');
    [$page, $perPage, $offset] = client_page($query, 8);
    $where = ["f.status <> 'disposed'"];
    $params = [];
    $category = client_category($query);
    $tab = (string) ($query['tab'] ?? 'all');
    if ($category === '' && in_array($tab, CLIENT_CATEGORIES, true)) {
        $category = $tab;
    }
    if ($category !== '') {
        $where[] = 'f.category = ?';
        $params[] = $category;
    }
    $location = trim((string) ($query['location'] ?? ''));
    if ($location !== '' && strlen($location) <= 150) {
        $where[] = 'f.location_found = ?';
        $params[] = $location;
    }
    $dates = (string) ($query['dates'] ?? 'all');
    if (!in_array($dates, ['all', '7', '30', 'month'], true)) {
        $dates = 'all';
    }
    if ($dates === '7') {
        $where[] = 'f.date_found >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)';
    } elseif ($dates === '30') {
        $where[] = 'f.date_found >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)';
    } elseif ($dates === 'month') {
        $where[] = 'f.date_found >= ? AND f.date_found < ?';
        $params[] = substr($thisStart, 0, 10);
        $params[] = substr($next, 0, 10);
    }
    $q = client_text($query);
    if ($q !== '') {
        $like = '%' . $q . '%';
        $where[] = '(f.item_name LIKE ? OR f.category LIKE ? OR f.location_found LIKE ? OR f.public_code LIKE ? OR f.public_summary LIKE ?)';
        array_push($params, $like, $like, $like, $like, $like);
    }
    $sqlWhere = implode(' AND ', $where);
    $total = client_count("SELECT COUNT(*) FROM found_items f WHERE $sqlWhere", $params);
    $pages = max(1, (int) ceil($total / $perPage));
    if ($page > $pages) {
        $page = $pages;
        $offset = ($page - 1) * $perPage;
    }
    $sort = client_sort($query);
    $stmt = get_db()->prepare(
        "SELECT f.id, f.public_code, f.item_name, f.category, f.location_found, f.date_found, f.photo_path, f.public_summary, f.status, f.created_at
         FROM found_items f WHERE $sqlWhere ORDER BY f.created_at $sort LIMIT $perPage OFFSET $offset"
    );
    $stmt->execute($params);
    $items = array_map(fn(array $row) => client_map_found($row, isset($saved[(int) $row['id']])), $stmt->fetchAll());
    $categoryCounts = [];
    foreach (CLIENT_CATEGORIES as $name) {
        $categoryCounts[$name] = client_count('SELECT COUNT(*) FROM found_items WHERE status <> \'disposed\' AND category = ?', [$name]);
    }
    $locations = get_db()->query("SELECT DISTINCT location_found FROM found_items WHERE status <> 'disposed' ORDER BY location_found")->fetchAll(PDO::FETCH_COLUMN);
    $openReports = get_db()->prepare("SELECT id, item_name FROM lost_items WHERE reported_by = ? AND status IN ('searching','matched') ORDER BY created_at DESC");
    $openReports->execute([$userId]);
    $base = "status <> 'disposed'";
    $totalAll = client_count("SELECT COUNT(*) FROM found_items WHERE $base");
    $pending = client_count("SELECT COUNT(*) FROM claims WHERE status IN ('pending','manual_review')");
    $returned = client_count("SELECT COUNT(*) FROM found_items f WHERE f.status = 'returned' OR EXISTS (SELECT 1 FROM claims c JOIN pickups p ON p.claim_id = c.id WHERE c.found_item_id = f.id AND p.scanned_at IS NOT NULL)");
    $newWeek = client_count("SELECT COUNT(*) FROM found_items WHERE $base AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
    $prevWeek = client_count("SELECT COUNT(*) FROM found_items WHERE $base AND created_at >= DATE_SUB(NOW(), INTERVAL 14 DAY) AND created_at < DATE_SUB(NOW(), INTERVAL 7 DAY)");

    return [
        'counts' => [
            'all' => $totalAll,
            'categories' => $categoryCounts,
        ],
        'items' => $items,
        'locations' => array_values(array_map('strval', $locations)),
        'open_reports' => $openReports->fetchAll(),
        'page' => $page,
        'pages' => $pages,
        'per_page' => $perPage,
        'total' => $total,
        'from' => $total === 0 ? 0 : $offset + 1,
        'to' => min($offset + $perPage, $total),
        'filters' => [
            'q' => $q,
            'category' => $category,
            'location' => $location,
            'dates' => $dates,
            'tab' => $category !== '' ? $category : 'all',
            'sort' => $sort === 'ASC' ? 'oldest' : 'latest',
        ],
        'kpis' => [
            'total' => $totalAll,
            'pending' => $pending,
            'returned' => $returned,
            'new_week' => $newWeek,
        ],
        'deltas' => [
            'total' => client_delta(
                client_count("SELECT COUNT(*) FROM found_items WHERE $base AND created_at >= ? AND created_at < ?", [$thisStart, $next]),
                client_count("SELECT COUNT(*) FROM found_items WHERE $base AND created_at >= ? AND created_at < ?", [$prev, $thisStart])
            ),
            'pending' => client_delta(
                client_count("SELECT COUNT(*) FROM claims WHERE status IN ('pending','manual_review') AND created_at >= ? AND created_at < ?", [$thisStart, $next]),
                client_count("SELECT COUNT(*) FROM claims WHERE status IN ('pending','manual_review') AND created_at >= ? AND created_at < ?", [$prev, $thisStart])
            ),
            'returned' => client_delta(
                client_count("SELECT COUNT(*) FROM pickups WHERE scanned_at IS NOT NULL AND scanned_at >= ? AND scanned_at < ?", [$thisStart, $next]),
                client_count("SELECT COUNT(*) FROM pickups WHERE scanned_at IS NOT NULL AND scanned_at >= ? AND scanned_at < ?", [$prev, $thisStart])
            ),
            'new_week' => client_delta($newWeek, $prevWeek, 'from the previous week'),
        ],
    ];
}

function client_claims_data(int $userId, array $query): array {
    [$page, $perPage, $offset] = client_page($query, 6);
    $where = ['c.claimant_id = ?'];
    $params = [$userId];
    $tab = (string) ($query['tab'] ?? 'all');
    if ($tab === 'pending') {
        $where[] = "c.status IN ('pending','manual_review')";
    } elseif ($tab === 'approved') {
        $where[] = "c.status = 'approved' AND p.scanned_at IS NULL";
    } elseif ($tab === 'collected') {
        $where[] = 'p.scanned_at IS NOT NULL';
    } elseif ($tab === 'rejected') {
        $where[] = "c.status = 'rejected'";
    }
    $q = client_text($query);
    if ($q !== '') {
        $like = '%' . $q . '%';
        $where[] = '(f.item_name LIKE ? OR f.category LIKE ? OR c.public_code LIKE ? OR c.status LIKE ?)';
        array_push($params, $like, $like, $like, $like);
    }
    $sqlWhere = implode(' AND ', $where);
    $joins = 'FROM claims c JOIN found_items f ON f.id = c.found_item_id LEFT JOIN pickups p ON p.claim_id = c.id';
    $total = client_count("SELECT COUNT(*) $joins WHERE $sqlWhere", $params);
    $pages = max(1, (int) ceil($total / $perPage));
    if ($page > $pages) {
        $page = $pages;
        $offset = ($page - 1) * $perPage;
    }
    $sort = client_sort($query);
    $stmt = get_db()->prepare(
        "SELECT c.id, c.public_code, c.status, c.rejection_reason, c.created_at, c.reviewed_at, c.claimant_answers,
                f.id AS found_item_id, f.item_name, f.category, f.location_found, f.date_found, f.photo_path, f.public_summary,
                p.id AS pickup_id, p.qr_token, p.expires_at, p.scanned_at, p.status AS pickup_status, p.return_code
         $joins WHERE $sqlWhere ORDER BY c.created_at $sort LIMIT $perPage OFFSET $offset"
    );
    $stmt->execute($params);
    $items = array_map(fn(array $row) => client_map_claim($row, true), $stmt->fetchAll());
    $base = 'WHERE claimant_id = ?';
    return [
        'items' => $items,
        'page' => $page,
        'pages' => $pages,
        'total' => $total,
        'from' => $total === 0 ? 0 : $offset + 1,
        'to' => min($offset + $perPage, $total),
        'filters' => ['q' => $q, 'tab' => $tab, 'sort' => $sort === 'ASC' ? 'oldest' : 'latest'],
        'counts' => [
            'all' => client_count("SELECT COUNT(*) FROM claims $base", [$userId]),
            'pending' => client_count("SELECT COUNT(*) FROM claims $base AND status IN ('pending','manual_review')", [$userId]),
            'approved' => client_count("SELECT COUNT(*) FROM claims c LEFT JOIN pickups p ON p.claim_id = c.id WHERE c.claimant_id = ? AND c.status = 'approved' AND p.scanned_at IS NULL", [$userId]),
            'collected' => client_count('SELECT COUNT(*) FROM claims c JOIN pickups p ON p.claim_id = c.id WHERE c.claimant_id = ? AND p.scanned_at IS NOT NULL', [$userId]),
            'rejected' => client_count("SELECT COUNT(*) FROM claims $base AND status = 'rejected'", [$userId]),
        ],
    ];
}

function client_notifications_data(int $userId, array $query): array {
    $where = ['user_id = ?'];
    $params = [$userId];
    $tab = (string) ($query['tab'] ?? 'all');
    if ($tab === 'unread') {
        $where[] = 'read_at IS NULL';
    } elseif (in_array($tab, ['match', 'claim', 'report', 'system'], true)) {
        $where[] = 'category = ?';
        $params[] = $tab;
    }
    $q = client_text($query);
    if ($q !== '') {
        $like = '%' . $q . '%';
        $where[] = '(title LIKE ? OR body LIKE ?)';
        array_push($params, $like, $like);
    }
    $open = max(0, (int) ($query['open'] ?? 0));
    $sqlWhere = implode(' AND ', $where);
    $stmt = get_db()->prepare("SELECT id, category, title, body, entity_type, entity_id, read_at, created_at FROM notifications WHERE $sqlWhere ORDER BY created_at DESC LIMIT 50");
    $stmt->execute($params);
    $items = array_map('client_map_notification', $stmt->fetchAll());
    if ($open === 0 && $items) {
        $open = (int) $items[0]['id'];
    }
    return [
        'items' => $items,
        'open_id' => $open,
        'filters' => ['q' => $q, 'tab' => $tab],
        'counts' => [
            'all' => client_count('SELECT COUNT(*) FROM notifications WHERE user_id = ?', [$userId]),
            'unread' => client_count('SELECT COUNT(*) FROM notifications WHERE user_id = ? AND read_at IS NULL', [$userId]),
            'match' => client_count("SELECT COUNT(*) FROM notifications WHERE user_id = ? AND category = 'match'", [$userId]),
            'claim' => client_count("SELECT COUNT(*) FROM notifications WHERE user_id = ? AND category = 'claim'", [$userId]),
            'report' => client_count("SELECT COUNT(*) FROM notifications WHERE user_id = ? AND category = 'report'", [$userId]),
            'system' => client_count("SELECT COUNT(*) FROM notifications WHERE user_id = ? AND category = 'system'", [$userId]),
        ],
    ];
}

function client_settings_data(int $userId, array $query = []): array {
    $stmt = get_db()->prepare(
        'SELECT id, email, student_id, phone, program_department, email_verified, phone_verified, full_name, role,
                avatar_url, totp_enabled, password_is_set, login_method, notify_email, notify_sms, notify_in_app, notify_matches, notify_system, share_lost_reports
         FROM users WHERE id = ?'
    );
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    if (!$user) {
        return [];
    }
    $user['id'] = (int) $user['id'];
    $user['totp_enabled'] = (int) $user['totp_enabled'] === 1;
    $user['password_is_set'] = (int) $user['password_is_set'] === 1;
    foreach (['email_verified', 'phone_verified', 'notify_email', 'notify_sms', 'notify_in_app', 'notify_matches', 'notify_system', 'share_lost_reports'] as $flag) {
        $user[$flag] = (int) $user[$flag] === 1;
    }
    $q = client_text($query);
    $catalog = [
        'account' => 'account information email phone student program department ' . $user['full_name'] . ' ' . $user['email'],
        'security' => 'security password authenticator two-factor email otp create change login method sign-in code',
        'notifications' => 'notification preferences email sms in-app match system announcements',
        'privacy' => 'privacy lost reports campus listing visibility',
    ];
    $sections = array_keys($catalog);
    if ($q !== '') {
        $sections = [];
        foreach ($catalog as $id => $text) {
            if (stripos($text, $q) !== false) {
                $sections[] = $id;
            }
        }
    }
    return [
        'user' => $user,
        'query' => $q,
        'sections' => $sections,
        'search_empty' => $q !== '' && $sections === [],
    ];
}

function client_module(string $module, int $userId, array $query): array {
    $data = match ($module) {
        'dashboard' => client_dashboard_data($userId),
        'lost-items' => client_lost_items_data($userId, $query, false),
        'found-items' => client_found_items_data($userId, $query),
        'my-reports' => client_lost_items_data($userId, $query, true),
        'my-claims' => client_claims_data($userId, $query),
        'notifications' => client_notifications_data($userId, $query),
        'settings' => client_settings_data($userId, $query),
        default => null,
    };
    if ($data === null) {
        json_out(['success' => false, 'message' => 'Unknown module.'], 404);
    }
    require_once __DIR__ . '/../../dashboard/client/views.php';
    return [
        'success' => true,
        'module' => $module,
        'data' => $data,
        'html' => client_render($module, $data),
    ];
}
