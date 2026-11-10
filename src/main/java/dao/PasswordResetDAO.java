package dao;

import util.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;

public class PasswordResetDAO {

    // Lưu OTP vào database
    public void saveOtp(String email, String otp) {
        // Xóa OTP cũ của email này trước
        String deleteSql = "DELETE FROM password_reset WHERE email = ?";
        String insertSql = "INSERT INTO password_reset(email, otp, expires_at) VALUES(?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement(deleteSql);
            ps1.setString(1, email);
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(insertSql);
            ps2.setString(1, email);
            ps2.setString(2, otp);
            ps2.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now().plusMinutes(5)));
            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Kiểm tra OTP có hợp lệ không
    public boolean verifyOtp(String email, String otp) {
        String sql = "SELECT * FROM password_reset WHERE email=? AND otp=? AND used=0 AND expires_at > NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            boolean result = rs.next();
            System.out.println("SQL verify: email=" + email + " otp=" + otp + " result=" + result);
            
            // Debug thêm - kiểm tra không có điều kiện thời gian
            String sql2 = "SELECT * FROM password_reset WHERE email=? AND otp=?";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setString(1, email);
            ps2.setString(2, otp);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                System.out.println("Tìm thấy OTP, expires_at: " + rs2.getTimestamp("expires_at"));
                System.out.println("used: " + rs2.getInt("used"));
            } else {
                System.out.println("Không tìm thấy OTP trong DB");
            }
            
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đánh dấu OTP đã dùng
    public void markUsed(String email) {
        String sql = "UPDATE password_reset SET used=1 WHERE email=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy email từ OTP
    public String getEmailByOtp(String otp) {
        String sql = "SELECT email FROM password_reset WHERE otp=? AND used=0 AND expires_at > NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("email");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}