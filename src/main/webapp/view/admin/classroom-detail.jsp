<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Classroom"%>
<%@ page import="model.Teacher"%>
<%@ page import="model.Student"%>
<%
request.setAttribute("pageTitle", "Chi tiết lớp học");
request.setAttribute("activeMenu", "classrooms");

Classroom classroom = (Classroom) request.getAttribute("classroom");
Teacher teacher = (Teacher) request.getAttribute("teacher");
List<Student> students = (List<Student>) request.getAttribute("students");
List<Student> availableStudents = (List<Student>) request.getAttribute("availableStudents");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<style>
.classroom-info .info-item { margin-bottom: 0.75rem; line-height: 1.5; }
.students-table { table-layout: fixed; width: 100%; }
.students-table th, .students-table td { vertical-align: middle; padding: 0.75rem; }
.students-table td { word-break: break-word; }
.students-table .col-email { min-width: 220px; }
</style>

<%
String successMsg = (String) session.getAttribute("successMsg");
if (successMsg != null) {
    session.removeAttribute("successMsg");
    String safeMsg = successMsg.replace("'", "\\'");
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>.swal2-container * { font-family: 'Inter', sans-serif !important; }</style>
<script>
Swal.fire({
    position: 'top', icon: 'success', title: '<%=safeMsg%>',
    showConfirmButton: false, timer: 4000, timerProgressBar: true, toast: true
});
</script>
<% } %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="page-title mb-0">Chi tiết lớp học</h2>
    <div class="d-flex gap-2">
        <a href="<%=request.getContextPath()%>/admin/classrooms" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-1"></i>Quay lại
        </a>
        <a href="<%=request.getContextPath()%>/admin/classrooms?action=edit&id=<%=classroom.getId()%>"
           class="btn btn-warning">
            <i class="fas fa-edit me-1"></i>Sửa
        </a>
    </div>
</div>

