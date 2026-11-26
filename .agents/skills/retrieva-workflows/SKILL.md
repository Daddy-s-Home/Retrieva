---
name: retrieva-workflows
description: "Use for Retrieva campus lost-and-found domain workflows: found items, lost item reports, zero-knowledge masked-feature claims, single-use QR pickups, @umak.edu.ph Google OAuth, TOTP 2FA, PHPMailer, Pusher notifications, and audit trail."
---

# Retrieva Workflows

Domain rules and architecture for **Retrieva — Campus Lost and Found Platform** (University of Makati Security Office).

## Tech Stack (Strict)

- **Native PHP >= 8.0** (no Laravel, no MVC framework) running on XAMPP Apache.
- **MySQL / MariaDB** (`retrieva_db`, `utf8mb4_unicode_ci`, `InnoDB`) accessed via PDO (`database/db.php`).
- **Composer dependencies** (`composer.json`):
  - `league/oauth2-google` (`^5.0`) — Google OAuth SSO restricted to `@umak.edu.ph`.
  - `phpmailer/phpmailer` (`^7.1`) — SMTP email delivery for TOTP / security codes (`database/mailer.php`).
  - `pusher/pusher-php-server` (`^7.3`) — Real-time notifications.
- **Frontend**: Static HTML/CSS/JS + PHP views in `auth/`, `dashboard/`, and `assets/`.

## Core Domain Entities (`database/schema.sql`)

1. **`users`**:
   - Roles: `admin`, `security`, `professor`, `student` (default `student`).
   - Auth providers: `local` or `google` (`ALLOWED_EMAIL_DOMAIN = 'umak.edu.ph'`).
   - `student_id` is populated for `student` accounts via `database/save_student_id.php`.
   - Supports optional password setup (`password_is_set`, `skip_password_prompt`) and TOTP 2FA (`totp_secret`, `totp_enabled`).
2. **`totp_challenges`**:
   - Short-lived hashed codes (`code_hash`) with `purpose` (`login` or `password_reset`), `expires_at`, and `consumed_at`.
3. **`found_items`**:
   - Logged by `security` or `admin` (`logged_by`).
   - Categories: `Electronics`, `Clothing`, `IDs & Cards`, `Accessories`, `Books & Papers`, `Others`.
   - Stores `extracted_text` and `masked_features` (JSON) used to generate claim challenges.
   - Status lifecycle: `unclaimed` -> `pending_verification` -> `claimed` | `disposed`.
4. **`lost_items`**:
   - Filed by `student` or `professor` (`reported_by`).
   - Status lifecycle: `searching` -> `matched` -> `resolved`.
5. **`claims` (Zero-Knowledge Claim Challenges)**:
   - Claimants answer `challenge_questions` derived from `masked_features` without seeing the original `photo_path` or unmasked metadata.
   - Stores `claimant_answers` (JSON), `match_score`, `reviewed_by`, and status: `pending` -> `manual_review` | `approved` | `rejected`.
6. **`pickups`**:
   - Single-use `qr_token` generated upon claim approval, verified by `security` (`verified_by`, `scanned_at`).
7. **`sms_logs` & `audit_trail`**:
   - Track SMS notifications and security-relevant user actions (`user_id`, `action`, `details`, `ip_address`).

## Implementation Rules

- Never introduce Laravel or unrelated frameworks; keep endpoints in `database/` and views in `auth/` and `dashboard/`.
- Never expose `found_items.photo_path`, `extracted_text`, or unmasked `masked_features` to claimants before claim approval.
- Log sensitive actions (logins, password changes, claim approvals/rejections, QR pickup scans) to `audit_trail`.
