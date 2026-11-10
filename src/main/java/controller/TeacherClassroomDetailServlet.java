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
import model.Teacher;

import dao.ClassroomDAO;
import dao.StudentDAO;
import dao.TeacherDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/teacher/classrooms/detail")
public class TeacherClassroomDetailServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Account acc = (Account) session.getAttribute("account");

//		if (acc == null || !"teacher".equals(acc.getRole())) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		String idRaw = request.getParameter("id");
		if (idRaw == null || idRaw.trim().isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/teacher/classes");
			return;
		}

		int classroomId;
		try {
			classroomId = Integer.parseInt(idRaw);
		} catch (NumberFormatException ex) {
			response.sendRedirect(request.getContextPath() + "/teacher/classes");
			return;
		}

		TeacherDAO teacherDAO = new TeacherDAO();
		Teacher teacher = teacherDAO.getByAccountId(acc.getId());
		if (teacher == null) {
			response.sendRedirect(request.getContextPath() + "/logout");
			return;
		}

		ClassroomDAO classroomDAO = new ClassroomDAO();
		Classroom classroom = classroomDAO.getById(classroomId);

		// Chỉ cho xem lớp do chính giảng viên phụ trách
		if (classroom == null || classroom.getTeacherId() != teacher.getId()) {
			response.sendRedirect(request.getContextPath() + "/teacher/classes");
			return;
		}

		StudentDAO studentDAO = new StudentDAO();
		List<Student> students = studentDAO.getStudentsByClassroom(classroomId);

		request.setAttribute("teacher", teacher);
		request.setAttribute("classroom", classroom);
		request.setAttribute("students", students);

		request.getRequestDispatcher("/view/teacher/classroom-detail.jsp").forward(request, response);
	}
}
