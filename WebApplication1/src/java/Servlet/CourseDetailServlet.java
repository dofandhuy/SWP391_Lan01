package Servlet;

import Entity.Course;
import Entity.Module;
import Entity.Lesson;
import Service.CourseService;
import Service.ModuleService;
import Service.LessonService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class CourseDetailServlet extends HttpServlet {

    private CourseService courseService = new CourseService();
    private ModuleService moduleService = new ModuleService();
    private LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null) {
            response.sendRedirect("myCourse.jsp");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);
        Course course = courseService.getCourseById(courseId);
        List<Module> modules = moduleService.getModulesByCourseId(courseId);

        Map<Integer, List<Lesson>> lessonsByModule = new HashMap<>();
        for (Module m : modules) {
            try {
                lessonsByModule.put(m.getId(), lessonService.getLessonsByModuleId(m.getId()));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("course", course);
        request.setAttribute("modules", modules);
        request.setAttribute("lessonsByModule", lessonsByModule);
        request.getRequestDispatcher("/instructor/CourseDetail.jsp").forward(request, response);
    }
}
