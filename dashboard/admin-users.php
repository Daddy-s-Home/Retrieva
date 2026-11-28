<?php
declare(strict_types=1);

$currentPage = 'users';
require_once __DIR__ . '/_bootstrap.php';
require_role_page(['admin'], 'index.php');
require_once __DIR__ . '/../database/admin/lib.php';

$data = admin_users_data($_GET, (int) $user['id']);
$filters = $data['filters'];
$flash = (string) ($_SESSION['admin_flash'] ?? '');
$success = (string) ($_SESSION['admin_success'] ?? '');
unset($_SESSION['admin_flash']);
unset($_SESSION['admin_success']);

function legacy_user_select_options(array $options, string $selected): string {
    $html = '';
    foreach ($options as $option) {
        $html .= '<option value="' . h($option) . '"' . ($option === $selected ? ' selected' : '') . '>' . h(ucfirst($option)) . '</option>';
    }
    return $html;
}

function legacy_user_page_url(array $filters, int $page): string {
    $query = ['page' => $page];
    if ($filters['q'] !== '') {
        $query['q'] = $filters['q'];
    }
    if ($filters['role'] !== '') {
        $query['role'] = $filters['role'];
    }
    if ($filters['status'] !== '') {
        $query['status'] = $filters['status'];
    }
    return 'admin-users.php?' . http_build_query($query);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="csrf-token" content="<?= h(csrf_token()) ?>">
  <title>User Management — Retrieva</title>
  <link rel="icon" type="image/svg+xml" href="../assets/icons/logo.svg">
  <link rel="stylesheet" href="../assets/theme.css">
  <link rel="stylesheet" href="styles.css">
</head>
<body data-page="<?= h($currentPage) ?>" data-role="<?= h($role) ?>">
<?php include __DIR__ . '/components/sidebar.php'; ?>
<div class="main-col">
  <?php include __DIR__ . '/components/header.php'; ?>
  <main class="page-content user-management-page">
    <div class="page-header">
      <h1>User Management</h1>
      <p>Create accounts, manage access, reset passwords, and deactivate accounts without deleting their history.</p>
    </div>

    <?php if ($flash !== ''): ?>
      <div class="alert alert-error" role="status"><?= h($flash) ?></div>
    <?php endif; ?>
    <?php if ($success !== ''): ?>
      <div class="alert alert-success" role="status"><?= h($success) ?></div>
    <?php endif; ?>

    <section class="stat-grid" aria-label="Accounts by role">
      <?php foreach (ADMIN_ROLES as $accountRole): ?>
        <article class="stat-card stat-card--blue">
          <div>
            <div class="stat-card__value"><?= (int) $data['counts'][$accountRole] ?></div>
            <div class="stat-card__label"><?= h(ucfirst($accountRole)) ?> accounts</div>
          </div>
        </article>
      <?php endforeach; ?>
    </section>

    <section class="card" aria-labelledby="create-user-heading">
      <div class="card-header">
        <h3 id="create-user-heading">Add Account</h3>
      </div>
      <form method="post" action="../database/admin/actions.php">
        <?= csrf_field() ?>
        <input type="hidden" name="action" value="create_user">
        <div class="field-row">
          <div class="field">
            <label for="new-user-name">Name</label>
            <input id="new-user-name" type="text" name="full_name" maxlength="150" required>
          </div>
          <div class="field">
            <label for="new-user-email">UMak email</label>
            <input id="new-user-email" type="email" name="email" maxlength="150" required>
          </div>
        </div>
        <div class="field-row">
          <div class="field">
            <label for="new-user-role">Role</label>
            <select id="new-user-role" name="role"><?= legacy_user_select_options(ADMIN_ROLES, 'student') ?></select>
          </div>
          <div class="field">
            <label for="new-user-status">Status</label>
            <select id="new-user-status" name="status"><?= legacy_user_select_options(ADMIN_USER_STATUSES, 'active') ?></select>
          </div>
        </div>
        <div class="field-row">
          <div class="field">
            <label for="new-user-student-id">Student ID</label>
            <input id="new-user-student-id" type="text" name="student_id" maxlength="30">
          </div>
          <div class="field">
            <label for="new-user-program">Program / Department</label>
            <input id="new-user-program" type="text" name="program_department" maxlength="150">
          </div>
        </div>
        <div class="field">
          <label for="new-user-password">Password</label>
          <input id="new-user-password" type="password" name="password" minlength="8" required autocomplete="new-password">
        </div>
        <button class="btn btn-primary" type="submit">Create Account</button>
      </form>
    </section>

    <section class="card" aria-label="Filter accounts">
      <form method="get" action="admin-users.php">
        <div class="field-row user-filter-row">
          <div class="field">
            <label for="user-search">Search accounts</label>
            <input id="user-search" type="search" name="q" value="<?= h($filters['q']) ?>" placeholder="Name, email, student ID">
          </div>
          <div class="field">
            <label for="user-role-filter">Role</label>
            <select id="user-role-filter" name="role">
              <option value="">All roles</option>
              <?= legacy_user_select_options(ADMIN_ROLES, $filters['role']) ?>
            </select>
          </div>
          <div class="field">
            <label for="user-status-filter">Status</label>
            <select id="user-status-filter" name="status">
              <option value="">All statuses</option>
              <?= legacy_user_select_options(ADMIN_USER_STATUSES, $filters['status']) ?>
            </select>
          </div>
        </div>
        <button class="btn btn-primary" type="submit">Search</button>
      </form>
    </section>

    <section class="card" aria-labelledby="user-accounts-heading">
      <div class="card-header user-accounts-header">
        <h3 id="user-accounts-heading">Accounts</h3>
        <span><?= count($data['rows']) ?> shown · <?= (int) $data['total'] ?> total</span>
      </div>
      <div class="data-table-wrap">
        <table class="data-table user-accounts-table">
          <thead>
            <tr><th>Name / Email</th><th>Role</th><th>Student ID</th><th>Status</th><th>Manage</th></tr>
          </thead>
          <tbody>
            <?php if (!$data['rows']): ?>
              <tr class="empty-row"><td colspan="5">No accounts match your search.</td></tr>
            <?php endif; ?>
            <?php foreach ($data['rows'] as $account): ?>
              <?php $accountId = (int) $account['id']; ?>
              <tr>
                <td><strong><?= h($account['full_name']) ?></strong><br><small><?= h($account['email']) ?></small></td>
                <td><?= h(ucfirst($account['role'])) ?></td>
                <td><?= h((string) $account['student_id']) ?></td>
                <td><span class="user-status user-status--<?= h($account['status']) ?>"><?= h(ucfirst($account['status'])) ?></span></td>
                <td>
                  <details>
                    <summary class="btn btn-ghost btn-sm">Manage</summary>
                    <div class="user-account-tools">
                      <form method="post" action="../database/admin/actions.php">
                        <?= csrf_field() ?>
                        <input type="hidden" name="action" value="update_user">
                        <input type="hidden" name="user_id" value="<?= $accountId ?>">
                        <div class="field">
                          <label for="user-name-<?= $accountId ?>">Name</label>
                          <input id="user-name-<?= $accountId ?>" type="text" name="full_name" maxlength="150" value="<?= h($account['full_name']) ?>" required>
                        </div>
                        <div class="field">
                          <label for="user-email-<?= $accountId ?>">Email</label>
                          <input id="user-email-<?= $accountId ?>" type="email" name="email" maxlength="150" value="<?= h($account['email']) ?>" required>
                        </div>
                        <div class="field-row">
                          <div class="field">
                            <label for="user-role-<?= $accountId ?>">Role</label>
                            <select id="user-role-<?= $accountId ?>" name="role"><?= legacy_user_select_options(ADMIN_ROLES, $account['role']) ?></select>
                          </div>
                          <div class="field">
                            <label for="user-status-<?= $accountId ?>">Status</label>
                            <select id="user-status-<?= $accountId ?>" name="status"><?= legacy_user_select_options(ADMIN_USER_STATUSES, $account['status']) ?></select>
                          </div>
                        </div>
                        <div class="field">
                          <label for="user-student-id-<?= $accountId ?>">Student ID</label>
                          <input id="user-student-id-<?= $accountId ?>" type="text" name="student_id" maxlength="30" value="<?= h((string) $account['student_id']) ?>">
                        </div>
                        <div class="field">
                          <label for="user-program-<?= $accountId ?>">Program / Department</label>
                          <input id="user-program-<?= $accountId ?>" type="text" name="program_department" maxlength="150" value="<?= h((string) $account['program_department']) ?>">
                        </div>
                        <button class="btn btn-primary" type="submit">Save Account</button>
                      </form>
                      <form method="post" action="../database/admin/actions.php">
                        <?= csrf_field() ?>
                        <input type="hidden" name="action" value="reset_user_password">
                        <input type="hidden" name="user_id" value="<?= $accountId ?>">
                        <div class="field">
                          <label for="user-password-<?= $accountId ?>">New Password</label>
                          <input id="user-password-<?= $accountId ?>" type="password" name="password" minlength="8" required autocomplete="new-password">
                        </div>
                        <div class="field">
                          <label for="user-confirm-password-<?= $accountId ?>">Confirm Password</label>
                          <input id="user-confirm-password-<?= $accountId ?>" type="password" name="confirm_password" minlength="8" required autocomplete="new-password">
                        </div>
                        <button class="btn btn-ghost" type="submit">Reset Password</button>
                      </form>
                      <?php if ($account['status'] !== 'inactive' && $accountId !== (int) $user['id']): ?>
                        <form class="user-account-deactivate" method="post" action="../database/admin/actions.php"
                              data-confirm-title="Deactivate account?"
                              data-confirm="This will set this account to Inactive and prevent sign-in. Its reports and claims will be kept, and an admin can reactivate it later."
                              data-confirm-btn="Mark inactive">
                          <?= csrf_field() ?>
                          <input type="hidden" name="action" value="deactivate_user">
                          <input type="hidden" name="user_id" value="<?= $accountId ?>">
                          <p>Deletion is reversible: the account is marked inactive and its history is retained.</p>
                          <button class="btn btn-danger" type="submit">Delete Account</button>
                        </form>
                      <?php elseif ($account['status'] === 'inactive'): ?>
                        <p class="user-account-inactive-note">This account is inactive. Set its status to Active and save to restore access.</p>
                      <?php endif; ?>
                    </div>
                  </details>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </section>

    <?php if ($data['pages'] > 1): ?>
      <div class="section-title">
        <span>Page <?= (int) $filters['page'] ?> of <?= (int) $data['pages'] ?></span>
        <span class="actions-cell">
          <?php if ($filters['page'] > 1): ?><a class="btn btn-ghost btn-sm" href="<?= h(legacy_user_page_url($filters, $filters['page'] - 1)) ?>">Previous</a><?php endif; ?>
          <?php if ($filters['page'] < $data['pages']): ?><a class="btn btn-ghost btn-sm" href="<?= h(legacy_user_page_url($filters, $filters['page'] + 1)) ?>">Next</a><?php endif; ?>
        </span>
      </div>
    <?php endif; ?>
  </main>
</div>
<script src="dashboard.js"></script>
</body>
</html>
