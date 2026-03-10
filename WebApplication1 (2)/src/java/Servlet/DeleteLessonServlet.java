package Servlet;

import Service.LessonService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/instructor/DeleteLessonServlet")
public class DeleteLessonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            LessonService lessonService = new LessonService();

            boolean success = lessonService.deleteLesson(lessonId);
            String courseId = request.getParameter("courseId");
            if (courseId == null) courseId = "0";
            response.sendRedirect(request.getContextPath() +
                "/CourseDetailServlet?courseId=" + courseId + "&deleted=" + success);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/instructor/courses?deleted=false");
        }
    }
}
