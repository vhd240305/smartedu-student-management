<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setAttribute("pageTitle", "Import sinh viên");
request.setAttribute("activeMenu", "students");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Import nhiều sinh viên từ Excel</h2>

<div class="row">
    <div class="col-md-7">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600;">
                    <i class="fas fa-upload me-2"></i>Tải lên file Excel
                </h6>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
                </div>
                <% } %>

                <% if (request.getAttribute("importErrors") != null) { %>
                <div class="alert alert-warning">
                    <strong><i class="fas fa-check-circle me-2"></i>Import hoàn tất:</strong>
                    <span class="text-success fw-bold"><%= request.getAttribute("successCount") %> thành công</span>,
                    <span class="text-danger fw-bold"><%= request.getAttribute("failedCount") %> lỗi</span>
                    <hr>
                    <strong>Chi tiết lỗi:</strong><br>
                    <%= request.getAttribute("importErrors") %>
                    <div class="mt-2">
                        <a href="<%=request.getContextPath()%>/admin/students" class="btn btn-primary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Về danh sách sinh viên
                        </a>
                    </div>
                </div>
                <% } %>

                <form method="post" action="<%=request.getContextPath()%>/admin/students/import"
                      enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">Chọn file Excel (.xlsx)</label>
                        <input type="file" name="excelFile" class="form-control" accept=".xlsx" required>
                        <div class="form-text">Chỉ hỗ trợ file .xlsx</div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-upload me-2"></i>Import
                        </button>
                        <a href="<%=request.getContextPath()%>/admin/students" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600;">
                    <i class="fas fa-info-circle me-2"></i>Hướng dẫn
                </h6>
                <p class="text-muted" style="font-size:13px;">
                    File Excel phải có định dạng <strong>.xlsx</strong> với các cột theo thứ tự:
                </p>
                <table class="table table-sm table-bordered" style="font-size:12px;">
                    <thead class="table-light">
                        <tr><th>Cột</th><th>Nội dung</th><th>Bắt buộc</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>A</td><td>Họ tên</td><td>✓</td></tr>
                        <tr><td>B</td><td>Email</td><td>✓</td></tr>
                        <tr><td>C</td><td>Số điện thoại</td><td>✓</td></tr>
                        <tr><td>D</td><td>Giới tính (Nam/Nữ)</td><td>✓</td></tr>
                        <tr><td>E</td><td>Ngày sinh (yyyy-MM-dd)</td><td>✓</td></tr>
                        <tr><td>F</td><td>Địa chỉ</td><td>✓</td></tr>
                        <tr><td>G</td><td>Tên đăng nhập</td><td>✓</td></tr>
                        <tr><td>H</td><td>Mật khẩu</td><td>✓</td></tr>
                        <tr><td>I</td><td>Lớp học (VD: HP0001 - Tên lớp, HP0002 - Tên lớp)</td><td>-</td></tr>
                    </tbody>
                </table>
                <a href="<%=request.getContextPath()%>/admin/students/import?action=template"
                   class="btn btn-outline-primary btn-sm w-100 mt-2">
                    <i class="fas fa-download me-2"></i>Tải file mẫu
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>