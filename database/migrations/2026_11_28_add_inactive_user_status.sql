-- Requires MariaDB 10.4+ (tested on 10.4.32) or MySQL 5.7+ with utf8mb4.
-- Existing accounts retain their current status; deactivation preserves related history.
ALTER TABLE `users`
  MODIFY COLUMN `status` ENUM('active', 'blocked', 'inactive') NOT NULL DEFAULT 'active';
