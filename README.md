# USER MANUAL

**Retrieva – Campus Lost and Found Platform (University of Makati)**  
*Web System and Technologies (Elective 4) Case Study*  
*Submitted to: Engr. Michael C. Olivo*

---

## Chapter 1 – Introduction

### 1.1 System Overview

**Retrieva** is a prototype web-based Campus Lost and Found Platform designed for the **University of Makati (UMak)**. It centralizes how lost-item reports, found-item logs, ownership claims, and item pickups are recorded, verified, and tracked across campus.

The platform follows a structured end-to-end workflow:

1. **Reporting or Logging Items**: Students and Professors submit lost-item reports (`dashboard/lost-items.php`), while authorized Security Personnel and Administrators log items turned in to campus custody (`dashboard/found-items.php`).
2. **Claiming & Verification**: Students and Professors browse available unclaimed items (`dashboard/claims.php`) and submit an identifying detail without seeing sensitive item metadata. Security Personnel and Administrators review pending claims (`dashboard/pending-verifications.php` or `dashboard/claims.php`) and approve, flag for manual review, or reject them.
3. **Single-Use QR Pickup**: Once a claim is approved, the system generates a unique single-use 64-character hex QR token. The claimant presents the QR code from their **Claims** page (`#pickup-qr-modal`), and Security/Admin staff scan or verify it (`dashboard/pickup-verification.php`) to mark the item as returned.
4. **Monitoring & Reporting**: Real-time notifications (via Pusher private channels), analytics charts, downloadable CSV/PDF reports (`dashboard/reports.php`), and an Administrator-only audit trail (`dashboard/audit-trail.php`) keep all transactions transparent and accountable.

### 1.2 Purpose

Traditional campus lost-and-found processes often rely on paper logbooks, scattered social media posts, or manual walk-in inquiries, which can lead to:

- Lost or incomplete records of turned-in belongings.
- Difficulty verifying true ownership without accidentally revealing identifying details to unauthorized claimants.
- Slow communication when matching items or approving claims.
- Lack of auditability, pickup proof, and structured reporting for campus administration.

Retrieva solves these problems by providing a secure, role-based, real-time web platform that enforces `@umak.edu.ph` campus authentication, protects item details until ownership is verified, issues single-use QR codes for item release, and generates exportable CSV and PDF reports.

### 1.3 Intended Users

Retrieva implements server-side Role-Based Access Control (`dashboard/rbac.php`) across four user roles:

- **Administrator (`admin`)**: Full system oversight. Has access to the Dashboard (with Integrations Status), Found Items, Lost Items (All Active Reports), Claims review, Pending Verifications, QR Pickup Verification, Reports & Export (including the Admin-only Audit Trail report), the Audit Trail module (`dashboard/audit-trail.php`), and Account Settings.
- **Security Personnel (`security`)**: Campus operations and verification staff. Has access to the Dashboard, Found Items logging/management, Lost Items (All Active Reports), Claims review, Pending Verifications, QR Pickup Verification, Reports & Export (Lost Items, Found Items, Claims, Pickups, and Item Inventory—excluding Audit Trail), and Account Settings.
- **Professor (`professor`)**: Campus faculty member. Has access to the client Dashboard, Lost Items (submitting lost-item reports), Claims (browsing unclaimed items, filing claims, viewing personal claim status and pickup QR codes), and Account Settings.
- **Student (`student`)**: Campus student. Has access to the client Dashboard, Lost Items (submitting lost-item reports), My Reports (`dashboard/my-reports.php`, restricted to students to track, resolve, or delete their own searching reports), Claims (browsing unclaimed items, filing claims, viewing personal claim status and pickup QR codes), and Account Settings.

### 1.4 System Features

Only features implemented in the current Retrieva codebase are listed below:

