/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Service.ParentStudentService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author doanh
 */
public class CourseRequestServlet extends HttpServlet {
private final PaymentService paymentService = new PaymentService();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ParentStudentService parentService = new ParentStudentService();

     @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 4;

        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) {}
        }

        int totalRequests = paymentDAO.getTotalRequestCount();
        int totalPages = (int) Math.ceil(totalRequests / (double) pageSize);

        List<PaymentRequest> requestList = paymentDAO.getRequestsByPage(page, pageSize);

        req.setAttribute("requestList", requestList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

           // 4. Forward ra JSP
        req.getRequestDispatcher("CourseRequest.jsp").forward(req, resp);
    }


}
