# Retrieva Project Context

> Agent handoff for continuing the current Retrieva application and rebuilding
> its Admin and Client/User dashboards from the supplied visual references.

## 1. Start here

- **Canonical active project:** `C:\xampp\htdocs\Retrieva`
- **Local URL:** `http://localhost/Retrieva/`
- **Runtime:** XAMPP (Apache + PHP 8+) and MySQL/MariaDB
- **Database:** `retrieva_db`
- **Reference designs:** `C:\xampp\htdocs\Retrieva\System Refence for front end in dashboard`
- **Git-backed backup:** `C:\xampp\htdocs\Retrieva-backup\Retrieva`
- **GitHub remote of the backup:** `https://github.com/Daddy-s-Home/Retrieva.git`

Treat `C:\xampp\htdocs\Retrieva` as the working source of truth. The backup has
the same application code plus Git history, but the active project has the
latest local timestamps.

### Agent rules

1. Do not explore or manually edit `vendor/`.
2. Do not replace working backend behavior merely to reproduce a mockup.
3. Inspect the relevant numbered reference image before implementing a screen.
4. Preserve server-side authentication, role checks, session behavior, CSRF
   checks, and database ownership rules.
5. Use real database data where it exists. Do not ship hard-coded KPI values,
   fake badges, or mock records.
6. Keep Admin/Security and Client/User experiences distinct.
7. Make incremental, testable changes and verify both role families after each
   shared layout change.
8. Never quote, copy, or commit credentials found in configuration files.

## 2. Product overview

Retrieva is the University of Makati lost-and-found system. Its intended
end-to-end workflow is:

1. A student or professor reports a lost item.
2. Security/Admin logs found items.
3. The system or staff identifies potential matches.
4. The user submits a claim with identifying information.
5. Admin/Security verifies the claim.
6. An approved claim receives a QR-based pickup flow.
7. Staff confirms pickup and the item becomes returned.
8. Actions appear in audit logs, notifications, and analytics.

The current code implements parts of this workflow. The visual references show
the complete target experience.

## 3. Reference-image convention

The parent reference directory contains two subfolders and no root-level
mockups:

```text
System Refence for front end in dashboard/
├── Admin side/
│   └── 1.png ... 11.png
└── User side/
    └── 12.png ... 18.png
```

- **Red markings = Admin designs**
- **Blue markings = Client/User designs**
- The numbering is one continuous sequence: Admin `1`–`11`, User `12`–`18`.
- “Log Found Item” appears in the Admin navigation but does not have a
  dedicated numbered mockup. Its final layout remains to be designed using the
  shared visual language and existing found-item fields.

## 4. Target screen map

### Admin/Security references

| Ref | Screen | Main target content |
|---|---|---|
| `Admin side\1.png` | Admin Dashboard | Found/lost/pending/returned KPIs, found-vs-lost line chart, category donut, location chart, recent found items, pending claims, recent activity |
| `Admin side\2.png` | Lost Reports | Status KPIs/tabs, filters, reports table, export, right-side report detail drawer, match/resolve/close actions |
| `Admin side\3.png` | Found Items | Inventory KPIs/tabs/table, Log Found Item action, item detail/history drawer, edit and claimed/unclaimed actions |
| `Admin side\4.png` | Matching Center | Match KPIs, automatic suggestions, confidence score, side-by-side comparison, similarity checklist, match/notify/no-match actions |
| `Admin side\5.png` | Claims | Claim KPIs, filters/table, claim detail drawer, identity verification, approve/reject/request-information actions |
| `Admin side\6.png` | QR Pickup Verification | QR scanner, verification KPIs, pickup queue, student/item detail, checklist, confirm-pickup action |
| `Admin side\7.png` | Returned Items | Return KPIs/table, report generation, returned-item timeline, view-claim/report-issue actions |
| `Admin side\8.png` | Users | Role KPIs, user table, add user, profile/activity/claims/reports detail tabs, edit/reset/deactivate actions |
| `Admin side\9.png` | Reports & Analytics | Overview/lost/found/claims/users/trends tabs, KPIs, charts, recent claims, downloadable reports |
| `Admin side\10.png` | Audit Logs | Category KPIs, filters, export, log table, technical metadata and linked-record detail drawer |
| `Admin side\11.png` | Admin Settings | General, Security, Notifications, System, QR & Pickup, Appearance, Backup & Maintenance settings |

