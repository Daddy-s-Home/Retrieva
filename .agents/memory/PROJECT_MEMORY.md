# Project Memory

## Project

- Repository: Retrieva — Campus Lost and Found Platform (University of Makati)
- Workspace root: `c:\xampp\htdocs\Retrieva-backup\Retrieva Test` (active XAMPP source described in `README.md`: `C:\xampp\htdocs\Retrieva`, local URL: `http://localhost/Retrieva/`)
- Stack: PHP 8+ (observed `8.2.12` in XAMPP), MariaDB `10.4.32` / MySQL (`retrieva_db`) via PDO, Apache via XAMPP, HTML, CSS (`assets/theme.css`), vanilla JavaScript (AJAX), Composer (`league/oauth2-google`, `phpmailer/phpmailer`), Node dev tooling (`live-server`, `prettier`)
- Architecture: Page-per-route PHP monolith serving both admin/security and student/professor workflows from one codebase, with shared server-side bootstrap (`database/db.php`, `dashboard/_bootstrap.php`), RBAC (`dashboard/rbac.php`), and modular backend endpoints (`database/admin/`, `database/client/`).

## Confirmed Architecture & Parameters

- **Role-Based Access Control (`dashboard/rbac.php`)**:
  * Admin-side roles: `admin`, `security` -> `dashboard/admin/page.php` (`dashboard/admin/prefetch.php`)
  * Client-side roles: `professor`, `student` -> `dashboard/client/page.php` (`dashboard/client/prefetch.php`)
  * Server-side enforcement: `require_login()`, `require_role()`, `require_login_page()`, `require_role_page()`, `csrf_token()`, `csrf_field()`, `verify_csrf()`, `log_audit()` in `database/db.php`.
- **Dashboard Modules**:
  * Admin: `dashboard`, `lost-reports`, `found-items`, `log-found`, `matching`, `claims`, `pickup`, `returned`, `users`, `reports`, `audit`, `settings`
  * Client: `dashboard`, `lost-items`, `found-items`, `my-reports`, `my-claims`, `notifications`, `settings`
- **Public Codes**:
  * `LR-YYYY-###` for lost reports
  * `F-YYYY-###` for found items
  * `CL-YYYY-###` for claims
- **Authentication & Communication**:
  * Email/password login (`database/login.php`), Google OAuth (`database/google_oauth_redirect.php`, `database/google_oauth_callback.php`, `database/oauth_config.php`), TOTP MFA (`database/setup_totp.php`, `database/totp_verify.php`), password setup/reset (`database/save_password.php`, `database/change_password.php`, `database/forgot_password.php`), PHPMailer (`database/mailer.php`), SMS hooks (`database/sms.php`).
- **Database (`retrieva_db`)**:
  * Schema & SQL files under `database/`: `retrieva_db_current.sql`, `schema.sql`, `retrieva_db.sql`, `retrieva_dbv1.sql`, `retrieva_dbv2.sql`, and `database/migrations/`.
  * Tables listed in `database/retrieva_db_current.sql`: `audit_trail`, `claims`, `found_items`, `item_images`, `item_matches`, `lost_items`, `notifications`, `pickups`, `saved_items`, `sms_logs`, `totp_challenges`, `users`.
- **UI & Styling**:
  * Shared design tokens in `assets/theme.css` (navy/gold palette, semantic states, radii, spacing, shadows).
  * Main scripts: `dashboard/dashboard.js`, `dashboard/admin/admin.js`, `dashboard/client/client.js`, `dashboard/client/qrcode.js`, `dashboard/settings.js`, `auth/auth.js`.

## 2026-11-26

- Memory Reset: Removed unrelated legacy project memory and initialized Retrieva project memory from `README.md` (read-only) and workspace inspection.
- Skills Setup: Configured `.agents/skills/` for Retrieva's actual PHP 8+ / MySQL / XAMPP / vanilla JS stack without framework or external AI/OCR bloat.
- Resolved (`database/retrieva_db_current.sql`): Re-exported cleanly from XAMPP phpMyAdmin 5.2.1 (`10.4.32-MariaDB`, `PHP 8.2.12`) with all 12 `InnoDB` table definitions and current data intact (`0` errors). Treat `database/retrieva_db_current.sql` as the authoritative current schema/data snapshot for `retrieva_db` (noting mixed `utf8mb4_unicode_ci` and `utf8mb4_general_ci` collations across tables).



## 2026-11-27

