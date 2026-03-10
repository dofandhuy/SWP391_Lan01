package Servlet;

import Dao.QuestionDAO;
import Entity.Question;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "AdminQuestionDetailServlet", urlPatterns = {"/admin/questionDetail"})
public class AdminQuestionDetailServlet extends HttpServlet {
    private final QuestionDAO questionDAO = new QuestionDAO();
     // ✅ Gson có TypeAdapter để xử lý LocalDateTime
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, 
                (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                        src == null ? null : context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
            )
            .create();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String questionIdParam = request.getParameter("id");

        // SỬA ĐỔI: Thêm kiểm tra để đảm bảo ID không bị rỗng hoặc null
        if (questionIdParam == null || questionIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or empty 'id' parameter.");
            return;
        }

        try {
            int questionId = Integer.parseInt(questionIdParam);
            Question question = questionDAO.getQuestionWithAnswersById(questionId);

            if (question == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Question not found for ID: " + questionId);
                return;
            }

            String questionJsonString = this.gson.toJson(question);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(questionJsonString);

        } catch (NumberFormatException e) {
            // Lỗi này xảy ra nếu id không phải là một số (ví dụ: id=abc)
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid 'id' parameter format. Must be a number.");
        }
    }
}