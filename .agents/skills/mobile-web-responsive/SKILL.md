---
name: mobile-web-responsive
description: "Use for responsive mobile and tablet web design, phone and tablet layouts, touch targets, viewport testing, CSS breakpoints, mobile navigation, reflow, accessibility, and performance across desktops, laptops, tablets, and phones."
---

# Mobile and Tablet Web Responsive Design

## Scope

Use this skill for Retrieva browser pages (`auth/` and `dashboard/`) that must work on desktop, laptop, tablet, and mobile devices.

## Responsive Workflow

1. Inspect existing PHP views, `assets/theme.css`, `auth/styles.css`, `dashboard/styles.css`, `dashboard/settings.css`, and `dashboard/components/`.
2. Test at desktop, laptop, tablet portrait/landscape, and phone portrait/landscape widths.
3. Start with the smallest usable layout, then progressively add density for wider screens.
4. Preserve content order, keyboard order, form submission, navigation, and RBAC behavior at every width.
5. Use horizontal reflow or controlled overflow only where a table genuinely requires it.
6. Add loading, empty, validation, permission, success, and error states for each viewport.
7. Verify no clipped controls, inaccessible menus, overlapping text, or unusable forms.

## Required Viewport Checks

- 320px phone minimum
- 360px to 430px modern phones
- 768px tablet portrait
- 1024px tablet landscape or small laptop
- 1366px laptop
- 1920px desktop

## Layout, Touch, and Navigation Rules

- Use CSS Grid and Flexbox intentionally; set `min-width: 0` on grid/flex children containing long text or tables.
- Avoid fixed heights that clip content and avoid permanently hidden desktop-only actions.
- Use at least ~44px by 44px touch targets for primary controls with adequate spacing.
- Keep focus visible for keyboard users; do not disable browser zoom.
- Ensure sidebar/drawer navigation, modals, and dropdowns close predictably and remain keyboard accessible.

## Retrieva Module Considerations

- **Auth & TOTP (`auth/login.php`, `auth/totp.php`, `auth/forgot-password.php`)**: Keep forms, Google sign-in button, and 6-digit TOTP inputs centered and usable without horizontal scroll.
- **Dashboard & Item Tables (`found-items.php`, `lost-items.php`, `claims.php`, `pending-verifications.php`)**: Tables may become cards or scroll containers while retaining labels and action buttons.
- **Claim Challenge & QR Pickup Modals**: Ensure challenge questions, answers, and QR codes scale cleanly on 360px screens.
- **Settings (`settings.php`)**: Keep profile, password, student ID, and TOTP setup sections stacked cleanly on narrow viewports.