- Architecture (Frontend): Verified dual server-rendered PHP shells. Admin (`dashboard/admin/page.php`, roles `admin`/`security`, `Chart.js` v4). Client (`dashboard/client/page.php`, roles `professor`/`student`, `#client-drawer`, `qrcode.js`). Both share `assets/theme.css` tokens and `dashboard/_bootstrap.php` bootstrap.
- Architecture (JS): Hybrid navigation — `window.RetrievaWarm` caches initial PHP payload; subsequent navigation uses `fetch` to `database/*/endpoint.php` (`X-CSRF-Token`, `X-Requested-With: fetch`) and receives `{success, html}` JSON swapped into `#client-module`. Actions POST to `database/*/actions.php`. `retrieva:paint` event re-initializes per-module JS. Falls back to form POST redirects.
- Architecture (Pusher): `dashboard/_bootstrap.php` initializes Pusher PHP SDK (`notify_channel($channel, $event, $data)`) for real-time in-app notifications on claim status changes and match alerts.
- Lifecycle (Lost Report `LR-YYYY-###`): `searching` (create_report) → `matched` (confirm_match) → `resolved` (confirm_pickup) or `closed`.
- Lifecycle (Found Item `F-YYYY-###`): `unclaimed` (create_found) → `pending_verification` (create_claim, atomic lock) → `claimed` (approve_claim) → `returned` (confirm_pickup) or `disposed`.
- Lifecycle (Matching, `item_matches`): `potential`/`needs_review` → `confirmed` (confirm_match, sets `lost_items.matched_found_item_id`) or `no_match`; `notify_match` alerts reporter.
- Lifecycle (Claims `CL-YYYY-###`): `pending` → `manual_review` (request_claim_info) → `approved` (approve_claim, auto-creates `pickups.qr_token`) or `rejected`; `withdraw_claim` by claimant reverts found item if no other active claims.
- Lifecycle (Pickup/Return `RT-YYYY-###`): `pickups.status = 'pending'` (created on approve_claim) → `verified` (confirm_pickup by qr_token, FOR UPDATE lock, sets scanned_at/verified_by/return_code, marks found_items = returned, linked lost_items = resolved). `report_return_issue` stores condition_note.
- Status Enums confirmed: `lost_items.status`: `searching`, `matched`, `resolved`, `closed`. `found_items.status`: `unclaimed`, `pending_verification`, `claimed`, `returned`, `disposed`. `item_matches.status`: `potential`, `needs_review`, `confirmed`, `no_match`. `claims.status`: `pending`, `manual_review`, `approved`, `rejected`. `pickups.status`: `pending`, `verified`.
- Convention: All lifecycle mutations use PDO transactions. `assign_public_code()` in `db.php` generates codes after INSERT. Photos saved to `uploads/lost/` or `uploads/found/` via `retrieva_save_photos()`, linked in `item_images`.

## 2026-11-28

