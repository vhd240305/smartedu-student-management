package controller;

import dao.ScheduleDAO;
import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Student;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/student/schedule")
public class StudentScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        StudentDAO studentDAO = new StudentDAO();
        Student student = studentDAO.getByAccountId(acc.getId());

        ScheduleDAO scheduleDAO = new ScheduleDAO();
        List<Map<String, Object>> schedules = scheduleDAO.getByStudent(student.getId());

        request.setAttribute("schedules", schedules);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/view/student/schedule.jsp").forward(request, response);
    }
}