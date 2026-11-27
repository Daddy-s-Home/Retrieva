<?php
declare(strict_types=1);

require_once __DIR__ . '/../components/photo-picker.php';
require_once __DIR__ . '/../components/item-photo-gallery.php';

function client_icon(string $name): string {
    $paths = [
        'home' => '<path d="M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1h-5v-6H10v6H5a1 1 0 0 1-1-1v-9.5Z"/>',
        'search' => '<circle cx="11" cy="11" r="6"/><path d="m16 16 4 4"/>',
        'box' => '<path d="M3 7.5 12 3l9 4.5-9 4.5L3 7.5Z"/><path d="M3 7.5V16.5L12 21l9-4.5V7.5"/><path d="M12 12v9"/>',
        'report' => '<path d="M7 3h7l5 5v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1Z"/><path d="M14 3v5h5M8 13h8M8 17h5"/>',
        'shield' => '<path d="M12 3 5 6v6c0 4.2 2.8 7.4 7 9 4.2-1.6 7-4.8 7-9V6l-7-3Z"/>',
        'bell' => '<path d="M6 16V10a6 6 0 1 1 12 0v6l1.5 2H4.5L6 16Z"/><path d="M10 19a2 2 0 0 0 4 0"/>',
        'gear' => '<circle cx="12" cy="12" r="3"/><path d="M12 3v2.2M12 18.8V21M3 12h2.2M18.8 12H21M5.6 5.6l1.6 1.6M16.8 16.8l1.6 1.6M18.4 5.6l-1.6 1.6M7.2 16.8l-1.6 1.6"/>',
        'pin' => '<path d="M12 21s6-5.2 6-10a6 6 0 1 0-12 0c0 4.8 6 10 6 10Z"/><circle cx="12" cy="11" r="2"/>',
        'calendar' => '<rect x="4" y="5" width="16" height="15" rx="2"/><path d="M8 3v4M16 3v4M4 10h16"/>',
        'heart' => '<path d="M12 19s-7-4.4-7-9a4 4 0 0 1 7-2 4 4 0 0 1 7 2c0 4.6-7 9-7 9Z"/>',
        'plus' => '<path d="M12 5v14M5 12h14"/>',
        'check' => '<path d="m5 12 5 5L20 7"/>',
    ];
    $body = $paths[$name] ?? $paths['box'];
    return '<svg class="ci" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' . $body . '</svg>';
}

function client_qs(string $page, array $filters, array $overrides = []): string {
    $params = array_merge($filters, $overrides);
    $clean = [];
    foreach ($params as $key => $value) {
        if ($value === '' || $value === null) {
            continue;
        }
        if ($key === 'page' && (int) $value <= 1) {
            continue;
        }
        if ($key === 'tab' && $value === 'all') {
            continue;
        }
        if ($key === 'sort' && $value === 'latest') {
            continue;
        }
        if ($key === 'dates' && $value === 'all') {
            continue;
        }
        $clean[$key] = $value;
    }
    $query = http_build_query($clean);
    return $page . ($query !== '' ? '?' . $query : '');
}

function client_kpi(string $tone, string $icon, string $value, string $label, string $delta, string $direction): string {
    return '<article class="kpi kpi--' . h($tone) . '"><div class="kpi__icon">' . client_icon($icon) . '</div><div><div class="kpi__value">' . h($value) . '</div><div class="kpi__label">' . h($label) . '</div><div class="kpi__delta kpi__delta--' . h($direction) . '">' . h($delta) . '</div></div></article>';
}

function client_photo(string $src, string $name, array $photos = [], string $variant = 'row'): string {
    if ($photos === [] && $src !== '') {
        $photos = [['src' => $src]];
    }
    return dashboard_photo_preview($photos, $name, $variant);
}

function client_photo_gallery(array $photos, string $name): string {
    if ($photos === []) {
        return '<p class="muted">No photos were added.</p>';
    }
    $html = '<div class="photo-gallery">';
    foreach ($photos as $photo) {
        $html .= '<img src="' . h((string) ($photo['src'] ?? '')) . '" alt="' . h($name) . '">';
    }
    return $html . '</div>';
}

function client_cover_map(array $items, string $idKey = 'id'): array {
    $covers = [];
    foreach ($items as $item) {
        $covers[(int) $item[$idKey]] = (string) ($item['photo_path'] ?? $item['photo'] ?? '');
    }
    return $covers;
}

function client_photo_picker(array $photos): string {
    return dashboard_photo_picker($photos);
}

function client_heart(string $type, int $id, bool $saved, string $redirect): string {
    $pressed = $saved ? 'true' : 'false';
    return '<form method="post" action="../database/client/actions.php" data-client-ajax>'
        . csrf_field()
        . '<input type="hidden" name="action" value="toggle_save">'
        . '<input type="hidden" name="entity_type" value="' . h($type) . '">'
        . '<input type="hidden" name="entity_id" value="' . $id . '">'
        . '<input type="hidden" name="redirect" value="' . h($redirect) . '">'
        . '<button class="heart' . ($saved ? ' is-saved' : '') . '" type="submit" aria-pressed="' . $pressed . '" aria-label="' . ($saved ? 'Remove saved item' : 'Save item') . '">' . client_icon('heart') . '</button></form>';
}

function client_pager(string $pageName, array $filters, array $data, string $noun): string {
    if (($data['pages'] ?? 1) <= 1 && ($data['total'] ?? 0) === 0) {
        return '';
    }
    $page = (int) $data['page'];
    $pages = (int) $data['pages'];
    $html = '<nav class="pager" aria-label="Pagination"><div class="pager__pages">';
    $prev = client_qs($pageName, $filters, ['page' => max(1, $page - 1)]);
    $html .= '<a class="pager__btn" href="' . h($prev) . '"' . ($page <= 1 ? ' aria-disabled="true" tabindex="-1"' : '') . '>Previous</a>';
    for ($i = 1; $i <= $pages && $i <= 8; $i++) {
        $href = client_qs($pageName, $filters, ['page' => $i]);
        $html .= '<a class="pager__btn' . ($i === $page ? ' is-current' : '') . '" href="' . h($href) . '"' . ($i === $page ? ' aria-current="page"' : '') . '>' . $i . '</a>';
    }
    $next = client_qs($pageName, $filters, ['page' => min($pages, $page + 1)]);
    $html .= '<a class="pager__btn" href="' . h($next) . '"' . ($page >= $pages ? ' aria-disabled="true" tabindex="-1"' : '') . '>Next</a></div>';
    $html .= '<p class="pager__meta">Showing ' . (int) $data['from'] . '–' . (int) $data['to'] . ' of ' . (int) $data['total'] . ' ' . h($noun) . '</p></nav>';
    return $html;
}

