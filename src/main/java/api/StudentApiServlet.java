package api;

import com.google.gson.Gson;
import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/students/*")
public class StudentApiServlet extends HttpServlet {

    private static final Gson gson = new Gson();
    private static final StudentDAO dao = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            // GET /api/students — lấy danh sách có phân trang
            if (pathInfo == null || pathInfo.equals("/")) {
                int page = 1;
                int pageSize = 6;
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
                try { pageSize = Integer.parseInt(request.getParameter("size")); } catch (Exception e) {}
                String keyword = request.getParameter("keyword");
                if (keyword != null && keyword.trim().isEmpty()) keyword = null;

                int offset = (page - 1) * pageSize;
                int total = dao.countWithFilter(keyword, null, null, null);
                List<Map<String, Object>> list = dao.getWithFilterAndKeyword(keyword, null, null, null, offset, pageSize);

                Map<String, Object> data = new java.util.HashMap<>();
                data.put("list", list);
                data.put("total", total);
                data.put("page", page);
                data.put("pageSize", pageSize);
                data.put("totalPages", (int) Math.ceil((double) total / pageSize));

                response.setStatus(200);
                response.getWriter().write(gson.toJson(new ApiResponse(200, "Thành công", data)));

            // GET /api/students/{id} — lấy 1 sinh viên
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                model.Student student = dao.getById(id);
                if (student == null) {
                    response.setStatus(404);
                    response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy sinh viên", null)));
                } else {
                    response.setStatus(200);
                    response.getWriter().write(gson.toJson(new ApiResponse(200, "Thành công", student)));
                }
            }
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new ApiResponse(500, "Lỗi server: " + e.getMessage(), null)));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Chỉ admin mới được thêm
        String role = (String) request.getAttribute("role");
        if (!"admin".equals(role)) {
            response.setStatus(403);
            response.getWriter().write(gson.toJson(new ApiResponse(403, "Không có quyền thực hiện", null)));
            return;
        }

        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) sb.append(line);

            model.Student s = gson.fromJson(sb.toString(), model.Student.class);

            if (s.getName() == null || s.getEmail() == null) {
                response.setStatus(400);
                response.getWriter().write(gson.toJson(new ApiResponse(400, "Thiếu thông tin bắt buộc", null)));
                return;
            }

            s.setAvatar("default.png");
            int id = dao.insertAndGetId(s);
            s.setId(id);

            response.setStatus(201);
            response.getWriter().write(gson.toJson(new ApiResponse(201, "Thêm sinh viên thành công", s)));

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new ApiResponse(500, "Lỗi server: " + e.getMessage(), null)));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String role = (String) request.getAttribute("role");
        if (!"admin".equals(role)) {
            response.setStatus(403);
            response.getWriter().write(gson.toJson(new ApiResponse(403, "Không có quyền thực hiện", null)));
            return;
        }

        try {
            String pathInfo = request.getPathInfo();
            int id = Integer.parseInt(pathInfo.substring(1));

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) sb.append(line);

            model.Student s = gson.fromJson(sb.toString(), model.Student.class);
            s.setId(id);

            model.Student old = dao.getById(id);
            if (old == null) {
                response.setStatus(404);
                response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy sinh viên", null)));
                return;
            }

            s.setAvatar(old.getAvatar());
            dao.update(s);

            response.setStatus(200);
            response.getWriter().write(gson.toJson(new ApiResponse(200, "Cập nhật thành công", s)));

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new ApiResponse(500, "Lỗi server: " + e.getMessage(), null)));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String role = (String) request.getAttribute("role");
        if (!"admin".equals(role)) {
            response.setStatus(403);
            response.getWriter().write(gson.toJson(new ApiResponse(403, "Không có quyền thực hiện", null)));
            return;
        }

        try {
            String pathInfo = request.getPathInfo();
            int id = Integer.parseInt(pathInfo.substring(1));

            model.Student s = dao.getById(id);
            if (s == null) {
                response.setStatus(404);
                response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy sinh viên", null)));
                return;
            }

            dao.delete(id);
            response.setStatus(200);
            response.getWriter().write(gson.toJson(new ApiResponse(200, "Xóa sinh viên thành công", null)));

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new ApiResponse(500, "Lỗi server: " + e.getMessage(), null)));
        }
    }
}