- **User Authentication and Account Management**: Local email/password sign-in (`auth/login.php`), account lockout after 5 consecutive failed attempts (15-minute cooldown), password reset flow (`auth/forgot-password.php`), and Google reCAPTCHA v2 verification on Login and Forgot Password.
- **Google OAuth (Where Configured)**: Campus-restricted `@umak.edu.ph` Google Sign-In and registration (`database/google_oauth_redirect.php`, `database/google_oauth_callback.php`) using `league/oauth2-google`, plus one-time Student ID and optional password setup modals.
- **TOTP-Based Multi-Factor Authentication**: Email-delivered 6-digit verification codes during local sign-in (`auth/totp.php`, `database/totp_verify.php`) with one-click pre-fill link and Paste Code support, plus optional authenticator app secret setup/disable in `dashboard/settings.php`.
- **Lost-Item Reporting**: Submit lost-item reports with category, optional custom `Others` category description (`other_category`), last-seen location, date lost, and description (`dashboard/lost-items.php`), plus a dedicated `My Reports` module for students (`dashboard/my-reports.php`).
- **Found-Item Registration and Management**: Log found items, filter by status, mark items as disposed, or delete records (`dashboard/found-items.php`).
- **Item Matching**: Update lost-item report statuses (`Searching`, `Matched`, `Resolved`) in real time via AJAX in `dashboard/lost-items.php` (with `item_matches` table support in the database).
- **Claims Management and Verification**: File claims against unclaimed found items, and allow Admin/Security staff to **Approve**, **Reject**, or **Flag** claims for manual review (`dashboard/claims.php`, `dashboard/pending-verifications.php`).
- **QR-Based Pickup Verification**: Automatic single-use QR token generation upon claim approval, claimant QR modal display (`qrcodejs`), and staff camera scanner (`html5-qrcode`) or manual 64-character token verification (`dashboard/pickup-verification.php`, `database/verify_pickup_qr.php`).
- **Notifications**: Persistent database-backed notification bell (`database/notifications.php`) and real-time toast alerts across all user roles.
- **Search and Filtering**: Topbar global search on the Dashboard (`database/search.php`) scoped by role, plus status/date/action filters in Found Items, Reports, and Audit Trail.
- **Dashboard Statistics and Real-Time Updates through Pusher**: Role-scoped KPI cards, 7-day line chart and category doughnut chart (Chart.js), and authenticated Pusher private channels (`database/pusher_auth.php`, `private-user-{id}`, `private-staff`, `private-updates`) that refresh stats and module tables without page reloads.
- **Reports and Analytics**: Interactive report viewer (`dashboard/reports.php`) with real-time AJAX date-range and status filtering across 6 report types.
- **CSV and PDF Exports**: Native PHP `fputcsv()` CSV exports with formula-injection protection and formatted PDF exports powered by `dompdf/dompdf` (`database/export_report.php`).
- **Audit Logs**: Dedicated Administrator-only Audit Trail module (`dashboard/audit-trail.php`) tracking login attempts, item actions, claim reviews, QR verifications, and report exports.
- **Account Settings and Security Preferences**: Profile overview, password change with live 5-rule strength checklist (`database/change_password.php`), authenticator setup/disable modal, and personal activity history (`dashboard/settings.php`).

---

## Chapter 2 – System Requirements

### 2.1 Hardware Requirements

The following hardware specifications are intended for running Retrieva locally on a XAMPP server. *(Note: These are general minimum and recommended requirements, separate from the specific development computer used to build the project.)*

| Component | Minimum Requirement | Recommended Requirement |
|---|---|---|
| **Processor (CPU)** | Dual-core 2.0 GHz (x64) | Quad-core 2.4 GHz or higher |
| **Memory (RAM)** | 4 GB RAM | 8 GB RAM or higher |
| **Storage** | 2 GB free disk space | 5 GB free SSD space |
| **Display** | 1280 × 720 resolution | 1366 × 768 or 1920 × 1080 resolution |
| **Camera (Optional)** | None (manual QR token entry supported) | Built-in or USB webcam for live QR scanning |

### 2.2 Software Requirements

- **Operating System**: Microsoft Windows 10 or Windows 11 (64-bit)
- **Web Server Stack**: XAMPP for Windows (bundling Apache and MariaDB/MySQL)
- **Web Server**: Apache HTTP Server (included in XAMPP)
- **PHP**: PHP 8.0 or higher (tested with PHP 8.2.4)
- **Database**: MySQL / MariaDB (tested with MariaDB 10.4.28, `InnoDB`, `utf8mb4_unicode_ci`)
- **Dependency Manager**: Composer (for installing PHP packages)
- **Web Browser**: Modern browser (Google Chrome, Microsoft Edge, or Mozilla Firefox) with JavaScript enabled
- **Required PHP Extensions**:
  - `pdo_mysql` and `mysqli` (database connectivity)
  - `curl` (Google OAuth, Pusher, and Google reCAPTCHA `siteverify` requests)
  - `openssl` (HTTPS/TLS, password hashing, and token generation)
  - `mbstring` and `dom` / `xml` (required by `dompdf/dompdf` for PDF generation)
  - `json`, `session`, `fileinfo`, `filter`
