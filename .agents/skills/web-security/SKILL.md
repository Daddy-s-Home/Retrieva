---
name: web-security
description: "Use for defensive PHP security review, OWASP risks, authentication, authorization, CSRF, XSS, SQL injection, file uploads, secrets, API security, and secure coding in Retrieva."
---

# Web Security

## Scope

Perform defensive, scoped security review for Retrieva's native PHP codebase. Do not execute destructive testing or claim a system is secure without evidence.

## Review Areas

- Input validation and output encoding (`h()` from `database/db.php`)
- Authentication, sessions (`start_session()`), password storage (`PASSWORD_BCRYPT`), Google OAuth (`ALLOWED_EMAIL_DOMAIN = 'umak.edu.ph'`), and `totp_challenges` lifecycle
- Authorization at PHP page and `database/` endpoint boundaries (`require_login()`, `require_role()`, `dashboard/rbac.php`)
- IDOR and record ownership (`reported_by`, `claimant_id`, `user_id`)
- Zero-knowledge claim protection (do not leak `found_items.photo_path` or unmasked `masked_features` to unapproved claimants)
- SQL injection (use PDO prepared statements with `ATTR_EMULATE_PREPARES => false`)
- CSRF (`csrf_field()`, `verify_csrf()`) and XSS prevention
- Safe file uploads (validate MIME/content, size, and storage path; never trust file names or extensions)
- Secret hygiene (avoid committing real SMTP passwords or OAuth secrets; keep backups/dumps/metadata out of web-accessible paths)

## Native PHP Rules

- Always use parameterized PDO queries via `get_db()`.
- Escape HTML output with `h()` according to context.
- Check `require_login()` / `require_role()` before fetching or modifying sensitive resources.
- Log security-sensitive actions to `audit_trail`.

## Review Output

1. Summary
2. Findings ordered by severity and confidence
3. Affected files and lines
4. Exploit scenario
5. Recommended minimal fix
6. Validation check
