package Dao;

import Context.DBContext;
import java.sql.*;
import java.util.*;
import Entity.Course;
import Entity.InstructorStats;

public class InstructorDashboardDao {

    public InstructorStats getInstructorStats(int instructorId) {
        InstructorStats stats = new InstructorStats();
        try (Connection conn = DBContext.getConnection()) {

            // 1️⃣ Tổng số khóa học
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT COUNT(*) FROM Courses WHERE InstructorID = ?");
            ps1.setInt(1, instructorId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) stats.setTotalCourses(rs1.getInt(1));

            // 2️⃣ Tổng số module
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT COUNT(*) FROM Modules m JOIN Courses c ON m.CourseID = c.CourseID WHERE c.InstructorID = ?");
            ps2.setInt(1, instructorId);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) stats.setTotalModules(rs2.getInt(1));

            // 3️⃣ Tổng số bài học
            PreparedStatement ps3 = conn.prepareStatement(
                "SELECT COUNT(*) FROM Lessons l JOIN Modules m ON l.ModuleID = m.ModuleID JOIN Courses c ON m.CourseID = c.CourseID WHERE c.InstructorID = ?");
            ps3.setInt(1, instructorId);
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) stats.setTotalLessons(rs3.getInt(1));

            // 4️⃣ Tổng số quiz
            PreparedStatement ps4 = conn.prepareStatement(
                "SELECT COUNT(*) FROM Quizzes q JOIN Modules m ON q.ModuleID = m.ModuleID JOIN Courses c ON m.CourseID = c.CourseID WHERE c.InstructorID = ?");
            ps4.setInt(1, instructorId);
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) stats.setTotalQuizzes(rs4.getInt(1));

            // 5️⃣ Tổng số học viên
            PreparedStatement ps5 = conn.prepareStatement(
                "SELECT COUNT(DISTINCT e.StudentID) FROM Enrollments e JOIN Courses c ON e.CourseID = c.CourseID WHERE c.InstructorID = ?");
            ps5.setInt(1, instructorId);
            ResultSet rs5 = ps5.executeQuery();
            if (rs5.next()) stats.setTotalStudents(rs5.getInt(1));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Course> getRecentCourses(int instructorId, int limit) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT TOP (?) CourseID, Title, Status, CreatedAt FROM Courses WHERE InstructorID = ? ORDER BY CreatedAt DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, instructorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setStatus(rs.getString("Status"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
