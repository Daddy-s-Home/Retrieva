<?php
declare(strict_types=1);

require_once __DIR__ . '/../client/views.php';

function admin_options(array $values, string $selected, bool $labels = false): string {
    $html = '';
    foreach ($values as $value) {
        $html .= '<option value="' . h($value) . '"' . ($value === $selected ? ' selected' : '') . '>' . h($labels ? admin_label($value) : $value) . '</option>';
    }
    return $html;
}

function admin_intro(string $title, string $copy, string $action = ''): string {
    return '<div class="page-intro"><div><h1>' . h($title) . '</h1><p>' . h($copy) . '</p></div>' . $action . '</div>';
}

function admin_export_links(string $module, array $filters): string {
    $query = [
        'module' => $module,
        'tab' => (string) ($filters['tab'] ?? 'overview'),
        'start' => (string) ($filters['start'] ?? ''),
        'end' => (string) ($filters['end'] ?? ''),
    ];
    if (($filters['q'] ?? '') !== '') {
        $query['q'] = (string) $filters['q'];
    }
    $csv = '../database/admin/export.php?' . http_build_query($query);
    $pdf = $csv . '&format=pdf';
    return '<span class="export-links"><a class="btn btn-ghost" href="' . h($csv) . '">Download CSV</a><a class="btn btn-ghost" href="' . h($pdf) . '">Download PDF</a></span>';
}

function admin_date_fields(array $filters): string {
    $today = date('Y-m-d');
    return '<label class="filter-field">Start date<input type="date" name="start" max="' . h($today) . '" value="' . h((string) ($filters['start'] ?? '')) . '"></label>'
        . '<label class="filter-field">End date<input type="date" name="end" max="' . h($today) . '" value="' . h((string) ($filters['end'] ?? $today)) . '"></label>';
}

function admin_pager(string $page, array $filters, int $pages, int $current): string {
    if ($pages < 2) {
        return '';
    }
    $html = '<nav class="pager" aria-label="Pages">';
    if ($current > 1) {
        $html .= '<a class="pager__btn" href="' . h(client_qs($page, $filters, ['page' => $current - 1])) . '">Previous</a>';
    }
    $html .= '<span>Page ' . $current . ' of ' . $pages . '</span>';
    if ($current < $pages) {
        $html .= '<a class="pager__btn" href="' . h(client_qs($page, $filters, ['page' => $current + 1])) . '">Next</a>';
    }
    return $html . '</nav>';
}

function admin_filter(string $page, array $filters, array $statuses): string {
    $html = '<form class="filter-bar" method="get" action="' . h($page) . '" data-client-filter>';
    $html .= '<label class="filter-field filter-field--search">Search<input type="search" name="q" value="' . h($filters['q']) . '"></label>';
    $html .= '<label class="filter-field">Category<select name="category"><option value="">All</option>' . admin_options(CLIENT_CATEGORIES, $filters['category']) . '</select></label>';
    if ($statuses) {
        $html .= '<label class="filter-field">Status<select name="status"><option value="">All</option>' . admin_options($statuses, $filters['status'], true) . '</select></label>';
    }
    $html .= '<button class="btn btn-primary" type="submit">Apply</button></form>';
    return $html;
}

function admin_render(string $module, array $data): string {
    return match ($module) {
        'dashboard' => admin_view_dashboard($data),
        'lost-reports' => admin_view_lost($data),
        'found-items' => admin_view_found($data),
        'log-found' => admin_view_log($data),
        'matching' => admin_view_matching($data),
        'claims' => admin_view_claims($data),
        'pickup' => admin_view_pickup($data),
        'returned' => admin_view_returned($data),
        'users' => admin_view_users($data),
        'reports' => admin_view_reports($data),
        'audit' => admin_view_audit($data),
        'settings' => admin_view_settings($data),
        default => '<p class="empty">This page is not available.</p>',
    };
}

