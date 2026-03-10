package Dao;
import Context.DBContext;
import Entity.Course;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {

    //Kiểm tra enroll
    public boolean isEnrolled(int studentId, int courseId) {
        String sql = "SELECT 1 FROM Enrollments WHERE StudentID=? AND CourseID=? AND Status='Enrolled'";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //Chèn vào bảng Enrollments
    public void enrollStudent(int studentId, int courseId) {
        String sql = """
            INSERT INTO Enrollments (StudentID, CourseID, Deadline)
            VALUES (?, ?, ?)
        """;
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            LocalDate deadline = LocalDate.now().plusDays(120);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.setDate(3, java.sql.Date.valueOf(deadline));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Date getDeadlineByQuizId(int studentId, int quizId) {
        String sql = """
            SELECT E.Deadline
            FROM dbo.Enrollments E
            JOIN dbo.Courses C ON E.CourseID = C.CourseID
            JOIN dbo.Modules M ON C.CourseID = M.CourseID
            JOIN dbo.Lessons L ON M.ModuleID = L.ModuleID
            JOIN dbo.Quizzes Q ON L.LessonID = Q.LessonID
            WHERE
                Q.QuizID = ?
                AND E.StudentID = ?
                AND E.Status = 'Enrolled'
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);

            ps.setInt(2, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Cột Deadline trong DB của bạn là kiểu DATE
                // nên dùng getDate() là chính xác
                Date deadline = rs.getDate("Deadline");

                if (deadline != null) {
                    // Chuyển java.sql.Date thành java.util.Date
                    return new Date(deadline.getTime());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không có deadline
    }

    public boolean createEnrollment(int studentID, int courseID) {
        String sql = "INSERT INTO Enrollments (StudentID, CourseID, Deadline, Status) VALUES (?, ?, DATEADD(month, 6, GETDATE()), 'Enrolled')";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ps.setInt(2, courseID);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Course> getEnrolledCoursesByStudentId(int studentId) {
        List<Course> list = new ArrayList<>();

        String sql = """
SELECT 
                c.CourseID, 
                c.Title AS CourseName, 
                u.FullName AS InstructorName,
                e.Status AS EnrollmentStatus, 
                ISNULL(sp.Progress, 0) AS Progress
            FROM Enrollments e
            JOIN Courses c ON e.CourseID = c.CourseID
            JOIN Users u ON c.InstructorID = u.UserID
            LEFT JOIN (
                SELECT 
                    e.StudentID, 
                    e.CourseID,
                    CAST(SUM(CASE WHEN sp.IsCompleted = 1 THEN 1 ELSE 0 END) AS FLOAT) / 
                    NULLIF(COUNT(sp.LessonID), 0) * 100 AS Progress
                FROM Enrollments e
                JOIN StudentProgress sp ON e.EnrollmentID = sp.EnrollmentID
                GROUP BY e.StudentID, e.CourseID
            ) sp ON e.StudentID = sp.StudentID AND e.CourseID = sp.CourseID
            WHERE e.StudentID = ?
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setCourseID(rs.getInt("CourseID"));
                    c.setTitle(rs.getString("CourseName"));
                    c.setInstructorName(rs.getString("InstructorName"));
                    c.setStatus(rs.getString("EnrollmentStatus"));
                    c.setProgress(rs.getDouble("Progress")); // bạn có thể thêm trường progress vào Course entity
                    list.add(c);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
