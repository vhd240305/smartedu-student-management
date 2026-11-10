package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Student;
import dao.AccountDAO;
import dao.ClassroomDAO;
import dao.StudentDAO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;

@WebServlet("/admin/students/import")
@MultipartConfig
public class StudentImportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("template".equals(action)) {
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Sinh vien");

            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            Row header = sheet.createRow(0);
            String[] columns = {
                "Họ tên *", "Email *", "Số điện thoại *",
                "Giới tính (Nam/Nữ) *", "Ngày sinh (yyyy-MM-dd) *",
                "Địa chỉ *", "Tên đăng nhập *", "Mật khẩu *",
                "Lớp học (VD: HP0001 - Tên lớp, HP0002 - Tên lớp)"
            };
            for (int i = 0; i < columns.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            Row sample = sheet.createRow(1);
            sample.createCell(0).setCellValue("Nguyễn Văn A");
            sample.createCell(1).setCellValue("nguyenvana@gmail.com");
            sample.createCell(2).setCellValue("0912345678");
            sample.createCell(3).setCellValue("Nam");
            sample.createCell(4).setCellValue("2000-01-15");
            sample.createCell(5).setCellValue("Hà Nội");
            sample.createCell(6).setCellValue("nguyenvana");
            sample.createCell(7).setCellValue("123456");
            sample.createCell(8).setCellValue("HP0001 - Kiểm thử phần mềm, HP0002 - Ứng dụng thuật toán");

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=mau-import-sinh-vien.xlsx");
            workbook.write(response.getOutputStream());
            workbook.close();
            return;
        }

        request.getRequestDispatcher("/view/admin/student-import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("excelFile");
        InputStream inputStream = filePart.getInputStream();

        StudentDAO studentDAO = new StudentDAO();
        AccountDAO accountDAO = new AccountDAO();
        ClassroomDAO classroomDAO = new ClassroomDAO();

        int success = 0;
        int failed = 0;
        StringBuilder errors = new StringBuilder();

        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rows = sheet.iterator();

            if (rows.hasNext()) rows.next();

            int rowNum = 2;
            while (rows.hasNext()) {
                Row row = rows.next();

                try {
                    String name      = getCellValue(row, 0);
                    String email     = getCellValue(row, 1);
                    String phone     = getCellValue(row, 2);
                    String gender    = getCellValue(row, 3);
                    String dob       = getCellValue(row, 4);
                    String address   = getCellValue(row, 5);
                    String username  = getCellValue(row, 6);
                    String password  = getCellValue(row, 7);
                    String classrooms = getCellValue(row, 8);

                    if (name.isEmpty() && email.isEmpty()) {
                        rowNum++;
                        continue;
                    }

                    if (name.isEmpty() || email.isEmpty() || phone.isEmpty()
                            || gender.isEmpty() || dob.isEmpty() || address.isEmpty()
                            || username.isEmpty() || password.isEmpty()) {
                        errors.append("Dòng ").append(rowNum).append(": Thiếu thông tin bắt buộc<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    if (!phone.matches("^0\\d{9}$")) {
                        errors.append("Dòng ").append(rowNum).append(": Số điện thoại không hợp lệ<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                        errors.append("Dòng ").append(rowNum).append(": Email không hợp lệ<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    if (!username.matches("^[A-Za-z0-9_.]{4,50}$")) {
                        errors.append("Dòng ").append(rowNum).append(": Username không hợp lệ<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    if (password.length() < 6) {
                        errors.append("Dòng ").append(rowNum).append(": Mật khẩu phải có ít nhất 6 ký tự<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    try {
                        java.time.LocalDate dobDate = java.time.LocalDate.parse(dob);
                        if (dobDate.isAfter(java.time.LocalDate.now().minusYears(18))) {
                            errors.append("Dòng ").append(rowNum).append(": Sinh viên chưa đủ 18 tuổi<br>");
                            failed++;
                            rowNum++;
                            continue;
                        }
                    } catch (Exception e) {
                        errors.append("Dòng ").append(rowNum).append(": Ngày sinh không đúng định dạng yyyy-MM-dd<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    if (accountDAO.existsByUsername(username)) {
                        errors.append("Dòng ").append(rowNum).append(": Username '").append(username).append("' đã tồn tại<br>");
                        failed++;
                        rowNum++;
                        continue;
                    }

                    int accountId = accountDAO.create(username, password, "student");

                    Student s = new Student();
                    s.setName(name);
                    s.setEmail(email);
                    s.setPhone(phone);
                    s.setGender("Nam".equals(gender) || "Male".equals(gender) ? "Male" : "Female");
                    s.setDob(dob);
                    s.setAddress(address);
                    s.setAccountId(accountId);
                    s.setAvatar("default.png");

                    int studentId = studentDAO.insertAndGetId(s);

                    if (!classrooms.isEmpty()) {
                        String[] classList = classrooms.split(",");
                        for (String cls : classList) {
                            cls = cls.trim();
                            String classCode = cls.contains(" - ") ? cls.split(" - ")[0].trim() : cls;
                            try {
                                String idStr = classCode.replaceAll("[^0-9]", "");
                                int classroomId = Integer.parseInt(idStr);
                                if (classroomDAO.getById(classroomId) != null) {
                                    studentDAO.assignToClassroom(studentId, classroomId);
                                } else {
                                    errors.append("Dòng ").append(rowNum).append(": Lớp '").append(cls).append("' không tồn tại, bỏ qua<br>");
                                }
                            } catch (Exception e) {
                                errors.append("Dòng ").append(rowNum).append(": Mã lớp '").append(cls).append("' không hợp lệ, bỏ qua<br>");
                            }
                        }
                    }

                    success++;

                } catch (Exception e) {
                    errors.append("Dòng ").append(rowNum).append(": Lỗi xử lý - ").append(e.getMessage()).append("<br>");
                    failed++;
                }
                rowNum++;
            }

        } catch (Exception e) {
            request.setAttribute("error", "File không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/view/admin/student-import.jsp").forward(request, response);
            return;
        }

        if (errors.length() > 0) {
            request.setAttribute("importErrors", errors.toString());
            request.setAttribute("successCount", success);
            request.setAttribute("failedCount", failed);
            request.getRequestDispatcher("/view/admin/student-import.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("successMsg", "Import thành công " + success + " sinh viên!");
        response.sendRedirect(request.getContextPath() + "/admin/students");
    }

    private String getCellValue(Row row, int index) {
        Cell cell = row.getCell(index, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    java.util.Date date = cell.getDateCellValue();
                    return new java.text.SimpleDateFormat("yyyy-MM-dd").format(date);
                }
                return String.valueOf((long) cell.getNumericCellValue());
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            default: return "";
        }
    }
}