function admin_view_dashboard(array $data): string {
    $kpis = '';
    foreach ($data['kpis'] as [$tone, $icon, $value, $label, $delta, $direction]) {
        $kpis .= client_kpi($tone, $icon, $value, $label, $delta, $direction);
    }
    $found = '';
    $recentFoundPhotos = retrieva_photo_map('found', admin_cover_map($data['recent_found'], 'id', 'photo_path'));
    foreach ($data['recent_found'] as $row) {
        $found .= '<div class="mini-row mini-row--media">' . dashboard_photo_preview($recentFoundPhotos[(int) $row['id']] ?? [], (string) $row['item_name'], 'row') . '<a class="mini-row__content" href="admin-found-items.php?q=' . rawurlencode((string) $row['public_code']) . '"><strong>' . h($row['item_name']) . '</strong><small>' . h($row['location_found']) . ' · ' . h(client_date($row['date_found'])) . '</small></a><span class="pill pill--' . h($row['status']) . '">' . h(admin_label($row['status'])) . '</span></div>';
    }
    $claims = '';
    foreach ($data['pending_claims'] as $row) {
        $claims .= '<a class="mini-row" href="admin-claims.php?q=' . rawurlencode((string) $row['public_code']) . '"><strong>' . h($row['item_name']) . '</strong><small>' . h($row['full_name']) . ' · ' . h(client_ago($row['created_at'])) . '</small></a>';
    }
    $activity = '';
    foreach ($data['activity'] as $row) {
        $activity .= '<div class="mini-row"><strong>' . h(admin_label((string) $row['action'])) . '</strong><small>' . h((string) ($row['full_name'] ?? 'System')) . ' · ' . h(client_ago($row['created_at'])) . '</small></div>';
    }
    $chart = json_encode($data['chart'], JSON_UNESCAPED_SLASHES);
    return admin_intro('Dashboard', 'Campus lost and found activity for the security office.')
        . '<section class="kpi-grid">' . $kpis . '</section>'
        . '<div class="dash-layout"><section class="panel"><div class="panel__head"><h2>Found and lost this week</h2></div><canvas id="admin-trend-chart" height="120"></canvas><pre hidden id="admin-chart-data">' . h($chart) . '</pre></section>'
        . '<section class="panel admin-category-panel"><div class="panel__head"><h2>Items by Category</h2></div>'
        . '<div class="admin-category-tabs" role="tablist" aria-label="Choose item type">'
        . '<button class="admin-category-tab" id="admin-category-tab-found" type="button" role="tab" aria-selected="true" aria-controls="admin-category-panel" tabindex="0" data-category-tab="found">Found Items</button>'
        . '<button class="admin-category-tab" id="admin-category-tab-lost" type="button" role="tab" aria-selected="false" aria-controls="admin-category-panel" tabindex="-1" data-category-tab="lost">Lost Items</button></div>'
        . '<div class="category-chart-layout" id="admin-category-panel" role="tabpanel" aria-labelledby="admin-category-tab-found" tabindex="0">'
        . '<div class="category-chart-layout__chart"><canvas id="admin-category-chart" role="img" aria-label="Found items by category"></canvas></div>'
        . '<ul class="category-chart-layout__legend" id="admin-category-legend" aria-label="Category totals"></ul></div>'
        . '<p class="admin-category-empty-state" id="admin-category-empty-state" role="status" aria-live="polite" hidden></p>'
        . '<h3>Locations</h3><ul class="note-list">' . admin_bars($data['chart']['locations']) . '</ul></section></div>'
        . '<div class="split"><section class="panel"><div class="panel__head"><h2>Recent found items</h2><a href="admin-found-items.php">View all</a></div>' . ($found ?: '<p class="empty">No found items yet.</p>') . '</section>'
        . '<section class="panel"><div class="panel__head"><h2>Pending claims</h2><a href="admin-claims.php?status=pending">Review</a></div>' . ($claims ?: '<p class="empty">No claims are waiting.</p>') . '</section></div>'
        . '<section class="panel"><h2>Recent activity</h2>' . ($activity ?: '<p class="empty">No activity yet.</p>') . '</section>';
}

function admin_cover_map(array $rows, string $idKey, string $pathKey): array {
    $covers = [];
    foreach ($rows as $row) {
        $id = (int) ($row[$idKey] ?? 0);
        if ($id > 0) {
            $covers[$id] = (string) ($row[$pathKey] ?? '');
        }
    }
    return $covers;
}

function admin_bars(array $rows): string {
    $html = '';
    foreach ($rows as $row) {
        $html .= '<li class="mini-row"><strong>' . h($row['label']) . '</strong><span>' . (int) $row['total'] . '</span></li>';
    }
    return $html ?: '<li class="empty">No locations yet.</li>';
}

function admin_view_lost(array $data): string {
    $filters = $data['filters'];
    $kpis = client_kpi('blue', 'search', (string) $data['counts']['searching'], 'Searching', 'Still open', 'flat')
        . client_kpi('purple', 'shield', (string) $data['counts']['matched'], 'Matched', 'Linked to a found item', 'flat')
        . client_kpi('green', 'check', (string) $data['counts']['resolved'], 'Resolved', 'Returned or closed out', 'flat')
        . client_kpi('red', 'report', (string) $data['counts']['closed'], 'Closed', 'No longer active', 'flat');
    $rows = '';
    $details = '';
    $lostPhotos = retrieva_photo_map('lost', admin_cover_map($data['rows'], 'id', 'photo_path'));
    foreach ($data['rows'] as $row) {
        $id = (int) $row['id'];
        $selectedCategory = dashboard_category_label((string) $row['category']);
        $categoryOptions = ($selectedCategory === 'Unspecified' ? '<option value="" disabled selected>Choose a category...</option>' : '')
            . admin_options(ITEM_CATEGORY_OPTIONS, $selectedCategory);
        $photos = $lostPhotos[$id] ?? [];
        $rows .= '<tr><td>' . dashboard_photo_preview($photos, (string) $row['item_name']) . '</td><td>' . h((string) $row['public_code']) . '</td><td><strong>' . h($row['item_name']) . '</strong></td><td>' . h($row['category']) . '</td><td>' . h($row['full_name']) . '</td><td>' . h((string) $row['last_seen_location']) . '</td><td>' . h(client_date($row['date_lost'])) . '</td><td><span class="pill pill--' . h($row['status']) . '">' . h(admin_label($row['status'])) . '</span></td><td><button class="btn btn-ghost" type="button" data-open-detail="lost-' . $id . '">Open</button></td></tr>';
        $delete = (int) $row['claim_count'] === 0
            ? '<form method="post" action="../database/admin/actions.php" data-client-ajax onsubmit="return confirm(\'Delete this lost report?\')">' . csrf_field() . '<input type="hidden" name="action" value="delete_lost"><input type="hidden" name="lost_id" value="' . $id . '"><input type="hidden" name="redirect" value="admin-lost-reports.php"><button class="btn btn-danger" type="submit">Delete</button></form>'
            : '<p class="muted">This report has a claim, so it stays on file.</p>';
        $details .= '<template id="detail-lost-' . $id . '"><h2 id="drawer-title">' . h($row['item_name']) . '</h2><p class="muted">' . h((string) $row['public_code']) . ' · ' . h($row['email']) . '</p>'
            . client_photo_gallery($photos, $row['item_name'])             . '<form class="stack-form" method="post" action="../database/admin/actions.php" enctype="multipart/form-data" data-client-ajax>' . csrf_field()
            . '<input type="hidden" name="action" value="update_lost"><input type="hidden" name="lost_id" value="' . $id . '"><input type="hidden" name="redirect" value="admin-lost-reports.php">'
            . '<label class="filter-field">Item<input name="item_name" value="' . h($row['item_name']) . '" required></label>'
            . '<label class="filter-field">Category<select name="category" required>' . $categoryOptions . '</select></label>'
            . '<label class="filter-field">Location<input name="location" value="' . h((string) $row['last_seen_location']) . '" required></label>'
            . '<label class="filter-field">Date lost<input type="date" name="date_lost" value="' . h(substr((string) $row['date_lost'], 0, 10)) . '" required></label>'
            . '<label class="filter-field">Description<textarea name="description">' . h((string) $row['description']) . '</textarea></label>'
            . '<label class="filter-field">Status<select name="status">' . admin_options(CLIENT_LOST_STATUSES, $row['status'], true) . '</select></label>'
            . '<label class="filter-field">Closed reason<input name="closed_reason" value="' . h((string) $row['closed_reason']) . '"></label>'
            . client_photo_picker($photos)
            . '<button class="btn btn-primary" type="submit">Save report</button></form>' . $delete . '</template>';
    }
    return admin_intro('Lost Reports', 'Review, update, or close campus lost reports.')
        . '<section class="kpi-grid">' . $kpis . '</section>'
        . admin_filter('admin-lost-reports.php', $filters, CLIENT_LOST_STATUSES)
        . '<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Photo</th><th>Code</th><th>Item</th><th>Category</th><th>Reporter</th><th>Location</th><th>Date lost</th><th>Status</th><th></th></tr></thead><tbody>'
        . ($rows ?: '<tr><td colspan="9" class="empty">No reports match these filters.</td></tr>')
        . '</tbody></table></div>' . admin_pager('admin-lost-reports.php', $filters, $data['pages'], $filters['page']) . $details;
}

