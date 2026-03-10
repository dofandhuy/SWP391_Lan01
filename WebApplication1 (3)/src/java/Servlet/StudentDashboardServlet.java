/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.Course;
import Dao.CourseDAO;
import Entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Admin
 */
public class StudentDashboardServlet extends HttpServlet {

    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();

        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {

            resp.sendRedirect("Signin.jsp");

            return;

        }

       int userId=  currentUser.getUserID();

        try {
            List<Course> continueLearning = courseDAO.getContinueLearning(userId);
            List<Course> recentlyViewed = courseDAO.getRecentlyViewed(userId, 6);
            List<Course> mostPopular = courseDAO.getPopularCourses(8);
            List<Course> recommendedCourses = courseDAO.getRecommendCourse(userId);

            req.setAttribute("continueLearning", continueLearning);
            req.setAttribute("recentlyViewed", recentlyViewed);
            req.setAttribute("mostPopular", mostPopular);
            req.setAttribute("recommendedCourses", recommendedCourses);

            // forward sang JSP (bạn đang dùng file JSP ở trên: có thể đổi tên sang dashboard.jsp)
            req.getRequestDispatcher("/student_dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

}
