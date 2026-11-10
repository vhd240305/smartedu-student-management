<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Thời khóa biểu");
request.setAttribute("activeMenu", "schedules");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Thời khóa biểu</h2>

<%
String successMsg = (String) session.getAttribute("successMsg");
if (successMsg != null) {
    session.removeAttribute("successMsg");
    String safeMsg = successMsg.replace("'", "\\'");
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
Swal.fire({ position:'top', icon:'success', title:'<%=safeMsg%>',
    showConfirmButton:false, timer:4000, timerProgressBar:true, toast:true });
</script>
<% } %>

<div class="toolbar">
    <div class="d-flex gap-2">
        <a href="<%=request.getContextPath()%>/admin/schedules?action=add" class="btn btn-success">
            <i class="fas fa-plus me-2"></i>Thêm lịch học
        </a>
    </div>
</div>

<%
// Tạo bảng thời khóa biểu dạng lưới
List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
List<Map<String, Object>> classrooms = (List<Map<String, Object>>) request.getAttribute("classrooms");

// Lọc theo lớp
String filterClassroom = request.getParameter("classroomId");
%>

<!-- Bộ lọc theo lớp -->
<div class="mb-3 d-flex gap-2 align-items-center">
    <label class="form-label mb-0">Lọc theo lớp:</label>
    <select id="classroomFilter" class="form-control" style="max-width:250px;"
            onchange="location.href='<%=request.getContextPath()%>/admin/schedules?classroomId='+this.value">
        <option value="">-- Tất cả lớp --</option>
        <% if (classrooms != null) { for (Map<String, Object> c : classrooms) { %>
        <option value="<%=c.get("id")%>"
            <%=String.valueOf(c.get("id")).equals(filterClassroom) ? "selected" : ""%>>
            HP000<%=c.get("id")%> - <%=c.get("name")%>
        </option>
        <% } } %>
    </select>
</div>

<!-- Bảng thời khóa biểu dạng lưới -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <h5 class="card-title mb-3" style="font-weight:600;">
            <i class="fas fa-calendar-week me-2"></i>Bảng thời khóa biểu tuần
        </h5>
        <div class="table-responsive">
            <table class="table table-bordered text-center" style="min-width:900px;">
                <thead>
                    <tr style="background:#1F3864; color:white;">
                        <th style="width:80px;">Tiết</th>
                        <th>Thứ 2</th>
                        <th>Thứ 3</th>
                        <th>Thứ 4</th>
                        <th>Thứ 5</th>
                        <th>Thứ 6</th>
                        <th>Thứ 7</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    // Tạo map lưới: period -> day -> schedule
                    Map<Integer, Map<Integer, List<Map<String, Object>>>> grid = new TreeMap<>();
                    for (int p = 1; p <= 12; p++) {
                        grid.put(p, new TreeMap<>());
                        for (int d = 2; d <= 7; d++) {
                            grid.get(p).put(d, new ArrayList<>());
                        }
                    }
                    if (schedules != null) {
                        for (Map<String, Object> s : schedules) {
                            if (filterClassroom != null && !filterClassroom.isEmpty()
                                    && !String.valueOf(s.get("classroom_id")).equals(filterClassroom)) continue;
                            int day = (int) s.get("day_of_week");
                            int pStart = (int) s.get("period_start");
                            int pEnd = (int) s.get("period_end");
                            for (int p = pStart; p <= pEnd; p++) {
                                if (grid.containsKey(p) && grid.get(p).containsKey(day)) {
                                    grid.get(p).get(day).add(s);
                                }
                            }
                        }
                    }

                    String[] colors = {"#e8f4fd","#e8fdf4","#fdf8e8","#fde8e8","#f0e8fd","#e8fdf8"};
                    int colorIdx = 0;
                    Map<Integer, String> scheduleColors = new HashMap<>();

                    for (int period = 1; period <= 12; period++) {
                    %>
                    <tr>
                        <td style="background:#f8f9fa; font-weight:600; font-size:13px;">
                            Tiết <%=period%>
                        </td>
                        <% for (int day = 2; day <= 7; day++) {
                            List<Map<String, Object>> cell = grid.get(period).get(day);
                        %>
                        <td style="padding:4px; min-width:120px;">
                            <% for (Map<String, Object> s : cell) {
                                int sid = (int) s.get("id");
                                if (!scheduleColors.containsKey(sid)) {
                                    scheduleColors.put(sid, colors[colorIdx % colors.length]);
                                    colorIdx++;
                                }
                                String color = scheduleColors.get(sid);
                            %>
                            <div style="background:<%=color%>; border-radius:6px; padding:4px 6px;
                                        font-size:12px; margin:2px; border-left:3px solid #2E75B6;">
                                <div style="font-weight:600;"><%=s.get("classroom_name")%></div>
                                <% if (s.get("room") != null && !s.get("room").toString().isEmpty()) { %>
                                <div style="color:#64748b;">P.<%=s.get("room")%></div>
                                <% } %>
                            </div>
                            <% } %>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Danh sách lịch học -->
<div class="card border-0 shadow-sm">
    <div class="card-body">
        <h5 class="card-title mb-3" style="font-weight:600;">
            <i class="fas fa-list me-2"></i>Danh sách lịch học
        </h5>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Lớp học</th>
                        <th>Thứ</th>
                        <th>Tiết</th>
                        <th>Phòng</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Ghi chú</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    int stt = 0;
                    String[] dayNames = {"", "", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};
                    if (schedules != null) {
                        for (Map<String, Object> s : schedules) {
                            if (filterClassroom != null && !filterClassroom.isEmpty()
                                    && !String.valueOf(s.get("classroom_id")).equals(filterClassroom)) continue;
                    %>
                    <tr>
                        <td><%=++stt%></td>
                        <td>HP000<%=s.get("classroom_id")%> - <%=s.get("classroom_name")%></td>
                        <td><%=dayNames[(int)s.get("day_of_week")]%></td>
                        <td>Tiết <%=s.get("period_start")%> - <%=s.get("period_end")%></td>
                        <td><%=s.get("room") != null ? s.get("room") : "-"%></td>
                        <td><%=s.get("start_date") != null ? s.get("start_date") : "-"%></td>
                        <td><%=s.get("end_date") != null ? s.get("end_date") : "-"%></td>
                        <td><%=s.get("note") != null ? s.get("note") : "-"%></td>
                        <td>
                            <div class="action-group">
                                <a href="<%=request.getContextPath()%>/admin/schedules?action=edit&id=<%=s.get("id")%>"
                                   class="btn btn-warning btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="btn btn-danger btn-sm"
                                   onclick="confirmDelete('<%=request.getContextPath()%>/admin/schedules?action=delete&id=<%=s.get("id")%>')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function confirmDelete(url) {
    Swal.fire({
        position: 'top', icon: 'warning',
        title: 'Bạn có chắc muốn xóa lịch học này?',
        showConfirmButton: true, showCancelButton: true,
        confirmButtonColor: '#dc3545', cancelButtonColor: '#6c757d',
        confirmButtonText: 'Xóa', cancelButtonText: 'Hủy', toast: true
    }).then(result => { if (result.isConfirmed) window.location.href = url; });
}
</script>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>