function admin_view_found(array $data): string {
    $filters = $data['filters'];
    $rows = '';
    $details = '';
    $foundPhotos = retrieva_photo_map('found', admin_cover_map($data['rows'], 'id', 'photo_path'));
    foreach ($data['rows'] as $row) {
        $id = (int) $row['id'];
        $selectedCategory = dashboard_category_label((string) $row['category']);
        $categoryOptions = ($selectedCategory === 'Unspecified' ? '<option value="" disabled selected>Choose a category...</option>' : '')
            . admin_options(ITEM_CATEGORY_OPTIONS, $selectedCategory);
        $photos = $foundPhotos[$id] ?? [];
        $rows .= '<tr><td>' . dashboard_photo_preview($photos, (string) $row['item_name']) . '</td><td>' . h((string) $row['public_code']) . '</td><td><strong>' . h($row['item_name']) . '</strong></td><td>' . h($row['category']) . '</td><td>' . h($row['location_found']) . '</td><td>' . h(client_date($row['date_found'])) . '</td><td><span class="pill pill--' . h($row['status']) . '">' . h(admin_label($row['status'])) . '</span></td><td><button class="btn btn-ghost" type="button" data-open-detail="found-' . $id . '">Open</button></td></tr>';
        $delete = (int) $row['claim_count'] === 0
            ? '<form method="post" action="../database/admin/actions.php" data-client-ajax onsubmit="return confirm(\'Delete this found item?\')">' . csrf_field() . '<input type="hidden" name="action" value="delete_found"><input type="hidden" name="found_id" value="' . $id . '"><input type="hidden" name="redirect" value="admin-found-items.php"><button class="btn btn-danger" type="submit">Delete</button></form>'
            : '<p class="muted">This item has a claim, so it stays on file.</p>';
        $details .= '<template id="detail-found-' . $id . '"><h2 id="drawer-title">' . h($row['item_name']) . '</h2><p class="muted">Logged by ' . h($row['full_name']) . '</p>'
            . client_photo_gallery($photos, $row['item_name'])             . '<form class="stack-form" method="post" action="../database/admin/actions.php" data-client-ajax enctype="multipart/form-data">' . csrf_field()
            . '<input type="hidden" name="action" value="update_found"><input type="hidden" name="found_id" value="' . $id . '"><input type="hidden" name="redirect" value="admin-found-items.php">'
            . '<label class="filter-field">Item<input name="item_name" value="' . h($row['item_name']) . '" required></label>'
            . '<label class="filter-field">Category<select name="category" required>' . $categoryOptions . '</select></label>'
            . '<label class="filter-field">Location<input name="location" value="' . h($row['location_found']) . '" required></label>'
            . '<label class="filter-field">Date found<input type="date" name="date_found" value="' . h(substr((string) $row['date_found'], 0, 10)) . '" required></label>'
            . '<label class="filter-field">Status<select name="status">' . admin_options(ADMIN_FOUND_STATUSES, $row['status'], true) . '</select></label>'
            . '<label class="filter-field">Public summary<textarea name="public_summary">' . h((string) $row['public_summary']) . '</textarea></label>'
            . client_photo_picker($photos)
            . '<button class="btn btn-primary" type="submit">Save item</button></form>' . $delete . '</template>';
    }
    return admin_intro('Found Items', 'Inventory logged by the security office.', '<a class="btn btn-primary" href="admin-log-found.php">Log found item</a>')
        . admin_filter('admin-found-items.php', $filters, ADMIN_FOUND_STATUSES)
        . '<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Photo</th><th>Code</th><th>Item</th><th>Category</th><th>Location</th><th>Date found</th><th>Status</th><th></th></tr></thead><tbody>'
        . ($rows ?: '<tr><td colspan="8" class="empty">No found items match these filters.</td></tr>')
        . '</tbody></table></div>' . admin_pager('admin-found-items.php', $filters, $data['pages'], $filters['page']) . $details;
}

