package Servlet;

import Entity.Lesson;
import Entity.Module;
import Service.LessonService;
import Service.ModuleService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/instructor/EditLessonServlet")
public class EditLessonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        LessonService lessonService = new LessonService();
        ModuleService moduleService = new ModuleService();

        Lesson lesson = lessonService.getLessonById(lessonId);
        Module module = moduleService.getModuleById(lesson.getModuleID());
        int courseId = (module != null) ? module.getCourseId() : 0;

        request.setAttribute("lesson", lesson);
        request.setAttribute("courseId", courseId);
        request.getRequestDispatcher("/instructor/editLesson.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String lessonType = request.getParameter("lessonType");

            LessonService lessonService = new LessonService();
            Lesson existingLesson = lessonService.getLessonById(lessonId);

            existingLesson.setTitle(title);
            existingLesson.setContent(content);
            existingLesson.setLessonType(lessonType);

            lessonService.updateLesson(existingLesson);

            ModuleService moduleService = new ModuleService();
            Module module = moduleService.getModuleById(existingLesson.getModuleID());
            int courseId = (module != null) ? module.getCourseId() : 0;

            response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating lesson: " + e.getMessage());
        }
    }
}
