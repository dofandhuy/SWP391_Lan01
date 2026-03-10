package Servlet;



import static Context.DBContext.getConnection;

import Entity.Quiz;

import Entity.Question;

import Entity.User;

import Service.QuizService;

import Service.QuestionService;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.*;

import java.io.IOException;

import java.sql.Connection;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.util.List;



public class CreateQuizServlet extends HttpServlet {



    private final QuizService quizService = new QuizService();

    private final QuestionService questionService = new QuestionService();



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

            // Lấy giá trị từ form

            String title = request.getParameter("title");

            int numQuestions = parseIntSafe(request.getParameter("numQuestions"));

            boolean isRandom = request.getParameter("random") != null;

            int duration = parseIntSafe(request.getParameter("duration"));

            double passing = parseDoubleSafe(request.getParameter("passingScore"));



            int maxAttempts = parseIntSafe(request.getParameter("maxAttempt"));

            int cooldownHours = parseIntSafe(request.getParameter("cooldownHours"));

            String[] selectedQuestions = request.getParameterValues("selectedQuestions");

            int easy = parseIntSafe(request.getParameter("easy"));

            int medium = parseIntSafe(request.getParameter("medium"));

            int hard = parseIntSafe(request.getParameter("hard"));

            String categoryName = request.getParameter("category");



            // Gán lại các giá trị để JSP giữ nguyên khi lỗi

            request.setAttribute("title", title);

            request.setAttribute("numQuestions", numQuestions);

            request.setAttribute("duration", duration);

            request.setAttribute("passingScore", passing);



            request.setAttribute("maxAttempt", maxAttempts);

            request.setAttribute("cooldownHours", cooldownHours);

            request.setAttribute("selectedQuestions", selectedQuestions);

            request.setAttribute("easy", easy);

            request.setAttribute("medium", medium);

            request.setAttribute("hard", hard);

            request.setAttribute("category", categoryName);

            request.setAttribute("randomChecked", isRandom);

            String action = request.getParameter("action");

            String status = "Draft"; // mặc định

            if ("save".equalsIgnoreCase(action)) {

                status = "Pending";

            }
if (passing < 0 || passing > 10) {

                request.setAttribute("error", "passingRange");

                request.getRequestDispatcher("createQuiz.jsp").forward(request, response);

                return;

            }



            // Xác định CategoryID

            Integer categoryId = null;

            if (categoryName != null && !categoryName.isBlank()) {

                String sql = "SELECT CategoryID FROM Category WHERE CategoryName=?";

                try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

                    ps.setString(1, categoryName);

                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {

                        categoryId = rs.getInt("CategoryID");

                    }

                }

            }



            Quiz quiz = new Quiz();

            quiz.setTitle(title);

            quiz.setNumQuestions(numQuestions);

            quiz.setRandom(isRandom);

            quiz.setDurationMinutes(duration);

            quiz.setPassingScore(passing);



            quiz.setCreatedBy(currentUser.getUserID());

            quiz.setMaxAttempts(maxAttempts);

            quiz.setAttemptCooldownHours(cooldownHours);

            quiz.setCategoryID(categoryId);

            quiz.setStatus(status);

            // Validate số câu random theo category

            if (isRandom) {

                List<Question> allQuestions = questionService.getAllQuestions();

                int countEasy = 0, countMedium = 0, countHard = 0;

                for (Question q : allQuestions) {

                    if (categoryName != null && !categoryName.isBlank()

                            && !categoryName.equals(q.getCategoryName())) {

                        continue;

                    }

                    switch (q.getDifficultyLevel().toLowerCase()) {

                        case "easy":

                            countEasy++;

                            break;

                        case "medium":

                            countMedium++;

                            break;

                        case "hard":

                            countHard++;

                            break;

                    }

                }

                if (easy > countEasy || medium > countMedium || hard > countHard) {

                    request.setAttribute("error", "notEnoughQuestions");

                    request.getRequestDispatcher("createQuiz.jsp").forward(request, response);

                    return;

                }

            } else {

                if (easy > 0 || medium > 0 || hard > 0) {

                    request.setAttribute("error", "randomNotChecked");

                    request.getRequestDispatcher("createQuiz.jsp").forward(request, response);

                    return;

                }

            }



            // Validate tổng số câu
int totalRandom = isRandom ? (easy + medium + hard) : 0;

            int totalSelected = (selectedQuestions != null) ? selectedQuestions.length : 0;

            if (numQuestions != totalRandom + totalSelected) {

                request.setAttribute("error", "mismatch");

                request.getRequestDispatcher("createQuiz.jsp").forward(request, response);

                return;

            }



            // Tạo quiz

            int quizID = quizService.createQuiz(quiz, selectedQuestions, easy, medium, hard, categoryName);

            if (quizID > 0) {

                response.sendRedirect("createQuiz.jsp?success=true");

            } else {

                request.setAttribute("error", "true");

                request.getRequestDispatcher("createQuiz.jsp").forward(request, response);

            }



        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("error", "exception");

            request.getRequestDispatcher("createQuiz.jsp").forward(request, response);

        }

    }



    private int parseIntSafe(String s) {

        try {

            return Integer.parseInt(s);

        } catch (Exception e) {

            return 0;

        }

    }



    private double parseDoubleSafe(String s) {

        try {

            return Double.parseDouble(s);

        } catch (Exception e) {

            return 0;

        }

    }

}