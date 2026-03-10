package Servlet;

import Dao.QuizDAO;
import Entity.Question;
import Entity.Quiz;
import Entity.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name="AdminQuizActionServlet", urlPatterns={"/admin/quizAction"})
public class AdminQuizActionServlet extends HttpServlet {
    private final QuizDAO quizDAO = new QuizDAO();
   private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, 
                (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                        src == null ? null : context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
            )
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- Cung cấp dữ liệu JSON cho Modal ---
      response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

       String idParam = request.getParameter("id");
if (idParam != null) {
    try {
        int quizId = Integer.parseInt(idParam);
        Quiz quiz = quizDAO.getQuizDetailsById(quizId);
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
            return;
        }
        List<Question> questions = quizDAO.getQuestionsByQuizIdAD(quizId);
        Map<String,Object> data = new HashMap<>();
        data.put("quiz", quiz);
        data.put("questions", questions);
        

        response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
response.getWriter().write(gson.toJson(data));

        return;
    } catch(NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
        return;
    }
}

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("user");
        if (adminUser == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        try {
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            String status = request.getParameter("status");
            String rejectionReason = request.getParameter("rejectionReason");

            if (!"Rejected".equals(status)) {
                rejectionReason = null;
            }
            // DAO đã có phương thức updateQuizStatusByAdmin(int, String, String, int)
            quizDAO.updateQuizStatusByAdmin(quizId, status, rejectionReason, adminUser.getUserID());

            session.setAttribute("updateMessage", "Quiz ID " + quizId + " has been updated to " + status + ".");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("updateMessage", "Error updating quiz.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/quizzes");
    }

    }