- **Composer Dependencies (`composer.json`)**:
  - `league/oauth2-google` (`^5.0`)
  - `phpmailer/phpmailer` (`^7.1`)
  - `pusher/pusher-php-server` (`^7.3`)
  - `dompdf/dompdf` (`^3.1`)
- **Frontend CDN Libraries (loaded in browser)**:
  - `Chart.js v4` (dashboard analytics)
  - `Pusher JS 8.2.0` (real-time WebSockets)
  - `qrcodejs` (claimant QR code rendering)
  - `html5-qrcode` (staff camera QR scanning)
  - Google reCAPTCHA v2 API (`https://www.google.com/recaptcha/api.js`)

### 2.3 Network Requirements

- **Localhost Access (Offline-Capable Core)**:
  - Apache and MySQL communicate locally via `localhost` (`127.0.0.1`).
  - Core local operations—such as local password login, logging found/lost items, filing and reviewing claims, manual QR token verification, viewing the Audit Trail, and exporting CSV/PDF reports—work over `localhost` without external internet access (assuming Composer dependencies are already installed).
- **Internet Connectivity Required for External Integrations**:
  - **Google OAuth (`league/oauth2-google`)**: Requires outbound HTTPS access to Google Accounts for `@umak.edu.ph` sign-in/registration.
  - **Google reCAPTCHA v2**: Requires internet access in the user's browser to load the reCAPTCHA widget and on the server to verify tokens via `https://www.google.com/recaptcha/api/siteverify`.
  - **SMTP / Email Delivery (`PHPMailer`)**: Requires outbound SMTP access (e.g., `smtp.gmail.com` port `465`) to send 6-digit verification codes unless `MAIL_DEV_MODE` is enabled for local logging.
  - **Pusher Real-Time WebSockets**: Requires internet access for real-time dashboard/table synchronization and live notification bell updates, as well as loading CDN scripts (`js.pusher.com`, `cdn.jsdelivr.net`).

---

## Chapter 3 – System Installation

### 3.1 Web Server Installation

1. Download the **XAMPP for Windows** installer (with PHP 8.0 or higher) from the official Apache Friends website.
2. Run the installer and install XAMPP to the default directory `C:\xampp`. Ensure **Apache** and **MySQL** (and **phpMyAdmin**) are selected.
3. Open the **XAMPP Control Panel**.
4. Click **Start** next to **Apache** and wait until the status turns green (ports `80` / `443`).
5. Click **Start** next to **MySQL** and wait until the status turns green (port `3306`).
6. Open a web browser and visit `http://localhost/dashboard/` to verify that Apache is running properly.

### 3.2 Application Installation

1. Obtain the Retrieva source code either by cloning the GitHub repository or extracting the project archive.
2. Place the project folder inside `C:\xampp\htdocs\` so the application root is:
   ```text
   C:\xampp\htdocs\Retrieva
   ```
3. Open **PowerShell** or **Command Prompt**, navigate to the project directory, and install Composer dependencies:
   ```powershell
   cd C:\xampp\htdocs\Retrieva
   composer install
   ```
   *(If Composer is installed via XAMPP's `composer.phar`, run `php C:\xampp\php\composer.phar install` instead.)*
4. Verify that the `vendor/` directory and `vendor/autoload.php` are present.

### 3.3 Database Installation

Retrieva includes two SQL files in the `database/` folder:
- `database/schema.sql`: The intended clean database schema (creates the `retrieva_db` database, all core tables, and a starter `admin@umak.edu.ph` account).
- `database/retrieva_db.sql`: A phpMyAdmin sample data export containing sample records and tables.

> **Important Warning:** Choose **only one** SQL file to import into a single database. **Do not import both `schema.sql` and `retrieva_db.sql` into the same database**, as doing so will cause duplicate table and key errors.

To install the database using phpMyAdmin:

1. Open your browser and navigate to `http://localhost/phpmyadmin/`.
2. Click **New** in the left sidebar.
3. Enter the database name (for example, `retrieva_db`), select collation **`utf8mb4_unicode_ci`**, and click **Create**.
4. Select your newly created database in the left sidebar, then click the **Import** tab at the top.
5. Click **Choose File** and select `C:\xampp\htdocs\Retrieva\database\schema.sql` (or `retrieva_db.sql` if you want the sample dataset).
6. Scroll down and click **Import** (or **Go**). Wait for the green confirmation banner indicating all queries executed successfully.

