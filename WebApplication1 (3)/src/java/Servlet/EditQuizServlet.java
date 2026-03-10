package Servlet;

import Entity.Question;
import Entity.Quiz;
import Service.QuestionService;
import Service.QuizService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class EditQuizServlet extends HttpServlet {
    private final QuizService quizService = new QuizService();
    private final QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing quiz ID");
                return;
            }

            int quizID = Integer.parseInt(idParam);
            Quiz quiz = quizService.getQuizById(quizID);
            if (quiz == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found!");
                return;
            }

            // 🔹 Lấy danh sách câu hỏi trong quiz
            List<Question> quizQuestions = questionService.getQuestionsByQuizId(quizID);

            // 🔹 Lấy toàn bộ question bank và lọc cùng category
            List<Question> questionBank = questionService.getAllQuestions();
            questionBank.removeAll(quizQuestions);
            int quizCategoryID = quiz.getCategoryID() != null ? quiz.getCategoryID() : -1;
            questionBank.removeIf(q -> q.getCategoryID() != quizCategoryID);

            // 🔹 Gửi dữ liệu sang JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("quizQuestions", quizQuestions);
            request.setAttribute("questionBank", questionBank);
            request.getRequestDispatcher("editQuiz.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quiz ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String quizIDParam = request.getParameter("quizID");
            if (quizIDParam == null || quizIDParam.isEmpty()) {
                request.setAttribute("errorMessage", "Quiz ID is missing");
                request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
                return;
            }

            int quizID = Integer.parseInt(quizIDParam);
            Quiz oldQuiz = quizService.getQuizById(quizID);
            if (oldQuiz == null) {
                request.setAttribute("errorMessage", "Quiz not found!");
                request.getRequestDispatcher("QuizListServlet").forward(request, response);
                return;
            }

            // 🔹 Lấy dữ liệu từ form
            String title = request.getParameter("title");
            Integer duration = parseIntOrNull(request.getParameter("duration"));
            Double passingScore = parseDoubleOrNull(request.getParameter("passingScore"));
            Double pointPerQuestion = parseDoubleOrNull(request.getParameter("pointPerQuestion"));
            String status = request.getParameter("status");
            boolean isRandom = request.getParameter("isRandom") != null;
            Integer maxAttempts = parseIntOrNull(request.getParameter("maxAttempts"));
Integer attemptCooldown = parseIntOrNull(request.getParameter("attemptCooldown"));
            // 🔹 Tạo đối tượng quiz mới
            Quiz quiz = new Quiz();
            quiz.setQuizID(quizID);
            quiz.setTitle(title);
            quiz.setDurationMinutes(duration);
            quiz.setPassingScore(passingScore);
            quiz.setPointPerQuestion(pointPerQuestion);
            quiz.setStatus(status);
            quiz.setRandom(isRandom);
            quiz.setCategoryID(oldQuiz.getCategoryID()); // giữ nguyên categoryID
quiz.setMaxAttempts(maxAttempts);
quiz.setAttemptCooldownHours(attemptCooldown);
            // 🔹 Danh sách câu hỏi cần xóa
            List<Integer> toDelete = parseIntList(request.getParameterValues("questionsToDelete"));

            // 🔹 Danh sách câu hỏi cần thêm
            List<Integer> toAdd = parseIntList(request.getParameterValues("questionsToAdd"));

            // 🔹 Cập nhật quiz (bao gồm cập nhật NumQuestions bên trong)
            boolean updated = quizService.updateQuiz(quiz, toDelete, toAdd);

            if (updated) {
                response.sendRedirect("QuizListServlet?success=updated");
            } else {
                reloadEditPage(request, response, quizID, quiz, "Cập nhật quiz thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật quiz: " + e.getMessage());
            request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
        }
    }

    // 🔹 Helper: chuyển chuỗi sang Integer hoặc null
    private Integer parseIntOrNull(String val) {
        try {
            return (val == null || val.isEmpty()) ? null : Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // 🔹 Helper: chuyển chuỗi sang Double hoặc null
    private Double parseDoubleOrNull(String val) {
        try {
            return (val == null || val.isEmpty()) ? null : Double.parseDouble(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // 🔹 Helper: chuyển mảng String sang List<Integer>
    private List<Integer> parseIntList(String[] arr) {
        List<Integer> list = new ArrayList<>();
        if (arr != null) {
            for (String s : arr) {
                try {
                    list.add(Integer.parseInt(s));
                } catch (NumberFormatException ignored) {}
            }
        }
        return list;
    }

    // 🔹 Helper: load lại trang edit nếu cập nhật thất bại
    private void reloadEditPage(HttpServletRequest request, HttpServletResponse response, int quizID, Quiz quiz, String error)
            throws ServletException, IOException {
        List<Question> quizQuestions = questionService.getQuestionsByQuizId(quizID);
        List<Question> questionBank = questionService.getAllQuestions();
        questionBank.removeAll(quizQuestions);

        request.setAttribute("quiz", quiz);
        request.setAttribute("quizQuestions", quizQuestions);
        request.setAttribute("questionBank", questionBank);
        request.setAttribute("errorMessage", error);
        request.getRequestDispatcher("editQuiz.jsp").forward(request, response);
    }
}
