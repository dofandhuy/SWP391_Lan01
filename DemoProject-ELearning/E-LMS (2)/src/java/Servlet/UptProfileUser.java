package Servlet;

import DAO.UserDAO;

import java.io.IOException;

import Entity.User;
import Service.UserService;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import java.io.PrintWriter;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;

/**
 *
 *
 *
 * @author doanh
 *
 */
public class UptProfileUser extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dob");
        String sex = request.getParameter("sex");

        // Cập nhật vào object user
        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setSex(sex);

        try {
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(java.sql.Date.valueOf(dobStr));
            }
        } catch (IllegalArgumentException e) {
            user.setDob(null);
        }

        try {
            // Gọi Service để update vào DB
            userService.updateUserProfile(user);

            // Cập nhật lại session
            session.setAttribute("user", user);

            // Chuyển hướng về profile
            response.sendRedirect("profile");
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi thì có thể redirect về trang edit với thông báo lỗi
            session.setAttribute("errorMsg", "Cập nhật thất bại: " + e.getMessage());
            response.sendRedirect("Edit.jsp");
        }
    }
}