*(Note: If you use `schema.sql`, ensure the `notifications` table and `other_category` columns on `found_items` and `lost_items` are present if upgrading from an older dump.)*

### 3.4 Database Configuration

Open `C:\xampp\htdocs\Retrieva\database\db.php` and verify that the PDO connection constants match your local MySQL/MariaDB setup:

```php
const DB_HOST = 'localhost';
const DB_NAME = 'your_database_name'; // e.g., 'retrieva_db'
const DB_USER = 'your_db_username';   // XAMPP default: 'root'
const DB_PASS = 'your_db_password';   // XAMPP default: '' (blank)
```

Save the file after updating `DB_NAME`, `DB_USER`, and `DB_PASS` to match the database you created in Section 3.3. Never commit real production database passwords to version control.

### 3.5 Application Configuration

Review the following configuration files before using optional external integrations:

1. **Local Application URL**:
   Access the application in your browser at:
   ```text
   http://localhost/Retrieva/
   ```
   To open the sign-in screen directly, navigate to:
   ```text
   http://localhost/Retrieva/auth/login.php
   ```
2. **Google OAuth Configuration (`database/oauth_config.php`)**:
   If Google Sign-In (`@umak.edu.ph`) is enabled, update `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, and `GOOGLE_REDIRECT_URI` with your Google Cloud OAuth 2.0 Web Application credentials:
   ```php
   const GOOGLE_CLIENT_ID     = 'YOUR_GOOGLE_CLIENT_ID';
   const GOOGLE_CLIENT_SECRET = 'YOUR_GOOGLE_CLIENT_SECRET';
   const GOOGLE_REDIRECT_URI  = 'http://localhost/Retrieva/database/google_oauth_callback.php';
   const ALLOWED_EMAIL_DOMAIN = 'umak.edu.ph';
   ```
3. **SMTP / Email Configuration (`database/mailer.php`)**:
   Configure your SMTP host, port, username, and app password in `database/mailer.php` to deliver 6-digit TOTP and password-reset emails. For offline local testing without SMTP, set `MAIL_DEV_MODE = true` so codes are written to the PHP error log instead of sending live emails:
   ```php
   const MAIL_DEV_MODE = false; // Set to true for local error_log testing
   $mail->Host     = 'smtp.gmail.com';
   $mail->Username = 'your_campus_email@umak.edu.ph';
   $mail->Password = 'YOUR_APP_PASSWORD';
   ```
4. **Pusher Real-Time Configuration (`dashboard/_bootstrap.php`, `database/notify_helper.php`, `dashboard/dashboard.js`)**:
   Ensure `PUSHER_APP_ID`, `PUSHER_KEY`, `PUSHER_SECRET`, and `PUSHER_CLUSTER` match your Pusher Channels app, and confirm the matching public key and cluster are set in `dashboard/dashboard.js`.
5. **Google reCAPTCHA v2 Configuration (`database/recaptcha_config.php`)**:
   Store your Google reCAPTCHA v2 Site Key and Secret Key in `database/recaptcha_config.php`:
   ```php
   <?php
   define('RECAPTCHA_SITE_KEY', 'YOUR_RECAPTCHA_SITE_KEY');
   define('RECAPTCHA_SECRET_KEY', 'YOUR_RECAPTCHA_SECRET_KEY');
   ```
   > **Security Notice:** `database/recaptcha_config.php` is listed in `.gitignore`. Never remove it from `.gitignore` or commit secret keys to GitHub.

---

## Chapter 4 – System Operation

### 4.1 System Login

All users—Students, Professors, Security Personnel, and Administrators—sign in through the same gateway at `http://localhost/Retrieva/auth/login.php`.

[Insert Screenshot: Login Page]

#### Option A: Email and Password Sign-In (With TOTP)

