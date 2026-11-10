package dao;

import model.Classroom;
import model.Student;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class StudentDAO {
	public List<Student> getAll() {

		List<Student> list = new ArrayList<>();

		String sql = "SELECT * FROM student";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Student s = new Student(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("gender"), rs.getString("dob"), rs.getString("address"),
						rs.getInt("account_id"));
				s.setAvatar(rs.getString("avatar"));
				list.add(s);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public Student getById(int id) {

		String sql = "SELECT * FROM student WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				Student s = new Student(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("gender"), rs.getString("dob"), rs.getString("address"),
						rs.getInt("account_id"));
				s.setAvatar(rs.getString("avatar"));

				return s;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public void insert(Student s) {

		String sql = "INSERT INTO student(name,email,phone,gender,dob,address,account_id,avatar) VALUES(?,?,?,?,?,?,?,?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, s.getName());
			ps.setString(2, s.getEmail());
			ps.setString(3, s.getPhone());
			ps.setString(4, s.getGender());
			ps.setString(5, s.getDob());
			ps.setString(6, s.getAddress());
			ps.setInt(7, s.getAccountId());
			ps.setString(8, s.getAvatar());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void update(Student s) {

		String sql = "UPDATE student SET name=?, email=?, phone=?, gender=?, dob=?, address=?, avatar=? WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, s.getName());
			ps.setString(2, s.getEmail());
			ps.setString(3, s.getPhone());
			ps.setString(4, s.getGender());
			ps.setString(5, s.getDob());
			ps.setString(6, s.getAddress());
			ps.setString(7, s.getAvatar());
			ps.setInt(8, s.getId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void delete(int id) {

		try (Connection conn = DBConnection.getConnection()) {

			int accountId = 0;

			// Lấy account_id
			String sql0 = "SELECT account_id FROM student WHERE id=?";
			PreparedStatement ps0 = conn.prepareStatement(sql0);
			ps0.setInt(1, id);

			ResultSet rs = ps0.executeQuery();

			if (rs.next()) {
				accountId = rs.getInt("account_id");
			}

			System.out.println("Student ID = " + id);
			System.out.println("Account ID = " + accountId);

			// Xóa bảng trung gian
			String sql1 = "DELETE FROM student_classroom WHERE student_id=?";
			PreparedStatement ps1 = conn.prepareStatement(sql1);
			ps1.setInt(1, id);
			ps1.executeUpdate();

			// Xóa student
			String sql2 = "DELETE FROM student WHERE id=?";
			PreparedStatement ps2 = conn.prepareStatement(sql2);
			ps2.setInt(1, id);
			ps2.executeUpdate();

			// Xóa account
			if (accountId > 0) {
				String sql3 = "DELETE FROM account WHERE id=?";
				PreparedStatement ps3 = conn.prepareStatement(sql3);
				ps3.setInt(1, accountId);
				ps3.executeUpdate();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Map<String, Object>> searchWithClassrooms(String keyword) {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
				+ "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_names " + "FROM student s "
				+ "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
				+ "LEFT JOIN classroom c ON sc.classroom_id = c.id " + "WHERE s.name LIKE ? OR s.email LIKE ? "
				+ "GROUP BY s.id";

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
				row.put("gender", rs.getString("gender"));
				row.put("dob", rs.getString("dob"));
				row.put("address", rs.getString("address"));
				row.put("classes", rs.getString("class_names"));
				row.put("avatar", rs.getString("avatar"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public void assignToClassroom(int studentId, int classroomId) {

		String sql = "INSERT INTO student_classroom(student_id, classroom_id) VALUES(?,?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, classroomId);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Integer> getClassroomIdsByStudent(int studentId) {

		List<Integer> list = new ArrayList<>();

		String sql = "SELECT classroom_id FROM student_classroom WHERE student_id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(rs.getInt("classroom_id"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public int insertAndGetId(Student s) {

		int id = 0;

		String sql = "INSERT INTO student(name,email,phone,gender,dob,address,account_id,avatar) VALUES(?,?,?,?,?,?,?,?)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setString(1, s.getName());
			ps.setString(2, s.getEmail());
			ps.setString(3, s.getPhone());
			ps.setString(4, s.getGender());
			ps.setString(5, s.getDob());
			ps.setString(6, s.getAddress());
			ps.setInt(7, s.getAccountId());
			ps.setString(8, s.getAvatar());

			ps.executeUpdate();

			ResultSet rs = ps.getGeneratedKeys();

			if (rs.next()) {
				id = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return id;
	}

	public List<Map<String, Object>> getAllWithClassrooms() {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
				+ "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_names " + "FROM student s "
				+ "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
				+ "LEFT JOIN classroom c ON sc.classroom_id = c.id " + "GROUP BY s.id";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("id", rs.getInt("id"));
				row.put("name", rs.getString("name"));
				row.put("email", rs.getString("email"));
				row.put("phone", rs.getString("phone"));
				row.put("gender", rs.getString("gender"));
				row.put("dob", rs.getString("dob"));
				row.put("address", rs.getString("address"));
				row.put("classes", rs.getString("class_names"));
				row.put("avatar", rs.getString("avatar"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public void deleteStudentClassrooms(int studentId) {

		String sql = "DELETE FROM student_classroom WHERE student_id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public Student getByAccountId(int accountId) {

		String sql = "SELECT * FROM student WHERE account_id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, accountId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				Student s = new Student(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("gender"), rs.getString("dob"), rs.getString("address"),
						rs.getInt("account_id"));
				s.setAvatar(rs.getString("avatar"));

				return s;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public List<Classroom> getClassesByStudent(int studentId) {

		List<Classroom> list = new ArrayList<>();

		String sql = "SELECT c.id, c.name, c.room, c.description, "
				+ "IFNULL(t.name, 'Chưa có giáo viên') AS teacher_name " + "FROM classroom c "
				+ "JOIN student_classroom sc ON c.id = sc.classroom_id " + "LEFT JOIN teacher t ON c.teacher_id = t.id "
				+ "WHERE sc.student_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Classroom classroom = new Classroom(rs.getInt("id"), rs.getString("name"), rs.getString("room"),
						rs.getString("description"));
				list.add(classroom);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<Map<String, Object>> getTeachersByStudent(int studentId) {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT c.name AS class_name, t.name AS teacher_name " + "FROM classroom c "
				+ "LEFT JOIN teacher t ON c.teacher_id = t.id " + // Dùng LEFT JOIN để an toàn
				"JOIN student_classroom sc ON sc.classroom_id = c.id " + "WHERE sc.student_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("class_name", rs.getString("class_name"));
				row.put("teacher_name", rs.getString("teacher_name"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public void updateProfile(Student s) {

		String sql = "UPDATE student SET name=?, email=?, phone=?, gender=?, dob=?, address=?, avatar=? WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, s.getName());
			ps.setString(2, s.getEmail());
			ps.setString(3, s.getPhone());
			ps.setString(4, s.getGender());
			ps.setString(5, s.getDob());
			ps.setString(6, s.getAddress());
			ps.setString(7, s.getAvatar());
			ps.setInt(8, s.getId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Map<String, Object>> getStudentsByTeacher(int teacherId) {

		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
				+ "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_name " + "FROM student s "
				+ "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
				+ "LEFT JOIN classroom c ON sc.classroom_id = c.id " + "WHERE c.teacher_id = ? " + "GROUP BY s.id";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, teacherId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Map<String, Object> row = new HashMap<>();

				row.put("id", rs.getInt("id"));
				row.put("name", rs.getString("name"));
				row.put("email", rs.getString("email"));
				row.put("phone", rs.getString("phone"));
				row.put("class", rs.getString("class_name"));

				list.add(row);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<Student> getStudentsByClassroom(int classroomId) {

		List<Student> list = new ArrayList<>();

		String sql = "SELECT s.* " + "FROM student s " + "JOIN student_classroom sc ON s.id = sc.student_id "
				+ "WHERE sc.classroom_id=? " + "ORDER BY s.name";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, classroomId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Student s = new Student(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
						rs.getString("phone"), rs.getString("gender"), rs.getString("dob"), rs.getString("address"),
						rs.getInt("account_id"));
				s.setAvatar(rs.getString("avatar"));
				list.add(s);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	
	public List<Map<String, Object>> getWithPaging(int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
	            + "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_names "
	            + "FROM student s "
	            + "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
	            + "LEFT JOIN classroom c ON sc.classroom_id = c.id "
	            + "GROUP BY s.id LIMIT ? OFFSET ?";
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
	            row.put("gender", rs.getString("gender"));
	            row.put("dob", rs.getString("dob"));
	            row.put("address", rs.getString("address"));
	            row.put("classes", rs.getString("class_names"));
	            row.put("avatar", rs.getString("avatar"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public List<Map<String, Object>> searchWithPaging(String keyword, int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
	            + "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_names "
	            + "FROM student s "
	            + "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
	            + "LEFT JOIN classroom c ON sc.classroom_id = c.id "
	            + "WHERE s.name LIKE ? OR s.email LIKE ? "
	            + "GROUP BY s.id LIMIT ? OFFSET ?";
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
	            row.put("gender", rs.getString("gender"));
	            row.put("dob", rs.getString("dob"));
	            row.put("address", rs.getString("address"));
	            row.put("classes", rs.getString("class_names"));
	            row.put("avatar", rs.getString("avatar"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countAll() {
	    String sql = "SELECT COUNT(*) FROM student";
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
	    String sql = "SELECT COUNT(*) FROM student WHERE name LIKE ? OR email LIKE ?";
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
	
	public List<Map<String, Object>> getWithFilter(String gender, String classroomId, String yearOfBirth, int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder(
	        "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
	        + "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_names "
	        + "FROM student s "
	        + "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
	        + "LEFT JOIN classroom c ON sc.classroom_id = c.id "
	        + "WHERE 1=1 "
	    );
	    if (gender != null && !gender.isEmpty()) sql.append("AND s.gender = ? ");
	    if (classroomId != null && !classroomId.isEmpty()) sql.append("AND sc.classroom_id = ? ");
	    if (yearOfBirth != null && !yearOfBirth.isEmpty()) sql.append("AND YEAR(s.dob) = ? ");
	    sql.append("GROUP BY s.id LIMIT ? OFFSET ?");

	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	        int idx = 1;
	        if (gender != null && !gender.isEmpty()) ps.setString(idx++, gender);
	        if (classroomId != null && !classroomId.isEmpty()) ps.setInt(idx++, Integer.parseInt(classroomId));
	        if (yearOfBirth != null && !yearOfBirth.isEmpty()) ps.setInt(idx++, Integer.parseInt(yearOfBirth));
	        ps.setInt(idx++, limit);
	        ps.setInt(idx, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("id", rs.getInt("id"));
	            row.put("name", rs.getString("name"));
	            row.put("email", rs.getString("email"));
	            row.put("phone", rs.getString("phone"));
	            row.put("gender", rs.getString("gender"));
	            row.put("dob", rs.getString("dob"));
	            row.put("address", rs.getString("address"));
	            row.put("classes", rs.getString("class_names"));
	            row.put("avatar", rs.getString("avatar"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countWithFilter(String keyword, String gender, String classroomId, String yearOfBirth) {
	    StringBuilder sql = new StringBuilder(
	        "SELECT COUNT(DISTINCT s.id) FROM student s "
	        + "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
	        + "LEFT JOIN classroom c ON sc.classroom_id = c.id "
	        + "WHERE 1=1 "
	    );
	    if (keyword != null && !keyword.isEmpty()) sql.append("AND (s.name LIKE ? OR s.email LIKE ?) ");
	    if (gender != null && !gender.isEmpty()) sql.append("AND s.gender = ? ");
	    if (classroomId != null && !classroomId.isEmpty()) sql.append("AND sc.classroom_id = ? ");
	    if (yearOfBirth != null && !yearOfBirth.isEmpty()) sql.append("AND YEAR(s.dob) = ? ");

	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	        int idx = 1;
	        if (keyword != null && !keyword.isEmpty()) {
	            ps.setString(idx++, "%" + keyword + "%");
	            ps.setString(idx++, "%" + keyword + "%");
	        }
	        if (gender != null && !gender.isEmpty()) ps.setString(idx++, gender);
	        if (classroomId != null && !classroomId.isEmpty()) ps.setInt(idx++, Integer.parseInt(classroomId));
	        if (yearOfBirth != null && !yearOfBirth.isEmpty()) ps.setInt(idx++, Integer.parseInt(yearOfBirth));
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	public List<Map<String, Object>> getWithFilterAndKeyword(String keyword, String gender, String classroomId, String yearOfBirth, int offset, int limit) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder(
	        "SELECT s.id, s.name, s.email, s.phone, s.gender, s.dob, s.address, s.avatar, "
	        + "GROUP_CONCAT(c.name SEPARATOR ', ') AS class_names "
	        + "FROM student s "
	        + "LEFT JOIN student_classroom sc ON s.id = sc.student_id "
	        + "LEFT JOIN classroom c ON sc.classroom_id = c.id "
	        + "WHERE 1=1 "
	    );
	    if (keyword != null && !keyword.isEmpty()) sql.append("AND (s.name LIKE ? OR s.email LIKE ?) ");
	    if (gender != null && !gender.isEmpty()) sql.append("AND s.gender = ? ");
	    if (classroomId != null && !classroomId.isEmpty()) sql.append("AND sc.classroom_id = ? ");
	    if (yearOfBirth != null && !yearOfBirth.isEmpty()) sql.append("AND YEAR(s.dob) = ? ");
	    sql.append("GROUP BY s.id LIMIT ? OFFSET ?");

	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	        int idx = 1;
	        if (keyword != null && !keyword.isEmpty()) {
	            ps.setString(idx++, "%" + keyword + "%");
	            ps.setString(idx++, "%" + keyword + "%");
	        }
	        if (gender != null && !gender.isEmpty()) ps.setString(idx++, gender);
	        if (classroomId != null && !classroomId.isEmpty()) ps.setInt(idx++, Integer.parseInt(classroomId));
	        if (yearOfBirth != null && !yearOfBirth.isEmpty()) ps.setInt(idx++, Integer.parseInt(yearOfBirth));
	        ps.setInt(idx++, limit);
	        ps.setInt(idx, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("id", rs.getInt("id"));
	            row.put("name", rs.getString("name"));
	            row.put("email", rs.getString("email"));
	            row.put("phone", rs.getString("phone"));
	            row.put("gender", rs.getString("gender"));
	            row.put("dob", rs.getString("dob"));
	            row.put("address", rs.getString("address"));
	            row.put("classes", rs.getString("class_names"));
	            row.put("avatar", rs.getString("avatar"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public Map<String, Integer> countByGender() {
	    Map<String, Integer> map = new LinkedHashMap<>();
	    String sql = "SELECT gender, COUNT(*) as total FROM student GROUP BY gender";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) {
	            map.put(rs.getString("gender"), rs.getInt("total"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return map;
	}

	public List<Map<String, Object>> countByClassroom() {
	    List<Map<String, Object>> list = new ArrayList<>();
	    String sql = "SELECT c.name, COUNT(sc.student_id) as total "
	            + "FROM classroom c "
	            + "LEFT JOIN student_classroom sc ON c.id = sc.classroom_id "
	            + "GROUP BY c.id, c.name ORDER BY total DESC";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("name", rs.getString("name"));
	            row.put("total", rs.getInt("total"));
	            list.add(row);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public void deleteMultiple(List<Integer> ids) {
	    try (Connection conn = DBConnection.getConnection()) {
	        for (int id : ids) {
	            int accountId = 0;

	            String sql0 = "SELECT account_id FROM student WHERE id=?";
	            PreparedStatement ps0 = conn.prepareStatement(sql0);
	            ps0.setInt(1, id);
	            ResultSet rs = ps0.executeQuery();
	            if (rs.next()) accountId = rs.getInt("account_id");

	            String sql1 = "DELETE FROM student_classroom WHERE student_id=?";
	            PreparedStatement ps1 = conn.prepareStatement(sql1);
	            ps1.setInt(1, id);
	            ps1.executeUpdate();

	            String sql2 = "DELETE FROM student WHERE id=?";
	            PreparedStatement ps2 = conn.prepareStatement(sql2);
	            ps2.setInt(1, id);
	            ps2.executeUpdate();

	            if (accountId > 0) {
	                String sql3 = "DELETE FROM account WHERE id=?";
	                PreparedStatement ps3 = conn.prepareStatement(sql3);
	                ps3.setInt(1, accountId);
	                ps3.executeUpdate();
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	//Lấy danh sách sinh viên chưa có lớp
	public List<Student> getStudentsNotInClassroom(int classroomId) {
	    List<Student> list = new ArrayList<>();
	    String sql = "SELECT * FROM student WHERE id NOT IN "
	            + "(SELECT student_id FROM student_classroom WHERE classroom_id = ?) "
	            + "ORDER BY name";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, classroomId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Student s = new Student(rs.getInt("id"), rs.getString("name"),
	                    rs.getString("email"), rs.getString("phone"),
	                    rs.getString("gender"), rs.getString("dob"),
	                    rs.getString("address"), rs.getInt("account_id"));
	            s.setAvatar(rs.getString("avatar"));
	            list.add(s);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	//Xóa sinh khỏi lớp
	public void removeFromClassroom(int studentId, int classroomId) {
	    String sql = "DELETE FROM student_classroom WHERE student_id=? AND classroom_id=?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, studentId);
	        ps.setInt(2, classroomId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	//Kiểm tra sinh viên có trong lớp không
	public boolean isInClassroom(int studentId, int classroomId) {
	    String sql = "SELECT 1 FROM student_classroom WHERE student_id=? AND classroom_id=?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, studentId);
	        ps.setInt(2, classroomId);
	        ResultSet rs = ps.executeQuery();
	        return rs.next();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
}
