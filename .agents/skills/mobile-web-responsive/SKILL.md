---
name: mobile-web-responsive
description: "Use for responsive mobile and tablet web design in Retrieva, phone and tablet layouts, touch targets, viewport testing, CSS breakpoints, mobile navigation, reflow, accessibility, and performance."
---

# Mobile and Tablet Web Responsive Design

## Scope

Use this skill for Retrieva browser views (`auth/`, `dashboard/admin/`, `dashboard/client/`) that must work on desktop, laptop, tablet, and mobile devices.

## Responsive Workflow

1. Inspect existing PHP-rendered HTML views, `assets/theme.css`, `dashboard/*.js`, components, breakpoints, and layout containers.
2. Test at desktop, laptop, tablet portrait/landscape, and phone portrait/landscape widths.
3. Start with the smallest usable layout, then progressively add density for wider screens.
4. Preserve content order, keyboard order, form submission, navigation, and authorization behavior at every width.
5. Use horizontal reflow or controlled overflow only where a table genuinely requires it.
6. Add loading, empty, validation, permission, success, and error states for each viewport.
7. Verify that the final implementation has no clipped controls, inaccessible menus, overlapping text, or unusable forms.

## Required Viewport Checks

- 320px phone minimum
- 360px to 430px modern phones
- 768px tablet portrait
- 1024px tablet landscape or small laptop
- 1366px laptop
- 1920px desktop

## Layout Rules

- Use CSS Grid and Flexbox intentionally.
- Use `min-width: 0` on grid or flex children that contain long text, tables, item titles, or location names.
- Avoid fixed heights that clip content.
- Avoid permanently hidden desktop-only actions.
- Collapse secondary navigation, filters, toolbars, or details progressively without removing functionality.
- Tables may become cards, scroll containers, grouped rows, or detail drawers, but must retain labels and actions.

## Touch and Input

- Use at least approximately 44px by 44px touch targets for primary controls.
- Keep spacing between adjacent actions; separate destructive actions from primary actions.
- Do not rely on hover, right-click, small text, or gesture-only controls.
- Keep focus visible for keyboard users and large focus targets for touch users.
- Prevent zoom failures; avoid disabling browser zoom.

## Mobile Navigation

- Use clear back, close, menu, and section-navigation behavior for the collapsible sidebar and detail drawers.
- Keep the current page and role context visible.
- Ensure menus, modals, and drawers are keyboard accessible and close predictably.
- Do not hide essential report, claim, QR pickup, approval, or logout actions behind decorative menus.

## Retrieva Module Considerations

- Dashboards: summarize key KPIs first; adapt charts and tables cleanly for narrow screens.
- Lost Reports & Found Items: keep item cards, status pills, filters, and detail drawers readable without horizontal page overflow.
- Matching Center & Claims: keep side-by-side comparisons and verification checklists legible by stacking on small viewports.
- QR Pickup Verification: keep scanner viewport, pickup queue, and confirm-pickup controls accessible on mobile/tablet.
- My Reports & My Claims: ensure progress steppers and pickup QR displays scale cleanly.
- Audit Logs & Reports: use responsive filters and expandable detail drawers rather than unbounded horizontal tables.

## Validation

Before completion, test:

- No horizontal page overflow
- Readable text without zooming
- All controls reachable by touch and keyboard
- Menus, drawers, modals, dropdowns, pagination, uploads, and forms work
- Tables retain labels and actions
- Images, charts, and QR codes reflow or scale correctly
- Existing desktop behavior is not regressed
- Reduced-motion and zoom settings are respected

Inspired by the Antigravity `mobile-design` concept, adapted for responsive PHP/HTML/CSS/JavaScript web applications:
https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/mobile-design/SKILL.md