function client_tabs(string $pageName, array $filters, array $tabs, string $current, array $reset = []): string {
    $html = '<div class="tabs" role="tablist">';
    foreach ($tabs as $id => $label) {
        $href = client_qs($pageName, $filters, array_merge(['tab' => $id, 'page' => 1, 'status' => ''], $reset));
        $html .= '<a class="tabs__tab' . ($current === $id ? ' is-current' : '') . '" role="tab" href="' . h($href) . '"' . ($current === $id ? ' aria-selected="true"' : ' aria-selected="false"') . '>' . h($label) . '</a>';
    }
    $html .= '</div>';
    return $html;
}

function client_select(string $name, string $label, array $options, string $current): string {
    $html = '<label class="filter-field"><span>' . h($label) . '</span><select name="' . h($name) . '">';
    foreach ($options as $value => $text) {
        $html .= '<option value="' . h((string) $value) . '"' . ((string) $value === $current ? ' selected' : '') . '>' . h($text) . '</option>';
    }
    $html .= '</select></label>';
    return $html;
}

function client_stepper(array $steps): string {
    $html = '<ol class="stepper">';
    $currentSet = false;
    foreach ($steps as $step) {
        $done = (bool) $step['done'];
        $state = 'todo';
        if ($done) {
            $state = 'done';
        } elseif (!$currentSet) {
            $state = 'current';
            $currentSet = true;
        }
        $html .= '<li class="stepper__step stepper__step--' . $state . '"><span class="stepper__dot">' . ($done ? client_icon('check') : '') . '</span><span class="stepper__label">' . h($step['label']) . '</span><span class="stepper__date">' . h($step['date']) . '</span></li>';
    }
    $html .= '</ol>';
    return $html;
}

function client_report_steps(array $item): string {
    $status = $item['status'];
    $matched = in_array($status, ['matched', 'resolved'], true);
    $verified = $status === 'resolved' || $item['verified_at'] !== '';
    $resolved = $status === 'resolved';
    return client_stepper([
        ['label' => 'Reported', 'date' => $item['reported_at'], 'done' => true],
        ['label' => 'Match Found', 'date' => $item['matched_at'], 'done' => $matched],
        ['label' => 'Under Verification', 'date' => $item['verified_at'], 'done' => $verified],
        ['label' => 'Resolved', 'date' => $item['resolved_at'], 'done' => $resolved],
    ]);
}

function client_claim_steps(array $item): string {
    $approved = $item['status'] === 'approved' || $item['collected'];
    $rejected = $item['status'] === 'rejected';
    return client_stepper([
        ['label' => 'Claim Submitted', 'date' => $item['submitted_at'], 'done' => true],
        ['label' => 'Under Verification', 'date' => $approved || $rejected ? $item['reviewed_at'] : '', 'done' => true],
        ['label' => 'Approved', 'date' => $approved ? $item['reviewed_at'] : '', 'done' => $approved],
        ['label' => $item['collected'] ? 'Collected' : 'Ready for Pickup', 'date' => $item['collected_at'], 'done' => $item['collected']],
    ]);
}

function client_lost_card(array $item, string $redirect, array $photos = []): string {
    $html = '<article class="item-card"><div class="item-card__media">' . client_photo($item['photo'], $item['item_name'], $photos, 'card') . client_heart('lost', $item['id'], $item['saved'], $redirect) . '<span class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</span></div>';
    $html .= '<div class="item-card__body"><h3>' . h($item['item_name']) . '</h3><p class="muted">' . client_icon('box') . ' ' . h($item['category']) . '</p><p class="muted">' . client_icon('pin') . ' ' . h($item['location'] !== '' ? $item['location'] : 'Location not given') . '</p><p class="muted">' . client_icon('calendar') . ' ' . h($item['date_reported']) . '</p>';
    if ($item['description'] !== '') {
        $html .= '<p class="item-card__copy">' . h($item['description']) . '</p>';
    }
    $html .= '<button type="button" class="btn btn-ghost" data-open-detail="lost-' . $item['id'] . '">View Details</button></div>';
    $html .= '<template id="detail-lost-' . $item['id'] . '"><h2 id="drawer-title">' . h($item['item_name']) . '</h2><p class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</p>' . client_photo_gallery($photos, $item['item_name']) . '<p>' . h($item['description'] !== '' ? $item['description'] : 'No description was provided.') . '</p><dl class="detail-list"><div><dt>Category</dt><dd>' . h($item['category']) . '</dd></div><div><dt>Location</dt><dd>' . h($item['location'] !== '' ? $item['location'] : '—') . '</dd></div><div><dt>Date lost</dt><dd>' . h($item['date_lost']) . '</dd></div><div><dt>Reported</dt><dd>' . h($item['date_reported']) . '</dd></div><div><dt>Report</dt><dd>' . h($item['public_code']) . '</dd></div></dl></template></article>';
    return $html;
}

