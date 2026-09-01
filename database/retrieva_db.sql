-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 01, 2026 at 02:47 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `retrieva_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_trail`
--

CREATE TABLE `audit_trail` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(150) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_trail`
--

INSERT INTO `audit_trail` (`id`, `user_id`, `action`, `details`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 2, 'google_signup', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 10:50:13'),
(2, 2, 'student_id_set', 'Student ID recorded: A12345431', '::1', NULL, '2026-09-01 10:50:18'),
(3, 2, 'password_set', 'Password created/updated by user.', '::1', NULL, '2026-09-01 10:50:31'),
(4, 2, 'logout', '', '::1', NULL, '2026-09-01 10:51:04'),
(5, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 10:51:21'),
(6, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 10:53:07'),
(7, 2, 'logout', '', '::1', NULL, '2026-09-01 10:53:15'),
(8, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 10:56:33'),
(9, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:01:54'),
(10, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:09:39'),
(11, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:16:30'),
(12, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:16:40'),
(13, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:24:01'),
(14, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:35:54'),
(15, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:50:46'),
(16, 2, 'login_success', 'TOTP verified, session started.', '::1', NULL, '2026-09-01 11:51:18'),
(17, 2, 'logout', '', '::1', NULL, '2026-09-01 11:52:15'),
(18, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 11:52:56'),
(19, 2, 'login_success', 'TOTP verified, session started.', '::1', NULL, '2026-09-01 11:53:02'),
(20, 2, 'logout', '', '::1', NULL, '2026-09-01 11:53:05'),
(21, 2, 'password_set', 'Password created/updated by user.', '::1', NULL, '2026-09-01 12:04:21'),
(22, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 12:04:31'),
(23, 2, 'login_success', 'TOTP verified, session started.', '::1', NULL, '2026-09-01 12:04:37'),
(24, 2, 'logout', '', '::1', NULL, '2026-09-01 12:04:39'),
(25, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 12:09:28'),
(26, 2, 'logout', '', '::1', NULL, '2026-09-01 12:09:40'),
(27, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 12:09:43'),
(28, 2, 'logout', '', '::1', NULL, '2026-09-01 12:11:53'),
(29, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 12:13:52'),
(30, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 12:14:16'),
(31, 2, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:28:17'),
(32, 2, 'login_failed', 'Invalid password attempt (2/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:28:17'),
(33, 2, 'login_failed', 'Invalid password attempt (3/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:28:17'),
(34, 2, 'login_failed', 'Invalid password attempt (4/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:28:17'),
(35, 2, 'account_locked', 'Account locked for 15 minutes due to 5 consecutive failed login attempts.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:28:17'),
(36, 2, 'login_lockout_rejected', 'Attempt while account locked (890s remaining)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:28:27'),
(37, 2, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:30:57'),
(38, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:31:03'),
(39, 2, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:31:09'),
(40, 2, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:31:12');

-- --------------------------------------------------------

--
-- Table structure for table `claims`
--

CREATE TABLE `claims` (
  `id` int(10) UNSIGNED NOT NULL,
  `found_item_id` int(10) UNSIGNED NOT NULL,
  `claimant_id` int(10) UNSIGNED NOT NULL,
  `challenge_questions` text DEFAULT NULL,
  `claimant_answers` text DEFAULT NULL,
  `match_score` decimal(5,2) DEFAULT NULL,
  `status` enum('pending','manual_review','approved','rejected') NOT NULL DEFAULT 'pending',
  `reviewed_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `found_items`
--

CREATE TABLE `found_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `logged_by` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` enum('Electronics','Clothing','IDs & Cards','Accessories','Books & Papers','Others') NOT NULL,
  `location_found` varchar(150) NOT NULL,
  `date_found` date NOT NULL,
  `photo_path` varchar(500) DEFAULT NULL,
  `extracted_text` text DEFAULT NULL,
  `masked_features` text DEFAULT NULL,
  `status` enum('unclaimed','pending_verification','claimed','disposed') NOT NULL DEFAULT 'unclaimed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lost_items`
