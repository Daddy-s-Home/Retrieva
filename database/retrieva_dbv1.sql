-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 28, 2026 at 05:40 AM
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
-- Database: `clientsample`
--
CREATE DATABASE IF NOT EXISTS `clientsample` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `clientsample`;

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `User_ID` int(11) NOT NULL,
  `First_Name` varchar(100) NOT NULL,
  `Middle_Name` varchar(100) NOT NULL,
  `Last_Name` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Role` varchar(50) NOT NULL,
  `Password` varchar(30) NOT NULL,
  `Dept_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`User_ID`, `First_Name`, `Middle_Name`, `Last_Name`, `Email`, `Role`, `Password`, `Dept_ID`) VALUES
(1, 'Christian Joel', 'Solero', 'Caracas', 'ccaracas.k12150199@umak.edu.ph', 'Student', 'password123', 1),
(2, 'John Clerwin', 'Nilo', 'Dela Cruz', 'jdelacruz.k12151536@umak.edu.ph', 'Student', 'password123', 2),
(3, 'Reynaldo', 'Lozano', 'Maramag', 'rmaramag.a12345287@umak.edu.ph', 'Assesor', 'password12345', 1),
(4, 'Richmhon', 'Linganay', 'Papa', 'rpapa.k12150334@umak.edu.ph', 'Student', 'password12345', 2),
(5, 'Ron', 'Antonio', 'Suarez', 'rsuarez.a12345678@umak.edu.ph', 'Assesor', 'password123', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`User_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- Database: `dldash_db`
--
CREATE DATABASE IF NOT EXISTS `dldash_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `dldash_db`;

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `type` enum('Notice','Update','System','Event') NOT NULL DEFAULT 'Notice',
  `priority` enum('Low','Medium','High') DEFAULT 'Low',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `body_text` text NOT NULL,
  `status` enum('Active','Archived') NOT NULL DEFAULT 'Active',
  `image_path` varchar(255) DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `type`, `priority`, `start_date`, `end_date`, `body_text`, `status`, `image_path`, `author_id`, `created_at`, `updated_at`) VALUES
(1, 'Office Closure - Holiday Notice', 'Notice', 'Low', NULL, NULL, 'The office will be closed on April 25-26 in observance of the upcoming holidays. Normal operations will resume the following Monday.', 'Active', NULL, 1, '2026-03-26 13:40:16', NULL),
(2, 'New Case Management System Launch', 'System', 'Low', NULL, NULL, 'We are excited to announce the soft launch of our new internal case management tool. Training sessions will be held next week.', 'Active', NULL, 1, '2026-03-26 10:40:16', NULL),
(3, 'Updated Billing Guidelines', 'Update', 'Low', NULL, NULL, 'Please review the updated billing guidelines attached to this month\'s newsletter. All time entries must be logged by 5 PM every Friday.', 'Active', NULL, 2, '2026-03-25 15:40:16', NULL),
(4, 'Mandatory HR Training', 'Notice', 'Low', NULL, NULL, 'A reminder to all employees to complete the mandatory HR compliance module by the end of the month.', 'Active', NULL, 2, '2026-03-24 15:40:16', NULL),
(5, 'Monthly Townhall Meeting', 'Event', 'Low', NULL, NULL, 'Join us for our monthly townhall meeting this Friday at the 18th Floor Executive Boardroom. We will discuss Q1 performance.', 'Active', NULL, 1, '2026-03-23 15:40:16', NULL),
(6, 'New Policy Implemented', 'Notice', 'Low', '2026-05-08', '2027-05-08', 'edit testing', 'Archived', NULL, 4, '2026-04-10 17:32:20', '2026-05-07 22:12:14'),
(7, 'dfasfasf', 'Notice', 'Low', '2026-04-27', '2026-04-27', 'Birthday', 'Active', NULL, 2, '2026-04-25 20:06:05', NULL),
(8, 'System Maintenance - May 15', 'System', 'High', NULL, NULL, 'The dashboard will be offline from 2 AM to 4 AM for database optimization.', 'Active', NULL, 1, '2026-05-10 22:18:48', NULL),
(9, 'New Associate Welcome', 'Notice', 'Low', NULL, NULL, 'Please welcome our new Junior Associates joining the litigation team.', 'Active', NULL, 2, '2026-05-10 22:18:48', NULL),
(10, 'Updated Security Protocol', 'Update', 'Medium', NULL, NULL, 'Two-factor authentication is now mandatory for all users accessing from external IPs.', 'Active', NULL, 4, '2026-05-10 22:18:48', '2026-05-11 11:45:18'),
(11, 'Summer Team Building', 'Event', 'Low', NULL, NULL, 'Mark calendars for June 20th! More details to follow.', 'Active', NULL, 2, '2026-05-10 22:18:48', NULL),
(12, 'Library Quiet Hours', 'Notice', 'Low', NULL, NULL, 'The 18th floor library is reserved for quiet study every Tuesday morning.', 'Active', NULL, 1, '2026-05-10 22:18:48', NULL),
(13, 'AWS HERONS AW AAW', 'Event', 'Low', '2026-05-07', '2026-05-31', 'Cursor Event', 'Archived', NULL, 4, '2026-05-13 19:39:00', '2026-05-13 03:39:58');

-- --------------------------------------------------------

--
-- Table structure for table `announcement_reads`
--

CREATE TABLE `announcement_reads` (
  `user_id` int(11) NOT NULL,
  `announcement_id` int(11) NOT NULL,
  `read_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcement_reads`
--

INSERT INTO `announcement_reads` (`user_id`, `announcement_id`, `read_at`) VALUES
(3, 8, '2026-05-13 21:50:58'),
(4, 1, '2026-05-08 17:59:09'),
(4, 2, '2026-05-08 17:59:09'),
(4, 3, '2026-05-08 17:59:14'),
(4, 4, '2026-05-08 17:59:14'),
(4, 5, '2026-05-08 17:59:15'),
(4, 6, '2026-05-08 13:27:30'),
(4, 7, '2026-05-08 13:21:24'),
(4, 8, '2026-05-13 18:56:40'),
(4, 13, '2026-05-13 19:39:01'),
(5, 8, '2026-05-15 09:00:00'),
(15, 8, '2026-05-15 09:10:00');

-- --------------------------------------------------------

--
-- Table structure for table `asset_assignments`
--

CREATE TABLE `asset_assignments` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `assigned_date` date NOT NULL,
  `returned_date` date DEFAULT NULL,
  `status` enum('Active','Returned','Lost','Stolen') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `module` varchar(50) DEFAULT NULL,
  `table_affected` varchar(50) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `before_value` text DEFAULT NULL,
  `after_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `module`, `table_affected`, `record_id`, `ip_address`, `timestamp`, `before_value`, `after_value`) VALUES
(1, 2, 'Approved Overtime Request', 'HRIS', 'overtime_requests', 3, '192.168.1.45', '2026-04-11 07:51:20', 'Status: Pending', 'Status: Approved by HR Admin'),
(2, 4, 'Denied Leave Request', 'HRIS', 'leave_requests', 7, '192.168.1.105', '2026-04-11 07:41:48', 'Status: Pending Approval', 'Status: Denied (Reason: nawala nanaman ang logout)'),
(3, 1, 'Updated Announcement', 'Dashboard', 'announcements', 6, '127.0.0.1', '2026-04-10 17:32:20', 'Content: testing polyc', 'Content: Updated New Policy Implemented'),
(4, 4, 'Created Room Reservation', 'Room Reservation', 'reservations', 15, '192.168.1.105', '2026-04-11 07:50:05', NULL, 'New Reservation: Client Meeting in Room C'),
(5, 2, 'User Clock-In', 'Attendance', 'dtr_logs', 12, '192.168.1.45', '2026-04-10 17:30:28', NULL, 'Clocked In at 2026-04-10 17:30:28'),
(6, 4, 'Export Monthly Payroll DTR Summary', 'Reports', NULL, NULL, NULL, '2026-04-17 08:03:20', NULL, '{\"format\":\"pdf\",\"period\":\"Apr 1 \\u2013 Apr 17, 2026\"}'),
(7, 3, 'Export System Audit Trail Export', 'Reports', NULL, NULL, NULL, '2026-04-17 14:20:42', NULL, '{\"format\":\"excel\",\"period\":\"Apr 1 \\u2013 Apr 17, 2026\"}'),
(8, 2, 'Export Monthly Payroll DTR Summary', 'Reports', NULL, NULL, NULL, '2026-04-18 05:04:05', NULL, '{\"format\":\"pdf\",\"period\":\"Apr 1 \\u2013 Apr 30, 2026\"}'),
(9, 1, 'Accessed Dashboard Data', 'Dashboard', 'reservations', NULL, '192.168.1.1', '2026-05-10 03:24:48', NULL, NULL),
(10, 5, 'Clocked In', 'HRIS', 'dtr_logs', NULL, '192.168.1.50', '2026-05-15 08:30:00', NULL, '{\"time_in\":\"2026-05-15 08:30:00\"}'),
(11, 21, 'Clocked In', 'HRIS', 'dtr_logs', NULL, '192.168.1.51', '2026-05-15 08:45:00', NULL, '{\"time_in\":\"2026-05-15 08:45:00\"}'),
(12, 45, 'Clocked In', 'HRIS', 'dtr_logs', NULL, '192.168.1.52', '2026-05-15 08:50:00', NULL, '{\"time_in\":\"2026-05-15 08:50:00\"}');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`) VALUES
(1, 'Administrator'),
(2, 'Human Resource'),
(3, 'Department Superiors'),
(4, 'Office Management'),
(5, 'Computer-Aided Design Department'),
(6, 'IT Department'),
(7, 'Finance Department'),
(8, 'Lawyer Department');

-- --------------------------------------------------------

--
-- Table structure for table `dtr_logs`
--

CREATE TABLE `dtr_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time_in` datetime DEFAULT NULL,
  `time_out` datetime DEFAULT NULL,
  `image_path_in` varchar(255) DEFAULT NULL,
  `image_path_out` varchar(255) DEFAULT NULL,
  `location_data` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dtr_logs`
--

INSERT INTO `dtr_logs` (`id`, `user_id`, `time_in`, `time_out`, `image_path_in`, `image_path_out`, `location_data`, `created_at`) VALUES
(1, 2, '2026-04-02 09:00:00', '2026-04-02 18:00:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(2, 4, '2026-04-02 09:45:00', '2026-04-02 18:00:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(3, 3, '2026-04-02 08:45:00', '2026-04-02 18:05:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(4, 3, '2026-04-02 08:55:00', NULL, NULL, NULL, NULL, '2026-04-10 22:13:00'),
(5, 2, '2026-04-03 08:50:00', '2026-04-03 21:00:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(6, 3, '2026-04-03 10:00:00', '2026-04-03 20:30:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(7, 2, NULL, '2026-04-10 18:00:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(8, 2, '2026-04-05 09:00:00', '2026-04-05 18:00:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(9, 3, '2026-04-09 08:30:00', '2026-04-09 18:15:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(11, 4, '2026-04-10 09:15:00', '2026-04-10 18:15:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(12, 2, '2026-04-10 08:55:00', '2026-04-10 22:00:00', NULL, NULL, NULL, '2026-04-10 22:13:00'),
(13, 4, '2026-04-11 08:50:00', '2026-04-11 18:00:00', NULL, NULL, NULL, '2026-04-11 07:40:24'),
(14, 2, '2026-04-18 08:50:00', NULL, NULL, NULL, NULL, '2026-04-18 03:55:07'),
(15, 3, '2026-04-21 10:30:00', '2026-04-21 18:00:00', NULL, NULL, NULL, '2026-04-21 16:53:57'),
(16, 4, '2026-04-24 08:45:00', '2026-04-24 20:00:00', NULL, NULL, NULL, '2026-04-24 22:39:26'),
(17, 3, '2026-04-25 09:00:00', '2026-04-25 18:00:00', NULL, NULL, NULL, '2026-04-25 15:11:32'),
(18, 2, '2026-04-25 09:05:00', '2026-04-25 18:00:00', NULL, NULL, NULL, '2026-04-25 19:37:26'),
(19, 2, '2026-04-26 08:50:00', '2026-04-26 19:30:00', NULL, NULL, NULL, '2026-04-26 14:17:57'),
(20, 4, '2026-05-06 08:55:00', '2026-05-06 18:02:00', NULL, NULL, NULL, '2026-05-06 16:41:34'),
(21, 4, '2026-05-08 08:00:50', '2026-05-08 20:35:12', NULL, NULL, NULL, '2026-05-08 20:34:53'),
(22, 1, '2026-05-01 12:03:00', '2026-05-01 19:32:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(23, 1, '2026-05-01 09:11:00', '2026-05-01 17:15:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(24, 1, '2026-05-01 09:54:00', '2026-05-01 19:21:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(25, 4, '2026-05-01 08:05:00', '2026-05-01 17:51:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(26, 4, '2026-05-01 10:26:00', '2026-05-01 17:21:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(27, 2, '2026-05-01 12:10:00', '2026-05-01 17:24:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(28, 3, '2026-05-01 09:45:00', '2026-05-01 17:26:00', NULL, NULL, NULL, '2026-05-10 22:18:48'),
(29, 5, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(30, 6, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(31, 7, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(32, 8, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(33, 9, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(34, 10, '2026-05-15 08:40:00', '2026-05-15 17:50:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(35, 11, '2026-05-15 08:55:00', '2026-05-15 18:05:00', NULL, NULL, NULL, '2026-05-15 18:15:00'),
(36, 12, '2026-05-15 08:20:00', '2026-05-15 17:20:00', NULL, NULL, NULL, '2026-05-15 17:30:00'),
(37, 13, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(38, 14, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(39, 15, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(40, 16, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(41, 17, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(42, 18, '2026-05-15 08:40:00', '2026-05-15 17:50:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(43, 19, '2026-05-15 08:55:00', '2026-05-15 18:05:00', NULL, NULL, NULL, '2026-05-15 18:15:00'),
(44, 20, '2026-05-15 08:20:00', '2026-05-15 17:20:00', NULL, NULL, NULL, '2026-05-15 17:30:00'),
(45, 21, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(46, 22, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(47, 23, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(48, 24, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(49, 25, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(50, 26, '2026-05-15 08:40:00', '2026-05-15 17:50:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(51, 27, '2026-05-15 08:55:00', '2026-05-15 18:05:00', NULL, NULL, NULL, '2026-05-15 18:15:00'),
(52, 28, '2026-05-15 08:20:00', '2026-05-15 17:20:00', NULL, NULL, NULL, '2026-05-15 17:30:00'),
(53, 29, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(54, 30, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(55, 31, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(56, 32, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(57, 33, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(58, 34, '2026-05-15 08:40:00', '2026-05-15 17:50:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(59, 35, '2026-05-15 08:55:00', '2026-05-15 18:05:00', NULL, NULL, NULL, '2026-05-15 18:15:00'),
(60, 36, '2026-05-15 08:20:00', '2026-05-15 17:20:00', NULL, NULL, NULL, '2026-05-15 17:30:00'),
(61, 37, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(62, 38, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(63, 39, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(64, 40, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(65, 41, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(66, 42, '2026-05-15 08:40:00', '2026-05-15 17:50:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(67, 43, '2026-05-15 08:55:00', '2026-05-15 18:05:00', NULL, NULL, NULL, '2026-05-15 18:15:00'),
(68, 44, '2026-05-15 08:20:00', '2026-05-15 17:20:00', NULL, NULL, NULL, '2026-05-15 17:30:00'),
(69, 45, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(70, 46, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(71, 47, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(72, 48, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(73, 49, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(74, 50, '2026-05-15 08:40:00', '2026-05-15 17:50:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(75, 51, '2026-05-15 08:55:00', '2026-05-15 18:05:00', NULL, NULL, NULL, '2026-05-15 18:15:00'),
(76, 52, '2026-05-15 08:20:00', '2026-05-15 17:20:00', NULL, NULL, NULL, '2026-05-15 17:30:00'),
(77, 53, '2026-05-15 08:30:00', '2026-05-15 17:30:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(78, 54, '2026-05-15 08:45:00', '2026-05-15 17:45:00', NULL, NULL, NULL, '2026-05-15 18:00:00'),
(79, 55, '2026-05-15 08:50:00', '2026-05-15 18:00:00', NULL, NULL, NULL, '2026-05-15 18:10:00'),
(80, 56, '2026-05-15 09:00:00', '2026-05-15 18:15:00', NULL, NULL, NULL, '2026-05-15 18:20:00'),
(81, 57, '2026-05-15 08:35:00', '2026-05-15 17:35:00', NULL, NULL, NULL, '2026-05-15 18:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_items`
--

CREATE TABLE `inventory_items` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `category_id` int(11) NOT NULL,
  `stock_qty` int(11) DEFAULT 0,
  `unit_price` decimal(10,2) DEFAULT 0.00,
  `min_threshold` int(11) DEFAULT 10,
  `location` varchar(100) DEFAULT '18th Floor Inventory Room'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_items`
--

INSERT INTO `inventory_items` (`id`, `name`, `category_id`, `stock_qty`, `unit_price`, `min_threshold`, `location`) VALUES
(1, 'A4 Bond Paper', 1, 3, 180.00, 10, 'Secretarial Dept'),
(2, 'Printer Ink (Black)', 2, 1, 450.00, 5, 'Admin Office'),
(3, 'Staple Wire', 1, 2, 45.00, 10, 'Legal Dept'),
(4, 'Whiteboard Markers', 1, 4, 120.00, 8, 'Conference Room');

-- --------------------------------------------------------

--
-- Table structure for table `item_categories`
--

CREATE TABLE `item_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item_categories`
--

INSERT INTO `item_categories` (`id`, `name`) VALUES
(1, 'Office Supplies'),
(2, 'Consumables'),
(3, 'Equipment');

-- --------------------------------------------------------

--
-- Table structure for table `leave_balances`
--

CREATE TABLE `leave_balances` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `total_days` int(11) NOT NULL DEFAULT 0,
  `used_days` int(11) NOT NULL DEFAULT 0,
  `year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_balances`
--

INSERT INTO `leave_balances` (`id`, `user_id`, `leave_type_id`, `total_days`, `used_days`, `year`) VALUES
(1, 3, 1, 15, 2, 2026),
(2, 3, 2, 10, 2, 2026),
(3, 3, 6, 5, 5, 2026),
(4, 4, 1, 15, 7, 2026),
(5, 4, 2, 10, 2, 2026),
(6, 4, 6, 5, 0, 2026),
(100, 2, 1, 15, 0, 2026),
(101, 2, 2, 10, 2, 2026),
(102, 2, 6, 5, 0, 2026),
(103, 5, 1, 15, 0, 2026),
(104, 6, 1, 15, 0, 2026),
(105, 7, 1, 15, 0, 2026),
(106, 8, 1, 15, 0, 2026),
(107, 9, 1, 15, 0, 2026),
(108, 10, 1, 15, 0, 2026),
(109, 11, 1, 15, 0, 2026),
(110, 12, 1, 15, 0, 2026),
(111, 13, 1, 15, 0, 2026),
(112, 14, 1, 15, 0, 2026),
(113, 15, 1, 15, 0, 2026),
(114, 16, 1, 15, 0, 2026),
(115, 17, 1, 15, 0, 2026),
(116, 18, 1, 15, 0, 2026),
(117, 19, 1, 15, 0, 2026),
(118, 20, 1, 15, 0, 2026),
(119, 21, 1, 15, 0, 2026),
(120, 22, 1, 15, 0, 2026),
(121, 23, 1, 15, 0, 2026),
(122, 24, 1, 15, 0, 2026),
(123, 25, 1, 15, 0, 2026),
(124, 26, 1, 15, 0, 2026),
(125, 27, 1, 15, 0, 2026),
(126, 28, 1, 15, 0, 2026),
(127, 29, 1, 15, 0, 2026),
(128, 30, 1, 15, 0, 2026),
(129, 31, 1, 15, 0, 2026),
(130, 32, 1, 15, 0, 2026),
(131, 33, 1, 15, 0, 2026),
(132, 34, 1, 15, 0, 2026),
(133, 35, 1, 15, 0, 2026),
(134, 36, 1, 15, 0, 2026),
(135, 37, 1, 15, 0, 2026),
(136, 38, 1, 15, 0, 2026),
(137, 39, 1, 15, 0, 2026),
(138, 40, 1, 15, 0, 2026),
(139, 41, 1, 15, 0, 2026),
(140, 42, 1, 15, 0, 2026),
(141, 43, 1, 15, 0, 2026),
(142, 44, 1, 15, 0, 2026),
(143, 45, 1, 15, 0, 2026),
(144, 46, 1, 15, 0, 2026),
(145, 47, 1, 15, 0, 2026),
(146, 48, 1, 15, 0, 2026),
(147, 49, 1, 15, 0, 2026),
(148, 50, 1, 15, 0, 2026),
(149, 51, 1, 15, 0, 2026),
(150, 52, 1, 15, 0, 2026),
(151, 53, 1, 15, 0, 2026),
(152, 54, 1, 15, 0, 2026),
(153, 55, 1, 15, 0, 2026),
(154, 56, 1, 15, 0, 2026),
(155, 57, 1, 15, 0, 2026);

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int(11) NOT NULL,
  `reason` text DEFAULT NULL,
  `phase1_status` enum('Pending','Approved','Denied') DEFAULT 'Pending',
  `phase1_approver_id` int(11) DEFAULT NULL,
  `phase2_status` enum('Pending','Approved','Denied') DEFAULT 'Pending',
  `phase2_approver_id` int(11) DEFAULT NULL,
  `phase2_remarks` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_requests`
