<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Student"%>
<%@ page import="model.Classroom"%>
<%
request.setAttribute("pageTitle", "Chi tiết sinh viên");
request.setAttribute("activeMenu", "students");

Student student = (Student) request.getAttribute("student");
List<Classroom> classes = (List<Classroom>) request.getAttribute("classes");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<style>
.list-group-item {
	transition: all 0.2s ease;
}

.list-group-item:hover {
	background-color: #bcbcbc;
	cursor: pointer;
}
</style>

<div class="d-flex justify-content-between align-items-center mb-3">
	<h2 class="page-title mb-0">Chi tiết sinh viên</h2>
	<div class="d-flex gap-2">
		<a href="<%=request.getContextPath()%>/admin/students"
			class="btn btn-secondary"> <i class="fas fa-arrow-left me-1"></i>Quay
			lại
		</a> <a
			href="<%=request.getContextPath()%>/admin/students?action=edit&id=<%=student.getId()%>"
			class="btn btn-warning"> <i class="fas fa-edit me-1"></i>Sửa
		</a>
	</div>
</div>

<div class="row g-3">
	<div class="col-lg-4">
		<div class="card shadow-sm">
			<div class="card-body text-center">
				<img
					src="<%=request.getContextPath()%>/uploads/<%=student.getAvatar() == null ? "" : student.getAvatar()%>"
					alt="Avatar"
					style="width: 140px; height: 140px; object-fit: cover; border-radius: 50%; border: 1px solid #eee;">
				<h4 class="mt-3 mb-1"><%=student.getName()%></h4>
				<div class="text-muted">
					Mã SV: <strong><%=("SV000" + student.getId())%></strong>
				</div>
			</div>
		</div>
	</div>

	<div class="col-lg-8">
		<div class="card shadow-sm">
			<div class="card-body">
				<div class="row">
					<div class="col-md-6 mb-2">
						<strong>Email:</strong>
						<%=student.getEmail()%></div>
					<div class="col-md-6 mb-2">
						<strong>Điện thoại:</strong>
						<%=student.getPhone()%></div>
					<div class="col-md-6 mb-2">
						<strong>Giới tính:</strong>
						<%="Male".equals(student.getGender()) ? "Nam" : "Nữ"%></div>
					<div class="col-md-6 mb-2">
						<strong>Ngày sinh:</strong>
						<%=student.getDob()%></div>
					<div class="col-12 mb-2">
						<strong>Địa chỉ:</strong>
						<%=student.getAddress()%></div>
				</div>

				<hr />

				<h5 class="mb-2">Các lớp đang học</h5>
				<%
				if (classes == null || classes.isEmpty()) {
				%>
				<div class="text-muted">Chưa có lớp.</div>
				<%
				} else {
				%>
				<div class="list-group">
					<%
					for (Classroom c : classes) {
					%>
					<a
						class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
						href="<%=request.getContextPath()%>/admin/classrooms?action=detail&id=<%=c.getId()%>">
						<span> Lớp học phần: <strong><%=c.getClassroomCode() != null ? c.getClassroomCode() : c.getName()%></strong>
							<span> - Phòng: <strong><%=c.getRoom()%></strong></span> <!-- đang bỏ class="text-muted"-->
					</span>
					</a>
					<%
					}
					%>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>

