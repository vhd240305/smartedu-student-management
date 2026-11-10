<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Classroom"%>
<%@ page import="model.Account"%>
<%
Account acc = (Account) session.getAttribute("account");
Classroom classroom = (Classroom) request.getAttribute("classroom");
List<Map<String, Object>> scores = (List<Map<String, Object>>) request.getAttribute("scores");
String currentStatus = scores != null && !scores.isEmpty() ? (String) scores.get(0).get("status") : "draft";
boolean canEdit = "draft".equals(currentStatus) || "rejected".equals(currentStatus);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nhập điểm — QLSV</title>
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
			<div class="d-flex justify-content-between align-items-center mb-4">
				<h3 class="mb-0">
					<i class="fas fa-edit me-2"></i>Nhập điểm —
					<%=classroom.getName()%>
				</h3>
				<div class="d-flex gap-2">
					<a
						href="<%=request.getContextPath()%>/teacher/scores/export?classroomId=<%=classroom.getId()%>"
						class="btn btn-success"> <i class="fas fa-file-excel me-2"></i>Xuất
						báo cáo Excel
					</a> <a href="<%=request.getContextPath()%>/teacher/scores"
						class="btn btn-secondary btn-sm"> <i
						class="fas fa-arrow-left me-1"></i>Quay lại
					</a>
				</div>
			</div>

			<%
			if ("pending".equals(currentStatus)) {
			%>
			<div class="alert alert-warning">
				<i class="fas fa-clock me-2"></i>Điểm đã được nộp, đang chờ admin
				duyệt. Không thể chỉnh sửa.
			</div>
			<%
			} else if ("approved".equals(currentStatus)) {
			%>
			<div class="alert alert-success">
				<i class="fas fa-check-circle me-2"></i>Điểm đã được admin duyệt.
			</div>
			<%
			} else if ("rejected".equals(currentStatus)) {
			%>
			<div class="alert alert-danger">
				<i class="fas fa-times-circle me-2"></i>Điểm bị từ chối. Lý do: <strong><%=scores.get(0).get("note")%></strong>.
				Vui lòng chỉnh sửa và nộp lại.
			</div>
			<%
			}
			%>

			<%
			if (canEdit) {
			%>
			<form method="post"
				action="<%=request.getContextPath()%>/teacher/scores" id="scoreForm">
				<input type="hidden" name="action" value="save"> <input
					type="hidden" name="classroomId" value="<%=classroom.getId()%>">
				<div class="row mb-3">
					<div class="col-md-3">
						<label class="form-label">Học kỳ</label> <select name="semester"
							class="form-control">
							<option value="1"
								<%=scores != null && !scores.isEmpty() && "1".equals(scores.get(0).get("semester")) ? "selected" : ""%>>Học
								kỳ 1</option>
							<option value="2"
								<%=scores != null && !scores.isEmpty() && "2".equals(scores.get(0).get("semester")) ? "selected" : ""%>>Học
								kỳ 2</option>
							<option value="3"
								<%=scores != null && !scores.isEmpty() && "3".equals(scores.get(0).get("semester")) ? "selected" : ""%>>Học
								kỳ hè</option>
							<option value="4"
								<%=scores != null && !scores.isEmpty() && "4".equals(scores.get(0).get("semester")) ? "selected" : ""%>>Học
								kỳ xuân</option>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label">Năm học</label> <input type="text"
							name="academicYear" class="form-control"
							placeholder="VD: 2024-2025"
							value="<%=scores != null && !scores.isEmpty() && scores.get(0).get("academic_year") != null
		? scores.get(0).get("academic_year")
		: "2024-2025"%>">
					</div>
				</div>
				<%
				}
				%>

				<div class="table-responsive">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>STT</th>
								<th>Tên sinh viên</th>
								<th>Điểm giữa kỳ (40%)</th>
								<th>Điểm cuối kỳ (60%)</th>
								<th>GPA</th>
								<th>Xếp loại</th>
								<th>Kết quả</th>
							</tr>
						</thead>
						<tbody>
							<%
							int stt = 0;
							if (scores != null) {
								for (Map<String, Object> s : scores) {
									Object gpaObj = s.get("gpa");
									float gpa = 0;
									boolean hasGpa = false;
									if (gpaObj != null) {
								gpa = Float.parseFloat(gpaObj.toString());
								hasGpa = gpa > 0;
									}
									String rank = "";
									String rankClass = "";
									String ketQua = "-", ketQuaClass = "";
									if (hasGpa) {
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
									int studentId = (int) s.get("student_id");
							%>
							<tr>
								<td><%=++stt%></td>
								<td><%=s.get("student_name")%></td>
								<td>
									<%
									if (canEdit) {
									%> <input type="hidden" name="studentId" value="<%=studentId%>">
									<input type="number" name="midterm"
									class="form-control form-control-sm" min="0" max="10"
									step="0.1" style="width: 90px;"
									value="<%=s.get("midterm_score") != null ? s.get("midterm_score") : ""%>"
									id="midterm_<%=studentId%>" onchange="calcGpa(<%=studentId%>)">
									<%
									} else {
									%> <%=s.get("midterm_score") != null ? s.get("midterm_score") : "-"%>
									<%
									}
									%>
								</td>
								<td>
									<%
									if (canEdit) {
									%> <input type="number" name="finalScore"
									class="form-control form-control-sm" min="0" max="10"
									step="0.1" style="width: 90px;"
									value="<%=s.get("final_score") != null ? s.get("final_score") : ""%>"
									id="final_<%=studentId%>" onchange="calcGpa(<%=studentId%>)">
									<%
									} else {
									%> <%=s.get("final_score") != null ? s.get("final_score") : "-"%>
									<%
									}
									%>
								</td>
								<td><strong id="gpa_<%=studentId%>"> <%=gpa > 0 ? gpa : "-"%>
								</strong></td>
								<td id="rank_<%=studentId%>">
									<%
									if (hasGpa) {
									%> <span class="badge <%=rankClass%>"><%=rank%></span> <%
 } else {
 %> - <%
 }
 %>
								</td>
								<td id="ketqua_<%=studentId%>">
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
							}
							%>
						</tbody>
					</table>
				</div>

				<%
				if (canEdit) {
				%>
				<div class="d-flex gap-2 mt-3">
					<button type="submit" form="scoreForm" class="btn btn-primary">
						<i class="fas fa-save me-2"></i>Lưu điểm
					</button>
				</div>
			</form>

			<form method="post"
				action="<%=request.getContextPath()%>/teacher/scores" class="mt-2"
				id="submitScoreForm">
				<input type="hidden" name="action" value="submit"> <input
					type="hidden" name="classroomId" value="<%=classroom.getId()%>">
				<button type="button" class="btn btn-success"
					onclick="confirmSubmit()">
					<i class="fas fa-paper-plane me-2"></i>Nộp điểm chờ duyệt
				</button>
			</form>
			<%
			}
			%>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
function calcGpa(studentId) {
    const midterm = parseFloat(document.getElementById('midterm_' + studentId).value) || 0;
    const finalScore = parseFloat(document.getElementById('final_' + studentId).value) || 0;
    const gpa = Math.round((midterm * 0.4 + finalScore * 0.6) * 10) / 10;

    document.getElementById('gpa_' + studentId).textContent = gpa > 0 ? gpa : '-';

    const rankCell = document.getElementById('rank_' + studentId);
    const ketQuaCell = document.getElementById('ketqua_' + studentId);
    
    let rank = '', color = '';
    let ketQua = '', ketQuaColor = '';
    if (midterm > 0 || finalScore > 0) {
        if (gpa >= 8.5) { rank = 'Giỏi'; color = '#198754'; }
        else if (gpa >= 7.0) { rank = 'Khá'; color = '#0d6efd'; }
        else if (gpa >= 5.5) { rank = 'Trung bình'; color = '#ffc107'; }
        else { rank = 'Yếu'; color = '#dc3545'; }
        if (gpa >= 5.0) { ketQua = 'Đạt'; ketQuaColor = '#198754'; }
        else { ketQua = 'Không đạt'; ketQuaColor = '#dc3545'; }
    }
    rankCell.innerHTML = rank
        ? '<span class="badge" style="background-color:' + color + '; color:white;">' + rank + '</span>'
        : '-';
    ketQuaCell.innerHTML = ketQua
    ? '<span class="badge" style="background-color:' + ketQuaColor + '; color:white;">' + ketQua + '</span>'
    : '-';
}
</script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<style>
.swal2-container * {
	font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		sans-serif !important;
}
</style>
	<script>
function confirmSubmit() {
    Swal.fire({
        position: 'top',
        icon: 'warning',
        title: 'Bạn có chắc muốn nộp điểm? Sau khi nộp sẽ không chỉnh sửa được.',
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonColor: '#198754',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Nộp điểm',
        cancelButtonText: 'Hủy',
        toast: true
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('submitScoreForm').submit();
        }
    });
}
</script>
</body>
</html>