package controller;

import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;

@WebServlet("/admin/classrooms/import-students")
@MultipartConfig
public class ClassroomImportStudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int classroomId = Integer.parseInt(request.getParameter("classroomId"));

        if ("template".equals(action)) {
            // Xuất file mẫu
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Danh sach SV");

            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            Row header = sheet.createRow(0);
            String[] columns = {"Mã sinh viên (VD: SV0001)", "Họ tên sinh viên (để tham khảo)"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            Row sample = sheet.createRow(1);
            sample.createCell(0).setCellValue("SV0001");
            sample.createCell(1).setCellValue("Nguyễn Văn A");

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=mau-import-sv-vao-lop.xlsx");
            workbook.write(response.getOutputStream());
            workbook.close();
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/classrooms?action=detail&id=" + classroomId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int classroomId = Integer.parseInt(request.getParameter("classroomId"));
        Part filePart = request.getPart("excelFile");
        InputStream inputStream = filePart.getInputStream();

        StudentDAO studentDAO = new StudentDAO();

        int success = 0;
        int failed = 0;
        int alreadyIn = 0;
        StringBuilder errors = new StringBuilder();

        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rows = sheet.iterator();

            // Bỏ qua dòng tiêu đề
            if (rows.hasNext()) rows.next();

            int rowNum = 2;
            while (rows.hasNext()) {
                Row row = rows.next();
                try {
                    String masvRaw = getCellValue(row, 0).trim();
                    if (masvRaw.isEmpty()) { rowNum++; continue; }

                    // Lấy số ID từ mã SV (VD: SV0001 -> 1)
                    String idStr = masvRaw.replaceAll("[^0-9]", "");
                    if (idStr.isEmpty()) {
                        errors.append("Dòng ").append(rowNum).append(": Mã sinh viên '").append(masvRaw).append("' không hợp lệ<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    int studentId = Integer.parseInt(idStr);

                    // Kiểm tra sinh viên tồn tại
                    if (studentDAO.getById(studentId) == null) {
                        errors.append("Dòng ").append(rowNum).append(": Sinh viên '").append(masvRaw).append("' không tồn tại<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    // Kiểm tra đã có trong lớp chưa
                    if (studentDAO.isInClassroom(studentId, classroomId)) {
                        errors.append("Dòng ").append(rowNum).append(": Sinh viên '").append(masvRaw).append("' đã có trong lớp<br>");
                        alreadyIn++;
                        rowNum++;
                        continue;
                    }

                    // Thêm vào lớp
                    studentDAO.assignToClassroom(studentId, classroomId);
                    success++;

                } catch (Exception e) {
                    errors.append("Dòng ").append(rowNum).append(": Lỗi - ").append(e.getMessage()).append("<br>");
                    failed++;
                }
                rowNum++;
            }

        } catch (Exception e) {
            request.getSession().setAttribute("importError", "File không hợp lệ: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/classrooms?action=detail&id=" + classroomId);
            return;
        }

        request.getSession().setAttribute("successMsg", "Import thành công " + success + " sinh viên vào lớp!"
                + (alreadyIn > 0 ? " (" + alreadyIn + " đã có trong lớp)" : "")
                + (failed > 0 ? " (" + failed + " dòng lỗi)" : ""));

        if (errors.length() > 0) {
            request.getSession().setAttribute("importErrors", errors.toString());
        }

        response.sendRedirect(request.getContextPath() + "/admin/classrooms?action=detail&id=" + classroomId);
    }

    private String getCellValue(Row row, int index) {
        Cell cell = row.getCell(index, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC: return String.valueOf((long) cell.getNumericCellValue());
            default: return "";
        }
    }
}