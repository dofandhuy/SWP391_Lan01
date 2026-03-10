package Servlet;

import Entity.User;
import Dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


public class UptProfile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy data từ form
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dob");
        String sex = request.getParameter("sex");

        // Cập nhật object
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

        // Cập nhật DB
        UserDAO dao = new UserDAO();
        dao.updateUser(user);

        // Cập nhật lại session
        session.setAttribute("user", user);

        // Chuyển về profile
        response.sendRedirect("profile.jsp");
    }
}