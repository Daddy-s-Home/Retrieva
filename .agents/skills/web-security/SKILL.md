---
name: web-security
description: "Use for defensive PHP security review in Retrieva, OWASP risks, authentication, TOTP/OAuth, CSRF, XSS, SQL injection, file uploads, audit logging, secrets, and secure coding."
---

# Web Security

## Scope

Perform defensive, scoped security review for Retrieva's PHP 8+ codebase (`auth/`, `dashboard/`, `database/`, `uploads/`). Do not execute destructive testing or claim a system is secure without evidence.

## Review Areas

- Input validation and context-aware output encoding (`htmlspecialchars(..., ENT_QUOTES, 'UTF-8')`)
- Authentication, PHP sessions, password storage (`password_hash`/`password_verify`), TOTP MFA, and Google OAuth state/callback validation
- Authorization at page (`_bootstrap.php`, `rbac.php`) and endpoint (`database/admin/`, `database/client/`) boundaries
- IDOR and record ownership checks on lost reports, claims, pickups, and notifications
- SQL injection prevention via PDO prepared statements
- CSRF protection via `csrf_token()`, `csrf_field()`, and `verify_csrf()` on state-changing requests
- Safe file uploads in `uploads/` (size, extension, MIME/content verification, safe filenames, non-executable storage)
- Audit logging via `log_audit()` for administrative and security-sensitive actions
- Secret handling (never hardcode or commit OAuth secrets, SMTP passwords, or DB credentials)
- Error handling, cookie flags (`HttpOnly`, `SameSite`, `Secure` over HTTPS), and pagination bounds

## PHP Security Rules

- Use parameterized PDO queries; never interpolate user input into SQL.
- Escape HTML output according to context.
- Check `require_login()` / `require_role()` and `verify_csrf()` before fetching or modifying sensitive resources.
- Never trust file names, extensions, MIME headers, hidden form fields, or client-side state.
- Keep configuration secrets, SQL dumps, backups, and source control metadata inaccessible from public routes.
- Disable verbose error/stack-trace output in production.

## Review Output

1. Summary
2. Findings ordered by severity and confidence
3. Affected files and lines
4. Exploit scenario
5. Recommended minimal fix
6. Validation or regression test

Source: adapted from Antigravity [security-scanning-security-sast](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/security-scanning-security-sast/SKILL.md).

