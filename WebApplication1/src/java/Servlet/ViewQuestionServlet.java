/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;


import Entity.AnswerOption;
import Entity.Question;
import Service.QuestionService;
import Entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class ViewQuestionServlet extends HttpServlet {
    private QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        String qid = request.getParameter("id");
        if (qid == null || qid.isEmpty()) {
            response.sendRedirect("questionBank.jsp");
            return;
        }

        int questionID = Integer.parseInt(qid);
        Question question = questionService.getQuestionByID(questionID);
        if (question == null) {
            response.sendRedirect("questionBank.jsp");
            return;
        }

        List<AnswerOption> options = questionService.getOptionsByQuestionID(questionID);

        // Lấy tên người tạo
        String createdByName = questionService.getUserNameByID(question.getCreatedBy());

        request.setAttribute("question", question);
        request.setAttribute("options", options);
        request.setAttribute("createdByName", createdByName);

        request.getRequestDispatcher("viewQuestion.jsp").forward(request, response);
    }
}