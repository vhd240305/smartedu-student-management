package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Teacher;

import java.io.IOException;

import dao.TeacherDAO;

@WebServlet("/teacher/profile")
public class TeacherProfileServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");

//		if (acc == null || !"teacher".equals(acc.getRole())) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		TeacherDAO dao = new TeacherDAO();

		Teacher teacher = dao.getByAccountId(acc.getId());

		request.setAttribute("teacher", teacher);

		request.getRequestDispatcher("/view/teacher/profile.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		TeacherDAO dao = new TeacherDAO();

		Teacher t = new Teacher();

		t.setId(Integer.parseInt(request.getParameter("id")));
		t.setName(request.getParameter("name"));
		t.setEmail(request.getParameter("email"));
		t.setPhone(request.getParameter("phone"));
		t.setDepartment(request.getParameter("department"));

		dao.updateProfile(t);
		request.getSession().setAttribute("successMsg", "Cập nhật thông tin thành công!");
		response.sendRedirect(request.getContextPath() + "/teacher/home");
	}
}
