package Servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import Entity.User;
import Entity.Course;
import Entity.InstructorStats;
import Service.InstructorDashboardService;

public class InstructorDashboardServlet extends HttpServlet {
    private InstructorDashboardService dashboardService = new InstructorDashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        


        User instructor = (User) request.getSession().getAttribute("user");
       
        int instructorId = instructor.getUserID();

        InstructorStats stats = dashboardService.getStats(instructorId);
        List<Course> recentCourses = dashboardService.getRecentCourses(instructorId, 5);

        request.setAttribute("stats", stats);
        request.setAttribute("recentCourses", recentCourses);

        RequestDispatcher rd = request.getRequestDispatcher("/instructor/instructorDashboard.jsp");
        rd.forward(request, response);
    }
}
