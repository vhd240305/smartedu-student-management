package api;

import com.google.gson.Gson;
import dao.ClassroomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Classroom;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/classrooms/*")
public class ClassroomApiServlet extends HttpServlet {

    private static final Gson gson = new Gson();
    private static final ClassroomDAO dao = new ClassroomDAO();

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
                int total = keyword != null ? dao.countSearch(keyword) : dao.countAll();
                List<Map<String, Object>> list = keyword != null
                        ? dao.searchWithPaging(keyword, offset, pageSize)
                        : dao.getWithPaging(offset, pageSize);

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
                Classroom classroom = dao.getById(id);
                if (classroom == null) {
                    response.setStatus(404);
                    response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy lớp học", null)));
                } else {
                    response.setStatus(200);
                    response.getWriter().write(gson.toJson(new ApiResponse(200, "Thành công", classroom)));
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

            Classroom c = gson.fromJson(sb.toString(), Classroom.class);

            if (c.getName() == null) {
                response.setStatus(400);
                response.getWriter().write(gson.toJson(new ApiResponse(400, "Thiếu thông tin bắt buộc", null)));
                return;
            }

            dao.insert(c);
            response.setStatus(201);
            response.getWriter().write(gson.toJson(new ApiResponse(201, "Thêm lớp học thành công", c)));

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

            Classroom c = gson.fromJson(sb.toString(), Classroom.class);
            c.setId(id);

            if (dao.getById(id) == null) {
                response.setStatus(404);
                response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy lớp học", null)));
                return;
            }

            dao.update(c);
            response.setStatus(200);
            response.getWriter().write(gson.toJson(new ApiResponse(200, "Cập nhật thành công", c)));

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
                response.getWriter().write(gson.toJson(new ApiResponse(404, "Không tìm thấy lớp học", null)));
                return;
            }

            dao.delete(id);
            response.setStatus(200);
            response.getWriter().write(gson.toJson(new ApiResponse(200, "Xóa lớp học thành công", null)));

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(gson.toJson(new ApiResponse(500, "Lỗi server: " + e.getMessage(), null)));
        }
    }
}