package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class ScoreDAO {

    // Lấy danh sách điểm theo lớp
	public List<Map<String, Object>> getByClassroom(int classroomId) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT s.id AS student_id, s.name AS student_name, "
	            + "sc2.id AS score_id, sc2.midterm_score, sc2.final_score, sc2.gpa, "
	            + "sc2.semester, sc2.academic_year, sc2.status, sc2.note, "
	            + "c.name AS classroom_name "
	            + "FROM student_classroom sc "
	            + "JOIN student s ON sc.student_id = s.id "
	            + "JOIN classroom c ON sc.classroom_id = c.id "
	            + "LEFT JOIN score sc2 ON sc2.student_id = s.id AND sc2.classroom_id = sc.classroom_id "
	            + "WHERE sc.classroom_id = ? "
	            + "ORDER BY s.name";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, classroomId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("student_id", rs.getInt("student_id"));
	            row.put("student_name", rs.getString("student_name"));
	            row.put("classroom_id", classroomId);
	            row.put("classroom_name", rs.getString("classroom_name"));
	            row.put("id", rs.getObject("score_id"));
	            row.put("midterm_score", rs.getObject("midterm_score"));
	            row.put("final_score", rs.getObject("final_score"));
	            row.put("gpa", rs.getObject("gpa"));
	            row.put("semester", rs.getString("semester"));
	            row.put("academic_year", rs.getString("academic_year"));
	            row.put("status", rs.getString("status") != null ? rs.getString("status") : "draft");
	            row.put("note", rs.getString("note"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

    // Lấy điểm theo sinh viên
    public List<Map<String, Object>> getByStudent(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sc.*, s.name AS student_name, c.name AS classroom_name "
                + "FROM score sc "
                + "JOIN student s ON sc.student_id = s.id "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "WHERE sc.student_id = ? AND sc.status = 'approved' "
                + "ORDER BY sc.academic_year, sc.semester";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("midterm_score", rs.getObject("midterm_score"));
                row.put("final_score", rs.getObject("final_score"));
                row.put("gpa", rs.getObject("gpa"));
                row.put("semester", rs.getString("semester"));
                row.put("academic_year", rs.getString("academic_year"));
                row.put("status", rs.getString("status"));
                row.put("classroom_name", rs.getString("classroom_name"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm hoặc cập nhật điểm
    public void saveScore(int studentId, int classroomId, float midterm,
            float finalScore, String semester, String academicYear) {
        float gpa = Math.round((midterm * 0.4f + finalScore * 0.6f) * 10) / 10f;
        String sql = "INSERT INTO score(student_id, classroom_id, midterm_score, final_score, gpa, semester, academic_year, status) "
                + "VALUES(?,?,?,?,?,?,?,'draft') "
                + "ON DUPLICATE KEY UPDATE midterm_score=?, final_score=?, gpa=?, semester=?, academic_year=?, status='draft'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, classroomId);
            ps.setFloat(3, midterm);
            ps.setFloat(4, finalScore);
            ps.setFloat(5, gpa);
            ps.setString(6, semester);
            ps.setString(7, academicYear);
            ps.setFloat(8, midterm);
            ps.setFloat(9, finalScore);
            ps.setFloat(10, gpa);
            ps.setString(11, semester);
            ps.setString(12, academicYear);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Nộp điểm chờ duyệt
    public void submitScores(int classroomId) {
        String sql = "UPDATE score SET status='pending' WHERE classroom_id=? AND status='draft'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Admin duyệt điểm
    public void approveScores(int classroomId) {
        String sql = "UPDATE score SET status='approved', note=NULL WHERE classroom_id=? AND status='pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Admin từ chối điểm
    public void rejectScores(int classroomId, String note) {
        String sql = "UPDATE score SET status='rejected', note=? WHERE classroom_id=? AND status='pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setInt(2, classroomId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách lớp chờ duyệt
    public List<Map<String, Object>> getPendingClassrooms() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.id, c.name, t.name AS teacher_name, "
                + "COUNT(sc.id) AS score_count "
                + "FROM score sc "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "LEFT JOIN teacher t ON c.teacher_id = t.id "
                + "WHERE sc.status = 'pending' "
                + "GROUP BY c.id, c.name, t.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                row.put("teacher_name", rs.getString("teacher_name"));
                row.put("score_count", rs.getInt("score_count"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Khởi tạo điểm cho tất cả sinh viên trong lớp
    public void initScoresForClassroom(int classroomId, String semester, String academicYear) {
        String sql = "INSERT IGNORE INTO score(student_id, classroom_id, semester, academic_year, status) "
                + "SELECT sc.student_id, ?, ?, ?, 'draft' "
                + "FROM student_classroom sc WHERE sc.classroom_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ps.setString(2, semester);
            ps.setString(3, academicYear);
            ps.setInt(4, classroomId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
 // Lấy điểm theo lớp (tất cả trạng thái) cho admin xem
    public List<Map<String, Object>> getAllByClassroom(int classroomId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.id AS student_id, s.name AS student_name, "
                + "sc2.id AS score_id, sc2.midterm_score, sc2.final_score, sc2.gpa, "
                + "sc2.semester, sc2.academic_year, sc2.status, sc2.note, "
                + "c.name AS classroom_name "
                + "FROM student_classroom sc "
                + "JOIN student s ON sc.student_id = s.id "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "LEFT JOIN score sc2 ON sc2.student_id = s.id AND sc2.classroom_id = sc.classroom_id "
                + "WHERE sc.classroom_id = ? "
                + "ORDER BY s.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("student_id", rs.getInt("student_id"));
                row.put("student_name", rs.getString("student_name"));
                row.put("classroom_id", classroomId);
                row.put("classroom_name", rs.getString("classroom_name"));
                row.put("id", rs.getObject("score_id"));
                row.put("midterm_score", rs.getObject("midterm_score"));
                row.put("final_score", rs.getObject("final_score"));
                row.put("gpa", rs.getObject("gpa"));
                row.put("semester", rs.getString("semester"));
                row.put("academic_year", rs.getString("academic_year"));
                row.put("status", rs.getString("status") != null ? rs.getString("status") : "draft");
                row.put("note", rs.getString("note"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả điểm của 1 sinh viên cho admin xem
    public List<Map<String, Object>> getAllByStudent(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.id AS student_id, s.name AS student_name, "
                + "c.id AS classroom_id, c.name AS classroom_name, "
                + "sc2.id AS score_id, sc2.midterm_score, sc2.final_score, sc2.gpa, "
                + "sc2.semester, sc2.academic_year, sc2.status, sc2.note "
                + "FROM student_classroom sc "
                + "JOIN student s ON sc.student_id = s.id "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "LEFT JOIN score sc2 ON sc2.student_id = s.id AND sc2.classroom_id = c.id "
                + "WHERE sc.student_id = ? "
                + "ORDER BY sc2.academic_year, sc2.semester";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("student_id", rs.getInt("student_id"));
                row.put("student_name", rs.getString("student_name"));
                row.put("classroom_id", rs.getInt("classroom_id"));
                row.put("classroom_name", rs.getString("classroom_name"));
                row.put("id", rs.getObject("score_id"));
                row.put("midterm_score", rs.getObject("midterm_score"));
                row.put("final_score", rs.getObject("final_score"));
                row.put("gpa", rs.getObject("gpa"));
                row.put("semester", rs.getString("semester"));
                row.put("academic_year", rs.getString("academic_year"));
                row.put("status", rs.getString("status") != null ? rs.getString("status") : "Chưa có điểm");
                row.put("note", rs.getString("note"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    //Xem điểm phía sinh viên
    public List<Map<String, Object>> getApprovedByStudent(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT c.name AS classroom_name, "
                + "sc2.midterm_score, sc2.final_score, sc2.gpa, "
                + "sc2.semester, sc2.academic_year, sc2.status "
                + "FROM student_classroom sc "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "LEFT JOIN score sc2 ON sc2.student_id = sc.student_id "
                + "AND sc2.classroom_id = sc.classroom_id "
                + "AND sc2.status IN ('approved', 'draft', 'pending', 'rejected') "
                + "WHERE sc.student_id = ? "
                + "ORDER BY sc2.academic_year DESC, sc2.semester ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("classroom_name", rs.getString("classroom_name"));
                row.put("midterm_score", rs.getObject("midterm_score"));
                row.put("final_score", rs.getObject("final_score"));
                row.put("gpa", rs.getObject("gpa"));
                row.put("semester", rs.getString("semester"));
                row.put("academic_year", rs.getString("academic_year"));
                row.put("status", rs.getString("status") != null ? rs.getString("status") : "Chưa có điểm");
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }    
 // Sửa điểm bởi admin
    public void updateScoreByAdmin(int scoreId, float midterm, float finalScore, float gpa) {
        String sql = "UPDATE score SET midterm_score=?, final_score=?, gpa=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setFloat(1, midterm);
            ps.setFloat(2, finalScore);
            ps.setFloat(3, gpa);
            ps.setInt(4, scoreId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy điểm theo ID
    public Map<String, Object> getById(int scoreId) {
        String sql = "SELECT sc.*, s.name AS student_name, c.name AS classroom_name "
                + "FROM score sc "
                + "JOIN student s ON sc.student_id = s.id "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "WHERE sc.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scoreId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("student_id", rs.getInt("student_id"));
                row.put("classroom_id", rs.getInt("classroom_id"));
                row.put("student_name", rs.getString("student_name"));
                row.put("classroom_name", rs.getString("classroom_name"));
                row.put("midterm_score", rs.getObject("midterm_score"));
                row.put("final_score", rs.getObject("final_score"));
                row.put("gpa", rs.getObject("gpa"));
                row.put("status", rs.getString("status"));
                return row;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy lịch sử chỉnh sửa điểm
    public List<Map<String, Object>> getHistory(int scoreId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sh.*, a.username AS changed_by_name "
                + "FROM score_history sh "
                + "JOIN account a ON sh.changed_by = a.id "
                + "WHERE sh.score_id = ? "
                + "ORDER BY sh.changed_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scoreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("field_changed", rs.getString("field_changed"));
                row.put("old_value", rs.getString("old_value"));
                row.put("new_value", rs.getString("new_value"));
                row.put("changed_by_name", rs.getString("changed_by_name"));
                row.put("changed_at", rs.getTimestamp("changed_at"));
                row.put("note", rs.getString("note"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    //Xuất báo cáo điểm
    public List<Map<String, Object>> getByClassroomAndSemester(int classroomId, String semester, String academicYear) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sc.*, s.name AS student_name, c.name AS classroom_name "
                + "FROM score sc "
                + "JOIN student s ON sc.student_id = s.id "
                + "JOIN classroom c ON sc.classroom_id = c.id "
                + "WHERE sc.classroom_id = ? AND sc.semester = ? AND sc.academic_year = ? "
                + "AND sc.status = 'approved' ORDER BY s.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ps.setString(2, semester);
            ps.setString(3, academicYear);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("student_id", rs.getInt("student_id"));
                row.put("student_name", rs.getString("student_name"));
                row.put("classroom_name", rs.getString("classroom_name"));
                row.put("midterm_score", rs.getObject("midterm_score"));
                row.put("final_score", rs.getObject("final_score"));
                row.put("gpa", rs.getObject("gpa"));
                row.put("semester", rs.getString("semester"));
                row.put("academic_year", rs.getString("academic_year"));
                row.put("status", rs.getString("status"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Biểu đồ đường
    public List<Map<String, Object>> getAvgGpaByYearAndSemester() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT academic_year, semester, AVG(gpa) as avg_gpa, COUNT(*) as total "
                + "FROM score WHERE status = 'approved' AND gpa > 0 "
                + "GROUP BY academic_year, semester "
                + "ORDER BY academic_year ASC, semester ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("academic_year", rs.getString("academic_year"));
                row.put("semester", rs.getString("semester"));
                row.put("avg_gpa", Math.round(rs.getFloat("avg_gpa") * 10f) / 10f);
                row.put("total", rs.getInt("total"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 // Tỉ lệ đạt/không đạt toàn trường
    public Map<String, Integer> getPassFailCount() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT "
                + "SUM(CASE WHEN avg_gpa >= 5.0 THEN 1 ELSE 0 END) as pass_count, "
                + "SUM(CASE WHEN avg_gpa < 5.0 THEN 1 ELSE 0 END) as fail_count "
                + "FROM ("
                + "  SELECT student_id, AVG(gpa) as avg_gpa "
                + "  FROM score "
                + "  WHERE status = 'approved' AND gpa > 0 "
                + "  GROUP BY student_id"
                + ") AS student_avg";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                map.put("pass", rs.getInt("pass_count"));
                map.put("fail", rs.getInt("fail_count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // Phân phối xếp loại
    public Map<String, Integer> getRankDistribution() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT "
                + "SUM(CASE WHEN avg_gpa >= 8.5 THEN 1 ELSE 0 END) as gioi, "
                + "SUM(CASE WHEN avg_gpa >= 7.0 AND avg_gpa < 8.5 THEN 1 ELSE 0 END) as kha, "
                + "SUM(CASE WHEN avg_gpa >= 5.5 AND avg_gpa < 7.0 THEN 1 ELSE 0 END) as trung_binh, "
                + "SUM(CASE WHEN avg_gpa < 5.5 AND avg_gpa > 0 THEN 1 ELSE 0 END) as yeu "
                + "FROM ("
                + "  SELECT student_id, AVG(gpa) as avg_gpa "
                + "  FROM score "
                + "  WHERE status = 'approved' AND gpa > 0 "
                + "  GROUP BY student_id"
                + ") AS student_avg";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                map.put("Giỏi", rs.getInt("gioi"));
                map.put("Khá", rs.getInt("kha"));
                map.put("Trung bình", rs.getInt("trung_binh"));
                map.put("Yếu", rs.getInt("yeu"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}