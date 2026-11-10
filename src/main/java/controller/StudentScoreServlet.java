package controller;

import dao.ScoreDAO;
import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Student;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/student/scores")
public class StudentScoreServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        StudentDAO studentDAO = new StudentDAO();
        Student student = studentDAO.getByAccountId(acc.getId());

        ScoreDAO scoreDAO = new ScoreDAO();
        List<Map<String, Object>> scores = scoreDAO.getApprovedByStudent(student.getId());

        // Tính GPA trung bình
        float totalGpa = 0;
        int countGpa = 0;
        for (Map<String, Object> s : scores) {
            if (s.get("gpa") != null) {
                totalGpa += Float.parseFloat(s.get("gpa").toString());
                countGpa++;
            }
        }
        float avgGpa = countGpa > 0 ? Math.round(totalGpa / countGpa * 10f) / 10f : 0;

        request.setAttribute("scores", scores);
        request.setAttribute("avgGpa", avgGpa);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/view/student/scores.jsp").forward(request, response);
    }
}