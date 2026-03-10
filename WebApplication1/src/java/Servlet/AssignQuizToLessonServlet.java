package Servlet;

import Service.LessonService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/assignQuizToLesson")
public class AssignQuizToLessonServlet extends HttpServlet {
    private LessonService lessonService;

    @Override
    public void init() throws ServletException {
        lessonService = new LessonService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int quizId = Integer.parseInt(request.getParameter("quizId"));

            boolean success = lessonService.assignQuizToLesson(lessonId, quizId);

            if (success) {
                request.getSession().setAttribute("message", "✅ Quiz assigned successfully!");
            } else {
                request.getSession().setAttribute("error", "❌ Failed to assign quiz. Please try again.");
            }

            // Quay lại trang lesson detail
            response.sendRedirect("instructor/lessonDetail?lessonId=" + lessonId);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Invalid input data.");
            response.sendRedirect("instructor/lessonDetail?lessonId=" + request.getParameter("lessonId"));
        }
    }
}