--

INSERT INTO `leave_requests` (`id`, `user_id`, `leave_type_id`, `start_date`, `end_date`, `total_days`, `reason`, `phase1_status`, `phase1_approver_id`, `phase2_status`, `phase2_approver_id`, `phase2_remarks`, `created_at`) VALUES
(1, 2, 1, '2026-04-03', '2026-04-04', 2, 'hello', 'Denied', 4, 'Pending', NULL, 'Auto-cancelled: Expired', '2026-04-01 22:43:32'),
(2, 2, 2, '2026-04-17', '2026-04-18', 2, 'mamamo', 'Denied', 4, 'Pending', NULL, NULL, '2026-04-01 22:52:28'),
(3, 2, 3, '2026-04-16', '2026-04-13', -2, 'vghgh', 'Denied', 2, 'Pending', NULL, 'Auto-cancelled: Expired', '2026-04-02 17:44:59'),
(4, 2, 1, '2026-04-02', '2026-04-01', 0, 'khkhk', 'Approved', 4, 'Denied', 4, '', '2026-04-02 17:46:04'),
(5, 4, 5, '2026-04-13', '2026-04-17', 5, 'Personal Matters', 'Approved', 4, 'Approved', 4, '', '2026-04-10 00:50:40'),
(6, 4, 1, '2026-04-20', '2026-04-24', 5, 'haha sabog na ko', 'Approved', 4, 'Approved', 4, '', '2026-04-10 11:49:29'),
(7, 4, 1, '2026-04-20', '2026-04-22', 3, 'nawala nanaman ang logout', 'Approved', 4, 'Denied', 4, '', '2026-04-11 07:41:48'),
(8, 4, 1, '2026-04-21', '2026-04-30', 10, 'asdasdadsa', 'Approved', 4, 'Approved', 4, '', '2026-04-21 16:09:02'),
(9, 4, 2, '2026-04-27', '2026-04-28', 2, 'sick', 'Denied', 4, 'Pending', NULL, NULL, '2026-04-24 22:40:25'),
(10, 4, 1, '2026-05-01', '2026-05-02', 2, 'a', 'Denied', NULL, 'Denied', NULL, 'Auto-cancelled: Expired', '2026-04-24 22:56:17'),
(11, 3, 2, '2026-04-25', '2026-04-25', 1, 'ddd', 'Pending', NULL, 'Pending', NULL, NULL, '2026-04-25 15:12:26'),
(12, 2, 4, '2026-04-30', '2026-05-01', 2, 'FAD', 'Approved', 2, 'Approved', 2, '', '2026-04-25 19:40:05');

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `is_paid` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_types`
--

INSERT INTO `leave_types` (`id`, `name`, `is_paid`) VALUES
(1, 'Vacation Leave', 1),
(2, 'Sick Leave', 1),
(3, 'Bereavement Leave', 1),
(4, 'Without Pay', 0),
(5, 'Other Leave', 1),
(6, 'Personal Leave', 1),
(7, 'Paternal', 0);

-- --------------------------------------------------------

--
-- Table structure for table `overtime_requests`
--

CREATE TABLE `overtime_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ot_date` date NOT NULL,
  `hours` decimal(4,2) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('Pending','Approved','Denied') DEFAULT 'Pending',
  `approved_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `overtime_requests`
--

INSERT INTO `overtime_requests` (`id`, `user_id`, `ot_date`, `hours`, `reason`, `status`, `approved_by`, `created_at`) VALUES
(1, 2, '2026-04-05', 3.00, 'dasdad', 'Pending', NULL, '2026-04-05 06:15:13'),
(2, 4, '2026-04-10', 7.00, 'Refactor and RBAC\r\n', 'Denied', 4, '2026-04-10 00:51:08'),
(3, 4, '2026-04-12', 6.00, 'OVERTIME', 'Approved', 4, '2026-04-11 07:51:20'),
(4, 4, '2026-04-24', 8.00, 'fixing stuff', 'Pending', NULL, '2026-04-24 22:40:49'),
(5, 4, '2026-05-08', 5.00, 'Hour Test', 'Approved', 4, '2026-05-08 20:36:24'),
(6, 2, '2026-05-10', 4.50, 'Heavy case load and filing deadlines', 'Approved', NULL, '2026-05-10 22:18:48'),
(7, 3, '2026-05-10', 4.50, 'Heavy case load and filing deadlines', 'Approved', NULL, '2026-05-10 22:18:48'),
(8, 1, '2026-05-10', 4.50, 'Heavy case load and filing deadlines', 'Approved', NULL, '2026-05-10 22:18:48');

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `meeting_type` enum('Internal','Client') NOT NULL,
  `client_name` varchar(150) DEFAULT NULL,
  `attendee_count` int(11) NOT NULL DEFAULT 1,
  `attendee_names` text DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `it_assistance` tinyint(1) DEFAULT 0,
  `status` enum('Pending Confirmation','Approved','Ongoing','Completed','Rejected','Cancelled') DEFAULT 'Pending Confirmation',
  `created_at` datetime DEFAULT current_timestamp(),
  `rejected_at` datetime DEFAULT NULL,
  `override_by` int(11) DEFAULT NULL,
  `override_reason` text DEFAULT NULL,
  `paired_room_id` int(11) DEFAULT NULL,
  `is_lawyer_priority` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `user_id`, `title`, `room_id`, `meeting_type`, `client_name`, `attendee_count`, `attendee_names`, `start_time`, `end_time`, `it_assistance`, `status`, `created_at`, `rejected_at`, `override_by`, `override_reason`, `paired_room_id`, `is_lawyer_priority`) VALUES
(15, 4, 'Client Meeting', 3, 'Client', '', 1, '', '2026-04-11 11:00:00', '2026-04-11 12:00:00', 0, 'Cancelled', '2026-04-11 07:50:05', NULL, 4, NULL, NULL, 1),
(16, 3, 'Client Meeting', 3, 'Client', '', 1, '', '2026-04-21 17:00:00', '2026-04-21 19:00:00', 0, 'Cancelled', '2026-04-21 16:56:02', NULL, NULL, NULL, NULL, 1),
(17, 3, 'Client Meeting', 4, 'Client', '', 1, '', '2026-04-21 17:00:00', '2026-04-21 19:00:00', 0, 'Cancelled', '2026-04-21 16:56:59', NULL, NULL, NULL, NULL, 1),
(18, 4, 'Internal Meeting', 1, 'Internal', '', 1, '', '2026-04-21 18:00:00', '2026-04-21 19:00:00', 0, 'Cancelled', '2026-04-21 17:38:06', NULL, NULL, NULL, NULL, 0),
(19, 4, 'Client Meeting', 3, 'Client', '', 1, '', '2026-04-23 17:00:00', '2026-04-23 18:30:00', 1, 'Approved', '2026-04-23 16:19:51', NULL, 4, NULL, NULL, 0),
(20, 4, 'Internal Meeting', 3, 'Internal', '', 2, 'Kevin, Christian', '2026-04-25 13:00:00', '2026-04-25 14:00:00', 0, 'Rejected', '2026-04-25 12:23:40', '2026-04-25 19:53:20', NULL, NULL, NULL, 0),
(21, 4, 'Client Meeting', 4, 'Client', '', 1, 'ako lng', '2026-04-25 13:00:00', '2026-04-25 14:00:00', 1, 'Cancelled', '2026-04-25 12:38:31', NULL, NULL, NULL, NULL, 0),
(22, 2, 'Client Meeting', 1, 'Client', '', 12, 'ADAS,DASDAS', '2026-04-29 08:00:00', '2026-04-29 19:00:00', 1, 'Approved', '2026-04-25 19:47:27', NULL, 2, NULL, 2, 1),
(23, 3, 'Client Meeting', 1, 'Client', '', 6, 'dsdsdsgfdsdsdsds', '2026-05-07 08:00:00', '2026-05-07 12:00:00', 1, 'Cancelled', '2026-05-06 23:06:52', NULL, NULL, NULL, NULL, 0),
(24, 3, 'Client Meeting', 1, 'Client', '', 12, 'sadafdfdfddsds', '2026-05-07 15:00:00', '2026-05-07 16:00:00', 1, 'Cancelled', '2026-05-06 23:17:38', NULL, NULL, NULL, 2, 0),
(25, 4, 'Internal Meeting', 3, 'Internal', '', 3, 'Richmhon Papa, Kevin Cris Layco, Christian Joel Caracas', '2026-05-12 08:00:00', '2026-05-12 10:00:00', 0, 'Cancelled', '2026-05-11 01:49:40', NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `reservation_attendees`
--

CREATE TABLE `reservation_attendees` (
  `id` int(11) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'Admin'),
(2, 'HR'),
(3, 'Lawyer'),
(4, 'IT'),
(5, 'Superior'),
(6, 'Operations'),
(7, 'Finance'),
(8, 'CAD');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `floor_level` int(11) NOT NULL,
  `base_capacity` int(11) DEFAULT 6,
  `paired_room_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `floor_level`, `base_capacity`, `paired_room_id`) VALUES
(1, 'Room A', 8, 6, 2),
(2, 'Room B', 8, 6, 1),
(3, 'Room C', 8, 5, 4),
(4, 'Room D', 8, 5, 3),
(5, 'Room E', 8, 6, 6),
(6, 'Room F', 8, 6, 5),
(7, 'Room G', 8, 6, 8),
(8, 'Room H', 8, 6, 7),
(9, 'Room A', 18, 7, 10),
(10, 'Room B', 18, 7, 9),
(11, 'Room C', 18, 7, 12),
(12, 'Room D', 18, 7, 11);

-- --------------------------------------------------------

--
-- Table structure for table `totp_reset_requests`
--

CREATE TABLE `totp_reset_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `remark` text NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `reviewed_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `reviewed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `totp_reset_requests`
--

INSERT INTO `totp_reset_requests` (`id`, `user_id`, `remark`, `status`, `reviewed_by`, `created_at`, `reviewed_at`) VALUES
(3, 4, 'Lost phone', 'Pending', NULL, '2026-05-20 04:57:22', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `mfa_secret` varchar(255) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `mfa_enabled` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `profile_pic` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password_hash`, `mfa_secret`, `department_id`, `role_id`, `mfa_enabled`, `created_at`, `profile_pic`, `status`) VALUES
(1, 'System', 'Admin', 'admin@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 1, 1, 0, '2026-03-26 15:40:16', NULL, 'active'),
(2, 'Kevin Cris', 'Layco', 'kevinslayco@gmail.com', '$2y$10$JJB3wKiUO/DmqLLOH3qClu1VzrFoAEfEfy836pn0LB0Fy4qnnAtE6', 'IJSBEZZL6DK565DT', 6, 4, 1, '2026-03-26 15:40:16', NULL, 'active'),
(3, 'Christian Joel', 'Caracas', 'christianjoelcaracas@gmail.com', '$2y$10$7aiB5sZkNUmUsyiSYo7SiuagywnJgNKmberzJdnX5s/vPVpOYM9w6', 'Y6FN55OQNC3HCDQG', 8, 3, 1, '2026-03-26 15:40:16', NULL, 'active'),
(4, 'Richmhon', 'Papa', 'richmhonpapa@gmail.com', '$2y$10$Fh887NKYd9RE.C0s54zHW.oB5Pwm3vO3gXRfYekDfmxJog0ieOLtC', 'WFPIRJZPN36LNACE', 6, 1, 1, '2026-03-26 15:40:16', NULL, 'active'),
(5, 'AJ', 'Goze', 'agoze@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(6, 'Ace Alwin', 'Reciproco', 'areciproco@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(7, 'Alexander', 'Cerilla', 'acerilla@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(8, 'Alyzza Claire', 'Magpulong', 'amagpulong@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(9, 'Andrei Kenneth', 'Agana', 'aagana@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(10, 'Catherine', 'Custodio', 'ccustodio@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(11, 'Charlene', 'Lagahit', 'clagahit@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(12, 'Cherry Ailyn', 'Baquiran', 'cbaquiran@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 7, 7, 0, '2026-05-15 00:00:00', NULL, 'active'),
(13, 'Christian', 'Bacod', 'cbacod@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(14, 'Joyce Andrea', 'Bermundo', 'jbermundo@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(15, 'Christopher John', 'Cejalvo', 'ccejalvo@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(16, 'Denisse Margaret', 'Ibanga', 'dibanga@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(17, 'Edan', 'Bagarinao', 'ebagarinao@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(18, 'Gabriel', 'Gabatin', 'ggabatin@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(19, 'Hazel Joy', 'Argel', 'hargel@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(20, 'Jerome', 'Gillego', 'jgillego@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 2, 2, 0, '2026-05-15 00:00:00', NULL, 'active'),
(21, 'Jester John', 'Narvaja', 'jnarvaja@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(22, 'Jhon Rey', 'Palconit', 'jpalconit@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(23, 'Jhorenz', 'Camarador', 'jcamarador@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(24, 'Jiane', 'Taqueban', 'jtaqueban@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(25, 'Joel', 'Barrientos', 'jbarrientos@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(26, 'John Clerwin', 'Dela Cruz', 'jdelacruz@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(27, 'John Kennidy', 'Abunda', 'jabunda@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(28, 'John Richie', 'Campo', 'jcampo@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 6, 4, 0, '2026-05-15 00:00:00', NULL, 'active'),
(29, 'Jullian Miguel', 'Joquico', 'jjoquico@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 8, 3, 0, '2026-05-15 00:00:00', NULL, 'active'),
(30, 'Justin Mark', 'Luzano', 'jluzano@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 8, 3, 0, '2026-05-15 00:00:00', NULL, 'active'),
(31, 'Juviel Ellah Mae', 'Vecinal', 'jvecinal@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 8, 3, 0, '2026-05-15 00:00:00', NULL, 'active'),
(32, 'Karl Martin', 'Antonio', 'kantonio@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 8, 3, 0, '2026-05-15 00:00:00', NULL, 'active'),
(33, 'Kenjie', 'Abiog', 'kabiog@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 8, 3, 0, '2026-05-15 00:00:00', NULL, 'active'),
(34, 'Kian Basty', 'Paysan', 'kpaysan@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 8, 3, 0, '2026-05-15 00:00:00', NULL, 'active'),
(35, 'Kuznets Zachary', 'Calleja', 'kcalleja@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(36, 'Lance Josh', 'Corpuz', 'lcorpuz@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(37, 'Louis Arthur', 'Fernando', 'lfernando@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(38, 'Madelaine Angela', 'Hernandez', 'mhernandez@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(39, 'Mark Angelo', 'Dapalla', 'mdapalla@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(40, 'Mathew Angelo', 'Balanlay', 'mbalanlay@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(41, 'Michael David', 'Valdez', 'mvaldez@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(42, 'Miguel Zitto', 'Octaviano', 'moctaviano@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 4, 6, 0, '2026-05-15 00:00:00', NULL, 'active'),
(43, 'Paul Angelo', 'Rivera', 'privera@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(44, 'Paul Rafael', 'Dela Calzada', 'pdelacalzada@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(45, 'Ralph Christopher', 'Soberano', 'rsoberano@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(46, 'Reiyanne Ghaile', 'Martinez', 'rmartinez@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(47, 'Reynaldo Jr.', 'Maramag', 'rmaramag@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(48, 'Ron Vincent', 'Suarez', 'rsuarez@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(49, 'Rydine Cassandra', 'Ramos', 'rramos@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 5, 8, 0, '2026-05-15 00:00:00', NULL, 'active'),
(50, 'Yoshke Grei', 'Nasayao', 'ynasayao@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(51, 'Zhann Llyn Anthony', 'Arsenal', 'zarsenal@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(52, 'Aaron James', 'Pascual', 'apascual@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(53, 'Bianca Marie', 'Santos', 'bsantos@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(54, 'Crisanto Miguel', 'Mendoza', 'cmendoza@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(55, 'Dianne Rose', 'Cruz', 'dcruz@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(56, 'Ethan Gabriel', 'Reyes', 'ereyes@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active'),
(57, 'Fiona Mae', 'Bautista', 'fbautista@divinalaw.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 3, 5, 0, '2026-05-15 00:00:00', NULL, 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indexes for table `announcement_reads`
--
ALTER TABLE `announcement_reads`
  ADD PRIMARY KEY (`user_id`,`announcement_id`),
  ADD KEY `fk_ann_read_ann` (`announcement_id`);

--
-- Indexes for table `asset_assignments`
--
ALTER TABLE `asset_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dtr_logs`
--
ALTER TABLE `dtr_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `item_categories`
--
ALTER TABLE `item_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `leave_type_id` (`leave_type_id`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `leave_type_id` (`leave_type_id`),
  ADD KEY `phase1_approver_id` (`phase1_approver_id`),
  ADD KEY `phase2_approver_id` (`phase2_approver_id`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `overtime_requests_ibfk_2` (`approved_by`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `reservation_attendees`
--
ALTER TABLE `reservation_attendees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `paired_room_id` (`paired_room_id`);

--
-- Indexes for table `totp_reset_requests`
--
ALTER TABLE `totp_reset_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `reviewed_by` (`reviewed_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `asset_assignments`
--
ALTER TABLE `asset_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `dtr_logs`
--
ALTER TABLE `dtr_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `inventory_items`
--
ALTER TABLE `inventory_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `item_categories`
--
ALTER TABLE `item_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `leave_balances`
--
ALTER TABLE `leave_balances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `reservation_attendees`
--
ALTER TABLE `reservation_attendees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `totp_reset_requests`
--
ALTER TABLE `totp_reset_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `announcement_reads`
--
ALTER TABLE `announcement_reads`
  ADD CONSTRAINT `fk_ann_read_ann` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ann_read_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `asset_assignments`
--
ALTER TABLE `asset_assignments`
  ADD CONSTRAINT `asset_assignments_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`),
  ADD CONSTRAINT `asset_assignments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `dtr_logs`
--
ALTER TABLE `dtr_logs`
  ADD CONSTRAINT `dtr_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD CONSTRAINT `inventory_items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `item_categories` (`id`);

--
-- Constraints for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD CONSTRAINT `leave_balances_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leave_balances_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`);

--
-- Constraints for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD CONSTRAINT `leave_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leave_requests_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`),
  ADD CONSTRAINT `leave_requests_ibfk_3` FOREIGN KEY (`phase1_approver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leave_requests_ibfk_4` FOREIGN KEY (`phase2_approver_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  ADD CONSTRAINT `overtime_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `overtime_requests_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);

--
-- Constraints for table `reservation_attendees`
--
ALTER TABLE `reservation_attendees`
  ADD CONSTRAINT `reservation_attendees_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`),
  ADD CONSTRAINT `reservation_attendees_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`paired_room_id`) REFERENCES `rooms` (`id`);

--
-- Constraints for table `totp_reset_requests`
--
ALTER TABLE `totp_reset_requests`
  ADD CONSTRAINT `totp_reset_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `totp_reset_requests_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
--
-- Database: `g4database`
--
CREATE DATABASE IF NOT EXISTS `g4database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `g4database`;

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `User_ID` int(11) NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Role` varchar(50) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Dept_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Dept_ID` int(11) NOT NULL,
  `Dept_Name` varchar(100) DEFAULT NULL,
  `Contact_Info` varchar(100) DEFAULT NULL,
  `Report_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faq_info`
--

CREATE TABLE `faq_info` (
  `FAQ_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Category_Title` varchar(100) DEFAULT NULL,
  `Content` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) DEFAULT NULL,
  `FAQ_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_status`
--

CREATE TABLE `report_status` (
  `Report_ID` int(11) NOT NULL,
  `Dept_ID` int(11) NOT NULL,
  `Assign_Date` date DEFAULT NULL,
  `Resolved_Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`User_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `Dept_ID` (`Dept_ID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Dept_ID`),
  ADD KEY `Report_ID` (`Report_ID`);

--
-- Indexes for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD PRIMARY KEY (`FAQ_ID`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`Report_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `FAQ_ID` (`FAQ_ID`);

--
-- Indexes for table `report_status`
--
ALTER TABLE `report_status`
  ADD PRIMARY KEY (`Report_ID`,`Dept_ID`),
  ADD KEY `Dept_ID` (`Dept_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dept_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faq_info`
--
ALTER TABLE `faq_info`
  MODIFY `FAQ_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `Report_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `client_ibfk_1` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`);

--
-- Constraints for table `department`
--
ALTER TABLE `department`
  ADD CONSTRAINT `department_ibfk_1` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`);

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `report_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`),
  ADD CONSTRAINT `report_ibfk_2` FOREIGN KEY (`FAQ_ID`) REFERENCES `faq_info` (`FAQ_ID`);

