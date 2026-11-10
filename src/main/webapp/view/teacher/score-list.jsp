<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Classroom"%>
<%@ page import="model.Account"%>
<%
Account acc = (Account) session.getAttribute("account");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản lý điểm — QLSV</title>
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
				<span class="user-greeting">Xin chào, <strong><%=acc.getUsername()%></strong></span>
				<a href="<%=request.getContextPath()%>/logout"
					class="btn btn-danger btn-sm"> <i
					class="fas fa-sign-out-alt me-1"></i>Đăng xuất
				</a>
			</div>
		</div>

		<div class="nav-pills-modern">
			<a href="<%=request.getContextPath()%>/teacher/home"><i
				class="fas fa-home me-1"></i>Trang chủ</a> <a
				href="<%=request.getContextPath()%>/teacher/classes"><i
				class="fas fa-school me-1"></i>Lớp giảng dạy</a> <a
				href="<%=request.getContextPath()%>/teacher/schedule"> <i
				class="fas fa-calendar-week me-1"></i>Thời khóa biểu
			</a><a href="<%=request.getContextPath()%>/teacher/scores" class="active"><i
				class="fas fa-star me-1"></i>Quản lý điểm</a> <a
				href="<%=request.getContextPath()%>/teacher/profile"><i
				class="fas fa-user-edit me-1"></i>Hồ sơ</a> <a
				href="<%=request.getContextPath()%>/teacher/change-password"><i
				class="fas fa-key me-1"></i>Đổi mật khẩu</a>
		</div>

		<div class="app-card">
			<h3 class="mb-4">
				<i class="fas fa-star me-2"></i>Quản lý điểm số
			</h3>

			<%
			String successMsg = (String) session.getAttribute("successMsg");
			if (successMsg != null) {
				session.removeAttribute("successMsg");
				String safeMsg = successMsg.replace("'", "\\'");
			%>
			<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
			<script>
        Swal.fire({
            position: 'top', icon: 'success', title: '<%=safeMsg%>
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
			<%
			Map<Integer, String> scoreStatusMap = (Map<Integer, String>) request.getAttribute("scoreStatusMap");
			%>
			<div class="table-responsive">
				<table class="table table-hover">
					<thead>
						<tr>
							<th>STT</th>
							<th>Mã lớp</th>
							<th>Tên lớp</th>
							<th>Trạng thái điểm</th>
							<th>Thao tác</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<Classroom> classes = (List<Classroom>) request.getAttribute("classes");
						int stt = 0;
						if (classes != null) {
							for (Classroom c : classes) {
						%>
						<tr>
							<td><%=++stt%></td>
							<td><strong>HP000<%=c.getId()%></strong></td>
							<td><%=c.getName()%></td>
							<%
							String status = scoreStatusMap != null ? scoreStatusMap.getOrDefault(c.getId(), "none") : "none";
							String badgeClass = "bg-secondary";
							String statusLabel = "Chưa nhập";
							if ("draft".equals(status)) {
								badgeClass = "bg-secondary";
								statusLabel = "Đang nhập";
							} else if ("pending".equals(status)) {
								badgeClass = "bg-warning text-dark";
								statusLabel = "Chờ duyệt";
							} else if ("approved".equals(status)) {
								badgeClass = "bg-success";
								statusLabel = "Đã duyệt";
							} else if ("rejected".equals(status)) {
								badgeClass = "bg-danger";
								statusLabel = "Bị từ chối";
							}
							%>
							<td><span class="badge <%=badgeClass%>"><%=statusLabel%></span></td>
							<td><a
								href="<%=request.getContextPath()%>/teacher/scores?action=enter&classroomId=<%=c.getId()%>"
								class="btn btn-primary btn-sm"> <i class="fas fa-edit me-1"></i>Nhập
									điểm
							</a></td>
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
</body>
</html>