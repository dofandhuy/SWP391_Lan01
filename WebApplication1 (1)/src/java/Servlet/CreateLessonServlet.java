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
@MultipartConfig // Cho phép upload file video
public class CreateLessonServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String lessonType = request.getParameter("lessonType");
        Part filePart = request.getPart("file");

        String videoUrl = null;

        // === Upload video nếu có ===
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads";

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            filePart.write(uploadDir + File.separator + fileName);
            videoUrl = "uploads/" + fileName;
        }

        Lesson lesson = new Lesson();
        lesson.setModuleID(moduleId);
        lesson.setTitle(title);
        lesson.setContent(content);
        lesson.setLessonType(lessonType);
        lesson.setVideoUrl(videoUrl);

        LessonService lessonService = new LessonService();
        ModuleService moduleService = new ModuleService();

        try {
            // ✅ Thêm bài học
            lessonService.createLesson(lesson);

            // ✅ Lấy courseId của module vừa thêm bài
            Module module = moduleService.getModuleById(moduleId);
            int courseId = (module != null) ? module.getCourseId() : 0;

            // ✅ Redirect đúng về trang chi tiết khóa học
            response.sendRedirect(request.getContextPath() + "/CourseDetailServlet?courseId=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error creating lesson: " + e.getMessage());
        }
    }
}
