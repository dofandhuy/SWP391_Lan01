package Servlet;

import Entity.Course;
import Entity.Lesson;
import Entity.LessonVideo;
import Entity.LessonDocument;
import Entity.Module;
import Entity.Quiz;
import Entity.Question;
import Service.CourseService;
import Service.LessonService;
import Service.ModuleService;
import Service.QuizService;
import Service.QuestionService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/instructor/lessonDetail")
public class LessonDetailServlet extends HttpServlet {

    private LessonService lessonService;
    private ModuleService moduleService;
    private QuizService quizService;
    private CourseService courseService;
    private QuestionService questionService;

    @Override
    public void init() throws ServletException {
        lessonService = new LessonService();
        moduleService = new ModuleService();
        quizService = new QuizService();
        courseService = new CourseService();
        questionService = new QuestionService(); // ✅ thêm service lấy câu hỏi
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String lessonIdParam = request.getParameter("lessonId");
        if (lessonIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lesson ID is missing");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdParam);

            // ✅ Lấy thông tin bài học
            Lesson lesson = lessonService.getLessonById(lessonId);
            if (lesson == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Lesson not found");
                return;
            }

            int moduleId = lesson.getModuleID();

            // ✅ Lấy module, danh sách lesson trong module (sidebar)
            Module module = moduleService.getModuleById(moduleId);
            List<Lesson> moduleLessons = lessonService.getLessonsByModuleId(moduleId);

            // ✅ Lấy video & document của lesson
            List<LessonVideo> videos = lessonService.getLessonVideos(lessonId);
            List<LessonDocument> documents = lessonService.getLessonDocuments(lessonId);

            // ✅ Lấy quiz gán cho module (không còn lấy quiz riêng cho lesson)
            Quiz quiz = quizService.getQuizByModuleId(moduleId);

            // ✅ Lấy toàn bộ câu hỏi trong quiz (nếu có)
            List<Question> questions = null;
            if (quiz != null) {
                questions = questionService.getQuestionsByQuizId(quiz.getQuizID());
            }

            // ✅ Lấy thông tin khóa học (nếu cần dùng ở giao diện)
            int courseId = moduleService.getCourseId(moduleId);
            Course course = courseService.getCourseById(courseId);

            // ✅ Gửi dữ liệu sang JSP
            request.setAttribute("lesson", lesson);
            request.setAttribute("module", module);
            request.setAttribute("moduleLessons", moduleLessons);
            request.setAttribute("videos", videos);
            request.setAttribute("documents", documents);
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("course", course);

            // ✅ Chuyển hướng đến trang JSP
            RequestDispatcher rd = request.getRequestDispatcher("/instructor/lessonDetail.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lesson ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading lesson detail");
        }
    }
}
