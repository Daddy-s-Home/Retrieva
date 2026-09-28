<?php
declare(strict_types=1);

require_once __DIR__ . '/lib.php';

$session = admin_guard();
$actorId = (int) $session['user_id'];
$input = $_POST;
if ($input === [] && str_contains((string) ($_SERVER['CONTENT_TYPE'] ?? ''), 'application/json')) {
    $decoded = json_decode(file_get_contents('php://input') ?: '', true);
    $input = is_array($decoded) ? $decoded : [];
}
$token = (string) ($input['csrf_token'] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? ''));
if (!verify_csrf($token)) {
    admin_finish(false, 'Your session expired. Please try again.', 400, (string) ($input['redirect'] ?? ''));
}

$action = (string) ($input['action'] ?? '');
try {
    match ($action) {
        'update_lost' => admin_update_lost($actorId, $input),
        'delete_lost' => admin_delete_lost($actorId, $input),
        'create_found' => admin_create_found($actorId, $input),
        'update_found' => admin_update_found($actorId, $input),
        'delete_found' => admin_delete_found($actorId, $input),
        'refresh_matches' => admin_action_refresh($actorId, $input),
        'confirm_match' => admin_confirm_match($actorId, $input),
        'reject_match' => admin_reject_match($actorId, $input),
        'notify_match' => admin_notify_match($actorId, $input),
        'approve_claim' => admin_review_claim($actorId, $input, 'approved'),
        'reject_claim' => admin_review_claim($actorId, $input, 'rejected'),
        'request_claim_info' => admin_request_claim($actorId, $input),
        'confirm_pickup' => admin_confirm_pickup($actorId, $input),
        'report_return_issue' => admin_return_issue($actorId, $input),
        'create_user' => admin_create_user($actorId, $input),
        'update_user' => admin_update_user($actorId, $input),
        'reset_user_password' => admin_reset_password($actorId, $input),
        default => throw new InvalidArgumentException('That action is not available.'),
    };
} catch (InvalidArgumentException | RuntimeException $e) {
    if (get_db()->inTransaction()) {
        get_db()->rollBack();
    }
    admin_finish(false, $e->getMessage(), 400, (string) ($input['redirect'] ?? ''));
} catch (Throwable $e) {
    if (get_db()->inTransaction()) {
        get_db()->rollBack();
    }
    admin_finish(false, 'The change could not be saved. Please try again.', 500, (string) ($input['redirect'] ?? ''));
}

function admin_finish(bool $success, string $message, int $code, string $redirect): void {
    $target = admin_safe_redirect($redirect);
    $wantsJson = ($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '') === 'fetch'
        || str_contains((string) ($_SERVER['HTTP_ACCEPT'] ?? ''), 'application/json');
    if ($wantsJson) {
        json_out(['success' => $success, 'message' => $message, 'redirect' => $target], $success ? 200 : $code);
    }
    if (!$success) {
        $_SESSION['admin_flash'] = $message;
    }
    header('Location: ../../dashboard/' . $target);
    exit;
}

function admin_safe_redirect(string $value): string {
    $hash = '';
    if (str_contains($value, '#')) {
        [$value, $hashPart] = explode('#', $value, 2);
        $hash = '#' . preg_replace('/[^a-z0-9_-]/i', '', $hashPart);
    }
    $query = '';
    if (str_contains($value, '?')) {
        [$value, $queryString] = explode('?', $value, 2);
        parse_str($queryString, $params);
        $clean = [];
        foreach (['page', 'q', 'tab', 'category', 'status', 'token'] as $key) {
            if (isset($params[$key]) && is_string($params[$key]) && strlen($params[$key]) <= 80) {
                $clean[$key] = $params[$key];
            }
        }
        if ($clean) {
            $query = '?' . http_build_query($clean);
        }
    }
    $file = basename(str_replace('\\', '/', $value));
    if (!in_array($file, array_values(ADMIN_PAGES), true)) {
        $file = 'index.php';
    }
    return $file . $query . $hash;
}

function admin_id(array $input, string $key): int {
    $id = filter_var($input[$key] ?? null, FILTER_VALIDATE_INT);
    if (!$id || $id < 1) {
        throw new InvalidArgumentException('Choose a valid record.');
    }
    return (int) $id;
}

