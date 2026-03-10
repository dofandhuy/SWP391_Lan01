/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.User;
import Service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author doanh
 */
public class SignInServlet extends HttpServlet {
 
 private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang Signin.jsp
        request.getRequestDispatcher("Signin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userService.signIn(email, password);

            // Lưu user vào session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

           String role = user.getRole().getRoleName();
           switch (role.toLowerCase()) {
            case "student":
                response.sendRedirect("studentdashboard");
                break;
            case "instructor":
                response.sendRedirect("instructordashboard");
                break;
            case "parent":
                response.sendRedirect("ParentDashBoard");
                break;
           }
        } catch (Exception e) {
            // Nếu lỗi, set thông báo và load lại form
            request.setAttribute("mess", e.getMessage());
            request.getRequestDispatcher("Signin.jsp").forward(request, response);
        }
    }
}
