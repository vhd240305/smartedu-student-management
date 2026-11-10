<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Student"%>
<%
request.setAttribute("pageTitle", "Xem điểm sinh viên");
request.setAttribute("activeMenu", "scores");
Student student = (Student) request.getAttribute("student");
List<Map<String, Object>> scores = (List<Map<String, Object>>) request.getAttribute("scores");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Điểm số — <%= student.getName() %></h2>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="card-title mb-0" style="font-weight:600;">
                <i class="fas fa-list me-2"></i>Toàn bộ điểm số
            </h5>
            <a href="javascript:history.back()" class="btn btn-secondary btn-sm">
                <i class="fas fa-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <% if (scores == null || scores.isEmpty()) { %>
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>Sinh viên này chưa có điểm nào.
        </div>
        <% } else { %>

        <!-- Tính GPA trung bình -->
        <%
        float totalGpa = 0;
        int countGpa = 0;
        for (Map<String, Object> s : scores) {
            if (s.get("gpa") != null && "approved".equals(s.get("status"))) {
                totalGpa += Float.parseFloat(s.get("gpa").toString());
                countGpa++;
            }
        }
        float avgGpa = countGpa > 0 ? Math.round(totalGpa / countGpa * 10f) / 10f : 0;
        %>
        <% if (countGpa > 0) { %>
        <div class="alert alert-info mb-3">
            <i class="fas fa-chart-line me-2"></i>
            GPA trung bình (các môn đã duyệt): <strong><%=avgGpa%></strong>
        </div>
        <% } %>

        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Môn học / Lớp</th>
                        <th>Điểm giữa kỳ</th>
                        <th>Điểm cuối kỳ</th>
                        <th>GPA</th>
                        <th>Xếp loại</th>                        
                        <th>Học kỳ</th>
                        <th>Năm học</th>
                        <th>Kết quả</th>
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

                        Object gpaObj = s.get("gpa");
                        float gpa = gpaObj != null ? Float.parseFloat(gpaObj.toString()) : 0;
                        String rank = "-", rankClass = "";
                        String ketQua = "-", ketQuaClass = "";
                        if (gpaObj != null && gpa > 0) {
                            if (gpa >= 8.5) { rank = "Giỏi"; rankClass = "bg-success"; }
                            else if (gpa >= 7.0) { rank = "Khá"; rankClass = "bg-primary"; }
                            else if (gpa >= 5.5) { rank = "Trung bình"; rankClass = "bg-warning text-dark"; }
                            else { rank = "Yếu"; rankClass = "bg-danger"; }
                            if (gpa >= 5.0) { ketQua = "Đạt"; ketQuaClass = "bg-success"; }
                            else { ketQua = "Không đạt"; ketQuaClass = "bg-danger"; }
                        }
                    %>
                    <tr>
                        <td><%=++stt%></td>
                        <td><%=s.get("classroom_name")%></td>
                        <td><%=s.get("midterm_score") != null ? s.get("midterm_score") : "-"%></td>
                        <td><%=s.get("final_score") != null ? s.get("final_score") : "-"%></td>
                        <td><strong><%=gpa > 0 ? gpa : "-"%></strong></td>
                        <td>
                            <% if (!rankClass.isEmpty()) { %>
                            <span class="badge <%=rankClass%>"><%=rank%></span>
                            <% } else { %>-<% } %>
                        </td>              
                        <td><%=s.get("semester") != null ? "HK" + s.get("semester") : "-"%></td>
                        <td><%=s.get("academic_year") != null ? s.get("academic_year") : "-"%></td>
                        <td>
    <% if (!ketQuaClass.isEmpty()) { %>
    <span class="badge <%=ketQuaClass%>"><%=ketQua%></span>
    <% } else { %>-<% } %>
</td>
                        <td><span class="badge <%=badgeClass%>"><%=statusLabel%></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>