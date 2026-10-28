# Retrieva

Campus lost and found platform for the University of Makati. The application is a PHP monolith that serves both staff/admin workflows and student/professor user workflows from the same codebase, backed by a MySQL database and a shared front-end shell.

## Overview

Retrieva manages the end-to-end lifecycle of lost-and-found operations:

1. Users report lost items.
2. Staff log found items.
3. The system helps match reports to found inventory.
4. Claimants submit claims with identifying details.
5. Security/admin reviews and approves or rejects claims.
6. Approved claims proceed through QR pickup verification and return completion.
7. Activity is recorded in audit logs, notifications, and analytics.

The codebase is designed around a page-per-route PHP architecture, with shared server-side bootstrap logic and a rich dashboard UI built from PHP-generated HTML modules plus JavaScript-driven interactions.

## Technology Stack

- PHP 8+
- MySQL / MariaDB via PDO
- Apache via XAMPP
- JavaScript for client-side interactions and AJAX
- CSS theming from shared assets
- Composer dependencies: `league/oauth2-google`, `phpmailer/phpmailer`
- Node tooling: `live-server` and `prettier` for local front-end convenience

## High-Level System Architecture

```text
┌─────────────────────────────┐
│ Users / Browsers            │
│ - Student / Professor       │
│ - Admin / Security          │
└──────────────┬──────────────┘
               │ HTTP
               ▼
┌─────────────────────────────┐
│ PHP Web App (Apache/XAMPP) │
│ ├── auth/                   │
│ │   login, forgot password, │
│ │   TOTP, Google OAuth      │
│ ├── dashboard/              │
│ │   admin and client shells │
│ │   role-based pages        │
│ ├── database/               │
│ │   db.php + API modules    │
│ │   login, email, SMS,     │
│ │   export, reports, etc.   │
│ └── assets/                 │
│     theme.css, icons, UI    │
└──────────────┬──────────────┘
               │ PDO / MySQL
               ▼
┌─────────────────────────────┐
│ MySQL: retrieva_db          │
│ Users, items, claims,      │
│ matches, audit_trail,      │
│ notifications, reports     │
└─────────────────────────────┘
```

## Core Architectural Pattern

The app follows an MVC-like server-rendered pattern, but not a strict framework MVC. The practical structure is:

- `auth/` handles login, password reset, TOTP, and OAuth entry points.
- `dashboard/` contains the authenticated application shell and page modules.
- `database/` contains:
  - connection bootstrap (`db.php`)
  - server-side endpoint handlers for each module
  - helper libraries for admin/client queries
  - auth, email, SMS, and report generation logic
- `assets/` contains shared theme variables and static UI assets.

The important real pattern is: page requests render PHP views, while module data is typically loaded by server-side PHP logic, not by a modern SPA framework.

## Request and Page Flow

### 1. User enters the app

- `auth/login.php` is the entry page.
- If a valid PHP session already exists, the user is redirected to the dashboard.
- The login page includes a standard email/password form and a Google login button.

### 2. PHP session and security bootstrap

The central database bootstrap is in `database/db.php`.

Key behaviors:

- Creates a shared PDO connection to MySQL.
- Starts the PHP session with secure cookie parameters.
- Exposes helpers such as:
  - `csrf_token()` and `csrf_field()`
  - `verify_csrf()`
  - `require_login()`
  - `require_role()`
  - `require_login_page()`
  - `require_role_page()`
  - `log_audit()`

This means security is enforced at the server level, not only in the browser.

### 3. Dashboard bootstrap

Every dashboard screen includes `dashboard/_bootstrap.php`.

That bootstrap:

- loads `database/db.php`
- loads RBAC helpers
- validates the session
- fetches the current user record from `users`
- stores common values like `$role`, `$currentPage`, and `$avatarSrc`
- redirects invalid or stale sessions back to login

This makes every page aware of the current authenticated user and role without needing a JS auth round-trip.

### 4. Role-based access control

The RBAC model is defined in `dashboard/rbac.php`.

Roles:

- `admin`
- `security`
- `professor`
- `student`

Admin-side roles:

- `admin`, `security`

Client-side roles:

- `professor`, `student`

The app does not rely on CSS hiding alone. The role checks are enforced in PHP before pages are rendered.

## The Dashboard Architecture

The dashboard is split into two shells:

- `dashboard/admin/page.php` for admin/security pages
- `dashboard/client/page.php` for professor/student pages

Both shells use a common layout pattern:

- left sidebar navigation
- top bar with search and user menu
- main content area
- drawer / modal behavior for item detail views
- role-sensitive page modules

The navigation and page modules are mapped in:

- `dashboard/admin/prefetch.php`
- `dashboard/client/prefetch.php`

