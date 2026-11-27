---
name: rbac-access-control
description: "Use for Retrieva's admin, security, professor, and student authorization, shell separation, record ownership, privacy masking, route protection, and authorization test matrices."
---

# RBAC Access Control

## Roles (`dashboard/rbac.php`)

- **Admin (`admin`)**: Full administrative operations, user management, lost reports, found items, matching center, claims, QR pickup verification, returned items, reports & analytics, audit logs, and system settings.
- **Security (`security`)**: Staff/security operational workflows within `dashboard/admin/page.php` (found-item logging, matching, claim verification, QR pickup verification, returned items), subject to `rbac.php` restrictions.
- **Professor (`professor`)** & **Student (`student`)**: Client-side workflows within `dashboard/client/page.php` (browsing public/privacy-masked lost & found items, submitting own lost reports, submitting/tracking own claims, viewing QR pickup codes for approved claims, notifications, and personal settings).

## Authorization Rules

Every page, AJAX endpoint, export, file view, and database action needs server-side authorization via `database/db.php` (`require_login()`, `require_role()`, `require_login_page()`, `require_role_page()`) and `dashboard/_bootstrap.php`.

Authorize with:

- authenticated session user (`$_SESSION`)
- role (`admin`, `security`, `professor`, `student`)
- record ownership (e.g., `lost_items`, `claims`, `notifications` belonging to the current user on client endpoints)
- item/claim lifecycle state (e.g., only approved claims expose pickup QR tokens)
- requested action

## Visibility & Privacy

- Keep Admin/Security (`dashboard/admin/`) and Client (`dashboard/client/`) experiences strictly distinct.
- Public/client found-item browsing views must preserve privacy masking and hide sensitive/identifying fields meant for claim verification.
- Prevent IDOR by checking ownership or admin/security role on every record ID lookup, edit, or download.
- Never rely on hidden UI controls or client-side JavaScript role checks alone.

## Test Matrix

For each role (`admin`, `security`, `professor`, `student`) and unauthenticated requests:
- Test access to `dashboard/admin/` vs `dashboard/client/` pages and `database/admin/` vs `database/client/` endpoints.
- Test own vs another user's `lost_items`, `claims`, `notifications`, and `pickups`.
- Test read, create, update, approve/reject, QR verify, export, and delete actions.

