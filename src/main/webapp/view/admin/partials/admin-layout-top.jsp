<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Account"%>
<%
Account adminAccount = (Account) session.getAttribute("account");
String pageTitle = (String) request.getAttribute("pageTitle");
if (pageTitle == null || pageTitle.trim().isEmpty()) {
	pageTitle = "Quản trị hệ thống";
}
String activeMenu = (String) request.getAttribute("activeMenu");
String contextPath = request.getContextPath();
String firstLetter = "A";
if (adminAccount != null && adminAccount.getUsername() != null && !adminAccount.getUsername().isEmpty()) {
	firstLetter = adminAccount.getUsername().substring(0, 1).toUpperCase();
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=pageTitle%> — QLSV</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="<%=contextPath%>/assets/css/admin.css" rel="stylesheet">
</head>
<body>
	<div class="admin-shell">
		<aside class="admin-sidebar">
			<div>
				<div class="brand-section">
					<div class="brand">🎓 Admin QLSV</div>
					<div class="brand-subtitle">Hệ thống quản lý sinh viên
						SmartEdu</div>
				</div>
				<div class="user-info">
					<div class="user-avatar"><%=firstLetter%></div>
					<div>
						<div class="user-name"><%=adminAccount != null ? adminAccount.getUsername() : "Admin"%></div>
						<div class="user-role">Quản trị viên</div>
					</div>
				</div>
				<nav class="nav flex-column gap-1">
					<a
						class="admin-nav-link <%="dashboard".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/view/admin/home.jsp"> <i
						class="fas fa-chart-pie"></i> Tổng quan
					</a> <a
						class="admin-nav-link <%="students".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/admin/students"> <i
						class="fas fa-user-graduate"></i> Quản lý sinh viên
					</a> <a
						class="admin-nav-link <%="teachers".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/admin/teachers"> <i
						class="fas fa-chalkboard-teacher"></i> Quản lý giảng viên
					</a> <a
						class="admin-nav-link <%="classrooms".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/admin/classrooms"> <i
						class="fas fa-school"></i> Quản lý lớp học
					</a> <a
						class="admin-nav-link <%="scores".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/admin/scores"> <i class="fas fa-star"></i>
						Quản lý điểm số
					</a> <a
						class="admin-nav-link <%="schedules".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/admin/schedules"> <i
						class="fas fa-calendar-week"></i> Thời khóa biểu
					</a><a
						class="admin-nav-link <%="accounts".equals(activeMenu) ? "active" : ""%>"
						href="<%=contextPath%>/admin/accounts"> <i
						class="fas fa-users-cog"></i> Quản lý tài khoản
					</a>
				</nav>
			</div>
			<div class="sidebar-footer">
				<a href="<%=contextPath%>/logout" class="btn-logout"> <i
					class="fas fa-sign-out-alt"></i> Đăng xuất
				</a>
			</div>
		</aside>
		<main class="admin-content">
			<div class="content-card">
				<script>
					function exportTableToExcel(tableId, filename) {
						var table = document.getElementById(tableId);
						if (!table) {
							alert("Không tìm thấy bảng dữ liệu để xuất.");
							return;
						}

						var html = "<html><head><meta charset='UTF-8'></head><body>"
								+ table.outerHTML + "</body></html>";
						var blob = new Blob([ html ], {
							type : "application/vnd.ms-excel;charset=utf-8;"
						});
						var link = document.createElement("a");
						link.href = URL.createObjectURL(blob);
						link.download = filename || "du-lieu.xls";
						document.body.appendChild(link);
						link.click();
						document.body.removeChild(link);
					}
				</script>