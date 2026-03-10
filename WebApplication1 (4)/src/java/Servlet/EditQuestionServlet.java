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

        // Lấy danh sách đáp án và category
        List<AnswerOption> options = questionService.getOptionsByQuestionID(questionID);
        List<String> categories = questionService.getAllCategories();

        request.setAttribute("question", question);
        request.setAttribute("options", options);
        request.setAttribute("categories", categories);
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

    int questionID = Integer.parseInt(request.getParameter("questionID"));
    String questionText = request.getParameter("questionText");
    String categoryName = request.getParameter("category");
    String difficulty = request.getParameter("difficulty");
    String status = request.getParameter("status");
    String[] answerIDs = request.getParameterValues("answerID");
    String[] answerTexts = request.getParameterValues("answerText");
   
String[] correctAnswers = request.getParameterValues("correctAnswer"); // có thể null nếu không tick gì
List<Integer> correctIds = new ArrayList<>();
if (correctAnswers != null) {
    for (String id : correctAnswers) {
        correctIds.add(Integer.parseInt(id));
    }
}
    // ✅ Lấy hoặc tạo CategoryID
    int categoryID = questionService.getOrCreateCategoryID(categoryName);

    // ✅ Xử lý danh sách đáp án
  
List<AnswerOption> options = new ArrayList<>();
if (answerIDs != null && answerTexts != null) {
    for (int i = 0; i < answerIDs.length; i++) {
        AnswerOption o = new AnswerOption();
        int ansId = Integer.parseInt(answerIDs[i]);
        o.setAnswerID(ansId);
        o.setAnswerText(answerTexts[i]);
        o.setCorrect(correctIds.contains(ansId)); // nếu id nằm trong danh sách tick thì true
        options.add(o);
    }
}
    // ✅ Tạo đối tượng Question
    Question question = new Question();
    question.setQuestionID(questionID);
    question.setQuestionText(questionText);
    question.setCategoryID(categoryID);
    question.setDifficultyLevel(difficulty);
    question.setStatus(status);

    // ✅ Cập nhật database
    questionService.updateQuestion(question, options);

    // ✅ Thông báo thành công
    request.setAttribute("message", "Updated successfully!");
    request.getRequestDispatcher("questionBank.jsp").forward(request, response);
}
}