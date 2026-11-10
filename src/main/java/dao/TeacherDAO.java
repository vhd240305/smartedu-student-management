package dao;

import model.Teacher;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class TeacherDAO {

	public List<Teacher> getAll() {

		List<Teacher> list = new ArrayList<>();

		String sql = "SELECT * FROM teacher";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Teacher teacher = new Teacher(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("department"), rs.getInt("account_id"));
				list.add(teacher);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public Teacher getById(int id) {

		String sql = "SELECT * FROM teacher WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Teacher teacher = new Teacher(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("department"), rs.getInt("account_id"));
				return teacher;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public void insert(Teacher t) {

		String sql = "INSERT INTO teacher(name,email,phone,department,account_id) VALUES(?,?,?,?,?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, t.getName());
			ps.setString(2, t.getEmail());
			ps.setString(3, t.getPhone());
			ps.setString(4, t.getDepartment());
			ps.setInt(5, t.getAccountId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void update(Teacher t) {

		String sql = "UPDATE teacher SET name=?, email=?, phone=?, department=? WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, t.getName());
			ps.setString(2, t.getEmail());
			ps.setString(3, t.getPhone());
			ps.setString(4, t.getDepartment());
			ps.setInt(5, t.getId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void delete(int id) {

		try (Connection conn = DBConnection.getConnection()) {

			// Lấy account_id
			String sql0 = "SELECT account_id FROM teacher WHERE id=?";
			PreparedStatement ps0 = conn.prepareStatement(sql0);
			ps0.setInt(1, id);
			ResultSet rs = ps0.executeQuery();

			int accountId = 0;
			if (rs.next()) {
				accountId = rs.getInt("account_id");
			}

			// Remove  teacher khỏi classroom
			String sql1 = "UPDATE classroom SET teacher_id=NULL WHERE teacher_id=?";

			PreparedStatement ps1 = conn.prepareStatement(sql1);
			ps1.setInt(1, id);
			ps1.executeUpdate();

			// Delete teacher
			String sql2 = "DELETE FROM teacher WHERE id=?";
			PreparedStatement ps2 = conn.prepareStatement(sql2);
			ps2.setInt(1, id);
			ps2.executeUpdate();

			// Delete account
			if (accountId != 0) {
				String sql3 = "DELETE FROM account WHERE id=?";
				PreparedStatement ps3 = conn.prepareStatement(sql3);
				ps3.setInt(1, accountId);
				ps3.executeUpdate();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Teacher> search(String keyword) {

		List<Teacher> list = new ArrayList<>();

		String sql = "SELECT * FROM teacher WHERE name LIKE ? OR email LIKE ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, "%" + keyword + "%");
			ps.setString(2, "%" + keyword + "%");

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Teacher teacher = new Teacher(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("department"), rs.getInt("account_id"));
				list.add(teacher);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<Map<String, Object>> getAllWithClasses() {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT t.id, t.name, t.email, t.phone, t.department, "
				+ "IFNULL(GROUP_CONCAT(c.name SEPARATOR ', '), 'Chưa phân lớp') AS classes " + "FROM teacher t "
				+ "LEFT JOIN classroom c ON t.id = c.teacher_id " + "GROUP BY t.id";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("id", rs.getInt("id"));
				row.put("name", rs.getString("name"));
				row.put("email", rs.getString("email"));
				row.put("phone", rs.getString("phone"));
				row.put("department", rs.getString("department"));
				row.put("classes", rs.getString("classes"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<Map<String, Object>> searchWithClasses(String keyword) {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT t.id, t.name, t.email, t.phone, t.department, "
				+ "IFNULL(GROUP_CONCAT(c.name SEPARATOR ', '), 'Chưa phân lớp') AS classes " + "FROM teacher t "
				+ "LEFT JOIN classroom c ON t.id = c.teacher_id " + "WHERE t.name LIKE ? OR t.email LIKE ? "
				+ "GROUP BY t.id";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, "%" + keyword + "%");
			ps.setString(2, "%" + keyword + "%");

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("id", rs.getInt("id"));
				row.put("name", rs.getString("name"));
				row.put("email", rs.getString("email"));
				row.put("phone", rs.getString("phone"));
				row.put("department", rs.getString("department"));
				row.put("classes", rs.getString("classes"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public Teacher getByAccountId(int accountId) {

		String sql = "SELECT * FROM teacher WHERE account_id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, accountId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Teacher teacher = new Teacher(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("department"), rs.getInt("account_id"));
				return teacher;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public void updateProfile(Teacher t) {

		String sql = "UPDATE teacher SET name=?, email=?, phone=?, department=? WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, t.getName());
			ps.setString(2, t.getEmail());
			ps.setString(3, t.getPhone());
			ps.setString(4, t.getDepartment());
			ps.setInt(5, t.getId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public List<Map<String, Object>> getWithPaging(int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT t.id, t.name, t.email, t.phone, t.department, "
	            + "IFNULL(GROUP_CONCAT(c.name SEPARATOR ', '), 'Chưa phân lớp') AS classes "
	            + "FROM teacher t "
	            + "LEFT JOIN classroom c ON t.id = c.teacher_id "
	            + "GROUP BY t.id LIMIT ? OFFSET ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, limit);
	        ps.setInt(2, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("id", rs.getInt("id"));
	            row.put("name", rs.getString("name"));
	            row.put("email", rs.getString("email"));
	            row.put("phone", rs.getString("phone"));
	            row.put("department", rs.getString("department"));
	            row.put("classes", rs.getString("classes"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public List<Map<String, Object>> searchWithPaging(String keyword, int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT t.id, t.name, t.email, t.phone, t.department, "
	            + "IFNULL(GROUP_CONCAT(c.name SEPARATOR ', '), 'Chưa phân lớp') AS classes "
	            + "FROM teacher t "
	            + "LEFT JOIN classroom c ON t.id = c.teacher_id "
	            + "WHERE t.name LIKE ? OR t.email LIKE ? "
	            + "GROUP BY t.id LIMIT ? OFFSET ?";
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
	            row.put("email", rs.getString("email"));
	            row.put("phone", rs.getString("phone"));
	            row.put("department", rs.getString("department"));
	            row.put("classes", rs.getString("classes"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countAll() {
	    String sql = "SELECT COUNT(*) FROM teacher";
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
	    String sql = "SELECT COUNT(*) FROM teacher WHERE name LIKE ? OR email LIKE ?";
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
	public List<Map<String, Object>> getWithFilterAndKeyword(String keyword, String department, String hasClass, int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder(
	        "SELECT t.id, t.name, t.email, t.phone, t.department, "
	        + "IFNULL(GROUP_CONCAT(c.name SEPARATOR ', '), 'Chưa phân lớp') AS classes "
	        + "FROM teacher t "
	        + "LEFT JOIN classroom c ON t.id = c.teacher_id "
	        + "WHERE 1=1 "
	    );
	    if (keyword != null && !keyword.isEmpty()) sql.append("AND (t.name LIKE ? OR t.email LIKE ?) ");
	    if (department != null && !department.isEmpty()) sql.append("AND t.department = ? ");
	    if ("yes".equals(hasClass)) sql.append("AND EXISTS (SELECT 1 FROM classroom WHERE teacher_id = t.id) ");
	    if ("no".equals(hasClass)) sql.append("AND NOT EXISTS (SELECT 1 FROM classroom WHERE teacher_id = t.id) ");
	    sql.append("GROUP BY t.id LIMIT ? OFFSET ?");

	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	        int idx = 1;
	        if (keyword != null && !keyword.isEmpty()) {
	            ps.setString(idx++, "%" + keyword + "%");
	            ps.setString(idx++, "%" + keyword + "%");
	        }
	        if (department != null && !department.isEmpty()) ps.setString(idx++, department);
	        ps.setInt(idx++, limit);
	        ps.setInt(idx, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("id", rs.getInt("id"));
	            row.put("name", rs.getString("name"));
	            row.put("email", rs.getString("email"));
	            row.put("phone", rs.getString("phone"));
	            row.put("department", rs.getString("department"));
	            row.put("classes", rs.getString("classes"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countWithFilter(String keyword, String department, String hasClass) {
	    StringBuilder sql = new StringBuilder(
	        "SELECT COUNT(*) FROM teacher t WHERE 1=1 "
	    );
	    if (keyword != null && !keyword.isEmpty()) sql.append("AND (t.name LIKE ? OR t.email LIKE ?) ");
	    if (department != null && !department.isEmpty()) sql.append("AND t.department = ? ");
	    if ("yes".equals(hasClass)) sql.append("AND EXISTS (SELECT 1 FROM classroom WHERE teacher_id = t.id) ");
	    if ("no".equals(hasClass)) sql.append("AND NOT EXISTS (SELECT 1 FROM classroom WHERE teacher_id = t.id) ");

	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	        int idx = 1;
	        if (keyword != null && !keyword.isEmpty()) {
	            ps.setString(idx++, "%" + keyword + "%");
	            ps.setString(idx++, "%" + keyword + "%");
	        }
	        if (department != null && !department.isEmpty()) ps.setString(idx++, department);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	public List<String> getAllDepartments() {
	    List<String> list = new ArrayList<>();
	    String sql = "SELECT DISTINCT department FROM teacher WHERE department IS NOT NULL ORDER BY department";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) list.add(rs.getString("department"));
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
}