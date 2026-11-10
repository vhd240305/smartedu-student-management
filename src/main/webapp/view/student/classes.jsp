<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, model.Classroom, model.Student, model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");
if (acc == null || !"student".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}
Student s = (Student) request.getAttribute("student");
String studentName = (s != null) ? s.getName() : acc.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lớp học của tôi — QLSV</title>
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
				<span class="user-greeting">Xin chào, <strong><%=studentName%></strong></span>
				<a href="<%=request.getContextPath()%>/logout"
					class="btn btn-danger btn-sm"> <i
					class="fas fa-sign-out-alt me-1"></i>Đăng xuất
				</a>
			</div>
		</div>

		<div class="nav-pills-modern">
			<a href="<%=request.getContextPath()%>/student/home"> <i
				class="fas fa-home me-1"></i>Trang chủ
			</a> <a href="<%=request.getContextPath()%>/student/classes"
				class="active"> <i class="fas fa-school me-1"></i>Lớp học
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
			<h3 class="mb-3">
				<i class="fas fa-school me-2"></i>Lớp học của tôi
			</h3>
			<div class="table-responsive">
				<table class="table table-bordered table-hover">
					<thead>
						<tr>
							<th>STT</th>
							<th>Mã lớp</th>
							<th>Tên lớp</th>
							<th>Phòng học</th>
							<th>Mô tả</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<Classroom> list = (List<Classroom>) request.getAttribute("classes");
						int stt = 0;
						if (list != null && !list.isEmpty()) {
							for (Classroom c : list) {
						%>
						<tr>
							<td><%=++stt%></td>
							<td><strong><%="HP000" + c.getId()%></strong></td>
							<td><%=c.getName()%></td>
							<td><%=c.getRoom()%></td>
							<td><%=c.getDescription()%></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="5" class="text-center"
								style="color: var(--text-secondary); padding: 24px;"><i
								class="fas fa-inbox me-2"></i>Chưa có lớp học nào</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
			<a href="<%=request.getContextPath()%>/student/home"
				class="btn btn-secondary"> <i class="fas fa-arrow-left me-2"></i>Quay
				lại
			</a>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>