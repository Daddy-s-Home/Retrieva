<?php
declare(strict_types=1);
$currentPage = 'settings';
require_once __DIR__ . '/_bootstrap.php';

$db = get_db();
$historyStmt = $db->prepare(
    "SELECT record_type, item_name, category, status, event_date
     FROM (
       SELECT 'Lost report' AS record_type, item_name, category, status,
              date_lost AS event_date, created_at
       FROM lost_items WHERE reported_by = ?
       UNION ALL
       SELECT 'Found item' AS record_type, item_name, category, status,
              date_found AS event_date, created_at
       FROM found_items WHERE logged_by = ?
       UNION ALL
       SELECT 'Claim' AS record_type, fi.item_name, fi.category, c.status,
              DATE(c.created_at) AS event_date, c.created_at
       FROM claims c INNER JOIN found_items fi ON fi.id = c.found_item_id
       WHERE c.claimant_id = ?
       UNION ALL
       SELECT 'Pickup' AS record_type, fi.item_name, fi.category,
              CASE WHEN p.scanned_at IS NULL THEN 'scheduled' ELSE 'completed' END AS status,
              DATE(COALESCE(p.scanned_at, p.scheduled_for, p.created_at)) AS event_date,
              p.created_at
       FROM pickups p
       INNER JOIN claims c ON c.id = p.claim_id
       INNER JOIN found_items fi ON fi.id = c.found_item_id
       WHERE c.claimant_id = ?
     ) AS activity
     ORDER BY event_date DESC, record_type ASC LIMIT 100"
);
$historyStmt->execute([$user['id'], $user['id'], $user['id'], $user['id']]);
$history = $historyStmt->fetchAll();

