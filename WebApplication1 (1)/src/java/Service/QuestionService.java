package Service;

import Dao.QuestionDAO;
import Entity.Question;
import Entity.AnswerOption;
import java.sql.SQLException;
import java.util.List;

public class QuestionService {
    private QuestionDAO dao = new QuestionDAO();

    // Thêm Question cùng danh sách đáp án
    public int createQuestion(Question q, List<AnswerOption> options) {
        int questionId = dao.insertQuestion(q); 
        if (questionId > 0 && options != null && !options.isEmpty()) {
            dao.insertAnswerOptions(questionId, options);
        }
        return questionId;
    }

    // Lấy tất cả câu hỏi của 1 user
    public List<Question> getQuestionsByUserID(int userID) {
  
        return dao.getQuestionsByUserID(userID);
    }
      public String getUserNameByID(int userID) {
           return dao.getUserNameByID(userID);
      }
    // Lấy danh sách category của user
    public List<String> getAllCategories(int userID) {
        return dao.getAllCategories(userID);
    }

    // Lấy danh sách đáp án của câu hỏi
    public List<AnswerOption> getOptionsByQuestionID(int questionID) {
        return dao.getOptionsByQuestionID(questionID);
    }

    // Search câu hỏi của user theo keyword
    public List<Question> searchQuestionsByUserID(int userID, String keyword) {
        return dao.searchQuestionsByUserIDAndKeyword(userID, keyword);
    }

    // Xóa câu hỏi
    public boolean deleteQuestionByIDAndUserID(int questionID, int userID) throws SQLException {
        return dao.deleteQuestionByIDAndUserID(questionID, userID);
    }

    // Search và sort câu hỏi
    public List<Question> searchAndSortQuestions(int userID, String keyword, String sort) {
        return dao.searchAndSortQuestions(userID, keyword, sort);
    }

    // Lấy question theo ID (để edit)
    public Question getQuestionByID(int questionID) {
        return dao.getQuestionByID(questionID);
    }

    // Cập nhật question cùng danh sách đáp án
    public void updateQuestion(Question question, List<AnswerOption> options) {
        dao.updateQuestion(question, options);
    }
      public List<Question> getQuestionsByQuizId(int quizId) {
        return dao.getQuestionsByQuizId(quizId);
    }
  public List<Question> getAllQuestions() {
    return dao.getAllQuestions();
}    
    
}