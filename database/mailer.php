<?php
declare(strict_types=1);

/**
 * Email API integration point.
 *
 * Swap the body of send_totp_email() for a real provider (PHPMailer +
 * SMTP, SendGrid, Mailgun, etc. — see README "Wiring the API integrations").
 * DEV_MODE writes the code to error_log so you can test the whole login
 * flow on localhost without configuring real SMTP credentials yet.
 */

const MAIL_DEV_MODE = true; // set to false once a real provider is wired in

function send_totp_email(string $toEmail, string $code): void {
    if (MAIL_DEV_MODE) {
        error_log("[Retrieva DEV MODE] TOTP code for {$toEmail}: {$code}");
        return;
    }

    // Example using PHPMailer (composer require phpmailer/phpmailer):
    //
    // $mail = new PHPMailer\PHPMailer\PHPMailer(true);
    // $mail->isSMTP();
    // $mail->Host       = 'smtp.yourprovider.com';
    // $mail->SMTPAuth   = true;
    // $mail->Username   = 'YOUR_SMTP_USER';
    // $mail->Password   = 'YOUR_SMTP_PASSWORD';
    // $mail->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
    // $mail->Port       = 587;
    // $mail->setFrom('security@umak.edu.ph', 'Retrieva Security Desk');
    // $mail->addAddress($toEmail);
    // $mail->Subject = 'Your Retrieva verification code';
    // $mail->Body    = "Your 6-digit code is: {$code} (expires in 5 minutes)";
    // $mail->send();
}
