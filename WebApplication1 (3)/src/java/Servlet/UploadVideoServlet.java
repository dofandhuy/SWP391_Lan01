package Servlet;

import Service.LessonVideoService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@MultipartConfig
public class UploadVideoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        Part filePart = request.getPart("file");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + "uploads/videos/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String filePath = uploadPath + fileName;
            filePart.write(filePath);

            String relativePath = "uploads/videos/" + fileName;
            LessonVideoService service = new LessonVideoService();
            service.addLocalVideo(lessonId, relativePath, fileName);

            request.getSession().setAttribute("status", "✅ Video uploaded successfully!");
        } else {
            request.getSession().setAttribute("status", "⚠️ Please choose a video to upload.");
        }

        response.sendRedirect("lessonDetail?lessonId=" + lessonId);
    }
}
