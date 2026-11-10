package api;

import com.google.gson.Gson;
import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Teacher;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/teachers/*")
public class TeacherApiServlet extends HttpServlet {

    private static final Gson gson = new Gson();
    private static final TeacherDAO dao = new TeacherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                int page = 1;
                int pageSize = 10;
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
                try { pageSize = Integer.parseInt(request.getParameter("size")); } catch (Exception e) {}
                String keyword = request.getParameter("keyword");
                if (keyword != null && keyword.trim().isEmpty()) keyword = null;

                int offset = (page - 1) * pageSize;
                int total = dao.countWithFilter(keyword, null, null);
                List<Map<String, Object>> list = dao.getWithFilterAndKeyword(keyword, null, null, offset, pageSize);

                Map<String, Object> data = new java.util.HashMap<>();
                data.put("list", list);
                data.put("total", total);
                data.put("page", page);
                data.put("pageSize", pageSize);
                data.put("totalPages", (int) Math.ceil((double) total / pageSize));

                response.setStatus(200);
                response.getWriter().write(gson.toJson(new ApiResponse(200, "Thành công", data)));

            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Teacher teacher = dao.getById(id);
                if (teacher == null) {
                    response.setStatus(404);
                    response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy giảng viên", null)));
                } else {
                    response.setStatus(200);
                    response.getWriter().write(gson.toJson(new ApiResponse(200, "Thành công", teacher)));
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

            Teacher t = gson.fromJson(sb.toString(), Teacher.class);

            if (t.getName() == null || t.getEmail() == null) {
                response.setStatus(400);
                response.getWriter().write(gson.toJson(new ApiResponse(400, "Thiếu thông tin bắt buộc", null)));
                return;
            }

            dao.insert(t);
            response.setStatus(201);
            response.getWriter().write(gson.toJson(new ApiResponse(201, "Thêm giảng viên thành công", t)));

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

            Teacher t = gson.fromJson(sb.toString(), Teacher.class);
            t.setId(id);

            if (dao.getById(id) == null) {
                response.setStatus(404);
                response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy giảng viên", null)));
                return;
            }

            dao.update(t);
            response.setStatus(200);
            response.getWriter().write(gson.toJson(new ApiResponse(200, "Cập nhật thành công", t)));

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

            if (dao.getById(id) == null) {
                response.setStatus(404);
                response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy giảng viên", null)));
                return;
            }

            dao.delete(id);
            response.setStatus(200);
            response.getWriter().write(gson.toJson(new ApiResponse(200, "Xóa giảng viên thành công", null)));

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new ApiResponse(500, "Lỗi server: " + e.getMessage(), null)));
        }
    }
}