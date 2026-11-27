---
name: skill-router
description: "Route requests to project-specific PHP, frontend, MySQL, security, RBAC, documentation, planning, debugging, or project-memory skills for Retrieva. Use before action when the task spans multiple areas."
---

# Skill Router

Select only skills that are directly relevant. Do not load every skill.

## Routing Table

| Request or task | Skill |
|---|---|
| Feature implementation plan or ordered coding checklist | `concise-planning` |
| Bug, test failure, regression, or unexpected behavior | `systematic-debugging` |
| Framework-agnostic PHP, sessions, PDO, request handling, APIs, CLI | `php-backend` |
| HTML, CSS, JavaScript, responsive UI, design systems, accessibility, or UI states | `frontend-uiux` |
| Mobile web, tablet, phone, touch behavior, narrow viewport, reflow, or device testing | `mobile-web-responsive` |
| MySQL/MariaDB schema, SQL files, imports, dumps, indexes, constraints, or optimization | `mysql-database` |
| Defensive security review, authorization, CSRF, XSS, SQL injection, uploads, secrets, or hardening | `web-security` |
| Role permissions (`admin`, `security`, `professor`, `student`), ownership, or authorization checks | `rbac-access-control` |
| Lost/found reporting, matching, claim verification, QR pickup, return lifecycle, or shell/endpoint flow | `retrieva-workflows` |
| README or project documentation | `readme-documentation` |
| Preserve project decisions, conventions, progress, or known issues across sessions | `project-memory` |

## Routing Rules

1. Read `.agents/memory/PROJECT_MEMORY.md` at the start of multi-session or project-wide work.
2. Use `php-backend` for all server-side PHP (`auth/`, `dashboard/`, `database/`) tasks.
3. Combine `frontend-uiux` and `mysql-database` with `php-backend` when a feature crosses those layers.
4. Combine `web-security` with any authentication, upload, API, SQL, or session task.
5. Use `rbac-access-control` before implementing or modifying role-protected pages, endpoints, or data visibility.
6. Use `retrieva-workflows` when modifying lost/found/match/claim/pickup/return flows or dashboard shell interactions.
7. Use `mobile-web-responsive` for every browser-facing layout and device adaptation; it complements `frontend-uiux`.
7. Use `systematic-debugging` before proposing any bug fix.
8. Use `project-memory` after significant decisions so future sessions can recover them.
9. Prefer existing Retrieva project conventions over external examples.
10. Do not modify `README.md` unless explicitly requested by the user.

## Context Summary

Before acting, return a short internal routing decision:

- Primary skill:
- Supporting skills:
- Framework/runtime:
- Validation target:
- Memory loaded:

