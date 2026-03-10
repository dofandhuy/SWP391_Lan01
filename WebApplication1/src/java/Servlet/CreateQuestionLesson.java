package Servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Entity.Lesson;
import Entity.Question;
import Entity.AnswerOption;
import Entity.User;
import Dao.LessonDAO;
import Entity.Course;
import Service.CourseService;
import Service.LessonService;
import Service.ModuleService;
import Service.QuestionService;

public class CreateQuestionLesson extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ModuleService moduleService = new ModuleService();
    private CourseService courseService = new CourseService();
    private LessonService lessonService = new LessonService();
    private QuestionService questionService = new QuestionService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            int createdBy = user.getUserID();

            // Lấy lessonID
            int lessonID = Integer.parseInt(request.getParameter("lessonId"));

            // Lấy lesson để lấy moduleID
            Lesson lesson = lessonService.getLessonById(lessonID);
            if (lesson == null) {
                session.setAttribute("status", "Lesson not found!");
                response.sendRedirect("instructor/MyCourse.jsp");
                return;
            }

            int moduleId = lesson.getModuleID();
            int courseId = moduleService.getCourseId(moduleId);
            Course course = courseService.getCourseById(courseId);
            int courseCategoryId = course.getCategoryId();

            // Tạo Question
            Question question = new Question();
            question.setQuestionText(request.getParameter("questionContent"));
            question.setLessonID(lessonID);
            question.setModuleID(lesson.getModuleID());
            question.setCreatedBy(createdBy);
            question.setCategoryID(courseCategoryId);
            question.setQuestionType(request.getParameter("questionType"));
            question.setDifficultyLevel(request.getParameter("difficulty"));
            question.setStatus("Pending"); // default status

            // Lấy danh sách đáp án từ form
            List<AnswerOption> options = new ArrayList<>();
            int answerIndex = 1;
            while (true) {
                String ansText = request.getParameter("answer" + answerIndex);
                String correctParam = request.getParameter("correct" + answerIndex);
                if (ansText == null) {
                    break; // hết input
                }
                AnswerOption opt = new AnswerOption();
                opt.setAnswerText(ansText);
                opt.setCorrect(correctParam != null && correctParam.equals("on"));
                options.add(opt);
                answerIndex++;
            }

            // Lưu vào DB
            int questionID = questionService.createQuestionInLesson(question, lessonID, options);
            if (questionID > 0) {
                session.setAttribute("status", "Question created successfully!");
            } else {
                session.setAttribute("status", "Failed to create question.");
            }

            response.sendRedirect(request.getContextPath() + "/instructor/lessonDetail?lessonId=" + lessonID);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("status", "Error: " + e.getMessage());
            response.sendRedirect("instructor/MyCourse.jsp");
        }
    }
}
