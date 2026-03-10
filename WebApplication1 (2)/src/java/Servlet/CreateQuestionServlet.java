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
import java.util.List;

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
        String optA = request.getParameter("q1-optA");
        String optB = request.getParameter("q1-optB");
        String optC = request.getParameter("q1-optC");
        String optD = request.getParameter("q1-optD");
        String correct = request.getParameter("q1-correct");
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
        if (optA != null && !optA.isEmpty()) options.add(new AnswerOption(optA, "A".equals(correct)));
        if (optB != null && !optB.isEmpty()) options.add(new AnswerOption(optB, "B".equals(correct)));
        if (optC != null && !optC.isEmpty()) options.add(new AnswerOption(optC, "C".equals(correct)));
        if (optD != null && !optD.isEmpty()) options.add(new AnswerOption(optD, "D".equals(correct)));

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