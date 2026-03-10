package Servlet;

import Dao.PaymentDAO;
import Entity.LinkedStudent;
import Entity.PaymentRequest;
import Entity.User;
import Service.ParentStudentService;
import Service.PaymentService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 *
 * @author Admin
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