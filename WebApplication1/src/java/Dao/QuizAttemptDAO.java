package Dao;

import Context.DBContext;
import Entity.HighestAttemptInfo;
import Entity.QuizAttemptQuestion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class QuizAttemptDAO extends DBContext {

    // ... (Giữ các hàm createAttempt, saveStudentAnswer, updateAttemptScore của bạn) ...

    /**
     * ✅ [GĐ 1] Lấy điểm cao nhất của học sinh cho 1 quiz.
     */
   public HighestAttemptInfo getHighestAttemptInfo(int studentId, int quizId) {
        // SQL: Chọn dòng có điểm cao nhất. Nếu điểm bằng nhau, ưu tiên lượt làm mới nhất.
        String sql = """
            SELECT TOP 1 AttemptID, Score
            FROM dbo.QuizAttempts
            WHERE StudentID = ? AND QuizID = ? AND Score IS NOT NULL
            ORDER BY Score DESC, AttemptDate DESC
        """;

        try (Connection conn = DBContext.getConnection(); // Lấy connection
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Lấy Score dùng getObject để xử lý NULL an toàn
                Double score = rs.getDouble("Score");
                // Lấy AttemptID dùng getObject
                Integer attemptId = rs.getInt("AttemptID");

                // Chỉ trả về nếu cả hai giá trị đều không null
                if (score != null && attemptId != null) {
                    return new HighestAttemptInfo(score, attemptId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console
        }
        // Trả về null nếu không tìm thấy, hoặc score là null, hoặc có lỗi
        return null;
    }

    /**
     * ✅ [GĐ 1] Lấy tổng số lần đã làm bài.
     */
    public int getTotalAttempts(int studentId, int quizId) {
        String sql = "SELECT COUNT(AttemptID) AS Total FROM QuizAttempts " +
                     "WHERE StudentID = ? AND QuizID = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("Total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu có lỗi hoặc chưa làm
    }

    /**
     * ✅ [GĐ 1] Lấy thời điểm làm bài cuối cùng.
     */
    public Date getLastAttemptTime(int studentId, int quizId) {
        String sql = "SELECT MAX(AttemptDate) AS LastAttempt FROM QuizAttempts " +
                     "WHERE StudentID = ? AND QuizID = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Timestamp ts = rs.getTimestamp("LastAttempt");
                if (ts != null) {
                    return new Date(ts.getTime());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu chưa làm lần nào
    }
    public int createAttempt(int studentId, int quizId) {
        // Dùng OUTPUT INSERTED.AttemptID để lấy ID tự tăng ngay lập tức
        String sql = "INSERT INTO QuizAttempts (StudentID, QuizID, AttemptDate) " +
                     "OUTPUT INSERTED.AttemptID VALUES (?, ?, SYSUTCDATETIME())";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("AttemptID"); // Trả về ID của lượt làm bài mới
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu thất bại
    }
    public void saveStudentAnswer(int attemptId, int questionId, String studentAnswer, boolean isCorrect) {
        String sql = "INSERT INTO dbo.QuizAttemptQuestions (AttemptID, QuestionID, StudentAnswer, IsCorrect) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, attemptId);
            ps.setInt(2, questionId);
            // Handle potentially long answers for FillBlank, use setNString for NVARCHAR(MAX)
            ps.setNString(3, studentAnswer);
            ps.setBoolean(4, isCorrect);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            // Consider logging the error more formally
        }
    }
    public void updateAttemptScore(int attemptId, double score, int durationSeconds) {
        String sql = "UPDATE dbo.QuizAttempts SET Score = ?, DurationSeconds = ? WHERE AttemptID = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, score);
            // Handle potential negative duration if clock sync issues occur
            ps.setInt(2, Math.max(0, durationSeconds));
            ps.setInt(3, attemptId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            // Consider logging the error
        }
    }
    public Date getAttemptStartTime(int attemptId) {
        String sql = "SELECT AttemptDate FROM dbo.QuizAttempts WHERE AttemptID = ?";
        
        try (Connection conn = DBContext.getConnection(); // Use your DBContext method
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, attemptId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // AttemptDate is DATETIME2 in SQL Server, use getTimestamp
                Timestamp startTimeStamp = rs.getTimestamp("AttemptDate");
                if (startTimeStamp != null) {
                    // Convert java.sql.Timestamp to java.util.Date
                    return new Date(startTimeStamp.getTime());
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
        }
        return null; // Return null if not found or error
    }
   public List<QuizAttemptQuestion> getStudentAnswersForAttempt(int attemptId) {
        List<QuizAttemptQuestion> studentAnswers = new ArrayList<>();
        String sql = "SELECT AttemptID, QuestionID, StudentAnswer, IsCorrect " +
                     "FROM dbo.QuizAttemptQuestions WHERE AttemptID = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, attemptId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                QuizAttemptQuestion qa = new QuizAttemptQuestion();
                qa.setAttemptId(rs.getInt("AttemptID"));
                qa.setQuestionId(rs.getInt("QuestionID"));
                qa.setStudentAnswer(rs.getString("StudentAnswer"));

                // --- FIX START ---
                // Use getBoolean for BIT columns
                boolean isCorrectDbValue = rs.getBoolean("IsCorrect");
                // Check if the value retrieved was actually NULL in the database
                if (rs.wasNull()) {
                    qa.setCorrect(false); // Default to false if the DB had NULL
                     System.err.println("Warning: IsCorrect was NULL in DB for AttemptID=" + attemptId + ", QuestionID=" + rs.getInt("QuestionID"));
                } else {
                    qa.setCorrect(isCorrectDbValue); // Use the boolean value retrieved
                }
                // --- FIX END ---

                studentAnswers.add(qa);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
        }
        return studentAnswers; // Will be empty if no rows found or error occurred
    }
    public int getQuizIdForAttempt(int attemptId) {
        String sql = "SELECT QuizID FROM dbo.QuizAttempts WHERE AttemptID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("QuizID");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
        }
        return -1; // Return -1 if not found or error
    }
    public double getAttemptScore(int attemptId) {
        String sql = "SELECT Score FROM dbo.QuizAttempts WHERE AttemptID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Score is DECIMAL(5,2) which can be retrieved as Double
                // Use getObject to handle potential NULL score
                Object scoreObj = rs.getObject("Score");
                if (scoreObj != null) {
                    // Convert the Number object (likely BigDecimal) to double
                    return ((Number) scoreObj).doubleValue();
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
        }
        // Return 0.0 if score is NULL or attempt not found
        return 0.0;
    }
}