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



public class DeleteQuestionServlet extends HttpServlet {

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

        String idStr = request.getParameter("id");

        if (idStr != null) {

            int questionID = Integer.parseInt(idStr);

            boolean deleted = false;
            try {
                deleted = qs.deleteQuestionByIDAndUserID(questionID, currentUser.getUserID());
            } catch (SQLException ex) {
                Logger.getLogger(DeleteQuestionServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            if (!deleted) {

                request.setAttribute("error", "Bạn không thể xóa câu hỏi này.");

            }

        }

        response.sendRedirect("questionBank.jsp");

    }

}
