package Servlet;

import Service.LessonDocumentService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DeleteDocumentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int documentId = Integer.parseInt(request.getParameter("documentId"));
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));

        LessonDocumentService service = new LessonDocumentService();
        boolean success = service.deleteDocument(documentId);

        request.getSession().setAttribute("status",
                success ? "🗑️ Document removed successfully!" : "❌ Failed to remove document.");

        response.sendRedirect("lessonDetail?lessonId=" + lessonId);
    }
}
