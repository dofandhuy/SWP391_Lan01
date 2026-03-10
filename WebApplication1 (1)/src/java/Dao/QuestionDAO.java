package Dao;

import Context.DBContext;
import Entity.AnswerOption;
import Entity.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    // Insert 1 câu hỏi
    public int insertQuestion(Question q) {
        String sql = "INSERT INTO QuestionBank " +
             "(QuestionText, QuestionType, DifficultyLevel, Category, CreatedBy, CreatedAt, Status) " +
             "VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
           ps.setString(1, q.getQuestionText());
ps.setString(2, q.getQuestionType());
ps.setString(3, q.getDifficultyLevel());
ps.setString(4, q.getCategory());
ps.setInt(5, q.getCreatedBy());
ps.setString(6, q.getStatus()); 
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Insert danh sách đáp án
    public void insertAnswerOptions(int questionId, List<AnswerOption> options) {
        String sql = "INSERT INTO AnswerOptions (QuestionID, AnswerText, IsCorrect) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (AnswerOption op : options) {
                ps.setInt(1, questionId);
                ps.setString(2, op.getAnswerText());
                ps.setBoolean(3, op.isCorrect());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy tất cả câu hỏi của 1 user
    public List<Question> getQuestionsByUserID(int userID) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE CreatedBy = ? ORDER BY QuestionID";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapQuestion(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 // Map ResultSet sang Question
  
    private Question mapQuestion(ResultSet rs) throws SQLException {
    Question q = new Question();
    q.setQuestionID(rs.getInt("QuestionID"));
    q.setQuestionText(rs.getString("QuestionText"));
    q.setQuestionType(rs.getString("QuestionType"));
    q.setDifficultyLevel(rs.getString("DifficultyLevel"));
    q.setCategory(rs.getString("Category"));
    q.setCreatedBy(rs.getInt("CreatedBy"));
    q.setStatus(rs.getString("Status")); // status: Draft, Pending, Approved, Rejected

    Timestamp ts = rs.getTimestamp("CreatedAt");
    if (ts != null) q.setCreatedAt(ts.toLocalDateTime());

    Timestamp ts2 = rs.getTimestamp("UpdatedAt");
    if (ts2 != null) q.setUpdatedAt(ts2.toLocalDateTime());

    try {
        q.setUpdatedBy(rs.getInt("UpdatedBy"));
    } catch(Exception e) {
        q.setUpdatedBy(null);
    }

    // Mới: ReviewedBy, ReviewedAt, RejectionReason
    try {
        int reviewedBy = rs.getInt("ReviewedBy");
        if (!rs.wasNull()) q.setReviewedBy(reviewedBy);
        Timestamp reviewedAt = rs.getTimestamp("ReviewedAt");
        if (reviewedAt != null) q.setReviewedAt(reviewedAt.toLocalDateTime());
        String reason = rs.getString("RejectionReason");
        q.setRejectionReason(reason);
    } catch(Exception e) {
        q.setReviewedBy(null);
        q.setReviewedAt(null);
        q.setRejectionReason(null);
    }
    return q;
}
    // Search câu hỏi theo keyword và user
    public List<Question> searchQuestionsByUserIDAndKeyword(int userID, String keyword) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE CreatedBy=? AND QuestionText LIKE ? ORDER BY QuestionID";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapQuestion(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy câu hỏi theo ID
    public Question getQuestionByID(int questionID) {
        String sql = "SELECT * FROM QuestionBank WHERE QuestionID=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapQuestion(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách đáp án của câu hỏi
    public List<AnswerOption> getOptionsByQuestionID(int questionID) {
        List<AnswerOption> list = new ArrayList<>();
        String sql = "SELECT * FROM AnswerOptions WHERE QuestionID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AnswerOption o = new AnswerOption();
                o.setAnswerID(rs.getInt("AnswerID"));
                o.setQuestionID(rs.getInt("QuestionID"));
                o.setAnswerText(rs.getString("AnswerText"));
                o.setCorrect(rs.getBoolean("IsCorrect"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 public List<Question> searchAndSortQuestions(int userID, String keyword, String sort) {
    List<Question> list = new ArrayList<>();
    String sql = "SELECT * FROM QuestionBank WHERE CreatedBy=? AND QuestionText LIKE ?";
    
    // Thêm ORDER BY dựa trên sort
    if ("a-z".equals(sort)) {
        sql += " ORDER BY QuestionText ASC";
    } else if ("z-a".equals(sort)) {
        sql += " ORDER BY QuestionText DESC";
    } else if ("category".equals(sort)) {
        sql += " ORDER BY Category ASC";
    } else { // default
        sql += " ORDER BY QuestionID ASC";
    }

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userID);
        ps.setString(2, "%" + keyword + "%");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapQuestion(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    // Xóa câu hỏi (cả question + options)
   
public boolean deleteQuestionByIDAndUserID(int questionID, int userID) throws SQLException {
  String sqlDeleteAnswers = "DELETE FROM AnswerOptions WHERE QuestionID = ?";
String sqlDeleteQuestion = "DELETE FROM QuestionBank WHERE QuestionID = ? AND CreatedBy = ?";

try (Connection conn = DBContext.getConnection()) {
    PreparedStatement ps1 = conn.prepareStatement(sqlDeleteAnswers);
    ps1.setInt(1, questionID);
    ps1.executeUpdate();

    PreparedStatement ps2 = conn.prepareStatement(sqlDeleteQuestion);
    ps2.setInt(1, questionID);
    ps2.setInt(2, userID);
    int rows = ps2.executeUpdate();

    return rows > 0;
}
}

   public void updateQuestion(Question question, List<AnswerOption> options) {
    String sqlQuestion = "UPDATE QuestionBank SET questionText=?, DifficultyLevel=?, category=?, Status=? WHERE questionID=?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement psQuestion = conn.prepareStatement(sqlQuestion)) {
        psQuestion.setString(1, question.getQuestionText());
        psQuestion.setString(2, question.getDifficultyLevel());
        psQuestion.setString(3, question.getCategory());
        psQuestion.setString(4, question.getStatus()); // <-- thêm dòng này
        psQuestion.setInt(5, question.getQuestionID());
        psQuestion.executeUpdate();

        String sqlOption = "UPDATE AnswerOptions SET answerText=?, isCorrect=? WHERE answerID=?";
        for (AnswerOption o : options) {
            try (PreparedStatement psOption = conn.prepareStatement(sqlOption)) {
                psOption.setString(1, o.getAnswerText());
                psOption.setBoolean(2, o.isCorrect());
                psOption.setInt(3, o.getAnswerID());
                psOption.executeUpdate();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
   
   
     public List<String> getAllCategories(int userID) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT Category FROM QuestionBank WHERE CreatedBy = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String cat = rs.getString("Category");
                if (cat != null && !cat.isEmpty()) categories.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }
     
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT q.QuestionID, q.QuestionText, q.QuestionType, 
                   q.DifficultyLevel, q.Category
            FROM QuestionBank q
            INNER JOIN QuizQuestions qq ON q.QuestionID = qq.QuestionID
            WHERE qq.QuizID = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionID(rs.getInt("QuestionID"));
                q.setQuestionText(rs.getString("QuestionText"));
                q.setQuestionType(rs.getString("QuestionType"));
                q.setDifficultyLevel(rs.getString("DifficultyLevel"));
                q.setCategory(rs.getString("Category"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Question> getAllQuestions() {
    List<Question> list = new ArrayList<>();
    String sql = "SELECT * FROM QuestionBank ORDER BY QuestionID";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapQuestion(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    public String getUserNameByID(int userID) {
    String name = "-";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT Username FROM Users WHERE UserID=?")) {
        ps.setInt(1, userID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("Username");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return name;
}
     
}
    