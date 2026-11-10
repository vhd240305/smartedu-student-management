<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hệ thống Quản lý Sinh viên</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		sans-serif;
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #0f172a;
	overflow: hidden;
	-webkit-font-smoothing: antialiased;
}

/* ===== ANIMATED BACKGROUND ===== */
.bg-animation {
	position: fixed;
	inset: 0;
	z-index: 0;
	/*background: linear-gradient(135deg, #0f172a 0%, #1e293b 30%, #312e81 60%, #1e1b4b 100%);*/
	background:
		url('<%= request.getContextPath() %>/uploads/anhnen.png')
		no-repeat center center;
	background-size: cover;
}

.bg-animation::before {
	content: '';
	position: absolute;
	width: 600px;
	height: 600px;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(99, 102, 241, 0.2), transparent
		70%);
	top: -150px;
	right: -100px;
	animation: floatBubble 8s ease-in-out infinite;
}

.bg-animation::after {
	content: '';
	position: absolute;
	width: 500px;
	height: 500px;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(168, 85, 247, 0.15),
		transparent 70%);
	bottom: -150px;
	left: -100px;
	animation: floatBubble 10s ease-in-out infinite reverse;
}

@
keyframes floatBubble { 0%, 100% {
	transform: translate(0, 0) scale(1);
}

33


%
{
transform


:


translate
(


30px
,
-30px


)


scale
(


1
.05


)
;


}
66


%
{
transform


:


translate
(


-20px
,
20px


)


scale
(


0
.95


)
;


}
}

/* Floating particles */
.particles {
	position: fixed;
	inset: 0;
	z-index: 1;
	pointer-events: none;
}

.particle {
	position: absolute;
	width: 4px;
	height: 4px;
	background: rgba(129, 140, 248, 0.3);
	border-radius: 50%;
	animation: rise linear infinite;
}

.particle:nth-child(1) {
	left: 10%;
	animation-duration: 12s;
	animation-delay: 0s;
	width: 3px;
	height: 3px;
}

.particle:nth-child(2) {
	left: 25%;
	animation-duration: 15s;
	animation-delay: 2s;
	width: 5px;
	height: 5px;
}

.particle:nth-child(3) {
	left: 40%;
	animation-duration: 10s;
	animation-delay: 4s;
}

.particle:nth-child(4) {
	left: 55%;
	animation-duration: 14s;
	animation-delay: 1s;
	width: 6px;
	height: 6px;
}

.particle:nth-child(5) {
	left: 70%;
	animation-duration: 11s;
	animation-delay: 3s;
	width: 3px;
	height: 3px;
}

.particle:nth-child(6) {
	left: 85%;
	animation-duration: 13s;
	animation-delay: 5s;
}

.particle:nth-child(7) {
	left: 15%;
	animation-duration: 16s;
	animation-delay: 6s;
	width: 5px;
	height: 5px;
}

.particle:nth-child(8) {
	left: 60%;
	animation-duration: 9s;
	animation-delay: 2s;
	width: 3px;
	height: 3px;
}

@
keyframes rise { 0% {
	bottom: -10px;
	opacity: 0;
}

10


%
{
opacity


:


0
.6
;


}
90


%
{
opacity


:


0
.2
;


}
100


%
{
bottom


:


110vh
;


opacity


:


0
;


}
}

/* ===== LOGIN CONTAINER ===== */
.login-container {
	position: relative;
	z-index: 10;
	width: 100%;
	max-width: 460px;
	padding: 16px;
	animation: cardEntrance 0.7s cubic-bezier(0.16, 1, 0.3, 1);
}

@
keyframes cardEntrance {from { opacity:0;
	transform: translateY(40px) scale(0.96);
}

to {
	opacity: 1;
	transform: translateY(0) scale(1);
}

}

/* ===== LOGIN CARD ===== */
.login-card {
	background: #003044;
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 24px;
	padding: 44px 40px 40px;
	box-shadow: 0 24px 80px rgba(0, 0, 0, 0.4), 0 0 0 1px
		rgba(255, 255, 255, 0.05) inset;
}

/* ===== LOGO ICON ===== */
.login-logo {
	width: 72px;
	height: 72px;
	border-radius: 20px;
	background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #a78bfa 100%);
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 20px;
	font-size: 32px;
	color: #fff;
	box-shadow: 0 8px 32px rgba(99, 102, 241, 0.4), 0 0 0 4px
		rgba(99, 102, 241, 0.1);
	animation: logoPulse 3s ease-in-out infinite;
}

