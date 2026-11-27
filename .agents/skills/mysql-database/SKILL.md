---
name: mysql-database
description: "Use for Retrieva's MySQL/MariaDB schema design, SQL files (retrieva_db_current.sql, schema.sql, retrieva_db.sql), migrations, indexes, constraints, foreign keys, PDO queries, and performance."
---

# MySQL Database

## Retrieva Context

- Target database: `retrieva_db` on XAMPP MariaDB (`10.4.32-MariaDB`) / MySQL.
- Authoritative current snapshot: `database/retrieva_db_current.sql` (full XAMPP phpMyAdmin export with all 12 `InnoDB` table schemas and current data).
- Historical/migration SQL files in `database/`: `schema.sql`, `retrieva_db.sql`, `retrieva_dbv1.sql`, `retrieva_dbv2.sql`, and `database/migrations/`.
- Core tables: `users`, `lost_items`, `found_items`, `claims`, `pickups`, `item_matches`, `item_images`, `saved_items`, `notifications`, `audit_trail`, `sms_logs`, `totp_challenges`.

## Design Workflow

1. Inspect `database/retrieva_db_current.sql` first as the current live schema, along with `database/migrations/`, naming conventions, `InnoDB` engine, charset (`utf8mb4`), and table collations (`utf8mb4_unicode_ci` / `utf8mb4_general_ci`).
2. Identify entities, relationships, cardinalities, uniqueness rules (e.g., `LR-YYYY-###`, `F-YYYY-###`, `CL-YYYY-###`), and lifecycle states.
3. Design primary keys, foreign keys, indexes, defaults, nullability, and constraints before writing application queries.
4. Create explicit, ordered, and reviewable `.sql` files in `database/migrations/` for schema changes.
5. Separate schema creation, seed data, and destructive operations.
6. Consider transactions, locking, rollback, and existing local data.

## SQL File Requirements

- State the expected MariaDB/MySQL version and required character set (`utf8mb4`).
- Quote identifiers consistently and avoid engine-specific ambiguity.
- Add foreign keys only when their lifecycle behavior (`ON DELETE` / `ON UPDATE`) is safe.
- Never include live credentials, tokens, personal data, or unreviewed production exports.
- Mark destructive statements (`DROP`, `TRUNCATE`, `DELETE`) prominently.

## Performance and Safety

- Verify indexes against actual filters, joins, sorts, pagination, and foreign keys.
- Prevent N+1 queries and accidental full-table scans.
- Use parameterized PDO prepared statements for all queries.
- Validate SQL changes against a representative local dataset and backup plan.

Source: based on Antigravity [database-architect](https://github.com/benjaminasterA/antigravity-awesome-skills/blob/main/skills/database-architect/SKILL.md) and Agentic [sql-pro](https://github.com/sickn33/agentic-awesome-skills/blob/main/skills/sql-pro/SKILL.md).

