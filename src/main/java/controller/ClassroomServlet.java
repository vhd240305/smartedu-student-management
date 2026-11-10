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

import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.ClassroomDAO;
import dao.StudentDAO;
import dao.TeacherDAO;

@WebServlet("/admin/classrooms")
public class ClassroomServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ClassroomServlet() {
	}

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
		ClassroomDAO dao = new ClassroomDAO();

		if (action == null) {
		    int page = 1;
		    int pageSize = 5;
		    try {
		        page = Integer.parseInt(request.getParameter("page"));
		    } catch (Exception e) {}

		    int offset = (page - 1) * pageSize;
		    String keyword = request.getParameter("keyword");

		    int totalRecords;
		    List<Map<String, Object>> list;

		    if (keyword != null && !keyword.trim().isEmpty()) {
		        totalRecords = dao.countSearch(keyword);
		        list = dao.searchWithPaging(keyword, offset, pageSize);
		        request.setAttribute("keyword", keyword);
		    } else {
		        totalRecords = dao.countAll();
		        list = dao.getWithPaging(offset, pageSize);
		    }

		    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

		    request.setAttribute("list", list);
		    request.setAttribute("currentPage", page);
		    request.setAttribute("totalPages", totalPages);

		    request.getRequestDispatcher("/view/admin/classroom-list.jsp").forward(request, response);
		} else if ("add".equals(action)) {

			TeacherDAO tdao = new TeacherDAO();
			request.setAttribute("teacherList", tdao.getAll());

			request.getRequestDispatcher("/view/admin/classroom-add.jsp").forward(request, response);

		} else if ("edit".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));

			request.setAttribute("classroom", dao.getById(id));

			TeacherDAO tdao = new TeacherDAO();
			request.setAttribute("teacherList", tdao.getAll());

			request.getRequestDispatcher("/view/admin/classroom-edit.jsp").forward(request, response);
		} else if ("detail".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));

			Classroom classroom = dao.getById(id);
			if (classroom == null) {
				response.sendRedirect(request.getContextPath() + "/admin/classrooms");
				return;
			}

			Teacher teacher = null;
			if (classroom.getTeacherId() > 0) {
				TeacherDAO tdao = new TeacherDAO();
				teacher = tdao.getById(classroom.getTeacherId());
			}

			StudentDAO sdao = new StudentDAO();
			List<Student> students = sdao.getStudentsByClassroom(id);
			// Thêm danh sách sinh viên chưa có trong lớp
		    List<Student> availableStudents = sdao.getStudentsNotInClassroom(id);
		    
			request.setAttribute("classroom", classroom);
			request.setAttribute("teacher", teacher);
			request.setAttribute("students", students);
			request.setAttribute("availableStudents", availableStudents);
			
			request.getRequestDispatcher("/view/admin/classroom-detail.jsp").forward(request, response);
		} else if ("delete".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));
			dao.delete(id);
			request.getSession().setAttribute("successMsg", "Xóa lớp học thành công!");
			response.sendRedirect("classrooms");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		ClassroomDAO dao = new ClassroomDAO();

		if ("insert".equals(action)) {

			Classroom c = new Classroom();

			c.setName(request.getParameter("name"));
			c.setRoom(request.getParameter("room"));
			c.setDescription(request.getParameter("description"));

			c.setTeacherId(Integer.parseInt(request.getParameter("teacher_id")));
			dao.insert(c);
			request.getSession().setAttribute("successMsg", "Thêm lớp học thành công!");
			response.sendRedirect("classrooms");

		} else if ("update".equals(action)) {

			Classroom c = new Classroom();

			c.setId(Integer.parseInt(request.getParameter("id")));
			c.setName(request.getParameter("name"));
			c.setRoom(request.getParameter("room"));
			c.setDescription(request.getParameter("description"));

			c.setTeacherId(Integer.parseInt(request.getParameter("teacher_id")));

			dao.update(c);
			request.getSession().setAttribute("successMsg", "Cập nhật lớp học thành công!");
			response.sendRedirect("classrooms");
		} else if ("addStudent".equals(action)) {
		    int classroomId = Integer.parseInt(request.getParameter("classroomId"));
		    String[] studentIds = request.getParameterValues("studentIds");
		    if (studentIds != null) {
		        StudentDAO sdao = new StudentDAO();
		        for (String sid : studentIds) {
		            sdao.assignToClassroom(Integer.parseInt(sid), classroomId);
		        }
		        request.getSession().setAttribute("successMsg", "Thêm sinh viên vào lớp thành công!");
		    }
		    response.sendRedirect(request.getContextPath() + "/admin/classrooms?action=detail&id=" + classroomId);

		} else if ("removeStudent".equals(action)) {
		    int classroomId = Integer.parseInt(request.getParameter("classroomId"));
		    int studentId = Integer.parseInt(request.getParameter("studentId"));
		    StudentDAO sdao = new StudentDAO();
		    sdao.removeFromClassroom(studentId, classroomId);
		    request.getSession().setAttribute("successMsg", "Xóa sinh viên khỏi lớp thành công!");
		    response.sendRedirect(request.getContextPath() + "/admin/classrooms?action=detail&id=" + classroomId);
		}
	}

}
