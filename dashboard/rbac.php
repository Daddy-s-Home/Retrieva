<?php
declare(strict_types=1);

/**
 * rbac.php — server-side Role-Based Access Control.
 *
 * Roles: admin, security, professor, student.
 * "admin" + "security" are the admin side of the dashboard;
 * "professor" + "student" are the client/normal-user side.
 *
 * Sidebar links (and anything else gated by role) are rendered with
 * PHP conditionals using these helpers, so a disallowed link is never
 * sent to the browser at all — not just hidden with CSS.
 */

const RETRIEVA_ADMIN_ROLES  = ['admin', 'security'];
const RETRIEVA_CLIENT_ROLES = ['professor', 'student'];

/** True if $role is in $allowedRoles. */
function role_can(string $role, array $allowedRoles): bool {
    return in_array($role, $allowedRoles, true);
}

function role_is_admin_side(string $role): bool {
    return role_can($role, RETRIEVA_ADMIN_ROLES);
}

function role_is_administrator(string $role): bool {
    return $role === 'admin';
}

function role_label(string $role): string {
    return ucfirst($role);
}