function client_found_card(array $item, array $photos = []): string {
    $html = '<article class="item-card"><div class="item-card__media">' . client_photo($item['photo'], $item['item_name'], $photos, 'card') . client_heart('found', $item['id'], $item['saved'], 'client-found-items.php') . '<span class="pill pill--cat">' . h($item['category']) . '</span></div>';
    $html .= '<div class="item-card__body"><h3>' . h($item['item_name']) . '</h3><p class="muted">' . client_icon('pin') . ' ' . h($item['location_found']) . '</p><p class="muted">' . client_icon('calendar') . ' ' . h($item['date_found']) . '</p><p class="item-card__copy">' . h($item['summary']) . '</p>';
    $html .= '<button type="button" class="btn btn-ghost" data-open-detail="found-' . $item['id'] . '">View Details</button></div>';
    $html .= '<template id="detail-found-' . $item['id'] . '"><h2 id="drawer-title">' . h($item['item_name']) . '</h2><p class="pill pill--cat">' . h($item['category']) . '</p>' . client_photo_gallery($photos, $item['item_name']) . '<p>' . h($item['summary']) . '</p><dl class="detail-list"><div><dt>Location found</dt><dd>' . h($item['location_found']) . '</dd></div><div><dt>Date found</dt><dd>' . h($item['date_found']) . '</dd></div><div><dt>Item</dt><dd>' . h($item['public_code']) . '</dd></div></dl>';
    if ($item['can_claim']) {
        $html .= '<form method="post" action="../database/client/actions.php" class="stack-form" data-client-ajax>' . csrf_field()
            . '<input type="hidden" name="action" value="create_claim"><input type="hidden" name="found_item_id" value="' . $item['id'] . '"><input type="hidden" name="redirect" value="client-my-claims.php">'
            . '<label class="filter-field"><span>Identifying detail</span><textarea name="answer" maxlength="1000" required placeholder="Describe something only the owner would know"></textarea></label>'
            . '<button class="btn btn-primary" type="submit">Submit Claim</button></form>';
    } else {
        $html .= '<p class="muted">This item is not open for a new claim.</p>';
    }
    $html .= '</template></article>';
    return $html;
}

function client_render(string $module, array $data): string {
    return match ($module) {
        'dashboard' => client_view_dashboard($data),
        'lost-items' => client_view_lost($data, false),
        'found-items' => client_view_found($data),
        'my-reports' => client_view_lost($data, true),
        'my-claims' => client_view_claims($data),
        'notifications' => client_view_notifications($data),
        'settings' => client_view_settings($data),
        default => '<p>This module is not available.</p>',
    };
}

function client_view_dashboard(array $data): string {
    $k = $data['kpis'];
    $html = '<header class="page-intro"><div><h1>' . h($data['greeting']) . ', ' . h($data['first_name']) . '</h1><p>Welcome to Retrieva. Report, search, and claim lost items easily.</p></div></header>';
    $html .= '<section class="kpi-grid">';
    $html .= client_kpi('blue', 'report', (string) $k['reports']['value'], 'My Lost Reports', $k['reports']['detail'], 'flat');
    $html .= client_kpi('gold', 'shield', (string) $k['claims']['value'], 'Active Claims', $k['claims']['detail'], 'flat');
    $html .= client_kpi('green', 'box', (string) $k['matches']['value'], 'Possible Matches', $k['matches']['detail'], 'flat');
    $html .= client_kpi('purple', 'bell', (string) $k['notifications']['value'], 'Notifications', $k['notifications']['detail'], 'flat');
    $html .= '</section>';
    $html .= '<section class="dash-layout"><div class="stack">';
    $html .= '<section class="panel"><div class="panel__head"><h2>Recently Found Items</h2><a href="client-found-items.php">View All</a></div><div class="card-grid">';
    if (!$data['recent_found']) {
        $html .= '<p class="empty">No found items have been logged yet.</p>';
    }
    $foundPhotos = retrieva_photo_map('found', client_cover_map($data['recent_found']));
    foreach ($data['recent_found'] as $item) {
        $html .= client_found_card($item, $foundPhotos[(int) $item['id']] ?? []);
    }
    $html .= '</div></section>';
    $html .= '<div class="split">';
    $html .= '<section class="panel"><div class="panel__head"><h2>My Lost Reports</h2><a href="client-my-reports.php">View All</a></div>';
    if (!$data['my_reports']) {
        $html .= '<p class="empty">You have not reported a lost item yet.</p>';
    }
    $reportPhotos = retrieva_photo_map('lost', client_cover_map($data['my_reports']));
    foreach ($data['my_reports'] as $item) {
        $photos = $reportPhotos[(int) $item['id']] ?? [];
        $html .= '<div class="mini-row mini-row--media">' . client_photo($item['photo'], $item['item_name'], $photos, 'row') . '<a class="mini-row__content" href="client-my-reports.php"><strong>' . h($item['item_name']) . '</strong><small>' . h($item['location']) . ' · ' . h($item['date_reported']) . '</small></a><span class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</span></div>';
    }
    $html .= '</section>';
    $html .= '<section class="panel"><div class="panel__head"><h2>My Claims</h2><a href="client-my-claims.php">View All</a></div>';
    if (!$data['my_claims']) {
        $html .= '<p class="empty">You have not filed a claim yet.</p>';
    }
    $claimCovers = [];
    foreach ($data['my_claims'] as $item) {
        if (!empty($item['found_id'])) {
            $claimCovers[(int) $item['found_id']] = (string) ($item['photo_path'] ?? '');
        }
    }
    $claimPhotos = retrieva_photo_map('found', $claimCovers);
    foreach ($data['my_claims'] as $item) {
        $photos = $claimPhotos[(int) ($item['found_id'] ?? 0)] ?? [];
        $html .= '<div class="mini-row mini-row--media">' . client_photo($item['photo'], $item['item_name'], $photos, 'row') . '<a class="mini-row__content" href="client-my-claims.php"><strong>' . h($item['item_name']) . '</strong><small>Claimed on ' . h($item['claimed_on']) . '</small></a><span class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</span></div>';
    }
    $html .= '</section></div></div>';
    $html .= '<aside class="stack"><section class="panel"><div class="panel__head"><h2>Notifications</h2><a href="client-notifications.php">View All</a></div>';
    if (!$data['notifications']) {
        $html .= '<p class="empty">You are all caught up.</p>';
    }
    foreach ($data['notifications'] as $note) {
        $html .= '<a class="note-row" href="client-notifications.php?open=' . $note['id'] . '"><strong>' . h($note['title']) . '</strong><span>' . h($note['body']) . '</span><small>' . h($note['ago']) . '</small></a>';
    }
    $html .= '</section><section class="panel"><h2>Quick Actions</h2><div class="quick-grid"><a class="quick" href="client-lost-items.php#report-lost">' . client_icon('report') . ' Report Lost Item</a><a class="quick" href="client-found-items.php">' . client_icon('search') . ' Browse Found Items</a><a class="quick" href="client-my-claims.php">' . client_icon('shield') . ' Track My Claims</a><a class="quick" href="client-notifications.php">' . client_icon('bell') . ' View Notifications</a></div></section></aside></section>';
    return $html;
}