@
keyframes logoPulse { 0%, 100% {
	box-shadow: 0 8px 32px rgba(99, 102, 241, 0.4), 0 0 0 4px
		rgba(99, 102, 241, 0.1);
}

50


%
{
box-shadow


:


0


8px


40px


rgba
(


99
,
102
,
241
,
0
.55


)
,
0


0


0


8px


rgba
(


99
,
102
,
241
,
0
.08


)
;


}
}
.login-title {
	text-align: center;
	font-size: 24px;
	font-weight: 700;
	color: #fff;
	margin-bottom: 6px;
	letter-spacing: -0.5px;
}

.login-subtitle {
	text-align: center;
	font-size: 14px;
	color: #94a3b8;
	margin-bottom: 32px;
	font-weight: 400;
}

/* ===== FORM ===== */
.form-group {
	margin-bottom: 20px;
	position: relative;
}

.form-group label {
	display: block;
	font-size: 13px;
	font-weight: 600;
	color: #cbd5e1;
	margin-bottom: 8px;
	letter-spacing: 0.2px;
}

.form-group label i {
	margin-right: 6px;
	color: #818cf8;
	font-size: 14px;
}

.input-wrapper {
	position: relative;
}

.input-wrapper input {
	width: 100%;
	padding: 14px 18px;
	padding-right: 48px;
	background: rgba(255, 255, 255, 0.06);
	border: 1.5px solid rgba(255, 255, 255, 0.1);
	border-radius: 12px;
	color: #f1f5f9;
	font-size: 15px;
	font-family: 'Inter', sans-serif;
	font-weight: 500;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	outline: none;
}

.input-wrapper input::placeholder {
	color: #64748b;
	font-weight: 400;
}

.input-wrapper input:focus {
	border-color: #6366f1;
	background: rgba(99, 102, 241, 0.06);
	box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
}

.input-wrapper .input-icon {
	position: absolute;
	right: 16px;
	top: 50%;
	transform: translateY(-50%);
	color: #475569;
	font-size: 16px;
	pointer-events: none;
	transition: color 0.3s;
}

.input-wrapper input:focus ~ .input-icon {
	color: #818cf8;
}

/* Toggle password */
.toggle-password {
	position: absolute;
	right: 16px;
	top: 50%;
	transform: translateY(-50%);
	color: #475569;
	font-size: 16px;
	cursor: pointer;
	background: none;
	border: none;
	padding: 4px;
	transition: color 0.3s;
	z-index: 2;
}

.toggle-password:hover {
	color: #818cf8;
}

/* ===== ERROR ALERT ===== */
.login-error {
	background: rgba(239, 68, 68, 0.1);
	border: 1px solid rgba(239, 68, 68, 0.25);
	border-radius: 12px;
	padding: 12px 16px;
	margin-bottom: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
	animation: shakeError 0.4s ease-in-out;
}

.login-error i {
	color: #f87171;
	font-size: 16px;
	flex-shrink: 0;
}

.login-error span {
	color: #fca5a5;
	font-size: 13px;
	font-weight: 500;
}

@
keyframes shakeError { 0%, 100% {
	transform: translateX(0);
}

20


%
{
transform


:


translateX
(


-6px


)
;


}
40


%
{
transform


:


translateX
(


6px


)
;


}
60


%
{
transform


:


translateX
(


-4px


)
;


}
80


%
{
transform


:


translateX
(


4px


)
;


}
}

/* ===== LOGIN BUTTON ===== */
.btn-login {
	width: 100%;
	padding: 15px 24px;
	border: none;
	border-radius: 12px;
	background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
	color: #fff;
	font-family: 'Inter', sans-serif;
	font-size: 15px;
	font-weight: 600;
	letter-spacing: 0.3px;
	cursor: pointer;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	position: relative;
	overflow: hidden;
	margin-top: 8px;
}

.btn-login::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, #818cf8 0%, #a78bfa 100%);
	opacity: 0;
	transition: opacity 0.3s;
}

.btn-login:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 32px rgba(99, 102, 241, 0.45);
}

.btn-login:hover::before {
	opacity: 1;
}

.btn-login:active {
	transform: translateY(0);
}

.btn-login span {
	position: relative;
	z-index: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
}

