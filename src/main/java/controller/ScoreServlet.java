package controller;

import dao.ClassroomDAO;
import dao.ScoreDAO;
import dao.ScoreHistoryDAO;
import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Classroom;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Account;

@WebServlet("/admin/scores")
public class ScoreServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ScoreDAO scoreDAO = new ScoreDAO();
        ClassroomDAO classroomDAO = new ClassroomDAO();

        if (action == null) {
            // Danh sách lớp chờ duyệt
            List<Map<String, Object>> pending = scoreDAO.getPendingClassrooms();
            request.setAttribute("pendingList", pending);
            request.getRequestDispatcher("/view/admin/score-list.jsp").forward(request, response);

        } else if ("view".equals(action)) {
            // Xem điểm của 1 lớp
            int classroomId = Integer.parseInt(request.getParameter("classroomId"));
            Classroom classroom = classroomDAO.getById(classroomId);
            List<Map<String, Object>> scores = scoreDAO.getByClassroom(classroomId);
            request.setAttribute("classroom", classroom);
            request.setAttribute("scores", scores);
            request.getRequestDispatcher("/view/admin/score-detail.jsp").forward(request, response);
        } else if ("viewByClassroom".equals(action)) {
            int classroomId = Integer.parseInt(request.getParameter("classroomId"));
            Classroom classroom = classroomDAO.getById(classroomId);
            List<Map<String, Object>> scores = scoreDAO.getAllByClassroom(classroomId);
            request.setAttribute("classroom", classroom);
            request.setAttribute("scores", scores);
            request.getRequestDispatcher("/view/admin/score-view-classroom.jsp").forward(request, response);

        } else if ("viewByStudent".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            model.Student student = new StudentDAO().getById(studentId);
            List<Map<String, Object>> scores = scoreDAO.getAllByStudent(studentId);
            request.setAttribute("student", student);
            request.setAttribute("scores", scores);
            request.getRequestDispatcher("/view/admin/score-view-student.jsp").forward(request, response);

        } else if ("allClassrooms".equals(action)) {
            // Danh sách tất cả lớp để admin chọn xem điểm
            List<Map<String, Object>> allClassrooms = classroomDAO.getAllWithTeacher();
            request.setAttribute("allClassrooms", allClassrooms);
            request.getRequestDispatcher("/view/admin/score-all.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            // Trang sửa điểm
            int scoreId = Integer.parseInt(request.getParameter("scoreId"));
            Map<String, Object> score = scoreDAO.getById(scoreId);

            // Chỉ cho sửa khi đã approved
            if (!"approved".equals(score.get("status"))) {
                response.sendRedirect(request.getContextPath() + "/admin/scores");
                return;
            }

            List<Map<String, Object>> history = scoreDAO.getHistory(scoreId);
            request.setAttribute("score", score);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/view/admin/score-edit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ScoreDAO scoreDAO = new ScoreDAO();

        if ("approve".equals(action)) {
        		int classroomId = Integer.parseInt(request.getParameter("classroomId"));
            scoreDAO.approveScores(classroomId);
            request.getSession().setAttribute("successMsg", "Duyệt điểm thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/scores");

        } else if ("reject".equals(action)) {
        		int classroomId = Integer.parseInt(request.getParameter("classroomId"));
        		String note = request.getParameter("note");
            scoreDAO.rejectScores(classroomId, note);
            request.getSession().setAttribute("successMsg", "Đã từ chối và gửi yêu cầu chỉnh sửa!");
            response.sendRedirect(request.getContextPath() + "/admin/scores");
        } else if ("update".equals(action)) {
            int scoreId = Integer.parseInt(request.getParameter("scoreId"));
            float newMidterm = Float.parseFloat(request.getParameter("midterm"));
            float newFinal = Float.parseFloat(request.getParameter("finalScore"));
            float newGpa = Math.round((newMidterm * 0.4f + newFinal * 0.6f) * 10) / 10f;
            String note = request.getParameter("note");

            Map<String, Object> oldScore = scoreDAO.getById(scoreId);
            float oldMidterm = oldScore.get("midterm_score") != null ?
                    Float.parseFloat(oldScore.get("midterm_score").toString()) : 0;
            float oldFinal = oldScore.get("final_score") != null ?
                    Float.parseFloat(oldScore.get("final_score").toString()) : 0;
            float oldGpa = oldScore.get("gpa") != null ?
                    Float.parseFloat(oldScore.get("gpa").toString()) : 0;

            int studentId = Integer.parseInt(oldScore.get("student_id").toString());
            int classroomId1 = Integer.parseInt(oldScore.get("classroom_id").toString());

            HttpSession session = request.getSession();
            Account adminAcc = (Account) session.getAttribute("account");
            int adminId = adminAcc.getId();

            ScoreHistoryDAO historyDAO = new ScoreHistoryDAO();

            if (oldMidterm != newMidterm) {
                historyDAO.save(scoreId, studentId, classroomId1,
                        "Điểm giữa kỳ", String.valueOf(oldMidterm),
                        String.valueOf(newMidterm), adminId, note);
            }
            if (oldFinal != newFinal) {
                historyDAO.save(scoreId, studentId, classroomId1,
                        "Điểm cuối kỳ", String.valueOf(oldFinal),
                        String.valueOf(newFinal), adminId, note);
            }
            if (oldGpa != newGpa) {
                historyDAO.save(scoreId, studentId, classroomId1,
                        "GPA", String.valueOf(oldGpa),
                        String.valueOf(newGpa), adminId, note);
            }

            scoreDAO.updateScoreByAdmin(scoreId, newMidterm, newFinal, newGpa);
            request.getSession().setAttribute("successMsg", "Cập nhật điểm thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/scores?action=viewByClassroom&classroomId=" + classroomId1);
        }

    }
}