function admin_view_log(array $data): string {
    return admin_intro('Log Found Item', 'Add an item turned in to the security office.')
        . '<form class="panel stack-form" method="post" action="../database/admin/actions.php" data-client-ajax enctype="multipart/form-data">' . csrf_field()
        . '<input type="hidden" name="action" value="create_found"><input type="hidden" name="redirect" value="admin-found-items.php">'
        . '<label class="filter-field">Item name<input name="item_name" required maxlength="150"></label>'
        . '<label class="filter-field">Category<select name="category" required><option value="" disabled selected>Select a category...</option>' . admin_options(ITEM_CATEGORY_OPTIONS, '') . '</select></label>'
        . '<label class="filter-field">Location found<input name="location" required maxlength="150"></label>'
        . '<label class="filter-field">Date found<input type="date" name="date_found" required max="' . h(date('Y-m-d')) . '"></label>'
        . '<label class="filter-field">Public summary<textarea name="public_summary" maxlength="500" placeholder="What other students may see"></textarea></label>'
        . client_photo_picker([])
        . '<button class="btn btn-primary" type="submit">Save found item</button></form>';
}

function admin_view_matching(array $data): string {
    $cards = '';
    $lostPhotos = retrieva_photo_map('lost', admin_cover_map($data['rows'], 'lost_item_id', 'lost_photo'));
    $foundPhotos = retrieva_photo_map('found', admin_cover_map($data['rows'], 'found_item_id', 'photo_path'));
    foreach ($data['rows'] as $row) {
        $checks = json_decode((string) ($row['similarity_json'] ?? ''), true);
        $list = '';
        if (is_array($checks)) {
            foreach ($checks as $check) {
                $list .= '<li>' . h((string) $check) . '</li>';
            }
        }
        $id = (int) $row['id'];
        $cards .= '<article class="panel match-card"><div class="split"><div><h3>Lost report</h3><p><strong>' . h($row['lost_name']) . '</strong></p><p class="muted">' . h((string) $row['lost_code']) . ' · ' . h($row['lost_category']) . '</p><p class="muted">' . h((string) $row['last_seen_location']) . '</p>' . client_photo_gallery($lostPhotos[(int) $row['lost_item_id']] ?? [], $row['lost_name']) . '</div><div><h3>Found item</h3><p><strong>' . h($row['found_name']) . '</strong></p><p class="muted">' . h((string) $row['found_code']) . ' · ' . h($row['found_category']) . '</p><p class="muted">' . h($row['location_found']) . '</p>' . client_photo_gallery($foundPhotos[(int) $row['found_item_id']] ?? [], $row['found_name']) . '</div></div>'
            . '<p class="kpi__value">' . h((string) $row['score']) . '%</p><ul>' . ($list ?: '<li>No shared details recorded.</li>') . '</ul>'
            . '<div class="filter-bar">'
            . '<form method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="confirm_match"><input type="hidden" name="match_id" value="' . $id . '"><button class="btn btn-primary" type="submit">Confirm match</button></form>'
            . '<form method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="notify_match"><input type="hidden" name="match_id" value="' . $id . '"><button class="btn btn-ghost" type="submit">Notify reporter</button></form>'
            . '<form method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="reject_match"><input type="hidden" name="match_id" value="' . $id . '"><button class="btn btn-danger" type="submit">No match</button></form>'
            . '</div>'  . '</article>';
    }
    return admin_intro('Matching Center', 'Suggestions compare category, name, and location.', '<form method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="refresh_matches"><button class="btn btn-primary" type="submit">Refresh suggestions</button></form>')
        . '<section class="kpi-grid"><article class="kpi"><div><div class="kpi__value">' . (int) $data['potential'] . '</div><div class="kpi__label">Suggestions</div></div></article>'
        . '<article class="kpi kpi--green"><div><div class="kpi__value">' . (int) $data['confirmed'] . '</div><div class="kpi__label">Confirmed</div></div></article>'
        . '<article class="kpi kpi--red"><div><div class="kpi__value">' . (int) $data['rejected'] . '</div><div class="kpi__label">No match</div></div></article></section>'
        . '<div class="stack">' . ($cards ?: '<p class="empty">Refresh suggestions to compare open reports with unclaimed items.</p>') . '</div>';
}

function admin_claim_answers(?string $json): string {
    $values = json_decode((string) $json, true);
    if (!is_array($values) || $values === []) {
        return 'No answer was submitted.';
    }
    $html = '';
    foreach ($values as $value) {
        $html .= '<p>' . h(is_scalar($value) ? (string) $value : '') . '</p>';
    }
    return $html;
}

