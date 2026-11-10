<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%
request.setAttribute("pageTitle", "Thêm sinh viên");
request.setAttribute("activeMenu", "students");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Thêm sinh viên mới</h2>
<%
if (request.getAttribute("error") != null) {
%>
<div class="alert alert-danger">
	<i class="fas fa-exclamation-circle me-2"></i><%=request.getAttribute("error")%></div>
<%
}
%>
<form action="students" method="post" enctype="multipart/form-data">

	<input type="hidden" name="action" value="insert">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Họ tên <span class="required-dot">*</span></label>
				<input name="name" class="form-control"
					placeholder="Nhập họ tên sinh viên" required maxlength="120"
					value="<%=request.getParameter("name") != null ? request.getParameter("name") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Email <span class="required-dot">*</span></label>
				<input name="email" class="form-control" placeholder="Nhập email"
					required type="email" maxlength="120"
					value="<%=request.getParameter("email") != null ? request.getParameter("email") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Số điện thoại <span
					class="required-dot">*</span></label> <input name="phone"
					class="form-control" placeholder="VD: 0912345678" required
					pattern="0[0-9]{9}" maxlength="10"
					title="Số điện thoại gồm 10 số, bắt đầu bằng 0"
					value="<%=request.getParameter("phone") != null ? request.getParameter("phone") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Giới tính</label> <select name="gender"
					class="form-control">
					<option value="Male">Nam</option>
					<option value="Female">Nữ</option>
				</select>
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Ngày sinh <span
					class="required-dot">*</span></label> <input type="date" name="dob"
					class="form-control" required
					value="<%=request.getParameter("dob") != null ? request.getParameter("dob") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Địa chỉ <span class="required-dot">*</span></label>
				<input name="address" class="form-control"
					placeholder="Nhập địa chỉ" required maxlength="255"
					value="<%=request.getParameter("address") != null ? request.getParameter("address") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Tên đăng nhập <span
					class="required-dot">*</span></label> <input name="username"
					class="form-control" required minlength="4" maxlength="50"
					pattern="[a-zA-Z0-9_\.]{4,50}"
					title="Tên đăng nhập 4-50 ký tự, chỉ gồm chữ, số, _ hoặc ."
					placeholder="Nhập tên đăng nhập"
					value="<%=request.getParameter("username") != null ? request.getParameter("username") : ""%>">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Mật khẩu <span
					class="required-dot">*</span></label> <input type="password"
					name="password" class="form-control" required minlength="6"
					maxlength="100" placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Ảnh đại diện</label> <input type="file"
					name="avatar" class="form-control">
			</div>
		</div>
		<div class="col-md-6">
    <div class="mb-3">
        <label class="form-label">Chọn lớp học</label>

        <%
        List<model.Classroom> cl = (List<model.Classroom>) request.getAttribute("classList");
        %>

        <div class="position-relative" id="classDropdownWrapper">
            <!-- Trigger -->
            <div class="form-control d-flex justify-content-between align-items-center"
                 id="classDropdownTrigger" tabindex="0"
                 style="cursor:pointer; min-height:38px;">
                <span id="classDropdownLabel" class="text-muted">-- Chọn lớp học --</span>
                <i class="bi bi-chevron-down" id="classDropdownArrow"></i>
            </div>

            <!-- Panel -->
            <div id="classDropdownPanel" class="border rounded bg-white shadow-sm"
                 style="display:none; position:absolute; z-index:1000; width:100%; max-height:220px; overflow-y:auto;">

                <!-- Tìm kiếm -->
                <div class="p-2 border-bottom sticky-top bg-white">
                    <input type="text" id="classSearch" class="form-control form-control-sm"
                           placeholder="Tìm lớp học..." autocomplete="off">
                </div>

                <!-- Danh sách -->
                <div id="classOptionList">
                    <% if (cl != null) { for (model.Classroom c : cl) { %>
                    <div class="class-option d-flex align-items-center gap-2 px-3 py-2 border-bottom"
                         style="cursor:pointer;"
                         data-name="<%= ("HP000" + c.getId()) + " - " + c.getName() %>">
                        <input type="checkbox" name="classroomIds"
                               id="cls_<%= c.getId() %>" value="<%= c.getId() %>">
                        <label for="cls_<%= c.getId() %>" style="cursor:pointer; margin:0;">
                            <%= "HP000" + c.getId() %>
                            - <%= c.getName() %>
                        </label>
                    </div>
                    <% } } %>
                </div>
            </div>
        </div>
    </div>
</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-success">
			<i class="fas fa-save me-2"></i>Lưu sinh viên
		</button>
		<a href="<%=request.getContextPath()%>/admin/students"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>
