---
name: project-memory
description: "Use to load and maintain project-specific decisions, conventions, known issues, architecture, database ownership, progress, and session continuity from the workspace memory file."
---

# Project Memory

## Memory File

Maintain `.agents/memory/PROJECT_MEMORY.md`.

## At Session Start

1. Read the memory file before architectural, database, or cross-feature work.
2. Reconcile memory with the current repository rather than assuming it is authoritative.
3. Treat sensitive values as absent unless explicitly provided in local configuration.

## Record

- Project purpose and runtime versions (PHP, MariaDB/MySQL, XAMPP)
- Frontend conventions and `assets/theme.css` design decisions
- PHP monolith architecture conventions (`auth/`, `dashboard/`, `database/`)
- MySQL/MariaDB schema ownership and SQL artifact state
- Security and RBAC constraints
- Repeated test or validation commands
- Known issues and their confirmed root causes
- Completed work and incomplete follow-up
- Architectural decisions and rejected alternatives

## Do Not Record

- Passwords, API keys, tokens, or private certificates
- Personal production data
- Large generated dumps
- Temporary guesses not confirmed by code or runtime evidence

## Update Format

Use timestamped, evidence-based entries:

```markdown
## YYYY-MM-DD
- Architecture: ...
- Convention: ...
- Known issue: ...
- Next step: ...
```

Remove or mark outdated entries instead of silently contradicting them.

Source: based on the Antigravity [memory-systems skill](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/memory-systems/SKILL.md).

