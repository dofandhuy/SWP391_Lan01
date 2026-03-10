package Servlet;

import Entity.Question;
import Entity.Quiz;
import Service.QuestionService;
import Service.QuizService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class EditQuizServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();
    private final QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int quizID = Integer.parseInt(request.getParameter("id"));
            Quiz quiz = quizService.getQuizById(quizID);
            if (quiz == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found!");
                return;
            }

            List<Question> quizQuestions = questionService.getQuestionsByQuizId(quizID);
            List<Question> questionBank = questionService.getAllQuestions();
            questionBank.removeAll(quizQuestions); // Loại bỏ câu đã có trong quiz

            request.setAttribute("quiz", quiz);
            request.setAttribute("quizQuestions", quizQuestions);
            request.setAttribute("questionBank", questionBank);

            request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quiz ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            int quizID = Integer.parseInt(request.getParameter("quizID"));
            String title = request.getParameter("title");
            int duration = Integer.parseInt(request.getParameter("duration"));
            double passingScore = Double.parseDouble(request.getParameter("passingScore"));
            double pointPerQuestion = Double.parseDouble(request.getParameter("pointPerQuestion"));
            String status = request.getParameter("status");
            boolean isRandom = request.getParameter("isRandom") != null;
            String maxAttemptsStr = request.getParameter("maxAttempts");
            String cooldownStr = request.getParameter("attemptCooldown");

            Integer maxAttempts = (maxAttemptsStr == null || maxAttemptsStr.isEmpty() || maxAttemptsStr.equals("0")) ? null : Integer.parseInt(maxAttemptsStr);
            Integer attemptCooldown = (cooldownStr == null || cooldownStr.isEmpty() || cooldownStr.equals("0")) ? null : Integer.parseInt(cooldownStr);

            Quiz quiz = new Quiz();
            quiz.setQuizID(quizID);
            quiz.setTitle(title);
            quiz.setDurationMinutes(duration);
            quiz.setPassingScore(passingScore);
            quiz.setPointPerQuestion(pointPerQuestion);
            quiz.setStatus(status);
            quiz.setRandom(isRandom);
            quiz.setMaxAttempts(maxAttempts);
            quiz.setAttemptCooldownHours(attemptCooldown);

            // Xử lý câu hỏi xóa
            String[] toDeleteArr = request.getParameterValues("questionsToDelete");
            List<Integer> toDelete = new ArrayList<>();
            if (toDeleteArr != null) {
                for (String id : toDeleteArr) {
                    try { toDelete.add(Integer.parseInt(id)); } catch (NumberFormatException ignored) {}
                }
            }

            // Xử lý câu hỏi thêm
            String[] toAddArr = request.getParameterValues("questionsToAdd");
            List<Integer> toAdd = new ArrayList<>();
            if (toAddArr != null) {
                for (String id : toAddArr) {
                    try { toAdd.add(Integer.parseInt(id)); } catch (NumberFormatException ignored) {}
                }
            }

            boolean updated = quizService.updateQuiz(quiz, toDelete, toAdd);

            if (updated) {
                response.sendRedirect("QuizListServlet?success=updated");
            } else {
                // Nếu cập nhật thất bại, load lại dữ liệu
                List<Question> quizQuestions = questionService.getQuestionsByQuizId(quizID);
                List<Question> questionBank = questionService.getAllQuestions();
                questionBank.removeAll(quizQuestions);

                request.setAttribute("quiz", quiz);
                request.setAttribute("quizQuestions", quizQuestions);
                request.setAttribute("questionBank", questionBank);
                request.setAttribute("errorMessage", "Cập nhật quiz thất bại!");
                request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật quiz: " + e.getMessage());

            // Load lại dữ liệu để tránh JSP lỗi
            try {
                int quizID = Integer.parseInt(request.getParameter("quizID"));
                Quiz quiz = quizService.getQuizById(quizID);
                List<Question> quizQuestions = questionService.getQuestionsByQuizId(quizID);
                List<Question> questionBank = questionService.getAllQuestions();
                questionBank.removeAll(quizQuestions);

                request.setAttribute("quiz", quiz);
                request.setAttribute("quizQuestions", quizQuestions);
                request.setAttribute("questionBank", questionBank);
            } catch (Exception ex) { ex.printStackTrace(); }

            request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
        }
    }
}