function admin_item_fields(array $input, string $dateKey): array {
    $name = trim((string) ($input['item_name'] ?? ''));
    $category = (string) ($input['category'] ?? '');
    $location = trim((string) ($input['location'] ?? ''));
    $dateValue = (string) ($input[$dateKey] ?? '');
    $date = DateTime::createFromFormat('Y-m-d', $dateValue);
    $validDate = $date instanceof DateTime && $date->format('Y-m-d') === $dateValue && $dateValue <= date('Y-m-d');
    if ($name === '' || strlen($name) > 150 || $location === '' || strlen($location) > 150 || !in_array($category, CLIENT_CATEGORIES, true) || !$validDate) {
        throw new InvalidArgumentException('Enter a valid item, category, location, and date.');
    }
    return [$name, $category, $location, $dateValue];
}

function admin_update_lost(int $actorId, array $input): void {
    $id = admin_id($input, 'lost_id');
    [$name, $category, $location, $dateLost] = admin_item_fields($input, 'date_lost');
    $description = trim((string) ($input['description'] ?? ''));
    $status = (string) ($input['status'] ?? '');
    $reason = trim((string) ($input['closed_reason'] ?? ''));
    if (!in_array($status, CLIENT_LOST_STATUSES, true) || strlen($description) > 1000 || strlen($reason) > 255) {
        throw new InvalidArgumentException('Enter a valid report status.');
    }
    $stmt = get_db()->prepare(
        'UPDATE lost_items SET item_name = ?, category = ?, last_seen_location = ?, date_lost = ?, description = ?, status = ?, closed_reason = ?,
            closed_at = CASE WHEN ? = \'closed\' THEN COALESCE(closed_at, NOW()) ELSE closed_at END,
            resolved_at = CASE WHEN ? = \'resolved\' THEN COALESCE(resolved_at, NOW()) ELSE resolved_at END,
            matched_at = CASE WHEN ? = \'matched\' THEN COALESCE(matched_at, NOW()) ELSE matched_at END
         WHERE id = ?'
    );
    $stmt->execute([$name, $category, $location, $dateLost, $description !== '' ? $description : null, $status, $reason !== '' ? $reason : null, $status, $status, $status, $id]);
    retrieva_save_photos('lost', $id, $input);
    log_audit($actorId, 'lost_report_updated', "lost={$id} status={$status}");
    admin_finish(true, 'Lost report updated.', 200, (string) ($input['redirect'] ?? 'admin-lost-reports.php'));
}

function admin_delete_lost(int $actorId, array $input): void {
    $id = admin_id($input, 'lost_id');
    if (client_count('SELECT COUNT(*) FROM claims WHERE lost_item_id = ?', [$id]) > 0) {
        throw new RuntimeException('This report has a claim and cannot be deleted.');
    }
    $stmt = get_db()->prepare('DELETE FROM item_matches WHERE lost_item_id = ?');
    $stmt->execute([$id]);
    retrieva_delete_photos('lost', $id);
    $stmt = get_db()->prepare('DELETE FROM lost_items WHERE id = ?');
    $stmt->execute([$id]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('The report was not found.');
    }
    log_audit($actorId, 'lost_report_deleted', "lost={$id}");
    admin_finish(true, 'Lost report deleted.', 200, (string) ($input['redirect'] ?? 'admin-lost-reports.php'));
}

function admin_create_found(int $actorId, array $input): void {
    [$name, $category, $location, $dateFound] = admin_item_fields($input, 'date_found');
    $summary = trim((string) ($input['public_summary'] ?? ''));
    if (strlen($summary) > 500) {
        throw new InvalidArgumentException('The public summary is too long.');
    }
    $db = get_db();
    $stmt = $db->prepare(
        'INSERT INTO found_items (logged_by, item_name, category, location_found, date_found, public_summary, photo_path) VALUES (?, ?, ?, ?, ?, ?, NULL)'
    );
    $stmt->execute([$actorId, $name, $category, $location, $dateFound, $summary !== '' ? $summary : null]);
    $foundId = (int) $db->lastInsertId();
    try {
        retrieva_save_photos('found', $foundId, $input);
    } catch (Throwable $photoError) {
        retrieva_delete_photos('found', $foundId);
        $db->prepare('DELETE FROM found_items WHERE id = ?')->execute([$foundId]);
        throw $photoError;
    }
    assign_public_code('found_items', $foundId);
    log_audit($actorId, 'found_item_logged', $name);
    admin_finish(true, 'Found item logged.', 200, 'admin-found-items.php');
}

