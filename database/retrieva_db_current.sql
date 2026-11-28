-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 27, 2026 at 11:30 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
(1, 2, 'google_signup', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 02:50:13'),
(2, 2, 'student_id_set', 'Student ID recorded: A12345431', '::1', NULL, '2026-09-01 02:50:18'),
(3, 2, 'password_set', 'Password created/updated by user.', '::1', NULL, '2026-09-01 02:50:31'),
(4, 2, 'logout', '', '::1', NULL, '2026-09-01 02:51:04'),
(5, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 02:51:21'),
(6, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 02:53:07'),
(7, 2, 'logout', '', '::1', NULL, '2026-09-01 02:53:15'),
(8, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 02:56:33'),
(9, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:01:54'),
(10, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:09:39'),
(11, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:16:30'),
(12, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:16:40'),
(13, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:24:01'),
(14, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:35:54'),
(15, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:50:46'),
(16, 2, 'login_success', 'TOTP verified, session started.', '::1', NULL, '2026-09-01 03:51:18'),
(17, 2, 'logout', '', '::1', NULL, '2026-09-01 03:52:15'),
(18, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 03:52:56'),
(19, 2, 'login_success', 'TOTP verified, session started.', '::1', NULL, '2026-09-01 03:53:02'),
(20, 2, 'logout', '', '::1', NULL, '2026-09-01 03:53:05'),
(21, 2, 'password_set', 'Password created/updated by user.', '::1', NULL, '2026-09-01 04:04:21'),
(22, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 04:04:31'),
(23, 2, 'login_success', 'TOTP verified, session started.', '::1', NULL, '2026-09-01 04:04:37'),
(24, 2, 'logout', '', '::1', NULL, '2026-09-01 04:04:39'),
(25, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 04:09:28'),
(26, 2, 'logout', '', '::1', NULL, '2026-09-01 04:09:40'),
(27, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', NULL, '2026-09-01 04:09:43'),
(28, 2, 'logout', '', '::1', NULL, '2026-09-01 04:11:53'),
(29, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 04:13:52'),
(30, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', NULL, '2026-09-01 04:14:16'),
(31, 2, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:28:17'),
(32, 2, 'login_failed', 'Invalid password attempt (2/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:28:17'),
(33, 2, 'login_failed', 'Invalid password attempt (3/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:28:17'),
(34, 2, 'login_failed', 'Invalid password attempt (4/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:28:17'),
(35, 2, 'account_locked', 'Account locked for 15 minutes due to 5 consecutive failed login attempts.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:28:17'),
(36, 2, 'login_lockout_rejected', 'Attempt while account locked (890s remaining)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:28:27'),
(37, 2, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:30:57'),
(38, 2, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:31:03'),
(39, 2, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:31:09'),
(40, 2, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 04:31:12'),
(41, 3, 'google_signup', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-01 05:22:57'),
(42, 3, 'student_id_set', 'Student ID recorded: K12150334', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-01 05:23:07'),
(43, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-01 05:32:01'),
(44, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 17:00:25'),
(45, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 17:33:51'),
(46, 2, 'lost_item_reported', 'VERIFY-24ae3482', '::1', NULL, '2026-09-27 18:38:24'),
(47, 2, 'lost_item_updated', 'item=1', '::1', NULL, '2026-09-27 18:38:24'),
(48, 2, 'claim_filed', 'found_item=1', '::1', NULL, '2026-09-27 18:38:24'),
(49, 2, 'claim_withdrawn', 'claim=1', '::1', NULL, '2026-09-27 18:38:24'),
(50, 2, 'password_set', 'Password created/updated by user.', '::1', NULL, '2026-09-27 18:38:24'),
(51, 2, 'password_changed', 'Password changed from account settings.', '::1', NULL, '2026-09-27 18:38:25'),
(52, 2, 'lost_item_deleted', 'item=1', '::1', NULL, '2026-09-27 18:38:25'),
(53, 3, 'privacy_updated', 'Lost reports are listed on campus.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 18:52:14'),
(54, 3, 'privacy_updated', 'Lost reports are listed on campus.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 18:53:57'),
(55, 3, 'profile_updated', 'Updated phone and department.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 18:56:48'),
(56, 3, 'lost_item_reported', 'StudentID', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 18:57:31'),
(57, 3, 'password_set', 'Password created/updated by user.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 18:58:16'),
(58, 3, 'notification_prefs_updated', 'Updated notification preferences.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 18:58:51'),
(59, 3, 'notification_prefs_updated', 'Updated notification preferences.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 18:58:57'),
(60, 3, 'login_password_ok', 'Password verified, email code sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:42:29'),
(61, 3, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:43:13'),
(62, 3, 'login_password_ok', 'Password verified, email code sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:43:27'),
(63, 3, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:44:07'),
(64, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:44:10'),
(65, 3, 'login_password_ok', 'Password verified, email code sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:45:14'),
(66, 3, 'login_password_ok', 'Password verified, email code sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:54:43'),
(67, 3, 'login_password_ok', 'Password verified, email code sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 19:56:15'),
(68, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:01:45'),
(69, 3, 'totp_disabled', 'Authenticator app disabled from account settings.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 20:03:58'),
(70, 3, 'totp_disabled', 'Authenticator app disabled from account settings.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 20:04:03'),
(71, 3, 'totp_enabled', 'Authenticator app enabled from account settings.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:11:18'),
(72, 3, 'login_method_updated', 'Authenticator code is asked first.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:11:30'),
(73, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:11:39'),
(74, 3, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:11:49'),
(75, 3, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:12:03'),
(76, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:12:06'),
(77, 3, 'password_set', 'Password created/updated by user.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:13:11'),
(78, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:14:13'),
(79, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:16:30'),
(80, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:16:48'),
(81, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:40:33'),
(82, 3, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:40:52'),
(83, 3, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:40:59'),
(84, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:42:22'),
(85, 0, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:42:53'),
(86, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:42:58'),
(87, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:44:48'),
(88, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:50:14'),
(89, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:50:28'),
(90, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:50:58'),
(91, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:51:24'),
(92, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 20:53:56'),
(93, 0, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-27 20:59:06'),
(94, 0, 'user_password_reset', 'user=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:23:29'),
(95, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:53:35'),
(96, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:53:43'),
(97, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:54:18'),
(98, 0, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:54:50'),
(99, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:54:52'),
(100, 0, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 22:55:16'),
(101, 3, 'lost_item_reported', 'My Phone', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 23:39:06'),
(102, 0, 'found_item_logged', 'Samsung Phone with large case', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:41:01'),
(103, 0, 'matches_refreshed', 'suggestions=4', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:41:32'),
(104, 0, 'matches_refreshed', 'suggestions=4', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:41:45'),
(105, 0, 'matches_refreshed', 'suggestions=4', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:41:46'),
(106, 0, 'match_notified', 'match=7', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:42:15'),
(107, 3, 'claim_filed', 'found_item=10', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-27 23:42:57'),
(108, 0, 'claim_information_requested', 'claim=6', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:43:19'),
(109, 0, 'claim_approved', 'claim=6', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:44:43'),
(110, 0, 'pickup_verified', 'pickup=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:46:52'),
(111, 0, 'lost_report_updated', 'lost=15 status=matched', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:48:12'),
(112, 0, 'lost_report_updated', 'lost=15 status=closed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:49:17'),
(113, 0, 'lost_report_updated', 'lost=15 status=matched', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:50:31'),
(114, 0, 'lost_report_updated', 'lost=15 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:50:34'),
(115, 0, 'lost_report_updated', 'lost=15 status=closed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:50:37'),
(116, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-27 23:52:53'),
(117, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 00:06:10'),
(118, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-28 00:06:15'),
(119, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 02:26:39'),
(120, 3, 'lost_item_reported', 'Android phone Samsung', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 02:30:38'),
(121, 0, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:32:27'),
(122, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:32:30'),
(123, 0, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:32:51'),
(124, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:35:43'),
(125, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 02:35:48'),
(126, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 02:36:19'),
(127, 3, 'lost_item_reported', 'Envelop', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 02:44:05'),
(128, 0, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:45:11'),
(129, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:45:19'),
(130, 0, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:45:43'),
(131, 0, 'found_item_logged', 'Envelop with documents', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:49:37'),
(132, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:49:54'),
(133, 3, 'claim_filed', 'found_item=11', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 02:50:43'),
(134, 0, 'claim_information_requested', 'claim=7', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:51:20'),
(135, 0, 'claim_approved', 'claim=7', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:51:32'),
(136, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:51:37'),
(137, 0, 'pickup_verified', 'pickup=4', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:56:34'),
(138, 0, 'lost_report_updated', 'lost=17 status=closed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:57:12'),
(139, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 02:57:41'),
(140, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 03:08:38'),
(141, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 03:08:38'),
(142, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 03:09:00'),
(143, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 03:09:01'),
(144, 0, 'matches_refreshed', 'suggestions=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 03:09:01'),
(145, 0, 'match_rejected', 'match=2', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0', '2026-09-28 03:11:33'),
(146, 3, 'claim_withdrawn', 'claim=3', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 03:12:25'),
(147, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:12:20'),
(148, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:12:56'),
(149, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:22:19'),
(150, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:27:11'),
(151, 0, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:27:29'),
(152, 0, 'claim_approved', 'claim=2', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:28:01'),
(153, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '2026-11-26 09:36:49'),
(154, 0, 'lost_item_deleted', 'item=17', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:40:00'),
(155, 0, 'lost_item_reported', 'ballpen', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:40:19'),
(156, 0, 'lost_item_status_changed', 'item=7 status=matched', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:40:31'),
(157, 0, 'lost_item_status_changed', 'item=15 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:40:37'),
(158, 0, 'lost_item_deleted', 'item=18', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:44:01'),
(159, 0, 'lost_item_deleted', 'item=16', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:44:06'),
(160, 2, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '2026-11-26 09:44:49'),
(161, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '2026-11-26 09:44:56'),
(162, 2, 'lost_item_status_changed', 'item=12 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '2026-11-26 09:52:44'),
(163, 2, 'lost_item_reported', 'dada', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '2026-11-26 09:53:00'),
(164, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 09:59:32'),
(165, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:02:23'),
(166, 0, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:02:46'),
(167, 0, 'lost_item_status_changed', 'item=19 status=matched', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:13:43'),
(168, 0, 'lost_item_status_changed', 'item=19 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:14:00'),
(169, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:21:44'),
(170, 2, 'google_login', 'jangeles.a12345431@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:21:51'),
(171, 2, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:22:05'),
(172, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:22:17'),
(173, 0, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:22:45'),
(174, 0, 'lost_item_status_changed', 'item=19 status=matched', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:30:17'),
(175, 0, 'lost_item_status_changed', 'item=15 status=searching', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:30:31'),
(176, 0, 'lost_item_status_changed', 'item=15 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:30:34'),
(177, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:30:56'),
(178, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:31:11'),
(179, 0, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:33:00'),
(180, 0, 'lost_item_status_changed', 'item=19 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:33:19'),
(181, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:34:15'),
(182, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:34:25'),
(183, 0, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:34:38'),
(184, 2, 'lost_item_status_changed', 'item=10 status=resolved', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36 Edg/158.0.0.0', '2026-11-26 10:37:21'),
(185, 0, 'report_exported', 'type=lost_items format=pdf rows=15', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:40:29'),
(186, 0, 'report_exported', 'type=lost_items format=csv rows=15', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 10:40:49'),
(187, 0, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 11:03:35'),
(188, 0, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 11:06:15'),
(189, 0, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 11:06:37'),
(190, 0, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-26 11:06:46'),
(191, 0, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 13:56:49'),
(192, 0, 'login_failed', 'Invalid password attempt (2/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 13:57:52'),
(193, 0, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 13:58:31'),
(194, 0, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:01:28'),
(197, 3, 'lost_item_reported', 'Stone Prop', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:05:10'),
(198, 0, 'found_item_logged', 'Red Lamp', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:06:41'),
(199, 3, 'claim_filed', 'found_item=12', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:08:45'),
(200, 0, 'claim_manual_review', 'claim=8', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:09:13'),
(201, 0, 'claim_approved', 'claim=8', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:10:07'),
(202, 0, 'pickup_verified', 'pickup=6 claim=8', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 14:11:40'),
(203, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 17:52:46'),
(204, 1, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 17:53:02'),
(205, 1, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 17:53:38'),
(206, 1, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 17:54:58'),
(207, 1, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 19:52:00'),
(208, 3, 'login_failed', 'Invalid password attempt (1/5)', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 19:52:26'),
(209, 3, 'login_password_ok', 'Password verified, authenticator code requested.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 19:52:38'),
(210, 3, 'login_success', 'Sign-in code verified, session started.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 19:52:59'),
(211, 0, 'found_item_logged', 'Phone Charger', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 22:06:29'),
(212, 3, 'lost_item_reported', 'Phone Charger', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 22:08:00'),
(213, 3, 'claim_filed', 'found_item=22', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 22:09:01'),
(214, 0, 'claim_manual_review', 'claim=9', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 22:09:15'),
(215, 0, 'claim_approved', 'claim=9', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 22:10:37'),
(216, 0, 'report_exported', 'type=lost_items format=pdf rows=17', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/158.0.0.0 Safari/537.36', '2026-11-27 22:28:38');

-- --------------------------------------------------------

--
-- Table structure for table `claims`
--

CREATE TABLE `claims` (
  `id` int(10) UNSIGNED NOT NULL,
  `public_code` varchar(30) DEFAULT NULL,
  `found_item_id` int(10) UNSIGNED NOT NULL,
  `claimant_id` int(10) UNSIGNED NOT NULL,
  `lost_item_id` int(10) UNSIGNED DEFAULT NULL,
  `challenge_questions` text DEFAULT NULL,
  `claimant_answers` text DEFAULT NULL,
  `match_score` decimal(5,2) DEFAULT NULL,
  `status` enum('pending','manual_review','approved','rejected') NOT NULL DEFAULT 'pending',
  `rejection_reason` varchar(500) DEFAULT NULL,
  `reviewed_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `claims`
--

INSERT INTO `claims` (`id`, `public_code`, `found_item_id`, `claimant_id`, `lost_item_id`, `challenge_questions`, `claimant_answers`, `match_score`, `status`, `rejection_reason`, `reviewed_by`, `created_at`, `reviewed_at`) VALUES
(2, 'CL-2026-101', 5, 2, 6, '[\"Describe the case.\"]', '[\"Blue case with a crack on the corner.\"]', 74.00, 'approved', NULL, 0, '2026-09-28 00:30:00', '2026-11-26 09:28:01'),
(4, 'CL-2026-103', 8, 2, 5, '[\"Whose name is on the ID?\"]', '[\"The name matches the student record.\"]', 90.00, 'approved', NULL, 0, '2026-09-26 23:20:00', '2026-09-27 17:10:00'),
(5, 'CL-2026-104', 9, 3, 11, '[\"Describe the case.\"]', '[\"Gray tablet in a keyboard case.\"]', 88.00, 'approved', NULL, 1, '2026-09-24 19:00:00', '2026-09-25 17:00:00'),
(6, 'CL-2026-006', 10, 3, NULL, '[\"Describe an identifying detail about this item.\"]', '[\"it has stickers and large case\"]', NULL, 'approved', NULL, 0, '2026-09-27 23:42:57', '2026-09-27 23:44:43'),
(7, 'CL-2026-007', 11, 3, NULL, '[\"Describe an identifying detail about this item.\"]', '[\"This envelop contains CTC of ROG and others stuff\"]', NULL, 'approved', NULL, 0, '2026-09-28 02:50:43', '2026-09-28 02:51:32'),
(8, NULL, 12, 3, NULL, '[\"Describe an identifying detail about this item.\"]', '[\"It looks like a salt but it is a red lamp indeed\"]', NULL, 'approved', NULL, 0, '2026-11-27 14:08:45', '2026-11-27 14:10:07'),
(9, NULL, 22, 3, NULL, '[\"Describe an identifying detail about this item.\"]', '[\"This is my charger, can I claim this?\"]', NULL, 'approved', NULL, 0, '2026-11-27 22:09:01', '2026-11-27 22:10:37');

-- --------------------------------------------------------

--
-- Table structure for table `found_items`
--

CREATE TABLE `found_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `public_code` varchar(30) DEFAULT NULL,
  `logged_by` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` enum('Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other','Phones (Android)','Phones (Iphone)','ID lace','Food containers and utensils','Others') NOT NULL,
  `other_category` varchar(150) DEFAULT NULL,
  `location_found` varchar(150) NOT NULL,
  `date_found` date NOT NULL,
  `photo_path` varchar(500) DEFAULT NULL,
  `public_summary` varchar(500) DEFAULT NULL,
  `extracted_text` text DEFAULT NULL,
  `masked_features` text DEFAULT NULL,
  `status` enum('unclaimed','pending_verification','claimed','disposed','returned') NOT NULL DEFAULT 'unclaimed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `found_items`
--

INSERT INTO `found_items` (`id`, `public_code`, `logged_by`, `item_name`, `category`, `other_category`, `location_found`, `date_found`, `photo_path`, `public_summary`, `extracted_text`, `masked_features`, `status`, `created_at`) VALUES
(3, 'F-2026-101', 0, 'Blue tumbler', 'Tumbler/Flask/Bottled Water', NULL, 'Cafeteria', '2026-09-27', '[\"uploads/lost/sample-bottle.jpg\"]', 'A blue tumbler. Some markings are hidden.', NULL, 'Sticker on the lid', 'unclaimed', '2026-09-26 18:05:00'),
(4, 'F-2026-102', 0, 'Black backpack', 'Bag', NULL, 'Library', '2026-09-24', '[\"uploads/lost/sample-bag.jpg\"]', 'A black backpack. Contents are not listed.', NULL, 'Small keychain on the zipper', 'unclaimed', '2026-09-23 23:35:00'),
(5, 'F-2026-103', 0, 'Android phone', 'Phone (Android)', NULL, 'Gymnasium', '2026-09-28', '[\"uploads/found/sample-phone.jpg\"]', 'A dark phone. The wallpaper is hidden.', NULL, 'Blue case', 'claimed', '2026-09-27 19:15:00'),
(6, 'F-2026-104', 0, 'Green notebook', 'Notebook', NULL, 'HSU Lobby', '2026-09-25', '[\"uploads/found/sample-notebook.jpg\"]', 'A green notebook. Written pages are hidden.', NULL, 'Name on the inside cover', 'unclaimed', '2026-09-24 16:45:00'),
(7, 'F-2026-105', 0, 'White sneakers', 'Shoes', NULL, 'University Oval', '2026-09-27', '[\"uploads/found/sample-shoes.jpg\"]', 'A pair of white sneakers.', NULL, 'Size written inside', 'unclaimed', '2026-09-27 00:50:00'),
(8, 'F-2026-106', 1, 'Student ID', 'ID', NULL, 'Admin Building', '2026-09-25', '[]', 'A campus ID. The name and photo are hidden.', NULL, 'Clear plastic holder', 'claimed', '2026-09-24 21:10:00'),
(9, 'F-2026-107', 0, 'Tablet', 'Tablet', NULL, 'AVR', '2026-09-24', '[]', 'A gray tablet. The lock screen is hidden.', NULL, 'Keyboard case', 'returned', '2026-09-23 17:25:00'),
(10, 'F-2026-010', 0, 'Samsung Phone with large case', 'Phone (Android)', NULL, 'Admin 3rd floor', '2026-09-28', '[\"uploads/found/found_45558335300552f5.jpg\"]', 'Has stickers', NULL, NULL, 'returned', '2026-09-27 23:41:01'),
(11, 'F-2026-011', 0, 'Envelop with documents', 'Other', NULL, 'Academic Building 2', '2026-09-28', '[\"uploads/found/found_2c2c1512788ba8ae.jpg\",\"uploads/found/found_c2c600906a8cfc20.jpg\",\"uploads/found/found_9afa0da282dc87a9.jpg\"]', 'Documents having CTC copy ROG and etc', NULL, NULL, 'returned', '2026-09-28 02:49:37'),
(12, NULL, 0, 'Red Lamp', '', 'Lamp', 'Academic Building 2', '2026-11-27', '[]', NULL, NULL, NULL, 'claimed', '2026-11-27 14:06:41'),
(22, NULL, 0, 'Phone Charger', 'Others', 'Type-C Charger', 'Admin Building 2nd Floor', '2026-11-27', '[\"uploads/found/found_d093e89e42761f38.jpg\",\"uploads/found/found_451e06281f153f91.jpg\",\"uploads/found/found_aa6a58f29c305296.jpg\"]', NULL, NULL, NULL, 'claimed', '2026-11-27 22:06:29');

-- --------------------------------------------------------

--
-- Table structure for table `item_images`
--

CREATE TABLE `item_images` (
  `id` int(10) UNSIGNED NOT NULL,
  `entity_type` enum('lost','found') NOT NULL,
  `entity_id` int(10) UNSIGNED NOT NULL,
  `photo_path` varchar(500) NOT NULL,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item_images`
--

INSERT INTO `item_images` (`id`, `entity_type`, `entity_id`, `photo_path`, `sort_order`, `created_at`) VALUES
(2, 'lost', 15, 'uploads/lost/lost_8bd3fd552e739c88.jpg', 0, '2026-09-27 23:39:06'),
(3, 'lost', 15, 'uploads/lost/lost_d95a5019a7107d76.jpg', 1, '2026-09-27 23:39:06'),
(4, 'found', 10, 'uploads/found/found_45558335300552f5.jpg', 0, '2026-09-27 23:41:01'),
(5, 'lost', 16, 'uploads/lost/lost_3d0b70c5119b5b91.jpg', 0, '2026-09-28 02:30:38'),
(6, 'lost', 16, 'uploads/lost/lost_38ad1c425515a632.jpg', 1, '2026-09-28 02:30:38'),
(7, 'lost', 16, 'uploads/lost/lost_8d55f0d39f73d891.jpg', 2, '2026-09-28 02:30:38'),
(8, 'lost', 16, 'uploads/lost/lost_31d77565fb8bc099.jpg', 3, '2026-09-28 02:30:38'),
(9, 'lost', 16, 'uploads/lost/lost_63ac52bd57cf2990.jpg', 4, '2026-09-28 02:30:38'),
(10, 'lost', 17, 'uploads/lost/lost_f0134b0301806ec5.jpg', 0, '2026-09-28 02:44:05'),
(11, 'lost', 17, 'uploads/lost/lost_a4dc5446c28cd7a0.jpg', 1, '2026-09-28 02:44:05'),
(12, 'found', 11, 'uploads/found/found_2c2c1512788ba8ae.jpg', 0, '2026-09-28 02:49:37'),
(13, 'found', 11, 'uploads/found/found_c2c600906a8cfc20.jpg', 1, '2026-09-28 02:49:37'),
(14, 'found', 11, 'uploads/found/found_9afa0da282dc87a9.jpg', 2, '2026-09-28 02:49:37'),
(16, 'found', 22, 'uploads/found/found_d093e89e42761f38.jpg', 0, '2026-11-27 22:06:29'),
(17, 'found', 22, 'uploads/found/found_451e06281f153f91.jpg', 1, '2026-11-27 22:06:29'),
(18, 'found', 22, 'uploads/found/found_aa6a58f29c305296.jpg', 2, '2026-11-27 22:06:29'),
(19, 'lost', 32, 'uploads/lost/lost_34c974563bd98168.jpg', 0, '2026-11-27 22:08:00');

-- --------------------------------------------------------

--
-- Table structure for table `item_matches`
--

CREATE TABLE `item_matches` (
  `id` int(10) UNSIGNED NOT NULL,
  `lost_item_id` int(10) UNSIGNED NOT NULL,
  `found_item_id` int(10) UNSIGNED NOT NULL,
  `score` decimal(5,2) NOT NULL DEFAULT 0.00,
  `status` enum('potential','needs_review','confirmed','no_match') NOT NULL DEFAULT 'potential',
  `similarity_json` text DEFAULT NULL,
  `reviewed_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item_matches`
--

INSERT INTO `item_matches` (`id`, `lost_item_id`, `found_item_id`, `score`, `status`, `similarity_json`, `reviewed_by`, `created_at`, `updated_at`) VALUES
(1, 3, 3, 100.00, 'potential', '[\"Same category\",\"Name looks similar\",\"Location overlaps\"]', NULL, '2026-09-26 18:30:00', '2026-09-28 03:09:01'),
(2, 4, 4, 68.00, 'no_match', '[\"Same category\",\"Name looks similar\",\"Location overlaps\"]', 0, '2026-09-24 00:10:00', '2026-09-28 03:11:33'),
(3, 9, 7, 100.00, 'no_match', '[\"Same category\",\"Name looks similar\",\"Location overlaps\"]', 0, '2026-09-27 01:05:00', '2026-09-28 03:09:01'),
(5, 8, 6, 88.00, 'potential', '[\"Same category\",\"Name looks similar\",\"Location overlaps\"]', NULL, '2026-09-27 23:41:32', '2026-09-28 03:09:01'),
(7, 15, 10, 60.00, 'potential', '[\"Same category\",\"Location overlaps\"]', NULL, '2026-09-27 23:41:32', '2026-09-27 23:41:46');

-- --------------------------------------------------------

--
-- Table structure for table `lost_items`
--

CREATE TABLE `lost_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `public_code` varchar(30) DEFAULT NULL,
  `reported_by` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` enum('Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other','Phones (Android)','Phones (Iphone)','ID lace','Food containers and utensils','Others') NOT NULL,
  `other_category` varchar(150) DEFAULT NULL,
  `last_seen_location` varchar(150) DEFAULT NULL,
  `date_lost` date NOT NULL,
  `photo_path` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `closed_reason` varchar(255) DEFAULT NULL,
  `matched_found_item_id` int(10) UNSIGNED DEFAULT NULL,
  `matched_at` datetime DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `status` enum('searching','matched','resolved','closed') NOT NULL DEFAULT 'searching',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lost_items`
--

INSERT INTO `lost_items` (`id`, `public_code`, `reported_by`, `item_name`, `category`, `other_category`, `last_seen_location`, `date_lost`, `photo_path`, `description`, `closed_reason`, `matched_found_item_id`, `matched_at`, `verified_at`, `resolved_at`, `closed_at`, `is_public`, `status`, `created_at`) VALUES
(2, 'LR-2026-002', 3, 'StudentID', 'ID', NULL, 'ADMIN', '2026-09-28', '[\"uploads/lost/lost_4d516da6f84afe7e.png\"]', 'LOST ID', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-09-27 18:57:31'),
(3, 'LR-2026-101', 2, 'Blue tumbler', 'Tumbler/Flask/Bottled Water', NULL, 'Cafeteria', '2026-09-26', '[\"uploads/lost/sample-bottle.jpg\"]', 'Blue tumbler left on a cafeteria table.', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-09-25 16:15:00'),
(4, 'LR-2026-102', 3, 'Black backpack', 'Bag', NULL, 'Library', '2026-09-24', '[\"uploads/lost/sample-bag.jpg\"]', 'Black backpack with a front zipper pocket.', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-09-23 19:40:00'),
(5, 'LR-2026-103', 2, 'Student ID', 'ID', NULL, 'Admin Building', '2026-09-27', '[]', 'UMak student ID in a clear plastic holder.', NULL, 8, '2026-09-27 15:00:00', '2026-09-28 09:10:00', NULL, NULL, 1, 'matched', '2026-09-26 17:05:00'),
(6, 'LR-2026-104', 2, 'Android phone', 'Phone (Android)', NULL, 'Gymnasium', '2026-09-25', '[\"uploads/found/sample-phone.jpg\"]', 'Dark Android phone in a blue case.', NULL, 5, '2026-09-28 16:10:00', NULL, NULL, NULL, 1, 'matched', '2026-09-25 00:20:00'),
(7, 'LR-2026-105', 3, 'iPhone', 'Phone (Iphone)', NULL, 'CAS Building', '2026-09-28', '[]', 'Silver iPhone last seen in a classroom.', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'matched', '2026-09-27 15:50:00'),
(8, 'LR-2026-106', 2, 'Spiral notebook', 'Notebook', NULL, 'HSU Lobby', '2026-09-24', '[\"uploads/found/sample-notebook.jpg\"]', 'Green spiral notebook with class notes.', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-09-23 22:10:00'),
(9, 'LR-2026-107', 3, 'White sneakers', 'Shoes', NULL, 'University Oval', '2026-09-26', '[\"uploads/found/sample-shoes.jpg\"]', 'Pair of white sneakers left by the bleachers.', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-09-25 21:25:00'),
(10, 'LR-2026-108', 2, 'Lace ribbon', 'Lace', NULL, 'Auditorium', '2026-09-27', '[]', 'White lace ribbon from a costume.', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'resolved', '2026-09-27 02:05:00'),
(11, 'LR-2026-109', 3, 'Tablet', 'Tablet', NULL, 'AVR', '2026-09-24', '[]', 'Gray tablet in a keyboard case.', NULL, 9, '2026-09-25 10:20:00', '2026-09-26 09:00:00', '2026-09-27 14:12:00', NULL, 1, 'resolved', '2026-09-23 18:30:00'),
(12, 'LR-2026-110', 2, 'Math textbook', 'Book', NULL, 'Library, 2nd floor', '2026-09-28', '[\"uploads/found/sample-notebook.jpg\"]', 'Hardcover math textbook.', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'resolved', '2026-09-27 20:45:00'),
(13, 'LR-2026-111', 3, 'Folding umbrella', 'Other', NULL, 'Gate 2', '2026-09-25', '[]', 'Black folding umbrella.', 'Owner recovered it elsewhere.', NULL, NULL, NULL, NULL, '2026-09-26 09:30:00', 1, 'closed', '2026-09-24 17:15:00'),
(14, 'LR-2026-112', 2, 'Steel flask', 'Tumbler/Flask/Bottled Water', NULL, 'Engineering Building', '2026-09-26', '[\"uploads/lost/sample-bottle.jpg\"]', 'Silver flask.', 'Report closed after a week with no match.', NULL, NULL, NULL, NULL, '2026-09-28 15:20:00', 1, 'closed', '2026-09-26 01:40:00'),
(15, 'LR-2026-015', 3, 'My Phone', 'Phone (Android)', NULL, 'Admin', '2026-09-28', '[\"uploads/lost/lost_8bd3fd552e739c88.jpg\",\"uploads/lost/lost_d95a5019a7107d76.jpg\"]', 'Drop it somewhere, has sticker on it', 'Item Returned', NULL, '2026-09-28 15:48:12', NULL, '2026-09-28 15:50:34', '2026-09-28 15:49:17', 1, 'resolved', '2026-09-27 23:39:06'),
(19, NULL, 2, 'dada', '', NULL, 'dadada', '2026-11-26', '[]', 'dada', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'resolved', '2026-11-26 09:53:00'),
(22, NULL, 3, 'Stone Prop', '', 'Stone Lamp Colored Like an Himalayan salt', 'ACAD B2', '2026-11-27', '[]', 'It looks like a giant Himalayan salt', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-11-27 14:05:10'),
(32, NULL, 3, 'Phone Charger', 'Others', 'Phone Charger', NULL, '2026-11-27', '[\"uploads/lost/lost_34c974563bd98168.jpg\"]', 'White colored Type-C wire and black adapter', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-11-27 22:08:00');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `category` enum('match','claim','report','system') NOT NULL,
  `title` varchar(180) NOT NULL,
  `body` text NOT NULL,
  `entity_type` varchar(40) DEFAULT NULL,
  `entity_id` int(10) UNSIGNED DEFAULT NULL,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `category`, `title`, `body`, `entity_type`, `entity_id`, `read_at`, `created_at`) VALUES
(2, 2, 'claim', 'Your claim is under review', 'Your claim for \"VERIFY-24ae3482-found\" is waiting for security verification.', 'claim', 1, '2026-11-27 01:52:30', '2026-09-27 18:38:24'),
(4, 2, 'match', 'A possible match was found', 'A found tumbler may match your lost report.', 'lost', 3, '2026-11-27 01:52:30', '2026-09-26 18:35:00'),
(18, 2, 'report', 'Lost Report Updated', 'Your lost item \"Math textbook\" is now marked resolved.', 'lost_item', 12, '2026-11-27 01:53:02', '2026-11-26 09:52:44'),
(20, 1, 'report', 'New Lost Item Report', 'JUSTIN ANGELES reported a lost Electronics: dada.', 'lost_item', 19, NULL, '2026-11-26 09:53:00'),
(22, 1, 'system', 'User Signed In', 'Administrator (admin) signed in.', 'user', 0, NULL, '2026-11-26 10:02:46'),
(23, 2, 'report', 'Lost Report Updated', 'Your lost item \"dada\" is now marked matched.', 'lost_item', 19, '2026-11-27 02:21:54', '2026-11-26 10:13:43'),
(24, 2, 'report', 'Lost Report Updated', 'Your lost item \"dada\" is now marked resolved.', 'lost_item', 19, '2026-11-27 02:21:54', '2026-11-26 10:14:00'),
(28, 1, 'system', 'User Signed In', 'JUSTIN ANGELES (student) signed in via Google.', 'user', 2, NULL, '2026-11-26 10:21:51'),
(30, 1, 'system', 'User Signed In', 'Administrator (admin) signed in.', 'user', 0, NULL, '2026-11-26 10:22:45'),
(31, 2, 'report', 'Lost Report Updated', 'Your lost item \"dada\" is now marked matched.', 'lost_item', 19, '2026-11-27 02:37:26', '2026-11-26 10:30:17'),
(35, 1, 'system', 'User Signed In', 'Administrator (admin) signed in.', 'user', 0, NULL, '2026-11-26 10:33:00'),
(36, 2, 'report', 'Lost Report Updated', 'Your lost item \"dada\" is now marked resolved.', 'lost_item', 19, '2026-11-27 02:37:26', '2026-11-26 10:33:19'),
(38, 1, 'system', 'User Signed In', 'Administrator (admin) signed in.', 'user', 0, NULL, '2026-11-26 10:34:38'),
(40, 1, 'system', 'Failed Login Attempt', 'Invalid password for administrator@umak.edu.ph (1/5 attempts).', 'user', 0, NULL, '2026-11-26 11:06:15'),
(42, 1, 'system', 'User Signed In', 'Administrator (admin) signed in.', 'user', 0, NULL, '2026-11-26 11:06:46'),
(44, 1, 'system', 'Failed Login Attempt', 'Invalid password for administrator@umak.edu.ph (1/5 attempts).', 'user', 0, NULL, '2026-11-27 13:56:49'),
(46, 1, 'system', 'Failed Login Attempt', 'Invalid password for administrator@umak.edu.ph (2/5 attempts).', 'user', 0, NULL, '2026-11-27 13:57:52'),
(48, 1, 'system', 'User Signed In', 'Administrator (admin) signed in.', 'user', 0, NULL, '2026-11-27 14:01:28'),
(54, 1, 'report', 'New Lost Item Report', 'RICHMHON PAPA reported a lost Others: Stone Prop.', 'lost_item', 22, NULL, '2026-11-27 14:05:10'),
(56, 1, 'report', 'New Found Item Logged', 'A Others item was turned in at Academic Building 2.', 'found_item', 12, NULL, '2026-11-27 14:06:41'),
(57, 2, 'report', 'New Found Item Logged', 'A Others item was turned in at Academic Building 2.', 'found_item', 12, NULL, '2026-11-27 14:06:41'),
(60, 1, 'claim', 'New Claim Pending Verification', 'RICHMHON PAPA filed a claim that requires verification.', 'claim', 8, NULL, '2026-11-27 14:08:45'),
(62, 3, 'claim', 'Claim Approved', 'Your claim was approved! Your pickup QR code is ready in Claims.', 'claim', 8, '2026-11-27 22:10:43', '2026-11-27 14:10:07'),
(63, 3, 'claim', 'Item Picked Up', 'Your pickup for \"Red Lamp\" has been verified.', 'pickup', 6, '2026-11-27 23:05:03', '2026-11-27 14:11:40'),
(64, 0, 'system', 'Failed Login Attempt', 'Invalid password for admin@umak.edu.ph (1/5 attempts).', 'user', 1, '2026-11-28 06:28:20', '2026-11-27 17:53:02'),
(65, 0, 'system', 'User Signed In', 'John Matthew S. Palma (security) signed in.', 'user', 1, '2026-11-28 06:28:20', '2026-11-27 17:54:58'),
(66, 0, 'system', 'Failed Login Attempt', 'Invalid password for rpapa.k12150334@umak.edu.ph (1/5 attempts).', 'user', 3, '2026-11-28 06:28:20', '2026-11-27 19:52:26'),
(67, 0, 'system', 'User Signed In', 'RICHMHON PAPA (student) signed in.', 'user', 3, '2026-11-28 06:28:20', '2026-11-27 19:52:59'),
(68, 0, 'report', 'New Found Item Logged', 'A Others item was turned in at Admin Building 2nd Floor.', 'found_item', 22, '2026-11-28 06:28:20', '2026-11-27 22:06:29'),
(69, 1, 'report', 'New Found Item Logged', 'A Others item was turned in at Admin Building 2nd Floor.', 'found_item', 22, NULL, '2026-11-27 22:06:29'),
(70, 2, 'report', 'New Found Item Logged', 'A Others item was turned in at Admin Building 2nd Floor.', 'found_item', 22, NULL, '2026-11-27 22:06:29'),
(71, 3, 'report', 'New Found Item Logged', 'A Others item was turned in at Admin Building 2nd Floor.', 'found_item', 22, NULL, '2026-11-27 22:06:29'),
(72, 0, 'report', 'New Lost Item Report', 'RICHMHON PAPA reported a lost Others: Phone Charger.', 'lost_item', 32, '2026-11-28 06:28:20', '2026-11-27 22:08:00'),
(73, 1, 'report', 'New Lost Item Report', 'RICHMHON PAPA reported a lost Others: Phone Charger.', 'lost_item', 32, NULL, '2026-11-27 22:08:00'),
(74, 0, 'claim', 'New Claim Pending Verification', 'RICHMHON PAPA filed a claim that requires verification.', 'claim', 9, '2026-11-28 06:28:20', '2026-11-27 22:09:01'),
(75, 1, 'claim', 'New Claim Pending Verification', 'RICHMHON PAPA filed a claim that requires verification.', 'claim', 9, NULL, '2026-11-27 22:09:01'),
(76, 3, 'claim', 'Claim Under Manual Review', 'Your claim has been flagged for manual review by security.', 'claim', 9, NULL, '2026-11-27 22:09:15'),
(77, 3, 'claim', 'Claim Approved', 'Your claim was approved! Your pickup QR code is ready in Claims. Pickup location: Please claim this at HPSB building 4th floor at parking lot near the vending machine', 'claim', 9, NULL, '2026-11-27 22:10:37');

-- --------------------------------------------------------

--
-- Table structure for table `pickups`
--

CREATE TABLE `pickups` (
  `id` int(10) UNSIGNED NOT NULL,
  `claim_id` int(10) UNSIGNED NOT NULL,
  `pickup_location` varchar(255) DEFAULT NULL,
  `qr_token` varchar(255) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `status` enum('pending','verified','expired','invalid') NOT NULL DEFAULT 'pending',
  `scheduled_for` datetime DEFAULT NULL,
  `scanned_at` datetime DEFAULT NULL,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `return_code` varchar(30) DEFAULT NULL,
  `return_method` varchar(80) DEFAULT NULL,
  `condition_note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pickups`
--

INSERT INTO `pickups` (`id`, `claim_id`, `pickup_location`, `qr_token`, `expires_at`, `status`, `scheduled_for`, `scanned_at`, `verified_by`, `return_code`, `return_method`, `condition_note`, `created_at`) VALUES
(1, 4, NULL, 'seedpickup000000000000000000000101', '2026-09-28 18:00:00', 'pending', '2026-09-28 15:00:00', NULL, NULL, NULL, NULL, NULL, '2026-09-27 17:15:00'),
(2, 5, NULL, 'seedpickup000000000000000000000102', '2026-09-27 18:00:00', 'verified', '2026-09-27 14:00:00', '2026-09-27 14:12:00', 0, 'RT-2026-102', 'Security office counter', NULL, '2026-09-25 17:05:00'),
(3, 6, NULL, '2cbc6f8c8f824f02fe8cc95f5f7870a5', NULL, 'verified', NULL, '2026-09-28 15:46:52', 0, 'RT-2026-003', NULL, NULL, '2026-09-27 23:44:43'),
(4, 7, NULL, '12bf990ddc06aa26e6f05f26ef9adda4', NULL, 'verified', NULL, '2026-09-28 18:56:34', 0, 'RT-2026-004', NULL, NULL, '2026-09-28 02:51:32'),
(5, 2, NULL, '920c1a95d5f1e953753611a3a8d17570db30836456bf4456bd32eec6da0a4e57', NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-26 09:28:01'),
(6, 8, NULL, '74f192220d1b65dd8dd41be65502be4222df2e258ec64b5cdf3f01681ed95ce3', NULL, 'pending', NULL, '2026-11-27 22:11:40', 0, NULL, NULL, NULL, '2026-11-27 14:10:07'),
(7, 9, 'Please claim this at HPSB building 4th floor at parking lot near the vending machine', '508db83456137c2062d78234162ac4795bd9305f6f955b73f0e7a74cc5c4dd27', NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-27 22:10:37');

-- --------------------------------------------------------

--
-- Table structure for table `saved_items`
--

CREATE TABLE `saved_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `entity_type` enum('lost','found') NOT NULL,
  `entity_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 2, '$2y$10$paS5gQQ3.TClPE9R2rCoXusjnu6gFJGGrHbJH2cyUibEGuENuZyR.', 'login', '2026-09-01 18:56:21', NULL, '2026-09-01 02:51:21'),
(2, 2, '$2y$10$9xvvr0hTnt720.vs17AVF.V8ETMvJUQBwHIVlBGFZvmT9h89zC9OK', 'login', '2026-09-01 19:01:33', NULL, '2026-09-01 02:56:33'),
(3, 2, '$2y$10$PVs39i2zftquZq9LL9AnL.2HLbqqREn88HUtxOY2QE2z0uVKyFvCa', 'login', '2026-09-01 19:06:52', NULL, '2026-09-01 03:01:52'),
(4, 2, '$2y$10$bG6B/6ZRE1JmZnYYGBjGXOnJ11fmyEEkdUcqB4UG74jktYx7hGKee', 'login', '2026-09-01 19:14:36', NULL, '2026-09-01 03:09:36'),
(5, 2, '$2y$10$Y0SvgaK4NszodHz2s44UTO0/Z8r7VRr.ug9B/amcLiBTtLRFDoZf.', 'login', '2026-09-01 19:21:28', NULL, '2026-09-01 03:16:28'),
(6, 2, '$2y$10$ArtFOTlGrby98AKKFE/7SeDCbuIG7CmMDgDwIaKYDE6q9Qr5UBPVy', 'login', '2026-09-01 19:21:38', NULL, '2026-09-01 03:16:38'),
(7, 2, '$2y$10$WpiWcyUSWfA3lkmgf.bNYeIVHjshNbG2YexqOyv3HjJS5vlTHFTc6', 'login', '2026-09-01 19:29:01', NULL, '2026-09-01 03:24:01'),
(8, 2, '$2y$10$gdeXg8ppfPEe9dFFiDLSRueOH9.kVAkQQye94Vy5m63Q6in.9UWwm', 'login', '2026-09-01 19:38:26', NULL, '2026-09-01 03:33:26'),
(9, 2, '$2y$10$Fx5we630LUKInwBTiGjteuEU8/QQQ4HjZt6.QpcslyvSl.1KOyeOS', 'login', '2026-09-01 19:38:35', NULL, '2026-09-01 03:33:35'),
(10, 2, '$2y$10$2j8AIbxQWEgwtEVCM1eLXep0k31LwmdltUMEHgRDQioMz8yPrcNV.', 'login', '2026-09-01 19:38:36', NULL, '2026-09-01 03:33:36'),
(11, 2, '$2y$10$uAldhQLUx1EQ/nDzUeVideAic7KbY1Ox44ULkF51IJwfXWKuxlXti', 'login', '2026-09-01 19:38:36', NULL, '2026-09-01 03:33:36'),
(12, 2, '$2y$10$ge4kMTZr9FCXeHsdyreuLO.LZoxM7I5I/wwVVJ0Z.fOhkWoHTNExm', 'login', '2026-09-01 19:38:36', NULL, '2026-09-01 03:33:36'),
(13, 2, '$2y$10$eDo6D472m.UZVPe3Im5ICuC0q1vldTsSX7DcLSxJ3T.Kxzx3Ci9HG', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 03:33:37'),
(14, 2, '$2y$10$JnsAYpsNoer/XKJAxvEc5OHLGYClPR4QElHVgN6uDukUBmmvG9ykS', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 03:33:37'),
(15, 2, '$2y$10$YB.UfOrtFQjTde9FI6nW8eAIVGdtKbdP6wFHUFJSJZrrC/kZIrht6', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 03:33:37'),
(16, 2, '$2y$10$gJfbzbKtWBhXHrVEaBULTu1uZgIzkpU0iIi/jXOiK1czbtw0hAeKu', 'login', '2026-09-01 19:38:37', NULL, '2026-09-01 03:33:37'),
(17, 2, '$2y$10$gQNS7mUX7GfrHJoHJLinsuEW1451gNYigDqpio60FHjfBzs9YJg.a', 'login', '2026-09-01 19:39:02', NULL, '2026-09-01 03:34:02'),
(18, 2, '$2y$10$4ZZKmg4iTWWn7YrJkpt5peK5viSIYBMj.dAO7KxCUnWPS0tZh610m', 'login', '2026-09-01 19:39:03', NULL, '2026-09-01 03:34:03'),
(19, 2, '$2y$10$./zi.LhaKNHcWX4EbhNMqOw0g/5K4PYnSlq3vcrLcwX04jkyxPY/O', 'login', '2026-09-01 19:40:54', NULL, '2026-09-01 03:35:54'),
(20, 2, '$2y$10$K2Qyym4B03.2WFZUMpZfEusEY9xDdkW8zklwMd8L3732Tkx0HuSQ6', 'login', '2026-09-01 19:48:24', NULL, '2026-09-01 03:43:24'),
(21, 2, '$2y$10$u5FPmmwzQXaDJuP7ehrs4uWAEuRXZkmL7YitWhyJ3HQ7crDrjteWO', 'login', '2026-09-01 19:48:26', NULL, '2026-09-01 03:43:26'),
(22, 2, '$2y$10$1VCyTMu4wG0iqtVk/Ub8/eSykKNQnx95YK1q.8WheFqsH9o6IKc5e', 'login', '2026-09-01 19:48:26', NULL, '2026-09-01 03:43:26'),
(23, 2, '$2y$10$OyuveOggKreU0a0TOh1RnuqnAjqngK5D8A73G.SBbgS0iFmuPtbTK', 'login', '2026-09-01 19:48:27', NULL, '2026-09-01 03:43:27'),
(24, 2, '$2y$10$NyOYOu3f2Is2Xt2rZqspzO/b/oIkcZ7VPTCyrxclRsVEcq8dHJ7nK', 'login', '2026-09-01 19:48:27', NULL, '2026-09-01 03:43:27'),
(25, 2, '$2y$10$aGd1jUiyKeE2K7omVptlmeVvR0Qc2EQ58GIvdcbs79e1qWSVZFEIy', 'login', '2026-09-01 19:48:27', NULL, '2026-09-01 03:43:27'),
(26, 2, '$2y$10$5z/kVecbwUldcJos7jTwzeLOtLPYpRUnsedd39M4TsjPYIUJNilA.', 'login', '2026-09-01 19:48:47', NULL, '2026-09-01 03:43:47'),
(27, 2, '$2y$10$YapTCLHLokNuJbBrbsFHs./8P4hLt12LxO9NN5VYSEqnVNDGrNUBe', 'login', '2026-09-01 19:49:21', NULL, '2026-09-01 03:44:21'),
(28, 2, '$2y$10$ulWLc7u/l7GJG1tnny4xC.mlgMRIFTJ6bdY/bFXco9bbDJavpM2U.', 'login', '2026-09-01 19:49:22', NULL, '2026-09-01 03:44:22'),
(29, 2, '$2y$10$1sCN4AtdIfUfQ1aoevmWKONiQZMdPicZbiy1Eai1VeLns.47ix3Wy', 'login', '2026-09-01 19:49:22', NULL, '2026-09-01 03:44:22'),
(30, 2, '$2y$10$m54WdkMadUybKC5Ayyy6YOAblvVmJNk5eTI8SzZhy17NsdvOz6Ho2', 'login', '2026-09-01 19:50:47', NULL, '2026-09-01 03:45:47'),
(31, 2, '$2y$10$5rsSEAPezbOb2QT/t5y5DOG07pt44hrSTXe3Ce4M9Vwzo/onoyqdG', 'login', '2026-09-01 19:51:02', NULL, '2026-09-01 03:46:02'),
(32, 2, '$2y$10$vwjoY8cbR3dbqEo7iTEYHORVGyjgzJUTBJRp6G49TneolTq6q0pna', 'login', '2026-09-01 19:51:03', NULL, '2026-09-01 03:46:03'),
(33, 2, '$2y$10$8Eh9S9YGrpnhYPR4XDieaOJICKI/IV2nKvZKgbZ6qx5ETew9Zzyoe', 'login', '2026-09-01 19:55:43', '2026-09-01 19:51:18', '2026-09-01 03:50:43'),
(34, 2, '$2y$10$8IzUGgNCGVNSXgoBFieTGO/bNmrGkGkbSZRvhIHu3lOngnHz6RnVa', 'login', '2026-09-01 19:57:52', '2026-09-01 19:53:02', '2026-09-01 03:52:52'),
(35, 2, '$2y$10$pwcbnONJTFGq.xTieF6y8.Zq1t5Hmnz.BeflmQ8m08njFDgxJHDIG', 'password_reset', '2026-09-01 20:08:48', '2026-09-01 20:04:10', '2026-09-01 04:03:48'),
(36, 2, '$2y$10$07XLvzD2Cb.ZpGvpBrioZOEDNNrYKNAmV.8d0/5kGYI1o3fLo6RBm', 'login', '2026-09-01 20:09:29', '2026-09-01 20:04:37', '2026-09-01 04:04:29'),
(37, 2, '$2y$10$RnXe8iwiaYr2749KRT/WqOCePj68JhvlYV.jmihE4uPoWEoX62/rW', 'password_reset', '2026-09-01 20:09:43', '2026-09-01 20:05:05', '2026-09-01 04:04:43'),
(38, 2, '$2y$10$/thIvrVIUcRozANB57kgAe7vUndfSSbdJd8SncXh1uyO9zjVaMzBK', 'login', '2026-09-01 20:18:49', NULL, '2026-09-01 04:13:49'),
(39, 2, '$2y$10$c9GFX10Exb4MotqYsw2wkORoo5cpl9H6Brcsy0nlYMTnCkWbY8.s.', 'login', '2026-09-01 20:19:13', NULL, '2026-09-01 04:14:13'),
(40, 2, '$2y$10$8Gl2BiX2ksM8nCXXCL/V/uzXUpMmyMe3z92cOXu3KND3lQ8XCAPDS', 'login', '2026-09-01 20:36:01', '2026-09-01 20:31:09', '2026-09-01 04:31:01'),
(41, 3, '$2y$10$JaHDSYMKLHXNyqda.F89muijt9EaxSGz/Aj2UllE.7KD8UWbiaQ26', 'login', '2026-09-28 11:47:24', NULL, '2026-09-27 19:42:24'),
(42, 3, '$2y$10$lncmRNTAemT5jA/lATiaFOYI9mxoGDr3JEHmaufWIyDB7VpMKlmJy', 'login', '2026-09-28 11:48:22', '2026-09-28 11:44:07', '2026-09-27 19:43:22'),
(43, 3, '$2y$10$8KdWIjulbV1QpedF353wdOEslUfp3LWXdT2w8jCJCth3VTJBUGMRy', 'login', '2026-09-28 11:50:09', NULL, '2026-09-27 19:45:09'),
(44, 3, '$2y$10$/lWDAjwghqfYYqX8ecGk5OWeSQZHK9IAuhB8pfEastqpg.7DKmKEK', 'login', '2026-09-28 11:59:38', NULL, '2026-09-27 19:54:38'),
(45, 3, '$2y$10$yYzP5Hd5VogStpfOhbaEguTjnrH2OlKcPHByZVlmhl8CVjHj4p8Iq', 'login', '2026-09-28 12:01:10', NULL, '2026-09-27 19:56:10'),
(46, 3, '$2y$10$McbkHTWVOm6yLwS6jK1C1uJhzpPus/2BpMAbxb3VYi0f0w.CmcFka', 'password_reset', '2026-09-28 12:17:12', '2026-09-28 12:12:52', '2026-09-27 20:12:12'),
(47, 0, '$2y$10$/VLLpyytsu.oli5TuLqWVuyI5j4ViYr1rDyZhQBKz2fw0DY/pXGlK', 'login', '2026-11-27 01:17:16', NULL, '2026-11-26 09:12:16'),
(48, 0, '$2y$10$oEYw8ueH9nS45S0D0ZpxYe4vlNxYpJ13Os2amejZt7GAMNfM/D9U6', 'login', '2026-11-27 01:17:54', NULL, '2026-11-26 09:12:54'),
(49, 0, '$2y$10$wKX3ZSoppZegH2pSL4XaguZtMOdPOOgfHlbK4Ge9Jrarbnk5HDd2W', 'login', '2026-11-27 01:27:15', NULL, '2026-11-26 09:22:15'),
(50, 0, '$2y$10$EKkeMHF/upt4OZ9TQtTdDOqwxjBMZpSkAt/n89KAS1ybK1jyYjVc6', 'login', '2026-11-27 01:32:09', '2026-11-27 01:27:28', '2026-11-26 09:27:09'),
(51, 2, '$2y$10$sYTEHSxjXmVpvH8FqKiT9ulyGbTa.WEWDV8/V/V/5IfNwKlD5N7wq', 'password_reset', '2026-11-27 02:04:39', NULL, '2026-11-26 09:59:39'),
(52, 0, '$2y$10$oRUBX5TNOzGT/PZ3eR10Xulb1DgOooaTp7yuAIwvWM0RMrUqy9v/u', 'login', '2026-11-27 02:07:19', '2026-11-27 02:02:45', '2026-11-26 10:02:19'),
(53, 0, '$2y$10$9hP12jGr/x1IYqCAtN.Lducx8aThKW4JahDrdUF8S0/W9hVSB0qNm', 'login', '2026-11-27 02:27:13', '2026-11-27 02:22:43', '2026-11-26 10:22:13'),
(54, 0, '$2y$10$CsKUjGEk9U6fhb.Q0v5h2eReUdZR/cPt75XogTuu2iIctj1GdMTCa', 'login', '2026-11-27 02:36:07', '2026-11-27 02:32:59', '2026-11-26 10:31:07'),
(55, 0, '$2y$10$nfizjhYfpjsSK8G7oNNLMO9.Lf7ZpR5nz9TBVVPB2S1jvg1F0yfGe', 'login', '2026-11-27 02:39:22', '2026-11-27 02:34:37', '2026-11-26 10:34:22'),
(56, 0, '$2y$10$p9CqVHiYxVtBnmxg98cG9exVCyxmDUQ80Hy5SCudX5HBzMNzOoyUO', 'login', '2026-11-27 03:11:34', '2026-11-27 03:06:45', '2026-11-26 11:06:34');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(150) NOT NULL,
  `student_id` varchar(30) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `program_department` varchar(150) DEFAULT NULL,
  `email_verified` tinyint(1) NOT NULL DEFAULT 0,
  `phone_verified` tinyint(1) NOT NULL DEFAULT 0,
  `last_login_at` datetime DEFAULT NULL,
  `notify_email` tinyint(1) NOT NULL DEFAULT 1,
  `notify_sms` tinyint(1) NOT NULL DEFAULT 0,
  `notify_in_app` tinyint(1) NOT NULL DEFAULT 1,
  `notify_matches` tinyint(1) NOT NULL DEFAULT 1,
  `notify_system` tinyint(1) NOT NULL DEFAULT 1,
  `share_lost_reports` tinyint(1) NOT NULL DEFAULT 1,
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
  `login_method` enum('email','totp') NOT NULL DEFAULT 'email',
  `status` enum('active','blocked','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `failed_attempts` int(10) UNSIGNED DEFAULT 0,
  `lockout_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `student_id`, `phone`, `program_department`, `email_verified`, `phone_verified`, `last_login_at`, `notify_email`, `notify_sms`, `notify_in_app`, `notify_matches`, `notify_system`, `share_lost_reports`, `full_name`, `password_hash`, `password_is_set`, `skip_password_prompt`, `role`, `auth_provider`, `google_id`, `avatar_url`, `totp_secret`, `totp_enabled`, `login_method`, `status`, `created_at`, `updated_at`, `failed_attempts`, `lockout_until`) VALUES
(0, 'administrator@umak.edu.ph', '[Administrator]', NULL, NULL, 1, 0, '2026-11-27 22:01:28', 1, 0, 1, 1, 1, 1, 'Administrator', '$2y$10$tVH52..5ZpfXsHR8Cp/6sevORJB2Hn9ZtN4EnZSCgGp/9dFdcWWbq', 1, 0, 'admin', 'local', NULL, NULL, 'OPNBHP3YLWJIMQMD', 1, 'totp', 'active', '2026-09-27 19:41:18', '2026-11-27 16:08:18', 0, NULL),
(1, 'admin@umak.edu.ph', '[Security]', NULL, NULL, 1, 0, '2026-11-28 01:54:58', 1, 0, 1, 1, 1, 1, 'John Matthew S. Palma', '$2y$10$tVH52..5ZpfXsHR8Cp/6sevORJB2Hn9ZtN4EnZSCgGp/9dFdcWWbq', 1, 0, 'security', 'local', NULL, NULL, 'ZVWI2DKNGNFVGNHI', 1, 'totp', 'active', '2026-09-01 02:42:39', '2026-11-27 17:54:58', 0, NULL),
(2, 'jangeles.a12345431@umak.edu.ph', 'A12345431', NULL, NULL, 1, 0, NULL, 1, 0, 1, 1, 1, 1, 'JUSTIN ANGELES', '$2y$10$vXoDV30IrWOFz3G2q5k9pO3QbEre2wA5SL3pIRYjjg8GtY89BACpG', 1, 0, 'professor', 'local', '113623321447473046632', 'https://lh3.googleusercontent.com/a/ACg8ocJUBdUOLKMk1w_XtsK8RKQ-0aJNkuvfdbPsMLP2o6yF3pZ01XI=s96-c', 'PQ2MSDBVMX3OJO6U', 0, 'email', 'active', '2026-09-01 02:50:13', '2026-11-27 16:10:46', 0, NULL),
(3, 'rpapa.k12150334@umak.edu.ph', 'K12150334', NULL, NULL, 1, 0, '2026-11-28 03:52:59', 1, 0, 1, 1, 1, 1, 'RICHMHON PAPA', '$2y$10$tVH52..5ZpfXsHR8Cp/6sevORJB2Hn9ZtN4EnZSCgGp/9dFdcWWbq', 1, 0, 'student', 'local', '116457197935379876137', 'https://lh3.googleusercontent.com/a/ACg8ocK1uq0sc53IbDwZpGkYhKSNYmjW4tdbJZCeiVHKfSnhM_OaO8-d=s96-c', 'VTF34SLHNPVC7SJA', 1, 'totp', 'active', '2026-09-01 05:22:57', '2026-11-27 19:52:59', 0, NULL);

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
  ADD UNIQUE KEY `uniq_claim_public_code` (`public_code`),
  ADD KEY `found_item_id` (`found_item_id`),
  ADD KEY `claimant_id` (`claimant_id`),
  ADD KEY `reviewed_by` (`reviewed_by`),
  ADD KEY `idx_claims_claimant` (`claimant_id`,`status`),
  ADD KEY `fk_claims_lost_item` (`lost_item_id`);

--
-- Indexes for table `found_items`
--
ALTER TABLE `found_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_found_public_code` (`public_code`),
  ADD KEY `logged_by` (`logged_by`);

--
-- Indexes for table `item_images`
--
ALTER TABLE `item_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_item_images` (`entity_type`,`entity_id`);

--
-- Indexes for table `item_matches`
--
ALTER TABLE `item_matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_item_match` (`lost_item_id`,`found_item_id`),
  ADD KEY `fk_match_found` (`found_item_id`),
  ADD KEY `fk_match_reviewer` (`reviewed_by`);

--
-- Indexes for table `lost_items`
--
ALTER TABLE `lost_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_lost_public_code` (`public_code`),
  ADD KEY `reported_by` (`reported_by`),
  ADD KEY `idx_lost_reported` (`reported_by`,`status`),
  ADD KEY `fk_lost_matched_found` (`matched_found_item_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user` (`user_id`,`read_at`,`created_at`);

--
-- Indexes for table `pickups`
--
ALTER TABLE `pickups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `claim_id` (`claim_id`),
  ADD UNIQUE KEY `qr_token` (`qr_token`),
  ADD KEY `verified_by` (`verified_by`);

--
-- Indexes for table `saved_items`
--
ALTER TABLE `saved_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_saved_item` (`user_id`,`entity_type`,`entity_id`);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

--
-- AUTO_INCREMENT for table `claims`
--
ALTER TABLE `claims`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `found_items`
--
ALTER TABLE `found_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `item_images`
--
ALTER TABLE `item_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `item_matches`
--
ALTER TABLE `item_matches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `lost_items`
--
ALTER TABLE `lost_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `pickups`
--
ALTER TABLE `pickups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `saved_items`
--
ALTER TABLE `saved_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sms_logs`
--
ALTER TABLE `sms_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `totp_challenges`
--
ALTER TABLE `totp_challenges`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  ADD CONSTRAINT `claims_ibfk_3` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_claims_lost_item` FOREIGN KEY (`lost_item_id`) REFERENCES `lost_items` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `found_items`
--
ALTER TABLE `found_items`
  ADD CONSTRAINT `found_items_ibfk_1` FOREIGN KEY (`logged_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `item_matches`
--
ALTER TABLE `item_matches`
  ADD CONSTRAINT `fk_match_found` FOREIGN KEY (`found_item_id`) REFERENCES `found_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_match_lost` FOREIGN KEY (`lost_item_id`) REFERENCES `lost_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_match_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `lost_items`
--
ALTER TABLE `lost_items`
  ADD CONSTRAINT `fk_lost_matched_found` FOREIGN KEY (`matched_found_item_id`) REFERENCES `found_items` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `lost_items_ibfk_1` FOREIGN KEY (`reported_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pickups`
--
ALTER TABLE `pickups`
  ADD CONSTRAINT `pickups_ibfk_1` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pickups_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `saved_items`
--
ALTER TABLE `saved_items`
  ADD CONSTRAINT `fk_saved_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
