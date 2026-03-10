/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.Course;
import Dao.CourseDAO;
import Dao.EnrollmentDAO;
import Dao.PaymentDAO;
import Entity.Lesson;
import Entity.Question;
import Entity.User;
import Entity.Module;

import Service.CourseService;
import Service.EnrollmentService;
import Service.LessonService;
import Service.ModuleService;
import Service.PaymentService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CourseDetailServlet_1 extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CourseDetailServlet_1.class.getName());

    private CourseService courseService = new CourseService();
    private PaymentService paymentService = new PaymentService();
    private EnrollmentService enrollmentService = new EnrollmentService();
    private ModuleService moduleService = new ModuleService();
    private LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(req.getParameter("id"));
            Course course = courseService.getCourseById1(courseId);
            HttpSession session = req.getSession();

            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {

                resp.sendRedirect("Signin.jsp");

                return;

            }
            boolean enrolled = false;

            enrolled = enrollmentService.isEnrolled(currentUser.getUserID(), courseId);

            //lay thong tin module va lesson de hien thi preview
            List<Module> modules = moduleService.getModulesByCourseId(courseId);
            Map<Integer, List<Lesson>> lessonMap = new HashMap<>();

            for (Module module : modules) {
                List<Lesson> lessons = lessonService.getLessonsByModuleId(module.getId());
                lessonMap.put(module.getId(), lessons);
                System.out.println("Module: " + module.getTitle() + " có " + lessons.size() + " bài học");

            }

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

            String paymentStatus = paymentService.getPaymentStatus(currentUser.getUserID(), courseId);

            // set attribute
            req.setAttribute("moduleList", modules);
            req.setAttribute("lessonListMap", lessonMap);
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
