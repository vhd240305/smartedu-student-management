package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Classroom;
import util.DBConnection;

public class ClassroomDAO {

	public List<Classroom> getAll() {

		List<Classroom> list = new ArrayList<>();

		String sql = "SELECT * FROM classroom";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Classroom classroom = new Classroom(rs.getInt("id"), rs.getString("name"), rs.getString("room"),
						rs.getString("description"), rs.getInt("teacher_id") // 🔥 THÊM
				);
				list.add(classroom);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public Classroom getById(int id) {

		String sql = "SELECT * FROM classroom WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Classroom classroom = new Classroom(rs.getInt("id"), rs.getString("name"), rs.getString("room"),
						rs.getString("description"), rs.getInt("teacher_id") // 🔥 THÊM
				);
				return classroom;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public void insert(Classroom c) {

		String sql = "INSERT INTO classroom(name, room, description, teacher_id) VALUES(?,?,?,?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, c.getName());
			ps.setString(2, c.getRoom());
			ps.setString(3, c.getDescription());
			ps.setInt(4, c.getTeacherId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void update(Classroom c) {

		String sql = "UPDATE classroom SET name=?, room=?, description=?, teacher_id=? WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, c.getName());
			ps.setString(2, c.getRoom());
			ps.setString(3, c.getDescription());
			ps.setInt(4, c.getTeacherId());
			ps.setInt(5, c.getId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void delete(int id) {

		String sql = "DELETE FROM classroom WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Map<String, Object>> search(String keyword) {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT c.id, c.name, c.room, c.description, c.teacher_id, "
				+ "IFNULL(t.name, 'Chưa có giáo viên') AS teacher_name " + "FROM classroom c "
				+ "LEFT JOIN teacher t ON c.teacher_id = t.id " + "WHERE c.name LIKE ? OR c.room LIKE ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, "%" + keyword + "%");
			ps.setString(2, "%" + keyword + "%");

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("id", rs.getInt("id"));
				row.put("name", rs.getString("name"));
				row.put("room", rs.getString("room"));
				row.put("description", rs.getString("description"));
				row.put("teacher_name", rs.getString("teacher_name"));
				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<Map<String, Object>> getAllWithTeacher() {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT c.id, c.name, c.room, c.description, c.teacher_id, "
				+ "IFNULL(t.name, 'Chưa có giáo viên') AS teacher_name " + "FROM classroom c "
				+ "LEFT JOIN teacher t ON c.teacher_id = t.id";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("id", rs.getInt("id"));
				row.put("name", rs.getString("name"));
				row.put("room", rs.getString("room"));
				row.put("description", rs.getString("description"));
				row.put("teacher_name", rs.getString("teacher_name"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<Classroom> getByTeacherId(int teacherId) {

		List<Classroom> list = new ArrayList<>();

		String sql = "SELECT * FROM classroom WHERE teacher_id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, teacherId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Classroom c = new Classroom(rs.getInt("id"), rs.getString("name"), rs.getString("room"),
						rs.getString("description"));

				list.add(c);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	public List<Map<String, Object>> getWithPaging(int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT c.id, c.name, c.room, c.description, c.teacher_id, "
	            + "IFNULL(t.name, 'Chưa có giáo viên') AS teacher_name "
	            + "FROM classroom c "
	            + "LEFT JOIN teacher t ON c.teacher_id = t.id "
	            + "LIMIT ? OFFSET ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, limit);
	        ps.setInt(2, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("id", rs.getInt("id"));
	            row.put("name", rs.getString("name"));
	            row.put("room", rs.getString("room"));
	            row.put("description", rs.getString("description"));
	            row.put("teacher_name", rs.getString("teacher_name"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public List<Map<String, Object>> searchWithPaging(String keyword, int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT c.id, c.name, c.room, c.description, c.teacher_id, "
	            + "IFNULL(t.name, 'Chưa có giáo viên') AS teacher_name "
	            + "FROM classroom c "
	            + "LEFT JOIN teacher t ON c.teacher_id = t.id "
	            + "WHERE c.name LIKE ? OR c.room LIKE ? "
	            + "LIMIT ? OFFSET ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, "%" + keyword + "%");
	        ps.setString(2, "%" + keyword + "%");
	        ps.setInt(3, limit);
	        ps.setInt(4, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("id", rs.getInt("id"));
	            row.put("name", rs.getString("name"));
	            row.put("room", rs.getString("room"));
	            row.put("description", rs.getString("description"));
	            row.put("teacher_name", rs.getString("teacher_name"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countAll() {
	    String sql = "SELECT COUNT(*) FROM classroom";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	public int countSearch(String keyword) {
	    String sql = "SELECT COUNT(*) FROM classroom WHERE name LIKE ? OR room LIKE ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, "%" + keyword + "%");
	        ps.setString(2, "%" + keyword + "%");
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
}