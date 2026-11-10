<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Account"%>
<%@ page import="dao.StudentDAO"%>
<%@ page import="dao.TeacherDAO"%>
<%@ page import="dao.ClassroomDAO"%>
<%@ page import="java.util.*"%>
<%@ page import="dao.ScoreDAO"%>

<%
Account acc = (Account) session.getAttribute("account");

if (acc == null || !acc.getRole().equals("admin")) {
	response.sendRedirect("../auth/login.jsp");
	return;
}

// lấy thống kê
StudentDAO dao = new StudentDAO();
int totalStudents = dao.getAll().size();
TeacherDAO teacherDAO = new TeacherDAO();
int totalTeachers = teacherDAO.getAll().size();
ClassroomDAO classroomDAO = new ClassroomDAO();
int totalClassrooms = classroomDAO.getAll().size();
//Thống kê giới tính
Map<String, Integer> genderMap = dao.countByGender();
int maleCount = genderMap.getOrDefault("Male", 0);
int femaleCount = genderMap.getOrDefault("Female", 0);

//Thống kê theo lớp
List<Map<String, Object>> byClassroom = dao.countByClassroom();
request.setAttribute("pageTitle", "Tổng quan hệ thống");
request.setAttribute("activeMenu", "dashboard");
%>
<%
ScoreDAO scoreDAO = new ScoreDAO();
List<Map<String, Object>> gpaByTime = scoreDAO.getAvgGpaByYearAndSemester();

// Tạo labels và data cho chart
StringBuilder chartLabels = new StringBuilder();
StringBuilder chartData = new StringBuilder();
for (int i = 0; i < gpaByTime.size(); i++) {
    Map<String, Object> row = gpaByTime.get(i);
    String label = "HK" + row.get("semester") + " " + row.get("academic_year");
    if (i > 0) { chartLabels.append(","); chartData.append(","); }
    chartLabels.append("'").append(label).append("'");
    chartData.append(row.get("avg_gpa"));
}
//Biểu đồ tròn - đạt/không đạt
Map<String, Integer> passFailMap = scoreDAO.getPassFailCount();
int passCount = passFailMap.getOrDefault("pass", 0);
int failCount = passFailMap.getOrDefault("fail", 0);

//Biểu đồ cột nhóm - phân phối xếp loại
Map<String, Integer> rankMap = scoreDAO.getRankDistribution();
%>
<%@ include file="/view/admin/partials/admin-layout-top.jsp"%>

<h2 class="page-title">Tổng quan hệ thống</h2>

<div class="row g-4 mt-1">
	<div class="col-md-4">
		<div class="stat-card stat-students">
			<div class="stat-icon">
				<i class="fas fa-user-graduate"></i>
			</div>
			<div class="stat-label">Tổng sinh viên</div>
			<div class="stat-value"><%=totalStudents%></div>
		</div>
	</div>

	<div class="col-md-4">
		<div class="stat-card stat-teachers">
			<div class="stat-icon">
				<i class="fas fa-chalkboard-teacher"></i>
			</div>
			<div class="stat-label">Tổng giảng viên</div>
			<div class="stat-value"><%=totalTeachers%></div>
		</div>
	</div>

	<div class="col-md-4">
		<div class="stat-card stat-classrooms">
			<div class="stat-icon">
				<i class="fas fa-school"></i>
			</div>
			<div class="stat-label">Tổng lớp học</div>
			<div class="stat-value"><%=totalClassrooms%></div>
		</div>
	</div>
</div>

<h5 class="mt-4 mb-3" style="font-weight: 600; color: #64748b;">
	<i class="fas fa-bolt me-2"></i>Truy cập nhanh
</h5>
<div class="d-flex gap-2 flex-wrap">
	<a href="<%=request.getContextPath()%>/admin/students"
		class="btn btn-primary"> <i class="fas fa-user-graduate me-2"></i>Quản
		lý sinh viên
	</a> <a href="<%=request.getContextPath()%>/admin/teachers"
		class="btn btn-success"> <i class="fas fa-chalkboard-teacher me-2"></i>Quản
		lý giảng viên
	</a> <a href="<%=request.getContextPath()%>/admin/classrooms"
		class="btn btn-info text-white"> <i class="fas fa-school me-2"></i>Quản
		lý lớp học
	</a> <a href="<%=request.getContextPath()%>/admin/accounts"
		class="btn btn-dark"> <i class="fas fa-users-cog me-2"></i>Quản lý
		tài khoản
	</a>
</div>
<div class="row g-4 mt-2">
    <!-- Biểu đồ tròn giới tính -->
    <div class="col-md-5">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600; color:#64748b;">
                    <i class="fas fa-venus-mars me-2"></i>Sinh viên theo giới tính
                </h6>
                <canvas id="genderChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Biểu đồ cột theo lớp -->
    <div class="col-md-7">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600; color:#64748b;">
                    <i class="fas fa-school me-2"></i>Sinh viên theo lớp học
                </h6>
                <canvas id="classroomChart"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// Biểu đồ tròn giới tính
const genderCtx = document.getElementById('genderChart').getContext('2d');
new Chart(genderCtx, {
    type: 'pie',
    data: {
        labels: ['Nam', 'Nữ'],
        datasets: [{
            data: [<%= maleCount %>, <%= femaleCount %>],
            backgroundColor: ['#4f86f7', '#f472b6'],
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { position: 'bottom' },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                        const percent = ((context.parsed / total) * 100).toFixed(1);
                        return context.label + ': ' + context.parsed + ' (' + percent + '%)';
                    }
                }
            }
        }
    }
});

