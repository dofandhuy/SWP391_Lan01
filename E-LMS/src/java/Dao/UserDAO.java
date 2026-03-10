package Dao;

import Context.DBContext;
import Entity.Role;
import Entity.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    // Đăng nhập
   public User signIn(String email, String password) {
    String sql = "SELECT u.UserID, u.Username, u.PasswordHash, u.Email, u.FullName, "
               + "u.Avatar, u.Phone, u.Sex, u.Address, u.DOB, u.Status, u.CreatedAt, "
               + "r.RoleID, r.RoleName "
               + "FROM Users u JOIN Roles r ON u.RoleID = r.RoleID "
               + "WHERE u.Email = ? AND u.PasswordHash = ? AND u.Status = 1";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
            return new User(
                    rs.getInt("UserID"),
                    rs.getString("Username"),
                    rs.getString("PasswordHash"),
                    rs.getString("Email"),
                    rs.getString("FullName"),
                    rs.getString("Avatar"),
                    rs.getString("Phone"),
                    rs.getString("Sex"),
                    rs.getString("Address"),
                    rs.getDate("DOB"),
                    role,
                    rs.getBoolean("Status"),
                    rs.getTimestamp("CreatedAt")
            );
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}


    // Kiểm tra email tồn tại
    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM Users WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đăng ký
    // Đăng ký
public boolean Insert(User user) {
    String sql = "INSERT INTO Users (Username, PasswordHash, Email, FullName, Avatar, Phone, Sex, Address, DOB, RoleID, Status, CreatedAt) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPasswordHash());
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getFullName());
        ps.setString(5, user.getAvatar());
        ps.setString(6, user.getPhone());
        ps.setString(7, user.getSex());
        ps.setString(8, user.getAddress());
        ps.setDate(9, user.getDob()); // java.sql.Date
        ps.setInt(10, user.getRole().getRoleID());
        ps.setBoolean(11, user.isStatus());

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

   public User getUserByEmail(String email) {
    String sql = "SELECT u.UserID, u.Username, u.Email, u.PasswordHash, u.FullName, u.Avatar, "
               + "u.Phone, u.Sex, u.Address, u.DOB, u.Status, u.CreatedAt, "
               + "r.RoleID, r.RoleName "
               + "FROM Users u JOIN Roles r ON u.RoleID = r.RoleID "
               + "WHERE u.Email = ?";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, email);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setEmail(rs.getString("Email"));
                user.setPasswordHash(rs.getString("PasswordHash"));
                user.setFullName(rs.getString("FullName"));
                user.setAvatar(rs.getString("Avatar"));
                user.setPhone(rs.getString("Phone"));
                user.setSex(rs.getString("Sex"));
                user.setAddress(rs.getString("Address"));
                user.setDob(rs.getDate("DOB"));
                user.setStatus(rs.getBoolean("Status"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setRole(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
                return user;
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    // lấy hết role từ DB
    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT RoleID, RoleName FROM Roles";  // đổi theo cột thật trong DB

        try {Connection conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
      public void updateUser(User u) {
        String sql = "UPDATE Users SET Username=?, FullName=?, Email=?, Phone=?, Address=?, DOB=?, Sex=? WHERE UserID=?";
        try (
                Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getFullName());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getAddress());
            ps.setDate(6, u.getDob());
            ps.setString(7, u.getSex());
            ps.setInt(8, u.getUserID());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy tất cả user
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();

        String sql = """
            SELECT u.*, r.RoleName
            FROM Users u
            LEFT JOIN Roles r ON u.RoleID = r.RoleID
        """;

        try (Connection conn = new DBContext().getConnection(); 
                PreparedStatement ps = conn.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setUsername(rs.getString("Username"));
                u.setPasswordHash(rs.getString("PasswordHash"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setAvatar(rs.getString("Avatar"));
                u.setPhone(rs.getString("Phone"));
                u.setSex(rs.getString("Sex"));
                u.setAddress(rs.getString("Address"));
                u.setDob(rs.getDate("DOB"));
                u.setStatus(rs.getBoolean("Status"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));

                // Map Role
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                u.setRole(role);

                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    // Lấy user theo ID
public User getUserById(int id) {
    String sql = "SELECT * FROM Users WHERE UserID = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setUserID(rs.getInt("UserID"));
            u.setUsername(rs.getString("Username"));
            u.setPasswordHash(rs.getString("PasswordHash"));
            u.setEmail(rs.getString("Email"));
            u.setFullName(rs.getString("FullName"));
            u.setAvatar(rs.getString("Avatar"));
            u.setPhone(rs.getString("Phone"));
            u.setSex(rs.getString("Sex"));
            u.setAddress(rs.getString("Address"));
            u.setDob(rs.getDate("DOB"));
            u.setCreatedAt(rs.getTimestamp("CreatedAt"));

            // Convert int RoleID to Role object
            int roleId = rs.getInt("RoleID");
            Role role = getRoleById(roleId); // Bạn cần viết hàm này để lấy Role từ DB
            u.setRole(role);

            // Convert int Status to boolean
            boolean status = rs.getInt("Status") == 1;
            u.setStatus(status);

            return u;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
public Role getRoleById(int roleId) {
    String sql = "SELECT * FROM Roles WHERE RoleID = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, roleId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Role role = new Role();
            role.setRoleID(rs.getInt("RoleID"));
            role.setRoleName(rs.getString("RoleName"));
            // Thêm các trường khác nếu có
            return role;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
// Cập nhật mật khẩu theo Email
public boolean updatePassword(String email, String passwordHash) {
    String sql = "UPDATE Users SET PasswordHash = ? WHERE Email = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, passwordHash);
        ps.setString(2, email);
        int rows = ps.executeUpdate();
        return rows > 0; // trả về true nếu có ít nhất 1 record được update
    } catch (Exception e) {
        System.err.println("updatePassword error: " + e.getMessage());
    }
    return false;
}
public int getRoleIDByRoleName(String roleName){
    String sql =" SELECT RoleID FROM Roles Where RoleName = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)){
        ps.setString(1, roleName);
        try(ResultSet rs = ps.executeQuery()){
            if(rs.next()){
                return rs.getInt("RoleID");
            }
        }
    }catch(Exception e){
        Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error in getRoleIDByRoleName", e);
    }
     return -1;
}
public int findStudentIDByCredentials(String username, String email, int studentRoleID) {
        String sql = "SELECT UserID FROM Users WHERE Username = ? AND Email = ? AND RoleID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setInt(3, studentRoleID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("UserID");
                }
            }

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Error in findStudentIDByCredentials", e);
        }
        return -1;
    }

  }
