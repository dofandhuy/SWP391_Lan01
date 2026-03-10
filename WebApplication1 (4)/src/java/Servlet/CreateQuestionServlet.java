package Servlet;

import Dao.QuestionDAO;
import Entity.User;
import Entity.Question;
import Entity.AnswerOption;
import Service.QuestionService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class CreateQuestionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách category từ QuestionBank
        QuestionService service = new QuestionService();
        List<String> categories = service.getAllCategories();
        request.setAttribute("categories", categories);
        RequestDispatcher rd = request.getRequestDispatcher("createQuestion.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int createdBy = user.getUserID();

        String text = request.getParameter("q1-text");
        String type = request.getParameter("q1-type");
        String difficulty = request.getParameter("q1-difficulty");
        String categoryName = request.getParameter("q1-category");
     String[] optionTexts = request.getParameterValues("optionText");
String[] correctIndexes = request.getParameterValues("correctOption");
        String action = request.getParameter("action");

        QuestionService service = new QuestionService();
        QuestionDAO dao = new QuestionDAO();

        int categoryID = dao.getOrCreateCategoryID(categoryName);

        Question q = new Question();
        q.setQuestionText(text);
        q.setQuestionType(type);
        q.setDifficultyLevel(difficulty);
        q.setCategoryID(categoryID);
        q.setCreatedBy(createdBy);
        q.setStatus("save".equals(action) ? "Pending" : "Draft");

        // ✅ Tạo danh sách đáp án
       List<AnswerOption> options = new ArrayList<>();
if (optionTexts != null) {
    // correctIndexes có thể null nếu không tick checkbox nào
    Set<Integer> correctSet = new HashSet<>();
    if (correctIndexes != null) {
        for (String idxStr : correctIndexes) {
            try {
                correctSet.add(Integer.parseInt(idxStr));
            } catch (NumberFormatException e) { }
        }
    }

    for (int i = 0; i < optionTexts.length; i++) {
        boolean isCorrect = correctSet.contains(i);
        options.add(new AnswerOption(optionTexts[i], isCorrect));
    }
}
        int questionId = service.createQuestion(q, options);

        if (questionId > 0) {
            request.setAttribute("message", "✅ Question created successfully!");
        } else {
            request.setAttribute("error", "❌ Failed to create question!");
        }

        // Nạp lại danh sách category để không lỗi JSP
        List<String> categories = service.getAllCategories();
        request.setAttribute("categories", categories);

        RequestDispatcher rd = request.getRequestDispatcher("createQuestion.jsp");
        rd.forward(request, response);
    }
}