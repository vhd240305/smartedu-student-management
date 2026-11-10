<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("pageTitle", "Thêm giảng viên");
request.setAttribute("activeMenu", "teachers");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Thêm giảng viên mới</h2>
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

	<input type="hidden" name="action" value="insert">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Họ tên <span class="required-dot">*</span></label>
				<input name="name" placeholder="Nhập họ tên giảng viên"
					class="form-control" required maxlength="120"
					value="<%=request.getParameter("name") != null ? request.getParameter("name") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Email <span class="required-dot">*</span></label>
				<input name="email" placeholder="Nhập email" class="form-control"
					required type="email" maxlength="120"
					value="<%=request.getParameter("email") != null ? request.getParameter("email") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Số điện thoại <span
					class="required-dot">*</span></label> <input name="phone"
					placeholder="VD: 0912345678" class="form-control" required
					pattern="0[0-9]{9}" maxlength="10"
					value="<%=request.getParameter("phone") != null ? request.getParameter("phone") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Bộ môn/Khoa <span
					class="required-dot">*</span></label> <input name="department"
					placeholder="Nhập bộ môn hoặc khoa" class="form-control" required
					maxlength="120"
					value="<%=request.getParameter("department") != null ? request.getParameter("department") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Tên đăng nhập <span
					class="required-dot">*</span></label> <input name="username"
					class="form-control" required minlength="4" maxlength="50"
					pattern="[a-zA-Z0-9_\.]{4,50}" placeholder="Nhập tên đăng nhập"
					value="<%=request.getParameter("username") != null ? request.getParameter("username") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Mật khẩu <span
					class="required-dot">*</span></label> <input type="password"
					name="password" class="form-control" required minlength="6"
					maxlength="100" placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
			</div>
		</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-success">
			<i class="fas fa-save me-2"></i>Lưu giảng viên
		</button>
		<a href="<%=request.getContextPath()%>/admin/teachers"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>