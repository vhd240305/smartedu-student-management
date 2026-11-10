<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Quản lý sinh viên");
request.setAttribute("activeMenu", "students");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<style>
.search-bar {
	display: flex;
	flex-wrap: wrap;
	gap: 0.75rem;
	align-items: center;
}

.search-bar .form-control {
	flex: 1 1 320px;
	min-width: 220px;
}

.student-table {
	width: 100%;
	min-width: 1400px;
}

.student-table th, .student-table td {
	padding: 0.75rem;
	vertical-align: middle;
	white-space: nowrap;
}

.student-table .col-email {
	min-width: 260px;
}

.student-table .col-name {
	width: 150px;
	max-width: 150px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.student-table .col-stt {
	width: 70px;
	max-width: 70px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.student-table .col-class {
	width: 160px;
	max-width: 160px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
.student-table .col-address {
	width: 105px;
	max-width: 105px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
.student-table .col-actions {
	width: 140px;
	max-width: 140px;
}

.student-table .action-group {
	display: flex;
	justify-content: center;
	gap: 0.5rem;
	flex-wrap: nowrap;
}

@media ( max-width : 991.98px) {
	.search-bar {
		gap: 0.5rem;
	}
	.search-bar .form-control {
		flex-basis: 100%;
		min-width: 0;
	}
	.student-table th, .student-table td {
		padding: 0.6rem;
	}
}
</style>


<h2 class="page-title">Quản lý sinh viên</h2>
<%
List<model.Classroom> classListFilter = (List<model.Classroom>) request.getAttribute("classListFilter");
%>
<div class="toolbar">
	<div class="d-flex gap-2">
		<a href="students?action=add" class="btn btn-success"> <i
			class="fas fa-plus me-2"></i>Thêm sinh viên
		</a> <a href="<%=request.getContextPath()%>/admin/students/import"
			class="btn btn-primary"> <i class="fas fa-file-import me-2"></i>Thêm
			nhiều SV
		</a>
		<button type="button" class="btn btn-danger" id="btnDeleteMultiple"
			onclick="confirmDeleteMultiple()">
			<i class="fas fa-trash me-2"></i>Xóa nhiều SV
		</button>
		<button type="button" class="btn btn-outline-primary"
			onclick="exportTableToExcel('studentTable','danh-sach-sinh-vien.xls')">
			<i class="fas fa-file-excel me-2"></i>Xuất Excel
		</button>
	</div>
</div>

<form method="get" action="<%=request.getContextPath()%>/admin/students"
	class="mb-3" id="filterForm">

	<%-- Giữ lại giá trị filter khi tìm kiếm --%>
	<input type="hidden" name="gender" id="hiddenGender"
		value="${filterGender}"> <input type="hidden"
		name="classroomId" id="hiddenClassroomId" value="${filterClassroomId}">
	<input type="hidden" name="yearOfBirth" id="hiddenYearOfBirth"
		value="${filterYearOfBirth}">

	<%-- Thanh tìm kiếm --%>
	<div class="search-bar mb-2">
		<input type="text" name="keyword" value="${keyword}"
			class="form-control" placeholder="🔍 Tìm theo tên hoặc email...">
		<button class="btn btn-primary">
			<i class="fas fa-search me-1"></i>Tìm kiếm
		</button>
		<button type="button" class="btn btn-secondary" id="btnFilter">
			<i class="fas fa-filter me-1"></i>Bộ lọc
			<%
			boolean hasFilter = (request.getAttribute("filterGender") != null
					&& !request.getAttribute("filterGender").toString().isEmpty())
					|| (request.getAttribute("filterClassroomId") != null
					&& !request.getAttribute("filterClassroomId").toString().isEmpty())
					|| (request.getAttribute("filterYearOfBirth") != null
					&& !request.getAttribute("filterYearOfBirth").toString().isEmpty());
			if (hasFilter) {
			%>
			<span class="badge bg-danger ms-1">!</span>
			<%
			}
			%>
		</button>
		<a href="<%=request.getContextPath()%>/admin/students"
			class="btn btn-secondary"> <i class="fas fa-redo me-1"></i>Đặt
			lại
		</a>
	</div>

	<%-- Panel bộ lọc --%>
	<div id="filterPanel"
		style="display: none; background: var(--bs-light); border: 1px solid #dee2e6; border-radius: 8px; padding: 16px;"
		class="mb-2">
		<div class="row g-3">
			<div class="col-md-4">
				<label class="form-label fw-500">Giới tính</label> <select
					name="genderFilter" id="genderFilter" class="form-control">
					<option value="">-- Chọn giới tính --</option>
					<option value="Male"
						<%="Male".equals(request.getAttribute("filterGender")) ? "selected" : ""%>>Nam</option>
					<option value="Female"
						<%="Female".equals(request.getAttribute("filterGender")) ? "selected" : ""%>>Nữ</option>
				</select>
			</div>
			<div class="col-md-4">
				<label class="form-label">Lớp học</label> <input type="hidden"
					id="classroomIdFilter" value="${filterClassroomId}">
				<div class="position-relative" id="filterClassDropdownWrapper">
					<div
						class="form-control d-flex justify-content-between align-items-center"
						id="filterClassTrigger" tabindex="0"
						style="cursor: pointer; min-height: 38px;">
						<span id="filterClassLabel" class="text-muted">-- Chọn lớp
							học --</span> <i class="bi bi-chevron-down" id="filterClassArrow"></i>
					</div>
					<div id="filterClassPanel"
						class="border rounded bg-white shadow-sm"
						style="display: none; position: absolute; z-index: 1000; width: 100%; max-height: 220px; overflow-y: auto;">
						<div class="p-2 border-bottom"
							style="position: sticky; top: 0; background: white; z-index: 2;">
							<input type="text" id="filterClassSearch"
								class="form-control form-control-sm"
								placeholder="Tìm lớp học..." autocomplete="off">
						</div>
						<div id="filterClassList">
							<div class="filter-class-option px-3 py-2 border-bottom"
								style="cursor: pointer;" data-id="" data-name="-- Tất cả --">
								<span class="text-muted fst-italic">-- Chọn lớp học --</span>
							</div>
							<%
							if (classListFilter != null) {
								for (model.Classroom c : classListFilter) {
									String dataName = c.getName();
							%>
							<div class="filter-class-option px-3 py-2 border-bottom"
								style="cursor: pointer;" data-id="<%=c.getId()%>"
								data-name="<%=dataName%>">
								<%=c.getName()%>
							</div>
							<%
							}
							}
							%>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<label class="form-label">Năm sinh</label> <input type="number"
					id="yearOfBirthFilter" class="form-control"
					placeholder="Ví dụ: 2005" value="${filterYearOfBirth}">
			</div>
		</div>
		<div class="d-flex gap-2 mt-3">
			<button type="button" class="btn btn-primary" id="btnApplyFilter">
				<i class="fas fa-filter me-1"></i>Lọc
			</button>
			<button type="button" class="btn btn-outline-secondary"
				id="btnClearFilter">
				<i class="fas fa-times me-1"></i>Xóa bộ lọc
			</button>
		</div>
	</div>
</form>

<form method="post"
	action="<%=request.getContextPath()%>/admin/students"
	id="deleteMultipleForm">
	<input type="hidden" name="action" value="deleteMultiple">
	<div class="table-responsive">
		<table id="studentTable" class="table table-hover student-table">
			<thead>
				<tr>
					<th><input type="checkbox" id="checkAll"></th>
					<th class="col-stt">STT</th>
					<th>Mã SV</th>
					<th class="col-name">Họ tên</th>
					<th class="col-email">Email</th>
					<th>Điện thoại</th>
					<th>Giới tính</th>
					<th>Ngày sinh</th>
					<th class="col-address">Địa chỉ</th>
					<th class="col-class">Lớp học</th>
					<th>Ảnh</th>
					<th class="col-actions">Thao tác</th>
				</tr>
			</thead>
			<tbody>

				<%
				List<Map<String, Object>> list = (List<Map<String, Object>>) request.getAttribute("list");
				int stt = 0;

				if (list != null) {
					for (Map<String, Object> s : list) {
				%>

				<tr>
					<td><input type="checkbox" name="selectedIds"
						value="<%=s.get("id")%>" class="rowCheck"></td>
					<td class="col-stt"><%=++stt%></td>
					<td><strong><%=("SV000" + s.get("id"))%></strong></td>
					<td class="col-name"><%=s.get("name")%></td>
					<td class="col-email" title="<%=s.get("email")%>"><%=s.get("email")%></td>
					<td><%=s.get("phone")%></td>
					<td><%="Male".equals(s.get("gender")) ? "Nam" : "Nữ"%></td>
					<td><%=s.get("dob")%></td>
					<td class="col-address"><%=s.get("address")%></td>
					<td class="col-class"><%=s.get("classes") != null ? s.get("classes") : "<span class='text-no-data'>Chưa có lớp</span>"%>
					</td>
					<td><img
						src="<%=request.getContextPath()%>/uploads/<%=s.get("avatar")%>"
						class="avatar-table" alt="Ảnh đại diện"></td>

					<td class="col-actions">
						<div class="action-group">
							<a
								href="<%=request.getContextPath()%>/admin/students?action=detail&id=<%=s.get("id")%>"
								class="btn btn-primary btn-sm" title="Xem chi tiết"> <i
								class="fas fa-eye"></i>
							</a> <a
								href="<%=request.getContextPath()%>/admin/students?action=edit&id=<%=s.get("id")%>"
								class="btn btn-warning btn-sm" title="Sửa"> <i
								class="fas fa-edit"></i>
							</a> <a href="#" class="btn btn-danger btn-sm" title="Xóa"
								onclick="confirmDelete('<%=request.getContextPath()%>/admin/students?action=delete&id=<%=s.get("id")%>')">
								<i class="fas fa-trash"></i>
							</a>
						</div>
					</td>
				</tr>

				<%
				}
				}
				%>
			</tbody>
		</table>
	</div>
</form>

<%
int currentPage = (int) request.getAttribute("currentPage");
int totalPages = (int) request.getAttribute("totalPages");
String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
%>

<nav class="mt-3">
	<ul class="pagination justify-content-center">
		<li class="page-item <%=currentPage == 1 ? "disabled" : ""%>"><a
			class="page-link"
			href="students?page=<%=currentPage - 1%>&keyword=<%=keyword%>">
				<< </a></li>
		<%
		for (int i = 1; i <= totalPages; i++) {
		%>
		<li class="page-item <%=i == currentPage ? "active" : ""%>"><a
			class="page-link" href="students?page=<%=i%>&keyword=<%=keyword%>"><%=i%></a></li>
		<%
		}
		%>
		<li class="page-item <%=currentPage == totalPages ? "disabled" : ""%>">
			<a class="page-link"
			href="students?page=<%=currentPage + 1%>&keyword=<%=keyword%>">
				>> </a>
		</li>
	</ul>
</nav>
<style>
.swal2-container * {
	font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		sans-serif !important;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function confirmDelete(url) {
    Swal.fire({
        position: 'top',
        icon: 'warning',
        title: 'Bạn có chắc chắn muốn xóa sinh viên này không?',
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
        toast: true
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = url;
        }
    });
}

<%String successMsg = (String) session.getAttribute("successMsg");
if (successMsg != null) {
	session.removeAttribute("successMsg");%>
Swal.fire({
    position: 'top',
    icon: 'success',
    title: '<%=successMsg%>',
    showConfirmButton: false,
    timer: 4000,
    timerProgressBar: true,
    toast: true
});
<%}%>
</script>

<script>
// Mở/đóng panel filter
document.getElementById('btnFilter').addEventListener('click', function() {
    const panel = document.getElementById('filterPanel');
    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
});

// Mở sẵn panel nếu đang có filter
<%if (hasFilter) {%>
document.getElementById('filterPanel').style.display = 'block';
<%}%>

// Bấm Lọc
document.getElementById('btnApplyFilter').addEventListener('click', function() {
    document.getElementById('hiddenGender').value = document.getElementById('genderFilter').value;
    document.getElementById('hiddenClassroomId').value = document.getElementById('classroomIdFilter').value;
    document.getElementById('hiddenYearOfBirth').value = document.getElementById('yearOfBirthFilter').value;
    document.getElementById('filterForm').submit();
});

// Xóa bộ lọc
document.getElementById('btnClearFilter').addEventListener('click', function() {
    document.getElementById('hiddenGender').value = '';
    document.getElementById('hiddenClassroomId').value = '';
    document.getElementById('hiddenYearOfBirth').value = '';
    document.getElementById('genderFilter').value = '';
    document.getElementById('classroomIdFilter').value = '';
    document.getElementById('yearOfBirthFilter').value = '';
    document.getElementById('filterClassLabel').textContent = '-- Tất cả --';
    document.getElementById('filterClassLabel').className = 'text-muted';
    document.getElementById('filterForm').submit();
});
</script>
<script>
//Filter class dropdown
(function() {
    const wrapper = document.getElementById('filterClassDropdownWrapper');
    const trigger = document.getElementById('filterClassTrigger');
    const panel   = document.getElementById('filterClassPanel');
    const arrow   = document.getElementById('filterClassArrow');
    const lbl     = document.getElementById('filterClassLabel');
    const search  = document.getElementById('filterClassSearch');
    const hidden  = document.getElementById('classroomIdFilter');

    let open = false;

    // Set label nếu đang có filter
    const currentId = hidden.value;
    if (currentId) {
        const opts = document.querySelectorAll('.filter-class-option');
        opts.forEach(opt => {
            if (opt.getAttribute('data-id') == currentId) {
                lbl.textContent = opt.getAttribute('data-name');
                lbl.className = 'text-dark';
                opt.style.background = '#e8f0fe';
                opt.style.fontWeight = '500';
            }
        });
    }

    function openDD() {
        open = true;
        panel.style.display = 'block';
        arrow.style.transform = 'rotate(180deg)';
        search.focus();
    }

    function closeDD() {
        open = false;
        panel.style.display = 'none';
        arrow.style.transform = '';
        document.querySelectorAll('.filter-class-option').forEach(opt => opt.classList.remove('d-none'));
        search.value = '';
    }

    trigger.addEventListener('click', () => open ? closeDD() : openDD());

    document.addEventListener('click', e => {
        if (!wrapper.contains(e.target)) closeDD();
    });

    search.onkeyup = function() {
        const q = this.value.toLowerCase().trim().normalize('NFC');
        document.querySelectorAll('.filter-class-option').forEach(opt => {
            const name = opt.getAttribute('data-name').toLowerCase().normalize('NFC');
            opt.classList.toggle('d-none', !name.includes(q));
        });
    };

    document.querySelectorAll('.filter-class-option').forEach(opt => {
        opt.addEventListener('click', () => {
            const id   = opt.getAttribute('data-id');
            const name = opt.getAttribute('data-name');
            document.querySelectorAll('.filter-class-option').forEach(o => {
                o.style.background = '';
                o.style.fontWeight = '';
            });
            hidden.value = id;
            lbl.textContent = name;
            lbl.className = id ? 'text-dark' : 'text-muted';
            if (id) {
                opt.style.background = '#e8f0fe';
                opt.style.fontWeight = '500';
            }
            closeDD();
        });
    });
})();
</script>
<script>
// Check all
document.getElementById('checkAll').addEventListener('change', function() {
    document.querySelectorAll('.rowCheck').forEach(cb => cb.checked = this.checked);
    updateDeleteButton();
});

// Cập nhật nút xóa nhiều
document.querySelectorAll('.rowCheck').forEach(cb => {
    cb.addEventListener('change', updateDeleteButton);
});

function confirmDeleteMultiple() {
    const count = document.querySelectorAll('.rowCheck:checked').length;
    Swal.fire({
        position: 'top',
        icon: 'warning',
        title: 'Bạn có chắc chắn muốn xóa ' + count + ' sinh viên đã chọn không?',
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
        toast: true
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('deleteMultipleForm').submit();
        }
    });
}
</script>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>