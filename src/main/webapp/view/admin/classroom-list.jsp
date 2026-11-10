<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Quản lý lớp học");
request.setAttribute("activeMenu", "classrooms");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Quản lý lớp học</h2>

<div class="toolbar">
	<div class="d-flex gap-2">
		<a href="<%=request.getContextPath()%>/admin/classrooms?action=add"
			class="btn btn-success"> <i class="fas fa-plus me-2"></i>Thêm lớp
			học
		</a>
		<button type="button" class="btn btn-outline-primary"
			onclick="exportTableToExcel('classroomTable','danh-sach-lop-hoc.xls')">
			<i class="fas fa-file-excel me-2"></i>Xuất Excel
		</button>
	</div>
</div>

<form method="get"
	action="<%=request.getContextPath()%>/admin/classrooms" class="mb-3">
	<div class="search-bar">
		<input type="text" name="keyword" value="${keyword}"
			class="form-control" placeholder="🔍 Tìm theo tên lớp học...">
		<button class="btn btn-primary">
			<i class="fas fa-search me-1"></i>Tìm kiếm
		</button>
		<a href="<%=request.getContextPath()%>/admin/classrooms"
			class="btn btn-secondary"> <i class="fas fa-redo me-1"></i>Đặt
			lại
		</a>
	</div>
</form>
<div class="table-responsive">
	<table id="classroomTable" class="table table-hover">
		<thead>
			<tr>
				<th>STT</th>
				<th>Mã lớp</th>
				<th>Tên lớp</th>
				<th>Phòng học</th>
				<th>Mô tả</th>
				<th>Giảng viên phụ trách</th>
				<th>Thao tác</th>
			</tr>
		</thead>
		<tbody>
			<%
			List<Map<String, Object>> list = (List<Map<String, Object>>) request.getAttribute("list");
			int stt = 0;
			if (list != null) {
				for (Map<String, Object> row : list) {
			%>

			<tr>
				<td><%=++stt%></td>
				<td><strong><%=("HP000" + row.get("id"))%></strong></td>
				<td><%=row.get("name")%></td>
				<td><%=row.get("room")%></td>
				<td><%=row.get("description")%></td>
				<td><%=row.get("teacher_name") != null
		? ((row.get("teacher_code") != null ? row.get("teacher_code") + " - " : "") + row.get("teacher_name"))
		: "<span class='text-no-data'>Chưa phân công</span>"%></td>
				<td>
					<div class="action-group">
						<a
							href="<%=request.getContextPath()%>/admin/classrooms?action=detail&id=<%=row.get("id")%>"
							class="btn btn-info btn-sm" title="Chi tiết"> <i
							class="fas fa-eye"></i>
						</a> <a
							href="<%=request.getContextPath()%>/admin/classrooms?action=edit&id=<%=row.get("id")%>"
							class="btn btn-warning btn-sm" title="Sửa"> <i
							class="fas fa-edit"></i>
						</a> <a href="#" class="btn btn-danger btn-sm" title="Xóa"
							onclick="confirmDelete('<%=request.getContextPath()%>/admin/classrooms?action=delete&id=<%=row.get("id")%>')">
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
            <a class="page-link" href="classrooms?page=<%= currentPage - 1 %>&keyword=<%= keyword %>"> << </a>
        </li>
        <% for (int i = 1; i <= totalPages; i++) { %>
        <li class="page-item <%= i == currentPage ? "active" : "" %>">
            <a class="page-link" href="classrooms?page=<%= i %>&keyword=<%= keyword %>"><%= i %></a>
        </li>
        <% } %>
        <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <a class="page-link" href="classrooms?page=<%= currentPage + 1 %>&keyword=<%= keyword %>"> >> </a>
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
        title: 'Bạn có chắc chắn muốn xóa lớp học này không?',
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