<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';

$session = require_login();
header('Content-Type: application/json');

$input     = json_decode(file_get_contents('php://input'), true) ?? [];
$studentId = trim((string)($input['student_id'] ?? ''));

if ($session['role'] !== 'student') {
    json_out(['success' => false, 'message' => 'Student ID only applies to student accounts.'], 403);
}
if (!preg_match('/^[A-Za-z0-9\-]{4,20}$/', $studentId)) {
    json_out(['success' => false, 'message' => 'Enter a valid student ID.'], 400);
}

$db = get_db();

// Uniqueness check first so we can return a friendly message.
$check = $db->prepare('SELECT id FROM users WHERE student_id = ? AND id != ?');
$check->execute([$studentId, $session['user_id']]);
if ($check->fetch()) {
    json_out(['success' => false, 'message' => 'That student ID is already on file.'], 409);
}

$stmt = $db->prepare('UPDATE users SET student_id = ? WHERE id = ?');
$stmt->execute([$studentId, $session['user_id']]);

log_audit((int)$session['user_id'], 'student_id_set', "Student ID recorded: {$studentId}");

json_out(['success' => true, 'message' => 'Student ID saved.']);
