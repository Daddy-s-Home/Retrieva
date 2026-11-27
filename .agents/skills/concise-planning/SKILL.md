---
name: concise-planning
description: "Use for coding plans, feature planning, architecture sequencing, migration planning, and atomic implementation checklists."
---

# Concise Planning

## Workflow

1. Scan the repository structure, `README.md`, relevant configuration, and nearby implementations.
2. Identify PHP, MySQL/MariaDB, Apache/XAMPP, and compatibility constraints.
3. Make reasonable assumptions for non-blocking details.
4. Ask at most two questions only when an answer blocks implementation.
5. Produce a verb-first checklist with discovery, implementation, validation, and rollback considerations.

## Plan Format

```markdown
# Plan

## Approach

## Scope
- In:
- Out:

## Action Items
- [ ] Discover...
- [ ] Implement...
- [ ] Validate...

## Validation
- [ ] Targeted checks (`php -l`, SQL, browser/API verification)
- [ ] Regression checks (admin and client shells)
- [ ] Migration or deployment safety where applicable
```

Source: adapted from the Antigravity [concise-planning skill](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/concise-planning/SKILL.md).

