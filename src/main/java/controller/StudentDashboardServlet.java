package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Student;

import java.io.IOException;

import dao.StudentDAO;

@WebServlet("/student/home")
public class StudentDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public StudentDashboardServlet() {
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");

//		if (acc == null || !"student".equals(acc.getRole())) {
//
//			response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
//
//			return;
//		}

		StudentDAO dao = new StudentDAO();

		Student student = dao.getByAccountId(acc.getId());

		if (student == null) {

			response.getWriter().println("Student not found in database");
			return;
		}

		request.setAttribute("student", student);

		request.getRequestDispatcher("/view/student/home.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