Target Admin navigation:

```text
Dashboard
Lost Reports
Found Items
Log Found Item
Matching Center
Claims
QR Pickup Verification
Returned Items
Users
Reports & Analytics
Audit Logs
Settings
```

### Client/User references

| Ref | Screen | Main target content |
|---|---|---|
| `User side\12.png` | User Dashboard | Greeting, personal KPIs, recently found grid, notifications, own reports/claims summaries, quick actions |
| `User side\13.png` | Lost Items | Campus statistics, tabs/filters/date range, report-lost action, item cards, pagination |
| `User side\14.png` | Found Items | Found-item statistics, category tabs, privacy-masked public cards, detail/claim path |
| `User side\15.png` | My Reports | Personal KPIs and reports with Reported → Match → Verification → Resolved progress stepper |
| `User side\16.png` | My Claims | Claim-lifecycle KPIs and steppers, status details, pickup QR when approved |
| `User side\17.png` | Notifications | Filter tabs, unread indicators, mark-all-read, notification list and detail panel |
| `User side\18.png` | User Settings | Account, Security, Notifications, Privacy, profile verification, password/2FA and preference controls |

Target Client/User navigation:

```text
Dashboard
Lost Items
Found Items
My Reports
My Claims
Notifications
Settings
```

## 5. Shared target UI language

The references consistently use:

- Dark navy left sidebar with Retrieva branding and role-aware navigation.
- Top header with global search, notifications, and current-user profile.
- White/light-gray application canvas with card-based sections.
- UMak/Retrieva navy, blue, and gold accents.
- KPI cards, status pills, tabs, filters, tables, item cards, charts, progress
  steppers, and right-side detail drawers.
- Item thumbnails where authorized; privacy-masked details on public/user
  browsing views.
- Responsive layouts that retain usable actions and readable data on smaller
  screens.

Reuse tokens from `assets/theme.css` rather than creating a second independent
palette:

- Navy: `--c-navy`, `--c-navy-dark`
- Gold: `--c-gold`, `--c-gold-soft`
- Semantic states: success, danger, info, purple
- Shared radii, shadows, text colors, borders, and font stack

## 6. Current application architecture

The application is a PHP monolith with page-per-route rendering.

```text
Retrieva/
├── assets/
│   ├── effects/particles/
│   ├── icons/
│   └── theme.css
├── auth/
│   ├── login.php
│   ├── totp.php
│   ├── forgot-password.php
│   ├── auth.js
│   └── styles.css
├── dashboard/
│   ├── components/
│   ├── _bootstrap.php
│   ├── rbac.php
│   ├── index.php
│   ├── found-items.php
│   ├── lost-items.php
│   ├── claims.php
│   ├── pending-verifications.php
│   ├── settings.php
│   ├── dashboard.js
│   └── styles.css
├── database/
│   ├── db.php
│   ├── schema.sql
│   ├── retrieva_db.sql
│   └── JSON/auth endpoints
├── composer.json
├── composer.lock
└── package.json
```

### Request/layout flow

1. A dashboard page sets `$currentPage`.
2. It includes `dashboard/_bootstrap.php`.
3. Bootstrap loads `database/db.php`, starts/validates the session, fetches the
   current user, and prepares role/avatar variables.
4. Pages include `dashboard/components/sidebar.php` and `header.php`.
5. Page-specific PHP directly queries MySQL through `get_db()`.
6. Mutations currently use either same-page protected POST forms or JSON
   endpoints under `database/`.

There is no framework, SPA router, or frontend build pipeline.

## 7. Roles and access model

