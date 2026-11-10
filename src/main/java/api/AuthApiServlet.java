package api;

import com.google.gson.Gson;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import at.favre.lib.crypto.bcrypt.BCrypt;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/auth/login")
public class AuthApiServlet extends HttpServlet {

    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Đọc body JSON
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }

        Map<?, ?> body = gson.fromJson(sb.toString(), Map.class);
        String username = (String) body.get("username");
        String password = (String) body.get("password");

        if (username == null || password == null) {
            response.setStatus(400);
            response.getWriter().write(gson.toJson(new ApiResponse(400, "Thiếu username hoặc password", null)));
            return;
        }

        AccountDAO dao = new AccountDAO();
        Account acc = dao.findByUsername(username);

        if (acc == null) {
            response.setStatus(401);
            response.getWriter().write(gson.toJson(new ApiResponse(401, "Tài khoản không tồn tại", null)));
            return;
        }

        BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), acc.getPassword());
        if (!result.verified) {
            response.setStatus(401);
            response.getWriter().write(gson.toJson(new ApiResponse(401, "Mật khẩu không chính xác", null)));
            return;
        }

        String token = JwtUtil.generate(acc.getUsername(), acc.getRole());

        Map<String, String> data = new HashMap<>();
        data.put("token", token);
        data.put("username", acc.getUsername());
        data.put("role", acc.getRole());

        response.setStatus(200);
        response.getWriter().write(gson.toJson(new ApiResponse(200, "Đăng nhập thành công", data)));
    }
}