These files register a map of modules such as:

Admin modules:

- dashboard
- lost-reports
- found-items
- log-found
- matching
- claims
- pickup
- returned
- users
- reports
- audit
- settings

Client modules:

- dashboard
- lost-items
- found-items
- my-reports
- my-claims
- notifications
- settings

## Authentication, Profiles, and Session Logic

### Login flow

The login page submits credentials to the server. The application supports:

- email/password login
- Google OAuth flow
- TOTP-based MFA if enabled
- password setup prompts for accounts created via Google login

### DB-backed auth helpers

Files in `database/` that handle auth include:

- `database/login.php`
- `database/logout.php`
- `database/change_password.php`
- `database/save_password.php`
- `database/setup_totp.php`
- `database/totp_verify.php`
- `database/switch_login_factor.php`
- `database/google_oauth_redirect.php`
- `database/google_oauth_callback.php`
- `database/oauth_config.php`

These scripts coordinate with `users`, `user_sessions`, and related tables so that the application can support secure sign-in, MFA toggles, and preference persistence.

### Password and identity flow

Accounts can require:

- password configuration
- student ID save/verification
- TOTP enablement
- email and SMS notification preferences

The system also supports identity verification before claims and returns are approved.

## Server-Side Module API Pattern

The dashboard pages are backed by endpoint modules in `database/admin/` and `database/client/`.

Examples:

- `database/admin/lib.php`
- `database/client/lib.php`
- `database/admin/actions.php`
- `database/client/actions.php`

These files centralize the business logic for:

- loading module data
- executing CRUD actions
- calculating KPIs
- listing items, claims, reports, users, audit entries
- mapping actions to tables and permissions

The page shell requests a module payload, and the backend returns HTML or JSON used by the page. This keeps the app modular without forcing a separate frontend framework.

## Database Architecture

The main database bootstrap is `database/db.php`.

Schema and database artifacts live under `database/`:

- `database/schema.sql`
- `database/retrieva_db.sql`
- `database/retrieva_dbv1.sql`
- `database/retrieva_dbv2.sql`

Important domain tables include, among others:

- `users`
- `lost_items`
- `found_items`
- `claims`
- `notifications`
- `audit_trail`
- `pickup_tokens`
- `report_matches`

The system uses assigned public codes such as:

- `LR-YYYY-###` for lost reports
- `F-YYYY-###` for found items
- `CL-YYYY-###` for claims

The app also uses audit logging for administrative actions and system changes.

## User Workflow: Client Side

### Student / professor experience

The client navigation includes:

- Dashboard
- Lost Items
- Found Items
- My Reports
- My Claims
- Notifications
- Settings

### Representative client flow

1. A user browses public reporting pages.
2. A student/professor creates a lost report or views found-item listings.
3. If a matching item is found, the user can progress through claims and verification.
4. A claim can move through pending, manual review, approved, rejected, or resolved states.
5. An approved claim leads to QR pickup verification.
6. Notifications keep the user updated on status changes.
7. Settings allow editing account contact preferences, security, and notifications.

The client UI is assembled through `dashboard/client/views.php` and related module HTML templates.

## Admin Workflow: Security / Staff Side

The admin navigation includes:

- Dashboard
- Lost Reports
- Found Items
- Log Found Item
- Matching Center
- Claims
- QR Pickup Verification
- Returned Items
- Users
- Reports & Analytics
- Audit Logs
- Settings

### Representative admin flow

1. Staff review lost reports and found-item inventory.
2. Found items are logged and indexed by category and location.
3. Matching Center suggests possible connections between lost reports and found items.
4. Claims are verified for identity and item ownership.
5. Approved claims are made ready for QR pickup.
6. Pickup staff confirm return and update status to returned.
7. Audit logs capture who did what and when.
8. Reports and analytics aggregate trends for admin decision-making.

## Lost-Item and Found-Item Lifecycle

The system models an item lifecycle across multiple entity types:

### Lost reports

A lost report is created by a user and can follow statuses such as:

- pending
- matched
- resolved
- closed

The system supports report details, item attributes, and later matching to found items.

### Found items

A found-item record captures objects that have been recovered and logged by security/admin. It may later be matched against one or more lost reports and used to drive verification and return processes.

### Claims

Claims are initiated by users when they believe an item is theirs. Claims can be reviewed, approved, or rejected by staff and may require additional identity verification.

### Pickup and return

When a claim is approved:

- a pickup token or QR flow is used
- the item is verified at pickup
- the return is confirmed
- the status is updated to returned

This is implemented through the admin pickup/returned workflows and backend pickup APIs.

## Shared Front-End and Styling Model

The UI styling is built around shared design tokens in `assets/theme.css`.

The design system includes:

- navy / gold color palette
- semantic color states
- standard radii, spacing, and shadows
- form, card, and sidebar styling
- responsive dashboard layout conventions

The app reuses the same shell styling across admin and client pages instead of creating a completely separate design language for each role.

## JavaScript Behavior

The front-end uses JS for:

- client-side form validation
- dynamic toggles and UI state
- modal and drawer behaviors
- query/search interactions
- QR scanner and pickup actions
- chart rendering on dashboards

Main UI script files include:

- `dashboard/dashboard.js`
- `dashboard/client/client.js`
- `dashboard/client/qrcode.js`
- `dashboard/admin/admin.js`
- `auth/auth.js`
- `dashboard/settings.js`

## Email, Notifications, and Communication

The app includes communication infrastructure for:

- password reset emails
- Google OAuth integration
- notifications for reports and claims
- in-app notifications
- SMS support hooks

Relevant files include:

- `database/mailer.php`
- `database/sms.php`
- `database/forgot_password.php`
- `database/save_login_method.php`

## Deployment and Local Setup

This repository is intended to run in a local XAMPP environment.

### Local prerequisites

- XAMPP (Apache + PHP 8+)
- MySQL/MariaDB
- a local database named `retrieva_db`

### Local app path

The project context describes the active working source as:

```text
C:\xampp\htdocs\Retrieva
```

and the local URL is:

```text
http://localhost/Retrieva/
```

### Typical setup

```bash
# from the project root
php -S localhost:8000
```

or run through Apache/XAMPP as a normal PHP application. Ensure that:

- the project root is served by Apache
- the database is created as `retrieva_db`
- the schema is imported from `database/schema.sql` or the SQL dump in `database/retrieva_db.sql`

## Repository Structure

```text
Retrieva/
├── assets/                     shared theme and static assets
├── auth/                       login, forgot password, TOTP, OAuth UI
├── dashboard/                  admin/client PHP dashboard shells
│   ├── admin/                  admin module map and layouts
│   ├── client/                 client module map and layouts
│   ├── components/             shared UI components
│   ├── _bootstrap.php          session + user bootstrap
│   ├── rbac.php                role checks
│   ├── index.php               dashboard entry
│   └── *.php                   module pages
├── database/                   DB connection + all server-side logic
│   ├── admin/                  admin endpoints and helpers
│   ├── client/                 client endpoints and helpers
│   ├── migrations/             DB migration-related files
│   ├── db.php                  shared PDO connection and session helpers
│   ├── schema.sql              current schema
│   ├── retrieva_db.sql         DB dump
│   └── *.php                   auth, mailer, OAuth, SMS, exports
├── uploads/                    uploaded files / media storage
├── vendor/                     Composer dependencies
├── .gitattributes
├── composer.json
├── composer.lock
├── package.json
├── POLISHING.md                backlog and polish notes
├── PROJECT_CONTEXT.md         project handoff context
├── README.md                  this documentation
└── notes.md
```

## Important Process Notes from Project Context

The project includes explicit operational guidance in `PROJECT_CONTEXT.md`:

- treat the active local app as the source of truth
- preserve server-side auth, RBAC, session behavior, and database ownership rules
- inspect design references before implementing new screens
- do not hard-code fake data or KPI values
- keep admin and client experiences distinct

The repository also contains a `POLISHING.md` backlog file listing remaining improvements, especially around:

- QR scanning for pickup verification
- card alignment and layout polish
- SMS messaging for approvals/reminders
- matching logic refinements
- security-role visibility restrictions
- UI consistency between admin and client views

## Summary

Retrieva is a role-based campus lost-and-found platform built as a PHP application served by XAMPP Apache and backed by MySQL. It uses a server-rendered dashboard architecture with shared PHP bootstrapping, role-based page enforcement, modular backend endpoint logic, and shared front-end styling. The system tracks the full lost-item lifecycle from item report to matching, claim verification, QR pickup, and final return while preserving auditability and role separation.

## Quick Start

```bash
# 1. Clone or open the project in your XAMPP document root
# 2. Create the database
#    Name: retrieva_db
# 3. Import the schema
mysql -u root -p retrieva_db < database/schema.sql
# 4. Start Apache/MySQL in XAMPP
# 5. Open the app in browser
http://localhost/Retrieva/
```

## Related Files

- `PROJECT_CONTEXT.md` — local setup and product intent
- `POLISHING.md` — remaining implementation/backlog notes
- `database/schema.sql` — schema definition
- `dashboard/_bootstrap.php` — core request bootstrap
- `dashboard/rbac.php` — RBAC rules
- `database/db.php` — database connection and guard helpers