function admin_update_found(int $actorId, array $input): void {
    $id = admin_id($input, 'found_id');
    [$name, $category, $location, $dateFound] = admin_item_fields($input, 'date_found');
    $status = (string) ($input['status'] ?? '');
    $summary = trim((string) ($input['public_summary'] ?? ''));
    if (!in_array($status, ADMIN_FOUND_STATUSES, true) || strlen($summary) > 500) {
        throw new InvalidArgumentException('Enter a valid found-item status.');
    }
    $stmt = get_db()->prepare('UPDATE found_items SET item_name = ?, category = ?, location_found = ?, date_found = ?, status = ?, public_summary = ? WHERE id = ?');
    $stmt->execute([$name, $category, $location, $dateFound, $status, $summary !== '' ? $summary : null, $id]);
    retrieva_save_photos('found', $id, $input);
    log_audit($actorId, 'found_item_updated', "found={$id} status={$status}");
    admin_finish(true, 'Found item updated.', 200, (string) ($input['redirect'] ?? 'admin-found-items.php'));
}

function admin_delete_found(int $actorId, array $input): void {
    $id = admin_id($input, 'found_id');
    if (client_count('SELECT COUNT(*) FROM claims WHERE found_item_id = ?', [$id]) > 0) {
        throw new RuntimeException('This item has a claim and cannot be deleted.');
    }
    $stmt = get_db()->prepare('DELETE FROM item_matches WHERE found_item_id = ?');
    $stmt->execute([$id]);
    retrieva_delete_photos('found', $id);
    $stmt = get_db()->prepare('DELETE FROM found_items WHERE id = ?');
    $stmt->execute([$id]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('The item was not found.');
    }
    log_audit($actorId, 'found_item_deleted', "found={$id}");
    admin_finish(true, 'Found item deleted.', 200, 'admin-found-items.php');
}

function admin_action_refresh(int $actorId, array $input): void {
    $count = admin_refresh_matches($actorId);
    admin_finish(true, $count > 0 ? 'Suggestions updated.' : 'No new suggestions were found.', 200, 'admin-matching.php');
}

function admin_match_row(int $id): array {
    $rows = admin_rows(
        'SELECT m.*, l.reported_by, l.item_name AS lost_name, f.item_name AS found_name, f.status AS found_status
         FROM item_matches m
         INNER JOIN lost_items l ON l.id = m.lost_item_id
         INNER JOIN found_items f ON f.id = m.found_item_id
         WHERE m.id = ?',
        [$id]
    );
    if (!$rows) {
        throw new RuntimeException('That suggestion was not found.');
    }
    return $rows[0];
}

function admin_confirm_match(int $actorId, array $input): void {
    $id = admin_id($input, 'match_id');
    $row = admin_match_row($id);
    if (!in_array($row['found_status'], ['unclaimed', 'pending_verification'], true)) {
        throw new RuntimeException('That found item is no longer available to match.');
    }
    $db = get_db();
    $db->beginTransaction();
    $stmt = $db->prepare("UPDATE item_matches SET status = 'confirmed', reviewed_by = ? WHERE id = ? AND status IN ('potential', 'needs_review')");
    $stmt->execute([$actorId, $id]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('That suggestion was already reviewed.');
    }
    $stmt = $db->prepare("UPDATE lost_items SET status = 'matched', matched_found_item_id = ?, matched_at = COALESCE(matched_at, NOW()) WHERE id = ?");
    $stmt->execute([(int) $row['found_item_id'], (int) $row['lost_item_id']]);
    $db->commit();
    log_audit($actorId, 'match_confirmed', "match={$id}");
    admin_finish(true, 'Match confirmed.', 200, 'admin-matching.php');
}

