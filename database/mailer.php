<?php
declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

const MAIL_DEV_MODE = false; // Set to false for real SMTP delivery

function send_totp_email(string $toEmail, string $code): void {
    if (MAIL_DEV_MODE) {
        error_log("[Retrieva DEV MODE] TOTP code for {$toEmail}: {$code}");
        return;
    }

    $mail = new PHPMailer(true);

    try {
        // Google SMTP Configuration (Port 465 SSL)
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'jangeles.a12345431@umak.edu.ph'; 
        $mail->Password   = 'nmwldcmiulyfdqjk'; // Google App Password
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
        $mail->Port       = 465;

        // Bypass local XAMPP OpenSSL certificate path issues
        $mail->SMTPOptions = [
            'ssl' => [
                'verify_peer'       => false,
                'verify_peer_name'  => false,
                'allow_self_signed' => true
            ]
        ];

        // Sender and Recipient
        $mail->setFrom('jangeles.a12345431@umak.edu.ph', 'Retrieva Security Desk');
        $mail->addAddress($toEmail);

        // Content
        $mail->isHTML(true);
        $mail->Subject = 'Your Retrieva Security Verification Code';
        $mail->Body    = "
            <div style='font-family: Arial, sans-serif; padding: 20px;'>
                <h2>Retrieva Security Gateway</h2>
                <p>Your 6-digit verification code is:</p>
                <h1 style='letter-spacing: 4px; color: #1a56db;'>{$code}</h1>
                <p>This code expires in 5 minutes. Do not share this code with anyone.</p>
            </div>
        ";

        $mail->send();
    } catch (Exception $e) {
        error_log("SMTP Error: " . $mail->ErrorInfo);
        throw $e; // Rethrow so forgot_password.php can log the exact failure
    }
}