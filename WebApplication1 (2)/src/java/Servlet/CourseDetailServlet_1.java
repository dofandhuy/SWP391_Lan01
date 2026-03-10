/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.Course;
import Dao.CourseDAO;
import Dao.EnrollmentDAO;
import Dao.PaymentDAO;
import Entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;

public class CourseDetailServlet_1 extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CourseDetailServlet_1.class.getName());

    private CourseDAO courseDAO = new CourseDAO();
    private EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(req.getParameter("id"));
            Course course = courseDAO.getCourseById1(courseId);
            HttpSession session = req.getSession();

            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {

                resp.sendRedirect("Signin.jsp");

                return;

            }
            boolean enrolled = false;
           
            enrolled = enrollmentDAO.isEnrolled(currentUser.getUserID(), courseId);
            

            // Recently viewed
            List<Course> recentlyViewed = (List<Course>) req.getSession().getAttribute("recentlyViewed");
            if (recentlyViewed == null) {
                recentlyViewed = new ArrayList<>();
            }

            recentlyViewed.removeIf(c -> c.getCourseID() == courseId);
            recentlyViewed.add(0, course);
            if (recentlyViewed.size() > 5) {
                recentlyViewed = recentlyViewed.subList(0, 5);
            }

            PaymentDAO paymentDAO = new PaymentDAO();
            String paymentStatus = paymentDAO.getPaymentStatus(currentUser.getUserID(), courseId);

            // set attribute
            req.setAttribute("course", course);
            req.setAttribute("enrolled", enrolled);
            req.setAttribute("paymentStatus", paymentStatus);
            req.getSession().setAttribute("recentlyViewed", recentlyViewed);
            req.setAttribute("recentlyViewed", recentlyViewed);

            // ✅ Log thông tin ra console
            logger.info("=== CourseDetailServlet_1 called ===");
            logger.info("courseId = " + courseId);
            logger.info("userId = " + currentUser.getUserID());
            logger.info("course = " + course);
            logger.info("enrolled = " + enrolled);
            logger.info("paymentStatus = " + paymentStatus);
            logger.info("recentlyViewed count = " + recentlyViewed.size());

            RequestDispatcher rd = req.getRequestDispatcher("/course_detail.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            logger.severe("Error in CourseDetailServlet_1: " + e.getMessage());
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Servlet Error: " + e.getMessage());
        }
    }
}
