package Servlet;

import Entity.Module;
import Service.ModuleService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class EditModuleServlet extends HttpServlet {
    private ModuleService moduleService = new ModuleService();
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        Module module = moduleService.getModuleById(moduleId);
        if (module != null) {
            request.setAttribute("module", module);
            request.getRequestDispatcher("/instructor/editModule.jsp").forward(request, response);
        } else {
            response.getWriter().println("Module not found!");
        }
    } catch (NumberFormatException e) {
        response.getWriter().println("Invalid module ID!");
    }
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");

            Module module = moduleService.getModuleById(moduleId);
            if (module != null) {
                module.setTitle(title);
                module.setDescription(description);

                boolean success = moduleService.updateModule(module);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);
                } else {
                    response.getWriter().println("<h3 style='color:red;'>Failed to update module!</h3>");
                }
            } else {
                response.getWriter().println("<h3 style='color:red;'>Module not found!</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        }
    }
}
