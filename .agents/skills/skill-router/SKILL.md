---
name: skill-router
description: "Route requests to Retrieva project-specific PHP, frontend, MySQL, security, RBAC, Retrieva workflows, documentation, planning, debugging, or project-memory skills. Use before action when the task spans multiple areas."
---

# Skill Router

Select only skills that are directly relevant. Do not load every skill.

## Routing Table

| Request or task | Skill |
|---|---|
| Feature implementation plan or ordered coding checklist | `concise-planning` |
| Bug, test failure, regression, or unexpected behavior | `systematic-debugging` |
| Native PHP endpoints, sessions, PDO, CSRF, OAuth, PHPMailer, Pusher, or Composer | `php-backend` |
| HTML, CSS, vanilla JavaScript, PHP views, responsive UI, accessibility, or UI states | `frontend-uiux` |
| Mobile, tablet, phone, touch behavior, narrow viewport, reflow, or device testing | `mobile-web-responsive` |
| MySQL schema, SQL files, imports, indexes, constraints, foreign keys, or PDO queries | `mysql-database` |
| Defensive security review, authorization, XSS, SQL injection, CSRF, uploads, or secrets | `web-security` |
| Lost & found items, zero-knowledge claims, QR pickups, `@umak.edu.ph` OAuth, TOTP, or audit trail | `retrieva-workflows` |
| Role permissions (`admin`, `security`, `professor`, `student`), RBAC helpers, or endpoint guards | `rbac-access-control` |
| README or project documentation | `readme-documentation` |
| Preserve project decisions, conventions, progress, or known issues across sessions | `project-memory` |

## Routing Rules

1. Read `.agents/memory/PROJECT_MEMORY.md` at the start of multi-session or project-wide work.
2. Use `php-backend` for all PHP work — Retrieva uses native PHP `>=8.0` without Laravel.
3. Combine `frontend-uiux` and `mysql-database` with `php-backend` when a feature crosses those layers.
4. Combine `web-security` with any PHP, authentication, upload, API, or SQL task.
5. Use `retrieva-workflows` for domain behavior and `rbac-access-control` for role permissions before implementing protected records.
6. Use `mobile-web-responsive` for every browser-facing layout and device adaptation; it complements `frontend-uiux`.
7. Use `systematic-debugging` before proposing any bug fix.
8. Use `project-memory` after significant decisions so future sessions can recover them.
9. Prefer existing project conventions over external examples.
10. Do not invoke offensive-security, penetration-testing, or destructive workflows without explicit authorization and scope.

## Context Summary

Before acting, return a short internal routing decision:

- Primary skill:
- Supporting skills:
- Framework/runtime: Native PHP >= 8.0 (XAMPP), MySQL/MariaDB, HTML/CSS/JS
- Validation target:
- Memory loaded:
