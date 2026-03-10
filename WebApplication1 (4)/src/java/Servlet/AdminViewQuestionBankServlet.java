package Servlet;

import Dao.QuestionDAO;
import Dao.QuizDAO;
import Entity.Category;
import Entity.Question;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

// URL MỚI: Xử lý riêng cho trang kho câu hỏi
@WebServlet(name = "AdminViewQuestionBankServlet", urlPatterns = {"/admin/question-bank"})
public class AdminViewQuestionBankServlet extends HttpServlet {
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final QuizDAO quizDAO = new QuizDAO();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       // --- PHẦN LOGIC TẢI DỮ LIỆU CHO questionBank.jsp ---
String searchText = request.getParameter("searchText") == null ? "" : request.getParameter("searchText");
int categoryId = request.getParameter("categoryId") == null ? 0 : Integer.parseInt(request.getParameter("categoryId"));
String createdBy = request.getParameter("createdBy") == null ? "" : request.getParameter("createdBy");
String type = request.getParameter("type") == null ? "" : request.getParameter("type");
int page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));

// ✅ Chỉ lấy câu hỏi Approved
String status = "Approved";  

List<Question> questionList = questionDAO.getQuestionsForAdmin(searchText, categoryId, createdBy, type, status, page, PAGE_SIZE);
int totalQuestions = questionDAO.countQuestionsForAdmin(searchText, categoryId, createdBy, type, status);
int totalPages = (int) Math.ceil((double) totalQuestions / PAGE_SIZE);
List<Category> categoryList = quizDAO.getAllCategoriesByAdmin();

request.setAttribute("questionList", questionList);
request.setAttribute("categoryList", categoryList);
request.setAttribute("totalPages", totalPages);
request.setAttribute("currentPage", page);
request.setAttribute("searchText", searchText);
request.setAttribute("selectedCategoryId", categoryId);
request.setAttribute("createdBy", createdBy);
request.setAttribute("selectedType", type);

request.getRequestDispatcher("/adminQuestionBank.jsp").forward(request, response);
    }
}