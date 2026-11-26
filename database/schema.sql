-- =====================================================================
-- RETRIEVA — Fraud-Proof Campus Lost & Found System
-- University of Makati Security Office
-- Database schema for XAMPP / MySQL (phpMyAdmin)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS retrieva_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE retrieva_db;

-- ---------------------------------------------------------------------
-- USERS
-- Holds every account type. RBAC role controls sidebar/menu visibility.
-- student_id sits right after email as requested; it is only populated
-- for the "student" role and is asked for via a one-time popup.
-- ---------------------------------------------------------------------
CREATE TABLE users (
  id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email                 VARCHAR(150) NOT NULL UNIQUE,
  student_id            VARCHAR(30)  NULL UNIQUE,
  phone                 VARCHAR(30)  NULL,
  program_department    VARCHAR(150) NULL,
  email_verified        TINYINT(1)   NOT NULL DEFAULT 0,
  phone_verified        TINYINT(1)   NOT NULL DEFAULT 0,
  last_login_at         DATETIME     NULL,
  notify_email          TINYINT(1)   NOT NULL DEFAULT 1,
  notify_sms            TINYINT(1)   NOT NULL DEFAULT 0,
  notify_in_app         TINYINT(1)   NOT NULL DEFAULT 1,
  notify_matches        TINYINT(1)   NOT NULL DEFAULT 1,
  notify_system         TINYINT(1)   NOT NULL DEFAULT 1,
  share_lost_reports    TINYINT(1)   NOT NULL DEFAULT 1,
  full_name             VARCHAR(150) NOT NULL,
  password_hash         VARCHAR(255) NULL,          -- NULL until user sets a password
  password_is_set       TINYINT(1)   NOT NULL DEFAULT 0,
  skip_password_prompt  TINYINT(1)   NOT NULL DEFAULT 0, -- "don't ask again" checkbox
  role                  ENUM('admin','security','professor','student') NOT NULL DEFAULT 'student',
  auth_provider         ENUM('local','google') NOT NULL DEFAULT 'local',
  google_id             VARCHAR(100) NULL UNIQUE,
  avatar_url            VARCHAR(500) NULL,           -- pulled from Google profile if available
  totp_secret           VARCHAR(64)  NULL,
  totp_enabled          TINYINT(1)   NOT NULL DEFAULT 0,
  login_method          ENUM('email','totp') NOT NULL DEFAULT 'email',
  status                ENUM('active','blocked') NOT NULL DEFAULT 'active',
  failed_attempts       INT UNSIGNED NOT NULL DEFAULT 0,
  lockout_until         DATETIME     NULL,
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- PASSWORD RESET / TOTP CHALLENGES
-- Short-lived codes used both for login 2FA and forgot-password flow.
-- ---------------------------------------------------------------------
CREATE TABLE totp_challenges (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED NOT NULL,
  code_hash    VARCHAR(255) NOT NULL,
  purpose      ENUM('login','password_reset') NOT NULL DEFAULT 'login',
  expires_at   DATETIME NOT NULL,
  consumed_at  DATETIME NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- FOUND ITEMS
-- Logged by security/admin. Camera Scanner API + OCR API populate
-- extracted_text / masked_features automatically on upload.
-- ---------------------------------------------------------------------
CREATE TABLE found_items (
  id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  public_code        VARCHAR(30) NULL UNIQUE,
  logged_by          INT UNSIGNED NOT NULL,
  item_name          VARCHAR(150) NOT NULL,
  category           ENUM('Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other') NOT NULL,
  other_category     VARCHAR(150) NULL,
  location_found     VARCHAR(150) NOT NULL,
  date_found         DATE NOT NULL,
  photo_path         VARCHAR(500) NULL,
  public_summary     VARCHAR(500) NULL, -- the only description shown to students and professors
  extracted_text     TEXT NULL,      -- raw OCR output (name/number on ID, etc.)
  masked_features    TEXT NULL,      -- JSON: camera-scanner detected marks, turned into challenge Qs
  status             ENUM('unclaimed','pending_verification','claimed','disposed','returned') NOT NULL DEFAULT 'unclaimed',
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (logged_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- LOST ITEM REPORTS
-- Filed by students/faculty describing what they lost.
-- ---------------------------------------------------------------------
CREATE TABLE lost_items (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  public_code      VARCHAR(30) NULL UNIQUE,
  reported_by      INT UNSIGNED NOT NULL,
  item_name        VARCHAR(150) NOT NULL,
  category         ENUM('Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other') NOT NULL,
  other_category   VARCHAR(150) NULL,
  last_seen_location VARCHAR(150) NULL,
  date_lost        DATE NOT NULL,
  photo_path       VARCHAR(500) NULL,
  description      TEXT NULL,
  closed_reason    VARCHAR(255) NULL,
  matched_found_item_id INT UNSIGNED NULL,
  matched_at       DATETIME NULL,
  verified_at      DATETIME NULL,
  resolved_at      DATETIME NULL,
  closed_at        DATETIME NULL,
  is_public        TINYINT(1) NOT NULL DEFAULT 1,
  status           ENUM('searching','matched','resolved','closed') NOT NULL DEFAULT 'searching',
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reported_by) REFERENCES users(id),
  FOREIGN KEY (matched_found_item_id) REFERENCES found_items(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- ZERO-KNOWLEDGE CLAIM CHALLENGES
-- A claimant must answer masked-feature questions without ever seeing
-- the original photo/metadata, proving ownership without exposing data.
-- ---------------------------------------------------------------------
CREATE TABLE claims (
  id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  public_code         VARCHAR(30) NULL UNIQUE,
  found_item_id       INT UNSIGNED NOT NULL,
  claimant_id         INT UNSIGNED NOT NULL,
  lost_item_id        INT UNSIGNED NULL,
  challenge_questions TEXT NULL,        -- JSON array of masked questions
  claimant_answers    TEXT NULL,        -- JSON array of submitted answers
  match_score         DECIMAL(5,2) NULL,-- OCR/metadata auto-match confidence
  status              ENUM('pending','manual_review','approved','rejected') NOT NULL DEFAULT 'pending',
  rejection_reason    VARCHAR(500) NULL,
  reviewed_by         INT UNSIGNED NULL,
  created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reviewed_at         TIMESTAMP NULL,
  FOREIGN KEY (found_item_id) REFERENCES found_items(id) ON DELETE CASCADE,
  FOREIGN KEY (claimant_id) REFERENCES users(id),
  FOREIGN KEY (lost_item_id) REFERENCES lost_items(id) ON DELETE SET NULL,
  FOREIGN KEY (reviewed_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- PICKUPS
-- Single-use QR code generated once a claim is approved.
-- ---------------------------------------------------------------------
CREATE TABLE pickups (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  claim_id      INT UNSIGNED NOT NULL UNIQUE,
  qr_token      VARCHAR(255) NOT NULL UNIQUE,
  expires_at    DATETIME NULL,
  status        ENUM('pending','verified','expired','invalid') NOT NULL DEFAULT 'pending',
  scheduled_for DATETIME NULL,
  scanned_at    DATETIME NULL,
  verified_by   INT UNSIGNED NULL,      -- security guard who scanned it
  return_code   VARCHAR(30) NULL,
  return_method VARCHAR(80) NULL,
  condition_note VARCHAR(255) NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (claim_id) REFERENCES claims(id) ON DELETE CASCADE,
  FOREIGN KEY (verified_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- SMS LOGS (UniSMS API)
-- ---------------------------------------------------------------------
CREATE TABLE sms_logs (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipient    INT UNSIGNED NOT NULL,
  message      TEXT NOT NULL,
  status       ENUM('sent','failed','pending') NOT NULL DEFAULT 'pending',
  sent_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (recipient) REFERENCES users(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- AUDIT TRAIL
-- ---------------------------------------------------------------------
CREATE TABLE audit_trail (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     INT UNSIGNED NULL,
  action      VARCHAR(150) NOT NULL,
  details     TEXT NULL,
  ip_address  VARCHAR(45) NULL,
  user_agent  TEXT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- IN-APP NOTIFICATIONS
-- ---------------------------------------------------------------------
CREATE TABLE notifications (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id       INT UNSIGNED NOT NULL,
  category      ENUM('match','claim','report','system') NOT NULL,
  title         VARCHAR(180) NOT NULL,
  body          TEXT NOT NULL,
  entity_type   VARCHAR(40) NULL,
  entity_id     INT UNSIGNED NULL,
  read_at       DATETIME NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- STAFF MATCH SUGGESTIONS
-- Clients only receive public found-item fields for their own reports.
-- ---------------------------------------------------------------------
CREATE TABLE item_matches (
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
  FOREIGN KEY (lost_item_id) REFERENCES lost_items(id) ON DELETE CASCADE,
  FOREIGN KEY (found_item_id) REFERENCES found_items(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- SAVED CARDS (heart control)
-- ---------------------------------------------------------------------
CREATE TABLE saved_items (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED NOT NULL,
  entity_type  ENUM('lost','found') NOT NULL,
  entity_id    INT UNSIGNED NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_saved_item (user_id, entity_type, entity_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- EXTRA ITEM PHOTOS
-- ---------------------------------------------------------------------
CREATE TABLE item_images (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  entity_type  ENUM('lost','found') NOT NULL,
  entity_id    INT UNSIGNED NOT NULL,
  photo_path   VARCHAR(500) NOT NULL,
  sort_order   INT UNSIGNED NOT NULL DEFAULT 0,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Seed: one admin account for first login.
-- REPLACE_WITH_BCRYPT_HASH is a placeholder — generate a real one first:
--   php -r "echo password_hash('Password12345**', PASSWORD_BCRYPT);"
-- Run that in your XAMPP php.exe, then paste the output below before
-- importing this file (see README "First run" section).
-- ---------------------------------------------------------------------
INSERT INTO users (email, full_name, password_hash, password_is_set, role, auth_provider)
VALUES (
  'admin@umak.edu.ph',
  'John Matthew S. Palma',
  '$2y$10$/HSC5vk1SeIlrrk.ZDDalusHSLMYAs5HGtcrvZVXaC1da27m4AMS6',
  1,
  'admin',
  'local'
);
