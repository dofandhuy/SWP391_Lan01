/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;
import Entity.Quiz;
import Service.QuizService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class QuizListServlet extends HttpServlet {
    private QuizService service = new QuizService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         
        List<Quiz> quizzes = service.getAllQuiz();
        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("quizManagement.jsp").forward(request, response);
    }
}