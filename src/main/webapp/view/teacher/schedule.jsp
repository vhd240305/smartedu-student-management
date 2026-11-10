<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Teacher, model.Account"%>
<%
Account acc = (Account) session.getAttribute("account");
Teacher teacher = (Teacher) request.getAttribute("teacher");
List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Thời khóa biểu — QLSV</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="<%=request.getContextPath()%>/assets/css/app-modern.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
    <div class="app-topbar">
        <h3 class="app-title"><i class="fas fa-chalkboard-teacher"></i> Cổng giảng viên</h3>
        <div class="d-flex align-items-center gap-3">
            <span class="user-greeting">Xin chào, <strong><%=teacher.getName()%></strong></span>
            <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">
                <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
            </a>
        </div>
    </div>

    <div class="nav-pills-modern">
        <a href="<%=request.getContextPath()%>/teacher/home"><i class="fas fa-home me-1"></i>Trang chủ</a>
        <a href="<%=request.getContextPath()%>/teacher/classes"><i class="fas fa-school me-1"></i>Lớp giảng dạy</a>
        <a href="<%=request.getContextPath()%>/teacher/schedule" class="active"><i class="fas fa-calendar-week me-1"></i>Thời khóa biểu</a>
        <a href="<%=request.getContextPath()%>/teacher/scores"><i class="fas fa-star me-1"></i>Quản lý điểm</a>
        <a href="<%=request.getContextPath()%>/teacher/profile"><i class="fas fa-user-edit me-1"></i>Hồ sơ</a>
        <a href="<%=request.getContextPath()%>/teacher/change-password"><i class="fas fa-key me-1"></i>Đổi mật khẩu</a>
    </div>

    <div class="app-card">
        <h3 class="mb-4"><i class="fas fa-calendar-week me-2"></i>Thời khóa biểu giảng dạy</h3>

        <% if (schedules == null || schedules.isEmpty()) { %>
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>Chưa có lịch dạy nào được phân công.
        </div>
        <% } else { %>

        <%
        Map<Integer, Map<Integer, List<Map<String, Object>>>> grid = new TreeMap<>();
        for (int p = 1; p <= 12; p++) {
            grid.put(p, new TreeMap<>());
            for (int d = 2; d <= 7; d++) {
                grid.get(p).put(d, new ArrayList<>());
            }
        }
        for (Map<String, Object> s : schedules) {
            int day = (int) s.get("day_of_week");
            int pStart = (int) s.get("period_start");
            int pEnd = (int) s.get("period_end");
            for (int p = pStart; p <= pEnd; p++) {
                if (grid.containsKey(p) && grid.get(p).containsKey(day)) {
                    grid.get(p).get(day).add(s);
                }
            }
        }
        String[] colors = {"#e8f4fd","#e8fdf4","#fdf8e8","#fde8e8","#f0e8fd","#e8fdf8",
                           "#fde8f4","#f4fde8","#e8eafd","#fdf4e8"};
        int colorIdx = 0;
        Map<Integer, String> scheduleColors = new HashMap<>();
        %>

        <div class="table-responsive">
            <table class="table table-bordered text-center" style="min-width:800px;">
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
                    <% for (int period = 1; period <= 12; period++) {
                        boolean hasContent = false;
                        for (int d = 2; d <= 7; d++) {
                            if (!grid.get(period).get(d).isEmpty()) { hasContent = true; break; }
                        }
                        if (!hasContent) continue;
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
                            <div style="background:<%=color%>; border-radius:6px; padding:6px 8px;
                                        font-size:12px; margin:2px; border-left:3px solid #198754;">
                                <div style="font-weight:600;"><%=s.get("classroom_name")%></div>
                                <% if (s.get("room") != null && !s.get("room").toString().isEmpty()) { %>
                                <div style="color:#64748b;">
                                    <i class="fas fa-door-open me-1"></i>P.<%=s.get("room")%>
                                </div>
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

        <!-- Danh sách lịch dạy chi tiết -->
        <h5 class="mt-4 mb-3" style="font-weight:600; color:#2E75B6;">
            <i class="fas fa-list me-2"></i>Chi tiết lịch dạy
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
                    </tr>
                </thead>
                <tbody>
                    <%
                    int stt = 0;
                    String[] dayNames = {"","","Thứ 2","Thứ 3","Thứ 4","Thứ 5","Thứ 6","Thứ 7"};
                    // Lấy danh sách unique theo id
                    Set<Integer> shown = new HashSet<>();
                    for (Map<String, Object> s : schedules) {
                        int sid = (int) s.get("id");
                        if (shown.contains(sid)) continue;
                        shown.add(sid);
                    %>
                    <tr>
                        <td><%=++stt%></td>
                        <td><%=s.get("classroom_name")%></td>
                        <td><%=dayNames[(int)s.get("day_of_week")]%></td>
                        <td>Tiết <%=s.get("period_start")%> - <%=s.get("period_end")%></td>
                        <td><%=s.get("room") != null ? "P." + s.get("room") : "-"%></td>
                        <td><%=s.get("start_date") != null ? s.get("start_date") : "-"%></td>
                        <td><%=s.get("end_date") != null ? s.get("end_date") : "-"%></td>
                        <td><%=s.get("note") != null ? s.get("note") : "-"%></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>