function client_view_lost(array $data, bool $mine): string {
    $page = $mine ? 'client-my-reports.php' : 'client-lost-items.php';
    $filters = $data['filters'];
    $counts = $data['counts'];
    $title = $mine ? 'My Reports' : 'Lost Items';
    $intro = $mine ? 'Track the status of the lost items you have reported.' : 'Browse lost item reports submitted by UMak students. If you found any of these items, please turn it over to the security office.';
    $html = '<header class="page-intro"><div><h1>' . $title . '</h1><p>' . h($intro) . '</p></div><a class="btn btn-primary" href="#report-lost">' . client_icon('plus') . ' Report Lost Item</a></header>';
    if ($mine) {
        $html .= '<section class="kpi-grid">';
        $html .= client_kpi('blue', 'report', (string) $counts['searching'], 'Active Reports', 'Still looking', 'flat');
        $html .= client_kpi('gold', 'search', (string) $counts['matched'], 'Matched Reports', 'Possible match found', 'flat');
        $html .= client_kpi('green', 'check', (string) $counts['resolved'], 'Resolved Reports', 'Item has been returned', 'flat');
        $html .= client_kpi('red', 'bell', (string) $counts['closed'], 'Closed / Unsuccessful', 'No match found yet', 'flat');
        $html .= '</section>';
        $tabs = ['all' => 'All Reports (' . $counts['all'] . ')', 'active' => 'Active (' . $counts['searching'] . ')', 'matched' => 'Matched (' . $counts['matched'] . ')', 'resolved' => 'Resolved (' . $counts['resolved'] . ')', 'closed' => 'Closed (' . $counts['closed'] . ')'];
    } else {
        $html .= '<section class="kpi-grid">';
        $html .= client_kpi('blue', 'report', (string) $counts['all'], 'Total Lost Reports', $data['deltas']['total']['text'], $data['deltas']['total']['direction']);
        $html .= client_kpi('gold', 'search', (string) $counts['active'], 'Active Reports', $data['deltas']['active']['text'], $data['deltas']['active']['direction']);
        $html .= client_kpi('green', 'check', (string) $counts['resolved'], 'Resolved Reports', $data['deltas']['resolved']['text'], $data['deltas']['resolved']['direction']);
        $html .= client_kpi('purple', 'calendar', (string) $data['today'], 'Reported Today', $data['deltas']['today']['text'], $data['deltas']['today']['direction']);
        $html .= '</section>';
        $tabs = ['all' => 'All Reports (' . $counts['all'] . ')', 'active' => 'Active (' . $counts['active'] . ')', 'resolved' => 'Resolved (' . $counts['resolved'] . ')', 'closed' => 'Closed (' . $counts['closed'] . ')'];
    }
    $html .= '<form class="filter-bar" method="get" action="' . h($page) . '" data-client-filter>';
    if (!$mine) {
        $categories = ['' => 'All Categories'] + array_combine(CLIENT_CATEGORIES, CLIENT_CATEGORIES);
        $locations = ['' => 'All Locations'];
        foreach ($data['locations'] as $location) {
            $locations[$location] = $location;
        }
        $html .= client_select('category', 'Category', $categories, $filters['category']);
        $html .= client_select('location', 'Location', $locations, $filters['location']);
        $html .= client_select('status', 'Status', ['' => 'All Status', 'active' => 'Active', 'matched' => 'Matched', 'resolved' => 'Resolved', 'closed' => 'Closed'], $filters['status']);
        $html .= '<label class="filter-field"><span>Date Reported</span><span class="date-pair"><input type="date" name="start" value="' . h($filters['start']) . '" aria-label="Start date"><input type="date" name="end" value="' . h($filters['end']) . '" aria-label="End date"></span></label>';
    }
    $html .= client_select('sort', 'Sort by', ['latest' => 'Latest', 'oldest' => 'Oldest'], $filters['sort']);
    $html .= '<label class="filter-field filter-field--search"><span class="visually-hidden">Search</span><input type="search" name="q" value="' . h($filters['q']) . '" placeholder="' . ($mine ? 'Search your reports' : 'Search lost items') . '"></label>';
    $html .= '<button class="btn btn-primary" type="submit">Search</button></form>';
    $currentTab = $filters['tab'] !== '' ? $filters['tab'] : 'all';
    $html .= client_tabs($page, $filters, $tabs, $currentTab);
    if ($mine) {
        $html .= '<div class="report-list">';
        if (!$data['items']) {
            $html .= '<p class="empty">No reports match this view.</p>';
        }
        $reportPhotos = retrieva_photo_map('lost', client_cover_map($data['items']));
        foreach ($data['items'] as $item) {
            $photos = $reportPhotos[(int) $item['id']] ?? [];
            $html .= '<article class="report-row">' . client_photo($item['photo'], $item['item_name'], $photos, 'row') . '<div><h3>' . h($item['item_name']) . ' <span class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</span></h3><p class="muted">' . h($item['category']) . ' · ' . h($item['location']) . ' · ' . h($item['date_reported']) . '</p><p>' . h($item['description']) . '</p></div>' . client_report_steps($item) . '<div class="report-row__actions"><button type="button" class="btn btn-primary" data-open-detail="report-' . $item['id'] . '">View Details</button>';
            $html .= '</div>';
            if ($item['can_edit']) {
                $html .= '<details class="edit-disclosure"><summary>Edit Report</summary>' . client_report_form($item, $photos) . '</details>';
            }
            $html .= '<template id="detail-report-' . $item['id'] . '"><h2 id="drawer-title">' . h($item['item_name']) . '</h2>' . client_photo_gallery($photos, $item['item_name']) . client_report_steps($item) . '<p>' . h($item['description'] !== '' ? $item['description'] : 'No description was provided.') . '</p>' . '</template></article>';
        }
        $html .= '</div>';
    } else {
        $html .= '<div class="card-grid">';
        if (!$data['items']) {
            $html .= '<p class="empty">No lost reports match these filters.</p>';
        }
        $lostPhotos = retrieva_photo_map('lost', client_cover_map($data['items']));
        foreach ($data['items'] as $item) {
            $html .= client_lost_card($item, $page, $lostPhotos[(int) $item['id']] ?? []);
        }
        $html .= '</div>';
    }
    $html .= client_pager($page, $filters, $data, $mine ? 'reports' : 'reports');
    $html .= '<section class="panel" id="report-lost"><h2>' . ($mine ? 'Report another lost item' : 'Report a Lost Item') . '</h2>' . client_report_form(null) . '</section>';
    return $html;
}

