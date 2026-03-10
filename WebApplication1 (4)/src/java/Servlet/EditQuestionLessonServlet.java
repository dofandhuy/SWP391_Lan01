package Servlet;

import Entity.AnswerOption;
import Entity.Lesson;
import Entity.Question;
import Entity.User;
import Service.LessonService;
import Service.ModuleService;
import Service.CourseService;
import Service.QuestionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class EditQuestionLessonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private QuestionService questionService = new QuestionService();
    private LessonService lessonService = new LessonService();
    private ModuleService moduleService = new ModuleService();
    private CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        String qid = request.getParameter("id");
        String lessonIdParam = request.getParameter("lessonId");
        if (qid == null || qid.isEmpty() || lessonIdParam == null || lessonIdParam.isEmpty()) {
            response.sendRedirect("questionBank.jsp");
            return;
        }

        int questionID = Integer.parseInt(qid);
        int lessonID = Integer.parseInt(lessonIdParam);

        Question question = questionService.getQuestionByID(questionID);
        if (question == null) {
            response.sendRedirect("questionBank.jsp");
            return;
        }

        // Lấy options và categories
        List<AnswerOption> options = questionService.getOptionsByQuestionID(questionID);
        List<String> categories = questionService.getAllCategories();

        // Truyền dữ liệu sang JSP
        request.setAttribute("question", question);
        request.setAttribute("options", options);
        request.setAttribute("categories", categories);
        request.setAttribute("lessonID", lessonID);

        request.getRequestDispatcher("editQuestionLesson.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        try {
            int lessonID = Integer.parseInt(request.getParameter("lessonId"));
            Lesson lesson = lessonService.getLessonById(lessonID);
            if (lesson == null) {
                session.setAttribute("status", "Lesson not found!");
                response.sendRedirect("instructor/MyCourse.jsp");
                return;
            }

           int questionID = Integer.parseInt(request.getParameter("questionID"));
String questionText = request.getParameter("questionText");
String difficulty = request.getParameter("difficulty");
String status = request.getParameter("status");
String categoryName = request.getParameter("category");
String[] answerIDs = request.getParameterValues("answerID");
String[] answerTexts = request.getParameterValues("answerText");
String[] correctAnswers = request.getParameterValues("correctAnswer");

// Lấy danh sách answer đúng
List<Integer> correctIds = new ArrayList<>();
if (correctAnswers != null) {
    for (String id : correctAnswers) correctIds.add(Integer.parseInt(id));
}

// Lấy hoặc tạo CategoryID
int categoryID = questionService.getOrCreateCategoryID(categoryName);

// Tạo danh sách AnswerOption
List<AnswerOption> options = new ArrayList<>();
if (answerIDs != null && answerTexts != null) {
    for (int i = 0; i < answerIDs.length; i++) {
        AnswerOption o = new AnswerOption();
        int ansId = Integer.parseInt(answerIDs[i]);
        o.setAnswerID(ansId);
        o.setAnswerText(answerTexts[i]);
        o.setCorrect(correctIds.contains(ansId));
        options.add(o);
    }
}

// Tạo object Question
Question question = new Question();
question.setQuestionID(questionID);
question.setQuestionText(questionText);
question.setDifficultyLevel(difficulty);
question.setCategoryID(categoryID);
question.setStatus(status);

// Update database
questionService.updateQuestion(question, options);

// Redirect về LessonDetail
response.sendRedirect(request.getContextPath() + "/LessonDetailServlet?lessonId=" + lessonID);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("status", "Update question failed: " + e.getMessage());
            response.sendRedirect("questionBank.jsp");
        }
    }
}
