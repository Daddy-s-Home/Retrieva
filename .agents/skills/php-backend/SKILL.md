---
name: php-backend
description: "Use for Retrieva's framework-neutral PHP 8+ backend development, page-per-route handlers, PDO/MySQL, sessions, auth, APIs, Composer packages, and error handling."
---

# PHP Backend

## Scope

Use this skill for Retrieva's server-side PHP 8+ monolith across `auth/`, `dashboard/`, and `database/` (`db.php`, `admin/`, `client/`, mail/SMS/OAuth/TOTP scripts).

## Backend Standards

- Follow PSR-12 style and keep functions small and explicit.
- Reuse `database/db.php` for the shared PDO connection, session initialization, CSRF helpers (`csrf_token()`, `csrf_field()`, `verify_csrf()`), auth guards (`require_login()`, `require_role()`, `require_login_page()`, `require_role_page()`), and `log_audit()`.
- Reuse `dashboard/_bootstrap.php` for dashboard page authentication, role resolution, and user context.
- Use PDO prepared statements for all database operations.
- Validate Content-Type, required fields, data types, lengths, enums, and file uploads at request boundaries.
- Enforce server-side authorization on every protected page, module payload, and action endpoint (`database/admin/`, `database/client/`).
- Return consistent HTTP status codes and structured JSON or HTML responses.
- Never expose database credentials, OAuth secrets, stack traces, or internal paths in production responses.
- Use `password_hash()` / `password_verify()` and secure session cookie settings.
- Use database transactions (`beginTransaction()`, `commit()`, `rollBack()`) for multi-table mutations (e.g., claim approval + pickup token + audit log).
- Preserve existing Composer dependencies (`league/oauth2-google`, `phpmailer/phpmailer`) and never manually edit `vendor/`.

## Validation

- Run syntax checks on modified PHP files: `php -l <file>`
- Verify SQL behavior against `retrieva_db` schema definitions.
- Verify authorization with authenticated, unauthenticated, and cross-role cases.