function admin_view_claims(array $data): string {
    $filters = $data['filters'];
    $rows = '';
    $details = '';
    $claimPhotos = retrieva_photo_map('found', admin_cover_map($data['rows'], 'found_item_id', 'photo_path'));
    foreach ($data['rows'] as $row) {
        $id = (int) $row['id'];
        $photos = $claimPhotos[(int) $row['found_item_id']] ?? [];
        $rows .= '<tr><td>' . h((string) $row['public_code']) . '</td><td><strong>' . h($row['item_name']) . '</strong></td><td>' . h($row['full_name']) . '<br><span class="muted">' . h((string) $row['student_id']) . '</span></td><td>' . h(client_date($row['created_at'])) . '</td><td><span class="pill pill--' . h($row['status']) . '">' . h(admin_label($row['status'])) . '</span></td><td><button class="btn btn-ghost" type="button" data-open-detail="claim-' . $id . '">Review</button></td></tr>';
        $actions = '';
        if (in_array($row['status'], ['pending', 'manual_review'], true)) {
            $actions = '<button class="btn btn-primary" type="button" data-open-pickup-location data-claim-id="' . $id . '" data-approval-endpoint="../database/admin/actions.php" data-approval-action="approve_claim" data-approval-redirect="admin-claims.php" data-approval-ajax="true">Approve</button>';
            if ($row['status'] === 'pending') {
                $actions .= '<form method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="request_claim_info"><input type="hidden" name="claim_id" value="' . $id . '"><button class="btn btn-ghost" type="submit">Request information</button></form>';
            }
            $actions .= '<form class="stack-form" method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="reject_claim"><input type="hidden" name="claim_id" value="' . $id . '"><label class="filter-field">Rejection reason<input name="rejection_reason" required maxlength="500"></label><button class="btn btn-danger" type="submit">Reject</button></form>';
        }
        $details .= '<template id="detail-claim-' . $id . '"><h2 id="drawer-title">' . h($row['item_name']) . '</h2><p class="muted">' . h((string) $row['public_code']) . ' · ' . h((string) $row['found_code']) . '</p>' . client_photo_gallery($photos, $row['item_name'])  . '<p><strong>' . h($row['full_name']) . '</strong><br>' . h($row['email']) . '<br>' . h((string) $row['student_id']) . '</p><h3>Identifying answer</h3>' . admin_claim_answers($row['claimant_answers'] ?? null) . '<div class="stack">' . $actions . '</div></template>';
    }
    return admin_intro('Claims', 'Verify identity, then approve, reject, or ask for more information.')
        . '<section class="kpi-grid">'
        . client_kpi('gold', 'shield', (string) $data['counts']['pending'], 'Pending', 'New claims', 'flat')
        . client_kpi('blue', 'report', (string) $data['counts']['manual_review'], 'Needs information', 'Waiting on the claimant', 'flat')
        . client_kpi('green', 'check', (string) $data['counts']['approved'], 'Approved', 'Ready for pickup', 'flat')
        . client_kpi('red', 'shield', (string) $data['counts']['rejected'], 'Rejected', 'Not approved', 'flat')
        . '</section>'
        . '<form class="filter-bar" method="get" action="admin-claims.php" data-client-filter><label class="filter-field filter-field--search">Search<input type="search" name="q" value="' . h($filters['q']) . '"></label><label class="filter-field">Status<select name="status"><option value="">All</option>' . admin_options(['pending', 'manual_review', 'approved', 'rejected'], $filters['status'], true) . '</select></label><button class="btn btn-primary" type="submit">Apply</button></form>'
        . '<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Code</th><th>Item</th><th>Claimant</th><th>Filed</th><th>Status</th><th></th></tr></thead><tbody>'
        . ($rows ?: '<tr><td colspan="6" class="empty">No claims match these filters.</td></tr>')
        . '</tbody></table></div>' . admin_pager('admin-claims.php', $filters, $data['pages'], $filters['page']) . $details;
}

function admin_view_pickup(array $data): string {
    $filters = $data['filters'];
    $lookup = '';
    if ($data['lookup']) {
        $row = $data['lookup'];
        $canConfirm = $row['status'] === 'pending';
        $lookup = '<section class="panel"><h2>' . h($row['item_name']) . '</h2><p>' . h($row['full_name']) . ' · ' . h((string) $row['student_id']) . '</p><p class="muted">Claim ' . h((string) $row['claim_code']) . ' · Item ' . h((string) $row['found_code']) . '</p><p><span class="pill">' . h(admin_label($row['status'])) . '</span></p>'
            . ($canConfirm ? '<form method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="confirm_pickup"><input type="hidden" name="token" value="' . h($row['qr_token']) . '"><button class="btn btn-primary" type="submit">Confirm pickup</button></form>' : '<p class="muted">This code is already ' . h(admin_label($row['status'])) . '.</p>')
            . '</section>';
    } elseif ($data['lookup_message'] !== '') {
        $lookup = '<p class="empty">' . h($data['lookup_message']) . '</p>';
    }
    $queue = '';
    foreach ($data['queue'] as $row) {
        $queue .= '<a class="mini-row" href="admin-pickup.php?token=' . rawurlencode((string) $row['qr_token']) . '"><strong>' . h($row['item_name']) . '</strong><small>' . h($row['full_name']) . ' · ' . h((string) $row['student_id']) . '</small></a>';
    }
    return admin_intro('QR Pickup Verification', 'Type or paste the code from the student pickup QR.')
        . '<section class="kpi-grid"><article class="kpi"><div><div class="kpi__value">' . (int) $data['pending'] . '</div><div class="kpi__label">Waiting</div></div></article><article class="kpi kpi--green"><div><div class="kpi__value">' . (int) $data['verified'] . '</div><div class="kpi__label">Verified</div></div></article></section>'
        . '<form class="filter-bar" method="get" action="admin-pickup.php" data-client-filter><label class="filter-field filter-field--search">Pickup code<input name="token" value="' . h($filters['token']) . '" autocomplete="off"></label><button class="btn btn-primary" type="submit">Look up</button></form>'
        . $lookup
        . '<section class="panel"><h2>Pickup queue</h2>' . ($queue ?: '<p class="empty">No pickups are waiting.</p>') . '</section>';
}