function client_report_form(?array $item, array $photos = []): string {
    $editing = $item !== null;
    $selectedCategory = $editing ? dashboard_category_label((string) $item['category']) : '';
    $html = '<form class="stack-form" method="post" action="../database/client/actions.php" enctype="multipart/form-data" data-client-ajax id="' . ($editing ? 'edit-report-' . $item['id'] : 'report-lost-form') . '">';
    $html .= csrf_field();
    $html .= '<input type="hidden" name="action" value="' . ($editing ? 'update_report' : 'create_report') . '">';
    $html .= '<input type="hidden" name="redirect" value="client-my-reports.php">';
    if ($editing) {
        $html .= '<input type="hidden" name="item_id" value="' . $item['id'] . '">';
    }
    $html .= '<div class="form-grid"><label class="filter-field"><span>Item name</span><input name="item_name" maxlength="150" required value="' . h($editing ? $item['item_name'] : '') . '"></label>';
    $html .= '<label class="filter-field"><span>Category</span><select name="category" required>';
    if (!$editing || $selectedCategory === 'Unspecified') {
        $html .= '<option value="" disabled selected>Select a category...</option>';
    }
    foreach (ITEM_CATEGORY_OPTIONS as $category) {
        $html .= '<option value="' . h($category) . '"' . ($selectedCategory === $category ? ' selected' : '') . '>' . h($category) . '</option>';
    }
    $html .= '</select></label><label class="filter-field"><span>Last seen location</span><input name="last_seen_location" maxlength="150" value="' . h($editing ? $item['location'] : '') . '"></label>';
    $html .= '<label class="filter-field"><span>Date lost</span><input type="date" name="date_lost" required max="' . date('Y-m-d') . '" value="' . h($editing ? (string) ($item['date_lost_raw'] ?? '') : date('Y-m-d')) . '"></label></div>';
    $html .= '<label class="filter-field"><span>Description</span><textarea name="description" maxlength="1000">' . h($editing ? $item['description'] : '') . '</textarea></label>';
    $html .= client_photo_picker($photos);
    $html .= '<button class="btn btn-primary" type="submit">' . ($editing ? 'Save Report' : 'Submit Report') . '</button>';
    if ($editing) {
        $html .= '</form><form method="post" action="../database/client/actions.php" data-client-ajax onsubmit="return confirm(\'Delete this report?\');">' . csrf_field()
            . '<input type="hidden" name="action" value="delete_report"><input type="hidden" name="item_id" value="' . $item['id'] . '"><input type="hidden" name="redirect" value="client-my-reports.php"><button class="btn btn-danger" type="submit">Delete Report</button></form>';
        return $html;
    }
    $html .= '</form>';
    return $html;
}

function client_view_found(array $data): string {
    $filters = $data['filters'];
    $page = 'client-found-items.php';
    $html = '<header class="page-intro"><div><h1>Found Items</h1><p>Items turned in to the UMak security office. If you believe an item is yours, submit a claim for verification.</p></div></header>';
    $html .= '<section class="kpi-grid">';
    $html .= client_kpi('blue', 'box', (string) $data['kpis']['total'], 'Total Found Items', $data['deltas']['total']['text'], $data['deltas']['total']['direction']);
    $html .= client_kpi('gold', 'search', (string) $data['kpis']['pending'], 'Pending Claims', $data['deltas']['pending']['text'], $data['deltas']['pending']['direction']);
    $html .= client_kpi('green', 'check', (string) $data['kpis']['returned'], 'Returned to Owners', $data['deltas']['returned']['text'], $data['deltas']['returned']['direction']);
    $html .= client_kpi('purple', 'bell', (string) $data['kpis']['new_week'], 'Newly Added', $data['deltas']['new_week']['text'], $data['deltas']['new_week']['direction']);
    $html .= '</section><form class="filter-bar" method="get" action="' . $page . '" data-client-filter>';
    $categories = ['' => 'All Categories'] + array_combine(CLIENT_CATEGORIES, CLIENT_CATEGORIES);
    $locations = ['' => 'All Locations'];
    foreach ($data['locations'] as $location) {
        $locations[$location] = $location;
    }
    $html .= client_select('category', 'Category', $categories, $filters['category']);
    $html .= client_select('location', 'Location Found', $locations, $filters['location']);
    $html .= client_select('dates', 'Date Found', ['all' => 'All Dates', '7' => 'Last 7 days', '30' => 'Last 30 days', 'month' => 'This month'], $filters['dates']);
    $html .= client_select('sort', 'Sort by', ['latest' => 'Date (Newest)', 'oldest' => 'Date (Oldest)'], $filters['sort']);
    $html .= '<label class="filter-field filter-field--search"><span class="visually-hidden">Search</span><input type="search" name="q" value="' . h($filters['q']) . '" placeholder="Search found items"></label><button class="btn btn-primary" type="submit">Search</button></form>';
    $tabs = ['all' => 'All Items (' . $data['counts']['all'] . ')'];
    foreach (CLIENT_CATEGORIES as $category) {
        $tabs[$category] = $category . ' (' . (int) $data['counts']['categories'][$category] . ')';
    }
    $html .= client_tabs($page, $filters, $tabs, $filters['tab'], ['category' => '']);
    $html .= '<div class="card-grid">';
    if (!$data['items']) {
        $html .= '<p class="empty">No found items match these filters.</p>';
    }
    $foundPhotos = retrieva_photo_map('found', client_cover_map($data['items']));
    foreach ($data['items'] as $item) {
        $html .= client_found_card($item, $foundPhotos[(int) $item['id']] ?? []);
    }
    $html .= '</div>' . client_pager($page, $filters, $data, 'items');
    return $html;
}

