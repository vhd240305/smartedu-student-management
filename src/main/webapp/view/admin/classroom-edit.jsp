<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.*, model.Teacher, model.Classroom"%>

<%
Classroom classroom = (Classroom) request.getAttribute("classroom");
List<Teacher> teachers = (List<Teacher>) request.getAttribute("teacherList");
%>
<%
request.setAttribute("pageTitle", "Cập nhật lớp học");
request.setAttribute("activeMenu", "classrooms");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Cập nhật thông tin lớp học</h2>

<form action="<%=request.getContextPath()%>/admin/classrooms"
	method="post">

	<input type="hidden" name="action" value="update"> <input
		type="hidden" name="id" value="<%=classroom.getId()%>">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Tên lớp <span class="required-dot">*</span></label>
				<input name="name" value="<%=classroom.getName()%>"
					class="form-control" required maxlength="120">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Phòng học <span
					class="required-dot">*</span></label> <input name="room"
					value="<%=classroom.getRoom()%>" class="form-control" required
					maxlength="50">
			</div>
		</div>
		<div class="col-md-12">
			<div class="mb-3">
				<label class="form-label">Mô tả</label>
				<textarea name="description" class="form-control" maxlength="255"
					rows="3"><%=classroom.getDescription()%></textarea>
			</div>
		</div>
		<div class="col-md-6">
    <div class="mb-3">
        <label class="form-label">Giảng viên phụ trách</label>

        <!-- Input submit -->
        <input type="text" name="teacher_id" id="selectedTeacherId" 
               value="<%= classroom.getTeacherId() %>"
               required style="opacity:0; position:absolute; width:1px; height:1px;"
               oninvalid="this.setCustomValidity('Vui lòng chọn giảng viên phụ trách.')"
               oninput="this.setCustomValidity('')">

        <div class="position-relative" id="teacherDropdownWrapper">
            <!-- Trigger -->
            <%
            String selectedTeacherName = "-- Chọn giảng viên --";
            if (teachers != null) {
                for (Teacher t : teachers) {
                    if (t.getId() == classroom.getTeacherId()) {
                        selectedTeacherName = "GV000" + t.getId() + " - " + t.getName();
                        break;
                    }
                }
            }
            %>
            <div class="form-control d-flex justify-content-between align-items-center"
                 id="teacherDropdownTrigger" tabindex="0"
                 style="cursor: pointer; min-height: 38px;">
                <span id="teacherDropdownLabel" class="<%= classroom.getTeacherId() > 0 ? "text-dark" : "text-muted" %>">
                    <%= selectedTeacherName %>
                </span>
                <i class="bi bi-chevron-down" id="teacherDropdownArrow"></i>
            </div>

            <!-- Panel -->
            <div id="teacherDropdownPanel" class="border rounded bg-white shadow-sm"
                 style="display: none; position: absolute; z-index: 1000; width: 100%; max-height: 220px; overflow-y: auto;">

                <!-- Tìm kiếm -->
                <div class="p-2 border-bottom" style="position: sticky; top: 0; background: white; z-index: 2;">
                    <input type="text" id="teacherSearch" class="form-control form-control-sm"
                           placeholder="Tìm giảng viên..." autocomplete="off">
                </div>

                <!-- Danh sách -->
                <div id="teacherOptionList">
                    <% if (teachers != null) { for (Teacher t : teachers) {
                        String dataName = "GV000" + t.getId() + " - " + t.getName();
                        boolean isSelected = t.getId() == classroom.getTeacherId();
                    %>
                    <div class="teacher-option d-flex align-items-center gap-2 px-3 py-2 border-bottom"
                         style="cursor: pointer; <%= isSelected ? "background:#e8f0fe; font-weight:500;" : "" %>"
                         data-id="<%= t.getId() %>"
                         data-name="<%= dataName %>">
                        <%= "GV000" + t.getId() + " - " + t.getName() %>
                    </div>
                    <% } } %>
                </div>
            </div>
        </div>

        <div id="teacherError" style="display:none; color:#dc3545; font-size:13px; margin-top:4px;">
            Vui lòng chọn giảng viên phụ trách.
        </div>
    </div>
</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-primary">
			<i class="fas fa-save me-2"></i>Cập nhật
		</button>
		<a href="<%=request.getContextPath()%>/admin/classrooms"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>