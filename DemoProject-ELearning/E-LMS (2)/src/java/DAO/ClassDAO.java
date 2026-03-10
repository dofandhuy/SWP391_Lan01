package DAO;

import Entity.ClassEntity;

import Context.DBContext;

import Entity.ClassInfo;

import Entity.ClassModel;

import Entity.Event;

import java.sql.Connection;

import java.sql.*;

import java.util.ArrayList;

import java.util.List;

import java.util.logging.Level;

import java.util.logging.Logger;



public class ClassDAO {



  

    public List<ClassInfo> getEnrolledClasses(int studentId) {

        List<ClassInfo> list = new ArrayList<>();



        String sql = """

            SELECT 

                c.ClassID, 

                c.ClassName,

                (SELECT COUNT(*) FROM ClassEnrollments ce2 WHERE ce2.ClassID = c.ClassID) AS student_count,

                (SELECT COUNT(*) FROM Assignments a WHERE a.ClassID = c.ClassID) AS assignment_count,

                (SELECT COUNT(*) FROM Materials m WHERE m.ClassID = c.ClassID) AS document_count

            FROM Classes c

            JOIN ClassEnrollments ce ON ce.ClassID = c.ClassID

            WHERE ce.StudentID = ?

        """;



        try (

                Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {



            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();



            while (rs.next()) {

                list.add(new ClassInfo(

                        rs.getInt("ClassID"),

                        rs.getString("ClassName"),

                        rs.getInt("student_count"),

                        0, // lesson_count tạm thời

                        rs.getInt("assignment_count"),

                        rs.getInt("document_count")

                ));

            }



        } catch (Exception e) {

            e.printStackTrace();

        }



        return list;

    }



    public void createClass(ClassEntity cls) {

        String sql = "INSERT INTO Classes (ClassName, Description, ClassCode, CreatedBy, CreatedAt) VALUES (?,?,?,?,?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cls.getClassName());

            ps.setString(2, cls.getDescription());

            ps.setString(3, cls.getClassCode());

            ps.setInt(4, cls.getCreatedBy());

            ps.setTimestamp(5, new Timestamp(cls.getCreatedAt().getTime()));

            ps.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();

        }

    }



    public boolean updateClass(ClassEntity c) throws Exception {

        String sql = "UPDATE Classes SET className=?, classCode=?, description=? WHERE classId=?";

        try (

                Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getClassName());

            ps.setString(2, c.getClassCode());

            ps.setString(3, c.getDescription());

            ps.setInt(4, c.getClassId());
return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;

        }

    }



    public ClassModel getClassById(int classId) {

        String sql = "SELECT ClassID, ClassName, ClassCode, CreatedBy FROM Classes WHERE ClassID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return new ClassModel(

                        rs.getInt("ClassID"),

                        rs.getString("ClassName"),

                        rs.getString("ClassCode"),

                        rs.getInt("CreatedBy")

                );

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }



    public int countStudentsInClass(int classId) {

        String sql = "SELECT COUNT(*) AS total FROM ClassEnrollments WHERE ClassID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("total");

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;

    }



    public boolean isStudentEnrolled(int studentId, int classId) {

        String sql = "SELECT COUNT(*) FROM ClassEnrollments WHERE StudentID=? AND ClassID=?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            ps.setInt(2, classId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1) > 0;

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }



    public boolean enrollStudent(int studentId, int classId) {

        String sql = "INSERT INTO ClassEnrollments(StudentID, ClassID) VALUES(?,?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            ps.setInt(2, classId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }



    public int getClassIdByCode(String classCode) {

        String sql = "SELECT classId FROM Classes WHERE classCode = ?";

        try (

                Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, classCode);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("classId");

            }
} catch (SQLException e) {

            e.printStackTrace(); // Hoặc log lỗi nếu cần

        } catch (Exception ex) {

            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, null, ex);

        }

        return -1; // Trả về -1 nếu không tìm thấy

    }

     public int countExercises(int classId) {

        String sql = "SELECT COUNT(*) AS total FROM Assignments WHERE ClassID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("total");

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;

    }

     public int countSubmittedOnTime(int classId) {

        String sql = """

                     SELECT COUNT(*) AS total

                     FROM AssignmentSubmissions s

                     JOIN Assignments a ON s.AssignmentID = a.AssignmentID

                     WHERE a.ClassID = ? AND s.SubmittedAt <= a.DueDate

                     """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("total");

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;

    }

         public List<Event> getEventsByClass(int classId) {

        List<Event> list = new ArrayList<>();

        String sql = "SELECT EventID, Title, EventType, StartTime, EndTime FROM Events WHERE ClassID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                list.add(new Event(

                        rs.getInt("EventID"),

                        rs.getString("Title"),

                        rs.getString("EventType"),

                        rs.getTimestamp("StartTime"),

                        rs.getTimestamp("EndTime")

                ));

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

}
