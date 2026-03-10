package Servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Entity.Course;
import Service.CourseService;
import Entity.User;
import Entity.Category;
import Service.CategoryService;
import java.io.IOException;
import java.util.List;

@WebServlet("/instructor/courses")
public class InstructorCourseServlet extends HttpServlet {

    private final CourseService service = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"instructor".equalsIgnoreCase(user.getRole().getRoleName())) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        String action = req.getParameter("action");

        // Nếu là tạo course → load danh sách Category
        if ("create".equals(action)) {
            List<Category> categories = CategoryService.getAllCategories();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/instructor/createCourse.jsp").forward(req, resp);
            return;
        }

        // Mặc định: hiển thị danh sách course
        int instructorId = user.getUserID();
        String search = req.getParameter("search") != null ? req.getParameter("search") : "";
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        int pageSize = 5;

        List<Course> courses = service.getPagedCourses(instructorId, page, pageSize, search);
        int totalPages = service.getTotalPages(instructorId, pageSize, search);

        req.setAttribute("courses", courses);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("search", search);

        req.getRequestDispatcher("/instructor/myCourse.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"instructor".equalsIgnoreCase(user.getRole().getRoleName())) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        int instructorId = user.getUserID();
        String action = req.getParameter("action");

        if ("create".equals(action)) {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));

            Course c = new Course();
            c.setInstructorId(instructorId);
            c.setTitle(title);
            c.setDescription(description);
            c.setCategoryId(categoryId);

            boolean success = service.createCourse(c);
            resp.sendRedirect(req.getContextPath() + "/instructor/courses?success=" + success);
        } else if ("delete".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            boolean success = service.deleteCourseWithModules(courseId);
            resp.sendRedirect(req.getContextPath() + "/instructor/courses?deleted=" + success);
        } else if ("edit".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String title = req.getParameter("title");
            String description = req.getParameter("description");

            Course course = new Course();
            course.setId(courseId);
            course.setTitle(title);
            course.setDescription(description);

            boolean success = service.updateCourse(course);
            resp.sendRedirect(req.getContextPath() + "/instructor/courses?edited=" + success);
        } else if ("publish".equals(action)) {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        boolean success = service.updateCourseStatus(courseId, "PendingApproval");
        if (success) {
            req.getSession().setAttribute("msg", "Course sent for approval successfully.");
        } else {
            req.getSession().setAttribute("msg", "Failed to publish course.");
        }
        resp.sendRedirect(req.getContextPath() + "/instructor/courses");
        return;
    }

    }
}
