/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Context.DBContext;
import Entity.LinkedStudent;
import Entity.Relationship;
import Entity.User;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author doanh
 */
public class ParentStudentDAO {
    
    public User getStudentByEmail(String email) {
        String sql = """
            SELECT u.UserID, u.Username, u.Email, r.RoleName
            FROM Users u
            JOIN Roles r ON u.RoleID = r.RoleID
            WHERE u.Email = ? AND r.RoleName = 'Student'
        """;
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
        String sql = "SELECT * FROM ParentStudentLink WHERE ParentID = ? AND StudentID = ?";
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
    String sql = "INSERT INTO ParentStudentLink (ParentID, StudentID, RelationshipID, Note, LinkDate, Status) VALUES (?, ?, ?, ?, GETDATE(), 'Active')";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, parentID);
        ps.setInt(2, studentID);
        ps.setInt(3, relationshipID);
        ps.setString(4, note);

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace(); // Bắt buộc nên có
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

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
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
    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, linkID);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
public boolean updateRelationship(int linkID, int relationshipID) {
    String sql = "UPDATE ParentStudentLink SET RelationshipID = ? WHERE LinkID = ?";
    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, relationshipID);
        ps.setInt(2, linkID);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
public boolean approveLinkRequest(int linkID) {
    String sql = "UPDATE ParentStudentLink SET Status = 'Active' WHERE LinkID = ?";
    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, linkID);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

public boolean rejectLinkRequest(int linkID) {
    String sql = "UPDATE ParentStudentLink SET Status = 'Inactive' WHERE LinkID = ?";
    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
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
    String sql = "SELECT u.UserID, u.Username, u.Email, u.FullName, u.Avatar, " +
                 "CASE WHEN u.Status = 1 THEN 'Active' ELSE 'Inactive' END AS StatusText " +
                 "FROM dbo.Users AS u JOIN dbo.ParentStudentLink AS psl ON u.UserID = psl.StudentID " +
                 "WHERE psl.LinkID = ?";

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
}
