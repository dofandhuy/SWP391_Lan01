package Servlet;

import Entity.Course;
import Entity.Module;
import Service.CourseService;
import Service.ModuleService;
import Service.QuizService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CreateModuleServlet extends HttpServlet {

    private ModuleService moduleService = new ModuleService();
    private CourseService courseService = new CourseService();
    private QuizService quizService = new QuizService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            Course course = courseService.getCourseById(courseId);
            if (course.getStatus().equalsIgnoreCase("Pending") || course.getStatus().equalsIgnoreCase("Approved")) {
                request.setAttribute("error", "Cannot create module. Course is " + course.getStatus());
                request.getRequestDispatcher("/instructor/createModule.jsp").forward(request, response);
                return;
            }

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String quizIdParam = request.getParameter("quizId");
            Integer quizId = (quizIdParam != null && !quizIdParam.isEmpty()) ? Integer.parseInt(quizIdParam) : null;

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
            
            int moduleId = module.getId();

            if (quizId != null) {
                quizService.assignQuizToModule(quizId, moduleId);
            }

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
            if (modules.isEmpty()) {
                return 1;
            }
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
