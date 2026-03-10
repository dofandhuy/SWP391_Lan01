/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Dao.QuizAttemptDAO;
import Dao.QuizDAO;
import Entity.CorrectAnswerDTO;
import Entity.Quiz;
import Entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Date;

/**
 *
 * @author doanh
 */
public class SubmitQuizServlet extends HttpServlet {

  private QuizDAO quizDAO;
    private QuizAttemptDAO attemptDAO;

    @Override
    public void init() {
        this.quizDAO = new QuizDAO();
        this.attemptDAO = new QuizAttemptDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Ensure proper handling of FillBlank answers

        HttpSession session = request.getSession(false);

        // --- AUTHENTICATION/AUTHORIZATION CHECK ---
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("signin");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (!currentUser.getRole().getRoleName().equals("Student")) {
            response.sendRedirect("signin");
            return;
        }
        // --- END CHECK ---

        try {
            // --- STEP 1: GET SUBMITTED DATA ---
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            Map<String, String[]> studentAnswersMap = request.getParameterMap();

            // --- STEP 2: GET QUIZ RULES & ANSWER KEY ---
            Quiz quiz = quizDAO.getQuizById(quizId);
            if (quiz == null) {
                request.setAttribute("errorMessage", "Quiz not found.");
                request.getRequestDispatcher("errorPage.jsp").forward(request, response);
                return;
            }
            double pointPerQuestion = quiz.getPointPerQuestion();
            List<CorrectAnswerDTO> correctAnswersList = quizDAO.getCorrectAnswersForQuiz(quizId);

            // Convert Answer Key List to Map for fast lookup (Key: QuestionID)
            Map<Integer, CorrectAnswerDTO> answerKeyMap = new HashMap<>();
            for (CorrectAnswerDTO ans : correctAnswersList) {
                answerKeyMap.put(ans.getQuestionId(), ans);
            }

            // --- STEP 3: GRADING LOGIC ---
            int correctCount = 0;
            int incorrectCount = 0;
            int totalQuestionsInSubmission = 0;
            double totalScore = 0.0;

            // Iterate through submitted parameters
            for (String paramName : studentAnswersMap.keySet()) {
                // Process only parameters starting with 'q' (question answers)
                if (paramName.startsWith("q")) {
                    try {
                        // Extract Question ID and Student's Answer
                        int questionId = Integer.parseInt(paramName.substring(1)); // "q123" -> 123
                        String studentAnswer = studentAnswersMap.get(paramName)[0]; // Get the first value
                        totalQuestionsInSubmission++;

                        // Get the correct answer from the map
                        CorrectAnswerDTO correctAnswer = answerKeyMap.get(questionId);
                        boolean isStudentCorrect = false;

                        if (correctAnswer != null && studentAnswer != null && !studentAnswer.isEmpty()) {
                            String questionType = correctAnswer.getQuestionType();

                            // Compare based on question type
                            if ("MCQ".equals(questionType) || "TrueFalse".equals(questionType)) {
                                try {
                                    int studentAnswerId = Integer.parseInt(studentAnswer);
                                    if (studentAnswerId == correctAnswer.getCorrectAnwerId()) {
                                        isStudentCorrect = true;
                                    }
                                } catch (NumberFormatException nfe) {
                                    // Invalid answer format for MCQ/TF
                                    System.err.println("Warning: Invalid number format for MCQ/TF answer. QID=" + questionId + ", Answer=" + studentAnswer);
                                }
                            } else if ("FillBlank".equals(questionType)) {
                                // Case-insensitive and trim whitespace comparison
                                if (studentAnswer.trim().equalsIgnoreCase(correctAnswer.getCorrectAnswerText().trim())) {
                                    isStudentCorrect = true;
                                }
                            }
                        }

                        // Update score and counts
                        if (isStudentCorrect) {
                            correctCount++;
                            totalScore += pointPerQuestion;
                        } else {
                            incorrectCount++;
                        }

                        // IMPORTANT: Save the student's answer (correct or incorrect)
                        attemptDAO.saveStudentAnswer(attemptId, questionId, studentAnswer, isStudentCorrect);

                    } catch (Exception e) {
                        // Log unexpected errors during grading of a specific question
                        System.err.println("Error grading question from param: " + paramName);
                        e.printStackTrace();
                        incorrectCount++; // Count as incorrect if error occurs
                    }
                }
            } // End of loop through student answers

            // --- STEP 4: CALCULATE DURATION & FINALIZE ---
            int durationSeconds = 0;
            Date startTime = attemptDAO.getAttemptStartTime(attemptId);
            if (startTime != null) {
                long durationMillis = System.currentTimeMillis() - startTime.getTime();
                durationSeconds = (int) (durationMillis / 1000);
            }

            // Round the score (e.g., to 2 decimal places)
            totalScore = Math.round(totalScore * 100.0) / 100.0;

            // Update the final score and duration in QuizAttempts table
            attemptDAO.updateAttemptScore(attemptId, totalScore, durationSeconds);

            // --- STEP 5: PREPARE DATA FOR RESULT PAGE ---
            request.setAttribute("score", totalScore);
            request.setAttribute("correctCount", correctCount);
            request.setAttribute("totalQuestions", totalQuestionsInSubmission); // Or use quiz.getNumQuestions() if more reliable
            request.setAttribute("passingScore", quiz.getPassingScore());
            request.setAttribute("attemptId", attemptId); // Pass attemptId for potential review feature
            request.setAttribute("quizTitle", quiz.getTitle());

            // --- STEP 6: FORWARD TO RESULT PAGE (Stage 4) ---
            request.getRequestDispatcher("quizResult.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while submitting the quiz.");
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        }
    }
}
