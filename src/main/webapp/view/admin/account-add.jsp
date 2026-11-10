<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setAttribute("pageTitle", "Thêm tài khoản");
request.setAttribute("activeMenu", "accounts");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Thêm tài khoản mới</h2>

<form action="<%=request.getContextPath()%>/admin/accounts"
	method="post">

	<input type="hidden" name="action" value="insert">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Tên đăng nhập <span
					class="required-dot">*</span></label> <input type="text" name="username"
					class="form-control" required minlength="4" maxlength="50"
					pattern="[a-zA-Z0-9_\.]{4,50}" placeholder="Nhập tên đăng nhập">
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
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Vai trò</label> <select name="role"
					class="form-control">
					<option value="admin">Quản trị viên</option>
					<option value="teacher">Giảng viên</option>
					<option value="student">Sinh viên</option>
				</select>
			</div>
		</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-success">
			<i class="fas fa-save me-2"></i>Tạo tài khoản
		</button>
		<a href="<%=request.getContextPath()%>/admin/accounts"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>