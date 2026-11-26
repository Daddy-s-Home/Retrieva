---
name: rbac-access-control
description: "Use for Retrieva RBAC authorization across admin, security, professor, and student roles, sidebar visibility, endpoint guards, record ownership, and authorization checks."
---

# RBAC Access Control

## Roles (`database/schema.sql` & `dashboard/rbac.php`)

Retrieva defines four roles in `users.role`:

- **Admin side (`RETRIEVA_ADMIN_ROLES = ['admin', 'security']`)**:
  - `admin`: Full system administration, found/lost item management, claim verification, pickup oversight, and user/audit management.
  - `security`: Campus Security Office staff — logs found items, reviews pending verifications/claims, and scans/verifies pickup QR codes.
- **Client side (`RETRIEVA_CLIENT_ROLES = ['professor', 'student']`)**:
  - `professor`: Can report lost items, search/view eligible listings, submit zero-knowledge claims, and manage own profile/TOTP settings.
  - `student`: Same client-side capabilities as `professor`, plus `student_id` onboarding (`database/save_student_id.php`).

## Server-Side Helpers

- **View & Navigation (`dashboard/rbac.php`)**:
  - `role_can(string $role, array $allowedRoles): bool`
  - `role_is_admin_side(string $role): bool`
  - `role_label(string $role): string`
  - Render sidebar links and gated UI conditionally in PHP so disallowed links are never sent to the browser.
- **Endpoint Guards (`database/db.php`)**:
  - `require_login(): array` — returns `401` JSON if `$_SESSION['user_id']` is missing.
  - `require_role(array $allowed_roles): array` — returns `403` JSON if `$_SESSION['role']` is not in `$allowed_roles`.

## Authorization Rules

- Every endpoint in `database/` and every protected page in `dashboard/` must enforce `require_login()` / `require_role()` server-side.
- Prevent IDOR: for client roles (`professor`, `student`), verify record ownership (`reported_by`, `claimant_id`, `user_id`) before reading or mutating records.
- Do not rely on hidden UI controls or client-side JavaScript role checks.
- Verify `users.status === 'active'` (reject `'blocked'` accounts).

## Test Matrix

- Test unauthenticated access (expect redirect to login or `401`).
- Test `student` / `professor` accessing `admin` / `security` endpoints (expect `403`).
- Test `student` / `professor` accessing another user's lost item or claim (expect `403` / not found).
- Test `security` and `admin` flows across found items, claim reviews, and QR pickups.
