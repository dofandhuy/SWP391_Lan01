package Servlet;
import static Context.DBContext.getConnection;
import Entity.Quiz;
import Entity.User;
import Service.QuizService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CreateQuizServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        try {
            String title = request.getParameter("title");
            int numQuestions = parseIntSafe(request.getParameter("numQuestions"));
            boolean isRandom = request.getParameter("random") != null;
            int duration = parseIntSafe(request.getParameter("duration"));
            double passing = parseDoubleSafe(request.getParameter("passingScore"));
            double point = parseDoubleSafe(request.getParameter("pointPerQuestion"));
            int maxAttempts = parseIntSafe(request.getParameter("maxAttempt"));
            int cooldownHours = parseIntSafe(request.getParameter("cooldownHours"));

            Quiz quiz = new Quiz();
            quiz.setTitle(title);
            quiz.setNumQuestions(numQuestions);
            quiz.setRandom(isRandom);
            quiz.setDurationMinutes(duration);
            quiz.setPassingScore(passing);
            quiz.setPointPerQuestion(point);
            quiz.setCreatedBy(currentUser.getUserID());
            quiz.setMaxAttempts(maxAttempts);
            quiz.setAttemptCooldownHours(cooldownHours);

            String[] selectedQuestions = request.getParameterValues("selectedQuestions");
            int easy = parseIntSafe(request.getParameter("easy"));
            int medium = parseIntSafe(request.getParameter("medium"));
            int hard = parseIntSafe(request.getParameter("hard"));
            String categoryName = request.getParameter("category");
Integer categoryId = null;
if (categoryName != null && !categoryName.isBlank()) {
    String sql = "SELECT CategoryID FROM Category WHERE CategoryName=?";
    try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            ResultSet rs = ps.executeQuery();
        if (rs.next()) categoryId = rs.getInt("CategoryID");
    }
}
quiz.setCategoryID(categoryId);
            // Validate tổng số câu
            int totalRandom = easy + medium + hard;
            int totalSelected = (selectedQuestions != null) ? selectedQuestions.length : 0;
            if (numQuestions != totalRandom + totalSelected) {
                response.sendRedirect("createQuiz.jsp?error=mismatch");
                return;
            }

            int quizID = quizService.createQuiz(quiz, selectedQuestions, easy, medium, hard, categoryName);
            if (quizID > 0) {
                response.sendRedirect("createQuiz.jsp?success=true");
            } else {
                response.sendRedirect("createQuiz.jsp?error=true");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("createQuiz.jsp?error=exception");
        }
    }

    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }
    private double parseDoubleSafe(String s) {
        try { return Double.parseDouble(s); } catch (Exception e) { return 0; }
    }
}