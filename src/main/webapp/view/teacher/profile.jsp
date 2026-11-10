<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Teacher, model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");
if (acc == null || !"teacher".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}
Teacher t = (Teacher) request.getAttribute("teacher");

if (t == null) {
%>
<h3>Không tìm thấy dữ liệu giảng viên</h3>
<%
return;
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Chỉnh sửa hồ sơ — QLSV</title>
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
				<i class="fas fa-chalkboard-teacher"></i> Cổng giảng viên
			</h3>
			<div class="d-flex align-items-center gap-3">
				<span class="user-greeting">Xin chào, <strong><%=t.getName()%></strong></span>
				<a href="<%=request.getContextPath()%>/logout"
					class="btn btn-danger btn-sm"> <i
					class="fas fa-sign-out-alt me-1"></i>Đăng xuất
				</a>
			</div>
		</div>

		<div class="nav-pills-modern">
			<a href="<%=request.getContextPath()%>/teacher/home"> <i
				class="fas fa-home me-1"></i>Trang chủ
			</a> <a href="<%=request.getContextPath()%>/teacher/classes"> <i
				class="fas fa-school me-1"></i>Lớp giảng dạy
			</a> <a href="<%=request.getContextPath()%>/teacher/schedule"> <i
				class="fas fa-calendar-week me-1"></i>Thời khóa biểu
			</a><a href="<%=request.getContextPath()%>/teacher/scores"> <i
				class="fas fa-star me-1"></i>Quản lý điểm
			</a><a href="<%=request.getContextPath()%>/teacher/profile"
				class="active"> <i class="fas fa-user-edit me-1"></i>Hồ sơ
			</a> <a href="<%=request.getContextPath()%>/teacher/change-password">
				<i class="fas fa-key me-1"></i>Đổi mật khẩu
			</a>
		</div>

		<div class="app-card">
			<h3 class="mb-4">
				<i class="fas fa-user-edit me-2"></i>Chỉnh sửa hồ sơ
			</h3>

			<%
			if (request.getAttribute("msg") != null) {
			%>
			<div class="alert alert-success">
				<i class="fas fa-check-circle me-2"></i><%=request.getAttribute("msg")%>
			</div>
			<%
			}
			%>

			<%
			if (request.getAttribute("error") != null) {
			%>
			<div class="alert alert-danger">
				<i class="fas fa-exclamation-circle me-2"></i><%=request.getAttribute("error")%>
			</div>
			<%
			}
			%>

			<form action="<%=request.getContextPath()%>/teacher/profile"
				method="post">
				<input type="hidden" name="id" value="<%=t.getId()%>">

				<div class="row">
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-user me-2"></i>Họ
								tên</label> <input name="name" value="<%=t.getName()%>"
								class="form-control" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
							<input name="email" value="<%=t.getEmail()%>"
								class="form-control" type="email" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-phone me-2"></i>Số
								điện thoại</label> <input name="phone" value="<%=t.getPhone()%>"
								class="form-control" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-building me-2"></i>Bộ
								môn/Khoa</label> <input name="department" value="<%=t.getDepartment()%>"
								class="form-control" required>
						</div>
					</div>
				</div>

				<div class="app-actions">
					<button class="btn btn-primary">
						<i class="fas fa-save me-2"></i>Cập nhật hồ sơ
					</button>
					<a href="<%=request.getContextPath()%>/teacher/home"
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