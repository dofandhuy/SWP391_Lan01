package Dao;

import Context.DBContext;
import Entity.AnswerOption;
import Entity.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    // === 1️⃣ Lấy hoặc tạo Category ===
    public int getOrCreateCategoryID(String categoryName) {
        if (categoryName == null || categoryName.trim().isEmpty()) return 0;
        String checkSql = "SELECT CategoryID FROM Category WHERE CategoryName = ?";
        String insertSql = "INSERT INTO Category (CategoryName) VALUES (?)";
        try (Connection conn = DBContext.getConnection()) {
            // Kiểm tra tồn tại
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setString(1, categoryName);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) return rs.getInt("CategoryID");

            // Nếu chưa có thì thêm mới
            PreparedStatement psInsert = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            psInsert.setString(1, categoryName);
            psInsert.executeUpdate();
            ResultSet rs2 = psInsert.getGeneratedKeys();
            if (rs2.next()) return rs2.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // === 2️⃣ Thêm câu hỏi mới vào QuestionBank ===
    public int insertQuestion(Question q) {
        String sql = """
            INSERT INTO QuestionBank
            (QuestionText, QuestionType, DifficultyLevel, CategoryID, CreatedBy, CreatedAt, Status)
            VALUES (?, ?, ?, ?, ?, GETDATE(), ?)
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getQuestionType());
            ps.setString(3, q.getDifficultyLevel());
            ps.setInt(4, q.getCategoryID());
            ps.setInt(5, q.getCreatedBy());
            ps.setString(6, q.getStatus());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // === 3️⃣ Thêm danh sách đáp án ===
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

    // === 4️⃣ Lấy tất cả câu hỏi của 1 user ===
    public List<Question> getQuestionsByUserID(int userID) {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT q.*, c.CategoryName 
            FROM QuestionBank q
            LEFT JOIN Category c ON q.CategoryID = c.CategoryID
            WHERE q.CreatedBy = ?
            ORDER BY q.QuestionID
        """;
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

    // === 5️⃣ Map ResultSet sang Question ===
    private Question mapQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionID(rs.getInt("QuestionID"));
        q.setQuestionText(rs.getString("QuestionText"));
        q.setQuestionType(rs.getString("QuestionType"));
        q.setDifficultyLevel(rs.getString("DifficultyLevel"));
        q.setCategoryID(rs.getInt("CategoryID"));
        q.setCategoryName(rs.getString("CategoryName"));
        q.setCreatedBy(rs.getInt("CreatedBy"));
        q.setStatus(rs.getString("Status"));
        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) q.setCreatedAt(ts.toLocalDateTime());
        return q;
    }

    // === 6️⃣ Tìm kiếm câu hỏi theo user và keyword ===
    public List<Question> searchQuestionsByUserIDAndKeyword(int userID, String keyword) {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT q.*, c.CategoryName 
            FROM QuestionBank q
            LEFT JOIN Category c ON q.CategoryID = c.CategoryID
            WHERE q.CreatedBy=? AND q.QuestionText LIKE ?
            ORDER BY q.QuestionID
        """;
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

    // === 7️⃣ Lấy câu hỏi theo ID ===
    public Question getQuestionByID(int questionID) {
        String sql = """
            SELECT q.*, c.CategoryName 
            FROM QuestionBank q
            LEFT JOIN Category c ON q.CategoryID = c.CategoryID
            WHERE q.QuestionID=?
        """;
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

    // === 8️⃣ Lấy danh sách đáp án theo QuestionID ===
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

    // === 9️⃣ Xóa câu hỏi (và đáp án liên quan) ===
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

    // === 🔟 Cập nhật câu hỏi + đáp án ===
    public void updateQuestion(Question question, List<AnswerOption> options) {
        String sqlQuestion = """
            UPDATE QuestionBank 
            SET QuestionText=?, DifficultyLevel=?, CategoryID=?, Status=? 
            WHERE QuestionID=?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement psQuestion = conn.prepareStatement(sqlQuestion)) {

            psQuestion.setString(1, question.getQuestionText());
            psQuestion.setString(2, question.getDifficultyLevel());
            psQuestion.setInt(3, question.getCategoryID());
            psQuestion.setString(4, question.getStatus());
            psQuestion.setInt(5, question.getQuestionID());
            psQuestion.executeUpdate();

            String sqlOption = "UPDATE AnswerOptions SET AnswerText=?, IsCorrect=? WHERE AnswerID=?";
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

    // === 11️⃣ Lấy danh sách Category (distinct) ===
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT CategoryName FROM Category ORDER BY CategoryName";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("CategoryName"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    // === 12️⃣ Lấy danh sách câu hỏi của quiz ===
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT q.QuestionID, q.QuestionText, q.QuestionType, q.DifficultyLevel, c.CategoryName
            FROM QuestionBank q
            INNER JOIN QuizQuestions qq ON q.QuestionID = qq.QuestionID
            LEFT JOIN Category c ON q.CategoryID = c.CategoryID
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
                q.setCategoryName(rs.getString("CategoryName"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 13️⃣ Lấy toàn bộ câu hỏi ===
    public List<Question> getAllQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT q.*, c.CategoryName 
            FROM QuestionBank q
            LEFT JOIN Category c ON q.CategoryID = c.CategoryID
            ORDER BY q.QuestionID
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapQuestion(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 14️⃣ Lấy tên user theo ID ===
    public String getUserNameByID(int userID) {
        String name = "-";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT Username FROM Users WHERE UserID=?")) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) name = rs.getString("Username");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }
     public int insertQuestionAutoModule(Question q, int lessonID) {
    String getModuleSql = "SELECT ModuleID FROM Lessons WHERE LessonID = ?";
    String insertSql = """
        INSERT INTO QuestionBank
        (QuestionText, QuestionType, DifficultyLevel, CategoryID,
         CreatedBy, CreatedAt, Status, ModuleID, LessonID)
        VALUES (?, ?, ?, ?, ?, GETDATE(), ?, ?, ?)
    """;
    try (Connection conn = DBContext.getConnection()) {
        int moduleID = -1;
        // 1️⃣ Lấy ModuleID từ LessonID
        try (PreparedStatement ps1 = conn.prepareStatement(getModuleSql)) {
            ps1.setInt(1, lessonID);
            ResultSet rs = ps1.executeQuery();
            if (rs.next()) {
                moduleID = rs.getInt("ModuleID");
            } else {
                System.out.println("⚠️ Không tìm thấy LessonID: " + lessonID);
                return -1;
            }
        }
        // 2️⃣ Thêm câu hỏi mới
        try (PreparedStatement ps2 = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps2.setString(1, q.getQuestionText());
            ps2.setString(2, q.getQuestionType());
            ps2.setString(3, q.getDifficultyLevel());
            ps2.setInt(4, q.getCategoryID());
            ps2.setInt(5, q.getCreatedBy());
            ps2.setString(6, q.getStatus());
            ps2.setInt(7, moduleID);  // tự động lấy
            ps2.setInt(8, lessonID);  // lấy từ tham số
            int rows = ps2.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps2.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return -1;
}
   public List<Question> getQuestionsByLessonId(int lessonID) {
    List<Question> questions = new ArrayList<>();
    String sql = "SELECT * FROM QuestionBank WHERE LessonID = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, lessonID);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Question q = new Question();
            q.setQuestionID(rs.getInt("QuestionID"));
            q.setQuestionText(rs.getString("QuestionText"));
            q.setQuestionType(rs.getString("QuestionType"));
            q.setDifficultyLevel(rs.getString("DifficultyLevel"));
            q.setCategoryID(rs.getInt("CategoryID"));
            q.setCreatedBy(rs.getInt("CreatedBy"));
            q.setStatus(rs.getString("Status"));
            q.setModuleID(rs.getInt("ModuleID"));
            q.setLessonID(rs.getInt("LessonID"));

            // Nếu muốn, có thể load answerOptions ở đây
            q.setOptions(getAnswerOptionsByQuestionId(q.getQuestionID()));

            questions.add(q);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return questions;
}

// Phương thức phụ để lấy đáp án của 1 câu hỏi
private List<AnswerOption> getAnswerOptionsByQuestionId(int questionID) {
    List<AnswerOption> answers = new ArrayList<>();
    String sql = "SELECT * FROM AnswerOptions WHERE QuestionID = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, questionID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            AnswerOption a = new AnswerOption();
            a.setAnswerID(rs.getInt("AnswerID"));
            a.setQuestionID(rs.getInt("QuestionID"));
            a.setAnswerText(rs.getString("AnswerText"));
            a.setCorrect(rs.getBoolean("IsCorrect"));
            answers.add(a);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return answers;
}
}
    