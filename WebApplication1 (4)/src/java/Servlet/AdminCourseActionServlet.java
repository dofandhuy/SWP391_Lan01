package Servlet;

import Dao.CourseDAO;
import Entity.Course;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

// Servlet này xử lý cả GET (lấy chi tiết) và POST (cập nhật)
@WebServlet(name = "CourseActionServlet", urlPatterns = {"/admin/courseAction"})
public class AdminCourseActionServlet extends HttpServlet {
    
    private final CourseDAO courseDAO = new CourseDAO();
    private final Gson gson = new Gson();

    /**
     * Handles GET requests to fetch course details for the modal (AJAX).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            Course course = courseDAO.getCourseDetailsById(courseId);
            
            String courseJsonString = this.gson.toJson(course);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(courseJsonString);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Course ID");
        }
    }

    /**
     * Handles POST requests to update course information from the modal.
     */
  @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        request.setCharacterEncoding("UTF-8");

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String title = request.getParameter("title");
       BigDecimal price = new BigDecimal(request.getParameter("price"));

        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String status = request.getParameter("status");
        String rejectionReason = request.getParameter("adminFeedback");

        if (!"Rejected".equalsIgnoreCase(status)) {
            rejectionReason = null;
        }

        Course course = new Course();
        course.setCourseID(courseId);
        course.setTitle(title);
        course.setPrice(price);
        course.setCategoryID(categoryId);
        course.setStatus(status);
        course.setRejectionReason(rejectionReason);

        CourseDAO dao = new CourseDAO();
        dao.updateCourseByAdmin(course);

        request.getSession().setAttribute("updateMessage", "Course updated successfully!");
    } catch (Exception e) {
        e.printStackTrace();
        request.getSession().setAttribute("updateMessage", "Error: Could not update course.");
    }

    // ✅ Quay lại servlet /admin/courses để load lại danh sách
    response.sendRedirect(request.getContextPath() + "/admin/courses");
}

}