<?php
declare(strict_types=1);

require_once __DIR__ . '/lib.php';
require_once __DIR__ . '/pdf.php';

start_session();
if (!session_id_present('user_id')) {
    header('Location: ../../auth/login.php');
    exit;
}
if (!in_array($_SESSION['role'] ?? '', RETRIEVA_ADMIN_ROLES, true)) {
    header('Location: ../../dashboard/index.php');
    exit;
}

$module = (string) ($_GET['module'] ?? '');
$format = (string) ($_GET['format'] ?? '') === 'pdf' ? 'pdf' : 'csv';
$range = admin_date_range($_GET);
$doc = [
    'title' => 'Export',
    'subtitle' => admin_range_label($range),
    'filename' => 'retrieva-export',
    'kpis' => [],
    'charts' => [],
    'headers' => ['Message'],
    'rows' => [['Nothing to export.']],
];

if ($module === 'audit') {
    $audit = admin_audit_data($_GET);
    $doc['title'] = 'Audit Logs';
    $doc['filename'] = 'retrieva-audit';
    $doc['subtitle'] = admin_range_label($audit['range']);
    $doc['kpis'] = [
        ['label' => 'Sign-in', 'value' => (string) $audit['counts']['login']],
        ['label' => 'Items', 'value' => (string) $audit['counts']['items']],
        ['label' => 'Claims', 'value' => (string) $audit['counts']['claims']],
        ['label' => 'Accounts', 'value' => (string) $audit['counts']['users']],
    ];
    $exported = admin_audit_export_rows($_GET);
    if ($format === 'pdf') {
        $doc['headers'] = ['When', 'Person', 'Action', 'Details'];
        $doc['rows'] = array_map(static fn(array $row): array => [$row[0], $row[1], $row[3], $row[4]], $exported);
    } else {
        $doc['headers'] = ['When', 'Person', 'Email', 'Action', 'Details', 'IP'];
        $doc['rows'] = $exported;
    }
} elseif ($module === 'reports') {
    $report = admin_reports_data($_GET);
    $tab = (string) $report['filters']['tab'];
    $table = admin_report_table($tab, $report['range']);
    $doc['title'] = 'Reports & Analytics';
    $doc['filename'] = 'retrieva-reports-' . $tab;
    $doc['subtitle'] = ucfirst($tab) . ' · ' . admin_range_label($report['range']);
    $doc['kpis'] = [
        ['label' => 'Found', 'value' => (string) $report['found']],
        ['label' => 'Lost', 'value' => (string) $report['lost']],
        ['label' => 'Claims', 'value' => (string) $report['claims']],
        ['label' => 'Users', 'value' => (string) $report['users']],
    ];
    $chart = $report['chart'];
    $doc['charts'] = [
        [
            'title' => 'Lost and found',
            'labels' => $chart['days'],
            'series' => [
                ['name' => 'Lost', 'color' => [11, 61, 145], 'values' => $chart['lost']],
                ['name' => 'Found', 'color' => [201, 162, 39], 'values' => $chart['found']],
            ],
        ],
        [
            'title' => 'Categories',
            'labels' => $chart['categories'],
            'series' => [
                ['name' => 'Lost', 'color' => [11, 61, 145], 'values' => $chart['category_lost']],
                ['name' => 'Found', 'color' => [201, 162, 39], 'values' => $chart['category_found']],
            ],
        ],
    ];
    $doc['headers'] = $table['headers'];
    $doc['rows'] = $table['rows'];
}

$safeName = preg_replace('/[^a-z0-9-]/', '', $doc['filename']) ?: 'retrieva-export';
if ($format === 'pdf') {
    header('Content-Type: application/pdf');
    header('Content-Disposition: attachment; filename="' . $safeName . '.pdf"');
    echo retrieva_pdf_build($doc);
    exit;
}

header('Content-Type: text/csv; charset=UTF-8');
header('Content-Disposition: attachment; filename="' . $safeName . '.csv"');
$out = fopen('php://output', 'w');
if ($out === false) {
    exit;
}
fputcsv($out, $doc['headers']);
foreach ($doc['rows'] as $row) {
    fputcsv($out, $row);
}
fclose($out);
