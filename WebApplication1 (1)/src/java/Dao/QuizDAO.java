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
        // 1. CẬP NHẬT CÂU SQL: Bỏ DifficultyLevel, thêm MaxAttempts, AttemptCooldownHours
        String sql = """
        INSERT INTO Quizzes (
            LessonID, Title, NumQuestions, DurationMinutes, PassingScore, 
            PointPerQuestion, IsRandom, CreatedBy, CreatedAt,
            MaxAttempts, AttemptCooldownHours 
        )
        OUTPUT INSERTED.QuizID 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), ?, ?)
    """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // 2. CẬP NHẬT THỨ TỰ PARAMETER
            if (quiz.getLessonID() == 0) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, quiz.getLessonID());
            }

            ps.setString(2, quiz.getTitle());
            ps.setInt(3, quiz.getNumQuestions());
            ps.setInt(4, quiz.getDurationMinutes());
            ps.setDouble(5, quiz.getPassingScore());
            ps.setDouble(6, quiz.getPointPerQuestion());
            ps.setBoolean(7, quiz.isRandom()); // <-- Đổi từ 8 thành 7
            ps.setInt(8, quiz.getCreatedBy()); // <-- Đổi từ 9 thành 8

            // 3. THÊM 2 TRƯỜNG MỚI
            // Dùng setObject để xử lý chính xác giá trị NULL (cho phép vô hạn)
            // (Chúng ta sẽ sửa Servlet ở bước 2 để nó gửi NULL thay vì 0)
            ps.setObject(9, quiz.getMaxAttempts(), Types.INTEGER);
            ps.setObject(10, quiz.getAttemptCooldownHours(), Types.INTEGER);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("QuizID");
                System.out.println("✅ Quiz inserted with ID: " + id);
                return id;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
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
        SET Title = ?, DurationMinutes = ?, PassingScore = ?,
            PointPerQuestion = ?, IsRandom = ?, Status = ?,
            MaxAttempts = ?, AttemptCooldownHours = ?
        WHERE QuizID = ?
    """;
    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, quiz.getTitle());
        ps.setInt(2, quiz.getDurationMinutes());
        ps.setDouble(3, quiz.getPassingScore());
        ps.setDouble(4, quiz.getPointPerQuestion());
        
        
        ps.setBoolean(5, quiz.isRandom());
        ps.setString(6, quiz.getStatus());
       ps.setInt(7, quiz.getMaxAttempts() != null ? quiz.getMaxAttempts() : 0);
ps.setInt(8, quiz.getAttemptCooldownHours() != null ? quiz.getAttemptCooldownHours() : 0);
        ps.setInt(9, quiz.getQuizID());
        int rows = ps.executeUpdate();
        System.out.println("Rows updated: " + rows); // 🔹 kiểm tra
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
                   q.RejectionReason, u.Username AS CreatedByName
            FROM Quizzes q
            JOIN Users u ON q.CreatedBy = u.UserID
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
                q.setLessonID(rs.getInt("LessonID"));
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

    // ✅ Thêm ngẫu nhiên câu hỏi theo mức độ và category
    public void addRandomQuestions(int quizId, int ez, int medium, int hard, int userID, String category) {
        String sqlTemplate = """
            INSERT INTO QuizQuestions (QuizID, QuestionID)
            SELECT TOP (?) ?, QuestionID
            FROM QuestionBank
            WHERE CreatedBy = ?
              AND DifficultyLevel = ?
              AND (? = '' OR Category = ?)
              AND QuestionID NOT IN (SELECT QuestionID FROM QuizQuestions WHERE QuizID = ?)
            ORDER BY NEWID()
        """;
        try (Connection conn = getConnection()) {

            if (ez > 0) {
                insertRandom(conn, sqlTemplate, quizId, ez, userID, "Easy", category);
            }
            if (medium > 0) {
                insertRandom(conn, sqlTemplate, quizId, medium, userID, "Medium", category);
            }
            if (hard > 0) {
                insertRandom(conn, sqlTemplate, quizId, hard, userID, "Hard", category);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void insertRandom(Connection conn, String sql, int quizId, int topN, int userID, String difficulty, String category) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, topN);
            ps.setInt(2, quizId);
            ps.setInt(3, userID);
            ps.setString(4, difficulty);
            ps.setString(5, category);
            ps.setString(6, category);
            ps.setInt(7, quizId);
            int rows = ps.executeUpdate();
            System.out.println("✅ Random " + difficulty + " questions inserted: " + rows);
        }
    }

    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> questions = new ArrayList<>();
        // Join 2 bảng QuizQuestions và QuestionBank
        String sql = """
            SELECT QB.QuestionID, QB.QuestionText, QB.QuestionType, QB.DifficultyLevel, QB.Category
            FROM QuestionBank QB
            JOIN QuizQuestions QQ ON QB.QuestionID = QQ.QuestionID
            WHERE QQ.QuizID = ?
            ORDER BY QQ.OrderIndex ASC, NEWID() -- Sắp xếp theo thứ tự (nếu có) hoặc ngẫu nhiên
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
                q.setCategory(rs.getString("Category"));

                // Lưu ý: q.setOptions() sẽ được gọi ở Servlet
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
}
