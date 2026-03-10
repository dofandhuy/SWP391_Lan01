package DAO;

import Entity.InstructorClass;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Context.DBContext;
import Entity.ClassEntity;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;


public class InstructorDAO {


     public List<InstructorClass> getClassesByInstructor(int instructorId) {
    List<InstructorClass> list = new ArrayList<>();
    String sql = """
        SELECT c.ClassID, c.ClassCode, c.ClassName,
               COUNT(DISTINCT ce.StudentID) AS student_count,
               COUNT(DISTINCT e.EventID) AS lesson_count,
               COUNT(DISTINCT a.AssignmentID) AS assignment_count,
               COUNT(DISTINCT m.MaterialID) AS document_count
        FROM Classes c
        LEFT JOIN ClassEnrollments ce ON c.ClassID = ce.ClassID
        LEFT JOIN Assignments a ON c.ClassID = a.ClassID
        LEFT JOIN Materials m ON c.ClassID = m.ClassID
        LEFT JOIN Events e ON c.ClassID = e.ClassID
        WHERE c.CreatedBy = ?
        GROUP BY c.ClassID, c.ClassCode, c.ClassName
    """;

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, instructorId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                InstructorClass ic = new InstructorClass();
                ic.setClassId(rs.getInt("ClassID"));
                ic.setClassCode(rs.getString("ClassCode"));
                ic.setClassName(rs.getString("ClassName"));
                ic.setStudentCount(rs.getInt("student_count"));
                ic.setLessonCount(rs.getInt("lesson_count"));
                ic.setAssignmentCount(rs.getInt("assignment_count"));
                ic.setDocumentCount(rs.getInt("document_count"));
                list.add(ic);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
     


    // Tạo mới class
    public void createClass(String classCode, String className, int instructorId) {
        String sql = "INSERT INTO Classes(class_code, class_name, instructor_id) VALUES (?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, classCode);
            ps.setString(2, className);
            ps.setInt(3, instructorId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ClassEntity getClassById(int classId) {
        String sql = "SELECT * FROM Classes WHERE ClassID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ClassEntity c = new ClassEntity();
                c.setClassId(rs.getInt("ClassID"));
                c.setClassName(rs.getString("ClassName"));
                c.setDescription(rs.getString("Description"));
                c.setClassCode(rs.getString("ClassCode"));
                c.setCreatedBy(rs.getInt("CreatedBy"));
                c.setCreatedAt(rs.getDate("CreatedAt"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
             Logger.getLogger(InstructorDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
        return null;
    }


    // Update class
    public boolean updateClass(int classId, String className, String description) {
        String sql = "UPDATE Classes SET ClassName = ?, Description = ? WHERE ClassID = ?";
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, className);
            ps.setString(2, description);
            ps.setInt(3, classId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
             Logger.getLogger(InstructorDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
        return false;
    }
    public void deleteClass(int classId)  {
        String sql = "DELETE FROM Classes WHERE ClassID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
             Logger.getLogger(InstructorDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
    }
}