function admin_view_returned(array $data): string {
    $rows = '';
    $details = '';
    $returnFound = retrieva_photo_map('found', admin_cover_map($data['rows'], 'found_id', 'photo_path'));
    $returnLost = retrieva_photo_map('lost', admin_cover_map($data['rows'], 'lost_id', 'lost_photo'));
    foreach ($data['rows'] as $row) {
        $key = (int) ($row['pickup_id'] ?: $row['found_id']);
        $rows .= '<tr><td>' . h((string) ($row['found_code'] ?? '')) . '</td><td><strong>' . h($row['item_name']) . '</strong></td><td>' . h((string) ($row['full_name'] ?? '')) . '</td><td>' . h(client_date($row['scanned_at'] ?? $row['reviewed_at'])) . '</td><td><button class="btn btn-ghost" type="button" data-open-detail="return-' . $key . '">Open</button></td></tr>';
        $issue = '';
        if (!empty($row['pickup_id'])) {
            $issue = '<form class="stack-form" method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="report_return_issue"><input type="hidden" name="pickup_id" value="' . (int) $row['pickup_id'] . '"><label class="filter-field">Issue note<input name="condition_note" value="' . h((string) $row['condition_note']) . '" maxlength="255" required></label><button class="btn btn-ghost" type="submit">Save issue</button></form>';
        }
        $returnPhotos = array_merge($returnFound[(int) $row['found_id']] ?? [], $returnLost[(int) ($row['lost_id'] ?? 0)] ?? []);
        $details .= '<template id="detail-return-' . $key . '"><h2 id="drawer-title">' . h($row['item_name']) . '</h2>' . client_photo_gallery($returnPhotos, $row['item_name'])  . '<ol class="note-list"><li>Claim reviewed ' . h(client_date($row['reviewed_at'])) . '</li><li>Pickup scanned ' . h(client_date($row['scanned_at']) ?: 'not yet') . '</li><li>Report resolved ' . h(client_date($row['resolved_at']) ?: 'not linked') . '</li></ol><p class="muted">Claim ' . h((string) $row['claim_code']) . ' · Lost report ' . h((string) $row['lost_code']) . '</p>' . $issue . '</template>';
    }
    return admin_intro('Returned Items', 'Items handed back after a verified pickup.')
        . '<section class="kpi-grid"><article class="kpi kpi--green"><div><div class="kpi__value">' . (int) $data['returned'] . '</div><div class="kpi__label">Returned items</div></div></article><article class="kpi"><div><div class="kpi__value">' . (int) $data['verified'] . '</div><div class="kpi__label">Verified pickups</div></div></article></section>'
        . '<form class="filter-bar" method="get" action="admin-returned.php" data-client-filter><label class="filter-field filter-field--search">Search<input type="search" name="q" value="' . h($data['filters']['q']) . '"></label><button class="btn btn-primary" type="submit">Apply</button></form>'
        . '<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Code</th><th>Item</th><th>Claimant</th><th>Returned</th><th></th></tr></thead><tbody>'
        . ($rows ?: '<tr><td colspan="5" class="empty">No returned items yet.</td></tr>') . '</tbody></table></div>' . $details;
}

function admin_view_users(array $data): string {
    $filters = $data['filters'];
    $kpis = '';
    foreach (ADMIN_ROLES as $role) {
        $kpis .= '<article class="kpi"><div><div class="kpi__value">' . (int) $data['counts'][$role] . '</div><div class="kpi__label">' . h(ucfirst($role)) . '</div></div></article>';
    }
    $rows = '';
    $details = '';
    foreach ($data['rows'] as $row) {
        $id = (int) $row['id'];
        $rows .= '<tr><td><strong>' . h($row['full_name']) . '</strong><br><span class="muted">' . h($row['email']) . '</span></td><td>' . h($row['role']) . '</td><td>' . h((string) $row['student_id']) . '</td><td><span class="user-status user-status--' . h($row['status']) . '">' . h(ucfirst($row['status'])) . '</span></td><td><button class="btn btn-ghost" type="button" data-open-detail="user-' . $id . '">Edit</button></td></tr>';
        $details .= '<template id="detail-user-' . $id . '"><h2 id="drawer-title">' . h($row['full_name']) . '</h2>'
            . '<form class="stack-form" method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="update_user"><input type="hidden" name="user_id" value="' . $id . '">'
            . '<label class="filter-field">Name<input name="full_name" value="' . h($row['full_name']) . '" required></label>'
            . '<label class="filter-field">Email<input type="email" name="email" value="' . h($row['email']) . '" required></label>'
            . '<label class="filter-field">Role<select name="role">' . admin_options(ADMIN_ROLES, $row['role']) . '</select></label>'
            . '<label class="filter-field">Status<select name="status">' . admin_options(ADMIN_USER_STATUSES, $row['status'], true) . '</select></label>'
            . '<label class="filter-field">Student ID<input name="student_id" value="' . h((string) $row['student_id']) . '"></label>'
            . '<label class="filter-field">Program<input name="program_department" value="' . h((string) $row['program_department']) . '"></label>'
            . '<button class="btn btn-primary" type="submit">Save account</button></form>'
            . '<form class="stack-form" method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="reset_user_password"><input type="hidden" name="user_id" value="' . $id . '">'
            . '<label class="filter-field">New password<input type="password" name="password" minlength="8" required></label>'
            . '<label class="filter-field">Confirm password<input type="password" name="confirm_password" minlength="8" required></label>'
            . '<button class="btn btn-ghost" type="submit">Reset password</button></form>';
        if ($id !== (int) ($data['actor_id'] ?? 0) && $row['status'] !== 'inactive') {
            $details .= '<form class="stack-form" method="post" action="../database/admin/actions.php" data-confirm-title="Deactivate account?" data-confirm="This will set this account to Inactive and prevent sign-in. Its reports and claims will be kept, and an admin can reactivate it later." data-confirm-btn="Mark inactive">'
                . csrf_field() . '<input type="hidden" name="action" value="deactivate_user"><input type="hidden" name="user_id" value="' . $id . '">'
                . '<p class="muted">Deletion is reversible: the account is marked inactive and its history is retained.</p><button class="btn btn-danger" type="submit">Delete account</button></form>';
        }
        $details .= '</template>';
    }
    return admin_intro('Users', 'Add accounts and update role, status, or password.')
        . '<section class="kpi-grid">' . $kpis . '</section>'
        . '<form class="panel stack-form" method="post" action="../database/admin/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="create_user"><h2>Add account</h2>'
        . '<div class="form-grid"><label class="filter-field">Name<input name="full_name" required></label><label class="filter-field">UMak email<input type="email" name="email" required></label><label class="filter-field">Role<select name="role">' . admin_options(ADMIN_ROLES, 'student') . '</select></label><label class="filter-field">Status<select name="status">' . admin_options(ADMIN_USER_STATUSES, 'active', true) . '</select></label><label class="filter-field">Student ID<input name="student_id"></label><label class="filter-field">Program<input name="program_department"></label><label class="filter-field">Password<input type="password" name="password" minlength="8" required></label></div>'
        . '<button class="btn btn-primary" type="submit">Create account</button></form>'
        . '<form class="filter-bar" method="get" action="admin-users.php" data-client-filter><label class="filter-field filter-field--search">Search<input type="search" name="q" value="' . h($filters['q']) . '"></label><label class="filter-field">Role<select name="role"><option value="">All roles</option>' . admin_options(ADMIN_ROLES, $filters['role'], true) . '</select></label><label class="filter-field">Status<select name="status"><option value="">All statuses</option>' . admin_options(ADMIN_USER_STATUSES, $filters['status'], true) . '</select></label><button class="btn btn-primary" type="submit">Apply</button></form>'
        . '<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Person</th><th>Role</th><th>Student ID</th><th>Status</th><th></th></tr></thead><tbody>'
        . ($rows ?: '<tr><td colspan="5" class="empty">No accounts match these filters.</td></tr>') . '</tbody></table></div>'
        . admin_pager('admin-users.php', $filters, $data['pages'], $filters['page']) . $details;
}

