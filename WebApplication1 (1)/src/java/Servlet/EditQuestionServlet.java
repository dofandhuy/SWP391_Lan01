 package Servlet;

import Entity.AnswerOption;
import Entity.Question;
import Service.QuestionService;
import Entity.User;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class EditQuestionServlet extends HttpServlet {

    private QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        String qid = request.getParameter("id");
        if (qid == null || qid.isEmpty()) {
            response.sendRedirect("questionBank.jsp");
            return;
        }

        int questionID = Integer.parseInt(qid);
        Question question = questionService.getQuestionByID(questionID);
        if (question == null) {
            response.sendRedirect("questionBank.jsp");
            return;
        }

        // Lấy danh sách đáp án
        List<AnswerOption> options = questionService.getOptionsByQuestionID(questionID);

        // Set attribute và forward về JSP
        request.setAttribute("question", question);
        request.setAttribute("options", options);
        request.getRequestDispatcher("editQuestion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        int questionID = Integer.parseInt(request.getParameter("questionID"));
        String questionText = request.getParameter("questionText");
        String category = request.getParameter("category");

        // Lấy danh sách đáp án
        String[] answerIDs = request.getParameterValues("answerID");
        String[] answerTexts = request.getParameterValues("answerText");
        String correctAnswer = request.getParameter("correctAnswer");
        String difficulty = request.getParameter("difficulty");


        List<AnswerOption> options = new ArrayList<>();
        if (answerIDs != null && answerTexts != null) {
            for (int i = 0; i < answerIDs.length; i++) {
                AnswerOption o = new AnswerOption();
                o.setAnswerID(Integer.parseInt(answerIDs[i]));
                o.setAnswerText(answerTexts[i]);
                o.setCorrect(answerTexts[i].equals(correctAnswer));
                options.add(o);
            }
        }

        // Tạo Question object
        Question question = new Question();
        question.setQuestionID(questionID);
        question.setQuestionText(questionText);
        question.setCategory(category);
        question.setDifficultyLevel(difficulty); // <-- thêm dòng này
        // Cập nhật database
        questionService.updateQuestion(question, options);

        // Redirect về question bank
        response.sendRedirect("questionBank.jsp");
    }
}