---
name: frontend-uiux
description: "Use for Retrieva's HTML, CSS, vanilla JavaScript, PHP-rendered dashboard views, assets/theme.css design tokens, accessibility, loading and error states, and visual implementation."
---

# Frontend UI/UX

## Workflow

1. Inspect `assets/theme.css`, `dashboard/admin/page.php`, `dashboard/client/page.php`, `dashboard/components/`, and nearby module views before creating new patterns.
2. Check any relevant visual reference screens in `System Refence for front end in dashboard/` when designing or updating dashboard layouts.
3. Define clear information hierarchy and reuse Retrieva's navy/gold palette (`--c-navy`, `--c-navy-dark`, `--c-gold`, `--c-gold-soft`, semantic states) from `assets/theme.css`.
4. Use semantic HTML and accessible labels, landmarks, focus states, and keyboard behavior.
5. Implement responsive layouts with loading, empty, success, validation, and error states, using real database data (never hard-coded KPIs or mock records).
6. Keep JavaScript behavior vanilla (`dashboard/dashboard.js`, `dashboard/admin/admin.js`, `dashboard/client/client.js`, `dashboard/client/qrcode.js`, `dashboard/settings.js`, `auth/auth.js`) and minimize unnecessary state.
7. Test at desktop, tablet, and mobile viewport sizes, and verify both Admin/Security and Client/User shells after shared layout changes.
8. Load `mobile-web-responsive` before finalizing layouts used on phones or tablets.

## Implementation Rules

- Reuse `assets/theme.css` tokens and existing shell components (left sidebar, top bar, KPI cards, status pills, tabs, filters, tables, item cards, steppers, and right-side detail drawers).
- Avoid random decoration; every visual element must serve hierarchy or usability.
- Prefer native HTML, CSS, and vanilla JavaScript unless the project already includes a library.
- Preserve contrast, touch targets, visible focus, reduced-motion support, and readable typography.
- Keep client and server validation roles separate: client JS for immediate feedback, PHP endpoints for authority.
- Preserve privacy masking on public/client found-item views.

Source: adapted from the Antigravity [frontend-design skill](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/frontend-design/SKILL.md) and [javascript-pro skill](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/javascript-pro/SKILL.md).

