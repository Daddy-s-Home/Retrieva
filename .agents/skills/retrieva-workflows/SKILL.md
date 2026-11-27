---
name: retrieva-workflows
description: "Use for Retrieva's lost/found reporting, matching center, claim submission and verification, QR pickup, return confirmation, dashboard shell interactions, and the full item lifecycle state machine."
---

# Retrieva Workflows

## Frontend Shell & Design Pattern

### Design Tokens (`assets/theme.css`)
- Navy: `--c-navy: #003276` (sidebar/primary), `--c-navy-dark: #002554`
- Gold: `--c-gold: #F5A623` (active states, CTA), `--c-gold-soft: #FEEFC4`
- Semantic: `--c-success: #17A673`, `--c-danger: #DC3545`, `--c-info: #2E6FF2`, `--c-purple: #7C5CFC`
- Shape: `--radius-sm: 8px`, `--radius-md: 14px`, `--radius-lg: 20px`, shadows (`--shadow-sm`, `--shadow-card`, `--shadow-pop`)
- Typography: `"Inter"`, `"Segoe UI"`, system-ui

### Dual Server-Rendered Shells
- **Admin shell** (`dashboard/admin/page.php`): roles `admin` / `security`. Loads `Chart.js` v4, `admin.css`, per-module CSS. Navigation badge on `claims` for pending count.
- **Client shell** (`dashboard/client/page.php`): roles `professor` / `student`. Loads `client.css`, per-module CSS, `#client-drawer` (right-side detail panel), `qrcode.js`. Navigation badge on `notifications` for unread count.
- Both shells: `meta[name=csrf-token]`, `body[data-page][data-role]`, topbar (search, user menu, live clock), collapsible sidebar.

### Frontend JS Architecture (`dashboard/client/client.js`, `dashboard/admin/admin.js`)
- **`window.RetrievaWarm`**: PHP injects initial module payload at page load; JS caches it to avoid a redundant first fetch.
- **`retrieva:paint` event**: Dispatched after each module render so module-specific JS (charts, QR scanner, etc.) can reinitialize.
- **Navigation**: Client-side `fetch` requests `database/client/endpoint.php` or `database/admin/endpoint.php` with `X-CSRF-Token` and `X-Requested-With: fetch`, receives `{success, html}` JSON, swaps `#client-module` innerHTML.
- **Actions**: Forms or JS `fetch` POST to `database/client/actions.php` / `database/admin/actions.php` with `csrf_token` field or `X-CSRF-Token` header; on `success` shows toast, on failure shows error. Falls back to form POST redirect.
- **Drawer**: `#client-drawer` / `#client-drawer-body` used for item detail panels. Opened via `data-open-drawer`, closed via `data-close-drawer`.

---

## Backend Bootstrap & Action Pattern

### Bootstrap (`dashboard/_bootstrap.php`)
Included at the top of every dashboard page:
1. `vendor/autoload.php` (Composer deps including Pusher PHP SDK)
2. `database/db.php` (PDO, session, CSRF, auth guards, `assign_public_code()`, `log_audit()`)
3. `dashboard/rbac.php` (`RETRIEVA_ADMIN_ROLES`, `RETRIEVA_CLIENT_ROLES`, `role_can()`, `role_is_admin_side()`)
4. Pusher constants + `notify_channel(string $channel, string $event, array $data)` for real-time push
5. `require_login_page()` → fetches `$user` row → resolves `$role`, `$avatarSrc`, `$currentPage`

### Action Handler Pattern
Both `database/client/actions.php` and `database/admin/actions.php` follow:
```
guard()           → require_role(RETRIEVA_*_ROLES) → 401/403 JSON if not authenticated
verify_csrf()     → reads csrf_token from POST body or X-CSRF-Token header
match ($action)   → dispatches to named function
PDO transaction   → beginTransaction() / commit() / rollBack() on exception
client_notify()   → inserts to notifications + Pusher trigger
log_audit()       → inserts to audit_trail (user_id, action, details, ip, user_agent)
finish()          → JSON {success, message, redirect} or session flash + Location redirect
```
- Both shells also use `assign_public_code(string $table, int $id)` from `db.php` to generate `LR-/F-/CL-` codes after insert.
- Photos saved via `retrieva_save_photos(string $type, int $id, array $input)` → `uploads/lost/` or `uploads/found/` → `item_images` table.

---

## Item Lifecycle State Machine

### 1. Lost Report (`lost_items`, code `LR-YYYY-###`)

| Status | Trigger | Actor |
|---|---|---|
| `searching` | `create_report` (client) | `professor` / `student` |
| `matched` | `confirm_match` (admin) | `admin` / `security` |
| `resolved` | `confirm_pickup` (admin) | `admin` / `security` |
| `closed` | `update_lost` with `status=closed` | `admin` |

- Editable / deletable by owner only while `status = 'searching'`.
- `is_public` flag controls campus-wide visibility (driven by `users.share_lost_reports`).

### 2. Found Item (`found_items`, code `F-YYYY-###`)

| Status | Trigger |
|---|---|
| `unclaimed` | `create_found` (admin logs item) |
| `pending_verification` | `create_claim` (atomic lock — prevents double-claiming) |
| `claimed` | `approve_claim` |
| `returned` | `confirm_pickup` |
| `disposed` | admin manual update |

- `public_summary` shown to client browsing; `masked_features` / `extracted_text` stored for internal matching.

### 3. Matching (`item_matches`)

| Status | Trigger |
|---|---|
| `potential` / `needs_review` | `admin_refresh_matches()` auto-suggestion |
| `confirmed` | `confirm_match` → sets `lost_items.matched_found_item_id` + `matched_at` |
| `no_match` | `reject_match` |

- `notify_match` sends in-app notification to the original reporter without changing match status.

### 4. Claims (`claims`, code `CL-YYYY-###`)

| Status | Trigger | Actor |
|---|---|---|
| `pending` | `create_claim` | `professor` / `student` |
| `manual_review` | `request_claim_info` | `admin` / `security` |
| `approved` | `approve_claim` → creates `pickups` row + `qr_token` | `admin` / `security` |
| `rejected` | `reject_claim` (requires `rejection_reason`) → reverts `found_items` to `unclaimed` if no other active claims | `admin` / `security` |
| _(deleted)_ | `withdraw_claim` while `pending` / `manual_review` → reverts `found_items` to `unclaimed` | claimant |

### 5. QR Pickup & Return Verification (`pickups`, return code `RT-YYYY-###`)

| Status | Trigger |
|---|---|
| `pending` | Auto-created on `approve_claim` with random `qr_token` (32 hex chars) |
| `verified` | `confirm_pickup` by scanning `qr_token` → sets `scanned_at`, `verified_by`, `return_code` → `found_items = returned`, linked `lost_items = resolved` |

- `report_return_issue` stores a `condition_note` on a verified pickup without changing status.
- Claimant receives Pusher notification on approved claim, item returned.

---

## Key Security Invariants for Lifecycle Changes

- All status transitions happen inside `PDO::beginTransaction()` / `commit()`.
- `found_items` locking on claim (`unclaimed → pending_verification`) is a `rowCount() === 1` check to prevent race conditions.
- Pickup QR scan is locked with `FOR UPDATE` to prevent double-verification.
- Record ownership is always checked server-side before mutations (client owner check on `lost_items`; admin role for all admin actions).

