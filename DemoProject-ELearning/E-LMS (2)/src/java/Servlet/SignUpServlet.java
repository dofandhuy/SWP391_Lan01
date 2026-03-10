/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.Role;
import Service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author doanh
 */
public class SignUpServlet extends HttpServlet {
 private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load tất cả role từ DB
        List<Role> roles = userService.getAllRoles();
        request.setAttribute("roles", roles);

        // Hiển thị trang Signup.jsp
        request.getRequestDispatcher("Signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleIdStr = request.getParameter("roleId");

        // Optional fields
        String phone = request.getParameter("phone") != null ? request.getParameter("phone") : "";
        String dob = request.getParameter("dob") != null ? request.getParameter("dob") : "";
        String sex = request.getParameter("sex") != null ? request.getParameter("sex") : "";
        String address = request.getParameter("address") != null ? request.getParameter("address") : "";

        try {
            userService.signUp(username, email, password, confirmPassword,
                    roleIdStr, phone, dob, sex, address);

            request.setAttribute("mess", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("Signin.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("mess", e.getMessage());
            // Load lại form signup với roles
            doGet(request, response);
        }
    }
}
