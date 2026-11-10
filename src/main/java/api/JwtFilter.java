package api;

import com.google.gson.Gson;
import io.jsonwebtoken.Claims;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "JwtFilter", urlPatterns = "/api/*")
public class JwtFilter implements Filter {

    private static final Gson gson = new Gson();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        // Bỏ qua endpoint login
        String uri = req.getRequestURI();
        if (uri.endsWith("/api/auth/login")) {
            chain.doFilter(request, response);
            return;
        }

        // Lấy token từ header
        String authHeader = req.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.getWriter().write(gson.toJson(new ApiResponse(401, "Thiếu token xác thực", null)));
            return;
        }

        String token = authHeader.substring(7);
        Claims claims = JwtUtil.validate(token);

        if (claims == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.getWriter().write(gson.toJson(new ApiResponse(401, "Token không hợp lệ hoặc đã hết hạn", null)));
            return;
        }

        // Lưu thông tin vào request để dùng trong servlet
        req.setAttribute("username", claims.getSubject());
        req.setAttribute("role", claims.get("role"));

        chain.doFilter(request, response);
    }
}