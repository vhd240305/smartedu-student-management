<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%
request.setAttribute("pageTitle", "Thêm lớp học");
request.setAttribute("activeMenu", "classrooms");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>
<h2 class="page-title">Thêm lớp học mới</h2>
<form action="<%=request.getContextPath()%>/admin/classrooms"
	method="post">

	<input type="hidden" name="action" value="insert">

	<div class="row">
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Tên lớp <span class="required-dot">*</span></label>
				<input name="name" placeholder="Nhập tên lớp học"
					class="form-control" required maxlength="120">
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Phòng học <span
					class="required-dot">*</span></label> <input name="room"
					placeholder="VD: P.201" class="form-control" required
					maxlength="50">
			</div>
		</div>
		<div class="col-md-12">
			<div class="mb-3">
				<label class="form-label">Mô tả</label>
				<textarea name="description" class="form-control" maxlength="255"
					rows="3" placeholder="Nhập mô tả lớp học (không bắt buộc)"></textarea>
			</div>
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label class="form-label">Giảng viên phụ trách</label>
				<%
				List<model.Teacher> teachers = (List<model.Teacher>) request.getAttribute("teacherList");
				%>

				<!-- Hidden input để submit giá trị -->
				<input type="text" name="teacher_id" id="selectedTeacherId" value=""
       required style="opacity:0; position:absolute; width:1px; height:1px;"
       oninvalid="this.setCustomValidity('Vui lòng chọn giảng viên phụ trách.')"
       oninput="this.setCustomValidity('')">

				<div class="position-relative" id="teacherDropdownWrapper">
					<!-- Trigger -->
					<div
						class="form-control d-flex justify-content-between align-items-center"
						id="teacherDropdownTrigger" tabindex="0"
						style="cursor: pointer; min-height: 38px;">
						<span id="teacherDropdownLabel" class="text-muted">-- Chọn
							giảng viên --</span> <i class="bi bi-chevron-down"
							id="teacherDropdownArrow"></i>
					</div>

					<!-- Panel -->
					<div id="teacherDropdownPanel"
						class="border rounded bg-white shadow-sm"
						style="display: none; position: absolute; z-index: 1000; width: 100%; max-height: 220px; overflow-y: auto;">

						<!-- Tìm kiếm -->
						<div class="p-2 border-bottom"
							style="position: sticky; top: 0; background: white; z-index: 2;">
							<input type="text" id="teacherSearch"
								class="form-control form-control-sm"
								placeholder="Tìm giảng viên..." autocomplete="off">
						</div>


						<!-- Danh sách -->
						<div id="teacherOptionList">
							<%
							if (teachers != null) {
								for (model.Teacher t : teachers) {
									String dataName = "GV000" + t.getId() + " - " + t.getName();
							%>
							<div
								class="teacher-option d-flex align-items-center gap-2 px-3 py-2 border-bottom"
								style="cursor: pointer;" data-id="<%=t.getId()%>"
								data-name="<%=dataName%>">
								<%= "GV000" + t.getId() + " - " + t.getName()%>
							</div>
							<%
							}
							}
							%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="d-flex gap-2 mt-2">
		<button class="btn btn-success">
			<i class="fas fa-save me-2"></i>Lưu lớp học
		</button>
		<a href="<%=request.getContextPath()%>/admin/classrooms"
			class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Hủy</a>
	</div>

</form>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>