1. Open `http://localhost/Retrieva/auth/login.php`.
2. Enter your registered `@umak.edu.ph` email address and password.
3. *(Optional)* Check **Remember Me** to save your email locally in your browser.
4. Complete the **Google reCAPTCHA** checkbox ("I'm not a robot").
5. Click **Sign In**.
   - *Note:* Five consecutive failed password attempts trigger a **15-minute security cooldown** lockout.
6. Upon password verification, you are redirected to **Two-Factor Security** (`auth/totp.php`).
7. Check your email inbox for the 6-digit security code:
   - Click **Open Two-Factor Security** in the email to open the page with the code pre-filled, **or**
   - Copy the 6-digit code from the email and click **Paste Code** (or type the digits into the boxes).
8. Click **Verify Code** to enter your Dashboard.

[Insert Screenshot: Two-Factor Security Verification Page]

#### Option B: Google Sign-In (`@umak.edu.ph`)

1. On the Sign In page, click **Sign in with Google** (or **Register here** for new `@umak.edu.ph` accounts).
2. Choose your official `@umak.edu.ph` Google account.
3. On first sign-in:
   - **Students** without a Student ID on file are prompted by a modal to enter their **Student ID** before continuing.
   - **Google-authenticated users** without a local password are offered an optional modal to set a fallback password (or click **Later**).

#### Forgot Password Flow

1. Click **Forgot Password?** on the Sign In page to open `auth/forgot-password.php`.
2. Enter your `@umak.edu.ph` email, complete the **reCAPTCHA** checkbox, and click **Send Security Code**.
3. Enter the 6-digit code sent to your email (or click **Back to Sign In** if you cannot receive the code).
4. Set and confirm your new password, then return to `auth/login.php` to sign in.

### 4.2 Dashboard

After signing in, users land on `dashboard/index.php`. The interface adapts automatically based on your role:

- **Navigation Sidebar (`dashboard/components/sidebar.php`)**: Displays only the modules permitted for your role, along with a live red badge on **Pending Verifications** for Admin/Security users.
- **Top Header Bar (`dashboard/components/header.php`)**:
  - **Global Search** (visible on the Dashboard): Search items or claims.
  - **Notification Bell**: Shows an unread count badge and dropdown of recent system, report, and claim notifications. Opening the dropdown marks notifications as read; **Clear all** clears your notification list.
  - **User Menu**: Displays your profile avatar, name, and role, with links to **Profile overview**, **Settings**, and **Log out**.
- **KPI Stat Cards**:
  - *Admin / Security*: Total Found Items, Total Lost Reports, Total Claims, and Items Returned (blue card).
  - *Student / Professor*: Available Unclaimed, My Lost Reports, My Total Claims, and Successful Claims (blue card).
- **Analytics & Widgets**:
  - **Items Overview**: Interactive 7-day line chart comparing Found vs. Lost items.
  - **Recent Found Items**: Shows the 5 most recent found items (with smart masking applied for Student/Professor views).
  - **Pending Verifications Summary** *(Admin / Security only)*: Quick count of claims awaiting review.
  - **Items by Category**: Interactive doughnut chart and category count breakdown.
  - **Quick Actions**: Role-specific shortcut buttons.
  - **All Systems Secure & Integrations Status** *(Admin / Security; Integrations card is Admin-only)*: Displays Google OAuth and live Pusher WebSocket connection status.

[Insert Screenshot: Admin Dashboard]
[Insert Screenshot: Student Dashboard]

### 4.3 User Management

Retrieva does **not** include a separate User Management CRUD page for creating, editing, or deleting user accounts from the dashboard. Instead:

- **Account Creation**: New Student/Campus accounts are provisioned automatically when users sign in with an `@umak.edu.ph` Google account, or via database seed/import for local Staff/Admin accounts.
- **Self-Service Account Management (`dashboard/settings.php`)**: Every signed-in user can view their profile details (Name, Email, Role, and Student ID if applicable), change their password using the 5-rule strength checklist, enable or disable an authenticator app (TOTP), and review their personal activity history.
- **Administrator Account Monitoring (`dashboard/audit-trail.php`)**: Administrators monitor all login successes, failed password attempts, account lockouts, blocked-account attempts, and password/TOTP changes through the **Audit Trail** module and real-time admin notifications.

### 4.4 Main Transactions

#### 1. Submitting a Lost-Item Report (All Roles)