--

CREATE TABLE `lost_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `reported_by` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` enum('Electronics','Clothing','IDs & Cards','Accessories','Books & Papers','Others') NOT NULL,
  `last_seen_location` varchar(150) DEFAULT NULL,
  `date_lost` date NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('searching','matched','resolved') NOT NULL DEFAULT 'searching',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pickups`
--

CREATE TABLE `pickups` (
  `id` int(10) UNSIGNED NOT NULL,
  `claim_id` int(10) UNSIGNED NOT NULL,
  `qr_token` varchar(255) NOT NULL,
  `scheduled_for` datetime DEFAULT NULL,
  `scanned_at` datetime DEFAULT NULL,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sms_logs`
--

CREATE TABLE `sms_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `recipient` int(10) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `status` enum('sent','failed','pending') NOT NULL DEFAULT 'pending',
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `totp_challenges`
--

CREATE TABLE `totp_challenges` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `code_hash` varchar(255) NOT NULL,
  `purpose` enum('login','password_reset') NOT NULL DEFAULT 'login',
  `expires_at` datetime NOT NULL,
  `consumed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `totp_challenges`
--

INSERT INTO `totp_challenges` (`id`, `user_id`, `code_hash`, `purpose`, `expires_at`, `consumed_at`, `created_at`) VALUES
(1, 2, '$2y$10$paS5gQQ3.TClPE9R2rCoXusjnu6gFJGGrHbJH2cyUibEGuENuZyR.', 'login', '2026-09-01 18:56:21', NULL, '2026-09-01 10:51:21'),
(2, 2, '$2y$10$9xvvr0hTnt720.vs17AVF.V8ETMvJUQBwHIVlBGFZvmT9h89zC9OK', 'login', '2026-09-01 19:01:33', NULL, '2026-09-01 10:56:33'),
(3, 2, '$2y$10$PVs39i2zftquZq9LL9AnL.2HLbqqREn88HUtxOY2QE2z0uVKyFvCa', 'login', '2026-09-01 19:06:52', NULL, '2026-09-01 11:01:52'),
(4, 2, '$2y$10$bG6B/6ZRE1JmZnYYGBjGXOnJ11fmyEEkdUcqB4UG74jktYx7hGKee', 'login', '2026-09-01 19:14:36', NULL, '2026-09-01 11:09:36'),
(5, 2, '$2y$10$Y0SvgaK4NszodHz2s44UTO0/Z8r7VRr.ug9B/amcLiBTtLRFDoZf.', 'login', '2026-09-01 19:21:28', NULL, '2026-09-01 11:16:28'),
(6, 2, '$2y$10$ArtFOTlGrby98AKKFE/7SeDCbuIG7CmMDgDwIaKYDE6q9Qr5UBPVy', 'login', '2026-09-01 19:21:38', NULL, '2026-09-01 11:16:38'),
(7, 2, '$2y$10$WpiWcyUSWfA3lkmgf.bNYeIVHjshNbG2YexqOyv3HjJS5vlTHFTc6', 'login', '2026-09-01 19:29:01', NULL, '2026-09-01 11:24:01'),
(8, 2, '$2y$10$gdeXg8ppfPEe9dFFiDLSRueOH9.kVAkQQye94Vy5m63Q6in.9UWwm', 'login', '2026-09-01 19:38:26', NULL, '2026-09-01 11:33:26'),
(9, 2, '$2y$10$Fx5we630LUKInwBTiGjteuEU8/QQQ4HjZt6.QpcslyvSl.1KOyeOS', 'login', '2026-09-01 19:38:35', NULL, '2026-09-01 11:33:35'),
(10, 2, '$2y$10$2j8AIbxQWEgwtEVCM1eLXep0k31LwmdltUMEHgRDQioMz8yPrcNV.', 'login', '2026-09-01 19:38:36', NULL, '2026-09-01 11:33:36'),
(11, 2, '$2y$10$uAldhQLUx1EQ/nDzUeVideAic7KbY1Ox44ULkF51IJwfXWKuxlXti', 'login', '2026-09-01 19:38:36', NULL, '2026-09-01 11:33:36'),
(12, 2, '$2y$10$ge4kMTZr9FCXeHsdyreuLO.LZoxM7I5I/wwVVJ0Z.fOhkWoHTNExm', 'login', '2026-09-01 19:38:36', NULL, '2026-09-01 11:33:36'),
(13, 2, '$2y$10$eDo6D472m.UZVPe3Im5ICuC0q1vldTsSX7DcLSxJ3T.Kxzx3Ci9HG', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 11:33:37'),
(14, 2, '$2y$10$JnsAYpsNoer/XKJAxvEc5OHLGYClPR4QElHVgN6uDukUBmmvG9ykS', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 11:33:37'),
(15, 2, '$2y$10$YB.UfOrtFQjTde9FI6nW8eAIVGdtKbdP6wFHUFJSJZrrC/kZIrht6', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 11:33:37'),
(16, 2, '$2y$10$gJfbzbKtWBhXHrVEaBULTu1uZgIzkpU0iIi/jXOiK1czbtw0hAeKu', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 11:33:37'),
(17, 2, '$2y$10$gQNS7mUX7GfrHJoHJLinsuEW1451gNYigDqpio60FHjfBzs9YJg.a', 'login', '2026-09-01 19:39:02', NULL, '2026-09-01 11:34:02'),
(18, 2, '$2y$10$4ZZKmg4iTWWn7YrJkpt5peK5viSIYBMj.dAO7KxCUnWPS0tZh610m', 'login', '2026-09-01 19:39:03', NULL, '2026-09-01 11:34:03'),
(19, 2, '$2y$10$./zi.LhaKNHcWX4EbhNMqOw0g/5K4PYnSlq3vcrLcwX04jkyxPY/O', 'login', '2026-09-01 19:40:54', NULL, '2026-09-01 11:35:54'),
(20, 2, '$2y$10$K2Qyym4B03.2WFZUMpZfEusEY9xDdkW8zklwMd8L3732Tkx0HuSQ6', 'login', '2026-09-01 19:48:24', NULL, '2026-09-01 11:43:24'),
(21, 2, '$2y$10$u5FPmmwzQXaDJuP7ehrs4uWAEuRXZkmL7YitWhyJ3HQ7crDrjteWO', 'login', '2026-09-01 19:48:26', NULL, '2026-09-01 11:43:26'),
(22, 2, '$2y$10$1VCyTMu4wG0iqtVk/Ub8/eSykKNQnx95YK1q.8WheFqsH9o6IKc5e', 'login', '2026-09-01 19:48:26', NULL, '2026-09-01 11:43:26'),
(23, 2, '$2y$10$OyuveOggKreU0a0TOh1RnuqnAjqngK5D8A73G.SBbgS0iFmuPtbTK', 'login', '2026-09-01 19:48:27', NULL, '2026-09-01 11:43:27'),
(24, 2, '$2y$10$NyOYOu3f2Is2Xt2rZqspzO/b/oIkcZ7VPTCyrxclRsVEcq8dHJ7nK', 'login', '2026-09-01 19:48:27', NULL, '2026-09-01 11:43:27'),
(25, 2, '$2y$10$aGd1jUiyKeE2K7omVptlmeVvR0Qc2EQ58GIvdcbs79e1qWSVZFEIy', 'login', '2026-09-01 19:48:27', NULL, '2026-09-01 11:43:27'),
(26, 2, '$2y$10$5z/kVecbwUldcJos7jTwzeLOtLPYpRUnsedd39M4TsjPYIUJNilA.', 'login', '2026-09-01 19:48:47', NULL, '2026-09-01 11:43:47'),
(27, 2, '$2y$10$YapTCLHLokNuJbBrbsFHs./8P4hLt12LxO9NN5VYSEqnVNDGrNUBe', 'login', '2026-09-01 19:49:21', NULL, '2026-09-01 11:44:21'),
(28, 2, '$2y$10$ulWLc7u/l7GJG1tnny4xC.mlgMRIFTJ6bdY/bFXco9bbDJavpM2U.', 'login', '2026-09-01 19:49:22', NULL, '2026-09-01 11:44:22'),
(29, 2, '$2y$10$1sCN4AtdIfUfQ1aoevmWKONiQZMdPicZbiy1Eai1VeLns.47ix3Wy', 'login', '2026-09-01 19:49:22', NULL, '2026-09-01 11:44:22'),
(30, 2, '$2y$10$m54WdkMadUybKC5Ayyy6YOAblvVmJNk5eTI8SzZhy17NsdvOz6Ho2', 'login', '2026-09-01 19:50:47', NULL, '2026-09-01 11:45:47'),
(31, 2, '$2y$10$5rsSEAPezbOb2QT/t5y5DOG07pt44hrSTXe3Ce4M9Vwzo/onoyqdG', 'login', '2026-09-01 19:51:02', NULL, '2026-09-01 11:46:02'),
(32, 2, '$2y$10$vwjoY8cbR3dbqEo7iTEYHORVGyjgzJUTBJRp6G49TneolTq6q0pna', 'login', '2026-09-01 19:51:03', NULL, '2026-09-01 11:46:03'),
(33, 2, '$2y$10$8Eh9S9YGrpnhYPR4XDieaOJICKI/IV2nKvZKgbZ6qx5ETew9Zzyoe', 'login', '2026-09-01 19:55:43', '2026-09-01 19:51:18', '2026-09-01 11:50:43'),
(34, 2, '$2y$10$8IzUGgNCGVNSXgoBFieTGO/bNmrGkGkbSZRvhIHu3lOngnHz6RnVa', 'login', '2026-09-01 19:57:52', '2026-09-01 19:53:02', '2026-09-01 11:52:52'),
(35, 2, '$2y$10$pwcbnONJTFGq.xTieF6y8.Zq1t5Hmnz.BeflmQ8m08njFDgxJHDIG', 'password_reset', '2026-09-01 20:08:48', '2026-09-01 20:04:10', '2026-09-01 12:03:48'),
(36, 2, '$2y$10$07XLvzD2Cb.ZpGvpBrioZOEDNNrYKNAmV.8d0/5kGYI1o3fLo6RBm', 'login', '2026-09-01 20:09:29', '2026-09-01 20:04:37', '2026-09-01 12:04:29'),
(37, 2, '$2y$10$RnXe8iwiaYr2749KRT/WqOCePj68JhvlYV.jmihE4uPoWEoX62/rW', 'password_reset', '2026-09-01 20:09:43', '2026-09-01 20:05:05', '2026-09-01 12:04:43'),
(38, 2, '$2y$10$/thIvrVIUcRozANB57kgAe7vUndfSSbdJd8SncXh1uyO9zjVaMzBK', 'login', '2026-09-01 20:18:49', NULL, '2026-09-01 12:13:49'),
(39, 2, '$2y$10$c9GFX10Exb4MotqYsw2wkORoo5cpl9H6Brcsy0nlYMTnCkWbY8.s.', 'login', '2026-09-01 20:19:13', NULL, '2026-09-01 12:14:13'),
(40, 2, '$2y$10$8Gl2BiX2ksM8nCXXCL/V/uzXUpMmyMe3z92cOXu3KND3lQ8XCAPDS', 'login', '2026-09-01 20:36:01', '2026-09-01 20:31:09', '2026-09-01 12:31:01');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(150) NOT NULL,
  `student_id` varchar(30) DEFAULT NULL,
  `full_name` varchar(150) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `password_is_set` tinyint(1) NOT NULL DEFAULT 0,
  `skip_password_prompt` tinyint(1) NOT NULL DEFAULT 0,
  `role` enum('admin','security','professor','student') NOT NULL DEFAULT 'student',
  `auth_provider` enum('local','google') NOT NULL DEFAULT 'local',
  `google_id` varchar(100) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `totp_secret` varchar(64) DEFAULT NULL,
  `totp_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('active','blocked') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `failed_attempts` int(10) UNSIGNED DEFAULT 0,
  `lockout_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `student_id`, `full_name`, `password_hash`, `password_is_set`, `skip_password_prompt`, `role`, `auth_provider`, `google_id`, `avatar_url`, `totp_secret`, `totp_enabled`, `status`, `created_at`, `updated_at`, `failed_attempts`, `lockout_until`) VALUES
(1, 'admin@umak.edu.ph', NULL, 'John Matthew S. Palma', '$2y$10$/HSC5vk1SeIlrrk.ZDDalusHSLMYAs5HGtcrvZVXaC1da27m4AMS6', 1, 0, 'admin', 'local', NULL, NULL, NULL, 0, 'active', '2026-09-01 10:42:39', '2026-09-01 10:42:39', 0, NULL),
(2, 'jangeles.a12345431@umak.edu.ph', 'A12345431', 'JUSTIN ANGELES', '$2y$10$vXoDV30IrWOFz3G2q5k9pO3QbEre2wA5SL3pIRYjjg8GtY89BACpG', 1, 0, 'student', 'local', '113623321447473046632', 'https://lh3.googleusercontent.com/a/ACg8ocJUBdUOLKMk1w_XtsK8RKQ-0aJNkuvfdbPsMLP2o6yF3pZ01XI=s96-c', 'G6V2D6DEZILCZEWR', 0, 'active', '2026-09-01 10:50:13', '2026-09-01 12:31:01', 0, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `claims`
--
ALTER TABLE `claims`
  ADD PRIMARY KEY (`id`),
  ADD KEY `found_item_id` (`found_item_id`),
  ADD KEY `claimant_id` (`claimant_id`),
  ADD KEY `reviewed_by` (`reviewed_by`);

--
-- Indexes for table `found_items`
--
ALTER TABLE `found_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logged_by` (`logged_by`);

--
-- Indexes for table `lost_items`
--
ALTER TABLE `lost_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reported_by` (`reported_by`);

--
-- Indexes for table `pickups`
--
ALTER TABLE `pickups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `claim_id` (`claim_id`),
  ADD UNIQUE KEY `qr_token` (`qr_token`),
  ADD KEY `verified_by` (`verified_by`);

--
-- Indexes for table `sms_logs`
--
ALTER TABLE `sms_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recipient` (`recipient`);

--
-- Indexes for table `totp_challenges`
--
ALTER TABLE `totp_challenges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD UNIQUE KEY `google_id` (`google_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_trail`
--
ALTER TABLE `audit_trail`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `claims`
--
ALTER TABLE `claims`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `found_items`
--
ALTER TABLE `found_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lost_items`
--
ALTER TABLE `lost_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pickups`
--
ALTER TABLE `pickups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sms_logs`
--
ALTER TABLE `sms_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `totp_challenges`
--
ALTER TABLE `totp_challenges`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD CONSTRAINT `audit_trail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `claims`
--
ALTER TABLE `claims`
  ADD CONSTRAINT `claims_ibfk_1` FOREIGN KEY (`found_item_id`) REFERENCES `found_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `claims_ibfk_2` FOREIGN KEY (`claimant_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `claims_ibfk_3` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `found_items`
--
ALTER TABLE `found_items`
  ADD CONSTRAINT `found_items_ibfk_1` FOREIGN KEY (`logged_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `lost_items`
--
ALTER TABLE `lost_items`
  ADD CONSTRAINT `lost_items_ibfk_1` FOREIGN KEY (`reported_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `pickups`
--
ALTER TABLE `pickups`
  ADD CONSTRAINT `pickups_ibfk_1` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pickups_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `sms_logs`
--
ALTER TABLE `sms_logs`
  ADD CONSTRAINT `sms_logs_ibfk_1` FOREIGN KEY (`recipient`) REFERENCES `users` (`id`);

--
-- Constraints for table `totp_challenges`
--
ALTER TABLE `totp_challenges`
  ADD CONSTRAINT `totp_challenges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
