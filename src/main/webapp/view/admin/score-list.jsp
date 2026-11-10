<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Quản lý điểm số");
request.setAttribute("activeMenu", "scores");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Quản lý điểm số</h2>

<%
String successMsg = (String) session.getAttribute("successMsg");
if (successMsg != null) {
    session.removeAttribute("successMsg");
    String safeMsg = successMsg.replace("'", "\\'");
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
Swal.fire({
    position: 'top', icon: 'success', title: '<%=safeMsg%>',
    showConfirmButton: false, timer: 4000, timerProgressBar: true, toast: true
});
</script>
<% } %>

<!-- Tabs -->
<ul class="nav nav-tabs mb-4">
    <li class="nav-item">
        <a class="nav-link active" href="<%=request.getContextPath()%>/admin/scores">
            <i class="fas fa-clock me-1"></i>Duyệt điểm
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="<%=request.getContextPath()%>/admin/scores?action=allClassrooms">
            <i class="fas fa-school me-1"></i>Xem điểm sinh viên
        </a>
    </li>
</ul>

<!-- Danh sách chờ duyệt -->
<div class="card border-0 shadow-sm">
    <div class="card-body">
        <h5 class="card-title mb-3" style="font-weight:600;">
            <i class="fas fa-clock me-2 text-warning"></i>Danh sách lớp chờ duyệt điểm
        </h5>
        <%
        List<Map<String, Object>> pendingList = (List<Map<String, Object>>) request.getAttribute("pendingList");
        if (pendingList == null || pendingList.isEmpty()) {
        %>
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>Không có lớp nào chờ duyệt điểm.
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã lớp</th>
                        <th>Tên lớp</th>
                        <th>Giảng viên</th>
                        <th>Số sinh viên</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    int stt = 0;
                    for (Map<String, Object> row : pendingList) {
                    %>
                    <tr>
                        <td><%=++stt%></td>
                        <td><strong>HP000<%=row.get("id")%></strong></td>
                        <td><%=row.get("name")%></td>
                        <td><%=row.get("teacher_name") != null ? row.get("teacher_name") : "<span class='text-no-data'>Chưa phân công</span>"%></td>
                        <td><span class="badge bg-primary"><%=row.get("score_count")%> sinh viên</span></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/admin/scores?action=view&classroomId=<%=row.get("id")%>"
                               class="btn btn-warning btn-sm">
                                <i class="fas fa-eye me-1"></i>Xem & Duyệt
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>