function client_view_claims(array $data): string {
    $filters = $data['filters'];
    $counts = $data['counts'];
    $page = 'client-my-claims.php';
    $html = '<header class="page-intro"><div><h1>My Claims</h1><p>Track the status of your claims for found items. You will be notified once there are updates.</p></div></header>';
    $html .= '<section class="kpi-grid kpi-grid--five">';
    $html .= client_kpi('blue', 'report', (string) $counts['all'], 'Total Claims', 'Your submitted claims', 'flat');
    $html .= client_kpi('gold', 'search', (string) $counts['pending'], 'Pending Verification', 'Awaiting review', 'flat');
    $html .= client_kpi('green', 'check', (string) $counts['approved'], 'Approved', 'Ready for pickup', 'flat');
    $html .= client_kpi('purple', 'box', (string) $counts['collected'], 'Completed', 'Item collected', 'flat');
    $html .= client_kpi('red', 'bell', (string) $counts['rejected'], 'Rejected', 'Claims that did not match', 'flat');
    $html .= '</section>';
    $html .= '<form class="filter-bar" method="get" action="' . $page . '" data-client-filter>' . client_select('sort', 'Sort by', ['latest' => 'Latest', 'oldest' => 'Oldest'], $filters['sort']) . '<label class="filter-field filter-field--search"><span class="visually-hidden">Search</span><input type="search" name="q" value="' . h($filters['q']) . '" placeholder="Search your claims"></label><button class="btn btn-primary" type="submit">Search</button></form>';
    $tabs = ['all' => 'All Claims (' . $counts['all'] . ')', 'pending' => 'Pending (' . $counts['pending'] . ')', 'approved' => 'Approved (' . $counts['approved'] . ')', 'collected' => 'Collected (' . $counts['collected'] . ')', 'rejected' => 'Rejected (' . $counts['rejected'] . ')'];
    $html .= client_tabs($page, $filters, $tabs, $filters['tab'] !== '' ? $filters['tab'] : 'all');
    $html .= '<div class="report-list">';
    if (!$data['items']) {
        $html .= '<p class="empty">No claims match this view.</p>';
    }
    $claimCovers = [];
    foreach ($data['items'] as $item) {
        if (!empty($item['found_id'])) {
            $claimCovers[(int) $item['found_id']] = (string) $item['photo'];
        }
    }
    $claimPhotos = retrieva_photo_map('found', $claimCovers);
    foreach ($data['items'] as $item) {
        $photos = $claimPhotos[(int) ($item['found_id'] ?? 0)] ?? [];
        $html .= '<article class="report-row">' . client_photo($item['photo'], $item['item_name'], $photos, 'row') . '<div><h3>' . h($item['item_name']) . ' <span class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</span></h3><p class="muted">' . h($item['category']) . ' · ' . h($item['location']) . '</p><p>Claimed on ' . h($item['claimed_on']) . '</p></div>' . client_claim_steps($item) . '<div class="claim-side"><strong>' . h($item['label']) . '</strong>';
        if ($item['show_qr']) {
            $html .= '<button type="button" class="btn btn-primary" data-open-detail="qr-' . $item['id'] . '">View Pickup QR</button>';
        }
        $html .= '<button type="button" class="btn btn-ghost" data-open-detail="claim-' . $item['id'] . '">View Claim Details</button>';
        if (in_array($item['status'], ['pending', 'manual_review'], true)) {
            $html .= '<form method="post" action="../database/client/actions.php" data-client-ajax>' . csrf_field()
                . '<input type="hidden" name="action" value="withdraw_claim"><input type="hidden" name="claim_id" value="' . $item['id'] . '"><input type="hidden" name="redirect" value="client-my-claims.php">'
                . '<button class="btn btn-danger" type="submit">Withdraw Claim</button></form>';
        }
        $html .= '</div>';
        $html .= '<template id="detail-claim-' . $item['id'] . '"><h2 id="drawer-title">' . h($item['item_name']) . '</h2><p class="pill pill--' . h($item['status']) . '">' . h($item['label']) . '</p>' . client_photo_gallery($photos, $item['item_name']) . client_claim_steps($item) . '<p>' . h($item['summary']) . '</p>';
        if ($item['answer'] !== '') {
            $html .= '<p><strong>Your identifying detail</strong><br>' . h($item['answer']) . '</p>';
        }
        if ($item['rejection_reason'] !== '') {
            $html .= '<p>' . h($item['rejection_reason']) . '</p>';
        }
        $html .= '</template>';
        if ($item['show_qr']) {
            $pickupLocation = $item['pickup_location'] !== ''
                ? $item['pickup_location']
                : 'No pickup location is recorded. Contact Campus Security to confirm where to collect your item.';
            $html .= '<template id="detail-qr-' . $item['id'] . '"><h2 id="drawer-title">Pickup QR</h2><p>Show this code at the pickup location listed below.</p><div class="qr-box" data-qr-token="' . h($item['qr_token']) . '"></div><p class="pickup-location-label"><strong>Pickup location:</strong> ' . h($pickupLocation) . '</p><p class="pickup-code"><strong>Token fallback:</strong><code>' . h($item['qr_token']) . '</code></p></template>';
        }
        $html .= '</article>';
    }
    $html .= '</div>' . client_pager($page, $filters, $data, 'claims');
    return $html;
}

