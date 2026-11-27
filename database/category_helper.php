<?php
declare(strict_types=1);

const ITEM_CATEGORY_OPTIONS = [
    'Phones (Android)',
    'Phones (Iphone)',
    'Notebook',
    'Book',
    'ID',
    'ID lace',
    'Food containers and utensils',
    'Tumbler/Flask/Bottled Water',
    'Others',
];

const ITEM_CATEGORY_CHART_LABELS = [
    'Phones (Android)',
    'Phones (Iphone)',
    'Notebook',
    'Book',
    'ID',
    'ID lace',
    'Food containers and utensils',
    'Tumbler/Flask/Bottled Water',
    'Others',
    'Unspecified',
];

const ITEM_CATEGORY_LEGACY_LABELS = [
    'Phone (Android)' => 'Phones (Android)',
    'Phone (Iphone)' => 'Phones (Iphone)',
    'Tablet' => 'Others',
    'Lace' => 'ID lace',
    'Bag' => 'Others',
    'Shoes' => 'Others',
    'Other' => 'Others',
];

function dashboard_category_label(?string $category): string {
    $category = trim((string) $category);
    if ($category === '') {
        return 'Unspecified';
    }

    if (isset(ITEM_CATEGORY_LEGACY_LABELS[$category])) {
        return ITEM_CATEGORY_LEGACY_LABELS[$category];
    }

    return in_array($category, ITEM_CATEGORY_OPTIONS, true) ? $category : 'Unspecified';
}

function dashboard_category_rows(PDO $db, string $table): array {
    if (!in_array($table, ['found_items', 'lost_items'], true)) {
        throw new InvalidArgumentException('Unsupported category table.');
    }

    $counts = array_fill_keys(ITEM_CATEGORY_CHART_LABELS, 0);
    $sql = "SELECT category, COUNT(*) AS total FROM {$table} GROUP BY category";

    foreach ($db->query($sql)->fetchAll(PDO::FETCH_ASSOC) as $row) {
        $label = dashboard_category_label(isset($row['category']) ? (string) $row['category'] : null);
        $counts[$label] += (int) $row['total'];
    }

    $rows = [];
    foreach (ITEM_CATEGORY_CHART_LABELS as $label) {
        $rows[] = ['label' => $label, 'total' => $counts[$label]];
    }

    return $rows;
}
