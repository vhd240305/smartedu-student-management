package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import model.Account;
import model.Student;
import dao.StudentDAO;

import java.io.File;
import java.io.IOException;

@WebServlet("/student/profile")
@MultipartConfig
public class StudentProfileServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");

//		if (acc == null || !"student".equals(acc.getRole())) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		StudentDAO dao = new StudentDAO();

		Student student = dao.getByAccountId(acc.getId());

		request.setAttribute("student", student);

		request.getRequestDispatcher("/view/student/profile.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Account acc = (Account) session.getAttribute("account");

		if (acc == null || !"student".equals(acc.getRole())) {
			response.sendRedirect("../view/auth/login.jsp");
			return;
		}

		StudentDAO dao = new StudentDAO();
		Student current = dao.getByAccountId(acc.getId());
		if (current == null) {
			response.sendRedirect(request.getContextPath() + "/logout");
			return;
		}

		Student s = new Student();

		s.setId(current.getId());
		s.setName(request.getParameter("name"));
		s.setEmail(request.getParameter("email"));
		s.setPhone(request.getParameter("phone"));
		s.setGender(request.getParameter("gender"));
		s.setDob(request.getParameter("dob"));
		s.setAddress(request.getParameter("address"));

		// Upload avatar
		Part filePart = request.getPart("avatar");
		String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;

		if (fileName != null && !fileName.isEmpty()) {

			// Đổi tên file tránh lỗi khoảng trắng
			String safeFileName = fileName.replace("\\", "_").replace("/", "_").replaceAll("\\s+", "_");
			String newFileName = System.currentTimeMillis() + "_" + safeFileName;

			String uploadPath = getServletContext().getRealPath("/uploads");
			if (uploadPath == null) {
				// fallback: tránh NPE trong một số cấu hình server
				uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
			}

			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}

			filePart.write(uploadPath + File.separator + newFileName);

			s.setAvatar(newFileName);

		} else {

			s.setAvatar(current.getAvatar());
		}

		dao.updateProfile(s);
		request.getSession().setAttribute("successMsg", "Cập nhật thông tin thành công!");
		response.sendRedirect(request.getContextPath() + "/student/home");
	}
}