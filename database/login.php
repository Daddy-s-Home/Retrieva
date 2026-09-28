<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/totp_helper.php';
require_once __DIR__ . '/mailer.php';

start_session();
header('Content-Type: application/json');

$input    = json_decode(file_get_contents('php://input'), true) ?? [];
$email    = trim((string)($input['email'] ?? ''));
$password = (string)($input['password'] ?? '');

if ($email === '' || $password === '') {
    json_out(['success' => false, 'message' => 'Email and password are required.'], 400);
}

$db = get_db();
$stmt = $db->prepare('SELECT * FROM users WHERE email = ?');
$stmt->execute([$email]);
$user = $stmt->fetch();

$invalidMsg = 'Incorrect email or password.';

if (!$user) {
    // #region agent log
    file_put_contents('C:/xampp/htdocs/debug-5b3ba5.log', json_encode(['sessionId'=>'5b3ba5','hypothesisId'=>'E','location'=>'login.php:user','message'=>'account lookup','data'=>['found'=>false,'passwordLength'=>strlen($password)],'timestamp'=>(int) round(microtime(true)*1000)])."\n", FILE_APPEND);
    // #endregion
    log_audit(null, 'login_failed', "Unknown account login attempt for email: {$email}");
    json_out(['success' => false, 'message' => $invalidMsg], 401);
}

// 1. Admin manual block check
if ($user['status'] === 'blocked') {
    log_audit((int)$user['id'], 'login_blocked', 'Blocked user login attempt');
    json_out(['success' => false, 'message' => 'This account has been blocked. Contact the security office.'], 403);
}

// 2. Active lockout check
if (!empty($user['lockout_until'])) {
    $lockoutTime = strtotime($user['lockout_until']);
    $currentTime = time();

    if ($currentTime < $lockoutTime) {
        $remainingSeconds = $lockoutTime - $currentTime;
        log_audit((int)$user['id'], 'login_lockout_rejected', "Attempt while account locked ({$remainingSeconds}s remaining)");
        
        json_out([
            'success'           => false,
            'locked'            => true,
            'remaining_seconds' => $remainingSeconds,
            'message'           => 'Too many failed login attempts. Your account is temporarily locked.'
        ], 429);
    } else {
        // Lockout period has elapsed; reset counters
        $db->prepare('UPDATE users SET failed_attempts = 0, lockout_until = NULL WHERE id = ?')
           ->execute([$user['id']]);
        $user['failed_attempts'] = 0;
    }
}

// 3. Password verification
$passwordOk = $user['auth_provider'] === 'local' && !empty($user['password_hash']) && password_verify($password, $user['password_hash']);
// #region agent log
file_put_contents('C:/xampp/htdocs/debug-5b3ba5.log', json_encode(['sessionId'=>'5b3ba5','hypothesisId'=>'B','location'=>'login.php:password','message'=>'password check','data'=>['found'=>true,'id'=>(int)$user['id'],'idEmpty'=>empty($user['id']),'passwordOk'=>$passwordOk,'passwordLength'=>strlen($password),'factor'=>($user['login_method'] ?? 'email')],'timestamp'=>(int) round(microtime(true)*1000)])."\n", FILE_APPEND);
// #endregion
if (!$passwordOk) {
    $failedAttempts = ((int)($user['failed_attempts'] ?? 0)) + 1;
    
    if ($failedAttempts >= 5) {
        // 5 failures reach limit -> lock for 15 minutes (900s)
        $lockoutUntil = date('Y-m-d H:i:s', strtotime('+15 minutes'));
        $db->prepare('UPDATE users SET failed_attempts = ?, lockout_until = ? WHERE id = ?')
           ->execute([$failedAttempts, $lockoutUntil, $user['id']]);
        
        log_audit((int)$user['id'], 'account_locked', 'Account locked for 15 minutes due to 5 consecutive failed login attempts.');
        
        json_out([
            'success'           => false,
            'locked'            => true,
            'remaining_seconds' => 900,
            'message'           => 'Too many failed attempts. Account locked for 15 minutes.'
        ], 429);
    } else {
        $db->prepare('UPDATE users SET failed_attempts = ? WHERE id = ?')
           ->execute([$failedAttempts, $user['id']]);
        
        $remainingTries = 5 - $failedAttempts;
        log_audit((int)$user['id'], 'login_failed', "Invalid password attempt ({$failedAttempts}/5)");
        
        json_out([
            'success' => false,
            'message' => "{$invalidMsg} ({$remainingTries} attempt" . ($remainingTries > 1 ? 's' : '') . " remaining)"
        ], 401);
    }
}

// 4. Successful password check. Email codes live only in totp_challenges so an
// authenticator secret already stored on the account is left in place.
$db->prepare('UPDATE users SET failed_attempts = 0, lockout_until = NULL WHERE id = ?')
   ->execute([$user['id']]);

$useAuthenticator = ($user['login_method'] ?? 'email') === 'totp' && (int) $user['totp_enabled'] === 1;
$_SESSION['pending_totp_user_id'] = $user['id'];
$_SESSION['pending_login_factor'] = $useAuthenticator ? 'totp' : 'email';
$_SESSION['pending_login_can_switch'] = (int) $user['totp_enabled'] === 1;

if ($useAuthenticator) {
    log_audit((int)$user['id'], 'login_password_ok', 'Password verified, authenticator code requested.');
    json_out(['success' => true, 'factor' => 'totp', 'message' => 'Enter the 6-digit code from your authenticator app.']);
}

$secret = totp_generate_secret();
$code   = totp_code($secret);
$db->prepare(
    'INSERT INTO totp_challenges (user_id, code_hash, purpose, expires_at) VALUES (?, ?, "login", DATE_ADD(NOW(), INTERVAL 5 MINUTE))'
)->execute([$user['id'], password_hash($code, PASSWORD_BCRYPT)]);

try {
    send_totp_email($user['email'], $code);
} catch (Throwable $e) {
    error_log("Failed to dispatch TOTP email: " . $e->getMessage());
}

log_audit((int)$user['id'], 'login_password_ok', 'Password verified, email code sent.');

json_out(['success' => true, 'factor' => 'email', 'message' => 'Enter the 6-digit code sent to your email.']);