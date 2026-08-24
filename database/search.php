<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
$session = require_login();
$query = trim((string) ($_GET['q'] ?? $_POST['q'] ?? ''));
if ($query === '' || strlen($query) > 80) json_out(['success' => false, 'message' => 'Enter a search up to 80 characters.'], 422);
$db = get_db(); $like = '%' . $query . '%'; $results = [];
if (in_array($session['role'], ['admin', 'security'], true)) {
    $stmt = $db->prepare("SELECT id, item_name AS title, category AS context, status, date_found AS record_date FROM found_items WHERE item_name LIKE ? OR category LIKE ? OR location_found LIKE ? LIMIT 10"); $stmt->execute([$like, $like, $like]);
    foreach ($stmt->fetchAll() as $row) $results[] = ['type'=>'found', 'id'=>(int)$row['id'], 'title'=>$row['title'], 'context'=>$row['context'], 'status'=>$row['status'], 'date'=>$row['record_date'], 'url'=>'found-items.php'];
    $stmt = $db->prepare("SELECT id, item_name AS title, category AS context, status, date_lost AS record_date FROM lost_items WHERE item_name LIKE ? OR category LIKE ? OR last_seen_location LIKE ? OR description LIKE ? LIMIT 10"); $stmt->execute([$like, $like, $like, $like]);
    foreach ($stmt->fetchAll() as $row) $results[] = ['type'=>'lost', 'id'=>(int)$row['id'], 'title'=>$row['title'], 'context'=>$row['context'], 'status'=>$row['status'], 'date'=>$row['record_date'], 'url'=>'lost-items.php'];
    $stmt = $db->prepare("SELECT c.id, f.item_name AS title, f.category AS context, c.status, DATE(c.created_at) AS record_date FROM claims c JOIN found_items f ON f.id = c.found_item_id WHERE f.item_name LIKE ? OR f.category LIKE ? OR f.location_found LIKE ? OR c.status LIKE ? LIMIT 10"); $stmt->execute([$like, $like, $like, $like]);
} else {
    $stmt = $db->prepare("SELECT id, item_name AS title, category AS context, status, date_found AS record_date FROM found_items WHERE status = 'unclaimed' AND (item_name LIKE ? OR category LIKE ? OR location_found LIKE ?) LIMIT 10"); $stmt->execute([$like, $like, $like]);
    foreach ($stmt->fetchAll() as $row) $results[] = ['type'=>'found', 'id'=>(int)$row['id'], 'title'=>$row['title'], 'context'=>$row['context'], 'status'=>$row['status'], 'date'=>$row['record_date'], 'url'=>'claims.php'];
    $stmt = $db->prepare("SELECT id, item_name AS title, category AS context, status, date_lost AS record_date FROM lost_items WHERE reported_by = ? AND (item_name LIKE ? OR category LIKE ? OR last_seen_location LIKE ? OR description LIKE ?) LIMIT 10"); $stmt->execute([$session['user_id'], $like, $like, $like, $like]);
    foreach ($stmt->fetchAll() as $row) $results[] = ['type'=>'lost', 'id'=>(int)$row['id'], 'title'=>$row['title'], 'context'=>$row['context'], 'status'=>$row['status'], 'date'=>$row['record_date'], 'url'=>'lost-items.php'];
    $stmt = $db->prepare("SELECT c.id, f.item_name AS title, f.category AS context, c.status, DATE(c.created_at) AS record_date FROM claims c JOIN found_items f ON f.id = c.found_item_id WHERE c.claimant_id = ? AND (f.item_name LIKE ? OR f.category LIKE ? OR f.location_found LIKE ? OR c.status LIKE ?) LIMIT 10"); $stmt->execute([$session['user_id'], $like, $like, $like, $like]);
}
foreach ($stmt->fetchAll() as $row) $results[] = ['type'=>'claim', 'id'=>(int)$row['id'], 'title'=>$row['title'], 'context'=>$row['context'], 'status'=>$row['status'], 'date'=>$row['record_date'], 'url'=>'claims.php'];
json_out(['success' => true, 'results' => array_slice($results, 0, 20)]);
