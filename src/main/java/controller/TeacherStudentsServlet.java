package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Account;
import model.Teacher;

import dao.TeacherDAO;
import dao.StudentDAO;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/students")
public class TeacherStudentsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");

//		if (acc == null || !"teacher".equals(acc.getRole())) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		TeacherDAO teacherDAO = new TeacherDAO();
		StudentDAO studentDAO = new StudentDAO();

		Teacher teacher = teacherDAO.getByAccountId(acc.getId());

		List<Map<String, Object>> list = studentDAO.getStudentsByTeacher(teacher.getId());

		request.setAttribute("list", list);

		request.getRequestDispatcher("/view/teacher/students.jsp").forward(request, response);
	}
}