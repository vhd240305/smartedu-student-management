<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
Map<String, Object> schedule = (Map<String, Object>) request.getAttribute("schedule");
boolean isEdit = schedule != null;
request.setAttribute("pageTitle", isEdit ? "Sửa lịch học" : "Thêm lịch học");
request.setAttribute("activeMenu", "schedules");
List<Map<String, Object>> classrooms = (List<Map<String, Object>>) request.getAttribute("classrooms");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title"><%=isEdit ? "Sửa lịch học" : "Thêm lịch học"%></h2>

<div class="card border-0 shadow-sm">
    <div class="card-body">
        <form method="post" action="<%=request.getContextPath()%>/admin/schedules">
            <input type="hidden" name="action" value="<%=isEdit ? "update" : "insert"%>">
            <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%=schedule.get("id")%>">
            <% } %>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Lớp học <span class="required-dot">*</span></label>
                    <select name="classroom_id" class="form-control" required>
                        <option value="">-- Chọn lớp học --</option>
                        <% if (classrooms != null) { for (Map<String, Object> c : classrooms) {
                            boolean selected = isEdit && String.valueOf(c.get("id")).equals(String.valueOf(schedule.get("classroom_id")));
                        %>
                        <option value="<%=c.get("id")%>" <%=selected ? "selected" : ""%>>
                            HP000<%=c.get("id")%> - <%=c.get("name")%>
                        </option>
                        <% } } %>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Thứ <span class="required-dot">*</span></label>
                    <select name="day_of_week" class="form-control" required>
                        <% String[] days = {"", "", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};
                        for (int d = 2; d <= 7; d++) {
                            boolean selected = isEdit && (int)schedule.get("day_of_week") == d;
                        %>
                        <option value="<%=d%>" <%=selected ? "selected" : ""%>><%=days[d]%></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">Tiết bắt đầu <span class="required-dot">*</span></label>
                    <select name="period_start" class="form-control" required>
                        <% for (int p = 1; p <= 12; p++) {
                            boolean selected = isEdit && (int)schedule.get("period_start") == p;
                        %>
                        <option value="<%=p%>" <%=selected ? "selected" : ""%>>Tiết <%=p%></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">Tiết kết thúc <span class="required-dot">*</span></label>
                    <select name="period_end" class="form-control" required>
                        <% for (int p = 1; p <= 12; p++) {
                            boolean selected = isEdit && (int)schedule.get("period_end") == p;
                        %>
                        <option value="<%=p%>" <%=selected ? "selected" : ""%>>Tiết <%=p%></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Phòng học</label>
                    <input type="text" name="room" class="form-control"
                           placeholder="VD: A101"
                           value="<%=isEdit && schedule.get("room") != null ? schedule.get("room") : ""%>">
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">Ngày bắt đầu</label>
                    <input type="date" name="start_date" class="form-control"
                           value="<%=isEdit && schedule.get("start_date") != null ? schedule.get("start_date") : ""%>">
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">Ngày kết thúc</label>
                    <input type="date" name="end_date" class="form-control"
                           value="<%=isEdit && schedule.get("end_date") != null ? schedule.get("end_date") : ""%>">
                </div>
                <div class="col-md-12 mb-3">
                    <label class="form-label">Ghi chú</label>
                    <input type="text" name="note" class="form-control"
                           placeholder="Ghi chú thêm..."
                           value="<%=isEdit && schedule.get("note") != null ? schedule.get("note") : ""%>">
                </div>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save me-2"></i><%=isEdit ? "Cập nhật" : "Thêm lịch học"%>
                </button>
                <a href="<%=request.getContextPath()%>/admin/schedules" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>