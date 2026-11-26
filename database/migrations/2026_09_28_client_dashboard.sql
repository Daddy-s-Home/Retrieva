-- Retrieva client dashboard migration
-- Applies to an existing retrieva_db without dropping data.
-- Fresh installs should use database/schema.sql, which already includes these columns.

ALTER TABLE users
  ADD COLUMN phone VARCHAR(30) NULL AFTER student_id,
  ADD COLUMN program_department VARCHAR(150) NULL AFTER phone,
  ADD COLUMN email_verified TINYINT(1) NOT NULL DEFAULT 0 AFTER program_department,
  ADD COLUMN phone_verified TINYINT(1) NOT NULL DEFAULT 0 AFTER email_verified,
  ADD COLUMN last_login_at DATETIME NULL AFTER phone_verified,
  ADD COLUMN notify_email TINYINT(1) NOT NULL DEFAULT 1 AFTER last_login_at,
  ADD COLUMN notify_sms TINYINT(1) NOT NULL DEFAULT 0 AFTER notify_email,
  ADD COLUMN notify_in_app TINYINT(1) NOT NULL DEFAULT 1 AFTER notify_sms,
  ADD COLUMN notify_matches TINYINT(1) NOT NULL DEFAULT 1 AFTER notify_in_app,
  ADD COLUMN notify_system TINYINT(1) NOT NULL DEFAULT 1 AFTER notify_matches,
  ADD COLUMN share_lost_reports TINYINT(1) NOT NULL DEFAULT 1 AFTER notify_system;

UPDATE users SET email_verified = 1 WHERE email_verified = 0;

ALTER TABLE lost_items
  ADD COLUMN public_code VARCHAR(30) NULL AFTER id,
  ADD COLUMN photo_path VARCHAR(500) NULL AFTER date_lost,
  ADD COLUMN closed_reason VARCHAR(255) NULL AFTER description,
  ADD COLUMN matched_found_item_id INT UNSIGNED NULL AFTER closed_reason,
  ADD COLUMN matched_at DATETIME NULL AFTER matched_found_item_id,
  ADD COLUMN verified_at DATETIME NULL AFTER matched_at,
  ADD COLUMN resolved_at DATETIME NULL AFTER verified_at,
  ADD COLUMN closed_at DATETIME NULL AFTER resolved_at,
  ADD COLUMN is_public TINYINT(1) NOT NULL DEFAULT 1 AFTER closed_at,
  MODIFY status ENUM('searching','matched','resolved','closed') NOT NULL DEFAULT 'searching';

ALTER TABLE found_items
  ADD COLUMN public_code VARCHAR(30) NULL AFTER id,
  ADD COLUMN public_summary VARCHAR(500) NULL AFTER photo_path,
  MODIFY status ENUM('unclaimed','pending_verification','claimed','disposed','returned') NOT NULL DEFAULT 'unclaimed';

ALTER TABLE claims
  ADD COLUMN public_code VARCHAR(30) NULL AFTER id,
  ADD COLUMN lost_item_id INT UNSIGNED NULL AFTER claimant_id,
  ADD COLUMN rejection_reason VARCHAR(500) NULL AFTER status;

ALTER TABLE pickups
  ADD COLUMN expires_at DATETIME NULL AFTER qr_token,
  ADD COLUMN status ENUM('pending','verified','expired','invalid') NOT NULL DEFAULT 'pending' AFTER expires_at,
  ADD COLUMN return_code VARCHAR(30) NULL AFTER verified_by,
  ADD COLUMN return_method VARCHAR(80) NULL AFTER return_code,
  ADD COLUMN condition_note VARCHAR(255) NULL AFTER return_method;

UPDATE lost_items
SET public_code = CONCAT('LR-', DATE_FORMAT(created_at, '%Y'), '-', LPAD(id, 3, '0'))
WHERE public_code IS NULL OR public_code = '';

UPDATE found_items
SET public_code = CONCAT('F-', DATE_FORMAT(created_at, '%Y'), '-', LPAD(id, 3, '0'))
WHERE public_code IS NULL OR public_code = '';

UPDATE claims
SET public_code = CONCAT('CL-', DATE_FORMAT(created_at, '%Y'), '-', LPAD(id, 3, '0'))
WHERE public_code IS NULL OR public_code = '';

UPDATE lost_items SET matched_at = created_at WHERE status = 'matched' AND matched_at IS NULL;
UPDATE lost_items SET resolved_at = created_at WHERE status = 'resolved' AND resolved_at IS NULL;
UPDATE pickups SET status = 'verified' WHERE scanned_at IS NOT NULL AND status = 'pending';

ALTER TABLE lost_items
  ADD UNIQUE KEY uniq_lost_public_code (public_code),
  ADD KEY idx_lost_reported (reported_by, status),
  ADD CONSTRAINT fk_lost_matched_found FOREIGN KEY (matched_found_item_id) REFERENCES found_items(id) ON DELETE SET NULL;

ALTER TABLE found_items
  ADD UNIQUE KEY uniq_found_public_code (public_code);

ALTER TABLE claims
  ADD UNIQUE KEY uniq_claim_public_code (public_code),
  ADD KEY idx_claims_claimant (claimant_id, status),
  ADD CONSTRAINT fk_claims_lost_item FOREIGN KEY (lost_item_id) REFERENCES lost_items(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS notifications (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id       INT UNSIGNED NOT NULL,
  category      ENUM('match','claim','report','system') NOT NULL,
  title         VARCHAR(180) NOT NULL,
  body          TEXT NOT NULL,
  entity_type   VARCHAR(40) NULL,
  entity_id     INT UNSIGNED NULL,
  read_at       DATETIME NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_notifications_user (user_id, read_at, created_at),
  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS item_matches (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  lost_item_id     INT UNSIGNED NOT NULL,
  found_item_id    INT UNSIGNED NOT NULL,
  score            DECIMAL(5,2) NOT NULL DEFAULT 0,
  status           ENUM('potential','needs_review','confirmed','no_match') NOT NULL DEFAULT 'potential',
  similarity_json  TEXT NULL,
  reviewed_by      INT UNSIGNED NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_item_match (lost_item_id, found_item_id),
  CONSTRAINT fk_match_lost FOREIGN KEY (lost_item_id) REFERENCES lost_items(id) ON DELETE CASCADE,
  CONSTRAINT fk_match_found FOREIGN KEY (found_item_id) REFERENCES found_items(id) ON DELETE CASCADE,
  CONSTRAINT fk_match_reviewer FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS saved_items (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED NOT NULL,
  entity_type  ENUM('lost','found') NOT NULL,
  entity_id    INT UNSIGNED NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_saved_item (user_id, entity_type, entity_id),
  CONSTRAINT fk_saved_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS item_images (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  entity_type  ENUM('lost','found') NOT NULL,
  entity_id    INT UNSIGNED NOT NULL,
  photo_path   VARCHAR(500) NOT NULL,
  sort_order   INT UNSIGNED NOT NULL DEFAULT 0,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_item_images (entity_type, entity_id)
) ENGINE=InnoDB;
