/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.User;
import Service.PaymentService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author doanh
 */
public class PaymentRequestServlet extends HttpServlet {

    private PaymentService paymentService = new PaymentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User student = (User) session.getAttribute("user");
        if (student == null || !"student".equalsIgnoreCase(student.getRole().getRoleName())) {
            resp.sendRedirect("Signin.jsp");
            return;
        }
        int studentID = student.getUserID();
        int courseID = Integer.parseInt(req.getParameter("courseId"));
        
        String msg = paymentService.requestPayment(studentID, courseID);
        session.setAttribute("toastMessage", msg);
        resp.sendRedirect("CourseDetailServlet_1?id=" + courseID);
    }

}
