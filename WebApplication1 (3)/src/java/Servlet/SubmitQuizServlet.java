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
import java.util.ArrayList;
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

            List<CorrectAnswerDTO> correctAnswersList = quizDAO.getCorrectAnswersForQuiz(quizId);

            // Convert Answer Key List to Map for fast lookup (Key: QuestionID)
            Map<Integer, CorrectAnswerDTO> answerKeyMap = new HashMap<>();
            for (CorrectAnswerDTO ans : correctAnswersList) {
                answerKeyMap.put(ans.getQuestionId(), ans);
            }

            // --- ADDED: Lấy tổng số câu hỏi từ Answer Key (đáng tin cậy nhất) ---
            int totalQuestions = answerKeyMap.size();

            // --- STEP 3: GRADING LOGIC ---
            int correctCount = 0;
            int incorrectCount = 0;
            double totalScore = 0.0;

            for (Map.Entry<String, String[]> entry : studentAnswersMap.entrySet()) {
                String paramName = entry.getKey();

                if (paramName.startsWith("q")) {
                    try {
                        int questionId = Integer.parseInt(paramName.substring(1));
                        String[] studentAnswers = entry.getValue(); // Có thể nhiều đáp án
                        boolean isStudentCorrect = false;

                        if (studentAnswers != null && studentAnswers.length > 0) {
                            // ✅ Lấy danh sách đáp án đúng từ DB
                            List<Integer> correctOptionIds = quizDAO.getCorrectOptionIdsByQuestionId(questionId);

                            // ✅ Lấy danh sách người dùng chọn
                            List<Integer> studentOptionIds = new ArrayList<>();
                            for (String s : studentAnswers) {
                                try {
                                    studentOptionIds.add(Integer.parseInt(s));
                                } catch (NumberFormatException e) {
                                    // bỏ qua nếu lỗi
                                }
                            }

                            // ✅ Cách 1: phải chọn đúng hết, không dư
                            if (studentOptionIds.containsAll(correctOptionIds)
                                    && correctOptionIds.containsAll(studentOptionIds)) {
                                isStudentCorrect = true;
                            }
                        }

                        // --- Ghi nhận kết quả ---
                        if (isStudentCorrect) {
                            correctCount++;
                        } else {
                            incorrectCount++;
                        }
                        attemptDAO.saveStudentAnswer(attemptId, questionId, String.join(",", studentAnswers), isStudentCorrect);

                    } catch (Exception e) {
                        System.err.println("Error grading question: " + paramName);
                        e.printStackTrace();
                        incorrectCount++;
                    }
                }
            }

            // --- STEP 4: CALCULATE DURATION & FINALIZE ---
            int durationSeconds = 0;
            Date startTime = attemptDAO.getAttemptStartTime(attemptId);
            if (startTime != null) {
                long durationMillis = System.currentTimeMillis() - startTime.getTime();
                durationSeconds = (int) (durationMillis / 1000);
            }

            // --- CHANGED: Tính điểm theo logic mới (thang điểm 10) ---
            if (totalQuestions > 0) {
                // Công thức: (Số câu đúng / Tổng số câu) * 10
                // (Nếu muốn thang điểm 100, hãy đổi 10.0 thành 100.0)
                totalScore = ((double) correctCount / totalQuestions) * 10.0;
            } else {
                totalScore = 0.0; // Tránh lỗi chia cho 0
            }

            // Round the score (e.g., to 2 decimal places)
            totalScore = Math.round(totalScore * 100.0) / 100.0;

            // Update the final score and duration in QuizAttempts table
            attemptDAO.updateAttemptScore(attemptId, totalScore, durationSeconds);

            // --- STEP 5: PREPARE DATA FOR RESULT PAGE ---
            request.setAttribute("score", totalScore);
            request.setAttribute("correctCount", correctCount);

            // --- CHANGED: Gửi đi tổng số câu hỏi chính xác ---
            request.setAttribute("totalQuestions", totalQuestions);

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