// Biểu đồ cột theo lớp
const classroomCtx = document.getElementById('classroomChart').getContext('2d');
new Chart(classroomCtx, {
    type: 'bar',
    data: {
        labels: [<% for (int i = 0; i < byClassroom.size(); i++) { %>'<%= byClassroom.get(i).get("name") %>'<% if (i < byClassroom.size()-1) { %>,<% } } %>],
        datasets: [{
            label: 'Số sinh viên',
            data: [<% for (int i = 0; i < byClassroom.size(); i++) { %><%= byClassroom.get(i).get("total") %><% if (i < byClassroom.size()-1) { %>,<% } } %>],
            backgroundColor: '#4f86f7',
            borderRadius: 6,
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: { stepSize: 1 }
            }
        }
    }
});
</script>
<div class="row g-4 mt-2">
    <div class="col-md-12">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600; color:#64748b;">
                    <i class="fas fa-chart-line me-2"></i>Xu hướng điểm trung bình sinh viên theo học kỳ
                </h6>
                <% if (gpaByTime.isEmpty()) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>Chưa có dữ liệu điểm được duyệt.
                </div>
                <% } else { %>
                <canvas id="gpaLineChart" style="max-height:350px;"></canvas>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
<% if (!gpaByTime.isEmpty()) { %>
const gpaLineCtx = document.getElementById('gpaLineChart').getContext('2d');
new Chart(gpaLineCtx, {
    type: 'line',
    data: {
        labels: [<%=chartLabels%>],
        datasets: [{
            label: 'Điểm trung bình',
            data: [<%=chartData%>],
            borderColor: '#6366f1',
            backgroundColor: 'rgba(99,102,241,0.1)',
            borderWidth: 3,
            pointBackgroundColor: '#6366f1',
            pointRadius: 6,
            pointHoverRadius: 8,
            fill: true,
            tension: 0.4
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        return 'Điểm TB: ' + context.parsed.y + '/10';
                    }
                }
            }
        },
        scales: {
            y: {
                beginAtZero: false,
                min: 0,
                max: 10,
                ticks: { stepSize: 1 },
                grid: { color: 'rgba(0,0,0,0.05)' }
            },
            x: {
                grid: { display: false }
            }
        }
    }
});
<% } %>
</script>
<!-- Hàng 1: Biểu đồ tròn -->
<div class="row g-4 mt-2">
    <!-- Biểu đồ tròn đậu/rớt -->
    <div class="col-md-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600; color:#64748b;">
                    <i class="fas fa-chart-pie me-2"></i>Tỉ lệ đạt/không đạt toàn trường
                </h6>
                <% if (passCount == 0 && failCount == 0) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>Chưa có dữ liệu.
                </div>
                <% } else { %>
                <canvas id="passFailChart"></canvas>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Hàng 2: Biểu đồ phân phối xếp loại -->
<div class="row g-4 mt-2">
    <div class="col-md-12">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <h6 class="card-title mb-3" style="font-weight:600; color:#64748b;">
                    <i class="fas fa-chart-bar me-2"></i>Phân phối xếp loại học lực
                </h6>
                <% if (rankMap.isEmpty()) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>Chưa có dữ liệu.
                </div>
                <% } else { %>
                <canvas id="rankChart" style="max-height:280px;"></canvas>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// ===== BIỂU ĐỒ TRÒN ĐẬU/RỚT =====
<% if (passCount > 0 || failCount > 0) { %>
new Chart(document.getElementById('passFailChart').getContext('2d'), {
    type: 'pie',
    data: {
        labels: ['Đạt', 'Không đạt'],
        datasets: [{
            data: [<%=passCount%>, <%=failCount%>],
            backgroundColor: ['#10b981', '#ef4444'],
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { position: 'bottom' },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                        const percent = ((context.parsed / total) * 100).toFixed(1);
                        return context.label + ': ' + context.parsed + ' SV (' + percent + '%)';
                    }
                }
            }
        }
    }
});
<% } %>

// ===== BIỂU ĐỒ CỘT PHÂN PHỐI XẾP LOẠI =====
<% if (!rankMap.isEmpty()) { %>
new Chart(document.getElementById('rankChart').getContext('2d'), {
    type: 'bar',
    data: {
        labels: ['Giỏi', 'Khá', 'Trung bình', 'Yếu'],
        datasets: [{
            label: 'Số sinh viên',
            data: [
                <%=rankMap.getOrDefault("Giỏi", 0)%>,
                <%=rankMap.getOrDefault("Khá", 0)%>,
                <%=rankMap.getOrDefault("Trung bình", 0)%>,
                <%=rankMap.getOrDefault("Yếu", 0)%>
            ],
            backgroundColor: ['#10b981', '#6366f1', '#f59e0b', '#ef4444'],
            borderRadius: 6,
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        return 'Số SV: ' + context.parsed.y;
                    }
                }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: { stepSize: 1 },
                grid: { color: 'rgba(0,0,0,0.05)' }
            },
            x: { grid: { display: false } }
        }
    }
});
<% } %>
</script>
<%@ include file="/view/admin/partials/admin-layout-bottom.jsp"%>