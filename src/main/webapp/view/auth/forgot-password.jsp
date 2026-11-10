<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quên mật khẩu — QLSV</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #0f172a;
    overflow: hidden;
    -webkit-font-smoothing: antialiased;
}

.bg-animation {
    position: fixed;
    inset: 0;
    z-index: 0;
    background: url('<%= request.getContextPath() %>/uploads/anhnen.png') no-repeat center center;
    background-size: cover;
}

.bg-animation::before {
    content: '';
    position: absolute;
    width: 600px; height: 600px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(99,102,241,0.2), transparent 70%);
    top: -150px; right: -100px;
    animation: floatBubble 8s ease-in-out infinite;
}

.bg-animation::after {
    content: '';
    position: absolute;
    width: 500px; height: 500px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(168,85,247,0.15), transparent 70%);
    bottom: -150px; left: -100px;
    animation: floatBubble 10s ease-in-out infinite reverse;
}

@keyframes floatBubble {
    0%, 100% { transform: translate(0,0) scale(1); }
    33% { transform: translate(30px,-30px) scale(1.05); }
    66% { transform: translate(-20px,20px) scale(0.95); }
}

.particles { position: fixed; inset: 0; z-index: 1; pointer-events: none; }
.particle {
    position: absolute; width: 4px; height: 4px;
    background: rgba(129,140,248,0.3); border-radius: 50%;
    animation: rise linear infinite;
}
.particle:nth-child(1) { left:10%; animation-duration:12s; }
.particle:nth-child(2) { left:25%; animation-duration:15s; animation-delay:2s; width:5px; height:5px; }
.particle:nth-child(3) { left:40%; animation-duration:10s; animation-delay:4s; }
.particle:nth-child(4) { left:55%; animation-duration:14s; animation-delay:1s; width:6px; height:6px; }
.particle:nth-child(5) { left:70%; animation-duration:11s; animation-delay:3s; width:3px; height:3px; }
.particle:nth-child(6) { left:85%; animation-duration:13s; animation-delay:5s; }

@keyframes rise {
    0% { bottom:-10px; opacity:0; }
    10% { opacity:0.6; }
    90% { opacity:0.2; }
    100% { bottom:110vh; opacity:0; }
}

.login-container {
    position: relative;
    z-index: 10;
    width: 100%;
    max-width: 460px;
    padding: 16px;
    animation: cardEntrance 0.7s cubic-bezier(0.16,1,0.3,1);
}

@keyframes cardEntrance {
    from { opacity:0; transform:translateY(40px) scale(0.96); }
    to { opacity:1; transform:translateY(0) scale(1); }
}

.login-card {
    background: #003044;
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 24px;
    padding: 44px 40px 40px;
    box-shadow: 0 24px 80px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.05) inset;
}

.login-logo {
    width: 72px; height: 72px;
    border-radius: 20px;
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #a78bfa 100%);
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 20px;
    font-size: 32px; color: #fff;
    box-shadow: 0 8px 32px rgba(99,102,241,0.4), 0 0 0 4px rgba(99,102,241,0.1);
    animation: logoPulse 3s ease-in-out infinite;
}

@keyframes logoPulse {
    0%,100% { box-shadow: 0 8px 32px rgba(99,102,241,0.4), 0 0 0 4px rgba(99,102,241,0.1); }
    50% { box-shadow: 0 8px 40px rgba(99,102,241,0.55), 0 0 0 8px rgba(99,102,241,0.08); }
}

.login-title {
    text-align: center; font-size: 24px; font-weight: 700;
    color: #fff; margin-bottom: 6px; letter-spacing: -0.5px;
}

.login-subtitle {
    text-align: center; font-size: 14px; color: #94a3b8;
    margin-bottom: 32px; font-weight: 400;
}

.form-group { margin-bottom: 20px; }

.form-group label {
    display: block; font-size: 13px; font-weight: 600;
    color: #cbd5e1; margin-bottom: 8px;
}

.form-group input {
    width: 100%; padding: 14px 18px;
    background: rgba(255,255,255,0.06);
    border: 1.5px solid rgba(255,255,255,0.1);
    border-radius: 12px; color: #f1f5f9;
    font-size: 15px; font-family: 'Inter', sans-serif;
    font-weight: 500; outline: none;
    transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
}