1. Click **Lost Items** in the sidebar (`dashboard/lost-items.php`).
2. Fill out the **Report a Lost Item** form:
   - **Item name**
   - **Category** (if you select **Others**, an additional **Specify item type / description** field appears)
   - **Last seen location**
   - **Date lost**
   - **Description** (identifying features such as color, brand, or contents)
3. Click **Submit Report**. Admin and Security staff receive a notification of the new report.
4. *(Students)* Click **My Reports** (`dashboard/my-reports.php`) to view your submitted reports, click **Mark Resolved** when recovered, or **Delete** a report while its status is still `Searching`.

[Insert Screenshot: Lost Items Reporting Form]

#### 2. Viewing Found Items

- **Students & Professors**: Open **Claims** (`dashboard/claims.php`) to browse the list of currently **Unclaimed** found items (category, location found, and date found).
- **Admin & Security**: Open **Found Items** (`dashboard/found-items.php`) to view all found items across all statuses (`Unclaimed`, `Pending Verification`, `Claimed`, `Disposed`).

#### 3. Logging a Found Item (Admin & Security Only)

1. Open **Found Items** (`dashboard/found-items.php`) from the sidebar.
2. Under **Log a Found Item**, enter the **Item name**, select the **Category** (and fill in **Specify item type / description** if **Others** is selected), enter **Location found**, and select **Date found**.
3. Click **Log Found Item**. The status starts as `Unclaimed`, and users are notified.
4. From the **All Found Items** table, authorized staff can also click **Dispose** (with confirmation modal) on unclaimed items or **Delete** a record.

[Insert Screenshot: Found Items Management Page]

#### 4. Reviewing and Matching Items (Admin & Security Only)

1. Open **Lost Items** (`dashboard/lost-items.php`).
2. Scroll to **All Active Reports**.
3. Use the status dropdown in the **Actions** column of any row to switch a report between **Searching**, **Matched**, and **Resolved**.
4. The status updates immediately in-place via AJAX without reloading the page and notifies the reporter.

#### 5. Submitting a Claim (Student & Professor)

1. Open **Claims** (`dashboard/claims.php`) from the sidebar.
2. Locate the matching item in the unclaimed items table.
3. In the **Claim** column, type a specific **Identifying detail** proving ownership (for example, unique stickers, serial number, or contents).
4. Click **Claim**. The item is locked as `Pending Verification`, and Admin/Security staff are notified.

[Insert Screenshot: Student Claims Page]

#### 6. Reviewing and Approving or Rejecting Claims (Admin & Security Only)

1. Open **Pending Verifications** (`dashboard/pending-verifications.php`) or **Claims** (`dashboard/claims.php`).
   - *Note:* In **Pending Verifications**, claims flagged for `Manual Review` appear first.
2. Compare the claimant's submitted **Answer** against the item's logged details.
3. Choose an action:
   - **Approve**: Marks the claim `Approved`, updates the found item to `Claimed`, generates a unique single-use pickup QR token, and notifies the claimant.
   - **Flag**: Moves a `Pending` claim to `Manual Review` for closer inspection.
   - **Reject**: Marks the claim `Rejected` and returns the found item to `Unclaimed`.

[Insert Screenshot: Pending Verifications Page]

#### 7. QR Pickup Verification & Confirming Item Return

1. **Claimant Side**: Once a claim is approved, the Student or Professor opens **Claims** (`dashboard/claims.php`), scrolls to **My Claims**, and clicks **View Pickup QR** to display their single-use QR code and 64-character token.
2. **Security / Admin Side**: Open **QR Pickup Verification** (`dashboard/pickup-verification.php`).
   - Click **Start Camera** (select camera if multiple are available) and point it at the claimant's QR code, **or**
   - Paste the 64-character hex token into **Manual QR Token Fallback** and click **Verify Token**.
3. The system verifies the token in a database transaction, marks `scanned_at` and `verified_by`, displays the **Verification Result** card, updates the **Pickup Queue & Recent Verifications** table, and notifies the claimant that the item has been picked up. Each QR code can only be used once.

[Insert Screenshot: QR Pickup Verification Page]

### 4.5 Search

