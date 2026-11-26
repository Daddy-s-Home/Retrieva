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

        // Sender and Recipient — Custom Sender Name applied here
        $mail->setFrom('jangeles.a12345431@umak.edu.ph', 'Retrieva Security Gateway');
        $mail->addAddress($toEmail);

        // Formatted 6-digit display
        $verify_url = 'http://localhost/Retrieva/auth/totp.php?code=' . urlencode($code);

        // Content Configuration
        $mail->isHTML(true);
        $mail->Subject = "{$code} is your Retrieva Security Code";
        $mail->AltBody = "Your Retrieva verification code is: {$code}. It expires in 5 minutes. Verify directly at: {$verify_url}";
        
        $mail->Body = "
        <!DOCTYPE html>
        <html lang='en'>
        <head>
          <meta charset='UTF-8'>
          <meta name='viewport' content='width=device-width, initial-scale=1.0'>
          <title>Retrieva Security Code</title>
        </head>
        <body style='margin: 0; padding: 0; background-color: #FAFBFD; font-family: \"Inter\", \"Segoe UI\", system-ui, -apple-system, sans-serif; color: #1F2A3D;'>
          <table border='0' cellpadding='0' cellspacing='0' width='100%' style='min-width: 100%; background-color: #FAFBFD; padding: 36px 12px;'>
            <tr>
              <td align='center'>
                <table border='0' cellpadding='0' cellspacing='0' width='100%' style='max-width: 520px; background-color: #FEFEFE; border-radius: 20px; overflow: hidden; box-shadow: 0 12px 32px rgba(0, 50, 118, 0.14); border: 1px solid #E6E9F0;'>
                  <tr>
                    <td style='background: linear-gradient(160deg, #002554, #003276); padding: 30px 32px 26px; text-align: center;'>
                      <span style='display: inline-block; background-color: rgba(254, 254, 254, 0.12); padding: 5px 14px; border-radius: 999px; color: #FEEFC4; font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; margin-bottom: 12px;'>
                        RETRIEVA VERIFICATION
                      </span>
                      <h1 style='margin: 0; color: #FEFEFE; font-size: 24px; font-weight: 800; letter-spacing: -0.02em;'>
                        RETRIEVA
                      </h1>
                      <p style='margin: 4px 0 0; color: #FEEFC4; font-size: 12px; font-weight: 600; letter-spacing: 0.05em; text-transform: uppercase; opacity: 0.9;'>
                        University of Makati Lost &amp; Found System
                      </p>
                    </td>
                  </tr>

                  <tr>
                    <td style='padding: 34px 32px 30px; text-align: center;'>
                      <h2 style='margin: 0 0 8px; color: #1F2A3D; font-size: 20px; font-weight: 700;'>
                        Verify Your Identity
                      </h2>
                      <p style='margin: 0 0 24px; color: #6B7686; font-size: 14px; line-height: 1.5;'>
                        Tap the code box below to select &amp; copy your code, or click the button to open Two-Factor Security with the code pre-filled.
                      </p>

                      <div style='background-color: #FAFBFD; border: 1.5px dashed #CFD6E4; border-radius: 14px; padding: 20px 16px; margin-bottom: 22px;'>
                        <span style='display: block; font-size: 11px; font-weight: 700; color: #6B7686; text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 8px;'>
                          One-Time Security Code
                        </span>
                        <div style='font-family: \"Courier New\", Courier, monospace; font-size: 34px; font-weight: 800; color: #003276; letter-spacing: 6px; user-select: all; -webkit-user-select: all; cursor: pointer;'>{$code}</div>
                      </div>

                      <div style='margin-bottom: 24px;'>
                        <a href='{$verify_url}' style='display: inline-block; background-color: #F5A623; color: #1F2A3D; text-decoration: none; font-size: 14px; font-weight: 700; padding: 13px 28px; border-radius: 8px;'>
                          Open Two-Factor Security
                        </a>
                      </div>

                      <table border='0' cellpadding='0' cellspacing='0' width='100%' style='background-color: #FDEAEA; border: 1px solid #F5C2C7; border-radius: 8px; margin-bottom: 20px;'>
                        <tr>
                          <td style='padding: 12px 16px; text-align: left;'>
                            <p style='margin: 0; color: #9F1F2C; font-size: 13px; line-height: 1.4; font-weight: 500;'>
                              <strong>Notice:</strong> This code expires in <strong>5 minutes</strong>. If you did not request this verification, please secure your account immediately.
                            </p>
                          </td>
                        </tr>
                      </table>

                      <p style='margin: 0; color: #6B7686; font-size: 12px;'>
                        Never share this code with anyone, including UMak staff and employees.
                      </p>
                    </td>
                  </tr>

                  <tr>
                    <td style='background-color: #FAFBFD; padding: 18px 32px; text-align: center; border-top: 1px solid #E6E9F0;'>
                      <p style='margin: 0 0 4px; color: #64748b; font-size: 12px; font-weight: 600;'>
                        Retrieva Lost & Found System
                      </p>
                      <p style='margin: 0; color: #94a3b8; font-size: 11px;'>
                        University of Makati &bull; Official Automated Notification
                      </p>
                    </td>
                  </tr>

                </table>
                </td>
            </tr>
          </table>
        </body>
        </html>
        ";

        $mail->send();
    } catch (Exception $e) {
        error_log("SMTP Error: " . $mail->ErrorInfo);
        throw $e;
    }
}