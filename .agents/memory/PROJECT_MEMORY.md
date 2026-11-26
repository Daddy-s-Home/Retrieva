# Project Memory

## Project

- Repository: **Retrieva** — Campus Lost and Found Platform (University of Makati Security Office)
- Workspace root: `c:\xampp\htdocs\Retrieva`
- Current Setup (`README.md`): Campus lost and found platform
- Stack:
  - **Backend**: Native PHP `>=8.0` (no Laravel, no framework) served via XAMPP Apache
  - **Database**: MySQL / MariaDB (`retrieva_db`, `utf8mb4_unicode_ci`, `InnoDB`) via PDO (`database/db.php`)
  - **Composer Packages**: `league/oauth2-google` (`^5.0`), `phpmailer/phpmailer` (`^7.1`), `pusher/pusher-php-server` (`^7.3`)
  - **Frontend**: Static HTML/CSS/JS and PHP views (`auth/`, `dashboard/`, `assets/`), vanilla JS, CSS (`assets/theme.css`, `auth/styles.css`, `dashboard/styles.css`, `dashboard/settings.css`)
  - **Dev Tooling**: `live-server` (`^1.2.2`), `prettier` (`^3.3.3`) in `package.json`
- RBAC Roles (`dashboard/rbac.php`, `database/schema.sql`):
  - Admin side: `admin`, `security`
  - Client side: `professor`, `student`