- **Dashboard Global Search (`#global-search`)**: Available in the top header bar when viewing `dashboard/index.php`. Type at least 2 characters to search across matching found items, lost items, and claims (results are automatically filtered by your role—Admin/Security search all records, while Students/Professors search unclaimed found items and their own lost reports/claims). Click any result to jump directly to the corresponding module.
- **Module-Specific Filters**:
  - **Found Items (`dashboard/found-items.php`)**: Filter the table by status (`All statuses`, `Unclaimed`, `Pending Verification`, `Claimed`, `Disposed`).
  - **Reports (`dashboard/reports.php`)**: Filter dynamically by report type, status, `Date from`, and `Date to` via AJAX.
  - **Audit Trail (`dashboard/audit-trail.php`)**: Search by user name, email, details, or IP address, and filter by action type.

### 4.6 Reports

1. Authorized **Admin** and **Security** users click **Reports & Export** (`dashboard/reports.php`) in the sidebar.
2. Select a **Report type**:
   - **Lost Items Report**
   - **Found Items Report**
   - **Claims & Claim Status Report**
   - **Pickups & QR Verification Report**
   - **Item Inventory Summary**
   - **Security & System Audit Trail Report** *(restricted to Administrators only; hidden and blocked server-side for Security)*
3. *(Optional)* Choose a **Status filter**, **Date from**, and **Date to**. The report table updates automatically via AJAX without reloading the page.
4. Click **Reset Filters** to clear all active filters.
5. Click **Export CSV** (green button) to download a spreadsheet-safe UTF-8 CSV file, or **Export PDF** (red button) to download a formatted PDF report generated with Dompdf.

[Insert Screenshot: Reports and Export Page]

### 4.7 Logout

1. Click your profile name/avatar in the top-right corner of the header bar.
2. Click **Log out** (`#logout-btn`).
3. The system calls `database/logout.php`, records a `logout` entry in `audit_trail`, clears `$_SESSION`, destroys the PHP session, and redirects you to `auth/login.php`. Always log out when using shared campus or security-desk computers.

---

## Chapter 5 – Administrator Guide

### 5.1 User Accounts

Administrators oversee campus account activity rather than manually creating or deleting user rows in the UI:

- **Seeded & OAuth Accounts**: Local Admin/Security accounts are created during database setup or SQL administration, while Students and Faculty can sign up/sign in using `@umak.edu.ph` Google OAuth.
- **Account Security Controls**:
  - Local accounts lock automatically for 15 minutes after 5 failed password attempts.
  - Accounts with `status = 'blocked'` in the `users` table are prevented from signing in (both local and Google OAuth) and trigger an admin alert.
- **Personal Account Settings (`dashboard/settings.php`)**: Administrators can update their own password (enforcing >=8 characters, uppercase, lowercase, number, and special character) and manage their own TOTP authenticator secret.

### 5.2 Roles and Permissions

Access control is enforced server-side in `dashboard/rbac.php`, `database/db.php` (`require_role`, `require_role_page`), and `database/pusher_auth.php`. **Admin and Security do not have identical access**:

| Module / Capability | Admin | Security | Professor | Student |
|---|:---:|:---:|:---:|:---:|
| **Dashboard (`index.php`)** | Full Stats & Widgets | Full Stats & Widgets | Client Stats & Widgets | Client Stats & Widgets |
| **Integrations Status Card (Dashboard)** | Yes | No | No | No |
| **Found Items (`found-items.php`)** | Yes | Yes | No | No |
| **Lost Items – Submit Report (`lost-items.php`)** | Yes | Yes | Yes | Yes |
| **Lost Items – All Active Reports & Status Update** | Yes | Yes | No | No |
| **My Reports (`my-reports.php`)** | No | No | No | Yes |
| **Claims – Browse Unclaimed & File Claim (`claims.php`)** | No | No | Yes | Yes |
| **Claims – Approve / Reject / Flag (`claims.php`)** | Yes | Yes | No | No |
| **Pending Verifications (`pending-verifications.php`)** | Yes | Yes | No | No |
| **QR Pickup Verification (`pickup-verification.php`)** | Yes | Yes | No | No |
| **Reports & Export (Lost, Found, Claims, Pickups, Inventory)** | Yes | Yes | No | No |
| **Reports & Export – Audit Trail Report** | **Yes** | **No** | No | No |
| **Audit Trail Module (`audit-trail.php`)** | **Yes** | **No** | No | No |
| **Settings (`settings.php`)** | Yes | Yes | Yes | Yes |
| **Pusher `private-staff` Channel** | Yes | Yes | No | No |

