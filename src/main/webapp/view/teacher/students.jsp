<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Teacher, model.Account"%>

<%
Account acc = (Account) session.getAttribute("account");
if (acc == null || !"teacher".equals(acc.getRole())) {
	response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
	return;
}
Teacher t = (Teacher) request.getAttribute("teacher");
String teacherName = (t != null) ? t.getName() : acc.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Danh sách sinh viên — QLSV</title>
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
			</a> <a href="<%=request.getContextPath()%>/teacher/classes"> <i
				class="fas fa-school me-1"></i>Lớp giảng dạy
			</a> <a href="<%=request.getContextPath()%>/teacher/students"
				class="active"> <i class="fas fa-user-graduate me-1"></i>Sinh
				viên
			</a> <a href="<%=request.getContextPath()%>/teacher/profile"> <i
				class="fas fa-user-edit me-1"></i>Hồ sơ
			</a> <a href="<%=request.getContextPath()%>/teacher/change-password">
				<i class="fas fa-key me-1"></i>Đổi mật khẩu
			</a>
		</div>

		<div class="app-card">
			<div
				class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
				<h3 class="mb-0">
					<i class="fas fa-user-graduate me-2"></i>Danh sách sinh viên
				</h3>
				<button type="button" class="btn btn-outline-success"
					onclick="exportTableToExcel('teacherStudentTable', 'danh-sach-sinh-vien-giang-vien.xls')">
					<i class="fas fa-file-excel me-2"></i>Xuất Excel
				</button>
			</div>
			<div class="table-responsive">
				<table id="teacherStudentTable"
					class="table table-bordered table-hover table-striped">
					<thead>
						<tr>
							<th>STT</th>
							<th>Mã SV</th>
							<th>Họ tên</th>
							<th>Email</th>
							<th>Số điện thoại</th>
							<th>Mã lớp</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<Map<String, Object>> list = (List<Map<String, Object>>) request.getAttribute("list");
						int stt = 0;
						if (list != null && !list.isEmpty()) {
							for (Map<String, Object> row : list) {
						%>
						<tr>
							<td><%=++stt%></td>
							<td><strong><%=row.get("student_code") != null ? row.get("student_code") : ("SV" + row.get("id"))%></strong></td>
							<td><%=row.get("name")%></td>
							<td><%=row.get("email")%></td>
							<td><%=row.get("phone")%></td>
							<td><%=row.get("class")%></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="6" class="text-center"
								style="color: var(--text-secondary); padding: 24px;"><i
								class="fas fa-inbox me-2"></i>Chưa có sinh viên nào</td>
						</tr>
						<%
}
%>
					</tbody>
				</table>
			</div>
			<a href="<%=request.getContextPath()%>/teacher/home"
				class="btn btn-secondary"> <i class="fas fa-arrow-left me-2"></i>Quay
				lại
			</a>
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
			link.download = filename || "danh-sach-sinh-vien.xls";
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		}
	</script>
</body>
</html>