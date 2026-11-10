<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Xem điểm theo lớp");
request.setAttribute("activeMenu", "scores");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Xem điểm theo lớp</h2>

<!-- Tabs -->
<ul class="nav nav-tabs mb-4">
    <li class="nav-item">
        <a class="nav-link" href="<%=request.getContextPath()%>/admin/scores">
            <i class="fas fa-clock me-1"></i>Chờ duyệt
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link active" href="<%=request.getContextPath()%>/admin/scores?action=allClassrooms">
            <i class="fas fa-school me-1"></i>Xem theo lớp
        </a>
    </li>
</ul>

<!-- Thanh tìm kiếm -->
<div class="mb-3">
    <input type="text" id="searchInput" class="form-control"
           placeholder="🔍 Tìm theo mã hoặc tên lớp học..."
           oninput="filterTable()">
</div>
<div class="card border-0 shadow-sm mt-4">
    <div class="card-body">
        <h5 class="card-title mb-3" style="font-weight:600;">
            <i class="fas fa-file-excel me-2 text-success"></i>Xuất báo cáo tổng hợp theo học kỳ
        </h5>
        <form method="get" action="<%=request.getContextPath()%>/admin/scores/export" class="row g-2">
            <input type="hidden" name="type" value="semester">
            <div class="col-md-3">
                <select name="semester" class="form-control">
                    <option value="1">Học kỳ 1</option>
                    <option value="2">Học kỳ 2</option>
                    <option value="3">Học kỳ hè</option>
                    <option value="4">Học kỳ xuân</option>
                </select>
            </div>
            <div class="col-md-3">
                <input type="text" name="academicYear" class="form-control"
                       placeholder="Năm học (VD: 2024-2025)" value="2024-2025">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-success w-100">
                    <i class="fas fa-download me-1"></i>Xuất Excel
                </button>
            </div>
        </form>
    </div>
</div>
<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover" id="classroomTable">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã lớp</th>
                        <th>Tên lớp</th>
                        <th>Giảng viên</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Map<String, Object>> allClassrooms = (List<Map<String, Object>>) request.getAttribute("allClassrooms");
                    int stt = 0;
                    if (allClassrooms != null) {
                        for (Map<String, Object> row : allClassrooms) {
                    %>
                    <tr>
                        <td><%=++stt%></td>
                        <td><strong>HP000<%=row.get("id")%></strong></td>
                        <td><%=row.get("name")%></td>
                        <td><%=row.get("teacher_name") != null ? row.get("teacher_name") : "<span class='text-no-data'>Chưa phân công</span>"%></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/admin/scores?action=viewByClassroom&classroomId=<%=row.get("id")%>"
                               class="btn btn-primary btn-sm">
                                <i class="fas fa-eye me-1"></i>Xem điểm
                            </a>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterTable() {
    const q = document.getElementById('searchInput').value.toLowerCase().normalize('NFC');
    const rows = document.querySelectorAll('#classroomTable tbody tr');
    rows.forEach(row => {
        const maLop = row.cells[1].textContent.toLowerCase().normalize('NFC');
        const tenLop = row.cells[2].textContent.toLowerCase().normalize('NFC');
        row.style.display = maLop.includes(q) || tenLop.includes(q) ? '' : 'none';
    });
}
</script>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>