---
name: mysql-database
description: "Use for Retrieva MySQL/MariaDB schema design, SQL files (database/schema.sql, database/retrieva_db.sql), imports, indexes, constraints, foreign keys, seed data, PDO queries, and performance."
---

# MySQL Database

## Project Setup

- Engine: MySQL / MariaDB in XAMPP (`retrieva_db`), `InnoDB`, `utf8mb4` / `utf8mb4_unicode_ci`.
- Schema files: `database/schema.sql` and `database/retrieva_db.sql`.
- Connection: PDO via `get_db()` in `database/db.php` (`ATTR_EMULATE_PREPARES => false`).

## Design Workflow

1. Inspect `database/schema.sql` for existing tables, column types, enums, foreign keys, and indexes before adding or altering columns.
2. Keep schema changes in explicit, ordered, reviewable `.sql` statements or migration scripts compatible with phpMyAdmin / MySQL CLI import.
3. Separate schema creation, seed data, and destructive operations.
4. Consider transactions, foreign key cascade rules (`ON DELETE CASCADE` / `ON DELETE SET NULL`), and existing data.

## SQL File Requirements

- Target `retrieva_db` with `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci` and `ENGINE=InnoDB`.
- Never include live credentials, tokens, or personal production data in committed SQL files.
- Mark destructive statements (`DROP`, `TRUNCATE`, `DELETE`) prominently.

## Performance and Safety

- Verify indexes against actual filters, joins, sorts, and foreign keys (`email`, `student_id`, `google_id`, `qr_token`, status columns).
- Use PDO prepared statements for all application queries.
- Wrap multi-table updates (e.g., approving a claim and generating a pickup QR token) in PDO transactions.