--
-- Constraints for table `report_status`
--
ALTER TABLE `report_status`
  ADD CONSTRAINT `report_status_ibfk_1` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`),
  ADD CONSTRAINT `report_status_ibfk_2` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`);
--
-- Database: `guide_db`
--
CREATE DATABASE IF NOT EXISTS `guide_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `guide_db`;

-- --------------------------------------------------------

--
-- Table structure for table `gender`
--

CREATE TABLE `gender` (
  `ID` char(1) NOT NULL,
  `GENDER_NAME` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gender`
--

INSERT INTO `gender` (`ID`, `GENDER_NAME`) VALUES
('F', 'FEMALE'),
('M', 'MALE'),
('N', 'NOTHING');

-- --------------------------------------------------------

--
-- Table structure for table `sampleddl`
--

CREATE TABLE `sampleddl` (
  `ID` int(11) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `DESCRIPTION` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `AGE` int(11) DEFAULT NULL CHECK (`AGE` >= 18),
  `GENDER_ID` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`ID`, `NAME`, `AGE`, `GENDER_ID`) VALUES
(6, 'Alice', 25, 'F'),
(7, 'Bob', 31, 'M'),
(9, 'DIANA', 28, 'F'),
(10, 'Alex', 29, 'N'),
(11, 'Jamie', 35, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `GENDER_NAME` (`GENDER_NAME`);

--
-- Indexes for table `sampleddl`
--
ALTER TABLE `sampleddl`
  ADD UNIQUE KEY `NAME` (`NAME`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `GENDER_ID` (`GENDER_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`GENDER_ID`) REFERENCES `gender` (`ID`);
--
-- Database: `itolympics2025`
--
CREATE DATABASE IF NOT EXISTS `itolympics2025` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `itolympics2025`;

-- --------------------------------------------------------

--
-- Table structure for table `itolympics_competitors`
--

CREATE TABLE `itolympics_competitors` (
  `CompetitorID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Major` varchar(50) DEFAULT NULL,
  `UniversityID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `itolympics_competitors`
--

INSERT INTO `itolympics_competitors` (`CompetitorID`, `FirstName`, `LastName`, `Major`, `UniversityID`) VALUES
(1, 'Christian', 'David', 'Computer Science', 1),
(2, 'Sofia', 'Gonzales', 'IT', 1),
(3, 'Miguel', 'Santos', 'IT', 1),
(4, 'Samantha', 'Reyes', 'Computer Science', 1),
(5, 'James', 'Cruz', 'Diploma', 1),
(6, 'Daniel', 'Villanueva', 'IT', 2),
(7, 'Angela', 'Bautista', 'Computer Science', 2),
(8, 'Andrea', 'Ramos', 'IT', 2),
(9, 'Gabriel', 'Torres', 'Computer Science', 2),
(10, 'Chloe', 'Castro', 'Diploma', 2),
(11, 'Jose Antonio', 'Garcia', 'IT', 3),
(12, 'Juan', 'Mendoza', 'Diploma', 3),
(13, 'Elijah', 'Castillo', 'IT', 3),
(14, 'Isabella', 'Flores', 'Computer Science', 3),
(15, 'Marcus', 'Ocampo', 'IT', 3),
(16, 'Mayari', 'Garcia', 'Computer Science', 4),
(17, 'Alex', 'Banzuelo', 'IT', 4),
(18, 'Mikaela', 'Gomez', 'Diploma', 4),
(19, 'Andrei', 'Diaz', 'Computer Science', 4),
(20, 'Althea', 'Perez', 'IT', 4),
(21, 'Adrian', 'Pantoja', 'Diploma', 5),
(22, 'John Paul', 'Besiatas', 'Computer Science', 5),
(23, 'Rafael', 'Villanueva', 'Computer Science', 5),
(24, 'Katrina', 'Mercado', 'IT', 5),
(25, 'Luis', 'Aquino', 'Diploma', 5);

-- --------------------------------------------------------

--
-- Table structure for table `itolympics_events`
--

CREATE TABLE `itolympics_events` (
  `EventID` int(11) NOT NULL,
  `EventName` varchar(100) NOT NULL,
  `Category` varchar(50) DEFAULT NULL,
  `RoomNumber` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `itolympics_events`
--

INSERT INTO `itolympics_events` (`EventID`, `EventName`, `Category`, `RoomNumber`) VALUES
(1, 'Java Programming', 'Programming', 'Lab 1006'),
(2, 'Python Programming', 'Programming', 'Auditorium C'),
(3, '.NET Programming', 'Programming', 'Lab 806'),
(4, 'Mobile Legends', 'E-Sports', 'Room 701'),
(5, 'Call of Duty Mobile', 'E-Sports', 'Room 707');

-- --------------------------------------------------------

--
-- Table structure for table `itolympics_results`
--

CREATE TABLE `itolympics_results` (
  `ResultID` int(11) NOT NULL,
  `CompetitorID` int(11) DEFAULT NULL,
  `EventID` int(11) DEFAULT NULL,
  `Score` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `itolympics_results`
--

INSERT INTO `itolympics_results` (`ResultID`, `CompetitorID`, `EventID`, `Score`) VALUES
(1, 1, 1, 95),
(2, 4, 1, 92),
(3, 7, 1, 96),
(4, 9, 1, 88),
(5, 14, 1, 91),
(6, 19, 1, 85),
(7, 22, 1, 90),
(8, 2, 2, 94),
(9, 6, 2, 89),
(10, 11, 2, 85),
(11, 16, 2, 92),
(12, 20, 2, 88),
(13, 24, 2, 86),
(14, 1, 3, 88),
(15, 8, 3, 91),
(16, 13, 3, 93),
(17, 17, 3, 90),
(18, 3, 4, 97),
(19, 5, 4, 91),
(20, 10, 4, 89),
(21, 15, 4, 96),
(22, 18, 4, 85),
(23, 21, 4, 88),
(24, 7, 5, 92),
(25, 12, 5, 84),
(26, 16, 5, 95),
(27, 25, 5, 90);

-- --------------------------------------------------------

--
-- Table structure for table `itolympics_universities`
--

CREATE TABLE `itolympics_universities` (
  `UniversityID` int(11) NOT NULL,
  `UniversityName` varchar(100) NOT NULL,
  `City` varchar(50) DEFAULT NULL,
  `DateFounded` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `itolympics_universities`
--

INSERT INTO `itolympics_universities` (`UniversityID`, `UniversityName`, `City`, `DateFounded`) VALUES
(1, 'Lyceum of the Philippines (Cavite)', 'General Trias', '1952-07-07'),
(2, 'Pamantasan ng Lungsod ng Maynila', 'Manila', '1965-06-19'),
(3, 'Adamson University', 'Manila', '1932-06-20'),
(4, 'University of Cabuyao', 'Cabuyao', '2003-04-16'),
(5, 'Urdaneta City University', 'Urdaneta', '1966-02-04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `itolympics_competitors`
--
ALTER TABLE `itolympics_competitors`
  ADD PRIMARY KEY (`CompetitorID`),
  ADD KEY `fk_competitors_university` (`UniversityID`);

--
-- Indexes for table `itolympics_events`
--
ALTER TABLE `itolympics_events`
  ADD PRIMARY KEY (`EventID`);

--
-- Indexes for table `itolympics_results`
--
ALTER TABLE `itolympics_results`
  ADD PRIMARY KEY (`ResultID`),
  ADD KEY `fk_competitorid` (`CompetitorID`),
  ADD KEY `fk_eventid` (`EventID`);

--
-- Indexes for table `itolympics_universities`
--
ALTER TABLE `itolympics_universities`
  ADD PRIMARY KEY (`UniversityID`),
  ADD UNIQUE KEY `UniversityName` (`UniversityName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `itolympics_competitors`
--
ALTER TABLE `itolympics_competitors`
  MODIFY `CompetitorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `itolympics_events`
--
ALTER TABLE `itolympics_events`
  MODIFY `EventID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `itolympics_results`
--
ALTER TABLE `itolympics_results`
  MODIFY `ResultID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `itolympics_universities`
--
ALTER TABLE `itolympics_universities`
  MODIFY `UniversityID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `itolympics_competitors`
--
ALTER TABLE `itolympics_competitors`
  ADD CONSTRAINT `fk_competitors_university` FOREIGN KEY (`UniversityID`) REFERENCES `itolympics_universities` (`UniversityID`);

--
-- Constraints for table `itolympics_results`
--
ALTER TABLE `itolympics_results`
  ADD CONSTRAINT `fk_competitorid` FOREIGN KEY (`CompetitorID`) REFERENCES `itolympics_competitors` (`CompetitorID`),
  ADD CONSTRAINT `fk_eventid` FOREIGN KEY (`EventID`) REFERENCES `itolympics_events` (`EventID`);
--
-- Database: `itso`
--
CREATE DATABASE IF NOT EXISTS `itso` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `itso`;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `age` int(11) NOT NULL,
  `date` date DEFAULT curdate(),
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `email`, `age`, `date`, `time`) VALUES
(1, 'richmhonpapa@gmail', 21, '2025-11-20', '2025-11-20 13:59:03'),
(2, 'reynaldomaramag@gmail', 100, '2025-11-20', '2025-11-20 13:59:03'),
(3, 'christiancarcas@gmail', 69, '2025-11-20', '2025-11-20 14:24:22'),
(4, 'clerwindelacruz@gmail', 21, '2025-11-20', '2025-11-20 14:24:22'),
(5, 'ronsua@gmail', 21, '2025-11-20', '2025-11-20 14:24:22');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customerID` int(11) NOT NULL,
  `product` enum('Ball','Phone','Wifi') DEFAULT NULL,
  `date_created` date DEFAULT curdate()
) ;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customerID`, `product`, `date_created`) VALUES
(1, 1, 'Ball', '2025-11-20'),
(2, 2, 'Phone', '2025-11-20'),
(3, 1, 'Wifi', '2025-11-20');

-- --------------------------------------------------------

--
-- Table structure for table `package`
--

CREATE TABLE `package` (
  `package_ID` int(11) NOT NULL,
  `orderID` int(11) NOT NULL,
  `shipping_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `uk_email` (`email`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_order_customer` (`customerID`);

--
-- Indexes for table `package`
--
ALTER TABLE `package`
  ADD PRIMARY KEY (`package_ID`),
  ADD KEY `fk_order_package` (`orderID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `package`
--
ALTER TABLE `package`
  MODIFY `package_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_customer` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `package`
--
ALTER TABLE `package`
  ADD CONSTRAINT `fk_order_package` FOREIGN KEY (`orderID`) REFERENCES `orders` (`order_id`);
--
-- Database: `pbl_db`
--
CREATE DATABASE IF NOT EXISTS `pbl_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pbl_db`;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `action_type` varchar(100) NOT NULL,
  `action_description` text NOT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `user_agent` text DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `severity_level` enum('LOW','MEDIUM','HIGH','CRITICAL') DEFAULT 'LOW',
  `status` enum('SUCCESS','FAILED') DEFAULT 'SUCCESS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`log_id`, `user_id`, `admin_id`, `user_email`, `action_type`, `action_description`, `table_name`, `record_id`, `old_values`, `new_values`, `user_agent`, `session_id`, `severity_level`, `status`, `created_at`) VALUES
(0, NULL, NULL, NULL, 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 39): status, assignment, or notes.', 'report_status', 39, '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"Paki ayos ngatong kupal nato\",\"Dept_ID\":1}', '{\"Status_ID\":2,\"Assigned_To\":\"14\",\"Notes & Comments\":\"Paki ayos ngatong kupal nato\",\"Dept_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '5nemfr4cqufq1lbildvn71vush', 'MEDIUM', 'SUCCESS', '2025-11-02 16:24:35'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John Clerwin\",\"Last_Name\":\"Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 07:55:25'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 07:55:34'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 07:58:18'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 07:58:23'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 07:58:56'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 07:59:01'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:00:23'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:02:10'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:02:12'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:02:17'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:02:18'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:02:59'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:03:01'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:03:06'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:03:18'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:03:35'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:25:19'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:25:20'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:25:24'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:38'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:40'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:40'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:40'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:40'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:40'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:41'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:41'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:41'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:41'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:41'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:41'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:42'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:42'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:42'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:42'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:42'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:42'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:26:47'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:27:45'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:27:47'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:28:36'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:28:36'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:28:36'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:28:36'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:28:39'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:30:01'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:30:03'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:30:05'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:32:14'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:32:15'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 15): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 15, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'umji7mib3mcgdka8trnb3f6sn4', 'MEDIUM', 'SUCCESS', '2025-11-06 08:32:18'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John Clerwin\",\"Last_Name\":\"Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'qam3u17us4tcpfdbedhus4krig', 'MEDIUM', 'SUCCESS', '2025-11-16 15:18:19'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'bl02r75f08a3cch2seblap9tor', 'MEDIUM', 'SUCCESS', '2025-11-17 09:30:29'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'csbnkcl1ea5c0jgd367mal4a1c', 'MEDIUM', 'SUCCESS', '2025-11-17 09:31:12'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'csbnkcl1ea5c0jgd367mal4a1c', 'MEDIUM', 'SUCCESS', '2025-11-17 09:31:16'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:36:10'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:36:25'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:49:56'),
(0, NULL, NULL, NULL, 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:50:24'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:51:43'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:51:52'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 14): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 14, '{\"First_Name\":\"Richmon\",\"Last_Name\":\"Technician\",\"Email\":\"richmontech@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":5}', '{\"First_Name\":\"Richmon\",\"Last_Name\":\"Technician\",\"Email\":\"richmontech@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:52:14'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 14): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 14, '{\"First_Name\":\"Richmon\",\"Last_Name\":\"Technician\",\"Email\":\"richmontech@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"Richmon\",\"Last_Name\":\"Technician\",\"Email\":\"richmontech@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":5}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:52:22'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'lqmnnh76r4ktp83haenvcqpfej', 'MEDIUM', 'SUCCESS', '2025-11-17 09:54:04'),
(0, NULL, 16, 'jdelacruz.k12151536@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 16): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 16, '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"John\",\"Last_Name\":\"Clerwin Dela Cruz\",\"Email\":\"jdelacruz.k12151536@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '0srubelncho1kih1b2fcmh04ba', 'MEDIUM', 'SUCCESS', '2025-11-17 12:57:33'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 11): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 11, '{\"First_Name\":\"admin\",\"Last_Name\":\"pogi\",\"Email\":\"Admin@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', '{\"First_Name\":\"admin\",\"Last_Name\":\"pogi\",\"Email\":\"Admin@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2qpn7tqeoebpmrv7g32tligjgq', 'MEDIUM', 'SUCCESS', '2025-11-20 14:15:27'),
(0, NULL, 11, 'Admin@umak.edu.ph', 'UPDATE_USER', 'Admin updated user (User_ID 2): First_Name = ?, Last_Name = ?, Email = ?, Role_ID = ?', 'client', 2, '{\"First_Name\":\"Christian\",\"Last_Name\":\"Caracas\",\"Email\":\"cjcaracas@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":2}', '{\"First_Name\":\"Christian\",\"Last_Name\":\"Caracas\",\"Email\":\"cjcaracas@umak.edu.ph\",\"Account_type\":\"\",\"Role_ID\":3}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2qpn7tqeoebpmrv7g32tligjgq', 'MEDIUM', 'SUCCESS', '2025-11-20 14:15:36'),
(0, NULL, NULL, NULL, 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 225): status, assignment, or notes.', 'report_status', 225, '{\"Status_ID\":2,\"Assigned_To\":\"12\",\"Notes & Comments\":\"Please investigate the router settings.\",\"Dept_ID\":1}', '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"Please investigate the router settings.\",\"Dept_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'ucgc6ellkil7qe1kcjdhuihe7t', 'MEDIUM', 'SUCCESS', '2025-11-21 08:04:15'),
(0, NULL, NULL, NULL, 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 225): status, assignment, or notes.', 'report_status', 225, '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"Please investigate the router settings.\",\"Dept_ID\":1}', '{\"Status_ID\":2,\"Assigned_To\":\"12\",\"Notes & Comments\":\"Please investigate the router settings.\",\"Dept_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'ucgc6ellkil7qe1kcjdhuihe7t', 'MEDIUM', 'SUCCESS', '2025-11-21 08:04:19'),
(0, NULL, NULL, NULL, 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 227): status, assignment, or notes.', 'report_status', 227, 'null', '{\"Status_ID\":3,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36 Edg/142.0.0.0', 'b0majms58ifcc28a835dp5ae0h', 'MEDIUM', 'SUCCESS', '2025-11-21 09:01:46'),
(0, NULL, NULL, NULL, 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 228): status, assignment, or notes.', 'report_status', 228, '{\"Status_ID\":1,\"Assigned_To\":\"\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '16dnjllc461v27g9r3aei5ossm', 'MEDIUM', 'SUCCESS', '2025-11-21 13:49:31'),
(0, NULL, NULL, NULL, 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 228): status, assignment, or notes.', 'report_status', 228, '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '1c47c28cmou2rn7msnq0vuqbmv', 'MEDIUM', 'SUCCESS', '2025-11-21 14:00:42'),
(0, NULL, 11, 'system@admin.com', 'UPDATE_TICKET', 'Updated Ticket 228', 'report_status', 228, '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes\":\"\"}', NULL, '1c47c28cmou2rn7msnq0vuqbmv', 'MEDIUM', 'SUCCESS', '2025-11-21 14:02:20'),
(0, NULL, 11, 'system@admin.com', 'UPDATE_TICKET', 'Admin updated ticket (Report_ID 228)', 'report_status', 228, '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes\":\"\",\"Dept_ID\":1}', NULL, '1c47c28cmou2rn7msnq0vuqbmv', 'MEDIUM', 'SUCCESS', '2025-11-21 14:04:30'),
(0, NULL, 11, 'system@admin.com', 'UPDATE_TICKET', 'Admin updated ticket 228', 'report_status', 228, '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes & Comments\":\"\",\"Dept_ID\":1}', '{\"Status_ID\":1,\"Assigned_To\":\"12\",\"Notes\":\"\"}', NULL, '1c47c28cmou2rn7msnq0vuqbmv', 'MEDIUM', 'SUCCESS', '2025-11-21 14:09:05');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_ID` int(11) NOT NULL,
  `Category_Title` varchar(150) NOT NULL,
  `Category_Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`Category_ID`, `Category_Title`, `Category_Description`) VALUES
(1, 'Network', 'Network connectivity / access issues'),
(2, 'Hardware', 'Physical device issues'),
(3, 'Software', 'Application or software errors'),
(4, 'Others', 'other concerns about tech');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `User_ID` int(11) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `Account_type` varchar(50) NOT NULL,
  `Phone` varchar(13) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `Password_Hash` varchar(255) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Role_ID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reset_expires` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`User_ID`, `First_Name`, `Middle_Name`, `Last_Name`, `Email`, `Account_type`, `Phone`, `address`, `Password_Hash`, `Dept_ID`, `Role_ID`, `created_at`, `reset_expires`) VALUES
(1, 'John', NULL, 'Dela Cruz', 'jcdelacruz@umak.edu.ph', '', NULL, NULL, '$2y$10$qn7ncKVDEBb5tTsTvgZCaOfuZTodBEvaj2hkK5/5qwFGcGFqebaIC', NULL, 1, '2025-09-13 04:58:38', NULL),
(2, 'Christian', 'Solero', 'Caracas', 'cjcaracas@umak.edu.ph', '', NULL, NULL, '$2y$10$qn7ncKVDEBb5tTsTvgZCaOfuZTodBEvaj2hkK5/5qwFGcGFqebaIC', NULL, 3, '2025-09-13 04:58:38', NULL),
(11, 'admin', 'na', 'pogi', 'Admin@umak.edu.ph', '', NULL, NULL, '$2y$10$qn7ncKVDEBb5tTsTvgZCaOfuZTodBEvaj2hkK5/5qwFGcGFqebaIC', 1, 3, '2025-11-21 13:57:56', NULL),
(12, 'Technician', 'na', 'Pogi', 'Technician@umak.edu.ph', '', NULL, NULL, '$2y$10$qn7ncKVDEBb5tTsTvgZCaOfuZTodBEvaj2hkK5/5qwFGcGFqebaIC', 1, 5, '2025-11-21 13:49:44', NULL),
(13, 'REYNALDO', 'JR.', 'MARAMAG', 'rmaramag.a12345287@umak.edu.ph', '', NULL, NULL, '$2y$10$qn7ncKVDEBb5tTsTvgZCaOfuZTodBEvaj2hkK5/5qwFGcGFqebaIC', NULL, 1, '2025-11-05 06:43:29', NULL),
(14, 'Richmon', 'Tech', 'Technician', 'richmontech@umak.edu.ph', '', NULL, NULL, '$2y$10$qn7ncKVDEBb5tTsTvgZCaOfuZTodBEvaj2hkK5/5qwFGcGFqebaIC', 1, 5, '2025-11-11 07:24:36', NULL),
(16, 'John Clerwin', 'CLERWIN DELA', 'Dela Cruz', 'jdelacruz.k12151536@umak.edu.ph', '', '', '', '$2y$10$gmPvF5BtSCr98FYuftHhAeYEB3SIoitcKofdvG86yck0B5NYWzv8W', NULL, 1, '2025-11-21 14:19:32', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `community_interactions`
--

CREATE TABLE `community_interactions` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `interaction_type` enum('post','comment','like') NOT NULL,
  `content` text DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `post_type` varchar(50) DEFAULT 'community',
  `is_announcement` tinyint(1) NOT NULL DEFAULT 0,
  `category` varchar(100) DEFAULT 'General',
  `image_path` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `community_interactions`
--

INSERT INTO `community_interactions` (`id`, `User_ID`, `interaction_type`, `content`, `parent_id`, `post_type`, `is_announcement`, `category`, `image_path`, `created_at`, `updated_at`) VALUES
(1, 13, 'post', 'How to create a own report po?', NULL, 'community', 0, 'General', NULL, '2025-11-08 23:37:26', NULL),
(3, 11, 'post', 'Okay guys need natin mag maintenance so magkakaroon ng problem sa pag submit ng report.', NULL, 'community', 1, 'Announcements', '../uploads/forum/forum_690f6414e6f84.jpg', '2025-11-08 23:39:00', NULL),
(4, 11, 'like', NULL, 1, 'community', 0, 'General', NULL, '2025-11-08 23:39:04', NULL),
(5, 11, 'comment', 'Go to report and submit but make it sure you use appropriate description.', 1, 'community', 0, 'General', NULL, '2025-11-08 23:40:06', NULL),
(6, 13, 'like', NULL, 3, 'community', 0, 'General', NULL, '2025-11-08 23:40:50', NULL),
(8, 2, 'post', 'How to create po ng ganto?', NULL, 'community', 0, 'General Help', '../uploads/forum/forum_690f6645679e4.png', '2025-11-08 23:48:21', NULL),
(10, 13, 'like', NULL, 8, 'community', 0, 'General', NULL, '2025-11-08 23:48:59', NULL),
(11, 13, 'comment', 'wow ang ganda po', 8, 'community', 0, 'General', NULL, '2025-11-08 23:49:05', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Dept_ID` int(11) NOT NULL,
  `Dept_Name` varchar(100) NOT NULL,
  `Contact_Info` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`Dept_ID`, `Dept_Name`, `Contact_Info`, `created_at`) VALUES
(1, 'IT Support', 'it-support@umak.edu.ph', '2025-09-13 04:58:38'),
(2, 'Facilities', 'facilities@umak.edu.ph', '2025-09-13 04:58:38'),
(3, 'Registrar', 'registrar@umak.edu.ph', '2025-09-13 04:58:38');

-- --------------------------------------------------------

--
-- Table structure for table `faq_filter`
--

CREATE TABLE `faq_filter` (
  `filter_id` int(11) NOT NULL,
  `filter_name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faq_filter`
--

INSERT INTO `faq_filter` (`filter_id`, `filter_name`) VALUES
(1, 'GENERAL'),
(2, 'TECHNICAL ISSUES'),
(3, 'DASHBOARD'),
(4, 'ACCOUNT'),
(5, 'REPORTING');

-- --------------------------------------------------------

--
-- Table structure for table `faq_info`
--

CREATE TABLE `faq_info` (
  `FAQ_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `filter_id` int(11) DEFAULT NULL,
  `Category_Title` varchar(150) DEFAULT NULL,
  `Content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faq_info`
--

INSERT INTO `faq_info` (`FAQ_ID`, `Category_ID`, `filter_id`, `Category_Title`, `Content`, `created_at`) VALUES
(4, NULL, 5, 'How do I submit a new report?', 'You can submit a new report by navigating to the \'Report\' page, filling out the required details, and submitting the form. Be sure to provide as much detail as possible to help us diagnose the problem quickly.', '2025-09-13 05:34:57'),
(5, NULL, 2, 'What information should I include in my report?', 'Include details like the device type, location, a clear description of the problem, and any error messages you\'ve encountered. You can also upload screenshots or photos to help us.', '2025-09-13 05:34:57'),
(6, NULL, 1, 'What is ServeLink?', 'ServeLink is a streamlined issue reporting and management system designed for academic institutions to efficiently handle network, hardware, and software problems reported by students and staff', '2025-09-13 05:50:28'),
(7, NULL, 1, 'How do I get started?', 'Simply log in with your university credentials. From there, you can view the dashboard, submit a new report, or check the status of your existing reports.', '2025-09-13 07:54:09'),
(8, NULL, 1, 'Is ServeLink free to use?', 'Yes, ServeLink is free for all students and staff of the institution.', '2025-09-13 07:54:09'),
(9, NULL, 2, 'What types of technical issues can I report?', 'You can report various technical issues including problems with hardware (e.g., computers, projectors, printers), software (e.g., operating systems, applications), and network connectivity (e.g., Wi-Fi, internet access).', '2025-09-25 11:22:00'),
(10, NULL, 2, 'How quickly are technical issues resolved?', 'Resolution times vary based on the severity and complexity of the issue. Our team works to resolve all issues as quickly as possible. You can track the status of your report on the dashboard.', '2025-09-25 11:22:00'),
(11, NULL, 3, 'What can I see on the dashboard?', 'The dashboard provides an overview of all your submitted reports. You can track their status (e.g., \'Pending\', \'In Progress\', \'Resolved\') and view a history of all your past issues.', '2025-09-25 11:22:00'),
(12, NULL, 3, 'Can I update my report from the dashboard?', 'Yes, you can add comments or additional information to your existing reports from the dashboard.', '2025-09-25 11:22:00'),
(13, NULL, 4, 'How do I reset my password?', 'If you have forgotten your password, please use the \'Forgot Password\' link on the login page. You will receive an email with instructions on how to reset it.', '2025-09-25 11:22:00'),
(14, NULL, 4, 'Can I change my profile picture?', 'Yes, you can update your profile information, including your picture, in the account settings section of the dashboard.', '2025-09-25 11:22:00');

-- --------------------------------------------------------

--
-- Table structure for table `forum_bans`
--

CREATE TABLE `forum_bans` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `banned_by` int(11) DEFAULT NULL,
  `ban_reason` varchar(255) NOT NULL,
  `ban_type` enum('automatic','manual') DEFAULT 'automatic',
  `violation_count` int(11) DEFAULT 0,
  `ban_start` timestamp NOT NULL DEFAULT current_timestamp(),
  `ban_end` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `forum_bans`
--

INSERT INTO `forum_bans` (`id`, `User_ID`, `banned_by`, `ban_reason`, `ban_type`, `violation_count`, `ban_start`, `ban_end`, `is_active`, `created_at`) VALUES
(7, 2, 11, 'Manual ban by admin: Please be mindful to your post, post only the think that in our category.', 'manual', 2, '2025-11-19 06:17:23', '2025-11-19 23:17:23', 1, '2025-11-19 06:17:23'),
(8, 13, NULL, 'Automatic ban: 3 content violations', 'automatic', 3, '2025-11-19 08:01:44', '2025-11-22 01:01:44', 1, '2025-11-19 08:01:44');

-- --------------------------------------------------------

--
-- Table structure for table `forum_rules_acceptance`
--

CREATE TABLE `forum_rules_acceptance` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `accepted` tinyint(1) NOT NULL DEFAULT 0,
  `acceptance_time` datetime DEFAULT NULL,
  `rejection_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_rules_acceptance`
--

INSERT INTO `forum_rules_acceptance` (`id`, `User_ID`, `accepted`, `acceptance_time`, `rejection_time`) VALUES
(11, 13, 1, '2025-11-20 00:00:37', NULL),
(12, 11, 1, '2025-11-20 00:02:36', NULL),
(13, 16, 1, '2025-11-20 22:19:58', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `forum_violations`
--

CREATE TABLE `forum_violations` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `violation_type` varchar(50) NOT NULL,
  `content` text DEFAULT NULL,
  `flagged_categories` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `forum_violations`
--

INSERT INTO `forum_violations` (`id`, `User_ID`, `violation_type`, `content`, `flagged_categories`, `created_at`) VALUES
(6, 2, 'post_moderation', 'The beauty of created a yet glow, interrupted only by the soft of the wind, reminding the of life\'s constant.\r\n\r\nThat sentence feels a little incomplete now! Would you like me to rewrite it completely to make sense, or would you like to provide the replacement words? tanginamo', '[\"inappropriate-language\",\"profanity\"]', '2025-11-19 06:11:36'),
(7, 2, 'comment_moderation', 'tangina mo', '[\"inappropriate-language\",\"profanity\"]', '2025-11-19 06:12:28'),
(8, 13, 'post_moderation', 'sd s sd f  s fd sdfd sd fsd fs fd s sr gs f sfgsd s dgs gfdas ffsd fs gs gsd fsd gs sd   as na tanginamo', '[\"inappropriate-language\",\"profanity\"]', '2025-11-19 08:01:02'),
(9, 13, 'post_moderation', 'as as das as das tangina mo asdbas tanginamo asbdas ahsdaks aksbd kabasjd das ass as as das das as das as as as as das', '[\"inappropriate-language\",\"profanity\"]', '2025-11-19 08:01:38'),
(10, 13, 'post_moderation', 'as as das as das tangina mo asdbas tanginamo asbdas ahsdaks aksbd kabasjd das ass as as das das as das as as as as das', '[\"inappropriate-language\",\"profanity\"]', '2025-11-19 08:01:44'),
(11, 16, 'post_moderation', 'TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO TAENA MO', '[\"inappropriate-language\",\"profanity\"]', '2025-11-20 14:20:52'),
(12, 16, 'post_moderation', 'NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA NIGGAAA NIGGGAAA', '[\"inappropriate-language\",\"profanity\"]', '2025-11-21 09:32:40');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `report_id` int(11) DEFAULT NULL,
  `message_body` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `attachment_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `sender_id`, `recipient_id`, `report_id`, `message_body`, `timestamp`, `is_read`, `attachment_path`) VALUES
(35, 16, 12, 121, 'Hi po', '2025-11-20 14:30:26', 1, NULL),
(36, 12, 16, 121, 'Hello', '2025-11-20 14:55:58', 1, NULL),
(37, 12, 16, 121, 'Ano po problems?', '2025-11-20 15:01:57', 1, NULL),
(38, 16, 12, 121, 'Uhm about sa wifi po', '2025-11-20 15:02:22', 1, NULL),
(39, 12, 16, 121, 'Ohhh', '2025-11-20 15:04:49', 1, NULL),
(40, 12, 16, 121, 'So bali', '2025-11-20 15:05:16', 1, NULL),
(41, 12, 16, 228, 'Sup', '2025-11-21 14:11:43', 1, NULL),
(42, 16, 12, 228, 'Sup', '2025-11-21 14:12:07', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `Notification_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Report_ID` int(11) DEFAULT NULL,
  `Message` varchar(255) NOT NULL,
  `Type` varchar(50) DEFAULT 'info',
  `Is_Read` tinyint(1) DEFAULT 0,
  `Created_At` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`Notification_ID`, `User_ID`, `Report_ID`, `Message`, `Type`, `Is_Read`, `Created_At`) VALUES
(183, 12, 228, 'You have been assigned to Ticket #228 (Wifi keeps disconnec...). Status: Pending', 'assignment', 1, '2025-11-21 22:09:05'),
(184, 16, 228, 'Your ticket TK-2025-228 has been started by Technician Pogi.', 'status', 1, '2025-11-21 22:11:08'),
(185, 16, 228, 'Technician Pogi sent you a message about ticket TKT-228', 'chat_message', 1, '2025-11-21 22:11:43'),
(186, 12, 228, 'John Clerwin Dela Cruz sent you a message about ticket TKT-228', 'chat_message', 1, '2025-11-21 22:12:07'),
(187, 16, 228, 'Your ticket TK-2025-228 status was changed to Pending by Technician Pogi.', 'status', 1, '2025-11-21 22:20:48'),
(188, 16, 228, 'Your ticket TK-2025-228 has been started by Technician Pogi.', 'status', 1, '2025-11-21 22:21:53'),
(189, 16, 228, 'Your ticket TK-2025-228 status was changed to Pending by Technician Pogi.', 'status', 1, '2025-11-21 22:22:08'),
(190, 16, 228, 'Your ticket TK-2025-228 has been resolved by Technician Pogi.', 'status', 1, '2025-11-21 22:22:21'),
(191, 16, 228, 'Your ticket TK-2025-228 has been started by Technician Pogi.', 'status', 1, '2025-11-21 22:23:02'),
(192, 16, 228, 'Your ticket TK-2025-228 status was changed to Pending by Technician Pogi.', 'status', 0, '2025-11-21 22:23:17');

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

CREATE TABLE `password_history` (
  `history_id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Password_Hash` varchar(255) NOT NULL,
  `failed_attempts` int(11) DEFAULT 0,
  `last_failed_attempt` datetime DEFAULT NULL,
  `locked_until` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_history`
--

INSERT INTO `password_history` (`history_id`, `User_ID`, `Password_Hash`, `failed_attempts`, `last_failed_attempt`, `locked_until`, `password_changed_at`, `changed_at`) VALUES
(1, 13, '$2y$10$4SuZP1sCCDu0/nqN5kuITOv/EWc.6wIZ2vT.p3fYNzFCUzF/aJ1lq', 0, NULL, NULL, '2025-11-07 21:34:59', '2025-11-07 21:34:59'),
(2, 13, '$2y$10$y9M1GE2jrV38/a70GRJlWOr8XDqoLBUoqo540m7Qf2Qdc257l9xae', 0, NULL, NULL, '2025-11-07 21:38:55', '2025-11-07 21:38:55');

-- --------------------------------------------------------

--
-- Table structure for table `read_notes`
--

CREATE TABLE `read_notes` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Notification_ID` varchar(50) NOT NULL,
  `Read_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `read_notes`
--

INSERT INTO `read_notes` (`id`, `User_ID`, `Notification_ID`, `Read_At`, `is_read`) VALUES
(66, 15, '113_0', '2025-11-11 07:27:30', 2),
(67, 15, '135', '2025-11-11 07:27:20', 3),
(68, 15, '136', '2025-11-11 07:27:21', 2),
(69, 15, '113_1', '2025-11-11 07:27:25', 1),
(70, 15, '137', '2025-11-11 07:28:13', 1),
(71, 16, '142', '2025-11-21 14:17:22', 4),
(72, 16, '141', '2025-11-21 14:17:22', 4),
(73, 16, '146', '2025-11-21 14:17:22', 4),
(74, 16, '151', '2025-11-21 14:17:22', 4),
(75, 16, '158', '2025-11-21 14:17:22', 9),
(76, 16, '157', '2025-11-21 14:17:22', 4),
(77, 16, '159', '2025-11-21 14:17:22', 4),
(78, 16, '225_0', '2025-11-21 14:17:22', 4),
(79, 16, '184', '2025-11-21 14:17:22', 4),
(80, 16, '227_0', '2025-11-21 14:21:09', 1),
(81, 16, '225_1', '2025-11-21 14:21:13', 1),
(82, 16, '227_1', '2025-11-21 14:21:37', 2),
(83, 16, '187', '2025-11-21 14:21:44', 3),
(84, 16, '188', '2025-11-21 14:22:01', 1),
(85, 16, '190', '2025-11-21 14:22:54', 1),
(86, 16, '189', '2025-11-21 14:22:55', 1);

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Report_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Current_Status_ID` int(11) DEFAULT NULL,
  `Resolved_Date` date NOT NULL DEFAULT current_timestamp(),
  `add_note` varchar(255) NOT NULL,
  `Is_Archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`Report_ID`, `User_ID`, `Category_ID`, `Description`, `Location`, `Attachment`, `Report_Date`, `Current_Status_ID`, `Resolved_Date`, `add_note`, `Is_Archived`) VALUES
(225, 16, 1, 'Internet connection drops intermittently on the 3rd floor workstation.', 'Room 305', NULL, '2025-11-21 09:03:41', 2, '2025-11-21', '\n--- Note by Technician Pogi on 2025-11-21 09:08:53 ---\nI\'m gonna start this na\n\n--- Note by Technician Pogi on 2025-11-21 09:09:13 ---\nStart ko na ah\nTime Spent: 00:00\n', 0),
(227, 16, 1, 'meow', 'Room 305', NULL, '2025-11-21 09:03:41', 2, '2025-11-21', '--- Note by Technician Pogi on 2025-11-21 09:08:53 ---\r\nI\'m gonna start this na\r\n\r\n--- Note by Technician Pogi on 2025-11-21 09:09:13 ---\r\nStart ko na ah\r\nTime Spent: 00:00\r\n', 0),
(228, 16, 1, 'Wifi keeps disconnecting in the library.', 'Library 2nd Floor', NULL, '2025-11-21 14:23:02', 1, '2025-11-21', '', 0),
(229, 16, 2, 'Printer in the faculty room is jamming paper.', 'Faculty Room A', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(230, 16, 3, 'Cannot access the enrollment portal on my PC.', 'Computer Lab 1', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(231, 16, 2, 'Projector remote is missing.', 'Room 405', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(232, 16, 1, 'No internet connection on LAN port 4.', 'Server Room', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(233, 16, 3, 'Need Adobe Reader installed on workstation.', 'Registrar Office', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(234, 16, 2, 'Keyboard keys are stuck on PC-02.', 'Computer Lab 3', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(235, 16, 1, 'Slow internet speed in the cafeteria.', 'Cafeteria', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(236, 16, 2, 'Monitor screen is flickering pink.', 'Admin Office', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0),
(237, 16, 3, 'Login error \"User not found\" on portal.', 'Home Access', NULL, '2025-11-21 09:36:16', 1, '2025-11-21', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `report_archive`
--

CREATE TABLE `report_archive` (
  `Archive_Report_ID` int(11) NOT NULL,
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Report_Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Current_Status_ID` int(11) DEFAULT NULL,
  `Resolved_Date` date DEFAULT NULL,
  `add_note` varchar(255) NOT NULL,
  `Archived_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `Dept_ID` int(11) DEFAULT NULL,
  `Status_ID` int(11) DEFAULT NULL,
  `Assigned_By` int(11) DEFAULT NULL,
  `Assign_Date` timestamp NULL DEFAULT NULL,
  `Assigned_To` varchar(255) NOT NULL,
  `Notes_Comments` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report_archive`
--

INSERT INTO `report_archive` (`Archive_Report_ID`, `Report_ID`, `User_ID`, `Category_ID`, `Description`, `Location`, `Attachment`, `Report_Date`, `Current_Status_ID`, `Resolved_Date`, `add_note`, `Archived_At`, `Dept_ID`, `Status_ID`, `Assigned_By`, `Assign_Date`, `Assigned_To`, `Notes_Comments`) VALUES
(1, 111, 15, 1, '0', '', '', '2025-11-06 22:18:50', 1, '2025-11-07', '0', '2025-11-07 06:53:19', NULL, NULL, NULL, NULL, '', ''),
(2, 110, 15, 2, '0', '', '', '2025-11-06 22:12:15', 1, '2025-11-07', '0', '2025-11-07 06:53:33', NULL, NULL, NULL, NULL, '', ''),
(3, 112, 15, 2, '0', '', '', '2025-11-07 00:52:47', 1, '2025-11-07', '0', '2025-11-10 17:18:35', 1, 1, NULL, '0000-00-00 00:00:00', '12', ''),
(4, 221, 16, 3, 'My specialized design software (Adobe Photoshop) is crashing on startup. It was working fine yesterday.', NULL, NULL, '2025-11-18 07:21:07', 3, '2025-11-18', '', '2025-11-20 11:28:06', 1, 3, 11, '2025-11-12 02:44:39', '12', 'Cleared application cache and preferences file. Software is now stable. User confirmed.'),
(5, 121, 16, 2, 'Mouse and keyboard for PC #12 in the computer lab are not working. Tried restarting.', 'Computer Lab 1 (HPSB 201)', NULL, '2025-11-20 15:26:58', 3, '2025-11-21', '0', '2025-11-21 06:30:56', 1, 3, 11, '2025-11-17 09:05:46', '12', 'Technician, please replace the peripherals for this station.');

-- --------------------------------------------------------

--
-- Table structure for table `report_rate_limit`
--

CREATE TABLE `report_rate_limit` (
  `rate_limit_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_report_time` datetime DEFAULT NULL,
  `report_count_today` int(11) DEFAULT 0,
  `report_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_status`
--

CREATE TABLE `report_status` (
  `Report_ID` int(11) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Status_ID` int(11) NOT NULL,
  `Assigned_By` int(11) DEFAULT NULL,
  `Assign_Date` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `Resolved_Date` timestamp(6) NULL DEFAULT NULL,
  `Assigned_To` varchar(255) NOT NULL,
  `Notes & Comments` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report_status`
--

INSERT INTO `report_status` (`Report_ID`, `Dept_ID`, `Status_ID`, `Assigned_By`, `Assign_Date`, `Resolved_Date`, `Assigned_To`, `Notes & Comments`) VALUES
(225, 1, 2, NULL, '2025-11-21 08:04:19.000000', NULL, '12', 'Please investigate the router settings.'),
(227, 1, 3, NULL, '2025-11-21 09:01:46.000000', NULL, '12', ''),
(228, 1, 1, 11, '2025-11-21 14:09:05.000000', NULL, '12', ''),
(229, 2, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(230, 1, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(231, 2, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(232, 1, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(233, 1, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(234, 2, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(235, 1, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(236, 2, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', ''),
(237, 1, 1, NULL, '2025-11-21 09:36:16.000000', NULL, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `Role_ID` int(11) NOT NULL,
  `Role_Name` varchar(50) NOT NULL,
  `Role_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`Role_ID`, `Role_Name`, `Role_Description`) VALUES
(1, 'Student', 'Regular student user'),
(2, 'Staff', 'University staff member'),
(3, 'IT Admin', 'Handles IT support and system management'),
(4, 'Professor', 'Faculty member responsible for teaching'),
(5, 'Technician', 'Provides technical assistance and support');

-- --------------------------------------------------------

--
-- Table structure for table `status_lookup`
--

CREATE TABLE `status_lookup` (
  `Status_ID` int(11) NOT NULL,
  `Status_Name` varchar(50) NOT NULL,
  `Status_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status_lookup`
--

INSERT INTO `status_lookup` (`Status_ID`, `Status_Name`, `Status_Description`) VALUES
(1, 'Pending', 'Report is pending and not yet assigned'),
(2, 'In Progress', 'Work is currently in progress'),
(3, 'Resolved', 'Issue has been resolved');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_ID`),
  ADD UNIQUE KEY `Category_Title` (`Category_Title`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`User_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `fk_client_dept` (`Dept_ID`),
  ADD KEY `fk_client_role` (`Role_ID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Dept_ID`),
  ADD UNIQUE KEY `uniq_dept_name` (`Dept_Name`);

--
-- Indexes for table `faq_filter`
--
ALTER TABLE `faq_filter`
  ADD PRIMARY KEY (`filter_id`);

--
-- Indexes for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD PRIMARY KEY (`FAQ_ID`),
  ADD KEY `fk_faq_category` (`Category_ID`),
  ADD KEY `fk_faq_filter` (`filter_id`);

--
-- Indexes for table `forum_bans`
--
ALTER TABLE `forum_bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banned_by` (`banned_by`),
  ADD KEY `idx_active_bans` (`User_ID`,`is_active`,`ban_end`);

--
-- Indexes for table `forum_rules_acceptance`
--
ALTER TABLE `forum_rules_acceptance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `accepted` (`accepted`),
  ADD KEY `rejection_time` (`rejection_time`);

--
-- Indexes for table `forum_violations`
--
ALTER TABLE `forum_violations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_violations` (`User_ID`,`created_at`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_sender` (`sender_id`),
  ADD KEY `idx_recipient` (`recipient_id`),
  ADD KEY `idx_report_conversation` (`report_id`,`sender_id`,`recipient_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`Notification_ID`),
  ADD KEY `User_ID` (`User_ID`);

--
-- Indexes for table `read_notes`
--
ALTER TABLE `read_notes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_read` (`User_ID`,`Notification_ID`),
  ADD KEY `idx_user` (`User_ID`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`Report_ID`),
  ADD KEY `fk_report_user` (`User_ID`),
  ADD KEY `fk_report_category` (`Category_ID`),
  ADD KEY `fk_report_status` (`Current_Status_ID`);

--
-- Indexes for table `report_archive`
--
ALTER TABLE `report_archive`
  ADD PRIMARY KEY (`Archive_Report_ID`);

--
-- Indexes for table `report_rate_limit`
--
ALTER TABLE `report_rate_limit`
  ADD PRIMARY KEY (`rate_limit_id`),
  ADD UNIQUE KEY `unique_user_date` (`user_id`,`report_date`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_report_date` (`report_date`);

--
-- Indexes for table `report_status`
--
ALTER TABLE `report_status`
  ADD PRIMARY KEY (`Report_ID`,`Assign_Date`),
  ADD KEY `fk_status_dept` (`Dept_ID`),
  ADD KEY `fk_status_lookup` (`Status_ID`),
  ADD KEY `fk_status_assigned_by` (`Assigned_By`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`Role_ID`),
  ADD UNIQUE KEY `Role_Name` (`Role_Name`);

--
-- Indexes for table `status_lookup`
--
ALTER TABLE `status_lookup`
  ADD PRIMARY KEY (`Status_ID`),
  ADD UNIQUE KEY `Status_Name` (`Status_Name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dept_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `faq_filter`
--
ALTER TABLE `faq_filter`
  MODIFY `filter_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `faq_info`
--
ALTER TABLE `faq_info`
  MODIFY `FAQ_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `forum_bans`
--
ALTER TABLE `forum_bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `forum_rules_acceptance`
--
ALTER TABLE `forum_rules_acceptance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `forum_violations`
--
ALTER TABLE `forum_violations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `Notification_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=193;

--
-- AUTO_INCREMENT for table `read_notes`
--
ALTER TABLE `read_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `Report_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT for table `report_archive`
--
ALTER TABLE `report_archive`
  MODIFY `Archive_Report_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `report_rate_limit`
--
ALTER TABLE `report_rate_limit`
  MODIFY `rate_limit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `Role_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `status_lookup`
--
ALTER TABLE `status_lookup`
  MODIFY `Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_role` FOREIGN KEY (`Role_ID`) REFERENCES `roles` (`Role_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD CONSTRAINT `fk_faq_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_faq_filter` FOREIGN KEY (`filter_id`) REFERENCES `faq_filter` (`filter_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `forum_bans`
--
ALTER TABLE `forum_bans`
  ADD CONSTRAINT `forum_bans_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `forum_bans_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `client` (`User_ID`) ON DELETE SET NULL;

--
-- Constraints for table `forum_violations`
--
ALTER TABLE `forum_violations`
  ADD CONSTRAINT `forum_violations_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE;

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `fk_report_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_status` FOREIGN KEY (`Current_Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `report_rate_limit`
--
ALTER TABLE `report_rate_limit`
  ADD CONSTRAINT `report_rate_limit_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE;

--
-- Constraints for table `report_status`
--
ALTER TABLE `report_status`
  ADD CONSTRAINT `fk_status_assigned_by` FOREIGN KEY (`Assigned_By`) REFERENCES `client` (`User_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_lookup` FOREIGN KEY (`Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_report` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `pbl_db_erd`
--
CREATE DATABASE IF NOT EXISTS `pbl_db_erd` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `pbl_db_erd`;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `action_type` varchar(100) NOT NULL,
  `action_description` text NOT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `old_values` longtext DEFAULT NULL,
  `new_values` longtext DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `severity_level` enum('LOW','MEDIUM','HIGH','CRITICAL') DEFAULT NULL,
  `status` enum('SUCCESS','FAILED') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_ID` int(11) NOT NULL,
  `Category_Title` varchar(150) NOT NULL,
  `Category_Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `User_ID` int(11) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `Account_type` varchar(50) NOT NULL,
  `Phone` varchar(13) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `Password_Hash` varchar(45) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Role_ID` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `reset_expires` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `community_interactions`
--

CREATE TABLE `community_interactions` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `interaction_type` enum('post','comment','like') NOT NULL,
  `content` text DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `post_type` varchar(50) DEFAULT NULL,
  `is_announcement` tinyint(1) NOT NULL DEFAULT 0,
  `category` varchar(100) DEFAULT NULL,
  `image_path` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Dept_ID` int(11) NOT NULL,
  `Dept_Name` varchar(100) NOT NULL,
  `Contact_Info` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='T';

-- --------------------------------------------------------

--
-- Table structure for table `faq_filter`
--

CREATE TABLE `faq_filter` (
  `filter_id` int(11) NOT NULL,
  `filter_name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faq_info`
--

CREATE TABLE `faq_info` (
  `FAQ_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `filter_id` int(11) DEFAULT NULL,
  `Category_Title` varchar(50) DEFAULT NULL,
  `Content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum_bans`
--

CREATE TABLE `forum_bans` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `banned_by` int(11) DEFAULT NULL,
  `ban_reason` varchar(255) NOT NULL,
  `ban_type` enum('automatic','manual') DEFAULT NULL,
  `violation_count` int(11) DEFAULT NULL,
  `ban_start` timestamp NULL DEFAULT NULL,
  `ban_end` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum_rules_acceptance`
--

CREATE TABLE `forum_rules_acceptance` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `accepted` tinyint(1) NOT NULL,
  `acceptance_time` datetime DEFAULT NULL,
  `rejection_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum_violations`
--

CREATE TABLE `forum_violations` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `violation_type` varchar(50) NOT NULL,
  `content` text DEFAULT NULL,
  `flagged_categories` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `report_id` int(11) DEFAULT NULL,
  `message_body` text NOT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL,
  `attachment_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `Notification_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Report_ID` int(11) DEFAULT NULL,
  `Message` varchar(255) NOT NULL,
  `Type` varchar(50) DEFAULT NULL,
  `Is_Read` tinyint(1) DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

CREATE TABLE `password_history` (
  `history_id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Password_Hash` varchar(255) NOT NULL,
  `failed_attempts` int(11) DEFAULT NULL,
  `last_failed_attempt` datetime DEFAULT NULL,
  `locked_until` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `changed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `read_notes`
--

CREATE TABLE `read_notes` (
  `id` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Notification_ID` int(11) NOT NULL,
  `Read_At` timestamp NULL DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Report_Date` timestamp NULL DEFAULT NULL,
  `Current_Status_ID` int(11) DEFAULT NULL,
  `Resolved_Date` date DEFAULT NULL,
  `add_note` varchar(255) NOT NULL,
  `Is_Archived` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_archive`
--

CREATE TABLE `report_archive` (
  `Archive_Report_ID` int(11) NOT NULL,
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Report_Date` timestamp NULL DEFAULT NULL,
  `Current_Status_ID` int(11) DEFAULT NULL,
  `Resolved_Date` date DEFAULT NULL,
  `add_note` varchar(255) NOT NULL,
  `Archived_At` timestamp NULL DEFAULT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Status_ID` int(11) DEFAULT NULL,
  `Assigned_By` int(11) DEFAULT NULL,
  `Assign_Date` timestamp NULL DEFAULT NULL,
  `Assigned_To` varchar(255) NOT NULL,
  `Notes_Comments` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_rate_limit`
--

CREATE TABLE `report_rate_limit` (
  `rate_limit_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_report_time` datetime DEFAULT NULL,
  `report_count_today` int(11) DEFAULT NULL,
  `report_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_status`
--

CREATE TABLE `report_status` (
  `Report_ID` int(11) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Status_ID` int(11) NOT NULL,
  `Assigned_By` int(11) DEFAULT NULL,
  `Assign_Date` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `Resolved_Date` timestamp(6) NULL DEFAULT NULL,
  `Assigned_To` varchar(255) NOT NULL,
  `Notes & Comments` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `Role_ID` int(11) NOT NULL,
  `Role_Name` varchar(50) NOT NULL,
  `Role_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `status_lookup`
--

CREATE TABLE `status_lookup` (
  `Status_ID` int(11) NOT NULL,
  `Status_Name` varchar(50) NOT NULL,
  `Status_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `audit_logs_client_id_idx` (`user_id`,`admin_id`),
  ADD KEY `fk_audit_admin_id` (`admin_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_ID`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`User_ID`),
  ADD KEY `Dept_ID_idx` (`Dept_ID`),
  ADD KEY `Role_ID_idx` (`Role_ID`);

--
-- Indexes for table `community_interactions`
--
ALTER TABLE `community_interactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_interactions_client_idx` (`User_ID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Dept_ID`);

--
-- Indexes for table `faq_filter`
--
ALTER TABLE `faq_filter`
  ADD PRIMARY KEY (`filter_id`);

--
-- Indexes for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD PRIMARY KEY (`FAQ_ID`),
  ADD KEY `Category_ID_idx` (`Category_ID`),
  ADD KEY `filter_id_idx` (`filter_id`);

--
-- Indexes for table `forum_bans`
--
ALTER TABLE `forum_bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `User_ID_idx` (`User_ID`,`banned_by`);

--
-- Indexes for table `forum_rules_acceptance`
--
ALTER TABLE `forum_rules_acceptance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `forum_rules_user_id_idx` (`User_ID`);

--
-- Indexes for table `forum_violations`
--
ALTER TABLE `forum_violations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `User_ID_idx` (`User_ID`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `messages_sender_id_idx` (`sender_id`,`recipient_id`),
  ADD KEY `messages_ibfk_2_idx` (`report_id`),
  ADD KEY `messages_recipient_fk` (`recipient_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`Notification_ID`),
  ADD KEY `User_ID_idx` (`User_ID`);

--
-- Indexes for table `password_history`
--
ALTER TABLE `password_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `password_history_ibfk_1_idx` (`User_ID`);

--
-- Indexes for table `read_notes`
--
ALTER TABLE `read_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `read_notes_notification_idx` (`Notification_ID`),
  ADD KEY `read_notes_user_idx` (`User_ID`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`Report_ID`),
  ADD KEY `fk_report_user_idx` (`User_ID`),
  ADD KEY `fk_report_category` (`Category_ID`),
  ADD KEY `fk_report_status` (`Current_Status_ID`);

--
-- Indexes for table `report_archive`
--
ALTER TABLE `report_archive`
  ADD PRIMARY KEY (`Archive_Report_ID`),
  ADD KEY `report_archive_report_idx` (`Report_ID`),
  ADD KEY `report_archive_user id_idx` (`User_ID`),
  ADD KEY `report_archive_category_idx` (`Category_ID`);

--
-- Indexes for table `report_rate_limit`
--
ALTER TABLE `report_rate_limit`
  ADD PRIMARY KEY (`rate_limit_id`),
  ADD KEY `report_rate_limit_ibfk_1_idx` (`user_id`);

--
-- Indexes for table `report_status`
--
ALTER TABLE `report_status`
  ADD PRIMARY KEY (`Report_ID`,`Assign_Date`),
  ADD KEY `Assigned_By_idx` (`Assigned_By`),
  ADD KEY `Dept_ID_idx` (`Dept_ID`),
  ADD KEY `Status_ID_idx` (`Status_ID`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`Role_ID`);

--
-- Indexes for table `status_lookup`
--
ALTER TABLE `status_lookup`
  ADD PRIMARY KEY (`Status_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `community_interactions`
--
ALTER TABLE `community_interactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dept_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faq_filter`
--
ALTER TABLE `faq_filter`
  MODIFY `filter_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faq_info`
--
ALTER TABLE `faq_info`
  MODIFY `FAQ_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum_bans`
--
ALTER TABLE `forum_bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum_rules_acceptance`
--
ALTER TABLE `forum_rules_acceptance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum_violations`
--
ALTER TABLE `forum_violations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `Notification_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_history`
--
ALTER TABLE `password_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `read_notes`
--
ALTER TABLE `read_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `Report_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_archive`
--
ALTER TABLE `report_archive`
  MODIFY `Archive_Report_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_rate_limit`
--
ALTER TABLE `report_rate_limit`
  MODIFY `rate_limit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `Role_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `status_lookup`
--
ALTER TABLE `status_lookup`
  MODIFY `Status_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_admin_id` FOREIGN KEY (`admin_id`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_audit_user_id` FOREIGN KEY (`user_id`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_client_role` FOREIGN KEY (`Role_ID`) REFERENCES `roles` (`Role_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `community_interactions`
--
ALTER TABLE `community_interactions`
  ADD CONSTRAINT `community_interactions_client` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD CONSTRAINT `fk_faq_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_faq_filter` FOREIGN KEY (`filter_id`) REFERENCES `faq_filter` (`filter_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `forum_bans`
--
ALTER TABLE `forum_bans`
  ADD CONSTRAINT `forum_bans_ibfk_1_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `forum_rules_acceptance`
--
ALTER TABLE `forum_rules_acceptance`
  ADD CONSTRAINT `forum_rules_user_id` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `forum_violations`
--
ALTER TABLE `forum_violations`
  ADD CONSTRAINT `forum_violations_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`report_id`) REFERENCES `report` (`Report_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `messages_recipient_fk` FOREIGN KEY (`recipient_id`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `messages_sender_fk` FOREIGN KEY (`sender_id`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `password_history`
--
ALTER TABLE `password_history`
  ADD CONSTRAINT `password_history_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `read_notes`
--
ALTER TABLE `read_notes`
  ADD CONSTRAINT `read_notes_notification` FOREIGN KEY (`Notification_ID`) REFERENCES `notifications` (`Notification_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `read_notes_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `fk_report_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_report_status` FOREIGN KEY (`Current_Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `report_archive`
--
ALTER TABLE `report_archive`
  ADD CONSTRAINT `report_archive_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `report_archive_report` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `report_archive_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `report_rate_limit`
--
ALTER TABLE `report_rate_limit`
  ADD CONSTRAINT `report_rate_limit_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `report_status`
--
ALTER TABLE `report_status`
  ADD CONSTRAINT `fk_status_assigned_by` FOREIGN KEY (`Assigned_By`) REFERENCES `client` (`User_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_status_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_status_lookup` FOREIGN KEY (`Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_status_report` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
--
-- Database: `pbl_db_og`
--
CREATE DATABASE IF NOT EXISTS `pbl_db_og` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pbl_db_og`;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_ID` int(11) NOT NULL,
  `Category_Title` varchar(150) NOT NULL,
  `Category_Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`Category_ID`, `Category_Title`, `Category_Description`) VALUES
(1, 'Network', 'Network connectivity / access issues'),
(2, 'Hardware', 'Physical device issues'),
(3, 'Software', 'Application or software errors');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `User_ID` int(11) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `Account_type` varchar(50) NOT NULL,
  `Phone` varchar(13) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `Password_Hash` varchar(255) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Role_ID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`User_ID`, `First_Name`, `Middle_Name`, `Last_Name`, `Email`, `Account_type`, `Phone`, `address`, `Password_Hash`, `Dept_ID`, `Role_ID`, `created_at`) VALUES
(1, 'John', NULL, 'Dela Cruz', 'jcdelacruz@umak.edu.ph', '', NULL, NULL, '$2y$10$abcdefghijklmnopqrstuv', NULL, 1, '2025-09-13 04:58:38'),
(2, 'Christian', 'Solero', 'Caracas', 'cjcaracas@umak.edu.ph', '', NULL, NULL, '$2y$10$1234567890abcdefghijk', NULL, 2, '2025-09-13 04:58:38'),
(3, 'Reynaldo', 'L.', 'Maramag', 'rmaramag@umak.edu.ph', '', '', '', '$2y$10$J8T6CMLzf8jC2n5MX9qit.pmrRn5Mh8oD55TF8Lf48L3VzOAqTMI.', 1, 3, '2025-10-28 08:13:50'),
(4, 'John Clerwin', 'CLERWIN DELA', 'Dela Cruz', 'jdelacruz.k12151536@umak.edu.ph', '', '09765447671', 'blk 210 lot 02 upper azucena st. pembo', '$2y$10$rLReoQUJ2.TfvXJALv.YMO9HpfSkk7cEyBdlmjN0HuzwQDOILUvUG', NULL, 2, '2025-10-16 07:32:55'),
(5, 'Admin', 'na', 'Pogi', 'admin@umak.edu.ph', '', NULL, NULL, '$2y$10$xM094Ol27.PYSiOtg.FGYe0MdFPbeJwxtwwnKvgnrpbZUP/A9NHG6', 1, 3, '2025-09-26 19:09:05'),
(7, 'RICHMHON', '', 'PAPA', 'rpapa.k12150334@umak.edu.ph', '', NULL, NULL, '$2y$10$xJcNrY0FmgcBloZCN52kC.Qo.dgbcwAP/S0VmGxZBtnIgOLAFoZsy', NULL, 2, '2025-11-03 05:52:54');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Dept_ID` int(11) NOT NULL,
  `Dept_Name` varchar(100) NOT NULL,
  `Contact_Info` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`Dept_ID`, `Dept_Name`, `Contact_Info`, `created_at`) VALUES
(1, 'IT Support', 'it-support@umak.edu.ph', '2025-09-13 04:58:38'),
(2, 'Facilities', 'facilities@umak.edu.ph', '2025-09-13 04:58:38'),
(3, 'Registrar', 'registrar@umak.edu.ph', '2025-09-13 04:58:38');

-- --------------------------------------------------------

--
-- Table structure for table `faq_filter`
--

CREATE TABLE `faq_filter` (
  `filter_id` int(11) NOT NULL,
  `filter_name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faq_filter`
--

INSERT INTO `faq_filter` (`filter_id`, `filter_name`) VALUES
(1, 'GENERAL'),
(2, 'TECHNICAL ISSUES'),
(3, 'DASHBOARD'),
(4, 'ACCOUNT'),
(5, 'REPORTING');

-- --------------------------------------------------------

--
-- Table structure for table `faq_info`
--

CREATE TABLE `faq_info` (
  `FAQ_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `filter_id` int(11) DEFAULT NULL,
  `Category_Title` varchar(150) DEFAULT NULL,
  `Content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faq_info`
--

INSERT INTO `faq_info` (`FAQ_ID`, `Category_ID`, `filter_id`, `Category_Title`, `Content`, `created_at`) VALUES
(1, NULL, NULL, 'TITLE', 'BOT', '2025-09-13 04:58:38'),
(2, NULL, NULL, 'HELLO WORLD', 'WORKING', '2025-09-13 04:58:38'),
(3, NULL, 1, 'HELLO', 'TESTING', '2025-09-13 04:58:38'),
(4, NULL, 5, 'How do I submit a new report?', 'You can submit a new report by navigating to the \'Report\' page, filling out the required details, and submitting the form. Be sure to provide as much detail as possible to help us diagnose the problem quickly.', '2025-09-13 05:34:57'),
(5, NULL, 2, 'What information should I include in my report?', 'Include details like the device type, location, a clear description of the problem, and any error messages you\'ve encountered. You can also upload screenshots or photos to help us.', '2025-09-13 05:34:57'),
(6, NULL, 1, 'What is ServeLink?', 'ServeLink is a streamlined issue reporting and management system designed for academic institutions to efficiently handle network, hardware, and software problems reported by students and staff.', '2025-09-13 05:50:28'),
(7, NULL, 1, 'How do I get started?', 'Simply log in with your university credentials. From there, you can view the dashboard, submit a new report, or check the status of your existing reports.', '2025-09-13 07:54:09'),
(8, NULL, 1, 'Is ServeLink free to use?', 'Yes, ServeLink is free for all students and staff of the institution.', '2025-09-13 07:54:09'),
(9, NULL, 2, 'What types of technical issues can I report?', 'You can report various technical issues including problems with hardware (e.g., computers, projectors, printers), software (e.g., operating systems, applications), and network connectivity (e.g., Wi-Fi, internet access).', '2025-09-25 11:22:00'),
(10, NULL, 2, 'How quickly are technical issues resolved?', 'Resolution times vary based on the severity and complexity of the issue. Our team works to resolve all issues as quickly as possible. You can track the status of your report on the dashboard.', '2025-09-25 11:22:00'),
(11, NULL, 3, 'What can I see on the dashboard?', 'The dashboard provides an overview of all your submitted reports. You can track their status (e.g., \'Pending\', \'In Progress\', \'Resolved\') and view a history of all your past issues.', '2025-09-25 11:22:00'),
(12, NULL, 3, 'Can I update my report from the dashboard?', 'Yes, you can add comments or additional information to your existing reports from the dashboard.', '2025-09-25 11:22:00'),
(13, NULL, 4, 'How do I reset my password?', 'If you have forgotten your password, please use the \'Forgot Password\' link on the login page. You will receive an email with instructions on how to reset it.', '2025-09-25 11:22:00'),
(14, NULL, 4, 'Can I change my profile picture?', 'Yes, you can update your profile information, including your picture, in the account settings section of the dashboard.', '2025-09-25 11:22:00');

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Report_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Current_Status_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`Report_ID`, `User_ID`, `Category_ID`, `Description`, `Location`, `Attachment`, `Report_Date`, `Current_Status_ID`) VALUES
(2, 2, 2, 'Projector not working in Room 101', 'Room 101, Main Building', NULL, '2025-09-13 04:58:39', 2),
(3, 3, 3, 'Application crashes on login', 'Online portal', NULL, '2025-09-13 04:58:39', 3),
(5, 4, 1, 'Computer lab doesn\'t have any wifi rn', 'General Inquiry', '', '2025-09-26 13:11:27', 1),
(6, 3, 2, 'The projector is not working', 'HPSB 10F - 1012', '', '2025-09-26 23:55:14', 1),
(7, 3, 2, 'nasira yung projector', 'HPSB 6F - 615', 'uploads/68d78f8364e9a.png', '2025-09-27 00:41:03', 2);

-- --------------------------------------------------------

--
-- Table structure for table `report_status`
--

CREATE TABLE `report_status` (
  `Report_ID` int(11) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Status_ID` int(11) NOT NULL,
  `Assigned_By` int(11) DEFAULT NULL,
  `Assign_Date` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `Resolved_Date` timestamp(6) NULL DEFAULT NULL,
  `notes` varchar(244) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report_status`
--

INSERT INTO `report_status` (`Report_ID`, `Dept_ID`, `Status_ID`, `Assigned_By`, `Assign_Date`, `Resolved_Date`, `notes`) VALUES
(2, 1, 2, 1, '2025-09-13 04:58:39.108299', NULL, ''),
(3, 1, 3, 2, '2025-09-13 04:58:39.108299', NULL, ''),
(7, NULL, 2, 2, '2025-10-16 09:34:24.000000', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `Role_ID` int(11) NOT NULL,
  `Role_Name` varchar(50) NOT NULL,
  `Role_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`Role_ID`, `Role_Name`, `Role_Description`) VALUES
(1, 'Student', 'Regular student user'),
(2, 'Staff', 'University staff member'),
(3, 'IT Admin', 'Handles IT support and system management'),
(4, 'Professor', 'Faculty member responsible for teaching'),
(5, 'Technician', 'Provides technical assistance and support');

-- --------------------------------------------------------

--
-- Table structure for table `status_lookup`
--

CREATE TABLE `status_lookup` (
  `Status_ID` int(11) NOT NULL,
  `Status_Name` varchar(50) NOT NULL,
  `Status_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status_lookup`
--

INSERT INTO `status_lookup` (`Status_ID`, `Status_Name`, `Status_Description`) VALUES
(1, 'Pending', 'Report is pending and not yet assigned'),
(2, 'In Progress', 'Work is currently in progress'),
(3, 'Resolved', 'Issue has been resolved');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_ID`),
  ADD UNIQUE KEY `Category_Title` (`Category_Title`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`User_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `fk_client_dept` (`Dept_ID`),
  ADD KEY `fk_client_role` (`Role_ID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Dept_ID`),
  ADD UNIQUE KEY `uniq_dept_name` (`Dept_Name`);

--
-- Indexes for table `faq_filter`
--
ALTER TABLE `faq_filter`
  ADD PRIMARY KEY (`filter_id`);

--
-- Indexes for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD PRIMARY KEY (`FAQ_ID`),
  ADD KEY `fk_faq_category` (`Category_ID`),
  ADD KEY `fk_faq_filter` (`filter_id`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`Report_ID`),
  ADD KEY `fk_report_user` (`User_ID`),
  ADD KEY `fk_report_category` (`Category_ID`),
  ADD KEY `fk_report_status` (`Current_Status_ID`);

--
-- Indexes for table `report_status`
--
ALTER TABLE `report_status`
  ADD PRIMARY KEY (`Report_ID`,`Assign_Date`),
  ADD KEY `fk_status_dept` (`Dept_ID`),
  ADD KEY `fk_status_lookup` (`Status_ID`),
  ADD KEY `fk_status_assigned_by` (`Assigned_By`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`Role_ID`),
  ADD UNIQUE KEY `Role_Name` (`Role_Name`);

--
-- Indexes for table `status_lookup`
--
ALTER TABLE `status_lookup`
  ADD PRIMARY KEY (`Status_ID`),
  ADD UNIQUE KEY `Status_Name` (`Status_Name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dept_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `faq_filter`
--
ALTER TABLE `faq_filter`
  MODIFY `filter_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `faq_info`
--
ALTER TABLE `faq_info`
  MODIFY `FAQ_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `Report_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `Role_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `status_lookup`
--
ALTER TABLE `status_lookup`
  MODIFY `Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_role` FOREIGN KEY (`Role_ID`) REFERENCES `roles` (`Role_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD CONSTRAINT `fk_faq_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_faq_filter` FOREIGN KEY (`filter_id`) REFERENCES `faq_filter` (`filter_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `fk_report_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_status` FOREIGN KEY (`Current_Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `report_status`
--
ALTER TABLE `report_status`
  ADD CONSTRAINT `fk_status_assigned_by` FOREIGN KEY (`Assigned_By`) REFERENCES `client` (`User_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_lookup` FOREIGN KEY (`Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_report` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `pbl_full`
--
CREATE DATABASE IF NOT EXISTS `pbl_full` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pbl_full`;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_ID` int(11) NOT NULL,
  `Category_Title` varchar(150) NOT NULL,
  `Category_Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`Category_ID`, `Category_Title`, `Category_Description`) VALUES
(1, 'Network', 'Network connectivity / access issues'),
(2, 'Hardware', 'Physical device issues'),
(3, 'Software', 'Application or software errors');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `User_ID` int(11) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `contact_number` varchar(13) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `Password_Hash` varchar(255) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Role_ID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`User_ID`, `First_Name`, `Middle_Name`, `Last_Name`, `Email`, `contact_number`, `address`, `Password_Hash`, `Dept_ID`, `Role_ID`, `created_at`) VALUES
(1, 'John', NULL, 'Dela Cruz', 'jcdelacruz@umak.edu.ph', NULL, NULL, '$2y$10$abcdefghijklmnopqrstuv', NULL, 1, '2025-09-13 04:58:38'),
(2, 'Christian', 'Solero', 'Caracas', 'cjcaracas@umak.edu.ph', NULL, NULL, '$2y$10$1234567890abcdefghijk', NULL, 2, '2025-09-13 04:58:38'),
(3, 'Reynaldo', 'L.', 'Maramag', 'rmaramag@umak.edu.ph', NULL, NULL, '$2y$10$zyxwvutsrqponmlkjihgf', 1, 3, '2025-09-13 04:58:38');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Dept_ID` int(11) NOT NULL,
  `Dept_Name` varchar(100) NOT NULL,
  `Contact_Info` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`Dept_ID`, `Dept_Name`, `Contact_Info`, `created_at`) VALUES
(1, 'IT Support', 'it-support@umak.edu.ph', '2025-09-13 04:58:38'),
(2, 'Facilities', 'facilities@umak.edu.ph', '2025-09-13 04:58:38'),
(3, 'Registrar', 'registrar@umak.edu.ph', '2025-09-13 04:58:38');

-- --------------------------------------------------------

--
-- Table structure for table `faq_filter`
--

CREATE TABLE `faq_filter` (
  `filter_id` int(11) NOT NULL,
  `filter_name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faq_filter`
--

INSERT INTO `faq_filter` (`filter_id`, `filter_name`) VALUES
(1, 'GENERAL'),
(2, 'TECHNICAL ISSUES'),
(3, 'DASHBOARD'),
(4, 'ACCOUNT'),
(5, 'REPORTING');

-- --------------------------------------------------------

--
-- Table structure for table `faq_info`
--

CREATE TABLE `faq_info` (
  `FAQ_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `filter_id` int(11) DEFAULT NULL,
  `Category_Title` varchar(150) DEFAULT NULL,
  `Content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faq_info`
--

INSERT INTO `faq_info` (`FAQ_ID`, `Category_ID`, `filter_id`, `Category_Title`, `Content`, `created_at`) VALUES
(1, NULL, NULL, NULL, '', '2025-09-13 04:58:38'),
(2, NULL, NULL, NULL, '', '2025-09-13 04:58:38'),
(3, NULL, NULL, NULL, '', '2025-09-13 04:58:38'),
(4, NULL, 5, 'How do I submit a new report?', 'You can submit a new report by navigating to the \'Report\' page, filling out the required details, and submitting the form. Be sure to provide as much detail as possible to help us diagnose the problem quickly.', '2025-09-13 05:34:57'),
(5, NULL, 5, 'What information should I include in my report?', 'Include details like the device type, location, a clear description of the problem, and any error messages you\'ve encountered. You can also upload screenshots or photos to help us.', '2025-09-13 05:34:57'),
(6, NULL, 1, 'What is ServeLink?', 'ServeLink is a streamlined issue reporting and management system designed for academic institutions to efficiently handle network, hardware, and software problems reported by students and staff.', '2025-09-13 05:50:28'),
(7, NULL, 1, 'How do I get started?', 'Simply log in with your university credentials. From there, you can view the dashboard, submit a new report, or check the status of your existing reports.', '2025-09-13 07:54:09'),
(8, NULL, 1, 'Is ServeLink free to use?', 'Yes, ServeLink is free for all students and staff of the institution.', '2025-09-13 07:54:09'),
(9, NULL, 2, 'What types of technical issues can I report?', 'You can report various technical issues including problems with hardware (e.g., computers, projectors, printers), software (e.g., operating systems, applications), and network connectivity (e.g., Wi-Fi, internet access).', '2025-09-25 11:22:00'),
(10, NULL, 2, 'How quickly are technical issues resolved?', 'Resolution times vary based on the severity and complexity of the issue. Our team works to resolve all issues as quickly as possible. You can track the status of your report on the dashboard.', '2025-09-25 11:22:00'),
(11, NULL, 3, 'What can I see on the dashboard?', 'The dashboard provides an overview of all your submitted reports. You can track their status (e.g., \'Pending\', \'In Progress\', \'Resolved\') and view a history of all your past issues.', '2025-09-25 11:22:00'),
(12, NULL, 3, 'Can I update my report from the dashboard?', 'Yes, you can add comments or additional information to your existing reports from the dashboard.', '2025-09-25 11:22:00'),
(13, NULL, 4, 'How do I reset my password?', 'If you have forgotten your password, please use the \'Forgot Password\' link on the login page. You will receive an email with instructions on how to reset it.', '2025-09-25 11:22:00'),
(14, NULL, 4, 'Can I change my profile picture?', 'Yes, you can update your profile information, including your picture, in the account settings section of the dashboard.', '2025-09-25 11:22:00');

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `Report_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Attachment` varchar(255) DEFAULT NULL,
  `Report_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Current_Status_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`Report_ID`, `User_ID`, `Category_ID`, `Description`, `Location`, `Attachment`, `Report_Date`, `Current_Status_ID`) VALUES
(1, 1, 1, 'Cannot connect to campus wifi in Lab A', 'Computer Lab A, 2nd floor', NULL, '2025-09-13 04:58:39', 3),
(2, 2, 2, 'Projector not working in Room 101', 'Room 101, Main Building', NULL, '2025-09-13 04:58:49', 2),
(3, 3, 3, 'Application crashes on login', 'Online portal', NULL, '2025-09-13 04:58:39', 3);

-- --------------------------------------------------------

--
-- Table structure for table `report_status`
--

CREATE TABLE `report_status` (
  `Report_ID` int(11) NOT NULL,
  `Dept_ID` int(11) DEFAULT NULL,
  `Status_ID` int(11) NOT NULL,
  `Assigned_By` int(11) DEFAULT NULL,
  `Assign_Date` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `Resolved_Date` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report_status`
--

INSERT INTO `report_status` (`Report_ID`, `Dept_ID`, `Status_ID`, `Assigned_By`, `Assign_Date`, `Resolved_Date`) VALUES
(1, 1, 3, 2, '2025-09-13 04:58:39.108299', NULL),
(2, 1, 2, 1, '2025-09-13 04:58:39.108299', NULL),
(3, 1, 3, 2, '2025-09-13 04:58:39.108299', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `Role_ID` int(11) NOT NULL,
  `Role_Name` varchar(50) NOT NULL,
  `Role_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`Role_ID`, `Role_Name`, `Role_Description`) VALUES
(1, 'Student', 'Regular student user'),
(2, 'Staff', 'University staff member'),
(3, 'IT Admin', 'Handles IT support and system management'),
(4, 'Professor', 'Faculty member responsible for teaching'),
(5, 'Technician', 'Provides technical assistance and support');

-- --------------------------------------------------------

--
-- Table structure for table `status_lookup`
--

CREATE TABLE `status_lookup` (
  `Status_ID` int(11) NOT NULL,
  `Status_Name` varchar(50) NOT NULL,
  `Status_Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status_lookup`
--

INSERT INTO `status_lookup` (`Status_ID`, `Status_Name`, `Status_Description`) VALUES
(1, 'Pending', 'Report is pending and not yet assigned'),
(2, 'In Progress', 'Work is currently in progress'),
(3, 'Resolved', 'Issue has been resolved');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_ID`),
  ADD UNIQUE KEY `Category_Title` (`Category_Title`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`User_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `fk_client_dept` (`Dept_ID`),
  ADD KEY `fk_client_role` (`Role_ID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Dept_ID`),
  ADD UNIQUE KEY `uniq_dept_name` (`Dept_Name`);

--
-- Indexes for table `faq_filter`
--
ALTER TABLE `faq_filter`
  ADD PRIMARY KEY (`filter_id`);

--
-- Indexes for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD PRIMARY KEY (`FAQ_ID`),
  ADD KEY `fk_faq_category` (`Category_ID`),
  ADD KEY `fk_faq_filter` (`filter_id`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`Report_ID`),
  ADD KEY `fk_report_user` (`User_ID`),
  ADD KEY `fk_report_category` (`Category_ID`),
  ADD KEY `fk_report_status` (`Current_Status_ID`);

--
-- Indexes for table `report_status`
--
ALTER TABLE `report_status`
  ADD PRIMARY KEY (`Report_ID`,`Assign_Date`),
  ADD KEY `fk_status_dept` (`Dept_ID`),
  ADD KEY `fk_status_lookup` (`Status_ID`),
  ADD KEY `fk_status_assigned_by` (`Assigned_By`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`Role_ID`),
  ADD UNIQUE KEY `Role_Name` (`Role_Name`);

--
-- Indexes for table `status_lookup`
--
ALTER TABLE `status_lookup`
  ADD PRIMARY KEY (`Status_ID`),
  ADD UNIQUE KEY `Status_Name` (`Status_Name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dept_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `faq_filter`
--
ALTER TABLE `faq_filter`
  MODIFY `filter_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `faq_info`
--
ALTER TABLE `faq_info`
  MODIFY `FAQ_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `Report_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `Role_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `status_lookup`
--
ALTER TABLE `status_lookup`
  MODIFY `Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_role` FOREIGN KEY (`Role_ID`) REFERENCES `roles` (`Role_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `faq_info`
--
ALTER TABLE `faq_info`
  ADD CONSTRAINT `fk_faq_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_faq_filter` FOREIGN KEY (`filter_id`) REFERENCES `faq_filter` (`filter_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `fk_report_category` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_status` FOREIGN KEY (`Current_Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`User_ID`) REFERENCES `client` (`User_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `report_status`
--
ALTER TABLE `report_status`
  ADD CONSTRAINT `fk_status_assigned_by` FOREIGN KEY (`Assigned_By`) REFERENCES `client` (`User_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_dept` FOREIGN KEY (`Dept_ID`) REFERENCES `department` (`Dept_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_lookup` FOREIGN KEY (`Status_ID`) REFERENCES `status_lookup` (`Status_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_status_report` FOREIGN KEY (`Report_ID`) REFERENCES `report` (`Report_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

--
-- Dumping data for table `pma__designer_settings`
--

INSERT INTO `pma__designer_settings` (`username`, `settings_data`) VALUES
('root', '{\"relation_lines\":\"true\",\"snap_to_grid\":\"off\",\"angular_direct\":\"direct\",\"full_screen\":\"off\",\"side_menu\":\"true\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

--
-- Dumping data for table `pma__pdf_pages`
--

INSERT INTO `pma__pdf_pages` (`db_name`, `page_nr`, `page_descr`) VALUES
('pbl_db', 2, 'pbl_db-ERD'),
('pbl_db_erd', 3, 'pbl_db_erd');

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"pbl_db_erd\",\"table\":\"report_rate_limit\"},{\"db\":\"pbl_db_erd\",\"table\":\"department\"},{\"db\":\"pbl_db\",\"table\":\"faq_info\"},{\"db\":\"pbl_db\",\"table\":\"faq_filter\"},{\"db\":\"pbl_db\",\"table\":\"client\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

--
-- Dumping data for table `pma__table_coords`
--

INSERT INTO `pma__table_coords` (`db_name`, `table_name`, `pdf_page_number`, `x`, `y`) VALUES
('pbl_db', 'audit_logs', 2, 1707, 697),
('pbl_db', 'category', 2, 909, 717),
('pbl_db', 'client', 2, 554, 53),
('pbl_db', 'community_interactions', 2, 1282, 402),
('pbl_db', 'department', 2, 207, 388),
('pbl_db', 'faq_filter', 2, 1194, 942),
('pbl_db', 'faq_info', 2, 912, 888),
('pbl_db', 'forum_bans', 2, 908, 421),
('pbl_db', 'forum_rules_acceptance', 2, 1286, 219),
('pbl_db', 'forum_violations', 2, 913, 43),
('pbl_db', 'messages', 2, 579, 863),
('pbl_db', 'notifications', 2, 224, 49),
('pbl_db', 'password_history', 2, 194, 867),
('pbl_db', 'read_notes', 2, 1290, 42),
('pbl_db', 'report', 2, 582, 416),
('pbl_db', 'report_archive', 2, 1440, 701),
('pbl_db', 'report_rate_limit', 2, 912, 242),
('pbl_db', 'report_status', 2, 194, 537),
('pbl_db', 'roles', 2, 185, 259),
('pbl_db', 'status_lookup', 2, 573, 717),
('pbl_db_erd', 'audit_logs', 3, 466, 739),
('pbl_db_erd', 'category', 3, 462, 1129),
('pbl_db_erd', 'client', 3, 468, 99),
('pbl_db_erd', 'community_interactions', 3, 930, 773),
('pbl_db_erd', 'department', 3, 87, 105),
('pbl_db_erd', 'faq_filter', 3, 1301, 1102),
('pbl_db_erd', 'faq_info', 3, 943, 1082),
('pbl_db_erd', 'forum_bans', 3, 932, 311),
('pbl_db_erd', 'forum_rules_acceptance', 3, 1279, 85),
('pbl_db_erd', 'forum_violations', 3, 1275, 242),
('pbl_db_erd', 'messages', 3, 87, 718),
('pbl_db_erd', 'notifications', 3, 1280, 430),
('pbl_db_erd', 'password_history', 3, 926, 93),
('pbl_db_erd', 'read_notes', 3, 1287, 638),
('pbl_db_erd', 'report', 3, 472, 431),
('pbl_db_erd', 'report_archive', 3, 92, 935),
('pbl_db_erd', 'report_rate_limit', 3, 937, 603),
('pbl_db_erd', 'report_status', 3, 86, 370),
('pbl_db_erd', 'roles', 3, 86, 247),
('pbl_db_erd', 'status_lookup', 3, 84, 609);

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2025-11-24 14:49:21', '{\"Console\\/Mode\":\"collapse\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `retrieva_db`
--
CREATE DATABASE IF NOT EXISTS `retrieva_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `retrieva_db`;

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
(40, 2, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-09-01 12:31:12'),
(41, 3, 'google_signup', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-01 13:22:57'),
(42, 3, 'student_id_set', 'Student ID recorded: K12150334', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-01 13:23:07'),
(43, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '2026-09-01 13:32:01'),
(44, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-28 01:00:25'),
(45, 3, 'google_login', 'rpapa.k12150334@umak.edu.ph', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 01:33:51'),
(46, 2, 'lost_item_reported', 'VERIFY-24ae3482', '::1', NULL, '2026-09-28 02:38:24'),
(47, 2, 'lost_item_updated', 'item=1', '::1', NULL, '2026-09-28 02:38:24'),
(48, 2, 'claim_filed', 'found_item=1', '::1', NULL, '2026-09-28 02:38:24'),
(49, 2, 'claim_withdrawn', 'claim=1', '::1', NULL, '2026-09-28 02:38:24'),
(50, 2, 'password_set', 'Password created/updated by user.', '::1', NULL, '2026-09-28 02:38:24'),
(51, 2, 'password_changed', 'Password changed from account settings.', '::1', NULL, '2026-09-28 02:38:25'),
(52, 2, 'lost_item_deleted', 'item=1', '::1', NULL, '2026-09-28 02:38:25'),
(53, 3, 'privacy_updated', 'Lost reports are listed on campus.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-28 02:52:14'),
(54, 3, 'privacy_updated', 'Lost reports are listed on campus.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.22.7 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '2026-09-28 02:53:57'),
(55, 3, 'profile_updated', 'Updated phone and department.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 02:56:48'),
(56, 3, 'lost_item_reported', 'StudentID', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 02:57:31'),
(57, 3, 'password_set', 'Password created/updated by user.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 02:58:16'),
(58, 3, 'notification_prefs_updated', 'Updated notification preferences.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 02:58:51'),
(59, 3, 'notification_prefs_updated', 'Updated notification preferences.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 02:58:57'),
(60, 3, 'totp_enabled', 'Authenticator app enabled from account settings.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:15:43'),
(61, 3, 'logout', '', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:15:55'),
(62, 3, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:16:12'),
(63, 3, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:17:01'),
(64, 3, 'logout', '', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:19:17'),
(65, 3, 'login_password_ok', 'Password verified, TOTP sent.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:19:36'),
(66, 3, 'login_success', 'TOTP verified, session started.', '::1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36', '2026-09-28 03:20:24'),
(67, 3, 'login_method_updated', 'Authenticator code is asked first.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 03:35:46'),
(68, 3, 'login_method_updated', 'Authenticator code is asked first.', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 03:35:57'),
(69, 3, 'logout', '', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', '2026-09-28 03:36:35');

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

-- --------------------------------------------------------

--
-- Table structure for table `found_items`
--

CREATE TABLE `found_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `public_code` varchar(30) DEFAULT NULL,
  `logged_by` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` enum('Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other') NOT NULL,
  `location_found` varchar(150) NOT NULL,
  `date_found` date NOT NULL,
  `photo_path` varchar(500) DEFAULT NULL,
  `public_summary` varchar(500) DEFAULT NULL,
  `extracted_text` text DEFAULT NULL,
  `masked_features` text DEFAULT NULL,
  `status` enum('unclaimed','pending_verification','claimed','disposed','returned') NOT NULL DEFAULT 'unclaimed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `lost_items`
--

CREATE TABLE `lost_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `public_code` varchar(30) DEFAULT NULL,
  `reported_by` int(10) UNSIGNED NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `category` enum('Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other') NOT NULL,
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

INSERT INTO `lost_items` (`id`, `public_code`, `reported_by`, `item_name`, `category`, `last_seen_location`, `date_lost`, `photo_path`, `description`, `closed_reason`, `matched_found_item_id`, `matched_at`, `verified_at`, `resolved_at`, `closed_at`, `is_public`, `status`, `created_at`) VALUES
(2, 'LR-2026-002', 3, 'StudentID', 'ID', 'ADMIN', '2026-09-28', 'uploads/lost/lost_4d516da6f84afe7e.png', 'LOST ID', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'searching', '2026-09-28 02:57:31');

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
(2, 2, 'claim', 'Your claim is under review', 'Your claim for \"VERIFY-24ae3482-found\" is waiting for security verification.', 'claim', 1, NULL, '2026-09-28 02:38:24'),
(3, 3, 'report', 'Your lost report has been submitted', 'Your report for \"StudentID\" has been submitted.', 'lost', 2, NULL, '2026-09-28 02:57:31');

-- --------------------------------------------------------

--
-- Table structure for table `pickups`
--

CREATE TABLE `pickups` (
  `id` int(10) UNSIGNED NOT NULL,
  `claim_id` int(10) UNSIGNED NOT NULL,
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
(40, 2, '$2y$10$8Gl2BiX2ksM8nCXXCL/V/uzXUpMmyMe3z92cOXu3KND3lQ8XCAPDS', 'login', '2026-09-01 20:36:01', '2026-09-01 20:31:09', '2026-09-01 12:31:01'),
(41, 3, '$2y$10$jdWDs1xjso7mf1gn8RDuGON78PhR4u8GlDAA.1EwrpClcB8OnjF46', 'login', '2026-09-28 11:21:07', '2026-09-28 11:17:01', '2026-09-28 03:16:07'),
(42, 3, '$2y$10$uz3bSyZUNjC9yzFw4ffzu.76vDiZYSrtoH5a1K7U/dMsigRDpfAzy', 'login', '2026-09-28 11:24:30', '2026-09-28 11:20:24', '2026-09-28 03:19:30');

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
  `status` enum('active','blocked') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `failed_attempts` int(10) UNSIGNED DEFAULT 0,
  `lockout_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `student_id`, `phone`, `program_department`, `email_verified`, `phone_verified`, `last_login_at`, `notify_email`, `notify_sms`, `notify_in_app`, `notify_matches`, `notify_system`, `share_lost_reports`, `full_name`, `password_hash`, `password_is_set`, `skip_password_prompt`, `role`, `auth_provider`, `google_id`, `avatar_url`, `totp_secret`, `totp_enabled`, `login_method`, `status`, `created_at`, `updated_at`, `failed_attempts`, `lockout_until`) VALUES
(1, 'admin@umak.edu.ph', NULL, NULL, NULL, 1, 0, NULL, 1, 0, 1, 1, 1, 1, 'John Matthew S. Palma', '$2y$10$/HSC5vk1SeIlrrk.ZDDalusHSLMYAs5HGtcrvZVXaC1da27m4AMS6', 1, 0, 'admin', 'local', NULL, NULL, NULL, 0, 'email', 'active', '2026-09-01 10:42:39', '2026-09-28 00:29:22', 0, NULL),
(2, 'jangeles.a12345431@umak.edu.ph', 'A12345431', NULL, NULL, 1, 0, NULL, 1, 0, 1, 1, 1, 1, 'JUSTIN ANGELES', '$2y$10$vXoDV30IrWOFz3G2q5k9pO3QbEre2wA5SL3pIRYjjg8GtY89BACpG', 1, 0, 'student', 'local', '113623321447473046632', 'https://lh3.googleusercontent.com/a/ACg8ocJUBdUOLKMk1w_XtsK8RKQ-0aJNkuvfdbPsMLP2o6yF3pZ01XI=s96-c', 'G6V2D6DEZILCZEWR', 0, 'email', 'active', '2026-09-01 10:50:13', '2026-09-28 02:38:25', 0, NULL),
(3, 'rpapa.k12150334@umak.edu.ph', 'K12150334', NULL, NULL, 1, 0, '2026-09-28 11:20:24', 1, 0, 1, 1, 1, 1, 'RICHMHON PAPA', '$2y$10$EQTT63ciEpIouWupNM3E7.Y8ZvAZoV7T5tpl0Jt6dbOMVi.Q8cqJm', 1, 0, 'student', 'local', '116457197935379876137', 'https://lh3.googleusercontent.com/a/ACg8ocK1uq0sc53IbDwZpGkYhKSNYmjW4tdbJZCeiVHKfSnhM_OaO8-d=s96-c', '2JHDMVRUN7TFOORA', 1, 'totp', 'active', '2026-09-01 13:22:57', '2026-09-28 03:35:46', 0, NULL),
(4, 'administrator@umak.edu.ph', NULL, NULL, NULL, 1, 0, NULL, 1, 0, 1, 1, 1, 1, 'Administrator', '$2y$10$RYDohk1a.gHV4Gm5Ae0fOu0BqogkhYyAWOfgfnKQqUcO1nZmRF7hq', 1, 0, 'admin', 'local', NULL, NULL, 'HK2R2HZNX2RG3ZD4', 1, 'totp', 'active', '2026-09-28 03:32:14', '2026-09-28 03:32:14', 0, NULL);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `claims`
--
ALTER TABLE `claims`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `found_items`
--
ALTER TABLE `found_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `item_images`
--
ALTER TABLE `item_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_matches`
--
ALTER TABLE `item_matches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lost_items`
--
ALTER TABLE `lost_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pickups`
--
ALTER TABLE `pickups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
--
-- Database: `studentdb`
--
CREATE DATABASE IF NOT EXISTS `studentdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `studentdb`;

-- --------------------------------------------------------

--
-- Table structure for table `studentinfo`
--

CREATE TABLE `studentinfo` (
  `ID` int(5) NOT NULL,
  `LName` varchar(15) DEFAULT NULL,
  `FName` varchar(20) DEFAULT NULL,
  `MInitial` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `studentinfo`
--
ALTER TABLE `studentinfo`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `studentinfo`
--
ALTER TABLE `studentinfo`
  MODIFY `ID` int(5) NOT NULL AUTO_INCREMENT;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
--
-- Database: `umakcoop`
--
CREATE DATABASE IF NOT EXISTS `umakcoop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `umakcoop`;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `prod_id` int(11) DEFAULT NULL,
  `size_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `prod_id` int(11) NOT NULL,
  `prod_name` varchar(100) DEFAULT NULL,
  `stocks` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `prod_desc` text DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `prod_img` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`prod_id`, `prod_name`, `stocks`, `price`, `prod_desc`, `type_id`, `prod_img`) VALUES
(1, 'Essential Of Purposive Communication', 98, 425.00, 'Books', 1, 'purcomm.png'),
(2, 'Foundations Of Operations Management', 98, 450.00, 'Books', 1, 'FOUNDATIONS OF OPERATIONS MANAGEMENT.png'),
(3, 'Modern Physics', 97, 400.00, 'Books', 1, 'MODERN PHYSICS.png'),
(4, 'Web Applications Using PHP & MySQL', 100, 395.00, 'Books', 1, 'WEB APPLICATIONS USING PHP AND MYSQL.png'),
(5, 'NSTP Shirt', 104, 425.00, 'Uniforms', 2, 'nstp.png'),
(6, 'Naval Shirt', 102, 425.00, 'Uniforms', 2, 'Naval Shirt.png'),
(7, 'Tourism Uniform', 107, 425.00, 'Uniforms', 2, 'Tourism uniform.png'),
(8, 'PE Uniform', 101, 425.00, 'Uniforms', 2, 'PE UNIFORM.png'),
(9, 'Applied Business Tools and technologies', 100, 395.00, 'Books', 1, 'Applied Business Tools and technologies.png'),
(10, 'Art appreciation', 100, 425.00, 'Books', 1, 'art appreciation.png'),
(11, 'Mathematics in the Modern World', 99, 500.00, 'Books', 1, 'mathematics in the modern world.png'),
(12, 'Leisure & Recreation Management ', 100, 495.00, 'Books', 1, 'leisure & recreation management.png'),
(13, 'UMak Patch', 98, 75.00, 'Accessories', 3, 'PATCH.png'),
(14, 'CTHM Lanyard', 98, 75.00, 'Accessories', 3, 'cthm-id.png'),
(15, 'BSFM Lanyard', 100, 75.00, 'Accessories', 3, 'bsfm-id.png'),
(16, 'UMak Lanyard', 100, 75.00, 'Accessories', 3, 'UMak Lanyard.png');

-- --------------------------------------------------------

--
-- Table structure for table `product_sizes`
--

CREATE TABLE `product_sizes` (
  `prod_size_id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `size_id` int(11) NOT NULL,
  `size_stocks` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_sizes`
--

INSERT INTO `product_sizes` (`prod_size_id`, `prod_id`, `size_id`, `size_stocks`) VALUES
(1, 5, 1, 25),
(2, 5, 2, 25),
(3, 5, 3, 25),
(4, 5, 4, 25),
(5, 5, 5, 25),
(6, 6, 1, 25),
(7, 6, 2, 24),
(8, 6, 3, 24),
(9, 6, 4, 25),
(10, 6, 5, 25),
(11, 7, 1, 24),
(12, 7, 2, 25),
(13, 7, 3, 25),
(14, 7, 4, 24),
(15, 7, 5, 25),
(16, 8, 1, 24),
(17, 8, 2, 25),
(18, 8, 3, 25),
(19, 8, 4, 25),
(20, 8, 5, 25);

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `res_id` int(11) NOT NULL,
  `reference_no` varchar(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `prod_id` int(11) DEFAULT NULL,
  `size_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `res_date` date DEFAULT NULL,
  `res_time` time DEFAULT NULL,
  `queue_number` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `reservation_created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`res_id`, `reference_no`, `user_id`, `prod_id`, `size_id`, `quantity`, `res_date`, `res_time`, `queue_number`, `status_id`, `reservation_created`) VALUES
(131, 'REF9E8A811226EA', 58, 1, NULL, 1, '2025-05-28', '00:00:08', 1, 4, '2025-05-27 18:51:52'),
(132, 'REF9E8A811226EA', 58, 2, NULL, 1, '2025-05-28', '00:00:08', 1, 4, '2025-05-27 18:51:52'),
(133, 'REF18875CE45176', 58, 1, NULL, 1, '2025-05-30', '00:00:08', 1, 4, '2025-05-27 18:52:07'),
(134, 'REFF50B3E784380', 58, 9, NULL, 1, '2025-05-29', '00:00:08', 1, 4, '2025-05-27 20:09:26'),
(135, 'REFA10A3C90E0DD', 59, 2, NULL, 1, '2025-05-30', '00:00:08', 1, 1, '2025-05-29 21:40:39'),
(136, 'REFA10A3C90E0DD', 59, 3, NULL, 1, '2025-05-30', '00:00:08', 1, 4, '2025-05-29 21:40:39'),
(137, 'REFA10A3C90E0DD', 59, 11, NULL, 1, '2025-05-30', '00:00:08', 1, 4, '2025-05-29 21:40:39'),
(138, 'REFA10A3C90E0DD', 59, 7, 2, 5, '2025-05-30', '00:00:08', 1, 4, '2025-05-29 21:40:39'),
(139, 'REFB4EA6A8B694E', 59, 2, NULL, 1, '2025-05-29', '00:00:08', 1, 4, '2025-05-29 21:44:34'),
(140, 'REF9E0A670CE48F', 59, 2, NULL, 1, '2025-05-30', '00:00:08', 1, 4, '2025-05-29 21:46:44'),
(141, 'REF6342991D1D0B', 58, 4, NULL, 1, '2025-05-30', '00:00:08', 1, 1, '2025-05-30 01:00:58'),
(142, 'REF6342991D1D0B', 58, 9, NULL, 1, '2025-05-30', '00:00:08', 1, 1, '2025-05-30 01:00:58'),
(156, 'REF47939C1FE678', 58, 4, NULL, 1, '2025-06-02', '09:25:00', 18, 1, '2025-05-30 02:58:33'),
(157, 'REF47939C1FE678', 58, 13, NULL, 2, '2025-06-02', '09:25:00', 18, 1, '2025-05-30 02:58:33'),
(158, 'REFA3726310962E', 58, 2, NULL, 1, '2025-06-02', '08:00:00', 1, 1, '2025-05-30 02:59:58'),
(159, 'REFA3726310962E', 58, 14, NULL, 2, '2025-06-02', '08:00:00', 1, 1, '2025-05-30 02:59:58'),
(160, 'REF8FDA3EA3DFBB', 59, 6, 3, 1, '2025-06-02', '08:05:00', 2, 1, '2025-05-30 03:24:28'),
(161, 'REF8FDA3EA3DFBB', 59, 2, NULL, 1, '2025-06-02', '08:05:00', 2, 1, '2025-05-30 03:24:28'),
(162, 'REF42F3ED926AA5', 58, 1, NULL, 1, '2025-06-02', '08:10:00', 3, 1, '2025-05-30 03:24:53');

-- --------------------------------------------------------

--
-- Table structure for table `sizes`
--

CREATE TABLE `sizes` (
  `size_id` int(11) NOT NULL,
  `size_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sizes`
--

INSERT INTO `sizes` (`size_id`, `size_name`) VALUES
(1, 'XS'),
(2, 'S'),
(3, 'M'),
(4, 'L'),
(5, 'XL');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `status_id` int(11) NOT NULL,
  `res_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`status_id`, `res_status`) VALUES
(1, 'Reserved'),
(2, 'Completed'),
(3, 'Missed'),
(4, 'Cancelled');

-- --------------------------------------------------------

--
-- Table structure for table `type`
--

CREATE TABLE `type` (
  `type_id` int(11) NOT NULL,
  `prod_type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `type`
--

INSERT INTO `type` (`type_id`, `prod_type`) VALUES
(1, 'Books'),
(2, 'Uniform'),
(3, 'Accessories');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `student_no` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) DEFAULT NULL,
  `mi` char(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `student_no`, `email`, `password`, `fname`, `lname`, `mi`, `created_at`) VALUES
(1, 'K12000000', 'admin', '3a23651ec3e91b3983d66f1bc775135c95eb9cda2d791c8d44411f44cf9cf4cb', 'Admin', 'Admin', 'A', '2025-05-16 08:24:46'),
(2, 'K12482319', 'kabiog.K12482319@umak.edu.ph', '3a23651ec3e91b3983d66f1bc775135c95eb9cda2d791c8d44411f44cf9cf4cb', 'Kenjie', 'Abiog', 'C', '2025-05-20 06:16:57'),
(3, 'K12490276', 'jabunda.K12490276@umak.edu.ph', 'defaultpassword', 'John Kennidy', 'Abunda', 'M', '2025-05-16 08:24:46'),
(4, 'K12471985', 'aagana.K12471985@umak.edu.ph', 'defaultpassword', 'Andrei Kenneth', 'Agana', 'P', '2025-05-16 08:24:46'),
(5, 'K12468294', 'hargel.K12468294@umak.edu.ph', 'defaultpassword', 'Hazel Joy', 'Argel', 'D', '2025-05-16 08:24:46'),
(6, 'K12453170', 'zarsenal.K12453170@umak.edu.ph', 'defaultpassword', 'Zhann Llyn Anthony', 'Arsenal', 'L', '2025-05-16 08:24:46'),
(7, 'K12485567', 'ebagarinao.K12485567@umak.edu.ph', 'defaultpassword', 'Edan', 'Bagarinao', 'R', '2025-05-16 08:24:46'),
(8, 'K12446173', 'mbalanlay.K12446173@umak.edu.ph', 'defaultpassword', 'Mathew Angelo', 'Balanlay', 'F', '2025-05-16 08:24:46'),
(9, 'K12422890', 'cbaquiran.K12422890@umak.edu.ph', 'defaultpassword', 'Cherry Ailyn', 'Baquiran', 'N', '2025-05-16 08:24:46'),
(10, 'K12419564', 'jbarrientos.K12419564@umak.edu.ph', 'defaultpassword', 'Joel', 'Barrientos', 'E', '2025-05-16 08:24:46'),
(11, 'K12474285', 'dbergonia.K12474285@umak.edu.ph', 'defaultpassword', 'Divine', 'Bergonia', 'Q', '2025-05-16 08:24:46'),
(12, 'K12466717', 'jbermundo.K12466717@umak.edu.ph', 'defaultpassword', 'Joyce Andrea', 'Bermundo', 'K', '2025-05-16 08:24:46'),
(13, 'K12490114', 'kcalleja.K12490114@umak.edu.ph', 'defaultpassword', 'Kuznets Zachary', 'Calleja', 'O', '2025-05-16 08:24:46'),
(14, 'K12435216', 'jcamarador.K12435216@umak.edu.ph', 'defaultpassword', 'Jhorenz', 'Camarador', 'S', '2025-05-16 08:24:46'),
(15, 'K12481091', 'jcampo.K12481091@umak.edu.ph', 'defaultpassword', 'John Richie', 'Campo', 'A', '2025-05-16 08:24:46'),
(16, 'K12499758', 'ccaracas.K12499758@umak.edu.ph', 'defaultpassword', 'Christian Joel', 'Caracas', 'T', '2025-05-16 08:24:46'),
(17, 'K12433477', 'ccejalvo.K12433477@umak.edu.ph', 'defaultpassword', 'Christopher John', 'Cejalvo', 'G', '2025-05-16 08:24:46'),
(18, 'K12488142', 'acerilla.K12488142@umak.edu.ph', 'defaultpassword', 'Alexander', 'Cerilla', 'J', '2025-05-16 08:24:46'),
(19, 'K12421719', 'lcorpuz.K12421719@umak.edu.ph', 'defaultpassword', 'Lance Josh', 'Corpuz', 'H', '2025-05-16 08:24:46'),
(20, 'K12468492', 'ccustodio.K12468492@umak.edu.ph', 'defaultpassword', 'Catherine', 'Custodio', 'M', '2025-05-16 08:24:46'),
(21, 'K12447553', 'mdapalla.K12447553@umak.edu.ph', 'defaultpassword', 'Mark', 'Dapalla', 'Z', '2025-05-16 08:24:46'),
(22, 'K12495961', 'pdcalzada.K12495961@umak.edu.ph', 'defaultpassword', 'Paul Rafael', 'Dela Calzada', 'Y', '2025-05-16 08:24:46'),
(23, 'K12466378', 'jdcruz.K12466378@umak.edu.ph', 'defaultpassword', 'John Clerwin', 'Dela Cruz', 'F', '2025-05-16 08:24:46'),
(24, 'K12421134', 'lfernando.K12421134@umak.edu.ph', 'defaultpassword', 'Louis Arthur', 'Fernando', 'V', '2025-05-16 08:24:46'),
(25, 'K12445009', 'ggabatin.K12445009@umak.edu.ph', 'defaultpassword', 'Gabriel', 'Gabatin', 'B', '2025-05-16 08:24:46'),
(26, 'K12427864', 'agoze.K12427864@umak.edu.ph', 'defaultpassword', 'Aj', 'Goze', 'I', '2025-05-16 08:24:46'),
(27, 'K12471116', 'sgumia.K12471116@umak.edu.ph', 'defaultpassword', 'Steven', 'Gumia', 'U', '2025-05-16 08:24:46'),
(28, 'K12484003', 'mhernandez.K12484003@umak.edu.ph', 'defaultpassword', 'Madelaine Angela', 'Hernandez', 'P', '2025-05-16 08:24:46'),
(29, 'K12473899', 'dibanga.K12473899@umak.edu.ph', 'defaultpassword', 'Denisse Margaret', 'Ibanga', 'C', '2025-05-16 08:24:46'),
(30, 'K12445788', 'jjoquico.K12445788@umak.edu.ph', 'defaultpassword', 'Jullian Miguel', 'Joquico', 'W', '2025-05-16 08:24:46'),
(31, 'K12430125', 'klayco.K12430125@umak.edu.ph', 'defaultpassword', 'Kevin Cris', 'Layco', 'R', '2025-05-16 08:24:46'),
(32, 'K12411792', 'jluzano.K12411792@umak.edu.ph', 'defaultpassword', 'Justin Mark', 'Luzano', 'M', '2025-05-16 08:24:46'),
(33, 'K12448551', 'amagpulong.K12448551@umak.edu.ph', 'defaultpassword', 'Alyzza Claire', 'Magpulong', 'S', '2025-05-16 08:24:46'),
(34, 'K12424773', 'rmaramag.K12424773@umak.edu.ph', 'defaultpassword', 'Reynaldo Jr.', 'Maramag', 'Y', '2025-05-16 08:24:46'),
(35, 'K12475992', 'dnaldoza.K12475992@umak.edu.ph', 'defaultpassword', 'Darlene', 'Naldoza', 'X', '2025-05-16 08:24:46'),
(36, 'K12460845', 'jnarvaja.K12460845@umak.edu.ph', 'defaultpassword', 'Jester John', 'Narvaja', 'B', '2025-05-16 08:24:46'),
(37, 'K12419654', 'ynasayao.K12419654@umak.edu.ph', 'defaultpassword', 'Yoshke Grei', 'Nasayao', 'K', '2025-05-16 08:24:46'),
(38, 'K12440199', 'moctaviano.K12440199@umak.edu.ph', 'defaultpassword', 'Miguel', 'Octaviano', 'E', '2025-05-16 08:24:46'),
(39, 'K12497200', 'rpapa.K12497200@umak.edu.ph', 'defaultpassword', 'Richmhon', 'Papa', 'L', '2025-05-16 08:24:46'),
(40, 'K12466711', 'jquiambao.K12466711@umak.edu.ph', 'defaultpassword', 'Jermaine Carl', 'Quiambao', 'D', '2025-05-16 08:24:46'),
(41, 'K12459007', 'rramos.K12459007@umak.edu.ph', 'defaultpassword', 'Rydine Cassandra', 'Ramos', 'F', '2025-05-16 08:24:46'),
(42, 'K12425328', 'areciproco.K12425328@umak.edu.ph', 'defaultpassword', 'Ace Alwin', 'Reciproco', 'G', '2025-05-16 08:24:46'),
(43, 'K12432244', 'privera.K12432244@umak.edu.ph', 'defaultpassword', 'Paul Angelo', 'Rivera', 'M', '2025-05-16 08:24:46'),
(44, 'K12452515', 'rsoberano.K12452515@umak.edu.ph', 'defaultpassword', 'Ralph Christopher', 'Soberano', 'T', '2025-05-16 08:24:46'),
(45, 'K12493826', 'rsuarez.K12493826@umak.edu.ph', 'defaultpassword', 'Ron Vincent', 'Suarez', 'Q', '2025-05-16 08:24:46'),
(46, 'K12486119', 'jtaqueban.K12486119@umak.edu.ph', 'defaultpassword', 'Jiane', 'Taqueban', 'Z', '2025-05-16 08:24:46'),
(47, 'K12485442', 'mvaldez.K12485442@umak.edu.ph', 'defaultpassword', 'Michael David', 'Valdez', 'P', '2025-05-16 08:24:46'),
(48, 'K12410977', 'jvecinal.K12410977@umak.edu.ph', 'defaultpassword', 'Juviel Ellah Mae', 'Vecinal', 'D', '2025-05-16 08:24:46'),
(55, 'admin', 'umakcooponlinereservation@gmail.com', 'scrypt:32768:8:1$gcKyw6VBEguddRh5$5c539b6b74bc8bdefd3ca5ca503b5b50aec67a5a59a615eb8b158f87ebaa4e10b7e5a133b3a7f73735974ced295a3a164dac23f3bf775dbebc52cea0a1887617', 'admin', 'admin', 'a', '2025-05-20 04:12:10'),
(58, 'K12150332', 'rpapa.k12150334@umak.edu.ph', 'd216192b0f9d85a2aa8729ac906a6e2dfeb8041f353a7ad8884d4cfe8126ae8c', 'Richmhon', 'Papa', 'L', '2025-05-29 16:26:12'),
(59, 'K12151536', 'johnclerwin939.dj@gmail.com', '39f12ff7f470d255681803ec95de46792b44517f29869e9bd1cb67c058676590', 'John Clerwin', 'Dela Cruz', 'N', '2025-05-28 13:23:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `prod_id` (`prod_id`),
  ADD KEY `size_id` (`size_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`prod_id`),
  ADD KEY `type_id` (`type_id`);

--
-- Indexes for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD PRIMARY KEY (`prod_size_id`),
  ADD KEY `prod_id` (`prod_id`),
  ADD KEY `size_id` (`size_id`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`res_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `prod_id` (`prod_id`),
  ADD KEY `status_id` (`status_id`),
  ADD KEY `reservation_ibfk_4` (`size_id`);

--
-- Indexes for table `sizes`
--
ALTER TABLE `sizes`
  ADD PRIMARY KEY (`size_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`status_id`);

--
-- Indexes for table `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`type_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=233;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `prod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `product_sizes`
--
ALTER TABLE `product_sizes`
  MODIFY `prod_size_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `res_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `sizes`
--
ALTER TABLE `sizes`
  MODIFY `size_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `type`
--
ALTER TABLE `type`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `products` (`prod_id`),
  ADD CONSTRAINT `cart_ibfk_3` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`size_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `type` (`type_id`);

--
-- Constraints for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD CONSTRAINT `product_sizes_ibfk_1` FOREIGN KEY (`prod_id`) REFERENCES `products` (`prod_id`),
  ADD CONSTRAINT `product_sizes_ibfk_2` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`size_id`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`prod_id`) REFERENCES `products` (`prod_id`),
  ADD CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`),
  ADD CONSTRAINT `reservation_ibfk_4` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`size_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
