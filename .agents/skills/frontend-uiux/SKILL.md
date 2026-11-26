---
name: frontend-uiux
description: "Use for Retrieva HTML, CSS, vanilla JavaScript, PHP view templates (auth/, dashboard/), responsive pages, component design, UI/UX architecture, accessibility, loading and error states, and visual implementation."
---

# Frontend UI/UX

## Project Setup

- Views are native PHP + HTML pages in `auth/` (`login.php`, `forgot-password.php`, `totp.php`) and `dashboard/` (`index.php`, `found-items.php`, `lost-items.php`, `claims.php`, `pending-verifications.php`, `settings.php`).
- Shared styling and assets live in `assets/theme.css`, `assets/icons/`, `assets/effects/`, `auth/styles.css`, `dashboard/styles.css`, and `dashboard/settings.css`.
- Client behavior uses vanilla JavaScript (`auth/auth.js`, `dashboard/dashboard.js`, `dashboard/settings.js`).
- Dev formatting: `npm run format` (`prettier --write "**/*.{html,css,js}"`).

## Workflow

1. Inspect existing styles (`assets/theme.css`, `dashboard/styles.css`, `auth/styles.css`) and `dashboard/components/` before creating new patterns.
2. Reuse existing CSS variables, layout shells, and component classes.
3. Use semantic HTML and accessible labels, landmarks, focus states, and keyboard behavior.
4. Implement loading, empty, success, validation, and error states for every interactive flow.
5. Keep JavaScript vanilla, clean, and minimal; avoid introducing heavy frontend frameworks.
6. Escape all dynamic PHP output with `h(...)` from `database/db.php` and avoid unsafe `innerHTML` with untrusted strings.
7. Load `mobile-web-responsive` before finalizing layouts used on phones or tablets.

## Implementation Rules

- Keep client and server validation roles separate: client for immediate feedback, server for authority.
- Preserve contrast, touch targets, visible focus, reduced-motion support, and readable typography.
- Avoid layout shifts and render-blocking assets.
