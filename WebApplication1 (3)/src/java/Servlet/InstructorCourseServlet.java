package Servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Entity.Course;
import Service.CourseService;
import Entity.User;
import Entity.Category;
import Service.CategoryService;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

@WebServlet("/instructor/courses")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
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
        } else if ("edit".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            Course course = service.getCourseById(courseId);

            if (course == null) {
                resp.getWriter().write("<p style='color:red'>Course not found.</p>");
                return;
            }

            List<Category> categories = CategoryService.getAllCategories();
            req.setAttribute("course", course);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/instructor/editCourse.jsp").forward(req, resp);
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

            Part filePart = req.getPart("thumbnail"); // "thumbnail" là name của input
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString(); // tên file
                String uploadPath = getServletContext().getRealPath("") + "uploads/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                filePart.write(uploadPath + fileName);
            }

            Course c = new Course();
            c.setInstructorId(instructorId);
            c.setTitle(title);
            c.setDescription(description);
            c.setCategoryId(categoryId);
            c.setThumbnail(fileName);

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
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));

            Course course = service.getCourseById(courseId);
            if (course == null) {
                session.setAttribute("msg", "Course not found.");
                session.setAttribute("msgType", "error");
                resp.sendRedirect(req.getContextPath() + "/instructor/courses");
                return;
            }

            // Xử lý file thumbnail nếu có
            Part filePart = req.getPart("thumbnail");
            String fileName = course.getThumbnail(); // giữ lại ảnh cũ
            if (filePart != null && filePart.getSize() > 0) {
                fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + "uploads/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                filePart.write(uploadPath + fileName);
            }

            course.setTitle(title);
            course.setDescription(description);
            course.setCategoryId(categoryId);
            course.setThumbnail(fileName);

            boolean success = service.updateCourse(course);

            if (success) {
                session.setAttribute("msg", "Course updated successfully.");
                session.setAttribute("msgType", "success");
            } else {
                session.setAttribute("msg", "Failed to update course.");
                session.setAttribute("msgType", "error");
            }

            resp.sendRedirect(req.getContextPath() + "/instructor/courses");
        } else if ("publish".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            Course course = service.getCourseById(courseId);

            if (course == null) {
                session.setAttribute("msg", "Course not found.");
                session.setAttribute("msgType", "error");
            } else if ("Pending".equalsIgnoreCase(course.getStatus()) || "Approved".equalsIgnoreCase(course.getStatus())) {
                session.setAttribute("msg", "This course is already published or waiting for approval.");
                session.setAttribute("msgType", "warning");
            } else {
                boolean success = service.updateCourseStatus(courseId, "Pending");
                if (success) {
                    session.setAttribute("msg", "Course sent for approval successfully.");
                    session.setAttribute("msgType", "success");
                } else {
                    session.setAttribute("msg", "Failed to publish course.");
                    session.setAttribute("msgType", "error");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/instructor/courses");
            return;
        }

    }
}
