/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.LinkedStudent;
import Entity.User;
import Service.ParentStudentService;
import java.io.IOException;
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
public class ParentDashBoardServlet extends HttpServlet {

    private final ParentStudentService parentService = new ParentStudentService();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        User parent = (User) session.getAttribute("user");
        if (parent == null || !"Parent".equalsIgnoreCase(parent.getRole().getRoleName())) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        int parentID = parent.getUserID();
        List<LinkedStudent> linkedStudents = parentService.getActiveLinkedStudents(parentID);
        List<PaymentRequest> pendingRequests = paymentService.getPendingRequestsByParentID(parentID);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("linkedStudents", linkedStudents);
        request.getRequestDispatcher("ParentDashBoard.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
