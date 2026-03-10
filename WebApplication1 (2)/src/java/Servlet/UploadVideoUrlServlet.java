package Servlet;

import Service.LessonVideoService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class UploadVideoUrlServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String videoUrl = request.getParameter("videoUrl");

        if (videoUrl != null && !videoUrl.trim().isEmpty()) {

            // Chuẩn hóa URL cho YouTube
            videoUrl = videoUrl.trim();

            if (videoUrl.contains("youtube.com/watch?v=")) {
                videoUrl = videoUrl.replace("watch?v=", "embed/");
            } else if (videoUrl.contains("youtu.be/")) {
                videoUrl = videoUrl.replace("youtu.be/", "www.youtube.com/embed/");
            }

            // Có thể thêm hỗ trợ Vimeo nếu bạn dùng
            else if (videoUrl.contains("vimeo.com/")) {
                videoUrl = videoUrl.replace("vimeo.com/", "player.vimeo.com/video/");
            }

            LessonVideoService service = new LessonVideoService();
            service.addExternalVideo(lessonId, videoUrl);
            request.getSession().setAttribute("status", "✅ External video added successfully!");
        } else {
            request.getSession().setAttribute("status", "⚠️ Please enter a valid video URL.");
        }

        response.sendRedirect("lessonDetail?lessonId=" + lessonId);
    }
}
