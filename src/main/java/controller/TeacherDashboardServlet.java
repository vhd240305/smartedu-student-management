package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.Account;
import model.Teacher;
import dao.TeacherDAO;

@WebServlet("/teacher/home")
public class TeacherDashboardServlet extends HttpServlet {

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

		request.getRequestDispatcher("/view/teacher/home.jsp").forward(request, response);
	}
}