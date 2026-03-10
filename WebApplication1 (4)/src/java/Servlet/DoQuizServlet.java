/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Dao.QuizAttemptDAO;
import Dao.QuizDAO;
import Entity.AnswerOption;
import Entity.Question;
import Entity.QuizAttemptData;
import Entity.QuizDetailsDTO;
import Entity.User;
import Service.QuizService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author doanh
 */
public class DoQuizServlet extends HttpServlet {

    private QuizService quizService;
    private QuizDAO quizDAO;
    private QuizAttemptDAO attemptDAO;

    @Override
    public void init() {
        this.quizService = new QuizService();
        this.quizDAO = new QuizDAO();
        this.attemptDAO = new QuizAttemptDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            // --- BƯỚC 1: XÁC THỰC VÀ LẤY INPUT ---
            HttpSession session = request.getSession();

            User currentUser = (User) session.getAttribute("user");
            if (!currentUser.getRole().getRoleName().equals("Student")) {
                response.sendRedirect("signin");
                return;
            }

            String quizIdStr = request.getParameter("quizId");
            int quizId = Integer.parseInt(quizIdStr);

            // --- BƯỚC 2: KIỂM TRA BẢO MẬT (RẤT QUAN TRỌNG) ---
            // Gọi lại logic của Giai đoạn 1 để kiểm tra (chống gian lận)
            QuizDetailsDTO details = quizService.getQuizDetailsForStudent(quizId, currentUser.getUserID());

            if (details == null || !details.isCanStart()) {
                // Nếu không được phép (hết lượt, quá hạn, ...)
                // Chuyển hướng NGƯỢC LẠI trang chi tiết
                response.sendRedirect("quiz-detail"); // (Hoặc /viewQuizDetails?quizId=...)
                return;
            }

            // --- BƯỚC 3: TẠO LƯỢT LÀM BÀI MỚI (ATTEMPT) ---
            int newAttemptId = attemptDAO.createAttempt(currentUser.getUserID(), quizId);

            if (newAttemptId == -1) {
                request.setAttribute("errorMessage", "Could not create a new quiz attempt.");
                request.getRequestDispatcher("errorPage.jsp").forward(request, response);
                return;
            }

            // --- BƯỚC 4: TẢI BỘ CÂU HỎI VÀ LỰA CHỌN (AN TOÀN) ---
            List<Question> questions = quizDAO.getQuestionsByQuizId(quizId);

            for (Question q : questions) {
                // Hàm này chỉ lấy ID và Text, KHÔNG lấy IsCorrect
                List<AnswerOption> options = quizDAO.getAnswerOptionsByQuestionId(q.getQuestionID());
                q.setOptions(options); // Gắn các lựa chọn vào câu hỏi
            }

            // --- BƯỚC 5: ĐÓNG GÓI DỮ LIỆU VÀ GỬI SANG JSP ---
            QuizAttemptData quizData = new QuizAttemptData();
            quizData.setAttemptId(newAttemptId); // ID của lượt làm bài
            quizData.setQuizId(quizId);
            quizData.setQuizTitle(details.getQuizTitle());
            quizData.setDurationMinutes(details.getDurationMinutes());
            // <-- ĐÃ SỬA
            quizData.setDeadline(details.getDeadline());
            quizData.setQuestions(questions); // Danh sách câu hỏi đã có options

            request.setAttribute("quizData", quizData);
            request.getRequestDispatcher("DoQuiz.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while starting the quiz.");
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        }
    }
}
