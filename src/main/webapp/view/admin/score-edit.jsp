<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Sửa điểm");
request.setAttribute("activeMenu", "scores");
Map<String, Object> score = (Map<String, Object>) request.getAttribute("score");
List<Map<String, Object>> history = (List<Map<String, Object>>) request.getAttribute("history");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Sửa điểm — <%=score.get("student_name")%></h2>

<div class="row g-4">
    <div class="col-md-6">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <h5 class="card-title mb-3" style="font-weight:600;">
                    <i class="fas fa-edit me-2"></i>Chỉnh sửa điểm
                </h5>

                <div class="alert alert-info mb-3">
                    <i class="fas fa-info-circle me-2"></i>
                    Môn học: <strong><%=score.get("classroom_name")%></strong>
                </div>

                <form method="post" action="<%=request.getContextPath()%>/admin/scores">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="scoreId" value="<%=score.get("id")%>">

                    <div class="mb-3">
                        <label class="form-label">Điểm giữa kỳ (40%)</label>
                        <input type="number" name="midterm" class="form-control"
                               min="0" max="10" step="0.1" required
                               value="<%=score.get("midterm_score") != null ? score.get("midterm_score") : ""%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Điểm cuối kỳ (60%)</label>
                        <input type="number" name="finalScore" class="form-control"
                               min="0" max="10" step="0.1" required
                               value="<%=score.get("final_score") != null ? score.get("final_score") : ""%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Lý do chỉnh sửa <span class="required-dot">*</span></label>
                        <textarea name="note" class="form-control" rows="3"
                                  placeholder="Nhập lý do chỉnh sửa điểm..." required></textarea>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                        </button>
                        <a href="javascript:history.back()" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <h5 class="card-title mb-3" style="font-weight:600;">
                    <i class="fas fa-history me-2"></i>Lịch sử chỉnh sửa
                </h5>

                <% if (history == null || history.isEmpty()) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>Chưa có lịch sử chỉnh sửa.
                </div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-sm table-hover">
                        <thead>
                            <tr>
                                <th>Trường sửa</th>
                                <th>Cũ</th>
                                <th>Mới</th>
                                <th>Người sửa</th>
                                <th>Thời gian</th>
                                <th>Lý do</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> h : history) { %>
                            <tr>
                                <td><strong><%=h.get("field_changed")%></strong></td>
                                <td><span class="badge bg-danger"><%=h.get("old_value")%></span></td>
                                <td><span class="badge bg-success"><%=h.get("new_value")%></span></td>
                                <td><%=h.get("changed_by_name")%></td>
                                <td style="font-size:12px;"><%=h.get("changed_at")%></td>
                                <td style="font-size:12px;"><%=h.get("note") != null ? h.get("note") : "-"%></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>