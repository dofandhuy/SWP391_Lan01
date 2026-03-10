package Servlet;

import Service.ModuleService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;


public class DeleteModuleServlet extends HttpServlet {

    private ModuleService moduleService = new ModuleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String moduleIdStr = request.getParameter("moduleId");
        String courseIdStr = request.getParameter("courseId");

        if (moduleIdStr == null || courseIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/instructor/courses");
            return;
        }

        try {
            int moduleId = Integer.parseInt(moduleIdStr);
            int courseId = Integer.parseInt(courseIdStr);

            boolean deleted = moduleService.deleteModuleWithLessons(moduleId);

            if (deleted) {
                request.getSession().setAttribute("msg", "Module deleted successfully!");
            } else {
                request.getSession().setAttribute("msg", "Failed to delete module.");
            }

            response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/instructor/courses");
        }
    }
}
