package Service;

import Dao.EnrollmentDAO;
import Dao.QuizAttemptDAO;
import Dao.QuizDAO;
import Dao.UserDAO;
import Entity.HighestAttemptInfo;
import Entity.Quiz;
import Entity.QuizDetailsDTO;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import java.util.List;
public class QuizService {

    private QuizDAO dao = new QuizDAO();
    private UserDAO userDAO;
    private EnrollmentDAO enrollmentDAO;
    private QuizAttemptDAO attemptDAO;

    public QuizService() {
        this.dao = new QuizDAO();
        this.userDAO = new UserDAO();
        this.enrollmentDAO = new EnrollmentDAO();
        this.attemptDAO = new QuizAttemptDAO();
    }

public int createQuiz(Quiz quiz, String[] selectedQuestions, int easy, int medium, int hard, String category) {
    int quizID = dao.insertQuiz(quiz);
    if (quizID == -1) return -1;

    // ✅ Gom danh sách ID đã chọn để loại trừ khỏi random
    List<Integer> excluded = new ArrayList<>();
    if (selectedQuestions != null) {
        for (String id : selectedQuestions) {
            excluded.add(Integer.parseInt(id));
        }
    }

    // ✅ Random câu hỏi nhưng loại trừ câu đã chọn thủ công
    if (quiz.isRandom()) {
        dao.addRandomQuestions(quizID, easy, medium, hard, quiz.getCreatedBy(), category, excluded);
    }

    // ✅ Cuối cùng thêm các câu đã chọn thủ công vào quiz
    if (selectedQuestions != null && selectedQuestions.length > 0) {
        dao.addSelectedQuestions(quizID, selectedQuestions);
    }

    return quizID;
}
    /**
     * Lấy tất cả dữ liệu và xử lý logic cho Giai đoạn 1.
     */
  public QuizDetailsDTO getQuizDetailsForStudent(int quizId, int studentId) {

        QuizDetailsDTO data = new QuizDetailsDTO();
        data.setQuizId(quizId);

        try {
            // --- STEP 1: FETCH RAW DATA ---

            // 1a. Get Quiz info
            Quiz quiz = dao.getQuizById(quizId); // Corrected DAO variable name
            if (quiz == null) {
                System.err.println("QuizService: Quiz not found for ID: " + quizId);
                return null;
            }
            data.setQuizTitle(quiz.getTitle());
            data.setDurationMinutes(quiz.getDurationMinutes());
            data.setMaxAttempts(quiz.getMaxAttempts());
            data.setAttemptCooldownHours(quiz.getAttemptCooldownHours());
            data.setPointPerQuestion(quiz.getPointPerQuestion());

            // 1b. Get Instructor Name
            data.setInstructorName(userDAO.getInstructorNameByQuizId(quizId));

            // 1c. Get Deadline
            data.setDeadline(enrollmentDAO.getDeadlineByQuizId(studentId, quizId));

            // 1d. Get Attempt History (*** UPDATED PART ***)
            // Call the DAO method that returns HighestAttemptInfo
            HighestAttemptInfo highestInfo = attemptDAO.getHighestAttemptInfo(studentId, quizId);

            // Set the entire HighestAttemptInfo object into the DTO
            data.setHighestScore(highestInfo); // highestInfo can be null if no attempts

            // Fetch other attempt info
            int totalAttempts = attemptDAO.getTotalAttempts(studentId, quizId);
            Date lastAttemptTime = attemptDAO.getLastAttemptTime(studentId, quizId);

            // --- STEP 2: BUSINESS LOGIC ---
            boolean canStart = true;
            String waitMessage = "";
            int attemptsLeft = 999;

            // ... (Logic for canStart, attemptsLeft, waitMessage remains exactly the same) ...
            // 2a. Check Deadline
             if (data.getDeadline() != null && System.currentTimeMillis() > data.getDeadline().getTime()) {
                 canStart = false;
                 waitMessage = "The due date for this quiz has passed.";
             }

             // 2b. Check Max Attempts
             if (canStart && data.getMaxAttempts() != null && data.getMaxAttempts() > 0) {
                 attemptsLeft = data.getMaxAttempts() - totalAttempts;
                 if (attemptsLeft <= 0) {
                     canStart = false;
                     waitMessage = "You have no attempts left.";
                 }
             }
             data.setAttemptsLeft(attemptsLeft);

             // 2c. Check Cooldown
             if (canStart && data.getAttemptCooldownHours() != null && data.getAttemptCooldownHours() > 0 && lastAttemptTime != null) {
                 long lastAttemptMillis = lastAttemptTime.getTime();
                 long cooldownMillis = (long) data.getAttemptCooldownHours() * 3600 * 1000;
                 long nextAvailableTime = lastAttemptMillis + cooldownMillis;

                 if (System.currentTimeMillis() < nextAvailableTime) {
                     canStart = false;
                     long millisRemaining = nextAvailableTime - System.currentTimeMillis();
                     long hours = millisRemaining / 3600000;
                     long minutes = (millisRemaining % 3600000) / 60000 + 1;
                     waitMessage = "Please wait " + hours + "h " + minutes + "m to try again.";
                 }
             }

             // 2d. Set final logic results
             data.setCanStart(canStart);
             data.setWaitMessage(waitMessage);


            return data; // Return the DTO

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ✅ Cập nhật quiz + quản lý câu hỏi
  

    // ✅ Xóa quiz
    public boolean deleteQuiz(int quizID) {
        return dao.deleteQuiz(quizID);
    }

    // ✅ Lấy tất cả quiz
    public List<Quiz> getAllQuiz() {
        return dao.getAllQuiz();
    }

    // ✅ Lấy quiz theo ID
    public Quiz getQuizById(int quizID) {
        return dao.getQuizById(quizID);
    }

    // ✅ Lấy danh sách QuestionID trong quiz
    public List<Integer> getQuizQuestions(int quizID) {
        return dao.getQuizQuestions(quizID);
    }

    // ✅ Lấy tất cả QuestionBank (mọi giáo viên đều thấy)
    public List<Integer> getAllQuestionBank() {
        return dao.getAllQuestionBank();
    }

    // ✅ Chuyển mảng String sang List<Integer>
    private List<Integer> toIntegerList(String[] arr) {
        List<Integer> list = new java.util.ArrayList<>();
        for (String s : arr) {
            try {
                list.add(Integer.parseInt(s));
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return list;
    }
  public boolean updateQuiz(Quiz quiz, List<Integer> toDelete, List<Integer> toAdd) {
    try {
        dao.updateQuiz(quiz); // cập nhật thông tin cơ bản
        if (toDelete != null && !toDelete.isEmpty()) {
            dao.deleteSelectedQuestionsFromQuiz(quiz.getQuizID(), toDelete);
        }
        if (toAdd != null && !toAdd.isEmpty()) {
            dao.addQuestionsToQuiz(quiz.getQuizID(), toAdd);
        }
        
        // 4️⃣ Đếm lại tổng số câu hỏi hiện tại của quiz
        int newCount = dao.countQuestionsByQuizID(quiz.getQuizID());

        // 5️⃣ Cập nhật lại NumQuestions trong bảng Quizzes
        dao.updateNumQuestions(quiz.getQuizID(), newCount);

        return true;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

public void addSingleQuestion(int quizID, int questionID) {
    dao.addQuestionsToQuiz(quizID, List.of(questionID));
}

public void deleteSingleQuestion(int quizID, int questionID) {
    dao.deleteSelectedQuestionsFromQuiz(quizID, List.of(questionID));
}
 



public List<Quiz> getQuizzesByCategory(int categoryId) {
    return dao.getQuizzesByCategory(categoryId);
}
}
