package Servlet;

import Entity.User;
import Entity.Question;
import Entity.AnswerOption;
import Service.QuestionService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CreateQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        HttpSession session = request.getSession(false);
        int createdBy = 0;
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            createdBy = user.getUserID(); 
        } else {
            
            response.sendRedirect("Signin.jsp");
            return;
        }

        String text = request.getParameter("q1-text");
        String type = request.getParameter("q1-type");
        String difficulty = request.getParameter("q1-difficulty");
        String category = request.getParameter("q1-category");
        String optA = request.getParameter("q1-optA");
        String optB = request.getParameter("q1-optB");
        String optC = request.getParameter("q1-optC");
        String optD = request.getParameter("q1-optD");
        String correct = request.getParameter("q1-correct");

        QuestionService service = new QuestionService();
        boolean success = true;

       
 
         String action = request.getParameter("action"); // "save" hoặc "close"
Question q = new Question();
q.setQuestionText(text);
q.setQuestionType(type);
q.setDifficultyLevel(difficulty);
q.setCategory(category);
q.setCreatedBy(createdBy);

// set trạng thái
if ("save".equals(action)) {
    q.setStatus("Pending"); // lưu → pending
} else if ("close".equals(action)) {
    q.setStatus("Draft"); // đóng → draft
}
       
        List<AnswerOption> options = new ArrayList<>();
        if (optA != null && !optA.isBlank())
            options.add(new AnswerOption(optA, "A".equals(correct)));
        if (optB != null && !optB.isBlank())
            options.add(new AnswerOption(optB, "B".equals(correct)));
        if (optC != null && !optC.isBlank())
            options.add(new AnswerOption(optC, "C".equals(correct)));
        if (optD != null && !optD.isBlank())
            options.add(new AnswerOption(optD, "D".equals(correct)));

        int newId = service.createQuestion(q, options);
        if (newId <= 0) {
            success = false;
        }

        if (success) {
            response.sendRedirect("createQuestion.jsp?success=1");
        } else {
            response.sendRedirect("createQuestion.jsp?error=1");
        }
    }
}