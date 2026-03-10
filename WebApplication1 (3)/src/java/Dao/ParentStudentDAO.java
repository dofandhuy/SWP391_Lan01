package Dao;

import Context.DBContext;
import Entity.LinkedStudent;
import Entity.ParentStudentLink;
import Entity.Relationship;
import Entity.User;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

import java.util.ArrayList;
import java.util.List;
import jdk.jfr.Timestamp;

/**
 *
 * @author doanh
 */
public class ParentStudentDAO {

    public User findParentByStudentId(int studentId) {
        // Câu lệnh SQL này sẽ:
        // 1. JOIN bảng Users (đặt tên là 'p' cho parent) với bảng ParentStudentLink (đặt tên là 'l')
        // 2. Dựa trên điều kiện p.UserID = l.ParentID
        // 3. Lọc ra bản ghi có StudentID mà chúng ta cung cấp và có trạng thái là 'Active'
        String sql = """
                 SELECT p.UserID, p.FullName, p.Email
                 FROM Users p
                 JOIN ParentStudentLink l ON p.UserID = l.ParentID
                 WHERE l.StudentID = ? 
                 """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Gán giá trị studentId cho dấu ? trong câu lệnh SQL
            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();

            // Nếu tìm thấy một kết quả
            if (rs.next()) {
                User parent = new User();
                // Lấy thông tin cần thiết của phụ huynh để hiển thị trên trang profile
                parent.setUserID(rs.getInt("UserID"));
                parent.setFullName(rs.getString("FullName"));
                parent.setEmail(rs.getString("Email"));

                return parent; // Trả về đối tượng User của phụ huynh
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console nếu có sự cố
        }

        // Trả về null nếu không tìm thấy phụ huynh nào hoặc có lỗi xảy ra
        return null;
    }

