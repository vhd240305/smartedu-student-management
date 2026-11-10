package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Teacher;
import model.Classroom;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import dao.AccountDAO;
import dao.ClassroomDAO;
import dao.StudentDAO;
import dao.TeacherDAO;

@WebServlet("/admin/teachers")
public class TeacherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
	private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9}$");
	private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_.]{4,50}$");

	public TeacherServlet() {
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Account acc = (Account) session.getAttribute("account");
//
//		if (acc == null || !acc.getRole().equals("admin")) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		String action = request.getParameter("action");
		TeacherDAO dao = new TeacherDAO();

		if (action == null) {
		    int page = 1;
		    int pageSize = 5;
		    try {
		        page = Integer.parseInt(request.getParameter("page"));
		    } catch (Exception e) {}

		    int offset = (page - 1) * pageSize;
		    String keyword = request.getParameter("keyword");
		    String department = request.getParameter("department");
		    String hasClass = request.getParameter("hasClass");

		    if (keyword != null && keyword.trim().isEmpty()) keyword = null;
		    if (department != null && department.trim().isEmpty()) department = null;
		    if (hasClass != null && hasClass.trim().isEmpty()) hasClass = null;

		    int totalRecords = dao.countWithFilter(keyword, department, hasClass);
		    List<Map<String, Object>> list = dao.getWithFilterAndKeyword(keyword, department, hasClass, offset, pageSize);
		    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
		    if (totalPages == 0) totalPages = 1;

		    request.setAttribute("departmentList", dao.getAllDepartments());
		    request.setAttribute("list", list);
		    request.setAttribute("currentPage", page);
		    request.setAttribute("totalPages", totalPages);
		    request.setAttribute("keyword", keyword != null ? keyword : "");
		    request.setAttribute("filterDepartment", department != null ? department : "");
		    request.setAttribute("filterHasClass", hasClass != null ? hasClass : "");

		    request.getRequestDispatcher("/view/admin/teacher-list.jsp").forward(request, response);
		} else if ("add".equals(action)) {

			request.getRequestDispatcher("/view/admin/teacher-add.jsp").forward(request, response);

		} else if ("edit".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));
			request.setAttribute("teacher", dao.getById(id));

			request.getRequestDispatcher("/view/admin/teacher-edit.jsp").forward(request, response);
		} else if ("detail".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));

			Teacher teacher = dao.getById(id);
			if (teacher == null) {
				response.sendRedirect(request.getContextPath() + "/admin/teachers");
				return;
			}

			ClassroomDAO cdao = new ClassroomDAO();
			StudentDAO sdao = new StudentDAO();

			List<Classroom> classes = cdao.getByTeacherId(id);
			List<Map<String, Object>> students = sdao.getStudentsByTeacher(id);

			request.setAttribute("teacher", teacher);
			request.setAttribute("classes", classes);
			request.setAttribute("students", students);

			request.getRequestDispatcher("/view/admin/teacher-detail.jsp").forward(request, response);

		} else if ("delete".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));
			dao.delete(id);
			request.getSession().setAttribute("successMsg", "Xóa giảng viên thành công!");
			response.sendRedirect("teachers");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		TeacherDAO dao = new TeacherDAO();

		if ("insert".equals(action)) {
			String name = safeTrim(request.getParameter("name"));
			String email = safeTrim(request.getParameter("email"));
			String phone = safeTrim(request.getParameter("phone"));
			String department = safeTrim(request.getParameter("department"));
			String username = safeTrim(request.getParameter("username"));
			String password = request.getParameter("password");

			String validationError = validateTeacherData(name, email, phone, department);
			if (validationError != null) {
				request.setAttribute("error", validationError);
				request.getRequestDispatcher("/view/admin/teacher-add.jsp").forward(request, response);
				return;
			}

			if (!USERNAME_PATTERN.matcher(username).matches()) {
				request.setAttribute("error", "Username phai tu 4-50 ky tu, chi gom chu, so, _ hoac .");
				request.getRequestDispatcher("/view/admin/teacher-add.jsp").forward(request, response);
				return;
			}

			if (password == null || password.length() < 6) {
				request.setAttribute("error", "Mat khau phai co it nhat 6 ky tu.");
				request.getRequestDispatcher("/view/admin/teacher-add.jsp").forward(request, response);
				return;
			}

			Teacher t = new Teacher();

			t.setName(name);
			t.setEmail(email);
			t.setPhone(phone);
			t.setDepartment(department);

			AccountDAO accountDAO = new AccountDAO();
			if (accountDAO.existsByUsername(username)) {
				request.setAttribute("error", "Username da ton tai.");
				request.getRequestDispatcher("/view/admin/teacher-add.jsp").forward(request, response);
				return;
			}

			int accountId = accountDAO.create(username, password, "teacher");

			t.setAccountId(accountId);

			dao.insert(t);
			request.getSession().setAttribute("successMsg", "Thêm giảng viên thành công!");
			response.sendRedirect("teachers");
		} else if ("update".equals(action)) {
			String name = safeTrim(request.getParameter("name"));
			String email = safeTrim(request.getParameter("email"));
			String phone = safeTrim(request.getParameter("phone"));
			String department = safeTrim(request.getParameter("department"));

			String validationError = validateTeacherData(name, email, phone, department);
			if (validationError != null) {
				Teacher current = new Teacher();
				current.setId(Integer.parseInt(request.getParameter("id")));
				current.setName(name);
				current.setEmail(email);
				current.setPhone(phone);
				current.setDepartment(department);
				request.setAttribute("teacher", current);
				request.setAttribute("error", validationError);
				request.getRequestDispatcher("/view/admin/teacher-edit.jsp").forward(request, response);
				return;
			}

			Teacher t = new Teacher();

			t.setId(Integer.parseInt(request.getParameter("id")));
			t.setName(name);
			t.setEmail(email);
			t.setPhone(phone);
			t.setDepartment(department);

			dao.update(t);
			request.getSession().setAttribute("successMsg", "Cập nhật giảng viên thành công!");
			response.sendRedirect("teachers");
		}
	}

	private String safeTrim(String value) {
		return value == null ? "" : value.trim();
	}

	private String validateTeacherData(String name, String email, String phone, String department) {
		if (name.isEmpty())
			return "Ho ten giang vien khong duoc de trong.";
		if (!EMAIL_PATTERN.matcher(email).matches())
			return "Email khong dung dinh dang.";
		if (!PHONE_PATTERN.matcher(phone).matches())
			return "So dien thoai phai gom 10 so va bat dau bang 0.";
		if (department.isEmpty())
			return "Khoa/Bo mon khong duoc de trong.";
		return null;
	}
}
