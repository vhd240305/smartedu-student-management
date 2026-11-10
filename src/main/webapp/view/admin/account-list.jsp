<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Account"%>
<%
request.setAttribute("pageTitle", "Quản lý tài khoản");
request.setAttribute("activeMenu", "accounts");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Quản lý tài khoản</h2>

<div class="toolbar">
	<div class="d-flex gap-2">
		<a href="<%=request.getContextPath()%>/admin/accounts?action=add"
			class="btn btn-success"> <i class="fas fa-plus me-2"></i>Thêm tài
			khoản
		</a>
		<button type="button" class="btn btn-outline-primary"
			onclick="exportTableToExcel('accountTable','danh-sach-tai-khoan.xls')">
			<i class="fas fa-file-excel me-2"></i>Xuất Excel
		</button>
	</div>
</div>

<form method="get" action="<%=request.getContextPath()%>/admin/accounts"
	class="mb-3">
	<div class="search-bar">
		<input type="text" name="keyword" value="${keyword}"
			class="form-control"
			placeholder="🔍 Tìm theo tên tài khoản hoặc vai trò...">
		<button class="btn btn-primary">
			<i class="fas fa-search me-1"></i>Tìm kiếm
		</button>
		<a href="<%=request.getContextPath()%>/admin/accounts"
			class="btn btn-secondary"> <i class="fas fa-redo me-1"></i>Đặt
			lại
		</a>
	</div>
</form>

<div class="table-responsive">
	<table id="accountTable" class="table table-hover">
		<thead>
			<tr>
				<th>STT</th>
				<th>Mã TK</th>
				<th>Tên đăng nhập</th>
				<th>Mật khẩu</th>
				<th>Vai trò</th>
				<th>Thao tác</th>
			</tr>
		</thead>
		<tbody>

			<%
			List<Account> list = (List<Account>) request.getAttribute("list");
			int stt = 0;

			if (list != null) {
				for (Account a : list) {
					String roleBadge = "badge-student";
					String roleLabel = "Sinh viên";
					if ("admin".equals(a.getRole())) {
				roleBadge = "badge-admin";
				roleLabel = "Quản trị viên";
					} else if ("teacher".equals(a.getRole())) {
				roleBadge = "badge-teacher";
				roleLabel = "Giảng viên";
					}
			%>

			<tr>
				<td><%=++stt%></td>
				<td><strong><%="TK000" + a.getId()%></strong></td>
				<td><%=a.getUsername()%></td>
				<td><%=a.getPassword()%></td>
				<td><span class="badge-role <%=roleBadge%>"><%=roleLabel%></span></td>
				<td>
					<div class="action-group">
						<a
							href="<%=request.getContextPath()%>/admin/accounts?action=edit&id=<%=a.getId()%>"
							class="btn btn-warning btn-sm" title="Sửa"> <i
							class="fas fa-edit"></i>
						</a> <a href="#" class="btn btn-danger btn-sm" title="Xóa"
							onclick="confirmDelete('<%=request.getContextPath()%>/admin/accounts?action=delete&id=<%=a.getId()%>')">
							<i class="fas fa-trash"></i>
						</a>
					</div>
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
int currentPage = (int) request.getAttribute("currentPage");
int totalPages = (int) request.getAttribute("totalPages");
String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
%>

<nav class="mt-3">
    <ul class="pagination justify-content-center">
        <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
            <a class="page-link" href="accounts?page=<%= currentPage - 1 %>&keyword=<%= keyword %>"> << </a>
        </li>
        <% for (int i = 1; i <= totalPages; i++) { %>
        <li class="page-item <%= i == currentPage ? "active" : "" %>">
            <a class="page-link" href="accounts?page=<%= i %>&keyword=<%= keyword %>"><%= i %></a>
        </li>
        <% } %>
        <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <a class="page-link" href="accounts?page=<%= currentPage + 1 %>&keyword=<%= keyword %>"> >> </a>
        </li>
    </ul>
</nav>
<style>
.swal2-container * {
	font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		sans-serif !important;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function confirmDelete(url) {
    Swal.fire({
        position: 'top',
        icon: 'warning',
        title: 'Bạn có chắc chắn muốn xóa tài khoản này không?',
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
        toast: true
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = url;
        }
    });
}

<%String successMsg = (String) session.getAttribute("successMsg");
if (successMsg != null) {
	session.removeAttribute("successMsg");%>
Swal.fire({
    position: 'top',
    icon: 'success',
    title: '<%=successMsg%>',
    showConfirmButton: false,
    timer: 4000,
    timerProgressBar: true,
    toast: true
});
<%}%>
</script>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>