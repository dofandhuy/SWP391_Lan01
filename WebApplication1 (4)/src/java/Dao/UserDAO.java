package Dao;

import Context.DBContext;
import Entity.Role;
import Entity.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Đăng nhập
    public User signIn(String email, String password) {
        String sql = "SELECT u.UserID, u.Username, u.PasswordHash, u.Email, u.FullName, "
                + "u.Avatar, u.Phone, u.Sex, u.Address, u.DOB, u.Status, u.CreatedAt, "
                + "r.RoleID, r.RoleName "
                + "FROM Users u JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE u.Email = ? AND u.PasswordHash = ? AND u.Status = 1";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try {
            Connection conn = new DBContext().getConnection();
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
public boolean changePassword(int userId, String currentPasswordHash, String newPasswordHash) {
    String checkSql = "SELECT PasswordHash FROM Users WHERE UserID = ?";
    String updateSql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

        checkPs.setInt(1, userId);
        ResultSet rs = checkPs.executeQuery();

        if (rs.next()) {
            String dbPassword = rs.getString("PasswordHash");
            if (!dbPassword.equals(currentPasswordHash)) { 
                return false; // sai mật khẩu hiện tại
            }
        } else {
            return false; // không tìm thấy user
        }

        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
            updatePs.setString(1, newPasswordHash);
            updatePs.setInt(2, userId);
            return updatePs.executeUpdate() > 0;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
public List<User> getFilteredUsers(int roleId, String gender, int status, String searchCategory, String searchValue) {
    List<User> userList = new ArrayList<>();
    // Câu lệnh SQL cơ bản
    StringBuilder sql = new StringBuilder(
        "SELECT u.UserID, u.Username, u.Email, u.Sex, u.Status, r.RoleName " +
        "FROM dbo.Users u JOIN dbo.Roles r ON u.RoleID = r.RoleID WHERE 1=1"
    );

    // Xây dựng câu lệnh SQL động dựa trên các bộ lọc
    if (roleId > 0) {
        sql.append(" AND u.RoleID = ?");
    }
    if (gender != null && !gender.isEmpty()) {
        sql.append(" AND u.Sex = ?");
    }
    if (status != -1) {
        sql.append(" AND u.Status = ?");
    }

    // Cập nhật logic tìm kiếm: Chỉ tìm kiếm trên một cột dựa vào searchCategory
    if (searchValue != null && !searchValue.isEmpty() && searchCategory != null && !searchCategory.isEmpty()) {
        if ("username".equalsIgnoreCase(searchCategory)) {
            sql.append(" AND u.Username LIKE ?");
        } else if ("email".equalsIgnoreCase(searchCategory)) {
            sql.append(" AND u.Email LIKE ?");
        }
    }

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        int idx = 1; // Index cho các tham số PreparedStatement
        
        if (roleId > 0) {
            ps.setInt(idx++, roleId);
        }
        if (gender != null && !gender.isEmpty()) {
            ps.setString(idx++, gender);
        }
        if (status != -1) {
            ps.setInt(idx++, status);
        }
        
        // Gán giá trị cho tham số tìm kiếm
        if (searchValue != null && !searchValue.isEmpty() && searchCategory != null && !searchCategory.isEmpty()) {
            ps.setString(idx++, "%" + searchValue + "%");
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            User user = new User();
            // Sử dụng setUserID thay vì setId để khớp với Entity của bạn
            user.setUserID(rs.getInt("UserID")); 
            user.setUsername(rs.getString("Username"));
            user.setEmail(rs.getString("Email"));
            user.setSex(rs.getString("Sex"));
            user.setStatus(rs.getInt("Status") == 1);
            
            Role role = new Role();
            role.setRoleName(rs.getString("RoleName"));
            user.setRole(role);
            
            userList.add(user);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return userList;
}

public void updateUserByAdmin(User user) {
    String sql = "UPDATE dbo.Users SET FullName = ?, Email = ?, Phone = ?, Sex = ?, Address = ?, RoleID = ?, Status = ? WHERE UserID = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhone());
        ps.setString(4, user.getSex());
        ps.setString(5, user.getAddress());
        ps.setInt(6, user.getRole().getRoleID());
        ps.setBoolean(7, user.isStatus());
        ps.setInt(8, user.getUserID());
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public User getUserByIdAdmin(int userId) {
    User user = null;
    // Sử dụng JOIN để lấy RoleName cùng lúc với thông tin User
    String sql = "SELECT u.*, r.RoleName FROM dbo.Users u JOIN dbo.Roles r ON u.RoleID = r.RoleID WHERE u.UserID = ?";
    
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            user = new User();
            // Lấy tất cả thông tin từ bảng Users
            user.setUserID(rs.getInt("UserID"));
            user.setUsername(rs.getString("Username"));
            user.setPasswordHash(rs.getString("PasswordHash")); // Giữ lại để đối tượng đầy đủ
            user.setEmail(rs.getString("Email"));
            user.setFullName(rs.getString("FullName"));
            user.setAvatar(rs.getString("Avatar"));
            user.setPhone(rs.getString("Phone"));
            user.setSex(rs.getString("Sex"));
            user.setAddress(rs.getString("Address"));
            user.setDob(rs.getDate("DOB"));
            user.setCreatedAt(rs.getTimestamp("CreatedAt"));
            user.setStatus(rs.getBoolean("Status"));

            // Lấy thông tin Role từ kết quả JOIN
            Role role = new Role();
            role.setRoleID(rs.getInt("RoleID"));
            role.setRoleName(rs.getString("RoleName")); // Lấy trực tiếp RoleName
            user.setRole(role);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return user;
}

public boolean deleteUser(int userId) {
    String sql = "DELETE FROM Users WHERE UserID = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userId);
        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
public String getInstructorNameByQuizId(int quizId) {
        String sql = """
            SELECT U.FullName
            FROM dbo.Users U
            JOIN dbo.Courses C ON U.UserID = C.InstructorID
            JOIN dbo.Modules M ON C.CourseID = M.CourseID
            JOIN dbo.Lessons L ON M.ModuleID = L.ModuleID
            JOIN dbo.Quizzes Q ON L.LessonID = Q.LessonID
            WHERE Q.QuizID = ?
        """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("FullName");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Unknown Instructor"; // Trả về giá trị mặc định nếu lỗi
    }
}
