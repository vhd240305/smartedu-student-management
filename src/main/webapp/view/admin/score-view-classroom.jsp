<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Classroom"%>
<%
request.setAttribute("pageTitle", "Xem điểm lớp học");
request.setAttribute("activeMenu", "scores");
Classroom classroom = (Classroom) request.getAttribute("classroom");
List<Map<String, Object>> scores = (List<Map<String, Object>>) request.getAttribute("scores");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">
	Điểm số —
	<%=classroom.getName()%></h2>
<%
String successMsg = (String) session.getAttribute("successMsg");
if (successMsg != null) { session.removeAttribute("successMsg"); }
%>

<% if (successMsg != null) { %>
<div class="alert alert-success alert-dismissible fade show">
    <i class="fas fa-check-circle me-2"></i><%= successMsg %>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>
<div class="card border-0 shadow-sm mb-4">
	<div class="card-body">
		<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="card-title mb-0" style="font-weight: 600;">
        <i class="fas fa-list me-2"></i>Danh sách điểm sinh viên
    </h5>
    <div class="d-flex gap-2">
        <a href="<%=request.getContextPath()%>/admin/scores/export?type=classroom&classroomId=<%=classroom.getId()%>"
            class="btn btn-success btn-sm">
            <i class="fas fa-file-excel me-1"></i>Xuất Excel
        </a>
        <a href="<%=request.getContextPath()%>/admin/scores?action=allClassrooms"
            class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left me-1"></i>Quay lại
        </a>
    </div>
</div>

		<%
		if (scores == null || scores.isEmpty()) {
		%>
		<div class="alert alert-info">
			<i class="fas fa-info-circle me-2"></i>Chưa có điểm nào được nhập cho
			lớp này.
		</div>
		<%
		} else {
		%>
		<div class="table-responsive">
			<table class="table table-hover">
				<thead>
					<tr>
						<th>STT</th>
						<th>Tên sinh viên</th>
						<th>Điểm giữa kỳ</th>
						<th>Điểm cuối kỳ</th>
						<th>GPA</th>
						<th>Xếp loại</th>
						<th>Học kỳ</th>
						<th>Năm học</th>
						<th>Kết quả</th>
						<th>Trạng thái</th>
						<th>Thao tác</th>
					</tr>
				</thead>
				<tbody>
					<%
					int stt = 0;
					for (Map<String, Object> s : scores) {
						String status = (String) s.get("status");
						String badgeClass = "bg-secondary";
						String statusLabel = "Nháp";
						if ("pending".equals(status)) {
							badgeClass = "bg-warning text-dark";
							statusLabel = "Chờ duyệt";
						} else if ("approved".equals(status)) {
							badgeClass = "bg-success";
							statusLabel = "Đã duyệt";
						} else if ("rejected".equals(status)) {
							badgeClass = "bg-danger";
							statusLabel = "Từ chối";
						}

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
							if (gpa >= 5.0) { ketQua = "Đạt"; ketQuaClass = "bg-success"; }
						    else { ketQua = "Không đạt"; ketQuaClass = "bg-danger"; }

						}
					%>
					<tr>
						<td><%=++stt%></td>
						<td><a
							href="<%=request.getContextPath()%>/admin/scores?action=viewByStudent&studentId=<%=s.get("student_id")%>">
								<%=s.get("student_name")%>
						</a></td>
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
						<td><%=s.get("semester") != null ? "HK" + s.get("semester") : "-"%></td>
						<td><%=s.get("academic_year") != null ? s.get("academic_year") : "-"%></td>
						<td>
    <% if (!ketQuaClass.isEmpty()) { %>
    <span class="badge <%=ketQuaClass%>"><%=ketQua%></span>
    <% } else { %>-<% } %>
</td>
						<td><span class="badge <%=badgeClass%>"><%=statusLabel%></span></td>
						<td>
							<%
							if ("approved".equals(s.get("status"))) {
							%> <a
							href="<%=request.getContextPath()%>/admin/scores?action=edit&scoreId=<%=s.get("id")%>"
							class="btn btn-warning btn-sm"> <i class="fas fa-edit me-1"></i>Sửa
								điểm
						</a> <%
 } else {
 %> - <%
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
	</div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>