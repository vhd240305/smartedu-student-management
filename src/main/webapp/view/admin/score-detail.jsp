<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Classroom"%>
<%
request.setAttribute("pageTitle", "Duyệt điểm");
request.setAttribute("activeMenu", "scores");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<%
Classroom classroom = (Classroom) request.getAttribute("classroom");
List<Map<String, Object>> scores = (List<Map<String, Object>>) request.getAttribute("scores");
%>

<h2 class="page-title">Duyệt điểm — <%= classroom.getName() %></h2>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="card-title mb-0" style="font-weight:600;">
                <i class="fas fa-list me-2"></i>Danh sách điểm sinh viên
            </h5>
            <div class="d-flex gap-2">
                <a href="<%=request.getContextPath()%>/admin/scores" class="btn btn-secondary btn-sm">
                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên sinh viên</th>
                        <th>Điểm giữa kỳ</th>
                        <th>Điểm cuối kỳ</th>
                        <th>GPA</th>
                        <th>Học kỳ</th>
                        <th>Năm học</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    int stt = 0;
                    for (Map<String, Object> s : scores) {
                        String status = (String) s.get("status");
                        String badgeClass = "bg-secondary";
                        String statusLabel = "Nháp";
                        if ("pending".equals(status)) { badgeClass = "bg-warning text-dark"; statusLabel = "Chờ duyệt"; }
                        else if ("approved".equals(status)) { badgeClass = "bg-success"; statusLabel = "Đã duyệt"; }
                        else if ("rejected".equals(status)) { badgeClass = "bg-danger"; statusLabel = "Từ chối"; }
                    %>
                    <tr>
                        <td><%=++stt%></td>
                        <td><%=s.get("student_name")%></td>
                        <td><%=s.get("midterm_score") != null ? s.get("midterm_score") : "-"%></td>
                        <td><%=s.get("final_score") != null ? s.get("final_score") : "-"%></td>
                        <td><strong><%=s.get("gpa") != null ? s.get("gpa") : "-"%></strong></td>
                        <td><%=s.get("semester") != null ? s.get("semester") : "-"%></td>
                        <td><%=s.get("academic_year") != null ? s.get("academic_year") : "-"%></td>
                        <td><span class="badge <%=badgeClass%>"><%=statusLabel%></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Form duyệt/từ chối -->
        <div class="d-flex gap-3 mt-3">
            <form method="post" action="<%=request.getContextPath()%>/admin/scores" style="display:inline;">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="classroomId" value="<%=classroom.getId()%>">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-check me-2"></i>Duyệt điểm
                </button>
            </form>

            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">
                <i class="fas fa-times me-2"></i>Từ chối
            </button>
        </div>
    </div>
</div>

<!-- Modal từ chối -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Từ chối điểm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/admin/scores">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="classroomId" value="<%=classroom.getId()%>">
                <div class="modal-body">
                    <label class="form-label">Lý do từ chối</label>
                    <textarea name="note" class="form-control" rows="4"
                              placeholder="Nhập lý do từ chối..." required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Từ chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>