Database roles:

- `admin`
- `security`
- `professor`
- `student`

Current grouping:

- **Admin side:** `admin`, `security`
- **Client/User side:** `professor`, `student`

Relevant files:

- `dashboard/rbac.php`: role constants and helper checks.
- `dashboard/_bootstrap.php`: authenticated page bootstrap.
- `dashboard/components/sidebar.php`: hides unauthorized navigation.
- `database/db.php`: login guards, role guards, CSRF helpers, JSON helpers,
  audit logging, and PDO access.

Hiding a link is not authorization. Every sensitive page and mutation must
enforce its allowed roles on the server.

Open product decisions:

1. Whether Security receives every Admin capability or a restricted subset.
2. Whether Professor exactly matches Student or receives separate actions.
3. Whether only Admin can manage users/system settings while Security handles
   item/claim/pickup operations.

Do not invent these rules silently. Confirm them before finalizing new routes.

## 8. Authentication contracts to preserve

### Local login

1. `auth/login.php` renders the form and logged-in redirect.
2. `auth/auth.js` posts `{ email, password }` to `database/login.php`.
3. Password success creates an email verification challenge and sets
   `pending_totp_user_id`.
4. Browser moves to `auth/totp.php`.
5. `database/totp_verify.php` promotes the pending user into the authenticated
   session and redirects to `dashboard/index.php`.

### Google login

- Starts at `database/google_oauth_redirect.php`.
- Callback is `database/google_oauth_callback.php`.
- Only the configured UMak email domain is allowed.
- Successful OAuth creates/links the user and enters the dashboard.

### Session keys

- `user_id`
- `role`
- `name`
- `pending_totp_user_id`
- `pending_reset_user_id`
- `reset_user_id`
- `pending_totp_setup_secret`
- `oauth2state`
- `csrf_token`

### Client-side DOM/API hooks

Preserve these unless all callers are deliberately migrated:

- `#login-form`, fields `email` and `password`
- `#toggle-password`, `#eye-icon`
- `#totp-form`, `.totp-boxes input`, `#totp-submit`
- `#forgot-password-flow`
- `#fp-email-form`, `#fp-code-form`, `#fp-reset-form`
- `sessionStorage.retrieva_totp_purpose`
- JSON fields such as `success`, `message`, `locked`,
  `remaining_seconds`, and `redirect`

### Login UI status

- `auth/login.php` uses the latest split visual/card design.
- Login particles are isolated under `assets/effects/particles/`.
- Script order is `particles.min.js` → `auth-particles.js` → `auth.js`.
- Particles are decorative, pointer-inert, `aria-hidden`, responsive, and
  disabled for reduced-motion users.
- The login hero expects `assets/icons/login.png`; it currently has an
  `onerror` fallback because that image may be absent.
- “Remember me” is visual only and is not currently implemented.
- TOTP and forgot-password pages still use the older centered gateway shell.

## 9. Current dashboard implementation

### Shared files

- `dashboard/_bootstrap.php`
- `dashboard/rbac.php`
- `dashboard/components/sidebar.php`
- `dashboard/components/header.php`
- `dashboard/components/student-id-modal.php`
- `dashboard/components/password-setup-modal.php`
- `dashboard/styles.css`
- `dashboard/dashboard.js`

`dashboard/settings.php` additionally uses `settings.css` and `settings.js`.
`dashboard/index.php` currently loads Chart.js from a CDN.

### Existing screens

| Current file | Current capability | Reference coverage |
|---|---|---|
| `dashboard/index.php` | Role-scoped KPIs, basic real charts, recent/pending summaries | Partial refs 1 and 12 |
| `dashboard/found-items.php` | Admin/Security found-item create/update/delete table | Partial ref 3 |
| `dashboard/lost-items.php` | Admin all reports; user own report/create/resolve/delete | Partial refs 2, 13, and 15 |
| `dashboard/claims.php` | Admin claim review; user unclaimed items and own claims | Partial refs 5, 14, and 16 |
| `dashboard/pending-verifications.php` | Pending/manual-review queue | Partial overlap with ref 5 |
| `dashboard/settings.php` | Personal profile/password/TOTP/activity | Partial ref 18; not ref 11 |

