---
name: systematic-debugging
description: "Use for bugs, test failures, regressions, unexpected behavior, PHP exceptions, SQL/PDO errors, browser JS errors, and failed integrations."
---

# Systematic Debugging

## Iron Rule

Investigate and identify the root cause before proposing or applying a fix.

## Workflow

1. Read complete error messages, PHP/Apache logs, and stack traces.
2. Reproduce the failure with the smallest reliable case.
3. Inspect recent relevant changes, configuration, PHP/MySQL versions, and environment differences.
4. Trace data across browser JS, PHP views/endpoints, PDO/SQL, filesystem, and external services (Google OAuth, PHPMailer SMTP, Pusher).
5. Compare failing behavior with a nearby working implementation.
6. Form one specific hypothesis and test it with a minimal change.
7. Fix the source rather than masking the symptom.
8. Re-run `php -l` and the reproduction case to verify the fix.

## Evidence to Preserve

- Exact steps and input
- Expected and actual output
- Relevant exception, HTTP status, and stack trace
- PHP/XAMPP/MySQL runtime versions
- Database and environment configuration without secrets
- Diff and recent changes

Source: adapted from the Antigravity [systematic-debugging skill](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/systematic-debugging/SKILL.md).
