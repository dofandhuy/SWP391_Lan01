/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import Dao.QuizAttemptDAO;
import Dao.QuizDAO;
import Entity.AnswerOption;
import Entity.Question;
import Entity.Quiz;
import Entity.QuizAttemptQuestion;
import Entity.QuizReviewDTO;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author doanh
 */
public class QuizReviewService {

    private QuizDAO quizDAO;
    private QuizAttemptDAO attemptDAO;

    public QuizReviewService() {
        this.quizDAO = new QuizDAO();
        this.attemptDAO = new QuizAttemptDAO();
    }

    /**
     * Gathers all data needed to review a specific quiz attempt.
     *
     * @param attemptId The ID of the quiz attempt to review.
     * @return A QuizReviewDTO containing all review details, or null if the
     * attempt is not found or an error occurs.
     */
    public QuizReviewDTO getReviewData(int attemptId) {
        try {
            // 1. Get student's submitted answers for this attempt
            List<QuizAttemptQuestion> studentAnswersList = attemptDAO.getStudentAnswersForAttempt(attemptId);
            if (studentAnswersList == null || studentAnswersList.isEmpty()) {
                System.err.println("Review Service: Attempt not found or has no answers for ID: " + attemptId);
                return null; // Attempt not found or empty
            }
            // Convert list to map for easier lookup
            Map<Integer, QuizAttemptQuestion> studentAnswersReviewMap = studentAnswersList.stream()
                    .collect(Collectors.toMap(QuizAttemptQuestion::getQuestionId, qa -> qa));

            // 2. Get the QuizID for this attempt
            int quizId = attemptDAO.getQuizIdForAttempt(attemptId);
            if (quizId == -1) {
                System.err.println("Review Service: Could not find QuizID for AttemptID: " + attemptId);
                return null; // Quiz not found for this attempt
            }

            // 3. Get Quiz basic info
            Quiz quiz = quizDAO.getQuizById(quizId);
            if (quiz == null) {
                System.err.println("Review Service: Could not find Quiz details for QuizID: " + quizId);
                return null; // Quiz details missing
            }

            // 4. Get all questions for the quiz
            List<Question> questionsForReview = quizDAO.getQuestionsByQuizId(quizId);

            // 5. Get ALL options (including correct flag) for each question
            Map<Integer, List<AnswerOption>> allOptionsMap = new HashMap<>();
            for (Question q : questionsForReview) {
                // Ensure DAO method fetches IsCorrect
                allOptionsMap.put(q.getQuestionID(), quizDAO.getAllAnswerOptionsForQuestion(q.getQuestionID()));
            }

            // 6. Get final score and recalculate correct count
            double finalScore = attemptDAO.getAttemptScore(attemptId);
            int correctCount = 0;
            for (QuizAttemptQuestion ans : studentAnswersList) {
                if (ans.isCorrect()) {
                    correctCount++;
                }
            }

            // 7. Assemble the DTO
            QuizReviewDTO reviewData = new QuizReviewDTO();
            reviewData.setAttemptId(attemptId);
            reviewData.setQuizTitle(quiz.getTitle());
            reviewData.setScore(finalScore);
            reviewData.setPassingScore(quiz.getPassingScore());
            reviewData.setCorrectCount(correctCount);
            reviewData.setTotalQuestions(quiz.getNumQuestions()); // Use total from Quiz entity
            reviewData.setQuestions(questionsForReview);
            reviewData.setAllOptionsMap(allOptionsMap);
            reviewData.setStudentAnswersMap(studentAnswersReviewMap);
          
            return reviewData; // Return the fully populated DTO

        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            return null; // Return null on any unexpected error
        }
    }

    
}
