package controller;

import dao.AccountDAO;
import dao.PasswordResetDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import util.EmailUtil;

import java.io.IOException;
import java.util.Random;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("sendOtp".equals(action)) {
            sendOtp(request, response);
        } else if ("verifyOtp".equals(action)) {
            verifyOtp(request, response);
        } else if ("resetPassword".equals(action)) {
            resetPassword(request, response);
        }
    }

    private void sendOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email").trim();
        AccountDAO accountDAO = new AccountDAO();
        Account acc = accountDAO.findByEmail(email);

        if (acc == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.setAttribute("step", "email");
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Tạo OTP 6 số
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Lưu OTP vào database
        PasswordResetDAO dao = new PasswordResetDAO();
        dao.saveOtp(email, otp);

        // Gửi email
        try {
            String subject = "Mã xác nhận đặt lại mật khẩu - SMARTEDU";
            String body = "<div style='font-family: Arial; max-width: 500px; margin: auto;'>"
                    + "<h2 style='color: #2E75B6;'>Đặt lại mật khẩu</h2>"
                    + "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                    + "<p>Mã xác nhận của bạn là:</p>"
                    + "<h1 style='color: #dc3545; letter-spacing: 8px; text-align: center;'>" + otp + "</h1>"
                    + "<p style='color: #666;'>Mã có hiệu lực trong <strong>5 phút</strong>.</p>"
                    + "<p style='color: #666;'>Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>"
                    + "</div>";

            EmailUtil.sendEmail(email, subject, body);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại.");
            request.setAttribute("step", "email");
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("step", "otp");
        request.setAttribute("email", email);
        request.setAttribute("msg", "Mã OTP đã được gửi đến email của bạn!");
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }

    private void verifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email").trim();
        String otp = request.getParameter("otp").trim();
        System.out.println("Email: " + email);
        System.out.println("OTP nhập: [" + otp + "]");
        
        PasswordResetDAO dao = new PasswordResetDAO();
        System.out.println("Verify result: " + dao.verifyOtp(email, otp));

        if (!dao.verifyOtp(email, otp)) {
            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn.");
            request.setAttribute("step", "otp");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("step", "newPassword");
        request.setAttribute("email", email);
        request.setAttribute("otp", otp);
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email").trim();
        String otp = request.getParameter("otp").trim();
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.setAttribute("step", "newPassword");
            request.setAttribute("email", email);
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.setAttribute("step", "newPassword");
            request.setAttribute("email", email);
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        PasswordResetDAO resetDAO = new PasswordResetDAO();

        // Kiểm tra lại OTP lần cuối
        if (!resetDAO.verifyOtp(email, otp)) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            request.setAttribute("step", "email");
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu mới
        AccountDAO accountDAO = new AccountDAO();
        Account acc = accountDAO.findByEmail(email);
        accountDAO.changePassword(acc.getId(), newPassword);

        // Đánh dấu OTP đã dùng
        resetDAO.markUsed(email);

        request.setAttribute("step", "success");
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }
}