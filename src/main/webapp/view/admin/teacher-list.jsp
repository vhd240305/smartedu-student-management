<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Quản lý giảng viên");
request.setAttribute("activeMenu", "teachers");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Quản lý giảng viên</h2>

<div class="toolbar">
	<div class="d-flex gap-2">
		<a href="<%=request.getContextPath()%>/admin/teachers?action=add"
			class="btn btn-success"> <i class="fas fa-plus me-2"></i>Thêm
			giảng viên
		</a>
		<button type="button" class="btn btn-outline-primary"
			onclick="exportTableToExcel('teacherTable','danh-sach-giang-vien.xls')">
			<i class="fas fa-file-excel me-2"></i>Xuất Excel
		</button>
	</div>
</div>

<%
List<String> departmentList = (List<String>) request.getAttribute("departmentList");
boolean hasFilter = (request.getAttribute("filterDepartment") != null && !request.getAttribute("filterDepartment").toString().isEmpty())
    || (request.getAttribute("filterHasClass") != null && !request.getAttribute("filterHasClass").toString().isEmpty());
%>

<form method="get" action="<%=request.getContextPath()%>/admin/teachers" class="mb-3" id="filterForm">

    <input type="hidden" name="department" id="hiddenDepartment" value="${filterDepartment}">
    <input type="hidden" name="hasClass" id="hiddenHasClass" value="${filterHasClass}">

    <div class="search-bar mb-2">
        <input type="text" name="keyword" value="${keyword}"
            class="form-control" placeholder="🔍 Tìm theo tên giảng viên...">
        <button class="btn btn-primary">
            <i class="fas fa-search me-1"></i>Tìm kiếm
        </button>
        <button type="button" class="btn btn-secondary" id="btnFilter">
            <i class="fas fa-filter me-1"></i>Bộ lọc
            <% if (hasFilter) { %>
            <span class="badge bg-danger ms-1">!</span>
            <% } %>
        </button>
        <a href="<%=request.getContextPath()%>/admin/teachers" class="btn btn-secondary">
            <i class="fas fa-redo me-1"></i>Đặt lại
        </a>
    </div>

    <div id="filterPanel"
        style="display:none; background: var(--bs-light); border: 1px solid #dee2e6; border-radius: 8px; padding: 16px;"
        class="mb-2">
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Bộ môn/Khoa</label>
                <select id="filterDepartment" class="form-control">
                    <option value="">-- Chọn khoa --</option>
                    <% if (departmentList != null) { for (String dept : departmentList) { %>
                    <option value="<%= dept %>"
                        <%= dept.equals(request.getAttribute("filterDepartment")) ? "selected" : "" %>>
                        <%= dept %>
                    </option>
                    <% } } %>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Trạng thái lớp</label>
                <select id="filterHasClass" class="form-control">
                    <option value="">-- Chọn trạng thái lớp --</option>
                    <option value="yes" <%= "yes".equals(request.getAttribute("filterHasClass")) ? "selected" : "" %>>Đang phụ trách lớp</option>
                    <option value="no" <%= "no".equals(request.getAttribute("filterHasClass")) ? "selected" : "" %>>Chưa có lớp</option>
                </select>
            </div>
        </div>
        <div class="d-flex gap-2 mt-3">
            <button type="button" class="btn btn-primary" id="btnApplyFilter">
                <i class="fas fa-filter me-1"></i>Lọc
            </button>
            <button type="button" class="btn btn-outline-secondary" id="btnClearFilter">
                <i class="fas fa-times me-1"></i>Xóa bộ lọc
            </button>
        </div>
    </div>

</form>

<div class="table-responsive">
	<table id="teacherTable" class="table table-hover">
		<thead>
			<tr>
				<th>STT</th>
				<th>Mã GV</th>
				<th>Họ tên</th>
				<th>Email</th>
				<th>Điện thoại</th>
				<th>Bộ môn/Khoa</th>
				<th>Lớp phụ trách</th>
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
				<td><strong><%=("GV000" + row.get("id"))%></strong></td>
				<td><%=row.get("name")%></td>
				<td><%=row.get("email")%></td>
				<td><%=row.get("phone")%></td>
				<td><%=row.get("department")%></td>
				<td><%=row.get("classes") != null ? row.get("classes") : "<span class='text-no-data'>Chưa có lớp</span>"%>
				</td>
				<td>
					<div class="action-group">
						<a
							href="<%=request.getContextPath()%>/admin/teachers?action=detail&id=<%=row.get("id")%>"
							class="btn btn-info btn-sm" title="Chi tiết"> <i
							class="fas fa-eye"></i>
						</a> <a
							href="<%=request.getContextPath()%>/admin/teachers?action=edit&id=<%=row.get("id")%>"
							class="btn btn-warning btn-sm" title="Sửa"> <i
							class="fas fa-edit"></i>
						</a> <a href="#" class="btn btn-danger btn-sm" title="Xóa"
							onclick="confirmDelete('<%=request.getContextPath()%>/admin/teachers?action=delete&id=<%=row.get("id")%>')">
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
String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
String filterDepartment = request.getAttribute("filterDepartment") != null ? (String) request.getAttribute("filterDepartment") : "";
String filterHasClass = request.getAttribute("filterHasClass") != null ? (String) request.getAttribute("filterHasClass") : "";
String pageParams = "&keyword=" + keyword + "&department=" + filterDepartment + "&hasClass=" + filterHasClass;
%>

<nav class="mt-3">
    <ul class="pagination justify-content-center">
        <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
            <a class="page-link" href="teachers?page=<%= currentPage - 1 %><%= pageParams %>"> << </a>
        </li>
        <% for (int i = 1; i <= totalPages; i++) { %>
        <li class="page-item <%= i == currentPage ? "active" : "" %>">
            <a class="page-link" href="teachers?page=<%= i %><%= pageParams %>"><%= i %></a>
        </li>
        <% } %>
        <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <a class="page-link" href="teachers?page=<%= currentPage + 1 %><%= pageParams %>"> >> </a>
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
        title: 'Bạn có chắc chắn muốn xóa giảng viên này không?',
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
<script>
document.getElementById('btnFilter').addEventListener('click', function() {
    const panel = document.getElementById('filterPanel');
    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
});

<% if (hasFilter) { %>
document.getElementById('filterPanel').style.display = 'block';
<% } %>

document.getElementById('btnApplyFilter').addEventListener('click', function() {
    document.getElementById('hiddenDepartment').value = document.getElementById('filterDepartment').value;
    document.getElementById('hiddenHasClass').value = document.getElementById('filterHasClass').value;
    document.getElementById('filterForm').submit();
});

document.getElementById('btnClearFilter').addEventListener('click', function() {
    document.getElementById('hiddenDepartment').value = '';
    document.getElementById('hiddenHasClass').value = '';
    document.getElementById('filterDepartment').value = '';
    document.getElementById('filterHasClass').value = '';
    document.getElementById('filterForm').submit();
});
</script>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>