function client_view_notifications(array $data): string {
    $filters = $data['filters'];
    $counts = $data['counts'];
    $page = 'client-notifications.php';
    $html = '<header class="page-intro"><div><h1>Notifications</h1><p>Stay updated on your lost item reports, claims, and possible matches.</p></div><form method="post" action="../database/client/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="mark_all_read"><input type="hidden" name="redirect" value="client-notifications.php"><button class="btn btn-ghost" type="submit">Mark All as Read</button></form></header>';
    $tabs = [
        'all' => 'All (' . $counts['all'] . ')',
        'unread' => 'Unread (' . $counts['unread'] . ')',
        'match' => 'Matches (' . $counts['match'] . ')',
        'claim' => 'Claims (' . $counts['claim'] . ')',
        'report' => 'Reports (' . $counts['report'] . ')',
        'system' => 'System (' . $counts['system'] . ')',
    ];
    $html .= client_tabs($page, $filters, $tabs, $filters['tab'] !== '' ? $filters['tab'] : 'all');
    $html .= '<div class="note-layout"><div class="note-list">';
    $selected = null;
    if (!$data['items']) {
        $html .= '<p class="empty">No notifications in this view.</p>';
    }
    foreach ($data['items'] as $note) {
        if ((int) $note['id'] === (int) $data['open_id']) {
            $selected = $note;
        }
        $href = client_qs($page, $filters, ['open' => $note['id']]);
        $html .= '<a class="note-row' . ($selected === $note ? ' is-current' : '') . ($note['unread'] ? ' is-unread' : '') . '" href="' . h($href) . '"><strong>' . h($note['title']) . '</strong><span>' . h($note['body']) . '</span><small>' . h($note['ago']) . '</small></a>';
    }
    $html .= '</div><aside class="panel note-detail">';
    if ($selected) {
        $html .= '<h2>' . h($selected['title']) . '</h2><p class="muted">' . h($selected['when']) . '</p><p>' . h($selected['body']) . '</p>';
        if ($selected['unread']) {
            $html .= '<form method="post" action="../database/client/actions.php" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="mark_read"><input type="hidden" name="notification_id" value="' . $selected['id'] . '"><input type="hidden" name="redirect" value="' . h(client_qs($page, $filters, ['open' => $selected['id']])) . '"><button class="btn btn-primary" type="submit">Mark as Read</button></form>';
        }
        $html .= client_notification_links($selected);
    } else {
        $html .= '<p class="empty">Select a notification to read it.</p>';
    }
    $html .= '</aside></div>';
    return $html;
}

function client_notification_links(array $note): string {
    $type = $note['entity_type'];
    $id = (int) $note['entity_id'];
    if ($type === 'found' && $id > 0) {
        return '<a class="btn btn-primary" href="client-found-items.php">View Found Item</a>';
    }
    if ($type === 'claim' && $id > 0) {
        return '<a class="btn btn-primary" href="client-my-claims.php">Go to My Claim</a>';
    }
    if ($type === 'lost' && $id > 0) {
        return '<a class="btn btn-primary" href="client-my-reports.php">Go to My Reports</a>';
    }
    return '';
}