function admin_reject_match(int $actorId, array $input): void {
    $id = admin_id($input, 'match_id');
    $stmt = get_db()->prepare("UPDATE item_matches SET status = 'no_match', reviewed_by = ? WHERE id = ? AND status IN ('potential', 'needs_review')");
    $stmt->execute([$actorId, $id]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('That suggestion was already reviewed.');
    }
    log_audit($actorId, 'match_rejected', "match={$id}");
    admin_finish(true, 'Marked as no match.', 200, 'admin-matching.php');
}

function admin_notify_match(int $actorId, array $input): void {
    $id = admin_id($input, 'match_id');
    $row = admin_match_row($id);
    client_notify(
        (int) $row['reported_by'],
        'match',
        'A possible match was found',
        'Security found a possible match for "' . $row['lost_name'] . '".',
        'lost',
        (int) $row['lost_item_id']
    );
    log_audit($actorId, 'match_notified', "match={$id}");
    admin_finish(true, 'The reporter was notified.', 200, 'admin-matching.php');
}

function admin_review_claim(int $actorId, array $input, string $status): void {
    $id = admin_id($input, 'claim_id');
    $reason = trim((string) ($input['rejection_reason'] ?? ''));
    if ($status === 'rejected' && ($reason === '' || strlen($reason) > 500)) {
        throw new InvalidArgumentException('Enter a reason for the rejection.');
    }
    $db = get_db();
    $db->beginTransaction();
    $stmt = $db->prepare("SELECT id, found_item_id, claimant_id, lost_item_id FROM claims WHERE id = ? AND status IN ('pending', 'manual_review') FOR UPDATE");
    $stmt->execute([$id]);
    $claim = $stmt->fetch();
    if (!$claim) {
        throw new RuntimeException('This claim has already been reviewed.');
    }
    $stmt = $db->prepare('UPDATE claims SET status = ?, rejection_reason = ?, reviewed_by = ?, reviewed_at = NOW() WHERE id = ?');
    $stmt->execute([$status, $status === 'rejected' ? $reason : null, $actorId, $id]);
    if ($status === 'approved') {
        $stmt = $db->prepare("UPDATE found_items SET status = 'claimed' WHERE id = ?");
        $stmt->execute([(int) $claim['found_item_id']]);
        if (!empty($claim['lost_item_id'])) {
            $stmt = $db->prepare('UPDATE lost_items SET verified_at = COALESCE(verified_at, NOW()) WHERE id = ?');
            $stmt->execute([(int) $claim['lost_item_id']]);
        }
        if (client_count('SELECT COUNT(*) FROM pickups WHERE claim_id = ?', [$id]) === 0) {
            $token = bin2hex(random_bytes(16));
            $stmt = $db->prepare("INSERT INTO pickups (claim_id, qr_token, status) VALUES (?, ?, 'pending')");
            $stmt->execute([$id, $token]);
        }
        client_notify((int) $claim['claimant_id'], 'claim', 'Your claim was approved', 'Bring your pickup code to the security office.', 'claim', $id);
    } else {
        $others = client_count("SELECT COUNT(*) FROM claims WHERE found_item_id = ? AND id <> ? AND status IN ('pending', 'manual_review', 'approved')", [(int) $claim['found_item_id'], $id]);
        if ($others === 0) {
            $stmt = $db->prepare("UPDATE found_items SET status = 'unclaimed' WHERE id = ? AND status = 'pending_verification'");
            $stmt->execute([(int) $claim['found_item_id']]);
        }
        client_notify((int) $claim['claimant_id'], 'claim', 'Your claim was not approved', $reason, 'claim', $id);
    }
    $db->commit();
    log_audit($actorId, 'claim_' . $status, "claim={$id}");
    admin_finish(true, $status === 'approved' ? 'Claim approved.' : 'Claim rejected.', 200, (string) ($input['redirect'] ?? 'admin-claims.php'));
}

function admin_request_claim(int $actorId, array $input): void {
    $id = admin_id($input, 'claim_id');
    $stmt = get_db()->prepare("UPDATE claims SET status = 'manual_review' WHERE id = ? AND status = 'pending'");
    $stmt->execute([$id]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('Only a pending claim can be sent back for more information.');
    }
    $claim = admin_rows('SELECT claimant_id FROM claims WHERE id = ?', [$id])[0];
    client_notify((int) $claim['claimant_id'], 'claim', 'More information is needed', 'Security asked for more information about your claim.', 'claim', $id);
    log_audit($actorId, 'claim_information_requested', "claim={$id}");
    admin_finish(true, 'Information requested.', 200, 'admin-claims.php');
}

