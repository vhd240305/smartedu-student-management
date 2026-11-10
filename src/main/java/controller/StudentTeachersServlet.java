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
import java.util.List;
import java.util.Map;

import dao.StudentDAO;

@WebServlet("/student/teachers")
public class StudentTeachersServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public StudentTeachersServlet() {
	}

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

		List<Map<String, Object>> list = dao.getTeachersByStudent(student.getId());

		request.setAttribute("teachers", list);

		request.getRequestDispatcher("/view/student/teachers.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
