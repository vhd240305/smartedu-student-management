<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Student,model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");

if (acc == null || !"student".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}

Student s = (Student) request.getAttribute("student");

if (s == null) {
%>
<h3>Không tìm thấy dữ liệu sinh viên</h3>
<%
return;
}

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
<title>Trang chủ sinh viên — QLSV</title>
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
			<a href="<%=request.getContextPath()%>/student/home" class="active">
				<i class="fas fa-home me-1"></i>Trang chủ
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
			</a> <a href="<%=request.getContextPath()%>/student/change-password">
				<i class="fas fa-key me-1"></i>Đổi mật khẩu
			</a>
		</div>

		<div class="app-card">
			<h3 class="mb-4">
				<i class="fas fa-id-card me-2"></i>Thông tin cá nhân
			</h3>

			<div class="text-center mb-4">
				<img src="<%=request.getContextPath()%>/uploads/<%=avatar%>"
					class="avatar-lg" alt="Ảnh đại diện">
				<div class="mt-2"
					style="font-weight: 600; font-size: 18px; color: var(--text);"><%=s.getName()%></div>
				<div style="color: var(--text-secondary); font-size: 13px;">Sinh
					viên</div>
			</div>

			<table class="table table-bordered info-table">
				<tbody>
					<tr>
						<th><i class="fas fa-id-badge me-2"></i>Mã sinh viên</th>
						<td><%=("SV000" + s.getId())%></td>
					</tr>
					<tr>
						<th><i class="fas fa-user me-2"></i>Họ tên</th>
						<td><%=s.getName()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-envelope me-2"></i>Email</th>
						<td><%=s.getEmail()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-phone me-2"></i>Số điện thoại</th>
						<td><%=s.getPhone()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-venus-mars me-2"></i>Giới tính</th>
						<td><%="Male".equals(s.getGender()) ? "Nam" : "Nữ"%></td>
					</tr>
					<tr>
						<th><i class="fas fa-calendar-alt me-2"></i>Ngày sinh</th>
						<td><%=s.getDob()%></td>
					</tr>
					<tr>
						<th><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ</th>
						<td><%=s.getAddress()%></td>
					</tr>
				</tbody>
			</table>

			<div class="app-actions">
				<a href="<%=request.getContextPath()%>/student/classes"
					class="btn btn-primary"> <i class="fas fa-school me-2"></i>Lớp
					học của tôi
				</a> <a href="<%=request.getContextPath()%>/student/teachers"
					class="btn btn-primary"> <i
					class="fas fa-chalkboard-teacher me-2"></i>Giảng viên của tôi
				</a> <a href="<%=request.getContextPath()%>/student/scores"
					class="btn btn-primary"> <i
					class="fas fa-chalkboard-teacher me-2"></i>Điểm số
				</a><a href="<%=request.getContextPath()%>/student/profile"
					class="btn btn-outline-primary"> <i
					class="fas fa-user-edit me-2"></i>Chỉnh sửa hồ sơ
				</a> <a href="<%=request.getContextPath()%>/student/change-password"
					class="btn btn-secondary"> <i class="fas fa-key me-2"></i>Đổi
					mật khẩu
				</a>
			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<%
	String successMsg = (String) session.getAttribute("successMsg");
	if (successMsg != null) {
		session.removeAttribute("successMsg");
		String safeMsg = successMsg.replace("'", "\\'");
	%>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
console.log('successMsg:', '<%=safeMsg%>');
window.addEventListener('load', function() {
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
		});
	</script>
	<%
	}
	%>
</body>
</html>