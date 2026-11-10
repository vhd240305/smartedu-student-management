package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Student;
import model.Account;
import dao.AccountDAO;
import dao.ClassroomDAO;
import dao.StudentDAO;

import java.io.IOException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@MultipartConfig
@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
	private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9}$");
	private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_.]{4,50}$");

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
		StudentDAO dao = new StudentDAO();

		if (action == null) {
		    int page = 1;
		    int pageSize = 6;
		    try {
		        page = Integer.parseInt(request.getParameter("page"));
		    } catch (Exception e) {}

		    int offset = (page - 1) * pageSize;
		    String keyword = request.getParameter("keyword");
		    String gender = request.getParameter("gender");
		    String classroomId = request.getParameter("classroomId");
		    String yearOfBirth = request.getParameter("yearOfBirth");

		    // Chuẩn hóa
		    if (keyword != null && keyword.trim().isEmpty()) keyword = null;
		    if (gender != null && gender.trim().isEmpty()) gender = null;
		    if (classroomId != null && classroomId.trim().isEmpty()) classroomId = null;
		    if (yearOfBirth != null && yearOfBirth.trim().isEmpty()) yearOfBirth = null;

		    int totalRecords = dao.countWithFilter(keyword, gender, classroomId, yearOfBirth);
		    List<Map<String, Object>> list = dao.getWithFilterAndKeyword(keyword, gender, classroomId, yearOfBirth, offset, pageSize);
		    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
		    if (totalPages == 0) totalPages = 1;

		    // Load danh sách lớp cho filter
		    ClassroomDAO cdao = new ClassroomDAO();
		    request.setAttribute("classListFilter", cdao.getAll());

		    request.setAttribute("list", list);
		    request.setAttribute("currentPage", page);
		    request.setAttribute("totalPages", totalPages);
		    request.setAttribute("keyword", keyword != null ? keyword : "");
		    request.setAttribute("filterGender", gender != null ? gender : "");
		    request.setAttribute("filterClassroomId", classroomId != null ? classroomId : "");
		    request.setAttribute("filterYearOfBirth", yearOfBirth != null ? yearOfBirth : "");

		    request.getRequestDispatcher("/view/admin/student-list.jsp").forward(request, response);

		} else if (action.equals("add")) {

			ClassroomDAO cdao = new ClassroomDAO();
			request.setAttribute("classList", cdao.getAll());

			request.getRequestDispatcher("/view/admin/student-add.jsp").forward(request, response);

		} else if (action.equals("edit")) {

			int id = Integer.parseInt(request.getParameter("id"));

			request.setAttribute("student", dao.getById(id));

			// Tất cả lớp
			ClassroomDAO cdao = new ClassroomDAO();
			request.setAttribute("classList", cdao.getAll());

			// Lớp đã chọn
			request.setAttribute("selectedClasses", dao.getClassroomIdsByStudent(id));

			request.getRequestDispatcher("/view/admin/student-edit.jsp").forward(request, response);
		} else if (action.equals("detail")) {

			int id = Integer.parseInt(request.getParameter("id"));

			Student student = dao.getById(id);
			if (student == null) {
				response.sendRedirect(request.getContextPath() + "/admin/students");
				return;
			}

			request.setAttribute("student", student);
			request.setAttribute("classes", dao.getClassesByStudent(id));

			request.getRequestDispatcher("/view/admin/student-detail.jsp").forward(request, response);
		} else if (action.equals("delete")) {

			int id = Integer.parseInt(request.getParameter("id"));

			dao.delete(id);
			request.getSession().setAttribute("successMsg", "Xóa sinh viên thành công!");
			response.sendRedirect(request.getContextPath() + "/admin/students");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		StudentDAO dao = new StudentDAO();

		if ("insert".equals(action)) {
			String name = safeTrim(request.getParameter("name"));
			String email = safeTrim(request.getParameter("email"));
			String phone = safeTrim(request.getParameter("phone"));
			String gender = safeTrim(request.getParameter("gender"));
			String dob = safeTrim(request.getParameter("dob"));
			String address = safeTrim(request.getParameter("address"));
			String username = safeTrim(request.getParameter("username"));
			String password = request.getParameter("password");

			String validationError = validateStudentData(name, email, phone, gender, dob, address);
			if (validationError != null) {
				ClassroomDAO cdao = new ClassroomDAO();
				request.setAttribute("classList", cdao.getAll());
				request.setAttribute("error", validationError);
				request.getRequestDispatcher("/view/admin/student-add.jsp").forward(request, response);
				return;
			}

			if (!USERNAME_PATTERN.matcher(username).matches()) {
				ClassroomDAO cdao = new ClassroomDAO();
				request.setAttribute("classList", cdao.getAll());
				request.setAttribute("error", "Username phai tu 4-50 ky tu, chi gom chu, so, _ hoac .");
				request.getRequestDispatcher("/view/admin/student-add.jsp").forward(request, response);
				return;
			}

			if (password == null || password.length() < 6) {
				ClassroomDAO cdao = new ClassroomDAO();
				request.setAttribute("classList", cdao.getAll());
				request.setAttribute("error", "Mat khau phai co it nhat 6 ky tu.");
				request.getRequestDispatcher("/view/admin/student-add.jsp").forward(request, response);
				return;
			}

			Student s = new Student();

			s.setName(name);
			s.setEmail(email);
			s.setPhone(phone);
			s.setGender(gender);
			s.setDob(dob);
			s.setAddress(address);

			// Upload avatar
			Part filePart = request.getPart("avatar");
			String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;

			if (fileName != null && !fileName.isEmpty()) {

				String uploadPath = getServletContext().getRealPath("/uploads");
				if (uploadPath == null) {
					uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
				}

				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists())
					uploadDir.mkdirs();

				String safeFileName = fileName.replace("\\", "_").replace("/", "_").replaceAll("\\s+", "_");
				String newFileName = System.currentTimeMillis() + "_" + safeFileName;
				filePart.write(uploadPath + File.separator + newFileName);

				s.setAvatar(newFileName);
			}

			// Tạo account trước
			AccountDAO accountDAO = new AccountDAO();
			if (accountDAO.existsByUsername(username)) {
				ClassroomDAO cdao = new ClassroomDAO();
				request.setAttribute("classList", cdao.getAll());
				request.setAttribute("error", "Username da ton tai.");
				request.getRequestDispatcher("/view/admin/student-add.jsp").forward(request, response);
				return;
			}

			int accountId = accountDAO.create(username, password, "student");

			// Gắn account_id cho student
			s.setAccountId(accountId);

			// Insert student
			int studentId = dao.insertAndGetId(s);

			// Assign classroom
			String[] classIds = request.getParameterValues("classroomIds");

			if (classIds != null) {
				for (String cid : classIds) {
					dao.assignToClassroom(studentId, Integer.parseInt(cid));
				}
			}
			request.getSession().setAttribute("successMsg", "Thêm sinh viên thành công!");
			response.sendRedirect("students");
		}

		else if ("update".equals(action)) {
			String name = safeTrim(request.getParameter("name"));
			String email = safeTrim(request.getParameter("email"));
			String phone = safeTrim(request.getParameter("phone"));
			String gender = safeTrim(request.getParameter("gender"));
			String dob = safeTrim(request.getParameter("dob"));
			String address = safeTrim(request.getParameter("address"));

			Student s = new Student();

			s.setId(Integer.parseInt(request.getParameter("id")));
			s.setName(name);
			s.setEmail(email);
			s.setPhone(phone);
			s.setGender(gender);
			s.setDob(dob);
			s.setAddress(address);

			String validationError = validateStudentData(name, email, phone, gender, dob, address);
			if (validationError != null) {
				ClassroomDAO cdao = new ClassroomDAO();
				request.setAttribute("classList", cdao.getAll());
				String[] classIds = request.getParameterValues("classroomIds");
				List<Integer> selected = new ArrayList<>();
				if (classIds != null) {
					for (String cid : classIds) {
						selected.add(Integer.parseInt(cid));
					}
				}
				request.setAttribute("selectedClasses", selected);
				request.setAttribute("student", s);
				request.setAttribute("error", validationError);
				request.getRequestDispatcher("/view/admin/student-edit.jsp").forward(request, response);
				return;
			}

			Part filePart = request.getPart("avatar");
			String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;

			if (fileName != null && !fileName.isEmpty()) {

				String uploadPath = getServletContext().getRealPath("/uploads");
				if (uploadPath == null) {
					uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
				}

				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists())
					uploadDir.mkdirs();

				String safeFileName = fileName.replace("\\", "_").replace("/", "_").replaceAll("\\s+", "_");
				String newFileName = System.currentTimeMillis() + "_" + safeFileName;
				filePart.write(uploadPath + File.separator + newFileName);

				s.setAvatar(newFileName);
			} else {
				// GIỮ AVATAR CŨ
				Student old = dao.getById(s.getId());
				s.setAvatar(old.getAvatar());
			}

			dao.update(s);

			// XÓA CLASS CŨ
			dao.deleteStudentClassrooms(s.getId());

			// THÊM LẠI CLASS MỚI
			String[] classIds = request.getParameterValues("classroomIds");

			if (classIds != null) {
				for (String cid : classIds) {
					dao.assignToClassroom(s.getId(), Integer.parseInt(cid));
				}
			}
			request.getSession().setAttribute("successMsg", "Cập nhật sinh viên thành công!");
			response.sendRedirect("students");
		}
		else if ("deleteMultiple".equals(action)) {
		    String[] ids = request.getParameterValues("selectedIds");
		    if (ids != null && ids.length > 0) {
		        List<Integer> idList = new ArrayList<>();
		        for (String id : ids) {
		            idList.add(Integer.parseInt(id));
		        }
		        dao.deleteMultiple(idList);
		        request.getSession().setAttribute("successMsg", "Đã xóa " + ids.length + " sinh viên thành công!");
		    }
		    response.sendRedirect(request.getContextPath() + "/admin/students");
		}
	}

	private String safeTrim(String value) {
		return value == null ? "" : value.trim();
	}

	private String validateStudentData(String name, String email, String phone, String gender, String dob,
			String address) {
		if (name.isEmpty())
			return "Ho ten sinh vien khong duoc de trong.";
		if (!EMAIL_PATTERN.matcher(email).matches())
			return "Email khong dung dinh dang.";
		if (!PHONE_PATTERN.matcher(phone).matches())
			return "So dien thoai phai gom 10 so va bat dau bang 0.";
		if (!"Male".equals(gender) && !"Female".equals(gender))
			return "Gioi tinh khong hop le.";
		if (address.isEmpty())
			return "Dia chi khong duoc de trong.";
		try {
			LocalDate dobDate = LocalDate.parse(dob);
			if (dobDate.isAfter(LocalDate.now().minusYears(18))) {
				return "Ngay sinh khong hop le.";
			}
		} catch (Exception ex) {
			return "Ngay sinh khong hop le.";
		}
		return null;
	}
}