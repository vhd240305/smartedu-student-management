<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Student, model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");
if (acc == null || !"student".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}
Student s = (Student) request.getAttribute("student");

String avatar = "default.png";
if (s.getAvatar() != null && !s.getAvatar().isEmpty()) {
	avatar = s.getAvatar();
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
				<i class="fas fa-user-graduate"></i> Cổng sinh viên
			</h3>
			<div class="d-flex align-items-center gap-3">
				<span class="user-greeting">Xin chào, <strong><%=s.getName()%></strong></span>
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
			</a><a href="<%=request.getContextPath()%>/student/profile"
				class="active"> <i class="fas fa-user-edit me-1"></i>Hồ sơ
			</a> <a href="<%=request.getContextPath()%>/student/change-password">
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

			<form action="<%=request.getContextPath()%>/student/profile"
				method="post" enctype="multipart/form-data">
				<input type="hidden" name="id" value="<%=s.getId()%>">

				<div class="text-center mb-4">
					<img src="<%=request.getContextPath()%>/uploads/<%=avatar%>"
						class="avatar-lg d-block mx-auto mb-2" alt="Ảnh đại diện">
				</div>

				<div class="row">
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-user me-2"></i>Họ
								tên</label> <input name="name" value="<%=s.getName()%>"
								class="form-control" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
							<input name="email" value="<%=s.getEmail()%>"
								class="form-control" type="email" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-phone me-2"></i>Số
								điện thoại</label> <input name="phone" value="<%=s.getPhone()%>"
								class="form-control" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i
								class="fas fa-venus-mars me-2"></i>Giới tính</label> <select
								name="gender" class="form-control">
								<option value="Male"
									<%="Male".equals(s.getGender()) ? "selected" : ""%>>Nam</option>
								<option value="Female"
									<%="Female".equals(s.getGender()) ? "selected" : ""%>>Nữ</option>
							</select>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i
								class="fas fa-calendar-alt me-2"></i>Ngày sinh</label> <input
								type="date" name="dob" value="<%=s.getDob()%>"
								class="form-control" required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i
								class="fas fa-map-marker-alt me-2"></i>Địa chỉ</label> <input
								name="address" value="<%=s.getAddress()%>" class="form-control"
								required>
						</div>
					</div>
					<div class="col-md-6">
						<div class="mb-3">
							<label class="form-label"><i class="fas fa-camera me-2"></i>Ảnh
								đại diện mới</label> <input type="file" name="avatar"
								class="form-control">
						</div>
					</div>
				</div>

				<div class="app-actions">
					<button class="btn btn-primary">
						<i class="fas fa-save me-2"></i>Cập nhật hồ sơ
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