package Servlet;

import Dao.QuestionDAO;
import Dao.QuizDAO;
import Entity.Category;
import Entity.Question;
import Entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// URL MỚI: Xử lý cả GET và POST cho trang dashboard
@WebServlet(name = "AdminQuestionActionServlet", urlPatterns = {"/admin/questionAction"})
public class AdminQuestionActionServlet extends HttpServlet {
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final QuizDAO quizDAO = new QuizDAO(); // Cần thiết để lấy danh sách category
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- PHẦN LOGIC TẢI DỮ LIỆU CHO questionDashboard.jsp ---
        String searchText = request.getParameter("searchText") == null ? "" : request.getParameter("searchText");
        int categoryId = request.getParameter("categoryId") == null ? 0 : Integer.parseInt(request.getParameter("categoryId"));
        String createdBy = request.getParameter("createdBy") == null ? "" : request.getParameter("createdBy");
        String type = request.getParameter("type") == null ? "" : request.getParameter("type");
        String status = request.getParameter("status"); // Mặc định là null để tải tất cả
        int page = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));

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
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher("/questionDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- PHẦN LOGIC XỬ LÝ HÀNH ĐỘNG DUYỆT/TỪ CHỐI ---
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("user");
        if (adminUser == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String status = request.getParameter("status");
            String rejectionReason = request.getParameter("rejectionReason");
            if (!"Rejected".equals(status)) {
                rejectionReason = null;
            }
            questionDAO.updateQuestionStatusByAdmin(questionId, status, rejectionReason, adminUser.getUserID());
            session.setAttribute("updateMessage", "Question ID " + questionId + " has been updated.");
        } catch (Exception e) {
            session.setAttribute("updateMessage", "Error updating question.");
            e.printStackTrace();
        }
        // Sau khi xử lý, chuyển hướng về chính nó (để tải lại dữ liệu qua doGet)
        response.sendRedirect(request.getContextPath() + "/admin/questionAction");
    }
}