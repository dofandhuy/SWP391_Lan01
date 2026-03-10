package Servlet;

import Entity.Question;
import Service.QuestionService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class QuestionSearchServlet extends HttpServlet {

    private QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        if (keyword == null) keyword = "";
        if (category == null) category = "";

        // Gọi service để lấy danh sách câu hỏi (tìm kiếm + sort theo category)
        List<Question> questions = questionService.searchAndSortQuestions(keyword.trim(), category.trim());

        // Lấy danh sách tất cả category để hiển thị trong dropdown
        Set<String> categories = new TreeSet<>();
        List<Question> allQuestions = questionService.getAllQuestions();
        for (Question q : allQuestions) {
            if (q.getCategoryName() != null && !q.getCategoryName().isEmpty()) {
                categories.add(q.getCategoryName());
            }
        }

        // Gửi dữ liệu về JSP
        request.setAttribute("questions", questions);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("questionBank.jsp").forward(request, response);
    }
}