<!-- Thông tin lớp -->
<div class="card shadow-sm mb-3">
    <div class="card-body">
        <div class="row classroom-info">
            <div class="col-md-6 info-item"><strong>Mã lớp:</strong> <%=("HP000" + classroom.getId())%></div>
            <div class="col-md-6 info-item"><strong>Tên lớp:</strong> <%=classroom.getName()%></div>
            <div class="col-md-6 info-item"><strong>Phòng:</strong> <%=classroom.getRoom()%></div>
            <div class="col-12 info-item"><strong>Mô tả:</strong> <%=classroom.getDescription()%></div>
            <div class="col-12 info-item">
                <strong>Giảng viên phụ trách:</strong>
                <% if (teacher == null) { %>
                <span class="text-no-data">Chưa phân công</span>
                <% } else { %>
                <a href="<%=request.getContextPath()%>/admin/teachers?action=detail&id=<%=teacher.getId()%>">
                    <%=teacher.getTeacherCode() != null ? teacher.getTeacherCode() + " - " : ""%><%=teacher.getName()%>
                </a>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Danh sách sinh viên -->
<div class="card shadow-sm">
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Danh sách sinh viên trong lớp
                <span class="badge bg-primary ms-2"><%=students != null ? students.size() : 0%></span>
            </h5>
            <div class="d-flex gap-2">
    <button type="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addStudentModal">
        <i class="fas fa-user-plus me-1"></i>Thêm sinh viên
    </button>
    <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#importStudentModal">
        <i class="fas fa-file-import me-1"></i>Import Excel
    </button>
</div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover students-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã SV</th>
                        <th>Họ tên</th>
                        <th class="col-email">Email</th>
                        <th>Điện thoại</th>
                        <th>Giới tính</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (students == null || students.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="text-muted text-center py-4">
                            <i class="fas fa-inbox me-2"></i>Chưa có sinh viên trong lớp.
                        </td>
                    </tr>
                    <% } else {
                    int stt = 0;
                    for (Student s : students) { %>
                    <tr>
                        <td><%=++stt%></td>
                        <td><strong><%=s.getStudentCode() != null ? s.getStudentCode() : ("SV000" + s.getId())%></strong></td>
                        <td><%=s.getName()%></td>
                        <td class="col-email" title="<%=s.getEmail()%>"><%=s.getEmail()%></td>
                        <td><%=s.getPhone()%></td>
                        <td><%="Male".equals(s.getGender()) ? "Nam" : "Nữ"%></td>
                        <td>
                            <div class="d-flex gap-1">
                                <a href="<%=request.getContextPath()%>/admin/students?action=detail&id=<%=s.getId()%>"
                                   class="btn btn-sm btn-primary" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <form method="post" action="<%=request.getContextPath()%>/admin/classrooms" style="display:inline;">
                                    <input type="hidden" name="action" value="removeStudent">
                                    <input type="hidden" name="classroomId" value="<%=classroom.getId()%>">
                                    <input type="hidden" name="studentId" value="<%=s.getId()%>">
                                    <button type="button" class="btn btn-sm btn-danger" title="Xóa khỏi lớp"
                                            onclick="confirmRemove(this, '<%=s.getName()%>')">
                                        <i class="fas fa-user-minus"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal thêm sinh viên -->
<div class="modal fade" id="addStudentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i>Thêm sinh viên vào lớp</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/admin/classrooms">
                <input type="hidden" name="action" value="addStudent">
                <input type="hidden" name="classroomId" value="<%=classroom.getId()%>">
                <div class="modal-body">
                    <!-- Ô tìm kiếm -->
                    <div class="mb-3">
                        <input type="text" id="searchStudent" class="form-control"
                               placeholder="🔍 Tìm theo tên hoặc mã sinh viên..."
                               oninput="filterStudents()">
                    </div>

                    <% if (availableStudents == null || availableStudents.isEmpty()) { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>Tất cả sinh viên đã có trong lớp này.
                    </div>
                    <% } else { %>
                    <div style="max-height: 350px; overflow-y: auto;">
                        <table class="table table-hover table-sm" id="availableTable">
                            <thead class="sticky-top bg-white">
                                <tr>
                                    <th><input type="checkbox" id="checkAllStudents" onclick="toggleAll()"></th>
                                    <th>Mã SV</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Student s : availableStudents) { %>
                                <tr class="student-row" data-name="<%=s.getName().toLowerCase()%>"
                                    data-code="<%=("sv000" + s.getId()).toLowerCase()%>">
                                    <td>
                                        <input type="checkbox" name="studentIds" value="<%=s.getId()%>" class="student-check">
                                    </td>
                                    <td><strong>SV000<%=s.getId()%></strong></td>
                                    <td><%=s.getName()%></td>
                                    <td><%=s.getEmail()%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>
                </div>
                <div class="modal-footer">
                    <span id="selectedCount" class="text-muted me-auto">Chưa chọn sinh viên nào</span>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-user-plus me-1"></i>Thêm vào lớp
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Modal Import Excel -->
<div class="modal fade" id="importStudentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-file-import me-2"></i>Import sinh viên từ Excel</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/admin/classrooms/import-students"
                  enctype="multipart/form-data">
                <input type="hidden" name="classroomId" value="<%=classroom.getId()%>">
                <div class="modal-body">

                    <%
                    String importErrors = (String) session.getAttribute("importErrors");
                    if (importErrors != null) {
                        session.removeAttribute("importErrors");
                    %>
                    <div class="alert alert-warning">
                        <strong>Chi tiết lỗi:</strong><br><%=importErrors%>
                    </div>
                    <% } %>

                    <div class="alert alert-info" style="font-size:13px;">
                        <i class="fas fa-info-circle me-2"></i>
                        File Excel cần có cột <strong>Mã sinh viên</strong> (VD: SV0001).
                        <a href="<%=request.getContextPath()%>/admin/classrooms/import-students?action=template&classroomId=<%=classroom.getId()%>"
                           class="btn btn-outline-primary btn-sm ms-2">
                            <i class="fas fa-download me-1"></i>Tải file mẫu
                        </a>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Chọn file Excel (.xlsx)</label>
                        <input type="file" name="excelFile" class="form-control" accept=".xlsx" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-upload me-1"></i>Import
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
// Tìm kiếm sinh viên trong modal
function filterStudents() {
    const q = document.getElementById('searchStudent').value.toLowerCase().normalize('NFC');
    document.querySelectorAll('.student-row').forEach(row => {
        const name = row.getAttribute('data-name').normalize('NFC');
        const code = row.getAttribute('data-code').normalize('NFC');
        row.style.display = name.includes(q) || code.includes(q) ? '' : 'none';
    });
}

// Check all
function toggleAll() {
    const checked = document.getElementById('checkAllStudents').checked;
    document.querySelectorAll('.student-check').forEach(cb => cb.checked = checked);
    updateSelectedCount();
}

// Cập nhật số lượng đã chọn
document.querySelectorAll('.student-check').forEach(cb => {
    cb.addEventListener('change', updateSelectedCount);
});

function updateSelectedCount() {
    const count = document.querySelectorAll('.student-check:checked').length;
    document.getElementById('selectedCount').textContent =
        count > 0 ? 'Đã chọn ' + count + ' sinh viên' : 'Chưa chọn sinh viên nào';
}

// Xác nhận xóa sinh viên khỏi lớp
function confirmRemove(btn, name) {
    Swal.fire({
        position: 'top',
        icon: 'warning',
        title: 'Xóa ' + name + ' khỏi lớp?',
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
        toast: true
    }).then((result) => {
        if (result.isConfirmed) {
            btn.closest('form').submit();
        }
    });
}
</script>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>