package dao;

import model.Account;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import at.favre.lib.crypto.bcrypt.BCrypt;

public class AccountDAO {

//	public Account login(String username, String password) {
//
//		Account acc = null;
//
//		try {
//
//			Connection conn = DBConnection.getConnection();
//
//			String sql = "SELECT * FROM account WHERE username=? AND password=?";
//
//			PreparedStatement ps = conn.prepareStatement(sql);
//
//			ps.setString(1, username);
//			ps.setString(2, password);
//
//			ResultSet rs = ps.executeQuery();
//			if (rs.next()) {
//
//				acc = new Account();
//
//				acc.setId(rs.getInt("id"));
//				acc.setUsername(rs.getString("username"));
//				acc.setPassword(rs.getString("password"));
//				acc.setRole(rs.getString("role"));
//			}
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//		return acc;
//	}
//
//	public int create(String username, String password, String role) {
//
//		int id = 0;
//
//		String sql = "INSERT INTO account(username,password,role) VALUES(?,?,?)";
//
//		try (Connection conn = DBConnection.getConnection();
//				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//
//			ps.setString(1, username);
//			ps.setString(2, password);
//			ps.setString(3, role);
//
//			ps.executeUpdate();
//
//			ResultSet rs = ps.getGeneratedKeys();
//
//			if (rs.next()) {
//				id = rs.getInt(1);
//			}
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//		return id;
//	}

//	public boolean changePassword(int accountId, String oldPass, String newPass) {
//
//		String checkSql = "SELECT * FROM account WHERE id=? AND password=?";
//		String updateSql = "UPDATE account SET password=? WHERE id=?";
//
//		try (Connection conn = DBConnection.getConnection()) {
//
//			PreparedStatement check = conn.prepareStatement(checkSql);
//			check.setInt(1, accountId);
//			check.setString(2, oldPass);
//
//			ResultSet rs = check.executeQuery();
//
//			if (rs.next()) {
//
//				PreparedStatement update = conn.prepareStatement(updateSql);
//				update.setString(1, newPass);
//				update.setInt(2, accountId);
//
//				update.executeUpdate();
//
//				return true;
//			}
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//		return false;
//	}
//
//	public void changePassword(int accountId, String newPassword) {
//
//		String sql = "UPDATE account SET password=? WHERE id=?";
//
//		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//
//			ps.setString(1, newPassword);
//			ps.setInt(2, accountId);
//
//			ps.executeUpdate();
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}

	public List<Account> getAll() {

		List<Account> list = new ArrayList<>();

		String sql = "SELECT * FROM account";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(new Account(rs.getInt("id"), rs.getString("username"), rs.getString("password"),
						rs.getString("role")));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public Account getById(int id) {

		String sql = "SELECT * FROM account WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return new Account(rs.getInt("id"), rs.getString("username"), rs.getString("password"),
						rs.getString("role"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

//	public void insert(Account a) {
//		if (existsByUsername(a.getUsername()) == false) {
//			String sql = "INSERT INTO account(username,password,role) VALUES(?,?,?)";
//
//			try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//
//				ps.setString(1, a.getUsername());
//				ps.setString(2, a.getPassword());
//				ps.setString(3, a.getRole());
//
//				ps.executeUpdate();
//
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
//	}
//
//	public void update(Account a) {
//
//		String sql = "UPDATE account SET username=?,password=?,role=? WHERE id=?";
//
//		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//
//			ps.setString(1, a.getUsername());
//			ps.setString(2, a.getPassword());
//			ps.setString(3, a.getRole());
//			ps.setInt(4, a.getId());
//
//			ps.executeUpdate();
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}

	public void delete(int id) {

		String sql = "DELETE FROM account WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Account> search(String keyword) {

		List<Account> list = new ArrayList<>();

		String sql = "SELECT * FROM account WHERE username LIKE ? OR role LIKE ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, "%" + keyword + "%");
			ps.setString(2, "%" + keyword + "%");

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(new Account(rs.getInt("id"), rs.getString("username"), rs.getString("password"),
						rs.getString("role")));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public boolean existsByUsername(String username) {
		String sql = "SELECT 1 FROM account WHERE username = ? LIMIT 1";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();
			return rs.next();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<Account> getWithPaging(int offset, int limit) {
	    List<Account> list = new ArrayList<>();
	    String sql = "SELECT * FROM account LIMIT ? OFFSET ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, limit);
	        ps.setInt(2, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            list.add(new Account(rs.getInt("id"), rs.getString("username"),
	                    rs.getString("password"), rs.getString("role")));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public List<Account> searchWithPaging(String keyword, int offset, int limit) {
	    List<Account> list = new ArrayList<>();
	    String sql = "SELECT * FROM account WHERE username LIKE ? OR role LIKE ? LIMIT ? OFFSET ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, "%" + keyword + "%");
	        ps.setString(2, "%" + keyword + "%");
	        ps.setInt(3, limit);
	        ps.setInt(4, offset);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            list.add(new Account(rs.getInt("id"), rs.getString("username"),
	                    rs.getString("password"), rs.getString("role")));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countAll() {
	    String sql = "SELECT COUNT(*) FROM account";
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
	    String sql = "SELECT COUNT(*) FROM account WHERE username LIKE ? OR role LIKE ?";
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
	
	// Hash password khi tạo mới
	public int create(String username, String password, String role) {
	    int id = 0;
	    String hashedPassword = BCrypt.withDefaults().hashToString(12, password.toCharArray());
	    String sql = "INSERT INTO account(username,password,role) VALUES(?,?,?)";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
	        ps.setString(1, username);
	        ps.setString(2, hashedPassword);
	        ps.setString(3, role);
	        ps.executeUpdate();
	        ResultSet rs = ps.getGeneratedKeys();
	        if (rs.next()) id = rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return id;
	}

	// Đăng nhập - verify password
	public Account login(String username, String password) {
	    Account acc = null;
	    try {
	        Connection conn = DBConnection.getConnection();
	        String sql = "SELECT * FROM account WHERE username=?";
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setString(1, username);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            String hashedPassword = rs.getString("password");
	            BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), hashedPassword);
	            if (result.verified) {
	                acc = new Account();
	                acc.setId(rs.getInt("id"));
	                acc.setUsername(rs.getString("username"));
	                acc.setPassword(rs.getString("password"));
	                acc.setRole(rs.getString("role"));
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return acc;
	}
	
	public void insert(Account a) {
	    if (!existsByUsername(a.getUsername())) {
	        String hashedPassword = BCrypt.withDefaults().hashToString(12, a.getPassword().toCharArray());
	        String sql = "INSERT INTO account(username,password,role) VALUES(?,?,?)";
	        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setString(1, a.getUsername());
	            ps.setString(2, hashedPassword);
	            ps.setString(3, a.getRole());
	            ps.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	}

	public void update(Account a) {
	    String hashedPassword = BCrypt.withDefaults().hashToString(12, a.getPassword().toCharArray());
	    String sql = "UPDATE account SET username=?, password=?, role=? WHERE id=?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, a.getUsername());
	        ps.setString(2, hashedPassword);
	        ps.setString(3, a.getRole());
	        ps.setInt(4, a.getId());
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	public boolean changePassword(int accountId, String oldPass, String newPass) {
	    String checkSql = "SELECT * FROM account WHERE id=?";
	    String updateSql = "UPDATE account SET password=? WHERE id=?";
	    try (Connection conn = DBConnection.getConnection()) {
	        PreparedStatement check = conn.prepareStatement(checkSql);
	        check.setInt(1, accountId);
	        ResultSet rs = check.executeQuery();
	        if (rs.next()) {
	            String hashedPassword = rs.getString("password");
	            BCrypt.Result result = BCrypt.verifyer().verify(oldPass.toCharArray(), hashedPassword);
	            if (result.verified) {
	                String newHashed = BCrypt.withDefaults().hashToString(12, newPass.toCharArray());
	                PreparedStatement update = conn.prepareStatement(updateSql);
	                update.setString(1, newHashed);
	                update.setInt(2, accountId);
	                update.executeUpdate();
	                return true;
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	public void changePassword(int accountId, String newPassword) {
	    String hashedPassword = BCrypt.withDefaults().hashToString(12, newPassword.toCharArray());
	    String sql = "UPDATE account SET password=? WHERE id=?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, hashedPassword);
	        ps.setInt(2, accountId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	//Cho API
	public Account findByUsername(String username) {
	    String sql = "SELECT * FROM account WHERE username = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, username);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new Account(rs.getInt("id"), rs.getString("username"),
	                    rs.getString("password"), rs.getString("role"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	//Cho quên mật khẩu
	public Account findByEmail(String email) {
	    String sql = "SELECT a.* FROM account a " +
	                 "LEFT JOIN student s ON s.account_id = a.id " +
	                 "LEFT JOIN teacher t ON t.account_id = a.id " +
	                 "WHERE s.email = ? OR t.email = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, email);
	        ps.setString(2, email);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new Account(rs.getInt("id"), rs.getString("username"),
	                    rs.getString("password"), rs.getString("role"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}

}

