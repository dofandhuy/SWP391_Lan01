package Servlet;

import Service.QuestionService;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import Entity.User;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;



public class DeleteQuestionLessonServlet extends HttpServlet {

    private QuestionService qs = new QuestionService();

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }

    String qIdStr = request.getParameter("questionId"); // 🔥 Đổi tên tham số
    String lessonIdStr = request.getParameter("lessonId"); // để redirect về đúng bài học

    if (qIdStr != null) {
        int questionID = Integer.parseInt(qIdStr);
        boolean deleted = qs.deleteQuestionByIDAndUserID(questionID, currentUser.getUserID());

        if (!deleted) {
            request.setAttribute("error", "Bạn không thể xóa câu hỏi này.");
        }
    }

    // 🔥 Redirect lại đúng trang lessonDetail, không phải lessonDetail.jsp tĩnh
    response.sendRedirect(request.getContextPath() + "/instructor/lessonDetail?lessonId=" + lessonIdStr);
}
   
}
