/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import Context.DBContext;
import Entity.Course;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ProgressDAO {

    public class EnrollmentDAO {
// Lấy recently viewed courses (lấy theo StudentProgress recent lessons => course)

        public List<Course> getRecentlyViewed(int studentId, int limit) {
            List<Course> list = new ArrayList<>();
            String sql = """
            SELECT DISTINCT TOP (?) c.CourseID, c.Title, c.Description
            FROM StudentProgress sp
            JOIN Enrollments e ON sp.EnrollmentID = e.EnrollmentID
            JOIN Lessons l ON sp.LessonID = l.LessonID
            JOIN Modules m ON l.ModuleID = m.ModuleID
            JOIN Courses c ON m.CourseID = c.CourseID
            WHERE e.StudentID = ?
            ORDER BY MAX(sp.CompletedAt) OVER (PARTITION BY c.CourseID) DESC;
        """;
            // NOTE: SQL Server doesn't allow ORDER BY with window without wrapper; we will use simpler query:
            sql = """
            SELECT TOP (?) c.CourseID, c.Title, c.Description, MAX(sp.CompletedAt) AS LastAt
            FROM StudentProgress sp
            JOIN Enrollments e ON sp.EnrollmentID = e.EnrollmentID
            JOIN Lessons l ON sp.LessonID = l.LessonID
            JOIN Modules m ON l.ModuleID = m.ModuleID
            JOIN Courses c ON m.CourseID = c.CourseID
            WHERE e.StudentID = ?
            GROUP BY c.CourseID, c.Title, c.Description
            ORDER BY MAX(sp.CompletedAt) DESC;
        """;
            try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, limit);
                ps.setInt(2, studentId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("CourseID"));
                    c.setTitle(rs.getString("Title"));
                    c.setDescription(rs.getString("Description"));
                    c.setThumbnail("https://via.placeholder.com/150");
                    list.add(c);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return list;
        }

        // Fallback: get recently by quiz attempts if no progress
        public List<Course> getRecentlyViewedByAttempts(int studentId, int limit) {
            List<Course> list = new ArrayList<>();
            String sql = """
            SELECT TOP (?) c.CourseID, c.Title, c.Description, MAX(qa.AttemptDate) AS LastAttempt
            FROM QuizAttempts qa
            JOIN Quizzes q ON qa.QuizID = q.QuizID
            LEFT JOIN Lessons l ON q.LessonID = l.LessonID
            LEFT JOIN Modules m ON l.ModuleID = m.ModuleID
            LEFT JOIN Courses c ON m.CourseID = c.CourseID
            WHERE qa.StudentID = ?
            GROUP BY c.CourseID, c.Title, c.Description
            ORDER BY MAX(qa.AttemptDate) DESC;
        """;
            try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, limit);
                ps.setInt(2, studentId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("CourseID"));
                    c.setTitle(rs.getString("Title"));
                    c.setDescription(rs.getString("Description"));
                    c.setThumbnail("https://via.placeholder.com/150");
                    list.add(c);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return list;
        }

    }
}
