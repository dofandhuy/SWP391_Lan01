package Dao;

import Context.DBContext;
import static Context.DBContext.getConnection;
import Entity.AnswerOption;
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
            PassingScore, PointPerQuestion, DifficultyLevel,
            CreatedBy, CreatedAt, Status,
            ReviewedBy, ReviewedAt, RejectionReason,
            MaxAttempts, AttemptCooldownHours
        )
        OUTPUT INSERTED.QuizID
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), ?, ?, ?, ?, ?, ?)
    """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1️⃣ CategoryID (có thể null)
            if (quiz.getCategoryID() == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, quiz.getCategoryID());
            }

            // 2️⃣ Title
            ps.setString(2, quiz.getTitle());

            // 3️⃣ NumQuestions
            ps.setInt(3, quiz.getNumQuestions());

            // 4️⃣ IsRandom
            ps.setBoolean(4, quiz.isRandom());

            // 5️⃣ DurationMinutes
            if (quiz.getDurationMinutes() == null) {
                ps.setNull(5, Types.INTEGER);
            } else {
                ps.setInt(5, quiz.getDurationMinutes());
            }

            // 6️⃣ PassingScore
            if (quiz.getPassingScore() == null) {
                ps.setNull(6, Types.DECIMAL);
            } else {
                ps.setDouble(6, quiz.getPassingScore());
            }

            // 7️⃣ PointPerQuestion
            if (quiz.getPointPerQuestion() == null) {
                ps.setNull(7, Types.DECIMAL);
            } else {
                ps.setDouble(7, quiz.getPointPerQuestion());
            }

            // 8️⃣ DifficultyLevel
            ps.setString(8, quiz.getDifficultyLevel());

            // 9️⃣ CreatedBy
            ps.setInt(9, quiz.getCreatedBy());

            // 🔟 Status
            ps.setString(10, quiz.getStatus() != null ? quiz.getStatus() : "Draft");

            // 11️⃣ ReviewedBy
            if (quiz.getReviewedBy() == null) {
                ps.setNull(11, Types.INTEGER);
            } else {
                ps.setInt(11, quiz.getReviewedBy());
            }

            // 12️⃣ ReviewedAt
            ps.setNull(12, Types.TIMESTAMP);

            // 13️⃣ RejectionReason
            ps.setNull(13, Types.NVARCHAR);

            // 14️⃣ MaxAttempts
            if (quiz.getMaxAttempts() == null) {
                ps.setNull(14, Types.INTEGER);
            } else {
                ps.setInt(14, quiz.getMaxAttempts());
            }

            // 15️⃣ AttemptCooldownHours
            if (quiz.getAttemptCooldownHours() == null) {
                ps.setNull(15, Types.INTEGER);
            } else {
                ps.setInt(15, quiz.getAttemptCooldownHours());
            }

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

    private void insertRandom(Connection conn, int quizId, int topN, int userID, String difficulty, Integer categoryId) throws SQLException {
        String sql;
        if (categoryId == null) {
            sql = """
            INSERT INTO QuizQuestions (QuizID, QuestionID)
            SELECT TOP (?) ?, QB.QuestionID
            FROM QuestionBank QB
            WHERE QB.CreatedBy = ?
              AND QB.DifficultyLevel = ?
              AND QB.QuestionID NOT IN (SELECT QuestionID FROM QuizQuestions WHERE QuizID = ?)
            ORDER BY NEWID()
        """;
        } else {
            sql = """
            INSERT INTO QuizQuestions (QuizID, QuestionID)
            SELECT TOP (?) ?, QB.QuestionID
            FROM QuestionBank QB
            WHERE QB.CreatedBy = ?
              AND QB.DifficultyLevel = ?
              AND QB.CategoryID = ?
              AND QB.QuestionID NOT IN (SELECT QuestionID FROM QuizQuestions WHERE QuizID = ?)
            ORDER BY NEWID()
        """;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, topN);    // TOP (?)
            ps.setInt(2, quizId);  // QuizID insert
            ps.setInt(3, userID);  // CreatedBy
            ps.setString(4, difficulty); // Difficulty
            if (categoryId != null) {
                ps.setInt(5, categoryId);
                ps.setInt(6, quizId); // loại trừ đã có
            } else {
                ps.setInt(5, quizId); // loại trừ đã có
            }
            ps.executeUpdate();
        }
    }

    // ✅ Thêm ngẫu nhiên câu hỏi theo mức độ và category
    public void addRandomQuestions(int quizId, int ez, int medium, int hard, int userID, String categoryName) {
        Integer categoryId = null;

        // Nếu có categoryName, map sang CategoryID
        if (categoryName != null && !categoryName.isBlank()) {
            String sql = "SELECT CategoryID FROM Category WHERE CategoryName = ?";
            try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, categoryName);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    categoryId = rs.getInt("CategoryID");
                } else {
                    System.out.println("⚠️ Không tìm thấy CategoryName: " + categoryName + ", bỏ qua lọc category.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Chèn random câu hỏi theo từng mức độ
        try (Connection conn = getConnection()) {
            if (ez > 0) {
                insertRandom(conn, quizId, ez, userID, "Easy", categoryId);
            }
            if (medium > 0) {
                insertRandom(conn, quizId, medium, userID, "Medium", categoryId);
            }
            if (hard > 0) {
                insertRandom(conn, quizId, hard, userID, "Hard", categoryId);
            }
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
            PointPerQuestion = ?, IsRandom = ?, Status = ?,
            MaxAttempts = ?, AttemptCooldownHours = ?
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
            ps.setDouble(5, quiz.getPointPerQuestion());
            ps.setBoolean(6, quiz.isRandom());
            ps.setString(7, quiz.getStatus());
            ps.setInt(8, quiz.getMaxAttempts() != null ? quiz.getMaxAttempts() : 0);
            ps.setInt(9, quiz.getAttemptCooldownHours() != null ? quiz.getAttemptCooldownHours() : 0);
            ps.setInt(10, quiz.getQuizID());
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
               q.RejectionReason, u.Username AS CreatedByName,
               c.CategoryName
        FROM Quizzes q
        JOIN Users u ON q.CreatedBy = u.UserID
        LEFT JOIN Category c ON q.CategoryID = c.CategoryID
        ORDER BY q.QuizID DESC
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Quiz q = new Quiz();
                q.setQuizID(rs.getInt("QuizID"));
                q.setTitle(rs.getString("Title"));
                q.setNumQuestions(rs.getInt("NumQuestions"));
                q.setDurationMinutes(rs.getInt("DurationMinutes"));
                q.setPassingScore(rs.getDouble("PassingScore"));
                q.setStatus(rs.getString("Status"));
                q.setRejectionReason(rs.getString("RejectionReason"));
                q.setCreatedByName(rs.getString("CreatedByName"));
                q.setCategoryName(rs.getString("CategoryName")); // 🔹 thêm dòng này
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
                q.setPointPerQuestion(rs.getDouble("PointPerQuestion"));
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
        if (questionIds == null || questionIds.isEmpty()) {
            return;
        }
        String sql = "DELETE FROM QuizQuestions WHERE QuizID=? AND QuestionID=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        if (questionIds == null || questionIds.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO QuizQuestions(QuizID, QuestionID) VALUES(?,?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        String sql = "SELECT AnswerID, QuestionID, AnswerText, IsCorrect "
                + "FROM dbo.AnswerOptions WHERE QuestionID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

    public List<Quiz> getQuizzesByCategory(int categoryId) {
        List<Quiz> list = new ArrayList<>();
        String sql = "SELECT * FROM Quizzes WHERE CategoryID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
    String sql = "SELECT * FROM Quiz WHERE ModuleID = ?";

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
            q.setPointPerQuestion(rs.getDouble("PointPerQuestion"));
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
            if (!rs.wasNull()) q.setMaxAttempts(maxAttempts);

            int cooldownHours = rs.getInt("AttemptCooldownHours");
            if (!rs.wasNull()) q.setAttemptCooldownHours(cooldownHours);

            q.setModuleID(rs.getInt("ModuleID")); // ✅ nếu cột này tồn tại trong bảng
            return q;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

}
