package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Classroom;
import model.Student;

import java.io.IOException;
import java.util.List;

import dao.StudentDAO;

@WebServlet("/student/classes")
public class StudentClassesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public StudentClassesServlet() {
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");
//
//		if (acc == null || !"student".equals(acc.getRole())) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		StudentDAO dao = new StudentDAO();

		Student student = dao.getByAccountId(acc.getId());

		List<Classroom> classes = dao.getClassesByStudent(student.getId());

		request.setAttribute("classes", classes);

		request.getRequestDispatcher("/view/student/classes.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
