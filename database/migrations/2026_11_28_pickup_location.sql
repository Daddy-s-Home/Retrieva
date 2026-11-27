-- Requires MariaDB 10.4+ (tested on 10.4.32) or MySQL 5.7+ with utf8mb4.
-- Existing pickup rows retain NULL; new approvals supply the current holding location.
ALTER TABLE `pickups`
  ADD COLUMN `pickup_location` VARCHAR(255) DEFAULT NULL AFTER `claim_id`;
