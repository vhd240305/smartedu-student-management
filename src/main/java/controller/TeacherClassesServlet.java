package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Account;
import model.Teacher;
import model.Classroom;

import dao.TeacherDAO;
import dao.ClassroomDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/teacher/classes")
public class TeacherClassesServlet extends HttpServlet {

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
		ClassroomDAO classroomDAO = new ClassroomDAO();

		Teacher teacher = teacherDAO.getByAccountId(acc.getId());

		List<Classroom> list = classroomDAO.getByTeacherId(teacher.getId());

		request.setAttribute("list", list);

		request.getRequestDispatcher("/view/teacher/classes.jsp").forward(request, response);
	}
}