function admin_view_reports(array $data): string {
    $tab = $data['filters']['tab'];
    $tabs = '';
    foreach (['overview' => 'Overview', 'lost' => 'Lost', 'found' => 'Found', 'claims' => 'Claims', 'users' => 'Users'] as $id => $label) {
        $tabs .= '<a class="tabs__tab' . ($tab === $id ? ' is-current' : '') . '" href="' . h(client_qs('admin-reports.php', $data['filters'], ['tab' => $id, 'page' => 1])) . '">' . h($label) . '</a>';
    }
    $body = '<section class="kpi-grid">'
        . client_kpi('gold', 'box', (string) $data['found'], 'Found', 'All logged items', 'flat')
        . client_kpi('blue', 'search', (string) $data['lost'], 'Lost', 'All reports', 'flat')
        . client_kpi('purple', 'shield', (string) $data['claims'], 'Claims', 'All claims', 'flat')
        . client_kpi('green', 'check', (string) $data['users'], 'Users', 'All accounts', 'flat')
        . '</section>';
    $groups = ['lost' => $data['lost_status'], 'found' => $data['found_status'], 'claims' => $data['claim_status'], 'users' => $data['role_counts']];
    if ($tab === 'overview') {
        $chart = json_encode($data['chart'], JSON_UNESCAPED_UNICODE);
        $body .= '<div class="report-charts"><section class="panel"><h2>Lost and found</h2><canvas id="reports-trend-chart" height="140"></canvas></section>'
            . '<section class="panel"><h2>Categories</h2><canvas id="reports-category-chart" height="140"></canvas></section></div>'
            . '<pre hidden id="reports-chart-data">' . h((string) $chart) . '</pre>';
        $recent = '';
        foreach ($data['recent_claims'] as $row) {
            $recent .= '<div class="mini-row"><strong>' . h($row['item_name']) . '</strong><small>' . h($row['full_name']) . ' · ' . h(admin_label($row['status'])) . '</small></div>';
        }
        $body .= '<section class="panel"><h2>Recent claims</h2>' . ($recent ?: '<p class="empty">No claims yet.</p>') . '</section>';
    } else {
        $key = $tab === 'users' ? 'role' : 'status';
        $list = '';
        foreach ($groups[$tab] ?? [] as $row) {
            $list .= '<div class="mini-row"><strong>' . h(admin_label((string) $row[$key])) . '</strong><span>' . (int) $row['total'] . '</span></div>';
        }
        $body .= '<section class="panel"><h2>' . h(ucfirst($tab)) . '</h2>' . ($list ?: '<p class="empty">No rows yet.</p>') . '</section>';
    }
    return admin_intro('Reports & Analytics', 'Totals from the live records for ' . admin_range_label($data['range']) . '.', admin_export_links('reports', $data['filters']))
        . '<nav class="tabs">' . $tabs . '</nav>'
        . '<form class="filter-bar" method="get" action="admin-reports.php" data-client-filter><input type="hidden" name="tab" value="' . h($tab) . '">'
        . admin_date_fields($data['filters']) . '<button class="btn btn-primary" type="submit">Apply</button></form>'
        . $body;
}

