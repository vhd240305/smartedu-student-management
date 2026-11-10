<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, model.Classroom, model.Student, model.Teacher, model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");
if (acc == null || !"teacher".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}

Teacher teacher = (Teacher) request.getAttribute("teacher");
String teacherName = (teacher != null) ? teacher.getName() : acc.getUsername();

Classroom classroom = (Classroom) request.getAttribute("classroom");

// Xu ly logic xuat excel
List<Student> students = (List<Student>) request.getAttribute("students");
String classroomExportKey = "";
if (classroom != null) {
	if (classroom.getClassroomCode() != null && !classroom.getClassroomCode().trim().isEmpty()) {
		classroomExportKey = classroom.getClassroomCode();
	} else {
		classroomExportKey = String.valueOf(classroom.getId());
	}
}
String classroomExportFile = "danh-sach-sinh-vien-lop-" + classroomExportKey + ".xls";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Chi tiết lớp — QLSV</title>
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
				<span class="user-greeting">Xin chào, <strong><%=teacherName%></strong></span>
				<a href="<%=request.getContextPath()%>/logout"
					class="btn btn-danger btn-sm"> <i
					class="fas fa-sign-out-alt me-1"></i>Đăng xuất
				</a>
			</div>
		</div>

		<div class="nav-pills-modern">
			<a href="<%=request.getContextPath()%>/teacher/home"> <i
				class="fas fa-home me-1"></i>Trang chủ
			</a> <a href="<%=request.getContextPath()%>/teacher/classes"
				class="active"> <i class="fas fa-school me-1"></i>Lớp giảng dạy
			</a> <a href="<%=request.getContextPath()%>/teacher/scores">
        			<i class="fas fa-star me-1"></i>Quản lý điểm
    			</a><a href="<%=request.getContextPath()%>/teacher/profile"> <i
				class="fas fa-user-edit me-1"></i>Hồ sơ
			</a> <a href="<%=request.getContextPath()%>/teacher/change-password">
				<i class="fas fa-key me-1"></i>Đổi mật khẩu
			</a>
		</div>

		<div class="app-card">
			<div class="d-flex justify-content-between align-items-center mb-3">
				<h3 class="mb-0">
					<i class="fas fa-school me-2"></i>Chi tiết lớp học
				</h3>
				<a href="<%=request.getContextPath()%>/teacher/classes"
					class="btn btn-secondary"> <i class="fas fa-arrow-left me-2"></i>Quay
					lại
				</a>
			</div>

			<div class="card shadow-sm mb-3">
				<div class="card-body">
					<div class="row">
						<div class="col-md-6 mb-2">
							<strong>Mã lớp:</strong>
							<%="HP000" + classroom.getId()%></div>
						<div class="col-md-6 mb-2">
							<strong>Tên lớp:</strong>
							<%=classroom != null ? classroom.getName() : ""%></div>
						<div class="col-md-6 mb-2">
							<strong>Phòng:</strong>
							<%=classroom != null ? classroom.getRoom() : ""%></div>
						<div class="col-12 mb-2">
							<strong>Mô tả:</strong>
							<%=classroom != null ? classroom.getDescription() : ""%></div>
					</div>
				</div>
			</div>

			<div
				class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-2">
				<h5 class="mb-0">Danh sách sinh viên trong lớp</h5>
				<button type="button" class="btn btn-outline-success btn-sm"
					onclick="exportTableToExcel('teacherClassStudentTable', '<%=classroomExportFile%>')">
					<i class="fas fa-file-excel me-1"></i>Xuất Excel
				</button>
			</div>
			<div class="table-responsive">
				<table id="teacherClassStudentTable"
					class="table table-bordered table-hover table-striped">
					<thead>
						<tr>
							<th>STT</th>
							<th>Mã SV</th>
							<th>Họ tên</th>
							<th>Email</th>
							<th>Số điện thoại</th>
							<th>Giới tính</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (students == null || students.isEmpty()) {
						%>
						<tr>
							<td colspan="6" class="text-center"
								style="color: var(--text-secondary); padding: 24px;"><i
								class="fas fa-inbox me-2"></i>Chưa có sinh viên trong lớp</td>
						</tr>
						<%
						} else {
						int stt = 0;
						for (Student s : students) {
						%>
						<tr>
							<td><%=++stt%></td>
							<td><strong><%=("SV000" + s.getId())%></strong></td>
							<td><%=s.getName()%></td>
							<td><%=s.getEmail()%></td>
							<td><%=s.getPhone()%></td>
							<td><%="Male".equals(s.getGender()) ? "Nam" : "Nữ"%></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		function exportTableToExcel(tableId, filename) {
			var table = document.getElementById(tableId);
			if (!table) {
				alert("Không tìm thấy bảng dữ liệu để xuất.");
				return;
			}

			var html = "<html><head><meta charset='UTF-8'></head><body>"
					+ table.outerHTML + "</body></html>";
			var blob = new Blob([ html ], {
				type : "application/vnd.ms-excel;charset=utf-8;"
			});
			var link = document.createElement("a");
			link.href = URL.createObjectURL(blob);
			link.download = filename || "danh-sach-sinh-vien-theo-lop.xls";
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		}
	</script>
</body>
</html>

