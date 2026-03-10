package Servlet;

import Service.LessonService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class MoveLessonServlet extends HttpServlet {

    private LessonService lessonService = new LessonService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String lessonIdStr = request.getParameter("lessonId");
        String moduleIdStr = request.getParameter("moduleId");
        String courseIdStr = request.getParameter("courseId");

        if (action == null || lessonIdStr == null || moduleIdStr == null || courseIdStr == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        int lessonId = Integer.parseInt(lessonIdStr);
        int moduleId = Integer.parseInt(moduleIdStr);
        int courseId = Integer.parseInt(courseIdStr);

        boolean success = false;
        try {
            if (action.equals("up")) {
                success = lessonService.moveLessonUp(lessonId, moduleId);
            } else if (action.equals("down")) {
                success = lessonService.moveLessonDown(lessonId, moduleId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId + "&msg=fail");
        }
    }
}
