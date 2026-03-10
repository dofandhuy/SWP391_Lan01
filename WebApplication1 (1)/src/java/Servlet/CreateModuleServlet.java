package Servlet;

import Entity.Module;
import Service.ModuleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


public class CreateModuleServlet extends HttpServlet {
    private ModuleService moduleService = new ModuleService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");

            // ✅ Tự động set orderIndex = module cuối + 1
            int nextOrder = getNextOrderIndex(courseId);

            // Tạo đối tượng module
            Module module = new Module();
            module.setCourseId(courseId);
            module.setTitle(title);
            module.setDescription(description);
            module.setOrderIndex(nextOrder);

            // Gọi service để lưu
            boolean success = moduleService.addModule(module);

            if (success) {
                // Quay lại trang chi tiết khoá học
                response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);
            } else {
                request.setAttribute("error", "❌ Failed to create module!");
                request.getRequestDispatcher("/instructor/createModule.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠️ Error: " + e.getMessage());
            request.getRequestDispatcher("/instructor/createModule.jsp").forward(request, response);
        }
    }

    private int getNextOrderIndex(int courseId) {
        try {
            var modules = moduleService.getModulesByCourseId(courseId);
            if (modules.isEmpty()) return 1;
            return modules.stream()
                    .map(Module::getOrderIndex)
                    .max(Integer::compareTo)
                    .orElse(0) + 1;
        } catch (Exception e) {
            e.printStackTrace();
            return 1;
        }
    }
}
