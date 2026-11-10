<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("pageTitle", "Cập nhật giảng viên");
request.setAttribute("activeMenu", "teachers");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Cập nhật thông tin giảng viên</h2>
<%
if (request.getAttribute("error") != null) {
%>
<div class="alert alert-danger">
	<i class="fas fa-exclamation-circle me-2"></i><%=request.getAttribute("error")%></div>
<%
}
%>
<form action="<%=request.getContextPath()%>/admin/teachers"
	method="post">

	<input type="hidden" name="action" value="update"> <input
		type="hidden" name="id" value="${teacher.id}">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Họ tên <span class="required-dot">*</span></label>
				<input name="name" value="${teacher.name}" class="form-control"
					required maxlength="120">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Email <span class="required-dot">*</span></label>
				<input name="email" value="${teacher.email}" class="form-control"
					required type="email" maxlength="120">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Số điện thoại <span
					class="required-dot">*</span></label> <input name="phone"
					value="${teacher.phone}" class="form-control" required
					pattern="0[0-9]{9}" maxlength="10">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Bộ môn/Khoa <span
					class="required-dot">*</span></label> <input name="department"
					value="${teacher.department}" class="form-control" required
					maxlength="120">
			</div>
		</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-primary">
			<i class="fas fa-save me-2"></i>Cập nhật
		</button>
		<a href="<%=request.getContextPath()%>/admin/teachers"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>