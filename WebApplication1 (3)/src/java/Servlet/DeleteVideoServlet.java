package Servlet;

import Service.LessonVideoService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DeleteVideoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int videoId = Integer.parseInt(request.getParameter("videoId"));
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));

        LessonVideoService service = new LessonVideoService();
        boolean success = service.deleteVideo(videoId);

        request.getSession().setAttribute("status",
                success ? "🗑️ Video removed successfully!" : "❌ Failed to remove video.");

        response.sendRedirect("lessonDetail?lessonId=" + lessonId);
    }
}
