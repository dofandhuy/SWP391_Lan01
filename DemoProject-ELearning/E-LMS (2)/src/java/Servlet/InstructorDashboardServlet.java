/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.InstructorClass;
import Entity.User;
import Service.InstructorService;
import java.io.IOException;
import java.io.PrintWriter;
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
public class InstructorDashboardServlet extends HttpServlet {

  private InstructorService service = new InstructorService();

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // Lấy user từ session
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        // Chưa login → redirect về login
        response.sendRedirect("Signin.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");

    // Kiểm tra role
    if (!"instructor".equalsIgnoreCase(user.getRole().getRoleName())) {
        // Nếu không phải teacher → có thể redirect hoặc thông báo lỗi
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
        return;
    }

    int instructorId = user.getUserID(); // Lấy từ user ID

    String keyword = request.getParameter("search");
    String sort = request.getParameter("sort");

    List<InstructorClass> classes = service.getInstructorClasses(instructorId, keyword, sort);

    request.setAttribute("classes", classes);
    request.getRequestDispatcher("/InstructorDashboard.jsp").forward(request, response);
}
}