function admin_view_audit(array $data): string {
    $filters = $data['filters'];
    $rows = '';
    $details = '';
    foreach ($data['rows'] as $row) {
        $id = (int) $row['id'];
        $rows .= '<tr><td>' . h(client_date($row['created_at'], 'M j, Y g:i A')) . '</td><td>' . h((string) ($row['full_name'] ?? 'System')) . '</td><td>' . h($row['action']) . '</td><td>' . h((string) $row['details']) . '</td><td><button class="btn btn-ghost" type="button" data-open-detail="audit-' . $id . '">Open</button></td></tr>';
        $details .= '<template id="detail-audit-' . $id . '"><h2 id="drawer-title">' . h($row['action']) . '</h2><p>' . h((string) $row['details']) . '</p><p class="muted">' . h((string) ($row['full_name'] ?? 'System')) . ' · ' . h((string) $row['email']) . '</p><p class="muted">IP ' . h((string) $row['ip_address']) . '</p><p class="muted">' . h((string) $row['user_agent']) . '</p></template>';
    }
    return admin_intro('Audit Logs', 'A record of sign-ins and changes for ' . admin_range_label($data['range']) . '. These rows are not edited here.', admin_export_links('audit', $filters))
        . '<section class="kpi-grid">'
        . client_kpi('blue', 'shield', (string) $data['counts']['login'], 'Sign-in', 'Login events', 'flat')
        . client_kpi('gold', 'box', (string) $data['counts']['items'], 'Items', 'Lost and found changes', 'flat')
        . client_kpi('purple', 'report', (string) $data['counts']['claims'], 'Claims', 'Claim reviews', 'flat')
        . client_kpi('green', 'check', (string) $data['counts']['users'], 'Accounts', 'User changes', 'flat')
        . '</section>'
        . '<form method="get" action="admin-audit.php" data-client-filter>'
        . '<div class="filter-bar"><label class="filter-field filter-field--search">Search<input type="search" name="q" value="' . h($filters['q']) . '"></label></div>'
        . '<div class="filter-bar">' . admin_date_fields($filters) . '<button class="btn btn-primary" type="submit">Apply</button></div></form>'
        . '<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>When</th><th>Person</th><th>Action</th><th>Details</th><th></th></tr></thead><tbody>'
        . ($rows ?: '<tr><td colspan="5" class="empty">No log rows match this search.</td></tr>') . '</tbody></table></div>'
        . admin_pager('admin-audit.php', $filters, $data['pages'], $filters['page']) . $details;
}

function admin_view_settings(array $data): string {
    $user = $data['user'];
    if (!$user) {
        return '<p class="empty">Your account could not be loaded.</p>';
    }
    $loginMethod = ($user['login_method'] ?? 'email') === 'totp' ? 'totp' : 'email';
    $note = 'Sign-in will ask for the authenticator code first.';
    if (empty($user['totp_enabled'])) {
        $note .= ' Email remains the sign-in code until authenticator setup is finished.';
    }
    $history = '';
    foreach ($data['history'] as $entry) {
        $history .= '<tr><td>' . h($entry['record_type']) . '</td><td>' . h($entry['item_name']) . '</td><td>' . h($entry['category']) . '</td><td>' . h(admin_label((string) $entry['status'])) . '</td><td>' . h((string) $entry['event_date']) . '</td></tr>';
    }
    return admin_intro('Settings', 'Account security for the signed-in admin or security account.')
        . '<section class="panel" id="account"><h2>Your profile</h2><p><strong>' . h($user['full_name']) . '</strong></p><p class="muted">' . h($user['email']) . ' · ' . h(ucfirst((string) $user['role'])) . '</p></section>'
        . '<section class="panel" id="security"><h2>Change password</h2><form id="change-password-form" class="stack-form"><label class="filter-field"><span>New password</span><input type="password" name="password" minlength="8" autocomplete="new-password" required></label><label class="filter-field"><span>Confirm new password</span><input type="password" name="confirm_password" minlength="8" autocomplete="new-password" required></label>'
        . (!empty($user['totp_enabled']) ? '<label class="filter-field"><span>Authenticator code</span><input type="text" name="totp_code" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" autocomplete="one-time-code" required></label>' : '<label class="filter-field"><span>Current password</span><input type="password" name="current_password" autocomplete="current-password" required></label>')
        . '<button class="btn btn-primary" type="submit">Update password</button><p class="settings-feedback" id="password-feedback" role="status"></p></form></section>'
        . '<section class="panel"><h2>Authenticator setup</h2><form id="login-method-form" class="stack-form"><fieldset><legend>Which code should appear first at sign-in?</legend><label class="pref-row"><span>Email code</span><input type="radio" name="login_method" value="email"' . ($loginMethod === 'email' ? ' checked' : '') . '></label><label class="pref-row"><span>Authenticator app</span><input type="radio" name="login_method" value="totp"' . ($loginMethod === 'totp' ? ' checked' : '') . '></label></fieldset><p id="login-method-note"' . ($loginMethod === 'totp' ? '' : ' hidden') . '>' . h($note) . '</p><button class="btn btn-primary" type="submit">Save sign-in method</button><p class="settings-feedback" id="login-method-feedback" role="status"></p></form>'
        . '<div class="settings-totp-status' . (!empty($user['totp_enabled']) ? ' is-enabled' : '') . '" id="totp-status"><strong>' . (!empty($user['totp_enabled']) ? 'Authenticator enabled' : 'Authenticator not set up') . '</strong><span>' . (!empty($user['totp_enabled']) ? 'Your account has a verified authenticator secret.' : 'Generate a secret, then confirm a current code.') . '</span></div>'
        . '<button type="button" class="btn btn-ghost" id="totp-start-btn"' . (!empty($user['totp_enabled']) ? ' hidden' : '') . '>Generate setup key</button>'
        . '<div id="totp-setup-panel" class="settings-totp-panel" hidden data-email="' . h($user['email']) . '"><div class="totp-setup-row"><label class="filter-field"><span>Setup key</span><input id="totp-secret" type="text" readonly title="Click to copy the setup key"></label><div id="totp-qr" aria-hidden="true"></div></div><p class="muted">Scan the code or click the key to copy it, then enter the six-digit code from your authenticator app.</p><form id="totp-verify-form" class="stack-form"><label class="filter-field">Authenticator code<input id="totp-code" type="text" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required></label><button class="btn btn-primary" type="submit">Verify and enable</button></form></div>'
        . '<button type="button" class="btn btn-danger" id="totp-disable-btn"' . (empty($user['totp_enabled']) ? ' hidden' : '') . '>Disable authenticator</button><p class="settings-feedback" id="totp-feedback" role="status"></p></section>'
        . '<section class="panel"><h2>Activity</h2><div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Activity</th><th>Item</th><th>Category</th><th>Status</th><th>Date</th></tr></thead><tbody>' . ($history ?: '<tr><td colspan="5" class="empty">No records yet.</td></tr>') . '</tbody></table></div></section>';
}
