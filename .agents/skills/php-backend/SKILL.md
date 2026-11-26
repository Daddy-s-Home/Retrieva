---
name: php-backend
description: "Use for Retrieva native PHP (>=8.0) backend development, endpoints in database/, PDO/MySQL, sessions, CSRF, Composer packages (Google OAuth, PHPMailer, Pusher), and validation."
---

# PHP Backend

## Scope

Retrieva is built with **native PHP >= 8.0** running on XAMPP Apache (no Laravel or external MVC framework). Keep all backend logic in native PHP using the project's existing helpers.

## Project Helpers (`database/db.php`)

- `get_db(): PDO` — shared PDO connection (`retrieva_db`, `utf8mb4`, `ERRMODE_EXCEPTION`, `FETCH_ASSOC`, `EMULATE_PREPARES => false`).
- `start_session(): void` — starts session with `httponly: true`, `samesite: 'Lax'`.
- `h(?string $value): string` — HTML escaping via `htmlspecialchars(..., ENT_QUOTES, 'UTF-8')`.
- `csrf_token(): string`, `csrf_field(): string`, `verify_csrf(?string $submitted): bool`.
- `json_out(array $payload, int $code = 200): void` — structured JSON response + `exit`.
- `require_login(): array` and `require_role(array $allowed_roles): array`.

## Backend Standards

- Use `declare(strict_types=1);` in PHP files.
- Always use PDO prepared statements with bound parameters (`?` or `:name`); never interpolate user input into SQL.
- Validate required fields, types, lengths, enums, and uploaded files at the boundary.
- Enforce `verify_csrf()` on state-changing HTML form posts and `require_login()` / `require_role()` on protected endpoints.
- Use `password_hash(..., PASSWORD_BCRYPT)` and `password_verify()` for passwords.
- Use Composer packages declared in `composer.json` (`vendor/autoload.php`):
  - `league/oauth2-google` (`database/oauth_config.php`, `google_oauth_redirect.php`, `google_oauth_callback.php`)
  - `phpmailer/phpmailer` (`database/mailer.php`)
  - `pusher/pusher-php-server`
- Use PDO transactions (`beginTransaction()` / `commit()` / `rollBack()`) for multi-table mutations (e.g., claim approval + pickup QR creation).

## Validation

- Run syntax checks on modified PHP files: `php -l <file>`
- Verify SQL queries and JSON responses against representative `retrieva_db` data.
- Verify authenticated, unauthenticated, and cross-role cases.
