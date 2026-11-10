<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");
if (acc == null || !"student".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đổi mật khẩu — QLSV</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="<%=request.getContextPath()%>/assets/css/app-modern.css"
	rel="stylesheet">
</head>
<body>
	<div class="app-shell">
		<div class="app-topbar">
			<h3 class="app-title">
				<i class="fas fa-user-graduate"></i> Cổng sinh viên
			</h3>
			<div class="d-flex align-items-center gap-3">
				<span class="user-greeting">Xin chào, <strong><%=acc.getUsername()%></strong></span>
				<a href="<%=request.getContextPath()%>/logout"
					class="btn btn-danger btn-sm"> <i
					class="fas fa-sign-out-alt me-1"></i>Đăng xuất
				</a>
			</div>
		</div>

		<div class="nav-pills-modern">
			<a href="<%=request.getContextPath()%>/student/home"> <i
				class="fas fa-home me-1"></i>Trang chủ
			</a> <a href="<%=request.getContextPath()%>/student/classes"> <i
				class="fas fa-school me-1"></i>Lớp học
			</a> <a href="<%=request.getContextPath()%>/student/schedule"> <i
				class="fas fa-calendar-week me-1"></i>Thời khóa biểu
			</a><a href="<%=request.getContextPath()%>/student/teachers"> <i
				class="fas fa-chalkboard-teacher me-1"></i>Giảng viên
			</a> <a href="<%=request.getContextPath()%>/student/scores"> <i
				class="fas fa-star me-1"></i>Điểm số
			</a><a href="<%=request.getContextPath()%>/student/profile"> <i
				class="fas fa-user-edit me-1"></i>Hồ sơ
			</a> <a href="<%=request.getContextPath()%>/student/change-password"
				class="active"> <i class="fas fa-key me-1"></i>Đổi mật khẩu
			</a>
		</div>

		<div class="app-card">
			<h3 class="mb-4">
				<i class="fas fa-key me-2"></i>Đổi mật khẩu
			</h3>

			<%
			if (request.getAttribute("error") != null) {
			%>
			<div class="alert alert-danger">
				<i class="fas fa-exclamation-circle me-2"></i><%=request.getAttribute("error")%>
			</div>
			<%
			}
			%>

			<%
			if (request.getAttribute("msg") != null) {
			%>
			<div class="alert alert-success">
				<i class="fas fa-check-circle me-2"></i><%=request.getAttribute("msg")%>
			</div>
			<%
			}
			%>

			<form method="post"
				action="<%=request.getContextPath()%>/student/change-password">
				<div class="row">
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-lock me-2"></i>Mật
								khẩu hiện tại</label> <input type="password" name="oldPassword"
								class="form-control" placeholder="Nhập mật khẩu hiện tại"
								required>
						</div>
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-lock me-2"></i>Mật
								khẩu mới</label> <input type="password" name="newPassword"
								class="form-control"
								placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" required
								minlength="6">
						</div>
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-lock me-2"></i>Xác
								nhận mật khẩu mới</label> <input type="password" name="confirmPassword"
								class="form-control" placeholder="Nhập lại mật khẩu mới"
								required minlength="6">
						</div>
					</div>
				</div>

				<div class="app-actions">
					<button class="btn btn-primary">
						<i class="fas fa-save me-2"></i>Đổi mật khẩu
					</button>
					<a href="<%=request.getContextPath()%>/student/home"
						class="btn btn-secondary"> <i class="fas fa-arrow-left me-2"></i>Quay
						lại
					</a>
				</div>
			</form>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>