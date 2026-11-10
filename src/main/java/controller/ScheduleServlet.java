package controller;

import dao.ClassroomDAO;
import dao.ScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Classroom;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/schedules")
public class ScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ScheduleDAO scheduleDAO = new ScheduleDAO();
        ClassroomDAO classroomDAO = new ClassroomDAO();

        if (action == null) {
            // Danh sách tất cả thời khóa biểu
            List<Map<String, Object>> schedules = scheduleDAO.getAll();
            List<Map<String, Object>> classrooms = classroomDAO.getAllWithTeacher();
            request.setAttribute("schedules", schedules);
            request.setAttribute("classrooms", classrooms);
            request.getRequestDispatcher("/view/admin/schedule-list.jsp").forward(request, response);

        } else if ("add".equals(action)) {
            List<Map<String, Object>> classrooms = classroomDAO.getAllWithTeacher();
            request.setAttribute("classrooms", classrooms);
            request.getRequestDispatcher("/view/admin/schedule-add.jsp").forward(request, response);

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Map<String, Object> schedule = scheduleDAO.getById(id);
            List<Map<String, Object>> classrooms = classroomDAO.getAllWithTeacher();
            request.setAttribute("schedule", schedule);
            request.setAttribute("classrooms", classrooms);
            request.getRequestDispatcher("/view/admin/schedule-add.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            scheduleDAO.delete(id);
            request.getSession().setAttribute("successMsg", "Xóa lịch học thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/schedules");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ScheduleDAO scheduleDAO = new ScheduleDAO();

        if ("insert".equals(action)) {
            int classroomId = Integer.parseInt(request.getParameter("classroom_id"));
            int dayOfWeek = Integer.parseInt(request.getParameter("day_of_week"));
            int periodStart = Integer.parseInt(request.getParameter("period_start"));
            int periodEnd = Integer.parseInt(request.getParameter("period_end"));
            String room = request.getParameter("room");
            String startDate = request.getParameter("start_date");
            String endDate = request.getParameter("end_date");
            String note = request.getParameter("note");

            scheduleDAO.insert(classroomId, dayOfWeek, periodStart, periodEnd,
                    room, startDate, endDate, note);
            request.getSession().setAttribute("successMsg", "Thêm lịch học thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/schedules");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            int dayOfWeek = Integer.parseInt(request.getParameter("day_of_week"));
            int periodStart = Integer.parseInt(request.getParameter("period_start"));
            int periodEnd = Integer.parseInt(request.getParameter("period_end"));
            String room = request.getParameter("room");
            String startDate = request.getParameter("start_date");
            String endDate = request.getParameter("end_date");
            String note = request.getParameter("note");

            scheduleDAO.update(id, dayOfWeek, periodStart, periodEnd,
                    room, startDate, endDate, note);
            request.getSession().setAttribute("successMsg", "Cập nhật lịch học thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/schedules");
        }
    }
}