package Servlet;

import Service.LessonDocumentService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.*;

@MultipartConfig
public class UploadDocumentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        Part filePart = request.getPart("file");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + "uploads/documents/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String filePath = uploadPath + fileName;
            filePart.write(filePath);

            String relativePath = "uploads/documents/" + fileName;
            LessonDocumentService service = new LessonDocumentService();
            service.addDocument(lessonId, relativePath, fileName);

            request.getSession().setAttribute("status", "✅ Document uploaded successfully!");
        } else {
            request.getSession().setAttribute("status", "⚠️ Please choose a file to upload.");
        }

        response.sendRedirect("lessonDetail?lessonId=" + lessonId);
    }
}
