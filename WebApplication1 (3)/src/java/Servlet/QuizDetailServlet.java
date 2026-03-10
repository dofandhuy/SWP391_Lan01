package Servlet;

import Entity.Question;
import Entity.Quiz;
import Service.QuestionService;
import Service.QuizService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class QuizDetailServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();
    private final QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing quiz ID");
                return;
            }

            int quizId = Integer.parseInt(idRaw);

            // ✅ Lấy thông tin quiz
            Quiz quiz = quizService.getQuizById(quizId);
            if (quiz == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
                return;
            }

            // ✅ Lấy câu hỏi thuộc quiz
            List<Question> questions = questionService.getQuestionsByQuizId(quizId);

            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);

            RequestDispatcher rd = request.getRequestDispatcher("quizDetail.jsp");
            rd.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quiz ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
}