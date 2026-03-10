package Dao;
import Context.DBContext;
import java.sql.*;
import java.time.LocalDate;

public class EnrollmentDAO {

    
    //Kiểm tra enroll
    public boolean isEnrolled(int studentId, int courseId) {
        String sql = "SELECT 1 FROM Enrollments WHERE StudentID=? AND CourseID=? AND Status='Enrolled'";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            LocalDate deadline = LocalDate.now().plusDays(30);
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
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
}
