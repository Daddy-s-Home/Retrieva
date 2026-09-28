<?php
declare(strict_types=1);

require_once __DIR__ . '/lib.php';

$session = client_guard();
$userId = (int) $session['user_id'];
$input = $_POST;
if ($input === [] && str_contains((string) ($_SERVER['CONTENT_TYPE'] ?? ''), 'application/json')) {
    $decoded = json_decode(file_get_contents('php://input') ?: '', true);
    $input = is_array($decoded) ? $decoded : [];
}
$token = (string) ($input['csrf_token'] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? ''));
if (!verify_csrf($token)) {
    client_finish(false, 'Your session expired. Please try again.', 400, (string) ($input['redirect'] ?? ''));
}

$action = (string) ($input['action'] ?? '');
try {
    match ($action) {
        'create_report' => client_action_create_report($userId, $input),
        'update_report' => client_action_update_report($userId, $input),
        'delete_report' => client_action_delete_report($userId, $input),
        'toggle_save' => client_action_toggle_save($userId, $input),
        'create_claim' => client_action_create_claim($userId, $input),
        'withdraw_claim' => client_action_withdraw_claim($userId, $input),
        'mark_read' => client_action_mark_read($userId, $input),
        'mark_all_read' => client_action_mark_all($userId),
        'update_profile' => client_action_profile($userId, $input),
        'update_notifications' => client_action_notifications($userId, $input),
        'update_privacy' => client_action_privacy($userId, $input),
        'update_login_method' => client_action_login_method($userId, $input),
        default => throw new InvalidArgumentException('That action is not available.'),
    };
} catch (InvalidArgumentException | RuntimeException $e) {
    if (get_db()->inTransaction()) {
        get_db()->rollBack();
    }
    client_finish(false, $e->getMessage(), 400, (string) ($input['redirect'] ?? ''));
} catch (Throwable $e) {
    if (get_db()->inTransaction()) {
        get_db()->rollBack();
    }
    client_finish(false, 'The change could not be saved. Please try again.', 500, (string) ($input['redirect'] ?? ''));
}

function client_finish(bool $success, string $message, int $code, string $redirect): void {
    $target = client_safe_redirect($redirect);
    $wantsJson = ($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '') === 'fetch'
        || str_contains((string) ($_SERVER['HTTP_ACCEPT'] ?? ''), 'application/json');
    if ($wantsJson) {
        json_out(['success' => $success, 'message' => $message, 'redirect' => $target], $success ? 200 : $code);
    }
    if (!$success) {
        $_SESSION['client_flash'] = $message;
    }
    header('Location: ../../dashboard/' . $target);
    exit;
}

function client_safe_redirect(string $value): string {
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
        foreach (['page', 'q', 'tab', 'category', 'location', 'status', 'sort', 'start', 'end', 'dates', 'open'] as $key) {
            if (isset($params[$key]) && is_string($params[$key]) && strlen($params[$key]) <= 80) {
                $clean[$key] = $params[$key];
            }
        }
        if ($clean) {
            $query = '?' . http_build_query($clean);
        }
    }
    $file = basename(str_replace('\\', '/', $value));
    if (!in_array($file, array_values(CLIENT_PAGES), true)) {
        $file = 'client-dashboard.php';
    }
    return $file . $query . $hash;
}

function client_store_photo(array $file): ?string {
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
    $dir = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'lost';
    if (!is_dir($dir) && !mkdir($dir, 0755, true) && !is_dir($dir)) {
        throw new RuntimeException('Photo storage is unavailable.');
    }
    $name = 'lost_' . bin2hex(random_bytes(8)) . '.' . $ext;
    if (!move_uploaded_file((string) $file['tmp_name'], $dir . DIRECTORY_SEPARATOR . $name)) {
        throw new RuntimeException('The photo could not be saved.');
    }
    return 'uploads/lost/' . $name;
}

function client_report_input(array $input): array {
    $name = trim((string) ($input['item_name'] ?? ''));
    $category = (string) ($input['category'] ?? '');
    $location = trim((string) ($input['last_seen_location'] ?? ''));
    $dateLost = (string) ($input['date_lost'] ?? '');
    $description = trim((string) ($input['description'] ?? ''));
    $date = DateTime::createFromFormat('Y-m-d', $dateLost);
    $validDate = $date instanceof DateTime && $date->format('Y-m-d') === $dateLost && $dateLost <= date('Y-m-d');
    if ($name === '' || strlen($name) > 150 || strlen($location) > 150 || strlen($description) > 1000 || !in_array($category, CLIENT_CATEGORIES, true) || !$validDate) {
        throw new InvalidArgumentException('Enter a valid item, category, date, and description.');
    }
    return [$name, $category, $location !== '' ? $location : null, $dateLost, $description !== '' ? $description : null];
}

