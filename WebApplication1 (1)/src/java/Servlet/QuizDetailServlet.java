/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
    private QuizService quizService = new QuizService();
    private QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int quizId = Integer.parseInt(request.getParameter("id"));

            // ✅ Lấy quiz theo ID
            Quiz quiz = quizService.getQuizById(quizId);

            // ✅ Lấy danh sách câu hỏi thuộc quiz
            List<Question> questions = questionService.getQuestionsByQuizId(quizId);

            // ✅ Gửi dữ liệu sang JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);

            RequestDispatcher rd = request.getRequestDispatcher("quizDetail.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quiz ID");
        }
    }
}