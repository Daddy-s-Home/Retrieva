---
name: systematic-debugging
description: "Use for bugs, regressions, unexpected behavior, PHP exceptions, PDO/SQL errors, Apache/XAMPP issues, browser JavaScript errors, and failed auth or mail/SMS integrations."
---

# Systematic Debugging

## Iron Rule

Investigate and identify the root cause before proposing or applying a fix.

## Workflow

1. Read complete error messages, PHP/Apache error logs, and stack traces.
2. Reproduce the failure with the smallest reliable case.
3. Inspect recent relevant changes, configuration, PHP/MariaDB versions, and XAMPP environment differences.
4. Trace data across browser JS, PHP page/endpoint (`auth/`, `dashboard/`, `database/`), PDO/SQL, filesystem (`uploads/`), and external services (Google OAuth, PHPMailer, SMS).
5. Compare failing behavior with a nearby working implementation in the same codebase.
6. Form one specific hypothesis and test it with a minimal change.
7. Fix the source rather than masking the symptom.
8. Re-run the reproduction and focused verification checks (`php -l`, endpoint check, and UI check).

## Evidence to Preserve

- Exact steps and input
- Expected and actual output
- Relevant exception and stack trace
- PHP/MariaDB/XAMPP versions
- Database and configuration context without secrets
- Diff and recent changes

Source: adapted from the Antigravity [systematic-debugging skill](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/systematic-debugging/SKILL.md).

