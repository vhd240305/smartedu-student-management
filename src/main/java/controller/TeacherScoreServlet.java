package controller;

import dao.ClassroomDAO;
import dao.ScoreDAO;
import dao.StudentDAO;
import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Classroom;
import model.Student;
import model.Teacher;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/scores")
public class TeacherScoreServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        TeacherDAO teacherDAO = new TeacherDAO();
        Teacher teacher = teacherDAO.getByAccountId(acc.getId());

        String action = request.getParameter("action");
        ScoreDAO scoreDAO = new ScoreDAO();
        ClassroomDAO classroomDAO = new ClassroomDAO();

        if (action == null) {
        		List<Classroom> classes = classroomDAO.getByTeacherId(teacher.getId());
            
            // Lấy trạng thái điểm của từng lớp
            Map<Integer, String> scoreStatusMap = new HashMap<>();
            for (Classroom c : classes) {
                List<Map<String, Object>> scores = scoreDAO.getByClassroom(c.getId());
                if (scores.isEmpty()) {
                    scoreStatusMap.put(c.getId(), "none");
                } else {
                    scoreStatusMap.put(c.getId(), (String) scores.get(0).get("status"));
                }
            }
            
            request.setAttribute("classes", classes);
            request.setAttribute("scoreStatusMap", scoreStatusMap);
            request.getRequestDispatcher("/view/teacher/score-list.jsp").forward(request, response);

        } else if ("enter".equals(action)) {
            // Trang nhập điểm cho 1 lớp
            int classroomId = Integer.parseInt(request.getParameter("classroomId"));
            Classroom classroom = classroomDAO.getById(classroomId);

            // Kiểm tra giảng viên có phụ trách lớp này không
            if (classroom.getTeacherId() != teacher.getId()) {
                response.sendRedirect(request.getContextPath() + "/teacher/scores");
                return;
            }

            List<Map<String, Object>> scores = scoreDAO.getByClassroom(classroomId);

            // Nếu chưa có điểm thì khởi tạo
            if (scores.isEmpty()) {
                String semester = request.getParameter("semester") != null
                        ? request.getParameter("semester") : "1";
                String academicYear = request.getParameter("academicYear") != null
                        ? request.getParameter("academicYear") : "2024-2025";
                scoreDAO.initScoresForClassroom(classroomId, semester, academicYear);
                scores = scoreDAO.getByClassroom(classroomId);
            }

            request.setAttribute("classroom", classroom);
            request.setAttribute("scores", scores);
            request.getRequestDispatcher("/view/teacher/score-enter.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ScoreDAO scoreDAO = new ScoreDAO();
        int classroomId = Integer.parseInt(request.getParameter("classroomId"));
        String semester = request.getParameter("semester");
        String academicYear = request.getParameter("academicYear");

        if ("save".equals(action)) {
            // Lưu điểm
            String[] studentIds = request.getParameterValues("studentId");
            String[] midterms = request.getParameterValues("midterm");
            String[] finals = request.getParameterValues("finalScore");

            if (studentIds != null) {
                for (int i = 0; i < studentIds.length; i++) {
                    int studentId = Integer.parseInt(studentIds[i]);
                    float midterm = 0, finalScore = 0;
                    try { midterm = Float.parseFloat(midterms[i]); } catch (Exception e) {}
                    try { finalScore = Float.parseFloat(finals[i]); } catch (Exception e) {}
                    scoreDAO.saveScore(studentId, classroomId, midterm, finalScore, semester, academicYear);
                }
            }
            request.getSession().setAttribute("successMsg", "Lưu điểm thành công!");
            response.sendRedirect(request.getContextPath() + "/teacher/scores");

        } else if ("submit".equals(action)) {
            // Nộp điểm chờ admin duyệt
            scoreDAO.submitScores(classroomId);
            request.getSession().setAttribute("successMsg", "Nộp điểm thành công! Chờ admin duyệt.");
            response.sendRedirect(request.getContextPath() + "/teacher/scores");
        }
    }
}