### Missing or substantially incomplete screens

- Matching Center
- QR Pickup Verification
- Returned Items
- User management
- Reports & Analytics
- Audit Logs viewer
- Admin/System Settings
- Dedicated Client Found Items
- Dedicated My Reports
- Dedicated My Claims
- Notifications
- Standalone Log Found Item layout

### Known UI gaps

- Current pages are table-centric; references use detail drawers, image cards,
  steppers, tabs, and richer filters.
- Notification bell is only a visual stub.
- Some KPI trend text and controls are hard-coded/non-functional.
- No dedicated reusable drawer, pagination, item-card, stepper, or status-pill
  component layer exists yet.
- Current sidebar uses emoji-like icons and an older information architecture.

## 10. Database model

Primary SQL files:

- `database/schema.sql`: intended schema definition.
- `database/retrieva_db.sql`: dump of the database that was actually used
  locally; includes data and schema additions.

Tables:

| Table | Purpose |
|---|---|
| `users` | Accounts, roles, providers, student IDs, lockout state, TOTP state |
| `totp_challenges` | Hashed email codes for login/password reset |
| `found_items` | Logged item details, location/date/photo/masked features/status |
| `lost_items` | User lost reports and status |
| `claims` | Item claims, identifying answers, match/review state |
| `pickups` | Claim QR token, schedule, scan time, verifier |
| `sms_logs` | Intended SMS delivery tracking |
| `audit_trail` | Action, actor, details, IP, user agent, timestamp |

Representative statuses:

- Found item: `unclaimed`, `pending_verification`, `claimed`, `disposed`
- Lost item: `searching`, `matched`, `resolved`
- Claim: `pending`, `manual_review`, `approved`, `rejected`
- User: `active`, `blocked`

Reference designs also show concepts such as closed reports, returned items,
verification steps, notification states, report IDs, return IDs, and issue
reporting. Reconcile those concepts with the schema before implementing UI
that relies on them.

### Schema drift that must be resolved

`database/retrieva_db.sql` and current PHP include fields that
`database/schema.sql` does not fully reproduce:

- Login lockout fields on `users`
- `user_agent` on `audit_trail`

A fresh install using only `schema.sql` can therefore break current login
lockout or audit behavior. Establish one canonical migration/schema path before
adding dashboard tables or columns.

## 11. Existing backend endpoints

| Endpoint | Purpose |
|---|---|
| `database/login.php` | Password verification, lockout, email-code handoff |
| `database/totp_verify.php` | Login/password-reset code verification |
| `database/logout.php` | Session logout |
| `database/forgot_password.php` | Password-reset email challenge |
| `database/save_password.php` | Reset/first-time password |
| `database/change_password.php` | Authenticated password change |
| `database/save_student_id.php` | Student onboarding |
| `database/setup_totp.php` | Authenticator-app TOTP setup/verify/disable |
| `database/search.php` | Role-scoped global search |
| `database/google_oauth_redirect.php` | Begin Google OAuth |
| `database/google_oauth_callback.php` | Complete Google OAuth |

Current domain CRUD is mainly embedded in dashboard PHP pages. There is no
complete backend API for:

- Matching suggestions
- File/photo upload and OCR
- Claim evidence/challenge workflows
- Pickup QR generation/scanning
- Notifications
- User administration
- Analytics/report exports
- Reading/exporting audit logs
- SMS integration

Do not create frontend-only buttons for these workflows without implementing
and authorizing the corresponding backend behavior.

## 12. Security and data-integrity warnings

Do not include actual credential values in documentation, chat responses,
commits, or screenshots.

Known issues:

1. `database/oauth_config.php` contains hard-coded Google OAuth credentials.
2. `database/mailer.php` contains hard-coded SMTP credentials and local
   certificate-verification workarounds.
