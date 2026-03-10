package Servlet;

import Entity.Course;
import Entity.Module;
import Entity.Quiz;
import Service.CourseService;
import Service.ModuleService;
import Service.QuizService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class EditModuleServlet extends HttpServlet {

    private final ModuleService moduleService = new ModuleService();
    private final CourseService courseService = new CourseService();
    private final QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            Module module = moduleService.getModuleById(moduleId);

            if (module != null) {
                // Lấy quiz đã gán cho module (nếu có)
                Quiz assignedQuiz = quizService.getQuizByModuleId(moduleId);

                // Lưu vào request để JSP hiển thị
                request.setAttribute("module", module);
                request.setAttribute("assignedQuiz", assignedQuiz);

                request.getRequestDispatcher("/instructor/editModule.jsp").forward(request, response);
            } else {
                response.getWriter().println("<h3 style='color:red;'>Module not found!</h3>");
            }
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3 style='color:red;'>Invalid module ID!</h3>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String quizIdParam = request.getParameter("quizId");

            Integer quizId = (quizIdParam != null && !quizIdParam.isEmpty())
                    ? Integer.parseInt(quizIdParam)
                    : null;

            Course course = courseService.getCourseById(courseId);

            // Chặn chỉnh sửa nếu khóa học đang ở trạng thái Pending/Approved
            if (course != null &&
                    (course.getStatus().equalsIgnoreCase("Pending") || course.getStatus().equalsIgnoreCase("Approved"))) {
                request.setAttribute("error", "Cannot edit module. Course is " + course.getStatus());
                request.getRequestDispatcher("/instructor/editModule.jsp").forward(request, response);
                return;
            }

            Module module = moduleService.getModuleById(moduleId);
            if (module == null) {
                request.setAttribute("error", "Module not found!");
                request.getRequestDispatcher("/instructor/editModule.jsp").forward(request, response);
                return;
            }

            // Cập nhật module
            module.setTitle(title);
            module.setDescription(description);
            boolean success = moduleService.updateModule(module);

            // Cập nhật quiz được gán
            if (quizId != null) {
                quizService.assignQuizToModule(quizId, moduleId);
            } else {
                quizService.removeQuizFromModule(moduleId);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);
            } else {
                request.setAttribute("error", "❌ Failed to update module!");
                request.getRequestDispatcher("/instructor/editModule.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠️ Error: " + e.getMessage());
            request.getRequestDispatcher("/instructor/editModule.jsp").forward(request, response);
        }
    }
}