### 5.3 System Configuration

Retrieva separates user-level settings from server/developer configuration:

- **User-Accessible Settings (`dashboard/settings.php`)**: Password updates, TOTP authenticator setup/disable, and personal activity history.
- **Server / Developer Configuration Files** (edited directly on the server by an Administrator/Developer):
  - `database/db.php`: MySQL/MariaDB PDO connection (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`), session cookie parameters, CSRF helpers, and RBAC guards.
  - `database/oauth_config.php`: Google OAuth 2.0 Client ID, Client Secret, redirect URI, and `ALLOWED_EMAIL_DOMAIN`.
  - `database/mailer.php`: PHPMailer SMTP credentials and `MAIL_DEV_MODE` toggle.
  - `dashboard/_bootstrap.php`, `database/notify_helper.php`, `dashboard/dashboard.js`: Pusher App ID, Key, Secret, and Cluster (`eu`).
  - `database/recaptcha_config.php`: Google reCAPTCHA v2 Site Key and Secret Key (excluded from Git via `.gitignore`).

### 5.4 Audit Logs

The **Audit Trail** module (`dashboard/audit-trail.php`) is restricted exclusively to the `admin` role (`require_role_page(['admin'])`).

- **Recorded Events**:
  - Authentication: `login_password_ok`, `login_success`, `login_failed`, `login_blocked`, `account_locked`, `google_signup`, `google_login`, `logout`, `password_changed`, `password_set`.
  - Transactions: `found_item_logged`, `found_item_status_changed`, `found_item_deleted`, `lost_item_reported`, `lost_item_status_changed`, `lost_item_deleted`, `claim_filed`, `claim_approved`, `claim_rejected`, `claim_manual_review`, `pickup_verified`, `report_exported`.
- **Viewing & Filtering**:
  1. Click **Audit Trail** in the sidebar.
  2. Search by user name, email, details, or IP address, or filter by a specific **Action** from the dropdown.
  3. Browse paginated results (25 events per page) showing timestamp, user/role, color-coded action badge, details, and IP address.
- **Importance**: Regular monitoring helps Administrators detect brute-force login attempts, verify staff claim approvals and QR pickups, and audit exported reports.

[Insert Screenshot: Admin Audit Trail Page]

### 5.5 Backup

Perform regular backups of both the database and application files:

1. **Database Backup via phpMyAdmin**:
   - Open `http://localhost/phpmyadmin/` and select your Retrieva database (e.g., `retrieva_db`).
   - Click the **Export** tab at the top.
   - Select **Quick** (or **Custom** to verify all tables are selected and **Structure and data** is enabled), keep format as **SQL**, and click **Export**.
   - Save the `.sql` file with a clear date stamp (e.g., `retrieva_backup_YYYYMMDD.sql`) in a secure location outside `htdocs`.
2. **Application Files & Media Backup**:
   - Copy the entire `C:\xampp\htdocs\Retrieva` folder (or back up `assets/`, `database/`, `dashboard/`, `auth/`, `composer.json`, and `composer.lock`) to secure external or cloud storage.
   - Ensure private configuration files (`database/recaptcha_config.php`, `database/oauth_config.php`, `database/mailer.php`) are stored securely and **never** uploaded to public repositories.

### 5.6 Restore

Follow these steps carefully when restoring a backup:

1. **Database Restore via phpMyAdmin**:
   - Open `http://localhost/phpmyadmin/`.
   - **Precaution:** Verify the target database name matches `DB_NAME` in `database/db.php`, and back up any current data before overwriting.
   - Create a fresh empty database (with `utf8mb4_unicode_ci`) or drop old tables in the target database so existing tables do not conflict with `CREATE TABLE` statements.
   - Select the target database, open the **Import** tab, choose your `.sql` backup file, and click **Import**.
   - Confirm schema compatibility (including `notifications` and `other_category` columns if restoring into a newer codebase).
2. **Application Files Restore**:
   - Restore the backed-up `Retrieva` folder into `C:\xampp\htdocs\Retrieva`.
   - If `vendor/` was not included in the backup, run `composer install` inside `C:\xampp\htdocs\Retrieva`.
   - Verify `database/db.php` and `database/recaptcha_config.php` are present and properly configured, then test sign-in at `http://localhost/Retrieva/auth/login.php`.