.form-group input::placeholder { color: #64748b; font-weight: 400; }

.form-group input:focus {
    border-color: #6366f1;
    background: rgba(99,102,241,0.06);
    box-shadow: 0 0 0 4px rgba(99,102,241,0.15);
}

.otp-input { letter-spacing: 8px; font-size: 24px; text-align: center; font-weight: bold; }

.btn-login {
    width: 100%; padding: 15px 24px;
    border: none; border-radius: 12px;
    background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
    color: #fff; font-family: 'Inter', sans-serif;
    font-size: 15px; font-weight: 600;
    cursor: pointer; transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
    position: relative; overflow: hidden; margin-top: 8px;
}

.btn-login::before {
    content: ''; position: absolute; inset: 0;
    background: linear-gradient(135deg, #818cf8 0%, #a78bfa 100%);
    opacity: 0; transition: opacity 0.3s;
}

.btn-login:hover { transform: translateY(-2px); box-shadow: 0 8px 32px rgba(99,102,241,0.45); }
.btn-login:hover::before { opacity: 1; }
.btn-login span { position: relative; z-index: 1; display: flex; align-items: center; justify-content: center; gap: 8px; }

.alert-error {
    background: rgba(239,68,68,0.1);
    border: 1px solid rgba(239,68,68,0.25);
    border-radius: 12px; padding: 12px 16px;
    margin-bottom: 20px;
    display: flex; align-items: center; gap: 10px;
}
.alert-error i { color: #f87171; font-size: 16px; }
.alert-error span { color: #fca5a5; font-size: 13px; font-weight: 500; }

.alert-success {
    background: rgba(34,197,94,0.1);
    border: 1px solid rgba(34,197,94,0.25);
    border-radius: 12px; padding: 12px 16px;
    margin-bottom: 20px;
    display: flex; align-items: center; gap: 10px;
}
.alert-success i { color: #4ade80; font-size: 16px; }
.alert-success span { color: #86efac; font-size: 13px; font-weight: 500; }

.back-link {
    display: block; text-align: center; margin-top: 20px;
    color: #818cf8; font-size: 13px; font-weight: 500;
    text-decoration: none;
}
.back-link:hover { color: #a78bfa; }

.success-icon { font-size: 4rem; color: #4ade80; display: block; text-align: center; }
</style>
</head>
<body>

<div class="bg-animation"></div>
<div class="particles">
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
</div>

<div class="login-container">
    <div class="login-card">
        <div class="login-logo">
            <i class="fas fa-key"></i>
        </div>

        <% String step = request.getAttribute("step") != null ? (String) request.getAttribute("step") : "email"; %>

        <% if (!"success".equals(step)) { %>
        <h1 class="login-title">Quên mật khẩu</h1>
        <p class="login-subtitle">Hệ thống Quản lý Sinh viên SmartEdu</p>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert-error">
            <i class="fas fa-exclamation-triangle"></i>
            <span><%= request.getAttribute("error") %></span>
        </div>
        <% } %>

        <% if (request.getAttribute("msg") != null) { %>
        <div class="alert-success">
            <i class="fas fa-check-circle"></i>
            <span><%= request.getAttribute("msg") %></span>
        </div>
        <% } %>

        <!-- Bước 1: Nhập email -->
        <% if ("email".equals(step)) { %>
        <form method="post" action="<%=request.getContextPath()%>/forgot-password">
            <input type="hidden" name="action" value="sendOtp">
            <div class="form-group">
                <label>Email đã đăng ký</label>
                <input type="email" name="email" placeholder="Nhập email của bạn" required autofocus>
            </div>
            <button type="submit" class="btn-login">
                <span><i class="fas fa-paper-plane"></i> Gửi mã OTP</span>
            </button>
        </form>

        <!-- Bước 2: Nhập OTP -->
        <% } else if ("otp".equals(step)) { %>
        <form method="post" action="<%=request.getContextPath()%>/forgot-password">
            <input type="hidden" name="action" value="verifyOtp">
            <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
            <div class="form-group">
                <label>Mã OTP (6 số)</label>
                <input type="text" name="otp" class="otp-input"
                       placeholder="000000" maxlength="6" required autofocus
                       autocomplete="off" inputmode="numeric">
                <div style="color:#64748b; font-size:12px; margin-top:6px;">Mã có hiệu lực trong 5 phút.</div>
            </div>
            <button type="submit" class="btn-login">
                <span><i class="fas fa-check"></i> Xác nhận mã</span>
            </button>
        </form>

        <!-- Bước 3: Đặt mật khẩu mới -->
        <% } else if ("newPassword".equals(step)) { %>
        <form method="post" action="<%=request.getContextPath()%>/forgot-password">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
            <input type="hidden" name="otp" value="<%= request.getAttribute("otp") %>">
            <div class="form-group">
                <label>Mật khẩu mới</label>
                <input type="password" name="newPassword" placeholder="Tối thiểu 6 ký tự" required minlength="6">
            </div>
            <div class="form-group">
                <label>Xác nhận mật khẩu</label>
                <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required minlength="6">
            </div>
            <button type="submit" class="btn-login">
                <span><i class="fas fa-save"></i> Đặt mật khẩu mới</span>
            </button>
        </form>

        <!-- Bước 4: Thành công -->
        <% } else if ("success".equals(step)) { %>
        <div style="text-align:center; padding: 20px 0;">
            <i class="fas fa-check-circle success-icon"></i>
            <h2 style="color:#fff; margin-top:16px; font-size:22px;">Đặt lại mật khẩu thành công!</h2>
            <p style="color:#94a3b8; font-size:14px; margin-top:8px;">Bạn có thể đăng nhập bằng mật khẩu mới.</p>
            <a href="<%=request.getContextPath()%>/view/auth/login.jsp" class="btn-login d-inline-block mt-3" style="text-decoration:none; padding: 12px 32px; width:auto;">
                <span><i class="fas fa-sign-in-alt"></i> Đăng nhập ngay</span>
            </a>
        </div>
        <% } %>

        <% if (!"success".equals(step)) { %>
        <a href="<%=request.getContextPath()%>/view/auth/login.jsp" class="back-link">
            <i class="fas fa-arrow-left me-1"></i>Quay lại đăng nhập
        </a>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>