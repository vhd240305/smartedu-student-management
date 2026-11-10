<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Student, model.Account"%>
<%
Account acc = (Account) session.getAttribute("account");
Student student = (Student) request.getAttribute("student");
List<Map<String, Object>> scores = (List<Map<String, Object>>) request.getAttribute("scores");
float avgGpa = request.getAttribute("avgGpa") != null ? (float) request.getAttribute("avgGpa") : 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Điểm số — QLSV</title>
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
				<span class="user-greeting">Xin chào, <strong><%=student.getName()%></strong></span>
				<a href="<%=request.getContextPath()%>/logout"
					class="btn btn-danger btn-sm"> <i
					class="fas fa-sign-out-alt me-1"></i>Đăng xuất
				</a>
			</div>
		</div>

		<div class="nav-pills-modern">
			<a href="<%=request.getContextPath()%>/student/home"><i
				class="fas fa-home me-1"></i>Trang chủ</a> <a
				href="<%=request.getContextPath()%>/student/classes"><i
				class="fas fa-school me-1"></i>Lớp học</a> <a
				href="<%=request.getContextPath()%>/student/schedule"> <i
				class="fas fa-calendar-week me-1"></i>Thời khóa biểu
			</a> <a href="<%=request.getContextPath()%>/student/teachers"><i
				class="fas fa-chalkboard-teacher me-1"></i>Giảng viên</a> <a
				href="<%=request.getContextPath()%>/student/scores" class="active"><i
				class="fas fa-star me-1"></i>Điểm số</a> <a
				href="<%=request.getContextPath()%>/student/profile"><i
				class="fas fa-user-edit me-1"></i>Hồ sơ</a> <a
				href="<%=request.getContextPath()%>/student/change-password"><i
				class="fas fa-key me-1"></i>Đổi mật khẩu</a>
		</div>

		<div class="app-card">
			<h3 class="mb-4">
				<i class="fas fa-star me-2"></i>Bảng điểm của tôi
			</h3>

			<%
			if (avgGpa > 0) {
			%>
			<%
			String avgRank = "";
			String avgRankClass = "";
			if (avgGpa >= 8.5) {
				avgRank = "Giỏi";
				avgRankClass = "bg-success";
			} else if (avgGpa >= 7.0) {
				avgRank = "Khá";
				avgRankClass = "bg-primary";
			} else if (avgGpa >= 5.5) {
				avgRank = "Trung bình";
				avgRankClass = "bg-warning text-dark";
			} else {
				avgRank = "Yếu";
				avgRankClass = "bg-danger";
			}
			%>
			<div class="row g-3 mb-4">
				<div class="col-md-4">
					<div class="card border-0 shadow-sm text-center p-3">
						<div style="font-size: 2rem; font-weight: 700; color: #2E75B6;"><%=avgGpa%></div>
						<div style="color: #64748b; font-size: 13px;">GPA Trung bình</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card border-0 shadow-sm text-center p-3">
						<div style="font-size: 2rem; font-weight: 700; color: #198754;"><%=scores.size()%></div>
						<div style="color: #64748b; font-size: 13px;">Số môn đã có
							điểm</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card border-0 shadow-sm text-center p-3">
						<span class="badge <%=avgRankClass%>"
							style="font-size: 1.2rem; padding: 10px 20px;"><%=avgRank%></span>
						<div style="color: #64748b; font-size: 13px; margin-top: 6px;">Xếp
							loại chung</div>
					</div>
				</div>
			</div>
			<%
			}
			%>

			<%
			if (scores == null || scores.isEmpty()) {
			%>
			<div class="alert alert-info">
				<i class="fas fa-info-circle me-2"></i>Chưa có điểm nào được duyệt.
			</div>
			<%
			} else {
			%>

			<%-- Nhóm theo năm học --%>
			<%
			Map<String, List<Map<String, Object>>> byYear = new LinkedHashMap<>();
			for (Map<String, Object> s : scores) {
				String year = s.get("academic_year") != null ? (String) s.get("academic_year") : "hiện tại";
				byYear.computeIfAbsent(year, k -> new ArrayList<>()).add(s);
			}
			%>

			<%
			for (Map.Entry<String, List<Map<String, Object>>> entry : byYear.entrySet()) {
			%>
			<h5 class="mt-4 mb-3" style="font-weight: 600; color: #2E75B6;">
				<i class="fas fa-calendar-alt me-2"></i>Năm học
				<%=entry.getKey()%>
			</h5>
			<div class="table-responsive">
				<table class="table table-hover">
					<thead>
						<tr>
							<th>STT</th>
							<th>Môn học / Lớp</th>
							<th>Học kỳ</th>
							<th>Điểm giữa kỳ</th>
							<th>Điểm cuối kỳ</th>
							<th>GPA</th>
							<th>Xếp loại</th>
							<th>Kết quả</th>
						</tr>
					</thead>
					<tbody>
						<%
						int stt = 0;
						for (Map<String, Object> s : entry.getValue()) {
							Object gpaObj = s.get("gpa");
							float gpa = gpaObj != null ? Float.parseFloat(gpaObj.toString()) : 0;
							String rank = "-", rankClass = "";
							String ketQua = "-", ketQuaClass = "";
							if (gpaObj != null && gpa > 0) {
								if (gpa >= 8.5) {
							rank = "Giỏi";
							rankClass = "bg-success";
								} else if (gpa >= 7.0) {
							rank = "Khá";
							rankClass = "bg-primary";
								} else if (gpa >= 5.5) {
							rank = "Trung bình";
							rankClass = "bg-warning text-dark";
								} else {
							rank = "Yếu";
							rankClass = "bg-danger";
								}
								if (gpa >= 5.0) {
							ketQua = "Đạt";
							ketQuaClass = "bg-success";
								} else {
							ketQua = "Không đạt";
							ketQuaClass = "bg-danger";
								}
							}
						%>
						<tr>
							<td><%=++stt%></td>
							<td><%=s.get("classroom_name")%></td>
							<td>Học kỳ <%=s.get("semester")%></td>
							<td><%=s.get("midterm_score") != null ? s.get("midterm_score") : "-"%></td>
							<td><%=s.get("final_score") != null ? s.get("final_score") : "-"%></td>
							<td><strong><%=gpa > 0 ? gpa : "-"%></strong></td>
							<td>
								<%
								if (!rankClass.isEmpty()) {
								%> <span
								class="badge <%=rankClass%>"><%=rank%></span> <%
 } else {
 %>-<%
 }
 %>
							</td>
							<td>
								<%
								if (!ketQuaClass.isEmpty()) {
								%> <span
								class="badge <%=ketQuaClass%>"><%=ketQua%></span> <%
 } else {
 %>-<%
 }
 %>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
			<%
			}
			%>
			<%
			}
			%>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>