function admin_confirm_pickup(int $actorId, array $input): void {
    $token = substr(preg_replace('/[^a-f0-9]/i', '', (string) ($input['token'] ?? '')) ?? '', 0, 64);
    if ($token === '') {
        throw new InvalidArgumentException('Enter the pickup code.');
    }
    $db = get_db();
    $db->beginTransaction();
    $stmt = $db->prepare("SELECT p.id, p.claim_id, c.found_item_id, c.lost_item_id, c.claimant_id FROM pickups p INNER JOIN claims c ON c.id = p.claim_id WHERE p.qr_token = ? AND p.status = 'pending' FOR UPDATE");
    $stmt->execute([$token]);
    $pickup = $stmt->fetch();
    if (!$pickup) {
        throw new RuntimeException('That pickup code is not waiting for verification.');
    }
    $returnCode = 'RT-' . date('Y') . '-' . str_pad((string) $pickup['id'], 3, '0', STR_PAD_LEFT);
    $stmt = $db->prepare("UPDATE pickups SET status = 'verified', scanned_at = NOW(), verified_by = ?, return_code = ? WHERE id = ? AND status = 'pending'");
    $stmt->execute([$actorId, $returnCode, (int) $pickup['id']]);
    $stmt = $db->prepare("UPDATE found_items SET status = 'returned' WHERE id = ?");
    $stmt->execute([(int) $pickup['found_item_id']]);
    if (!empty($pickup['lost_item_id'])) {
        $stmt = $db->prepare("UPDATE lost_items SET status = 'resolved', resolved_at = COALESCE(resolved_at, NOW()) WHERE id = ?");
        $stmt->execute([(int) $pickup['lost_item_id']]);
    }
    $db->commit();
    client_notify((int) $pickup['claimant_id'], 'claim', 'Your item was returned', 'The security office confirmed your pickup.', 'claim', (int) $pickup['claim_id']);
    log_audit($actorId, 'pickup_verified', "pickup={$pickup['id']}");
    admin_finish(true, 'Pickup confirmed. The item is marked returned.', 200, 'admin-returned.php');
}

function admin_return_issue(int $actorId, array $input): void {
    $id = admin_id($input, 'pickup_id');
    $note = trim((string) ($input['condition_note'] ?? ''));
    if ($note === '' || strlen($note) > 255) {
        throw new InvalidArgumentException('Describe the issue in 255 characters or fewer.');
    }
    $stmt = get_db()->prepare('UPDATE pickups SET condition_note = ? WHERE id = ?');
    $stmt->execute([$note, $id]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('That return record was not found.');
    }
    log_audit($actorId, 'return_issue_reported', "pickup={$id}");
    admin_finish(true, 'Issue recorded.', 200, 'admin-returned.php');
}

function admin_user_input(array $input, bool $requirePassword): array {
    $name = trim((string) ($input['full_name'] ?? ''));
    $email = strtolower(trim((string) ($input['email'] ?? '')));
    $role = (string) ($input['role'] ?? '');
    $status = (string) ($input['status'] ?? 'active');
    $studentId = trim((string) ($input['student_id'] ?? ''));
    $program = trim((string) ($input['program_department'] ?? ''));
    $password = (string) ($input['password'] ?? '');
    if ($name === '' || strlen($name) > 150 || !filter_var($email, FILTER_VALIDATE_EMAIL) || !str_ends_with($email, '@umak.edu.ph')) {
        throw new InvalidArgumentException('Enter a name and a UMak email address.');
    }
    if (!in_array($role, ADMIN_ROLES, true) || !in_array($status, ADMIN_USER_STATUSES, true)) {
        throw new InvalidArgumentException('Choose a valid role and status.');
    }
    if (strlen($studentId) > 30 || strlen($program) > 150) {
        throw new InvalidArgumentException('Student ID or program is too long.');
    }
    if ($requirePassword && strlen($password) < 8) {
        throw new InvalidArgumentException('Password must be at least 8 characters.');
    }
    return [$name, $email, $role, $status, $studentId !== '' ? $studentId : null, $program !== '' ? $program : null, $password];
}

