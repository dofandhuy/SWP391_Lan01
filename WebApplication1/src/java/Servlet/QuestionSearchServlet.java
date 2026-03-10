//package Servlet;
//
//import Entity.Question;
//import Entity.User;
//import Service.QuestionService;
//import jakarta.servlet.ServletException;
//
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import java.util.List;
//
//
//public class QuestionSearchServlet extends HttpServlet {
//    private QuestionService questionService = new QuestionService();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            response.sendRedirect("Signin.jsp");
//            return;
//        }
//
//        User currentUser = (User) session.getAttribute("user");
//        int userID = currentUser.getUserID();
//
//    
//        String keyword = request.getParameter("keyword");
//        String sort = request.getParameter("sort");
//
//
//        if (keyword == null) keyword = "";
//        if (sort == null) sort = "id";
//
//        List<Question> questions = questionService.searchAndSortQuestions(userID, keyword.trim(), sort);
//
//        // Set attribute và forward về JSP
//        request.setAttribute("questions", questions);
//        request.setAttribute("keyword", keyword); // để JSP giữ giá trị search
//        request.setAttribute("sort", sort);       // để JSP giữ giá trị sort hiện tại
//        request.getRequestDispatcher("questionBank.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        doGet(request, response);
//    }
//}