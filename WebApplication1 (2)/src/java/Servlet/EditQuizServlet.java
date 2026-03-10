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
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing quiz ID");
            return;
        }
        int quizID = Integer.parseInt(idParam);
        Quiz quiz = quizService.getQuizById(quizID);
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found!");
            return;
        }
        // Lấy câu hỏi trong quiz
        List<Question> quizQuestions = questionService.getQuestionsByQuizId(quizID);

        // Lấy toàn bộ question bank
        List<Question> questionBank = questionService.getAllQuestions();

        // Loại bỏ các câu đã có trong quiz
        questionBank.removeAll(quizQuestions);

        // 🔹 Chỉ giữ các câu cùng CategoryID với quiz
        int quizCategoryID = quiz.getCategoryID() != null ? quiz.getCategoryID() : -1;
      questionBank.removeIf(q -> q.getCategoryID() != quizCategoryID);

        request.setAttribute("quiz", quiz);
        request.setAttribute("quizQuestions", quizQuestions);
        request.setAttribute("questionBank", questionBank);
        request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
    } catch (NumberFormatException e) {
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
            String quizIDParam = request.getParameter("quizID");
            if (quizIDParam == null || quizIDParam.isEmpty()) {
                request.setAttribute("errorMessage", "Quiz ID is missing");
                request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
                return;
            }
            int quizID = Integer.parseInt(quizIDParam);

            String title = request.getParameter("title");
            Integer duration = (request.getParameter("duration") == null || request.getParameter("duration").isEmpty())
                    ? null : Integer.parseInt(request.getParameter("duration"));
            Double passingScore = (request.getParameter("passingScore") == null || request.getParameter("passingScore").isEmpty())
                    ? null : Double.parseDouble(request.getParameter("passingScore"));
            Double pointPerQuestion = (request.getParameter("pointPerQuestion") == null || request.getParameter("pointPerQuestion").isEmpty())
                    ? null : Double.parseDouble(request.getParameter("pointPerQuestion"));
            String status = request.getParameter("status");
            boolean isRandom = request.getParameter("isRandom") != null;

            // Tạo object Quiz
Quiz oldQuiz = quizService.getQuizById(quizID); // Lấy quiz cũ từ DB
Quiz quiz = new Quiz();
quiz.setQuizID(quizID);
quiz.setTitle(title);
quiz.setDurationMinutes(duration);
quiz.setPassingScore(passingScore);
quiz.setPointPerQuestion(pointPerQuestion);
quiz.setStatus(status);
quiz.setRandom(isRandom);
quiz.setCategoryID(oldQuiz.getCategoryID()); // ✅ giữ nguyên categoryID

String categoryIDParam = request.getParameter("categoryID");
Integer categoryID = "-1".equals(categoryIDParam) ? null : Integer.parseInt(categoryIDParam);
quiz.setCategoryID(categoryID);
            // Xử lý câu hỏi xóa
            List<Integer> toDelete = new ArrayList<>();
            String[] toDeleteArr = request.getParameterValues("questionsToDelete");
            if (toDeleteArr != null) {
                for (String id : toDeleteArr) {
                    try { toDelete.add(Integer.parseInt(id)); } catch (NumberFormatException ignored) {}
                }
            }

            // Xử lý câu hỏi thêm
            List<Integer> toAdd = new ArrayList<>();
            String[] toAddArr = request.getParameterValues("questionsToAdd");
            if (toAddArr != null) {
                for (String id : toAddArr) {
                    try { toAdd.add(Integer.parseInt(id)); } catch (NumberFormatException ignored) {}
                }
            }

            boolean updated = quizService.updateQuiz(quiz, toDelete, toAdd);
            if (updated) {
                response.sendRedirect("QuizListServlet?success=updated");
            } else {
                // Load lại dữ liệu nếu thất bại
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
            request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
        }
    }
}