<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Account"%>

<%
Account a = (Account) request.getAttribute("account");
%>
<%
request.setAttribute("pageTitle", "Cập nhật tài khoản");
request.setAttribute("activeMenu", "accounts");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Cập nhật tài khoản</h2>

<form action="<%=request.getContextPath()%>/admin/accounts"
	method="post">

	<input type="hidden" name="action" value="update"> <input
		type="hidden" name="id" value="<%=a.getId()%>">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Tên đăng nhập</label> <input type="text"
					name="username" value="<%=a.getUsername()%>" class="form-control">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Mật khẩu <span
					class="required-dot">*</span></label> <input type="text" name="password"
					value="<%=a.getPassword()%>" class="form-control" required
					minlength="6" maxlength="100">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Vai trò</label> <select name="role"
					class="form-control">
					<option value="admin"
						<%="admin".equals(a.getRole()) ? "selected" : ""%>>Quản trị
						viên</option>
					<option value="teacher"
						<%="teacher".equals(a.getRole()) ? "selected" : ""%>>Giảng
						viên</option>
					<option value="student"
						<%="student".equals(a.getRole()) ? "selected" : ""%>>Sinh
						viên</option>
				</select>
			</div>
		</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-primary">
			<i class="fas fa-save me-2"></i>Cập nhật
		</button>
		<a href="<%=request.getContextPath()%>/admin/accounts"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>