3. `database/retrieva_db.sql` contains sensitive development data, including
   user/audit/authentication-related records.
4. `database/db.php` uses the normal local XAMPP root/empty-password setup.
5. The active `C:\xampp\htdocs\Retrieva` folder does not itself contain Git
   metadata; version history is in `Retrieva-backup\Retrieva`.

Before any public deployment:

- Rotate OAuth and SMTP credentials.
- Move secrets into environment/local configuration excluded from Git.
- Remove SSL-verification bypasses.
- Exclude sensitive SQL dumps from public repositories.
- Use a non-root database user and strong password.
- Require HTTPS and secure-cookie settings.
- Verify all pages and mutations enforce role and ownership checks.

### Authentication model issue

Email login/reset codes and authenticator-app TOTP currently share confusing
terminology, and login behavior can overwrite the same user TOTP-secret field
used by authenticator setup. Separate email OTP challenge state from the
authenticator-app secret before extending 2FA behavior.

## 13. Implementation constraints

### Backend and authorization

- Keep `database/db.php` as the shared source for DB/session/CSRF helpers unless
  an explicit architectural migration is approved.
- Use prepared statements for all user-controlled values.
- Call role guards on protected pages and mutating operations.
- For Client/User records, verify ownership on the server.
- Validate CSRF tokens on same-page POST mutations.
- Keep JSON response shapes consistent for existing JavaScript.
- Write relevant mutations to `audit_trail`.

### Frontend

- Reuse `assets/theme.css`.
- Preserve visible keyboard focus.
- Use semantic headings, labels, tables, buttons, and links.
- Mark purely decorative graphics as hidden from assistive technology.
- Respect `prefers-reduced-motion`.
- Keep responsive behavior at desktop, tablet, and mobile widths.
- Avoid duplicating entire Admin/User shells; compose shared components with
  role-specific navigation and content.
- Add reusable patterns for status pills, filter bars, item cards, detail
  drawers, steppers, empty states, and pagination.

### Privacy

- Do not expose identifying found-item details that would help a false claimant.
- Mask sensitive public item features as indicated by the Client reference.
- Protect student IDs, claim answers, QR tokens, audit metadata, and contact
  information.
- Never place authorization decisions only in JavaScript.

## 14. Recommended implementation sequence

### Phase 0 — stabilize foundations

1. Back up files and database.
2. Put the canonical active project under source control or deliberately sync
   it with the Git-backed backup.
3. Reconcile `schema.sql` with `retrieva_db.sql`.
4. Define final role capabilities for Admin, Security, Professor, and Student.
5. Define missing states/entities: notifications, matches, returned items,
   report identifiers, claim verification steps, QR lifecycle.

### Phase 1 — shared dashboard shell

1. Rebuild sidebar/header to match references.
2. Preserve `_bootstrap.php`, session guards, and role-aware navigation.
3. Create reusable UI primitives: KPI cards, status pills, filter bar, tabs,
   table wrapper, item card, drawer, stepper, modal, pagination, toast.
4. Verify the shell with one Admin and one Client/User account.

### Phase 2 — existing workflows first

1. Admin Dashboard (`1.png`)
2. User Dashboard (`12.png`)
3. Admin Lost Reports (`2.png`) and User/My Reports (`13.png`, `15.png`)
4. Admin Found Items (`3.png`) and User Found Items (`14.png`)
5. Admin Claims (`5.png`) and My Claims (`16.png`)
6. Split personal User Settings (`18.png`) from Admin System Settings (`11.png`)

Reuse existing queries and mutations while replacing the presentation.

### Phase 3 — missing domain workflows

1. Matching Center (`4.png`)
2. QR Pickup Verification (`6.png`)
3. Returned Items (`7.png`)
4. Users (`8.png`)
5. Reports & Analytics (`9.png`)
6. Audit Logs (`10.png`)
7. Notifications (`17.png`)

Each screen requires an explicit database/API design before frontend wiring.

### Phase 4 — integration and hardening