function admin_assert_admin_remains(int $userId, string $role, string $status): void {
    $current = admin_rows('SELECT role, status FROM users WHERE id = ?', [$userId]);
    if (!$current) {
        throw new RuntimeException('That account was not found.');
    }
    $isActiveAdmin = $current[0]['role'] === 'admin' && $current[0]['status'] === 'active';
    $staysActiveAdmin = $role === 'admin' && $status === 'active';
    if ($isActiveAdmin && !$staysActiveAdmin && client_count("SELECT COUNT(*) FROM users WHERE role = 'admin' AND status = 'active' AND id <> ?", [$userId]) === 0) {
        throw new RuntimeException('The last active admin cannot be changed.');
    }
}

function admin_create_user(int $actorId, array $input): void {
    [$name, $email, $role, $status, $studentId, $program, $password] = admin_user_input($input, true);
    if (client_count('SELECT COUNT(*) FROM users WHERE email = ?', [$email]) > 0) {
        throw new RuntimeException('That email is already registered.');
    }
    if ($studentId !== null && client_count('SELECT COUNT(*) FROM users WHERE student_id = ?', [$studentId]) > 0) {
        throw new RuntimeException('That student ID is already registered.');
    }
    $stmt = get_db()->prepare(
        'INSERT INTO users (email, full_name, password_hash, password_is_set, role, auth_provider, student_id, program_department, email_verified, status)
         VALUES (?, ?, ?, 1, ?, \'local\', ?, ?, 1, ?)'
    );
    $stmt->execute([$email, $name, password_hash($password, PASSWORD_DEFAULT), $role, $studentId, $program, $status]);
    log_audit($actorId, 'user_created', $email);
    admin_finish(true, 'Account created.', 200, 'admin-users.php');
}

function admin_update_user(int $actorId, array $input): void {
    $id = admin_id($input, 'user_id');
    [$name, $email, $role, $status, $studentId, $program] = admin_user_input($input, false);
    if ($id === $actorId && $status === 'blocked') {
        throw new RuntimeException('You cannot block the account you are using.');
    }
    admin_assert_admin_remains($id, $role, $status);
    if (client_count('SELECT COUNT(*) FROM users WHERE email = ? AND id <> ?', [$email, $id]) > 0) {
        throw new RuntimeException('That email is already registered.');
    }
    if ($studentId !== null && client_count('SELECT COUNT(*) FROM users WHERE student_id = ? AND id <> ?', [$studentId, $id]) > 0) {
        throw new RuntimeException('That student ID is already registered.');
    }
    $stmt = get_db()->prepare('UPDATE users SET full_name = ?, email = ?, role = ?, status = ?, student_id = ?, program_department = ? WHERE id = ?');
    $stmt->execute([$name, $email, $role, $status, $studentId, $program, $id]);
    log_audit($actorId, 'user_updated', "user={$id}");
    admin_finish(true, 'Account updated.', 200, 'admin-users.php');
}

function admin_reset_password(int $actorId, array $input): void {
    $id = filter_var($input['user_id'] ?? null, FILTER_VALIDATE_INT);
    if ($id === false || $id < 0) {
        throw new InvalidArgumentException('Choose a valid record.');
    }
    $id = (int) $id;
    $password = (string) ($input['password'] ?? '');
    $confirm = (string) ($input['confirm_password'] ?? '');
    if (strlen($password) < 8 || $password !== $confirm) {
        throw new InvalidArgumentException('Enter a new password of at least 8 characters and confirm it.');
    }
    $lookup = get_db()->prepare('SELECT full_name FROM users WHERE id = ?');
    $lookup->execute([$id]);
    $fullName = trim((string) $lookup->fetchColumn());
    if ($fullName === '') {
        throw new RuntimeException('That account was not found.');
    }
    $stmt = get_db()->prepare('UPDATE users SET password_hash = ?, password_is_set = 1, failed_attempts = 0, lockout_until = NULL WHERE id = ?');
    $stmt->execute([password_hash($password, PASSWORD_DEFAULT), $id]);
    log_audit($actorId, 'user_password_reset', 'Password changed for user ' . $fullName);
    admin_finish(true, 'Password reset.', 200, 'admin-users.php');
}
