package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class ScheduleDAO {

    public List<Map<String, Object>> getByClassroom(int classroomId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS classroom_name "
                + "FROM schedule s "
                + "JOIN classroom c ON s.classroom_id = c.id "
                + "WHERE s.classroom_id = ? "
                + "ORDER BY s.day_of_week, s.period_start";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getByStudent(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS classroom_name "
                + "FROM schedule s "
                + "JOIN classroom c ON s.classroom_id = c.id "
                + "JOIN student_classroom sc ON sc.classroom_id = c.id "
                + "WHERE sc.student_id = ? "
                + "ORDER BY s.day_of_week, s.period_start";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getByTeacher(int teacherId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS classroom_name "
                + "FROM schedule s "
                + "JOIN classroom c ON s.classroom_id = c.id "
                + "WHERE c.teacher_id = ? "
                + "ORDER BY s.day_of_week, s.period_start";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getAll() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS classroom_name "
                + "FROM schedule s "
                + "JOIN classroom c ON s.classroom_id = c.id "
                + "ORDER BY s.day_of_week, s.period_start";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(int classroomId, int dayOfWeek, int periodStart,
            int periodEnd, String room, String startDate, String endDate, String note) {
        String sql = "INSERT INTO schedule(classroom_id, day_of_week, period_start, "
                + "period_end, room, start_date, end_date, note) VALUES(?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ps.setInt(2, dayOfWeek);
            ps.setInt(3, periodStart);
            ps.setInt(4, periodEnd);
            ps.setString(5, room);
            ps.setString(6, startDate != null && !startDate.isEmpty() ? startDate : null);
            ps.setString(7, endDate != null && !endDate.isEmpty() ? endDate : null);
            ps.setString(8, note);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM schedule WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Map<String, Object> getById(int id) {
        String sql = "SELECT s.*, c.name AS classroom_name "
                + "FROM schedule s "
                + "JOIN classroom c ON s.classroom_id = c.id "
                + "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(int id, int dayOfWeek, int periodStart, int periodEnd,
            String room, String startDate, String endDate, String note) {
        String sql = "UPDATE schedule SET day_of_week=?, period_start=?, period_end=?, "
                + "room=?, start_date=?, end_date=?, note=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dayOfWeek);
            ps.setInt(2, periodStart);
            ps.setInt(3, periodEnd);
            ps.setString(4, room);
            ps.setString(5, startDate != null && !startDate.isEmpty() ? startDate : null);
            ps.setString(6, endDate != null && !endDate.isEmpty() ? endDate : null);
            ps.setString(7, note);
            ps.setInt(8, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("classroom_id", rs.getInt("classroom_id"));
        row.put("classroom_name", rs.getString("classroom_name"));
        row.put("day_of_week", rs.getInt("day_of_week"));
        row.put("period_start", rs.getInt("period_start"));
        row.put("period_end", rs.getInt("period_end"));
        row.put("room", rs.getString("room"));
        row.put("start_date", rs.getString("start_date"));
        row.put("end_date", rs.getString("end_date"));
        row.put("note", rs.getString("note"));
        return row;
    }
}