1. Photo upload, validation, storage, and privacy masking.
2. Matching rules/scoring and staff review.
3. QR generation, expiration, scanning, and replay prevention.
4. Real notification events and read states.
5. Export/report generation.
6. Security review, accessibility review, responsive testing, and end-to-end
   role testing.

## 15. Verification checklist

For every dashboard increment:

- [ ] PHP syntax passes.
- [ ] Relevant SQL/query behavior is tested against `retrieva_db`.
- [ ] Logged-out users return to `auth/login.php`.
- [ ] Allowed roles can access the route.
- [ ] Disallowed roles cannot access it by entering the URL directly.
- [ ] Client/User queries cannot read or mutate another user’s records.
- [ ] CSRF is validated for state-changing forms.
- [ ] JSON endpoints return the expected status and shape.
- [ ] Desktop, tablet, and mobile layouts are usable.
- [ ] Keyboard focus order and visible focus work.
- [ ] Reduced-motion preference is respected.
- [ ] Empty, loading, success, validation, and server-error states are handled.
- [ ] No secret or sensitive claim/QR/audit data appears in the UI or logs.
- [ ] Shared shell changes are tested for both Admin and Client/User sides.

## 16. Open decisions for the product owner

Ask before making irreversible schema or workflow assumptions:

1. Exact Admin versus Security permissions.
2. Exact Professor versus Student differences.
3. Whether notifications are in-app only or also email/SMS.
4. Whether found-item photos are public, blurred, or hidden by role/status.
5. Matching algorithm rules and whether automated scores are advisory only.
6. Claim evidence fields and who can view them.
7. Pickup QR expiration, rescan, cancellation, and manual fallback rules.
8. Returned-item retention/disposal policy.
9. Required analytics/export formats.
10. Scope of Admin settings that should be database-configurable.
11. Final design of the standalone Log Found Item page.

## 17. Important path index

```text
C:\xampp\htdocs\Retrieva
C:\xampp\htdocs\Retrieva\PROJECT_CONTEXT.md
C:\xampp\htdocs\Retrieva\System Refence for front end in dashboard
C:\xampp\htdocs\Retrieva\System Refence for front end in dashboard\Admin side
C:\xampp\htdocs\Retrieva\System Refence for front end in dashboard\User side
C:\xampp\htdocs\Retrieva\assets\theme.css
C:\xampp\htdocs\Retrieva\auth\login.php
C:\xampp\htdocs\Retrieva\auth\auth.js
C:\xampp\htdocs\Retrieva\dashboard\_bootstrap.php
C:\xampp\htdocs\Retrieva\dashboard\rbac.php
C:\xampp\htdocs\Retrieva\dashboard\components\sidebar.php
C:\xampp\htdocs\Retrieva\dashboard\components\header.php
C:\xampp\htdocs\Retrieva\dashboard\styles.css
C:\xampp\htdocs\Retrieva\database\db.php
C:\xampp\htdocs\Retrieva\database\schema.sql
C:\xampp\htdocs\Retrieva\database\retrieva_db.sql
C:\xampp\htdocs\Retrieva-backup\Retrieva
```

## 18. Suggested prompt for the next agent

```text
Read C:\xampp\htdocs\Retrieva\PROJECT_CONTEXT.md first.

Use C:\xampp\htdocs\Retrieva as the canonical active project. Do not inspect or
edit vendor. Before changing a dashboard screen, inspect its numbered PNG under
System Refence for front end in dashboard. Red/Admin references are 1–11 and
blue/Client/User references are 12–18.

Preserve the existing PHP/MySQL authentication, sessions, routes, role checks,
CSRF protection, and backend behavior. Reuse assets/theme.css and shared
dashboard components. Do not use fake data where real database data is
available. Implement one reviewable workflow at a time, verify both role
families, and ask before deciding unresolved role, privacy, matching, QR, or
notification rules.
```

---

Last prepared from the active localhost project and its dashboard reference
images on September 28, 2026.
