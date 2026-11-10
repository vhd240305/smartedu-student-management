<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Teacher,model.Account"%>

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
<title>Trang chủ giảng viên — QLSV</title>
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
			<a href="<%=request.getContextPath()%>/teacher/home" class="active">
				<i class="fas fa-home me-1"></i>Trang chủ
			</a> <a href="<%=request.getContextPath()%>/teacher/classes"> <i
				class="fas fa-school me-1"></i>Lớp giảng dạy <a
				href="<%=request.getContextPath()%>/teacher/schedule"> <i
					class="fas fa-calendar-week me-1"></i>Thời khóa biểu
			</a>
			</a> <a href="<%=request.getContextPath()%>/teacher/scores"> <i
				class="fas fa-star me-1"></i>Quản lý điểm
			</a><a href="<%=request.getContextPath()%>/teacher/profile"> <i
				class="fas fa-user-edit me-1"></i>Hồ sơ
			</a> <a href="<%=request.getContextPath()%>/teacher/change-password">
				<i class="fas fa-key me-1"></i>Đổi mật khẩu
			</a>
		</div>

		<div class="app-card">
			<h3 class="mb-4">
				<i class="fas fa-id-card me-2"></i>Thông tin cá nhân
			</h3>

			<table class="table table-bordered info-table">
				<tbody>
					<tr>
						<th><i class="fas fa-id-badge me-2"></i>Mã giảng viên</th>
						<td><%=("GV000" + t.getId())%></td>
					</tr>
					<tr>
						<th><i class="fas fa-user me-2"></i>Họ tên</th>
						<td><%=t.getName()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-envelope me-2"></i>Email</th>
						<td><%=t.getEmail()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-phone me-2"></i>Số điện thoại</th>
						<td><%=t.getPhone()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-building me-2"></i>Bộ môn/Khoa</th>
						<td><%=t.getDepartment()%></td>
					</tr>
				</tbody>
			</table>

			<div class="app-actions">
				<a href="<%=request.getContextPath()%>/teacher/classes"
					class="btn btn-primary"> <i class="fas fa-school me-2"></i>Lớp
					giảng dạy
				</a> <a href="<%=request.getContextPath()%>/teacher/scores"
					class="btn btn-success"> <i class="fas fa-star me-2"></i>Quản
					lý điểm
				</a><a href="<%=request.getContextPath()%>/teacher/profile"
					class="btn btn-warning"> <i class="fas fa-user-edit me-2"></i>Chỉnh
					sửa hồ sơ
				</a> <a href="<%=request.getContextPath()%>/teacher/change-password"
					class="btn btn-secondary"> <i class="fas fa-key me-2"></i>Đổi
					mật khẩu
				</a>
			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
	</script>
	<%
	String successMsg = (String) session.getAttribute("successMsg");
	if (successMsg != null) {
		session.removeAttribute("successMsg");
		String safeMsg = successMsg.replace("'", "\\'");
	%>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<style>
.swal2-container * {
	font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		sans-serif !important;
}
</style>
	<script>
    Swal.fire({
        position: 'top',
        icon: 'success',
        title: '<%=safeMsg%>
		',
			showConfirmButton : false,
			timer : 4000,
			timerProgressBar : true,
			toast : true
		});
	</script>
	<%
	}
	%>
</body>
</html>