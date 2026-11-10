package controller;

import dao.ClassroomDAO;
import dao.ScoreDAO;
import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Classroom;
import model.Teacher;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/scores/export")
public class TeacherScoreExportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        int classroomId = Integer.parseInt(request.getParameter("classroomId"));

        ClassroomDAO classroomDAO = new ClassroomDAO();
        TeacherDAO teacherDAO = new TeacherDAO();
        ScoreDAO scoreDAO = new ScoreDAO();

        Classroom classroom = classroomDAO.getById(classroomId);
        Teacher teacher = classroom.getTeacherId() > 0
                ? teacherDAO.getById(classroom.getTeacherId()) : null;
        List<Map<String, Object>> scores = scoreDAO.getAllByClassroom(classroomId);

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Bảng điểm");
        
        String signerName = teacher != null ? teacher.getName() : acc.getUsername();
        // Dùng lại method export từ ScoreExportServlet
        ScoreExportServlet exporter = new ScoreExportServlet();
        exporter.exportClassroomSheet(workbook, sheet, classroom, teacher, scores, signerName);

        String filename = "BangDiem_" + "HP000" + classroomId + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}