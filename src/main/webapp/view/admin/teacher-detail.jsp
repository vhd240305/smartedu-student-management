<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Teacher" %>
<%@ page import="model.Classroom" %>
<%
request.setAttribute("pageTitle", "Chi tiết giảng viên");
request.setAttribute("activeMenu", "teachers");

Teacher teacher = (Teacher) request.getAttribute("teacher");
List<Classroom> classes = (List<Classroom>) request.getAttribute("classes");
List<Map<String,Object>> students = (List<Map<String,Object>>) request.getAttribute("students");
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp" %>
<style>
	.list-group-item{
		transition: all 0.2s ease;
	}
	.list-group-item:hover {
		background-color: #bcbcbc;          
    	cursor: pointer;
	}
</style>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="page-title mb-0">Chi tiết giảng viên</h2>
    <div class="d-flex gap-2">
        <a href="<%=request.getContextPath()%>/admin/teachers" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-1"></i>Quay lại
        </a>
        <a href="<%=request.getContextPath()%>/admin/teachers?action=edit&id=<%=teacher.getId()%>" class="btn btn-warning">
            <i class="fas fa-edit me-1"></i>Sửa
        </a>
    </div>
</div>

<div class="card shadow-sm mb-3">
    <div class="card-body">
        <div class="row">
            <div class="col-md-6 mb-2"><strong>Mã GV:</strong> <%=("GV000" + teacher.getId())%></div>
            <div class="col-md-6 mb-2"><strong>Họ tên:</strong> <%=teacher.getName()%></div>
            <div class="col-md-6 mb-2"><strong>Email:</strong> <%=teacher.getEmail()%></div>
            <div class="col-md-6 mb-2"><strong>Điện thoại:</strong> <%=teacher.getPhone()%></div>
            <div class="col-12 mb-2"><strong>Bộ môn/Khoa:</strong> <%=teacher.getDepartment()%></div>
        </div>
    </div>
</div>

<div class="row g-3">
    <div class="col-lg-5">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <h5 class="mb-2">Các lớp phụ trách</h5>
                <%
                if (classes == null || classes.isEmpty()) {
                %>
                    <div class="text-muted">Chưa có lớp phụ trách.</div>
                <%
                } else {
                %>
                    <div class="list-group">
                        <%
                        for (Classroom c : classes) {
                        %>
                            <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                               href="<%=request.getContextPath()%>/admin/classrooms?action=detail&id=<%=c.getId()%>">
                                <span>
                                	Lớp học phần:
                                    <strong><%=c.getClassroomCode() != null ? c.getClassroomCode() : c.getName()%></strong>
                                    <span> — Phòng: <strong><%=c.getRoom()%></strong></span>
                                    <!-- đang bỏ class="text-muted"-->
                                </span>
                            </a>
                        <%
                        }
                        %>
                    </div>
                <%
                }
                %>
            </div>
        </div>
    </div>
<!--  
    <div class="col-lg-7">
        <div class="card shadow-sm h-100">
            <div class="card-body">
                <h5 class="mb-2">Sinh viên thuộc các lớp của giảng viên</h5>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Mã SV</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Lớp</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        if (students == null || students.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="6" class="text-muted">Chưa có sinh viên.</td>
                            </tr>
                        <%
                        } else {
                            for (Map<String,Object> s : students) {
                        %>
                            <tr>
                                <td><strong><%=s.get("id")%></strong></td>
                                <td><%=s.get("name")%></td>
                                <td><%=s.get("email")%></td>
                                <td><%=s.get("phone")%></td>
                                <td><%=s.get("class")%></td>
                                <td class="text-end">
                                    <a class="btn btn-sm btn-outline-primary"
                                       href="<%=request.getContextPath()%>/admin/students?action=detail&id=<%=s.get("id")%>">
                                        Chi tiết
                                    </a>
                                </td>
                            </tr>
                        <%
                            }
                        }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    -->
</div>

<%@ include file="/view/admin/partials/admin-layout-bottom.jsp" %>