function client_action_create_report(int $userId, array $input): void {
    [$name, $category, $location, $dateLost, $description] = client_report_input($input);
    $share = client_count('SELECT share_lost_reports FROM users WHERE id = ?', [$userId]);
    $db = get_db();
    $stmt = $db->prepare('INSERT INTO lost_items (reported_by, item_name, category, last_seen_location, date_lost, description, photo_path, is_public) VALUES (?, ?, ?, ?, ?, ?, NULL, ?)');
    $stmt->execute([$userId, $name, $category, $location, $dateLost, $description, $share === 1 ? 1 : 0]);
    $id = (int) $db->lastInsertId();
    try {
        retrieva_save_photos('lost', $id, $input);
    } catch (Throwable $photoError) {
        retrieva_delete_photos('lost', $id);
        $db->prepare('DELETE FROM lost_items WHERE id = ?')->execute([$id]);
        throw $photoError;
    }
    assign_public_code('lost_items', $id);
    client_notify($userId, 'report', 'Your lost report has been submitted', 'Your report for "' . $name . '" has been submitted.', 'lost', $id);
    log_audit($userId, 'lost_item_reported', $name);
    client_finish(true, 'Lost item report submitted.', 200, 'client-my-reports.php');
}

function client_action_update_report(int $userId, array $input): void {
    $id = filter_var($input['item_id'] ?? null, FILTER_VALIDATE_INT);
    if (!$id) {
        throw new InvalidArgumentException('Invalid report.');
    }
    [$name, $category, $location, $dateLost, $description] = client_report_input($input);
    $db = get_db();
    $owns = $db->prepare("SELECT COUNT(*) FROM lost_items WHERE id = ? AND reported_by = ? AND status = 'searching'");
    $owns->execute([$id, $userId]);
    if ((int) $owns->fetchColumn() !== 1) {
        throw new RuntimeException('That report cannot be edited.');
    }
    $stmt = $db->prepare("UPDATE lost_items SET item_name = ?, category = ?, last_seen_location = ?, date_lost = ?, description = ? WHERE id = ? AND reported_by = ? AND status = 'searching'");
    $stmt->execute([$name, $category, $location, $dateLost, $description, $id, $userId]);
    retrieva_save_photos('lost', $id, $input);
    log_audit($userId, 'lost_item_updated', "item={$id}");
    client_finish(true, 'Report updated.', 200, (string) ($input['redirect'] ?? 'client-my-reports.php'));
}

function client_action_delete_report(int $userId, array $input): void {
    $id = filter_var($input['item_id'] ?? null, FILTER_VALIDATE_INT);
    if (!$id) {
        throw new InvalidArgumentException('Invalid report.');
    }
    $owns = get_db()->prepare("SELECT COUNT(*) FROM lost_items WHERE id = ? AND reported_by = ? AND status = 'searching'");
    $owns->execute([$id, $userId]);
    if ((int) $owns->fetchColumn() !== 1) {
        throw new RuntimeException('That report cannot be deleted.');
    }
    retrieva_delete_photos('lost', $id);
    $stmt = get_db()->prepare("DELETE FROM lost_items WHERE id = ? AND reported_by = ? AND status = 'searching'");
    $stmt->execute([$id, $userId]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('That report cannot be deleted.');
    }
    log_audit($userId, 'lost_item_deleted', "item={$id}");
    client_finish(true, 'Lost item report removed.', 200, 'client-my-reports.php');
}