- Dashboard categories: `database/category_helper.php` centralizes nine campus-focused submission categories, ten fixed chart buckets, and legacy normalization (including blank/unknown values as “Unspecified”). The Admin/Security chart has Found/Lost tabs; client dashboards show Lost categories only. Both legacy and modular dashboards use responsive horizontal bars with label/count legends and zero-data fallbacks. `database/dashboard_stats.php` live refresh returns canonical data and preserves the selected tab.
- Category schema: `database/migrations/2026_11_28_item_category_taxonomy.sql` adds the canonical enum members while retaining legacy values; the migration was applied to local `retrieva_db` without rewriting existing rows. Category submission validation is restricted to the canonical list.
- Category validation: PHP lint and Node syntax checks passed for changed dashboard files. A local PDO verification checked all ten bucket totals, legacy/blank/unknown mappings, canonical enum inserts inside a transaction, and rollback; original row counts remained unchanged. Responsive CSS rules were reviewed, but browser viewport automation was unavailable.
- Dashboard branding: Admin, Security, Professor, and Student shells use the transparent `assets/icons/logo.png`; unrelated favicon references remain unchanged.
- Responsive layout: At narrow content widths the category chart stacks above its legend; its donut and legend fit a 320px content layout without horizontal overflow.
- Local test account: No role, password, or MFA changes were made. Keep MFA disabled until the user completes enrollment and the existing verification flow accepts a code.
- Photo uploads: `dashboard/components/photo-picker.php`, `dashboard/photo-picker.css`, and `dashboard/photo-picker.js` provide shared picker, preview/removal, rear-camera capture, and file fallback for the modular Client and Admin/Security shells plus legacy lost/found forms. Accept JPEG/PNG/WebP, 1–5 total photos, max 2 MB each; uploads use generated names under `uploads/lost/` and `uploads/found/`.
- Photo storage: `database/client/lib.php` reads legacy single paths and JSON arrays, stores JSON arrays in the existing `photo_path` columns, synchronizes `item_images`, and renders all paths. The local `retrieva_db` conversion migrated 16 lost and 10 found rows without schema changes; all 13 `item_images` rows, including seven orphans, remained unchanged.
- Photo validation: PHP lint, JavaScript syntax, real multipart PNG upload with rollback/file cleanup, invalid image-byte rejection, server-side photo-count enforcement, and JSON gallery URL checks passed. Actual camera permission interaction and browser viewport automation remain unverified because headless Edge did not return page DOM and no browser automation tool was available.
- Pickup location: `database/migrations/2026_11_28_pickup_location.sql` adds nullable `pickups.pickup_location VARCHAR(255)`. It was applied to local `retrieva_db` after confirming the column was absent; all six existing pickup rows remained unchanged with `NULL` locations. All three Admin/Security approval routes require a trimmed 1–255-character location, persist it with pickup approval, and append it to the requested claimant notification. Legacy and modular QR views show the location plus a Campus Security fallback for historical rows.
- Item galleries: Shared `dashboard/components/item-photo-gallery.php`, `dashboard/item-photo-gallery.css`, and `dashboard/item-photo-gallery.js` provide responsive first-photo previews and a maximum-five-image gallery with keyboard arrows, touch swipes, broken-image/N/A fallbacks, and “View Item” affordance. Legacy lost/found tables and modular Admin/Security and Client lost/found views use the shared renderer; existing photo-path normalization and role visibility remain in place.
- QR fallback: The modular claimant drawer displays the actual QR token as a labeled manual fallback below the pickup-location label; only approved claims visible to their claimant expose it.
- Pickup/gallery validation: PHP syntax checks and JavaScript syntax checks passed for modified files. Focused helper checks passed for blank/whitespace/overlength/control-character location rejection, valid location preservation, notification prefix/location, five-photo output cap, and missing-photo N/A output. Authenticated browser route testing and viewport/touch interaction testing remain unverified because browser automation was unavailable.
- Database binding: The current workspace's `database/db.php` points to `retrieva_db_current`; a read-only PDO check confirmed the configured database is reachable and includes an active admin with ID `0`. Preserve this existing local configuration change.
- Authentication/MFA: Password login now routes both AJAX and ordinary form submissions through `database/login.php` and leaves the session pending until email/authenticator verification. Email challenges are created and dispatched by `database/send_login_code.php` after `auth/totp.php` loads; resend is CSRF-protected and subject to a 30-second per-session cooldown. No schema migration was needed. SMTP delivery was not exercised; local route checks confirmed login page HTTP 200, unauthenticated TOTP redirect, and rejection of an invalid-CSRF challenge request without sending mail.
- Admin user management: The Users module and its read/write endpoints are admin-only; create, edit/reactivate, password reset, and reversible deactivation are supported. Deactivation blocks self-removal and protects the last active admin; audit writes share a transaction with account changes. Session guards refresh role/status from the database, and account ID `0` is accepted for user-specific actions. PHP lint passed for touched endpoints; authenticated browser tests were not performed.
- Dashboard navigation: The Pending Verifications card title now links to `dashboard/pending-verifications.php` alongside its existing View All link. The route was verified to redirect unauthenticated requests to login; authenticated click behavior was not browser-tested.
- User navigation follow-up: The main `dashboard/index.php` uses `dashboard/components/sidebar.php`, separate from `dashboard/admin/page.php`. The Users link is present in the legacy sidebar for role `admin` only. `dashboard/admin-users.php` now renders account management with the legacy shared sidebar/header rather than routing into the newer Admin module shell; an isolated read-only render confirmed the legacy shell and user content.
- Dashboard local time: Legacy greetings plus Admin/Client date and clock labels are populated from the browser's local timezone in `dashboard/dashboard.js`; Client SPA paints reapply the greeting. Notification initialization now shows per-user tab-cached results immediately, then refreshes without allowing older HTTP results to erase live Pusher events. Pusher notification IDs support de-duplication, and personal notification fetches opt out of HTTP caching.
- User Management status: `database/migrations/2026_11_28_add_inactive_user_status.sql` expands the users status enum to `active`, `blocked`, and `inactive`; applied to configured `retrieva_db_current` without changing existing account statuses. Account removal is soft deactivation, preserving linked history; admins can reactivate an inactive account. Admin-only controls retain self-deactivation and last-active-admin safeguards. The legacy page uses existing shared shell styles and keeps the Users sidebar route visible to admins.
- Dashboard/User Management validation: PHP lint passed for all changed PHP files, Node syntax checks passed for `dashboard/dashboard.js` and `auth/auth.js`, and `git diff --check` found no whitespace errors (only expected LF/CRLF notices). A CLI render as admin ID `0` confirmed legacy sidebar, Users navigation, status filtering, and reversible Delete Account controls. Focused notification cache/Pusher reconciliation and inactive-session checks passed; browser viewport automation was unavailable.
- Pending Verifications selection: `dashboard/pending-verifications.php` must set `$currentPage` before `_bootstrap.php`; otherwise the bootstrap's `dashboard` fallback marks the Dashboard nav link active. A CLI render confirmed Pending Verifications is now active and Dashboard is not. User Management sections use a consistent full-width flex stack; status pills visibly distinguish active (green), blocked (red), and inactive (gold), with responsive role-stat columns.