/* ===== FOOTER ===== */
.login-footer {
	text-align: center;
	margin-top: 28px;
	padding-top: 20px;
	border-top: 1px solid rgba(255, 255, 255, 0.06);
}

.login-footer p {
	color: #64748b;
	font-size: 12px;
	font-weight: 500;
}

.login-footer .app-name {
	color: #818cf8;
	font-weight: 600;
}

/* ===== RESPONSIVE ===== */
@media ( max-width : 480px) {
	.login-card {
		padding: 32px 24px 28px;
		border-radius: 20px;
	}
	.login-title {
		font-size: 20px;
	}
	.login-logo {
		width: 60px;
		height: 60px;
		font-size: 26px;
		border-radius: 16px;
	}
}
</style>
</head>
<body>

	<!-- Animated background -->
	<div class="bg-animation"></div>
	<div class="particles">
		<div class="particle"></div>
		<div class="particle"></div>
		<div class="particle"></div>
		<div class="particle"></div>
		<div class="particle"></div>
		<div class="particle"></div>
		<div class="particle"></div>
		<div class="particle"></div>
	</div>

	<!-- Login Card -->
	<div class="login-container">
		<div class="login-card">
			<!-- Logo -->
			<div class="login-logo">
				<i class="fas fa-graduation-cap"></i>
			</div>
			<h1 class="login-title">Đăng nhập hệ thống</h1>
			<p class="login-subtitle">Hệ thống Quản lý Sinh viên SmartEdu</p>
			<!-- Error message -->
			<%
			String error = request.getParameter("error");
			if (error != null) {
			%>
			<div class="login-error">
				<i class="fas fa-exclamation-triangle"></i> <span>Tên đăng
					nhập hoặc mật khẩu không đúng</span>
			</div>
			<%
			}
			%>
			<!-- Login Form -->
			<form action="${pageContext.request.contextPath}/login1"
				method="post" autocomplete="on">
				<div class="form-group">
					<label for="username"> <!-- <i class="fas fa-user"></i>Tên đăng nhập -->
					</label>
					<div class="input-wrapper">
						<input type="text" id="username" name="username"
							placeholder="Tên đăng nhập" required autofocus
							autocomplete="username"> <i
							class="fas fa-user input-icon"></i>
					</div>
				</div>

				<div class="form-group">
					<label for="password"> <!-- <i class="fas fa-lock"></i>Mật khẩu -->
					</label>
					<div class="input-wrapper">
						<input type="password" id="password" name="password"
							placeholder="Mật khẩu" required autocomplete="current-password">
						<button type="button" class="toggle-password"
							onclick="togglePassword()" title="Hiện/Ẩn mật khẩu">
							<i class="fas fa-eye" id="toggleIcon"></i>
						</button>
					</div>
				</div>

				<button type="submit" class="btn-login">
					<span> <i class="fas fa-sign-in-alt"></i> Đăng nhập
					</span>
				</button>
				<div class="text-center mt-3">
					<a href="${pageContext.request.contextPath}/forgot-password"
						style="color: #818cf8; font-size: 13px; text-decoration: none; font-weight: 500;">
						<i class="fas fa-key me-1"></i>Quên mật khẩu?
					</a>
				</div>
			</form>
		</div>
	</div>

	<script>
		function togglePassword() {
			const input = document.getElementById('password');
			const icon = document.getElementById('toggleIcon');
			if (input.type === 'password') {
				input.type = 'text';
				icon.classList.remove('fa-eye');
				icon.classList.add('fa-eye-slash');
			} else {
				input.type = 'password';
				icon.classList.remove('fa-eye-slash');
				icon.classList.add('fa-eye');
			}
		}

		// Auto-focus animation
		document
				.getElementById('username')
				.addEventListener(
						'focus',
						function() {
							this.parentElement.parentElement.style.transform = 'scale(1.01)';
							this.parentElement.parentElement.style.transition = 'transform 0.2s';
						});

		document
				.getElementById('username')
				.addEventListener(
						'blur',
						function() {
							this.parentElement.parentElement.style.transform = 'scale(1)';
						});

		document
				.getElementById('password')
				.addEventListener(
						'focus',
						function() {
							this.parentElement.parentElement.style.transform = 'scale(1.01)';
							this.parentElement.parentElement.style.transition = 'transform 0.2s';
						});

		document
				.getElementById('password')
				.addEventListener(
						'blur',
						function() {
							this.parentElement.parentElement.style.transform = 'scale(1)';
						});
	</script>

</body>
</html>