function settings_status_class(string $status): string {
    return match ($status) {
        'approved', 'resolved', 'completed', 'claimed' => 'settings-status--success',
        'rejected', 'disposed' => 'settings-status--danger',
        'pending', 'manual_review', 'scheduled', 'matched' => 'settings-status--warning',
        default => 'settings-status--neutral',
    };
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Settings — Retrieva</title>
<link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
<link rel="stylesheet" href="../assets/theme.css"><link rel="stylesheet" href="styles.css"><link rel="stylesheet" href="settings.css">
</head>
<body data-page="settings" data-role="<?= htmlspecialchars($role, ENT_QUOTES, 'UTF-8') ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?>
<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>
  <main class="page-content settings-page">
    <div class="page-header"><h1>Settings</h1><p>Manage your account security and review your Retrieva activity.</p></div>
    <section class="settings-grid">
      <article class="card settings-card settings-card--profile" id="profile">
        <div class="settings-card__heading"><div><span class="settings-eyebrow">Account</span><h2>Your profile</h2></div><div class="settings-avatar"><img src="<?= htmlspecialchars($avatarSrc, ENT_QUOTES, 'UTF-8') ?>" alt=""></div></div>
        <dl class="settings-details">
          <div><dt>Name</dt><dd><?= htmlspecialchars($user['full_name'], ENT_QUOTES, 'UTF-8') ?></dd></div>
          <div><dt>Email</dt><dd><?= htmlspecialchars($user['email'], ENT_QUOTES, 'UTF-8') ?></dd></div>
          <div><dt>Role</dt><dd><?= htmlspecialchars(role_label($role), ENT_QUOTES, 'UTF-8') ?></dd></div>
          <?php if (!empty($user['student_id'])): ?><div><dt>Student ID</dt><dd><?= htmlspecialchars($user['student_id'], ENT_QUOTES, 'UTF-8') ?></dd></div><?php endif; ?>
        </dl>
      </article>
      <article class="card settings-card">
        <div class="settings-card__heading"><div><span class="settings-eyebrow">Security</span><h2>Change password</h2></div><span class="settings-card__icon">🔐</span></div>
        <form id="change-password-form" class="settings-form">
          <label class="field"><span>New password</span><input type="password" id="new-password-input" name="password" minlength="8" autocomplete="new-password" required></label>
          <ul class="pw-criteria" id="pw-criteria" aria-live="polite">
            <li data-rule="length"><span class="pw-icon" aria-hidden="true">✕</span> At least 8 characters</li>
            <li data-rule="upper"><span class="pw-icon" aria-hidden="true">✕</span> At least 1 uppercase letter (A–Z)</li>
            <li data-rule="lower"><span class="pw-icon" aria-hidden="true">✕</span> At least 1 lowercase letter (a–z)</li>
            <li data-rule="number"><span class="pw-icon" aria-hidden="true">✕</span> At least 1 number (0–9)</li>
            <li data-rule="special"><span class="pw-icon" aria-hidden="true">✕</span> At least 1 special character (!@#$%…)</li>
          </ul>
          <label class="field"><span>Confirm new password</span><input type="password" name="confirm_password" minlength="8" autocomplete="new-password" required></label>
          <?php if (!empty($user['totp_enabled'])): ?>
          <label class="field"><span>Authenticator code</span><input type="text" name="totp_code" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" autocomplete="one-time-code" required></label>
          <?php else: ?>
          <label class="field"><span>Current password</span><input type="password" name="current_password" autocomplete="current-password" required></label>
          <?php endif; ?>
          <button type="submit" class="btn btn-primary">Update password</button><p class="settings-feedback" id="password-feedback" role="status"></p>
        </form>
      </article>
      <article class="card settings-card">
        <div class="settings-card__heading"><div><span class="settings-eyebrow">Two-factor authentication</span><h2>Authenticator setup</h2></div><span class="settings-card__icon">🛡️</span></div>
        <p class="settings-copy">Use an authenticator app to add another layer of protection to your account.</p>
        <div class="settings-totp-status <?= !empty($user['totp_enabled']) ? 'is-enabled' : '' ?>" id="totp-status"><strong><?= !empty($user['totp_enabled']) ? 'Authenticator enabled' : 'Authenticator not set up' ?></strong><span><?= !empty($user['totp_enabled']) ? 'Your account has a verified authenticator secret.' : 'Generate a secret, then confirm a current code.' ?></span></div>
        <button type="button" class="btn btn-secondary" id="totp-start-btn" <?= !empty($user['totp_enabled']) ? 'hidden' : '' ?>>Generate setup key</button>
        <div id="totp-setup-panel" class="settings-totp-panel" hidden><label class="field"><span>Setup key</span><input id="totp-secret" type="text" readonly></label><p class="settings-copy">Add this key to your authenticator app, then enter the six-digit code it shows.</p><form id="totp-verify-form" class="settings-form"><label class="field"><span>Authenticator code</span><input id="totp-code" type="text" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required></label><button type="submit" class="btn btn-primary">Verify and enable</button></form></div>
        <button type="button" class="btn btn-danger-outline" id="totp-disable-btn" <?= empty($user['totp_enabled']) ? 'hidden' : '' ?>>Disable authenticator</button><p class="settings-feedback" id="totp-feedback" role="status"></p>
      </article>
    </section>
    <section class="card settings-card settings-history">
      <div class="settings-card__heading"><div><span class="settings-eyebrow">Your records</span><h2>Activity history</h2></div><span class="settings-history__count"><?= count($history) ?> records</span></div>
      <div class="settings-table-wrap"><table class="settings-table"><thead><tr><th>Activity</th><th>Item</th><th>Category</th><th>Status</th><th>Date</th></tr></thead><tbody>
      <?php if (!$history): ?><tr><td colspan="5" class="settings-empty">No lost, found, claim, or pickup records yet.</td></tr><?php else: foreach ($history as $entry): ?><tr><td><?= htmlspecialchars($entry['record_type'], ENT_QUOTES, 'UTF-8') ?></td><td><strong><?= htmlspecialchars($entry['item_name'], ENT_QUOTES, 'UTF-8') ?></strong></td><td><?= htmlspecialchars($entry['category'], ENT_QUOTES, 'UTF-8') ?></td><td><span class="settings-status <?= settings_status_class($entry['status']) ?>"><?= htmlspecialchars(ucwords(str_replace('_', ' ', $entry['status'])), ENT_QUOTES, 'UTF-8') ?></span></td><td><?= htmlspecialchars((string)$entry['event_date'], ENT_QUOTES, 'UTF-8') ?></td></tr><?php endforeach; endif; ?>
      </tbody></table></div>
    </section>
  </main>
</div>
<div class="modal-overlay" id="totp-disable-modal" role="dialog" aria-modal="true" aria-labelledby="totp-disable-title">
  <div class="modal-card">
    <div class="modal-card__badge modal-card__badge--danger" aria-hidden="true">🛡️</div>
    <h2 id="totp-disable-title">Disable Authenticator?</h2>
    <p class="modal-subtitle">
      Removing two-factor authenticator protection will make your account less secure. You can re-enable it anytime in Settings.
    </p>
    <div class="modal-actions modal-actions--end">
      <button type="button" class="btn btn-ghost" id="totp-disable-cancel">Cancel</button>
      <button type="button" class="btn btn-danger" id="totp-disable-confirm">Disable Authenticator</button>
    </div>
  </div>
</div>
<script src="dashboard.js"></script><script src="settings.js"></script>
</body></html>
