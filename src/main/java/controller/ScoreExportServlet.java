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

@WebServlet("/admin/scores/export")
public class ScoreExportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    		HttpSession session = request.getSession();
    		Account adminAcc = (Account) session.getAttribute("account");
    		String signerName = adminAcc.getUsername();
        String type = request.getParameter("type");
        ScoreDAO scoreDAO = new ScoreDAO();
        ClassroomDAO classroomDAO = new ClassroomDAO();
        TeacherDAO teacherDAO = new TeacherDAO();

        if ("classroom".equals(type)) {
            // Xuất báo cáo theo lớp
            int classroomId = Integer.parseInt(request.getParameter("classroomId"));
            Classroom classroom = classroomDAO.getById(classroomId);
            Teacher teacher = classroom.getTeacherId() > 0
                    ? teacherDAO.getById(classroom.getTeacherId()) : null;
            List<Map<String, Object>> scores = scoreDAO.getAllByClassroom(classroomId);

            XSSFWorkbook workbook = new XSSFWorkbook();
            XSSFSheet sheet = workbook.createSheet("Bảng điểm");

            exportClassroomSheet(workbook, sheet, classroom, teacher, scores, signerName);

            String filename = "BaoCaoBangDiem_" + "HP000" + classroomId + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);
            workbook.write(response.getOutputStream());
            workbook.close();

        } else if ("semester".equals(type)) {
            // Xuất báo cáo tổng hợp theo học kỳ - mỗi lớp 1 sheet
            String semester = request.getParameter("semester");
            String academicYear = request.getParameter("academicYear");

            List<Map<String, Object>> allClassrooms = classroomDAO.getAllWithTeacher();

            XSSFWorkbook workbook = new XSSFWorkbook();

            for (Map<String, Object> cls : allClassrooms) {
                int classroomId = (int) cls.get("id");
                Classroom classroom = classroomDAO.getById(classroomId);
                Teacher teacher = classroom.getTeacherId() > 0
                        ? teacherDAO.getById(classroom.getTeacherId()) : null;

                List<Map<String, Object>> scores = scoreDAO.getByClassroomAndSemester(
                        classroomId, semester, academicYear);

                if (!scores.isEmpty()) {
                    String sheetName = "HP000" + classroomId;
                    XSSFSheet sheet = workbook.createSheet(sheetName);
                    exportClassroomSheet(workbook, sheet, classroom, teacher, scores, signerName);
                }
            }

            String filename = "BaoCaoTongHop_HK" + semester + "_" + academicYear + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);
            workbook.write(response.getOutputStream());
            workbook.close();
        }
    }

    public void exportClassroomSheet(XSSFWorkbook workbook, XSSFSheet sheet,
            Classroom classroom, Teacher teacher, List<Map<String, Object>> scores, String signerName) {

        // ===== STYLES =====
        // Style tiêu đề trường
        CellStyle schoolStyle = workbook.createCellStyle();
        Font schoolFont = workbook.createFont();
        schoolFont.setBold(true);
        schoolFont.setFontHeightInPoints((short) 13);
        schoolStyle.setFont(schoolFont);
        schoolStyle.setAlignment(HorizontalAlignment.CENTER);

        // Style tiêu đề bảng điểm
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);

        // Style header bảng
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        setBorder(headerStyle);

        // Style data
        CellStyle dataStyle = workbook.createCellStyle();
        setBorder(dataStyle);
        dataStyle.setAlignment(HorizontalAlignment.CENTER);

        // Style data trái
        CellStyle dataLeftStyle = workbook.createCellStyle();
        setBorder(dataLeftStyle);
        dataLeftStyle.setAlignment(HorizontalAlignment.LEFT);

        // Style pass
        CellStyle passStyle = workbook.createCellStyle();
        Font passFont = workbook.createFont();
        passFont.setBold(true);
        passFont.setColor(IndexedColors.GREEN.getIndex());
        passStyle.setFont(passFont);
        passStyle.setAlignment(HorizontalAlignment.CENTER);
        setBorder(passStyle);

        // Style fail
        CellStyle failStyle = workbook.createCellStyle();
        Font failFont = workbook.createFont();
        failFont.setBold(true);
        failFont.setColor(IndexedColors.RED.getIndex());
        failStyle.setFont(failFont);
        failStyle.setAlignment(HorizontalAlignment.CENTER);
        setBorder(failStyle);

        // Style footer
        CellStyle footerStyle = workbook.createCellStyle();
        Font footerFont = workbook.createFont();
        footerFont.setBold(true);
        footerStyle.setFont(footerFont);
        footerStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        footerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorder(footerStyle);

        // Style ký tên
        CellStyle signStyle = workbook.createCellStyle();
        signStyle.setAlignment(HorizontalAlignment.CENTER);
        Font signFont = workbook.createFont();
        signFont.setBold(true);
        signStyle.setFont(signFont);

        int rowNum = 0;

        // ===== HEADER =====
        // Dòng 1: Tên trường
        Row r0 = sheet.createRow(rowNum++);
        r0.setHeightInPoints(20);
        Cell c0 = r0.createCell(0);
        c0.setCellValue("TRƯỜNG ĐẠI HỌC SMARTEDU");
        c0.setCellStyle(schoolStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 8));

        // Dòng 2: Tiêu đề
        Row r1 = sheet.createRow(rowNum++);
        r1.setHeightInPoints(25);
        Cell c1 = r1.createCell(0);
        c1.setCellValue("BẢNG ĐIỂM LỚP HỌC");
        c1.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 8));

        // Dòng 3: Thông tin lớp
        Row r2 = sheet.createRow(rowNum++);
        r2.createCell(0).setCellValue("Mã lớp: HP000" + classroom.getId());
        r2.createCell(4).setCellValue("Tên lớp: " + classroom.getName());
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 3));
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 4, 8));

        // Dòng 4: Học kỳ - Năm học
        Row r3 = sheet.createRow(rowNum++);
        String semester = scores.isEmpty() ? "-" : (scores.get(0).get("semester") != null ? "HK" + scores.get(0).get("semester") : "-");
        String academicYear = scores.isEmpty() ? "-" : (scores.get(0).get("academic_year") != null ? (String) scores.get(0).get("academic_year") : "-");
        r3.createCell(0).setCellValue("Học kỳ: " + semester);
        r3.createCell(4).setCellValue("Năm học: " + academicYear);
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 0, 3));
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 4, 8));

        // Dòng 5: Giáo viên - Ngày xuất
        Row r4 = sheet.createRow(rowNum++);
        String teacherName = teacher != null ? teacher.getName() : "Chưa phân công";
        r4.createCell(0).setCellValue("Giảng viên phụ trách: " + teacherName);
        r4.createCell(4).setCellValue("Ngày xuất: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
        sheet.addMergedRegion(new CellRangeAddress(4, 4, 0, 3));
        sheet.addMergedRegion(new CellRangeAddress(4, 4, 4, 8));

        rowNum++; // Dòng trống

        // ===== HEADER BẢNG =====
        Row headerRow = sheet.createRow(rowNum++);
        headerRow.setHeightInPoints(22);
        String[] headers = {"STT", "Mã SV", "Họ và tên", "Ngày sinh",
                "Điểm giữa kỳ (40%)", "Điểm cuối kỳ (60%)", "Điểm tổng kết", "Xếp loại", "Kết quả"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // ===== DỮ LIỆU =====
        int stt = 0;
        int passCount = 0;
        float totalGpa = 0;
        int countGpa = 0;

        // Lấy thêm thông tin sinh viên
        dao.StudentDAO studentDAO = new dao.StudentDAO();

        for (Map<String, Object> s : scores) {
            Row dataRow = sheet.createRow(rowNum++);

            // Lấy thông tin sinh viên
            int studentId = (int) s.get("student_id");
            model.Student student = studentDAO.getById(studentId);

            float gpa = s.get("gpa") != null ? Float.parseFloat(s.get("gpa").toString()) : 0;
            boolean pass = gpa >= 5.0f;
            if (pass) passCount++;
            if (gpa > 0) { totalGpa += gpa; countGpa++; }

            String rank = "-";
            if (gpa >= 8.5) rank = "Giỏi";
            else if (gpa >= 7.0) rank = "Khá";
            else if (gpa >= 5.5) rank = "Trung bình";
            else if (gpa > 0) rank = "Yếu";

            dataRow.createCell(0).setCellValue(++stt);
            dataRow.getCell(0).setCellStyle(dataStyle);

            Cell masvCell = dataRow.createCell(1);
            masvCell.setCellValue("SV000" + studentId);
            masvCell.setCellStyle(dataStyle);

            Cell nameCell = dataRow.createCell(2);
            nameCell.setCellValue(s.get("student_name") != null ? (String) s.get("student_name") : "");
            nameCell.setCellStyle(dataLeftStyle);

            Cell dobCell = dataRow.createCell(3);
            dobCell.setCellValue(student != null && student.getDob() != null ? student.getDob() : "-");
            dobCell.setCellStyle(dataStyle);

            Cell midCell = dataRow.createCell(4);
            midCell.setCellValue(s.get("midterm_score") != null ? Double.parseDouble(s.get("midterm_score").toString()) : 0);
            midCell.setCellStyle(dataStyle);

            Cell finalCell = dataRow.createCell(5);
            finalCell.setCellValue(s.get("final_score") != null ? Double.parseDouble(s.get("final_score").toString()) : 0);
            finalCell.setCellStyle(dataStyle);

            Cell gpaCell = dataRow.createCell(6);
            gpaCell.setCellValue(gpa);
            gpaCell.setCellStyle(dataStyle);

            Cell rankCell = dataRow.createCell(7);
            rankCell.setCellValue(rank);
            rankCell.setCellStyle(dataStyle);

            Cell resultCell = dataRow.createCell(8);
            resultCell.setCellValue(pass ? "Đạt" : "Không đạt");
            resultCell.setCellStyle(pass ? passStyle : failStyle);
        }

        rowNum++; // Dòng trống

        // ===== FOOTER THỐNG KÊ =====
        int totalCount = scores.size();
        int failCount = totalCount - passCount;
        float avgGpa = countGpa > 0 ? Math.round(totalGpa / countGpa * 10f) / 10f : 0;
        float passRate = totalCount > 0 ? Math.round((float) passCount / totalCount * 1000f) / 10f : 0;

        Row statRow1 = sheet.createRow(rowNum++);
        Cell statCell1 = statRow1.createCell(0);
        statCell1.setCellValue("Tổng số sinh viên: " + totalCount
                + "   |   Số sinh viên đạt: " + passCount
                + "   |   Số sinh viên không đạt: " + failCount
                + "   |   Tỉ lệ đạt: " + passRate + "%"
                + "   |   Điểm trung bình lớp: " + avgGpa);
        statCell1.setCellStyle(footerStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 8));

        rowNum += 2; // Khoảng trống trước ký tên

        // ===== KÝ TÊN =====
        Row signRow1 = sheet.createRow(rowNum++);
        Cell signLeft1 = signRow1.createCell(0);
        signLeft1.setCellValue("Người phụ trách");
        signLeft1.setCellStyle(signStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 3));

        Cell signRight1 = signRow1.createCell(5);
        signRight1.setCellValue("Xác nhận của khoa/phòng đào tạo");
        signRight1.setCellStyle(signStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 5, 8));

        // Dòng ký tên (để trống)
        rowNum += 4;
        Row signRow2 = sheet.createRow(rowNum++);
        Cell signNameLeft = signRow2.createCell(0);
        signNameLeft.setCellValue("(" + signerName + ")");
        signNameLeft.setCellStyle(signStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 3));

        Cell signNameRight = signRow2.createCell(5);
        signNameRight.setCellValue("(Ký tên, đóng dấu)");
        signNameRight.setCellStyle(signStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 5, 8));

        // ===== AUTO SIZE COLUMNS =====
        for (int i = 0; i < 9; i++) {
            sheet.autoSizeColumn(i);
        }
        // Cố định độ rộng cột họ tên
        sheet.setColumnWidth(2, 6000);
    }

    private void setBorder(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
    }
}