function client_action_toggle_save(int $userId, array $input): void {
    $type = (string) ($input['entity_type'] ?? '');
    $id = filter_var($input['entity_id'] ?? null, FILTER_VALIDATE_INT);
    if (!$id || !in_array($type, ['lost', 'found'], true)) {
        throw new InvalidArgumentException('Invalid item.');
    }
    if ($type === 'lost') {
        $visible = client_count('SELECT COUNT(*) FROM lost_items WHERE id = ? AND (is_public = 1 OR reported_by = ?)', [$id, $userId]);
    } else {
        $visible = client_count("SELECT COUNT(*) FROM found_items WHERE id = ? AND status <> 'disposed'", [$id]);
    }
    if ($visible !== 1) {
        throw new RuntimeException('That item is not available.');
    }
    $db = get_db();
    $existing = $db->prepare('SELECT id FROM saved_items WHERE user_id = ? AND entity_type = ? AND entity_id = ?');
    $existing->execute([$userId, $type, $id]);
    if ($existing->fetch()) {
        $db->prepare('DELETE FROM saved_items WHERE user_id = ? AND entity_type = ? AND entity_id = ?')->execute([$userId, $type, $id]);
        $message = 'Removed from saved items.';
    } else {
        $db->prepare('INSERT INTO saved_items (user_id, entity_type, entity_id) VALUES (?, ?, ?)')->execute([$userId, $type, $id]);
        $message = 'Saved.';
    }
    client_finish(true, $message, 200, (string) ($input['redirect'] ?? 'client-dashboard.php'));
}

function client_action_create_claim(int $userId, array $input): void {
    $itemId = filter_var($input['found_item_id'] ?? null, FILTER_VALIDATE_INT);
    $answer = trim((string) ($input['answer'] ?? ''));
    $lostId = filter_var($input['lost_item_id'] ?? null, FILTER_VALIDATE_INT);
    if (!$itemId || $answer === '' || strlen($answer) > 1000) {
        throw new InvalidArgumentException('Enter a valid identifying detail.');
    }
    $db = get_db();
    $db->beginTransaction();
    $existing = $db->prepare("SELECT COUNT(*) FROM claims WHERE found_item_id = ? AND status IN ('pending', 'manual_review', 'approved')");
    $existing->execute([$itemId]);
    if ((int) $existing->fetchColumn() > 0) {
        throw new RuntimeException('That item already has an active claim.');
    }
    if ($lostId) {
        $owns = $db->prepare('SELECT COUNT(*) FROM lost_items WHERE id = ? AND reported_by = ?');
        $owns->execute([$lostId, $userId]);
        if ((int) $owns->fetchColumn() !== 1) {
            throw new InvalidArgumentException('Choose one of your own reports.');
        }
    } else {
        $lostId = null;
    }
    $lock = $db->prepare("UPDATE found_items SET status = 'pending_verification' WHERE id = ? AND status = 'unclaimed'");
    $lock->execute([$itemId]);
    if ($lock->rowCount() !== 1) {
        throw new RuntimeException('That item is no longer available to claim.');
    }
    $stmt = $db->prepare("INSERT INTO claims (found_item_id, claimant_id, lost_item_id, challenge_questions, claimant_answers, status) VALUES (?, ?, ?, ?, ?, 'pending')");
    $stmt->execute([$itemId, $userId, $lostId, json_encode(['Describe an identifying detail about this item.']), json_encode([$answer])]);
    $claimId = (int) $db->lastInsertId();
    assign_public_code('claims', $claimId);
    $item = $db->prepare('SELECT item_name FROM found_items WHERE id = ?');
    $item->execute([$itemId]);
    $itemName = (string) ($item->fetchColumn() ?: 'item');
    client_notify($userId, 'claim', 'Your claim is under review', 'Your claim for "' . $itemName . '" is waiting for security verification.', 'claim', $claimId);
    $db->commit();
    log_audit($userId, 'claim_filed', "found_item={$itemId}");
    client_finish(true, 'Your claim was submitted for review.', 200, 'client-my-claims.php');
}