function client_view_settings(array $data): string {
    $user = $data['user'];
    $sections = $data['sections'] ?? ['account', 'security', 'notifications', 'privacy'];
    $show = static fn (string $id): bool => in_array($id, $sections, true);
    $nav = [
        'account' => [client_icon('report'), 'Account Information'],
        'security' => [client_icon('shield'), 'Security'],
        'notifications' => [client_icon('bell'), 'Notifications'],
        'privacy' => [client_icon('search'), 'Privacy'],
    ];
    $html = '<header class="page-intro"><div><h1>Settings</h1><p>Manage your account, security, and notification preferences.</p></div></header>';
    $html .= '<div class="settings-layout"><nav class="settings-nav" aria-label="Settings sections">';
    foreach ($nav as $id => $item) {
        if ($show($id)) {
            $html .= '<a href="#' . $id . '">' . $item[0] . ' ' . h($item[1]) . '</a>';
        }
    }
    $html .= '</nav><div class="settings-panels">';
    if (!empty($data['search_empty'])) {
        $html .= '<p class="empty" id="client-search-empty" data-toast="No settings match that search.">No settings match that search.</p>';
    }
    if ($show('account')) {
        $html .= '<section class="panel settings-panel settings-panel--account" id="account"><div class="panel__head"><h2>Account Information</h2></div><div class="account-hero"><div class="avatar-fallback">' . h(strtoupper(substr($user['full_name'], 0, 1))) . '</div><div><strong>' . h($user['full_name']) . '</strong><p class="muted">' . h((string) ($user['student_id'] ?? '')) . '</p><p>' . h(ucfirst((string) $user['role'])) . '</p></div></div>';
        $html .= '<form method="post" action="../database/client/actions.php" class="stack-form" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="update_profile"><input type="hidden" name="redirect" value="client-settings.php#account">';
        $html .= '<label class="filter-field"><span>Email Address</span><input value="' . h($user['email']) . '" readonly><small>' . ($user['email_verified'] ? 'Verified' : 'Not verified') . '</small></label>';
        $html .= '<label class="filter-field"><span>Phone Number</span><input name="phone" maxlength="30" value="' . h((string) ($user['phone'] ?? '')) . '"><small>' . ($user['phone_verified'] ? 'Verified' : 'Not verified — SMS verification is not available yet') . '</small></label>';
        $html .= '<label class="filter-field"><span>Student ID</span><input value="' . h((string) ($user['student_id'] ?? '')) . '" readonly></label>';
        $html .= '<label class="filter-field"><span>Program / Department</span><input name="program_department" maxlength="150" value="' . h((string) ($user['program_department'] ?? '')) . '"></label>';
        $html .= '<button class="btn btn-primary" type="submit">Save Account</button></form></section>';
    }
    if ($show('security')) {
        $html .= '<section class="panel" id="security">';
        if (!empty($user['password_is_set'])) {
            $html .= '<h2>Change Password</h2><form id="change-password-form" class="stack-form"><label class="filter-field"><span>New Password</span><input type="password" name="password" minlength="8" autocomplete="new-password" required></label><label class="filter-field"><span>Confirm New Password</span><input type="password" name="confirm_password" minlength="8" autocomplete="new-password" required></label>';
            $html .= !empty($user['totp_enabled']) ? '<label class="filter-field"><span>Authenticator code</span><input type="text" name="totp_code" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" autocomplete="one-time-code" required></label>' : '<label class="filter-field"><span>Current Password</span><input type="password" name="current_password" autocomplete="current-password" required></label>';
            $html .= '<button class="btn btn-primary" type="submit">Update Password</button><p class="form-feedback" id="password-feedback" role="status"></p></form>';
        } else {
            $html .= '<h2>Create a Password</h2><form id="create-password-form" class="stack-form"><label class="filter-field"><span>New Password</span><input type="password" name="password" minlength="8" autocomplete="new-password" required></label><label class="filter-field"><span>Confirm New Password</span><input type="password" name="confirm_password" minlength="8" autocomplete="new-password" required></label><button class="btn btn-primary" type="submit">Create Password</button><p class="form-feedback" id="password-feedback" role="status"></p></form>';
        }
        $loginMethod = ($user['login_method'] ?? 'email') === 'totp' ? 'totp' : 'email';
        $loginNote = 'Sign-in will ask for the authenticator code first.';
        if (empty($user['totp_enabled'])) {
            $loginNote .= ' Email remains the sign-in code until authenticator setup is finished.';
        }
        $html .= '<h2>Two-Factor Authentication</h2><form method="post" action="../database/client/actions.php" class="stack-form" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="update_login_method"><input type="hidden" name="redirect" value="client-settings.php#security"><fieldset class="stack-form"><legend>Which code should appear first at sign-in?</legend><label class="pref-row"><span>Email code</span><input type="radio" name="login_method" value="email"' . ($loginMethod === 'email' ? ' checked' : '') . '></label><label class="pref-row"><span>Authenticator app</span><input type="radio" name="login_method" value="totp"' . ($loginMethod === 'totp' ? ' checked' : '') . '></label></fieldset><p id="login-method-note"' . ($loginMethod === 'totp' ? '' : ' hidden') . '>' . h($loginNote) . '</p><button class="btn btn-primary" type="submit">Save sign-in method</button></form><div class="pref-row"><div><strong>Authenticator App</strong><p class="muted">Use an authenticator app such as Google Authenticator.</p></div><button type="button" class="btn btn-ghost" id="totp-start-btn"' . ($user['totp_enabled'] ? ' hidden' : '') . '>Set up</button><button type="button" class="btn btn-danger" id="totp-disable-btn"' . ($user['totp_enabled'] ? '' : ' hidden') . '>Disable</button></div><div id="totp-setup-panel" hidden data-email="' . h($user['email']) . '"><div class="totp-setup-row"><label class="filter-field"><span>Setup key</span><input id="totp-secret" readonly title="Click to copy the setup key"></label><div id="totp-qr" aria-hidden="true"></div></div><p class="muted">Scan the code or click the key to copy it, then enter the six-digit code from your authenticator app.</p><form id="totp-verify-form" class="stack-form"><label class="filter-field"><span>Authenticator code</span><input id="totp-code" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required></label><button class="btn btn-primary" type="submit">Verify and enable</button></form></div><p class="form-feedback" id="totp-feedback" role="status"></p><div class="pref-row"><div><strong>Email OTP</strong><p class="muted">Sign-in email codes stay on for this account.</p></div><span class="pill pill--resolved">On</span></div></section>';
    }
    if ($show('notifications')) {
        $html .= '<section class="panel" id="notifications"><h2>Notification Preferences</h2><form method="post" action="../database/client/actions.php" class="stack-form" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="update_notifications"><input type="hidden" name="redirect" value="client-settings.php#notifications">';
        foreach ([
            'notify_email' => ['Email Notifications', 'Claim updates, matches, and important announcements'],
            'notify_sms' => ['SMS Notifications', 'Receive SMS for approved claims and pickup reminders'],
            'notify_in_app' => ['In-App Notifications', 'Real-time updates inside Retrieva'],
            'notify_matches' => ['Possible Match Alerts', 'Notify me when a found item may match my report'],
            'notify_system' => ['System Announcements', 'Updates about the Retrieva system'],
        ] as $name => $meta) {
            $html .= '<label class="pref-row"><span><strong>' . h($meta[0]) . '</strong><small>' . h($meta[1]) . '</small></span><input type="checkbox" name="' . h($name) . '" value="1"' . ($user[$name] ? ' checked' : '') . '></label>';
        }
        $html .= '<button class="btn btn-primary" type="submit">Save Preferences</button></form></section>';
    }
    if ($show('privacy')) {
        $html .= '<section class="panel" id="privacy"><h2>Privacy</h2><p>Found-item identifying details stay hidden on the public Found Items page. Your lost-report description is visible to other signed-in UMak users when campus listing is on.</p><form method="post" action="../database/client/actions.php" class="stack-form" data-client-ajax>' . csrf_field() . '<input type="hidden" name="action" value="update_privacy"><input type="hidden" name="redirect" value="client-settings.php#privacy"><label class="pref-row"><span><strong>Show my lost reports</strong><small>List them on the campus Lost Items page.</small></span><input type="checkbox" name="share_lost_reports" value="1"' . ($user['share_lost_reports'] ? ' checked' : '') . '></label><button class="btn btn-primary" type="submit">Save Privacy</button></form></section>';
    }
    $html .= '</div></div>';
    return $html;
}
