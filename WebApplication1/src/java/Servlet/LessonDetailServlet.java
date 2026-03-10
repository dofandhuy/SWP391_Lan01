package Servlet;

import Entity.Course;
import Entity.Lesson;
import Entity.LessonVideo;
import Entity.LessonDocument;
import Entity.Quiz;
import Entity.Module;
import Entity.Question;
import Service.CourseService;
import Service.LessonService;
import Service.ModuleService;
import Service.QuestionService;
import Service.QuizService;

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
    private QuestionService questionService = new QuestionService();

    @Override
    public void init() throws ServletException {
        lessonService = new LessonService();
        moduleService = new ModuleService();
        quizService = new QuizService();
        courseService = new CourseService(); // ✅ thêm dòng này
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

            // Lấy thông tin bài học
            Lesson lesson = lessonService.getLessonById(lessonId);
            if (lesson == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Lesson not found");
                return;
            }

            int moduleId = lesson.getModuleID();

            // Lấy danh sách lesson trong module (sidebar)
            List<Lesson> moduleLessons = lessonService.getLessonsByModuleId(moduleId);
            Module module = moduleService.getModuleById(moduleId);

            // Lấy video, document, quiz liên quan
            List<LessonVideo> videos = lessonService.getLessonVideos(lessonId);
            List<LessonDocument> documents = lessonService.getLessonDocuments(lessonId);
            Quiz quiz = lessonService.getLessonQuiz(lessonId);
            System.out.println("📘 Lesson quiz: " + (quiz != null ? quiz.getTitle() + " (ID: " + quiz.getQuizID() + ")" : "null"));

//            // Lấy tất cả quiz khả dụng (vì quiz dùng chung)
//            List<Quiz> availableQuizzes = quizService.getAllQuizzes();
            int courseId = moduleService.getCourseId(moduleId);
            Course course = courseService.getCourseById(courseId);
            int courseCategoryId = course.getCategoryId();

            // Set dữ liệu lên JSP
            request.setAttribute("lesson", lesson);
            request.setAttribute("videos", videos);
            request.setAttribute("documents", documents);
            request.setAttribute("quiz", quiz);
            request.setAttribute("module", module);
            request.setAttribute("moduleLessons", moduleLessons);
            List<Question> questions = questionService.getQuestionsByLessonID(lessonId);
            for (Question q : questions) {
                q.setOptions(questionService.getOptionsByQuestionID(q.getQuestionID()));
            }
            request.setAttribute("questions", questions);

//            request.setAttribute("availableQuizzes", availableQuizzes);
            List<Quiz> availableQuizzes = quizService.getQuizzesByCategory(courseCategoryId);
            request.setAttribute("availableQuizzes", availableQuizzes);

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