function client_action_withdraw_claim(int $userId, array $input): void {
    $id = filter_var($input['claim_id'] ?? null, FILTER_VALIDATE_INT);
    if (!$id) {
        throw new InvalidArgumentException('Invalid claim.');
    }
    $db = get_db();
    $db->beginTransaction();
    $stmt = $db->prepare("SELECT found_item_id FROM claims WHERE id = ? AND claimant_id = ? AND status IN ('pending','manual_review') FOR UPDATE");
    $stmt->execute([$id, $userId]);
    $claim = $stmt->fetch();
    if (!$claim) {
        throw new RuntimeException('Only a pending claim can be withdrawn.');
    }
    $foundId = (int) $claim['found_item_id'];
    $delete = $db->prepare('DELETE FROM claims WHERE id = ? AND claimant_id = ? AND status IN (\'pending\',\'manual_review\')');
    $delete->execute([$id, $userId]);
    if ($delete->rowCount() !== 1) {
        throw new RuntimeException('That claim could not be withdrawn.');
    }
    $others = $db->prepare("SELECT COUNT(*) FROM claims WHERE found_item_id = ? AND status IN ('pending','manual_review','approved')");
    $others->execute([$foundId]);
    if ((int) $others->fetchColumn() === 0) {
        $db->prepare("UPDATE found_items SET status = 'unclaimed' WHERE id = ? AND status = 'pending_verification'")->execute([$foundId]);
    }
    $db->commit();
    log_audit($userId, 'claim_withdrawn', "claim={$id}");
    client_finish(true, 'Claim withdrawn.', 200, 'client-my-claims.php');
}

function client_action_mark_read(int $userId, array $input): void {
    $id = filter_var($input['notification_id'] ?? null, FILTER_VALIDATE_INT);
    if (!$id) {
        throw new InvalidArgumentException('Invalid notification.');
    }
    $stmt = get_db()->prepare('UPDATE notifications SET read_at = NOW() WHERE id = ? AND user_id = ? AND read_at IS NULL');
    $stmt->execute([$id, $userId]);
    client_finish(true, 'Notification marked as read.', 200, (string) ($input['redirect'] ?? 'client-notifications.php'));
}

function client_action_mark_all(int $userId): void {
    get_db()->prepare('UPDATE notifications SET read_at = NOW() WHERE user_id = ? AND read_at IS NULL')->execute([$userId]);
    log_audit($userId, 'notifications_read', 'Marked all notifications read.');
    client_finish(true, 'All notifications marked as read.', 200, 'client-notifications.php');
}

function client_action_profile(int $userId, array $input): void {
    $phone = trim((string) ($input['phone'] ?? ''));
    $program = trim((string) ($input['program_department'] ?? ''));
    if (strlen($phone) > 30 || strlen($program) > 150) {
        throw new InvalidArgumentException('Phone or department is too long.');
    }
    get_db()->prepare('UPDATE users SET phone = ?, program_department = ? WHERE id = ?')->execute([
        $phone !== '' ? $phone : null,
        $program !== '' ? $program : null,
        $userId,
    ]);
    log_audit($userId, 'profile_updated', 'Updated phone and department.');
    client_finish(true, 'Account saved.', 200, 'client-settings.php#account');
}

function client_action_notifications(int $userId, array $input): void {
    $flags = [];
    foreach (['notify_email', 'notify_sms', 'notify_in_app', 'notify_matches', 'notify_system'] as $name) {
        $flags[] = isset($input[$name]) ? 1 : 0;
    }
    get_db()->prepare('UPDATE users SET notify_email = ?, notify_sms = ?, notify_in_app = ?, notify_matches = ?, notify_system = ? WHERE id = ?')
        ->execute([...$flags, $userId]);
    log_audit($userId, 'notification_prefs_updated', 'Updated notification preferences.');
    client_finish(true, 'Notification preferences saved.', 200, 'client-settings.php#notifications');
}

function client_action_privacy(int $userId, array $input): void {
    $share = isset($input['share_lost_reports']) ? 1 : 0;
    $db = get_db();
    $db->prepare('UPDATE users SET share_lost_reports = ? WHERE id = ?')->execute([$share, $userId]);
    $db->prepare('UPDATE lost_items SET is_public = ? WHERE reported_by = ?')->execute([$share, $userId]);
    log_audit($userId, 'privacy_updated', $share ? 'Lost reports are listed on campus.' : 'Lost reports are hidden from the campus list.');
    client_finish(true, 'Privacy preference saved.', 200, 'client-settings.php#privacy');
}

function client_action_login_method(int $userId, array $input): void {
    $method = ($input['login_method'] ?? '') === 'totp' ? 'totp' : 'email';
    get_db()->prepare('UPDATE users SET login_method = ? WHERE id = ?')->execute([$method, $userId]);
    log_audit($userId, 'login_method_updated', $method === 'totp' ? 'Authenticator code is asked first.' : 'Email code is asked first.');
    client_finish(true, 'Sign-in method saved.', 200, 'client-settings.php#security');
}