    public User getStudentByEmail(String email) {
        String sql = """
            SELECT u.UserID, u.Username, u.Email, r.RoleName
            FROM Users u
            JOIN Roles r ON u.RoleID = r.RoleID
            WHERE u.Email = ? AND r.RoleName = 'Student'
        """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setUsername(rs.getString("Username"));
                u.setEmail(rs.getString("Email"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Relationship> getAllRelationships() {
        List<Relationship> list = new ArrayList<>();
        String sql = "SELECT RelationshipID, RelationshipName FROM Relationships";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Relationship r = new Relationship();
                r.setRelationshipID(rs.getInt("RelationshipID"));
                r.setRelationshipName(rs.getString("RelationshipName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int findRelationshipID(String relationshipName) {
        String sql = "SELECT RelationshipID FROM Relationships WHERE RelationshipName = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, relationshipName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("RelationshipID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean checkLinkExists(int parentID, int studentID) {

        // THAY ĐỔI SQL Ở ĐÂY: Thêm điều kiện kiểm tra Status
        String sql = "SELECT 1 FROM ParentStudentLink WHERE ParentID = ? AND StudentID = ? AND Status IN ('Active', 'Pending','Inactive')";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentID);

            ps.setInt(2, studentID);

            ResultSet rs = ps.executeQuery();

            return rs.next();
        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }

    public boolean createLinkRequest(int parentID, int studentID, int relationshipID, String note) {
        // THAY ĐỔI Ở ĐÂY: Status mặc định là 'Pending'
        String sql = "INSERT INTO ParentStudentLink (ParentID, StudentID, RelationshipID, Note) VALUES (?, ?, ?, ?)";
        // Giá trị mặc định 'Pending' đã được thiết lập ở mức cơ sở dữ liệu, nên không cần truyền vào đây nữa.

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentID);
            ps.setInt(2, studentID);
            ps.setInt(3, relationshipID);
            ps.setString(4, note);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<LinkedStudent> getLinkedStudentsByParentID(int parentID) {
        List<LinkedStudent> list = new ArrayList<>();
        String sql = """
        SELECT l.LinkID, l.ParentID, l.StudentID, u.FullName AS StudentName, 
               u.Email, r.RelationshipName, l.Note, l.LinkDate, l.Status
        FROM ParentStudentLink l
        JOIN Users u ON l.StudentID = u.UserID
        JOIN Relationships r ON l.RelationshipID = r.RelationshipID
        WHERE l.ParentID = ?
    """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LinkedStudent s = new LinkedStudent(
                            rs.getInt("LinkID"),
                            rs.getInt("ParentID"),
                            rs.getInt("StudentID"),
                            rs.getString("StudentName"),
                            rs.getString("Email"),
                            rs.getString("RelationshipName"),
                            rs.getString("Note"),
                            rs.getTimestamp("LinkDate"),
                            rs.getString("Status")
                    );
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean deleteLink(int linkID) {
        String sql = "DELETE FROM ParentStudentLink WHERE LinkID = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, linkID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRelationship(int linkID, int relationshipID) {
        String sql = "UPDATE ParentStudentLink SET RelationshipID = ? WHERE LinkID = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, relationshipID);
            ps.setInt(2, linkID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean approveLinkRequest(int linkID) {

        String sql = """
                 UPDATE psl_to_update
                 SET Status = 'Active'
                 FROM ParentStudentLink AS psl_to_update
                 WHERE
                     psl_to_update.LinkID = ? AND
                     NOT EXISTS (
                         SELECT 1
                         FROM ParentStudentLink AS existing_link
                         WHERE
                             existing_link.StudentID = psl_to_update.StudentID
                             AND existing_link.LinkID <> ? 
                             AND existing_link.Status IN ('Active', 'Inactive')
                     )
                 """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, linkID);
            ps.setInt(2, linkID); // LinkID được dùng 2 lần trong câu query

            // ps.executeUpdate() sẽ trả về 1 nếu cập nhật thành công (điều kiện đúng)
            // và trả về 0 nếu cập nhật thất bại (do điều kiện NOT EXISTS sai).
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectLinkRequest(int linkID) {
        // THAY ĐỔI Ở ĐÂY: từ 'Inactive' thành 'Rejected'
        String sql = "UPDATE ParentStudentLink SET Status = 'Rejected' WHERE LinkID = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, linkID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User findStudentByLinkId(int linkId) {
        User student = null;
        // Câu SQL vẫn giữ nguyên, rất chính xác
        String sql = "SELECT u.UserID, u.Username, u.Email, u.FullName, u.Avatar, "
                + "CASE WHEN u.Status = 1 THEN 'Active' ELSE 'Inactive' END AS StatusText "
                + "FROM dbo.Users AS u JOIN dbo.ParentStudentLink AS psl ON u.UserID = psl.StudentID "
                + "WHERE psl.LinkID = ?";

        try (Connection conn = new DBContext().getConnection(); // Thay DBContext bằng lớp kết nối của bạn
                 PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, linkId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                student = new User(); // TẠO ĐỐI TƯỢNG USERS

                // Map dữ liệu từ ResultSet vào đối tượng Users
                student.setUserID(rs.getInt("UserID")); // Giả sử tên phương thức là setUserID
                student.setUsername(rs.getString("Username"));
                student.setEmail(rs.getString("Email"));
                student.setFullName(rs.getString("FullName"));
                student.setAvatar(rs.getString("Avatar")); // Tên cột trong DB là Avatar
                student.setStatus(rs.getBoolean("Status")); // Lấy từ cột đã đổi tên
            }
        } catch (Exception e) {
            e.printStackTrace(); // Xử lý lỗi
        }
        return student;
    }

    public User getParentByEmail(String email) {
        String sql = """
                 SELECT u.UserID, u.Username, u.Email, r.RoleName
                 FROM Users u
                 JOIN Roles r ON u.RoleID = r.RoleID
                 WHERE u.Email = ? AND r.RoleName = 'Parent'
                 """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setUsername(rs.getString("Username"));
                u.setEmail(rs.getString("Email"));
                // Bạn có thể không cần set role ở đây vì đã lọc trong SQL
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<LinkedStudent> getPendingRequestsByParentID(int parentID) {
        List<LinkedStudent> list = new ArrayList<>();
        String sql = """
     SELECT l.LinkID, l.ParentID, l.StudentID, u.FullName AS StudentName, 
            u.Email, r.RelationshipName, l.Note, l.LinkDate, l.Status
     FROM ParentStudentLink l
     JOIN Users u ON l.StudentID = u.UserID
     JOIN Relationships r ON l.RelationshipID = r.RelationshipID
     WHERE l.ParentID = ? AND l.Status = 'Pending'
 """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LinkedStudent s = new LinkedStudent(
                            rs.getInt("LinkID"), rs.getInt("ParentID"), rs.getInt("StudentID"),
                            rs.getString("StudentName"), rs.getString("Email"), rs.getString("RelationshipName"),
                            rs.getString("Note"), rs.getTimestamp("LinkDate"), rs.getString("Status")
                    );
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<LinkedStudent> getActiveLinkedStudentsByParentID(int parentID) {
        List<LinkedStudent> list = new ArrayList<>();
        String sql = """
     SELECT l.LinkID, l.ParentID, l.StudentID, u.FullName AS StudentName, 
            u.Email, r.RelationshipName, l.Note, l.LinkDate, l.Status
     FROM ParentStudentLink l
     JOIN Users u ON l.StudentID = u.UserID
     JOIN Relationships r ON l.RelationshipID = r.RelationshipID
     WHERE l.ParentID = ? AND l.Status NOT IN ('Pending', 'Rejected')
 """;
        // ... code try-catch để thực thi query và add vào list giống hệt phương thức cũ ...
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LinkedStudent s = new LinkedStudent(
                            rs.getInt("LinkID"), rs.getInt("ParentID"), rs.getInt("StudentID"),
                            rs.getString("StudentName"), rs.getString("Email"), rs.getString("RelationshipName"),
                            rs.getString("Note"), rs.getTimestamp("LinkDate"), rs.getString("Status")
                    );
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deactivateLink(int linkID) {
        String sql = "UPDATE ParentStudentLink SET Status = 'Inactive' WHERE LinkID = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, linkID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ParentStudentLink getLinkByStudentId(int studentId) {
        String sql = "SELECT * FROM ParentStudentLink WHERE StudentID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ParentStudentLink link = new ParentStudentLink();
                link.setLinkID(rs.getInt("LinkID"));
                link.setParentID(rs.getInt("ParentID"));
                link.setStudentID(rs.getInt("StudentID"));
                link.setRelationshipID(rs.getInt("RelationshipID"));
                link.setNote(rs.getString("Note"));
                link.setStatus(rs.getString("Status"));

                // Chuyển đổi từ java.sql.Timestamp sang java.time.LocalDateTime
                java.sql.Timestamp linkTimestamp = rs.getTimestamp("LinkDate");
                if (linkTimestamp != null) {
                    link.setLinkDate(linkTimestamp.toLocalDateTime());
                }

                return link;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ParentStudentLink getLinkByParentAndStudentId(int parentID, int studentID) {
        String sql = "SELECT * FROM ParentStudentLink WHERE ParentID = ? AND StudentID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentID);
            ps.setInt(2, studentID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ParentStudentLink link = new ParentStudentLink();
                link.setLinkID(rs.getInt("LinkID"));
                link.setParentID(rs.getInt("ParentID"));
                link.setStudentID(rs.getInt("StudentID"));
                link.setStatus(rs.getString("Status"));
                // Bạn có thể set thêm các trường khác nếu cần
                return link;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRejectedLink(int parentID, int studentID, int relationshipID, String note) {
        String sql = "UPDATE ParentStudentLink SET Status = 'Pending', RelationshipID = ?, Note = ?, LinkDate = SYSUTCDATETIME() "
                + "WHERE ParentID = ? AND StudentID = ? AND Status = 'Rejected'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, relationshipID);
            ps.setString(2, note);
            ps.setInt(3, parentID);
            ps.setInt(4, studentID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    } 
    public List<LinkedStudent> getAllLinksByStudentId(int studentId) {
    List<LinkedStudent> allLinks = new ArrayList<>();
    String sql = """
                 SELECT u.Email AS ParentEmail, l.Status
                 FROM ParentStudentLink l
                 JOIN Users u ON l.ParentID = u.UserID
                 WHERE l.StudentID = ?
                 ORDER BY l.LinkDate DESC -- Sắp xếp để link mới nhất lên đầu
                 """;

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            // Tạo đối tượng LinkedStudent chỉ với thông tin cần thiết
            LinkedStudent link = new LinkedStudent();
            link.setEmail(rs.getString("ParentEmail")); // Chỉ cần email
            link.setStatus(rs.getString("Status"));     // và status
            allLinks.add(link);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return allLinks;
}
}
