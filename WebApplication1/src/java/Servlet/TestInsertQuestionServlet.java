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
import Service.LessonService;
import Service.QuestionService;


public class TestInsertQuestionServlet extends HttpServlet {
    private LessonService lessonService = new LessonService();
    private QuestionService questionService = new QuestionService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();

            // Test user giả lập
            User user = (User) session.getAttribute("user");
            if (user == null) {
                // Nếu chưa login, tạo user giả
                user = new User();
                user.setUserID(1); // userID giả
            }
            int createdBy = user.getUserID();

            int lessonID = Integer.parseInt(request.getParameter("lessonId"));
            Lesson lesson = lessonService.getLessonById(lessonID);
            if (lesson == null) {
                response.getWriter().println("Lesson not found!");
                return;
            }

            Question question = new Question();
            question.setQuestionText(request.getParameter("questionContent"));
            question.setLessonID(lessonID);
            question.setModuleID(lesson.getModuleID());
            question.setCreatedBy(createdBy);
            question.setQuestionType(request.getParameter("questionType"));
            question.setDifficultyLevel(request.getParameter("difficulty"));
            question.setStatus("Pending");

            List<AnswerOption> options = new ArrayList<>();
            int answerIndex = 1;
            while (true) {
                String ansText = request.getParameter("answer" + answerIndex);
                String correctParam = request.getParameter("correct" + answerIndex);
                if (ansText == null) break;
                AnswerOption opt = new AnswerOption();
                opt.setAnswerText(ansText);
                opt.setCorrect(correctParam != null && correctParam.equals("on"));
                options.add(opt);
                answerIndex++;
            }

            int questionID = questionService.createQuestionInLesson(question, lessonID, options);
            if (questionID > 0) {
                response.getWriter().println("✅ Insert successful! QuestionID: " + questionID);
                response.getWriter().println("<h3>Answers:</h3>");
                for (AnswerOption opt : options) {
                    response.getWriter().println(opt.getAnswerText() + " | Correct: " + opt.isCorrect() + "<br>");
                }
            } else {
                response.getWriter().println("❌ Insert failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}