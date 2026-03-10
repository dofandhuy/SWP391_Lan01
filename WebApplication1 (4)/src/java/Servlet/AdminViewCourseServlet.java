package Servlet;

import Dao.CourseDAO;
import Entity.Category;
import Entity.Course;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminCourseServlet", urlPatterns = {"/admin/courses"})
public class AdminViewCourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status") == null ? "" : request.getParameter("status");
        String instructorName = request.getParameter("instructorName") == null ? "" : request.getParameter("instructorName");
        String courseName = request.getParameter("courseName") == null ? "" : request.getParameter("courseName");
        String priceSort = request.getParameter("priceSort") == null ? "" : request.getParameter("priceSort");
        int categoryId = 0;

        try {
            String catParam = request.getParameter("categoryId");
            if (catParam != null && !catParam.trim().isEmpty()) {
                categoryId = Integer.parseInt(catParam);
            }
        } catch (NumberFormatException e) {
            categoryId = 0;
        }

        List<Course> courseList = courseDAO.getCoursesForAdmin(status, categoryId, instructorName, courseName, priceSort);
        List<Category> categoryList = courseDAO.getAllCategories();

        request.setAttribute("courseList", courseList);
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/courseDashboard.jsp").forward(request, response);
    }
}

