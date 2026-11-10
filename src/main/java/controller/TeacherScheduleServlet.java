package controller;

import dao.ScheduleDAO;
import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Teacher;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/schedule")
public class TeacherScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        TeacherDAO teacherDAO = new TeacherDAO();
        Teacher teacher = teacherDAO.getByAccountId(acc.getId());

        ScheduleDAO scheduleDAO = new ScheduleDAO();
        List<Map<String, Object>> schedules = scheduleDAO.getByTeacher(teacher.getId());

        request.setAttribute("schedules", schedules);
        request.setAttribute("teacher", teacher);
        request.getRequestDispatcher("/view/teacher/schedule.jsp").forward(request, response);
    }
}