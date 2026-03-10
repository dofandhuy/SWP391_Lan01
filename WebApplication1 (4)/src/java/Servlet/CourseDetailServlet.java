package Servlet;

import Entity.Course;
import Entity.Module;
import Entity.Lesson;
import Entity.Quiz;
import Service.CourseService;
import Service.ModuleService;
import Service.LessonService;
import Service.QuizService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class CourseDetailServlet extends HttpServlet {

    private CourseService courseService = new CourseService();
    private ModuleService moduleService = new ModuleService();
    private LessonService lessonService = new LessonService();
    private QuizService quizService = new QuizService();

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
        if (course == null) {
            response.sendRedirect("myCourse.jsp");
            return;
        }
        
        
        

        String courseStatus = (course.getStatus() != null) ? course.getStatus() : "Draft"; // default
        request.setAttribute("courseStatus", courseStatus);

        List<Module> modules = moduleService.getModulesByCourseId(courseId);

        Map<Integer, List<Lesson>> lessonsByModule = new HashMap<>();
        for (Module m : modules) {
            try {
                lessonsByModule.put(m.getId(), lessonService.getLessonsByModuleId(m.getId()));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
         int courseCategoryId = course.getCategoryId();
         List<Quiz> availableQuizzes = quizService.getQuizzesByCategory(courseCategoryId);
        

        request.setAttribute("course", course);
        request.setAttribute("modules", modules);
        request.setAttribute("lessonsByModule", lessonsByModule);
        request.setAttribute("availableQuizzes", availableQuizzes);
        request.getRequestDispatcher("/instructor/CourseDetail.jsp").forward(request, response);
    }
}
