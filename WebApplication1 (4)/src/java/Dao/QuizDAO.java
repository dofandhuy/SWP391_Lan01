package Dao;

import Context.DBContext;
import static Context.DBContext.getConnection;
import Entity.AnswerOption;
import Entity.Category;
import Entity.CorrectAnswerDTO;
import Entity.Question;
import Entity.Quiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class QuizDAO extends DBContext {

    // ✅ Thêm quiz mới, trả về ID vừa tạo
 
 public int insertQuiz(Quiz quiz) {
    String sql = """
        INSERT INTO Quizzes (
            CategoryID, Title, NumQuestions, IsRandom, DurationMinutes,
            PassingScore, DifficultyLevel, CreatedBy, CreatedAt, Status,
            ReviewedBy, ReviewedAt, RejectionReason, MaxAttempts, AttemptCooldownHours
        )
        OUTPUT INSERTED.QuizID
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), ?, ?, ?, ?, ?, ?)
    """;
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        // 1️⃣ CategoryID
        if (quiz.getCategoryID() == null) ps.setNull(1, Types.INTEGER);
        else ps.setInt(1, quiz.getCategoryID());

        // 2️⃣ Title
        ps.setString(2, quiz.getTitle());

        // 3️⃣ NumQuestions
        ps.setInt(3, quiz.getNumQuestions());

        // 4️⃣ IsRandom
        ps.setBoolean(4, quiz.isRandom());

        // 5️⃣ DurationMinutes
        if (quiz.getDurationMinutes() == null) ps.setNull(5, Types.INTEGER);
        else ps.setInt(5, quiz.getDurationMinutes());

        // 6️⃣ PassingScore
        if (quiz.getPassingScore() == null) ps.setNull(6, Types.DECIMAL);
        else ps.setDouble(6, quiz.getPassingScore());

        // 7️⃣ DifficultyLevel
        ps.setString(7, quiz.getDifficultyLevel());

        // 8️⃣ CreatedBy
        ps.setInt(8, quiz.getCreatedBy());

        // 9️⃣ Status
        ps.setString(9, quiz.getStatus() != null ? quiz.getStatus() : "Draft");

        // 🔟 ReviewedBy
        if (quiz.getReviewedBy() == null) ps.setNull(10, Types.INTEGER);
        else ps.setInt(10, quiz.getReviewedBy());

        // 11️⃣ ReviewedAt
        ps.setNull(11, Types.TIMESTAMP);

        // 12️⃣ RejectionReason
        ps.setNull(12, Types.NVARCHAR);

        // 13️⃣ MaxAttempts
        if (quiz.getMaxAttempts() == null) ps.setNull(13, Types.INTEGER);
        else ps.setInt(13, quiz.getMaxAttempts());

        // 14️⃣ AttemptCooldownHours
        if (quiz.getAttemptCooldownHours() == null) ps.setNull(14, Types.INTEGER);
        else ps.setInt(14, quiz.getAttemptCooldownHours());

        // Thực thi truy vấn
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            int id = rs.getInt("QuizID");
            System.out.println("✅ Quiz inserted with ID: " + id);
            return id;
        }
    } catch (SQLException e) {
        System.err.println("❌ insertQuiz failed: " + e.getMessage());
        e.printStackTrace();
    }
    return -1;
}
    
  private void insertRandom(Connection conn, int quizId, int topN, int userID, String difficulty, Integer categoryId, List<Integer> excludedIds) throws SQLException {
    String sql = """
        INSERT INTO QuizQuestions (QuizID, QuestionID)
        SELECT TOP (?) ?, QB.QuestionID
        FROM QuestionBank QB
        WHERE QB.CreatedBy = ?
          AND QB.DifficultyLevel = ?
    """;

    if (categoryId != null) {
        sql += " AND QB.CategoryID = ?";
    }

    // Loại bỏ câu hỏi đã có trong quiz hoặc đã chọn thủ công
    sql += " AND QB.QuestionID NOT IN (SELECT QuestionID FROM QuizQuestions WHERE QuizID = ?)";
    if (excludedIds != null && !excludedIds.isEmpty()) {
        String placeholders = excludedIds.stream().map(id -> "?").reduce((a, b) -> a + "," + b).get();
        sql += " AND QB.QuestionID NOT IN (" + placeholders + ")";
    }

    sql += " ORDER BY NEWID()";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        int i = 1;
        ps.setInt(i++, topN);
        ps.setInt(i++, quizId);
        ps.setInt(i++, userID);
        ps.setString(i++, difficulty);
        if (categoryId != null) ps.setInt(i++, categoryId);
        ps.setInt(i++, quizId);

        if (excludedIds != null && !excludedIds.isEmpty()) {
            for (Integer id : excludedIds) {
                ps.setInt(i++, id);
            }
        }

        ps.executeUpdate();
    }
}
public void addRandomQuestions(int quizId, int ez, int medium, int hard, int userID, String categoryName, List<Integer> excludedIds) {
    Integer categoryId = null;
    if (categoryName != null && !categoryName.isBlank()) {
        String sql = "SELECT CategoryID FROM Category WHERE CategoryName = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                categoryId = rs.getInt("CategoryID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    try (Connection conn = getConnection()) {
        if (ez > 0) insertRandom(conn, quizId, ez, userID, "Easy", categoryId, excludedIds);
        if (medium > 0) insertRandom(conn, quizId, medium, userID, "Medium", categoryId, excludedIds);
        if (hard > 0) insertRandom(conn, quizId, hard, userID, "Hard", categoryId, excludedIds);
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    // ✅ Thêm danh sách câu hỏi đã chọn thủ công vào quiz
    public void addSelectedQuestions(int quizId, String[] questionIds) {
        String sql = "INSERT INTO QuizQuestions (QuizID, QuestionID) VALUES (?, ?)";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            for (String qid : questionIds) {
                ps.setInt(1, quizId);
                ps.setInt(2, Integer.parseInt(qid));
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("✅ Added " + questionIds.length + " selected questions.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật quiz (các trường cơ bản)
   
public boolean updateQuiz(Quiz quiz) {
    String sql = """
        UPDATE Quizzes
        SET CategoryID = ?, Title = ?, DurationMinutes = ?, PassingScore = ?,
            IsRandom = ?, Status = ?, MaxAttempts = ?, AttemptCooldownHours = ?
        WHERE QuizID = ?
    """;
    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        if (quiz.getCategoryID() == null) {
            ps.setNull(1, Types.INTEGER);
        } else {
            ps.setInt(1, quiz.getCategoryID());
        }
        ps.setString(2, quiz.getTitle());
        ps.setInt(3, quiz.getDurationMinutes());
        ps.setDouble(4, quiz.getPassingScore());
        ps.setBoolean(5, quiz.isRandom());
        ps.setString(6, quiz.getStatus());
        ps.setInt(7, quiz.getMaxAttempts() != null ? quiz.getMaxAttempts() : 0);
        ps.setInt(8, quiz.getAttemptCooldownHours() != null ? quiz.getAttemptCooldownHours() : 0);
        ps.setInt(9, quiz.getQuizID());

        int rows = ps.executeUpdate();
        return rows > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    // ✅ Xóa quiz cùng các câu hỏi trong quiz
    public boolean deleteQuiz(int quizID) {
        String deleteQuestions = "DELETE FROM QuizQuestions WHERE QuizID = ?";
        String deleteQuiz = "DELETE FROM Quizzes WHERE QuizID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps1 = conn.prepareStatement(deleteQuestions); PreparedStatement ps2 = conn.prepareStatement(deleteQuiz)) {

            ps1.setInt(1, quizID);
            ps1.executeUpdate();

            ps2.setInt(1, quizID);
            return ps2.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Lấy tất cả quiz
   
public List<Quiz> getAllQuiz() {
    List<Quiz> list = new ArrayList<>();
    String sql = """
        SELECT q.QuizID, q.Title, q.NumQuestions, q.DurationMinutes, q.PassingScore, q.Status,
               q.RejectionReason, u.Username AS CreatedByName, q.CreatedBy,
               c.CategoryName
        FROM Quizzes q
        JOIN Users u ON q.CreatedBy = u.UserID
        LEFT JOIN Category c ON q.CategoryID = c.CategoryID
        ORDER BY q.QuizID DESC
    """;
    try (Connection conn = getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql); 
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Quiz q = new Quiz();
            q.setQuizID(rs.getInt("QuizID"));
            q.setTitle(rs.getString("Title"));
            q.setNumQuestions(rs.getInt("NumQuestions"));
            q.setDurationMinutes(rs.getInt("DurationMinutes"));
            q.setPassingScore(rs.getDouble("PassingScore"));
            q.setStatus(rs.getString("Status"));
            q.setRejectionReason(rs.getString("RejectionReason"));
            q.setCreatedBy(rs.getInt("CreatedBy"));          // 🔹 Bắt buộc
            q.setCreatedByName(rs.getString("CreatedByName"));
            q.setCategoryName(rs.getString("CategoryName"));
            list.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    // ✅ Lấy quiz theo ID
    public Quiz getQuizById(int id) {
        String sql = "SELECT * FROM Quizzes WHERE QuizID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Quiz q = new Quiz();
                q.setQuizID(rs.getInt("QuizID"));
                q.setCategoryID(rs.getInt("CategoryID"));
                q.setTitle(rs.getString("Title"));
                q.setNumQuestions(rs.getInt("NumQuestions"));
                q.setDurationMinutes(rs.getInt("DurationMinutes"));
                q.setPassingScore(rs.getDouble("PassingScore"));

                q.setDifficultyLevel(rs.getString("DifficultyLevel"));
                q.setRandom(rs.getBoolean("IsRandom"));
                q.setCreatedBy(rs.getInt("CreatedBy"));
                q.setStatus(rs.getString("Status"));
                q.setRejectionReason(rs.getString("RejectionReason"));

                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                if (createdAt != null) {
                    q.setCreatedAt(createdAt.toLocalDateTime());
                }

                // 2 trường mới
                int maxAttempts = rs.getInt("MaxAttempts");
                if (!rs.wasNull()) {
                    q.setMaxAttempts(maxAttempts);
                }

                int cooldownHours = rs.getInt("AttemptCooldownHours");
                if (!rs.wasNull()) {
                    q.setAttemptCooldownHours(cooldownHours);
                }

                return q;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Lấy danh sách QuestionID hiện có trong quiz
    public List<Integer> getQuizQuestions(int quizId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT QuestionID FROM QuizQuestions WHERE QuizID=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("QuestionID"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy tất cả QuestionBank (mọi giáo viên đều thấy)
    public List<Integer> getAllQuestionBank() {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT QuestionID FROM QuestionBank";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getInt("QuestionID"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

  public void deleteSelectedQuestionsFromQuiz(int quizId, List<Integer> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) return;
        String sql = "DELETE FROM QuizQuestions WHERE QuizID=? AND QuestionID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer qid : questionIds) {
                ps.setInt(1, quizId);
                ps.setInt(2, qid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Thêm nhiều câu hỏi (thủ công hoặc từ random)
    public void addQuestionsToQuiz(int quizId, List<Integer> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) return;
        String sql = "INSERT INTO QuizQuestions(QuizID, QuestionID) VALUES(?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer qid : questionIds) {
                ps.setInt(1, quizId);
                ps.setInt(2, qid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



public List<Question> getQuestionsByQuizId(int quizId) {
    List<Question> questions = new ArrayList<>();
    String sql = """
        SELECT QB.QuestionID, QB.QuestionText, QB.QuestionType, QB.DifficultyLevel,
               C.CategoryName
        FROM QuestionBank QB
        LEFT JOIN Category C ON QB.CategoryID = C.CategoryID
        JOIN QuizQuestions QQ ON QB.QuestionID = QQ.QuestionID
        WHERE QQ.QuizID = ?
        ORDER BY QQ.OrderIndex ASC, NEWID()
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
            q.setCategoryName(rs.getString("CategoryName")); // cần có setter trong Question
            questions.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return questions;
}
  
    public List<AnswerOption> getAnswerOptionsByQuestionId(int questionId) {
        List<AnswerOption> options = new ArrayList<>();
        // Chỉ lấy AnswerID, AnswerText, và QuestionID. KHÔNG lấy IsCorrect.
        String sql = "SELECT AnswerID, AnswerText, QuestionID FROM AnswerOptions WHERE QuestionID = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AnswerOption opt = new AnswerOption();
                opt.setAnswerID(rs.getInt("AnswerID"));
                opt.setAnswerText(rs.getString("AnswerText"));
                opt.setQuestionID(rs.getInt("QuestionID"));
                // opt.setCorrect(false) -- Mặc định của boolean là false
                options.add(opt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return options;
    }
    public List<CorrectAnswerDTO> getCorrectAnswersForQuiz(int quizId) {
        List<CorrectAnswerDTO> answers = new ArrayList<>();
        // Câu SQL này JOIN QuestionBank và AnswerOptions,
        // lọc ra những đáp án có IsCorrect = 1
        // và chỉ lấy những câu hỏi thuộc về quizId được chỉ định.
        String sql = """
            SELECT QB.QuestionID, QB.QuestionType, AO.AnswerID, AO.AnswerText
            FROM dbo.AnswerOptions AO
            JOIN dbo.QuestionBank QB ON AO.QuestionID = QB.QuestionID
            WHERE AO.IsCorrect = 1
            AND QB.QuestionID IN (SELECT QuestionID FROM dbo.QuizQuestions WHERE QuizID = ?)
        """;

        try (Connection conn = DBContext.getConnection(); // Lấy connection từ DBContext của bạn
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();

            // Lặp qua từng đáp án đúng tìm được
            while (rs.next()) {
                CorrectAnswerDTO dto = new CorrectAnswerDTO();
                dto.setQuestionId(rs.getInt("QuestionID"));         // ID câu hỏi
                dto.setQuestionType(rs.getString("QuestionType")); // Loại câu hỏi (để biết cách chấm)
                dto.setCorrectAnwerId(rs.getInt("AnswerID"));     // ID đáp án đúng (cho MCQ)
                dto.setCorrectAnswerText(rs.getString("AnswerText"));// Text đáp án đúng (cho FillBlank)
                answers.add(dto); // Thêm vào danh sách kết quả
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console nếu có sự cố
        }
        return answers; // Trả về danh sách "Khóa Đáp Án"
    }
    public List<AnswerOption> getAllAnswerOptionsForQuestion(int questionId) {
        List<AnswerOption> options = new ArrayList<>();
        // Select all relevant columns, INCLUDING IsCorrect
        String sql = "SELECT AnswerID, QuestionID, AnswerText, IsCorrect " +
                     "FROM dbo.AnswerOptions WHERE QuestionID = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AnswerOption opt = new AnswerOption();
                opt.setAnswerID(rs.getInt("AnswerID"));
                opt.setQuestionID(rs.getInt("QuestionID"));
                opt.setAnswerText(rs.getString("AnswerText"));
                opt.setCorrect(rs.getBoolean("IsCorrect")); // Fetch the correct flag
                options.add(opt);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
        }
        return options;
    }
    
    // Đếm số câu hỏi hiện có trong quiz
public int countQuestionsByQuizID(int quizID) {
    String sql = "SELECT COUNT(*) FROM QuizQuestions WHERE QuizID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, quizID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

// Cập nhật lại số câu hỏi trong quiz
public void updateNumQuestions(int quizID, int numQuestions) {
    String sql = "UPDATE Quizzes SET NumQuestions = ? WHERE QuizID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, numQuestions);
        ps.setInt(2, quizID);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    


    public List<Quiz> getQuizzesByCategory(int categoryId) {
    List<Quiz> list = new ArrayList<>();
    String sql = "SELECT * FROM Quizzes WHERE CategoryID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, categoryId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Quiz q = new Quiz();
            q.setQuizID(rs.getInt("QuizID"));
            q.setTitle(rs.getString("Title"));
            q.setCategoryID(rs.getInt("CategoryID"));
            list.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

    public boolean updateQuizLesson(int quizId, int lessonId) {
        String sql = "UPDATE Quizzes SET LessonID = ? WHERE QuizID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ps.setInt(2, quizId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignQuizToModule(int quizId, int moduleId) {
    String sql = "UPDATE Quizzes SET ModuleID = ? WHERE QuizID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, moduleId);
        ps.setInt(2, quizId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

public Quiz getQuizByModuleId(int moduleId) {
    String sql = "SELECT * FROM Quizzes WHERE ModuleID = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, moduleId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Quiz q = new Quiz();
            q.setQuizID(rs.getInt("QuizID"));
            q.setCategoryID(rs.getInt("CategoryID"));
            q.setTitle(rs.getString("Title"));
            q.setNumQuestions(rs.getInt("NumQuestions"));
            q.setDurationMinutes(rs.getInt("DurationMinutes"));
            q.setPassingScore(rs.getDouble("PassingScore"));
           
            q.setDifficultyLevel(rs.getString("DifficultyLevel"));
            q.setRandom(rs.getBoolean("IsRandom"));
            q.setCreatedBy(rs.getInt("CreatedBy"));
            q.setStatus(rs.getString("Status"));
            q.setRejectionReason(rs.getString("RejectionReason"));

            Timestamp createdAt = rs.getTimestamp("CreatedAt");
            if (createdAt != null) {
                q.setCreatedAt(createdAt.toLocalDateTime());
            }

            int maxAttempts = rs.getInt("MaxAttempts");
            if (!rs.wasNull()) {
                q.setMaxAttempts(maxAttempts);
            }

            int cooldownHours = rs.getInt("AttemptCooldownHours");
            if (!rs.wasNull()) {
                q.setAttemptCooldownHours(cooldownHours);
            }

            return q;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
public boolean removeQuizFromModule(int moduleId) {
    String sql = "UPDATE Quizzes SET ModuleID = NULL WHERE ModuleID = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, moduleId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

public List<Quiz> getQuizzesForAdmin(String status, int categoryId, String instructorName, String quizName) {
        List<Quiz> quizList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT q.QuizID, q.Title, q.Status, ISNULL(cat.CategoryName,'N/A') AS SubjectName, u.FullName AS CreatedByName " +
            "FROM Quizzes q " +
            "LEFT JOIN Users u ON q.CreatedBy = u.UserID " +
            "LEFT JOIN Category cat ON q.CategoryID = cat.CategoryID " +
            "WHERE q.Status <> 'Draft'"
        );
        List<Object> params = new ArrayList<>();
        if(status != null && !status.isEmpty()) { sql.append(" AND q.Status = ?"); params.add(status);}
        if(categoryId > 0) { sql.append(" AND q.CategoryID = ?"); params.add(categoryId);}
        if(instructorName != null && !instructorName.isEmpty()){ sql.append(" AND u.FullName LIKE ?"); params.add("%"+instructorName+"%");}
        if(quizName != null && !quizName.isEmpty()){ sql.append(" AND q.Title LIKE ?"); params.add("%"+quizName+"%");}
        sql.append(" ORDER BY q.QuizID DESC");

        try(Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for(int i=0;i<params.size();i++){ ps.setObject(i+1, params.get(i)); }
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Quiz q = new Quiz();
                q.setQuizID(rs.getInt("QuizID"));
                q.setTitle(rs.getString("Title"));
                q.setCategoryName(rs.getString("SubjectName"));
                q.setCreatedByName(rs.getString("CreatedByName"));
                q.setStatus(rs.getString("Status"));
                quizList.add(q);
            }
        } catch(Exception e){ e.printStackTrace();}
        return quizList;
    }

    // Get details quiz
    public Quiz getQuizDetailsById(int quizId){
        Quiz quiz = null;
        String sql = "SELECT q.*, ISNULL(cat.CategoryName,'N/A') AS SubjectName, u.FullName AS CreatedByName " +
                     "FROM Quizzes q " +
                     "LEFT JOIN Users u ON q.CreatedBy = u.UserID " +
                     "LEFT JOIN Category cat ON q.CategoryID = cat.CategoryID " +
                     "WHERE q.QuizID=?";
        try(Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                quiz = new Quiz();
                quiz.setQuizID(rs.getInt("QuizID"));
                quiz.setTitle(rs.getString("Title"));
                quiz.setCategoryName(rs.getString("SubjectName"));
                quiz.setCreatedByName(rs.getString("CreatedByName"));
                quiz.setStatus(rs.getString("Status"));
                quiz.setNumQuestions(rs.getInt("NumQuestions"));
                quiz.setDifficultyLevel(rs.getString("DifficultyLevel"));
                quiz.setPassingScore(rs.getDouble("PassingScore"));
                quiz.setPointPerQuestion(rs.getDouble("PointPerQuestion"));
                quiz.setMaxAttempts(rs.getInt("MaxAttempts"));
                quiz.setRejectionReason(rs.getString("RejectionReason"));
            }
        } catch(Exception e){ e.printStackTrace();}
        return quiz;
    }

    public List<Question> getQuestionsByQuizIdAD(int quizId) {
    List<Question> questions = new ArrayList<>();
    String sql = "SELECT QB.QuestionID, QB.QuestionText, QB.QuestionType, QB.DifficultyLevel, C.CategoryName " +
                 "FROM QuizQuestions QQ " +
                 "JOIN QuestionBank QB ON QQ.QuestionID = QB.QuestionID " +
                 "LEFT JOIN Category C ON QB.CategoryID = C.CategoryID " +
                 "WHERE QQ.QuizID = ? ORDER BY QQ.OrderIndex ASC";

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

            // Load options cho mỗi câu hỏi
            List<AnswerOption> options = getAllAnswerOptionsForQuestion(q.getQuestionID());
            q.setOptions(options);

            questions.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return questions;
}


//   public List<AnswerOption> getAllAnswerOptionsForQuestion(int questionId) {
//    List<AnswerOption> options = new ArrayList<>();
//    String sql = "SELECT AnswerID, QuestionID, AnswerText, IsCorrect FROM AnswerOptions WHERE QuestionID = ?";
//
//    try (Connection conn = DBContext.getConnection();
//         PreparedStatement ps = conn.prepareStatement(sql)) {
//
//        ps.setInt(1, questionId);
//        ResultSet rs = ps.executeQuery();
//
//        while (rs.next()) {
//            AnswerOption opt = new AnswerOption();
//            opt.setAnswerID(rs.getInt("AnswerID"));
//            opt.setQuestionID(rs.getInt("QuestionID"));
//            opt.setAnswerText(rs.getString("AnswerText"));
//            opt.setCorrect(rs.getBoolean("IsCorrect")); // ✅ must match DB column type
//            options.add(opt);
//        }
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
//
//    return options;
//}
public Quiz getQuizDetailsWithQuestions(int quizId) {
    Quiz quiz = getQuizDetailsById(quizId);
    if(quiz != null) {
        List<Question> questions = getQuestionsByQuizId(quizId);
        for(Question q : questions){
            q.setOptions(getAllAnswerOptionsForQuestion(q.getQuestionID()));
        }
        quiz.setQuestions(questions);
    }
    return quiz;
}


   public void updateQuizStatusByAdmin(int quizId, String status, String rejectionReason, int adminUserId) {
    String sql = """
        UPDATE Quizzes
        SET 
            Status = ?, 
            RejectionReason = ?, 
            ReviewedBy = ?, 
            ReviewedAt = SYSUTCDATETIME()
        WHERE QuizID = ?
    """;

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, status);
        ps.setString(2, rejectionReason);
        ps.setInt(3, adminUserId); // ID admin duyệt
        ps.setInt(4, quizId);

        int updated = ps.executeUpdate();
        if (updated > 0) {
            System.out.println("✅ Quiz ID " + quizId + " status updated to '" + status + "' by Admin ID " + adminUserId);
        } else {
            System.out.println("⚠️ No quiz updated. Quiz ID " + quizId + " may not exist.");
        }

    } catch (Exception e) {
        System.out.println("❌ Error updating quiz status for Quiz ID " + quizId);
        e.printStackTrace();
    }
}

    public List<Category> getAllCategoriesByAdmin(){
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName FROM Category ORDER BY CategoryName";
        try(Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){
            while(rs.next()){
                Category c = new Category();
                c.setCategoryID(rs.getInt("CategoryID"));
                c.setCategoryName(rs.getString("CategoryName"));
                list.add(c);
            }
        } catch(Exception e){ e.printStackTrace();}
        return list;
    }
}
    

