package dao;

import util.DBConnection;
import java.sql.*;

public class ScoreHistoryDAO {

    public void save(int scoreId, int studentId, int classroomId,
            String fieldChanged, String oldValue, String newValue,
            int changedBy, String note) {
        String sql = "INSERT INTO score_history(score_id, student_id, classroom_id, "
                + "field_changed, old_value, new_value, changed_by, note) "
                + "VALUES(?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scoreId);
            ps.setInt(2, studentId);
            ps.setInt(3, classroomId);
            ps.setString(4, fieldChanged);
            ps.setString(5, oldValue);
            ps.setString(6, newValue);
            ps.setInt(7, changedBy);
            ps.setString(8, note);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}