package Servlet;

import Entity.Quiz;
import Entity.User;
import Service.QuizService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CreateQuizServlet extends HttpServlet {
    
    private final QuizService quizService = new QuizService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 1️⃣ Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }
        
        try {
            // 2️⃣ Lấy dữ liệu từ form
            String title = request.getParameter("title");
            int numQuestions = parseIntSafe(request.getParameter("numQuestions"));
            boolean isRandom = request.getParameter("random") != null;
            int duration = parseIntSafe(request.getParameter("duration"));
            double passing = parseDoubleSafe(request.getParameter("passingScore"));
            double point = parseDoubleSafe(request.getParameter("pointPerQuestion"));
            int maxAttempts = parseIntSafe(request.getParameter("maxAttempt"));
            int cooldownHours = parseIntSafe(request.getParameter("cooldownHours"));

            // 🟢 Lấy LessonID nếu có (nếu form không có thì set = 0)
            int lessonID = parseIntSafe(request.getParameter("lessonID"));
            
            Quiz quiz = new Quiz();
            quiz.setTitle(title);
            quiz.setNumQuestions(numQuestions);
            quiz.setRandom(isRandom);
            quiz.setDurationMinutes(duration);
            quiz.setPassingScore(passing);
            quiz.setPointPerQuestion(point);
            
            quiz.setCreatedBy(currentUser.getUserID());
            quiz.setLessonID(lessonID);
            quiz.setMaxAttempts(maxAttempts);
            quiz.setAttemptCooldownHours(cooldownHours);
            // 3️⃣ Câu hỏi chọn thủ công
            String[] selectedQuestions = request.getParameterValues("selectedQuestions");

            // 4️⃣ Random theo độ khó
            int easy = parseIntSafe(request.getParameter("easy"));
            int medium = parseIntSafe(request.getParameter("medium"));
            int hard = parseIntSafe(request.getParameter("hard"));

            // 5️⃣ Gọi service tạo quiz
            String category = request.getParameter("category"); // null = tất cả

            // 🔹 Tổng số câu được random
            int totalRandom = easy + medium + hard;

// 🔹 Tổng số câu được chọn thủ công
            int totalSelected = (selectedQuestions != null) ? selectedQuestions.length : 0;

// 🔹 Tổng thực tế
            int totalCombined = totalRandom + totalSelected;

// 🔹 Kiểm tra hợp lệ với numQuestions
            if (numQuestions != totalCombined) {
                System.out.println("❌ Tổng số câu không khớp!");
                response.sendRedirect("createQuiz.jsp?error=mismatch");
                return;
            }
            int quizID = quizService.createQuiz(quiz, selectedQuestions, easy, medium, hard, category);

            // 6️⃣ Chuyển hướng
            if (quizID > 0) {
                System.out.println("✅ Quiz created successfully with ID: " + quizID);
                response.sendRedirect("createQuiz.jsp?success=true");
            } else {
                System.out.println("❌ Quiz creation failed!");
                response.sendRedirect("createQuiz.jsp?error=true");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("createQuiz.jsp?error=exception");
        }
    }

    // 7️⃣ Hàm parse an toàn
    private int parseIntSafe(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value.trim()) : 0;
        } catch (Exception e) {
            return 0;
        }
    }
    
    private double parseDoubleSafe(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Double.parseDouble(value.trim()) : 0;
        } catch (Exception e) {
            return 0;
        }
    }
}
