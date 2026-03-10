package Servlet;

import Service.ModuleService;
import Entity.Module;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ModuleServlet extends HttpServlet {
    private final ModuleService moduleService = new ModuleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseIdStr = request.getParameter("courseId");
        System.out.println("Received courseId = " + courseIdStr);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            List<Module> modules = moduleService.getModulesByCourseId(courseId);

            Gson gson = new Gson();
            String json = gson.toJson(modules);
            System.out.println("✅ JSON Output: " + json);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
}