package Servlet;

import Service.LessonService;
import Entity.Lesson;
import Service.ModuleService;
import Entity.Module;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/instructor/CreateLessonServlet")
public class CreateLessonServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String lessonType = request.getParameter("lessonType");

            Lesson lesson = new Lesson();
            lesson.setModuleID(moduleId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setLessonType(lessonType);

            LessonService lessonService = new LessonService();
            lessonService.createLesson(lesson);

            // Lấy courseId để redirect về đúng khóa học
            ModuleService moduleService = new ModuleService();
            Module module = moduleService.getModuleById(moduleId);
            int courseId = (module != null) ? module.getCourseId() : 0;

            response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error creating lesson: " + e.getMessage());
        }
    }
}
