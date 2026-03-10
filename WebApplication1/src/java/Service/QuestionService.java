package Service;

import Dao.QuestionDAO;
import Entity.Question;
import Entity.AnswerOption;
import java.sql.SQLException;
import java.util.List;

public class QuestionService {
    private final QuestionDAO dao = new QuestionDAO();

    // ✅ Thêm câu hỏi mới (có kèm danh sách đáp án)
    public int createQuestion(Question q, List<AnswerOption> options) {
        int questionId = dao.insertQuestion(q);
        if (questionId > 0 && options != null && !options.isEmpty()) {
            dao.insertAnswerOptions(questionId, options);
        }
        return questionId;
    }

    // ✅ Thêm câu hỏi mới theo Lesson (tự lấy ModuleID)
    public int createQuestionInLesson(Question q, int lessonID, List<AnswerOption> options) {
        int questionId = dao.insertQuestionAutoModule(q, lessonID);
        if (questionId > 0 && options != null && !options.isEmpty()) {
            dao.insertAnswerOptions(questionId, options);
        }
        return questionId;
    }

    // ✅ Lấy tất cả câu hỏi của 1 user
    public List<Question> getQuestionsByUserID(int userID) {
        return dao.getQuestionsByUserID(userID);
    }

    // ✅ Lấy username theo ID (CreatedBy)
    public String getUserNameByID(int userID) {
        return dao.getUserNameByID(userID);
    }

    // ✅ Lấy tất cả category từ QuestionBank
    public List<String> getAllCategories() {
        return dao.getAllCategories();
    }

    // ✅ Lấy danh sách đáp án của câu hỏi
    public List<AnswerOption> getOptionsByQuestionID(int questionID) {
        return dao.getOptionsByQuestionID(questionID);
    }

    // ✅ Tìm kiếm câu hỏi theo keyword
    public List<Question> searchQuestionsByUserID(int userID, String keyword) {
        return dao.searchQuestionsByUserIDAndKeyword(userID, keyword);
    }

    // ✅ Xóa câu hỏi theo ID + UserID
    public boolean deleteQuestionByIDAndUserID(int questionID, int userID) {
        try {
            return dao.deleteQuestionByIDAndUserID(questionID, userID);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Lấy chi tiết 1 câu hỏi (dùng cho trang Edit)
    public Question getQuestionByID(int questionID) {
        return dao.getQuestionByID(questionID);
    }

    // ✅ Cập nhật câu hỏi và danh sách đáp án
    public void updateQuestion(Question question, List<AnswerOption> options) {
        dao.updateQuestion(question, options);
    }

    // ✅ Lấy danh sách câu hỏi theo QuizID
    public List<Question> getQuestionsByQuizId(int quizId) {
        return dao.getQuestionsByQuizId(quizId);
    }

    // ✅ Lấy toàn bộ câu hỏi trong ngân hàng
    public List<Question> getAllQuestions() {
        return dao.getAllQuestions();
    }

    // ✅ Tạo hoặc lấy CategoryID (nếu bạn có bảng Category riêng)
    public int getOrCreateCategoryID(String categoryName) {
        return dao.getOrCreateCategoryID(categoryName);
    }
    public List<Question> getQuestionsByLessonID(int lessonID) {
    return dao.getQuestionsByLessonId(lessonID);
}
    
}
