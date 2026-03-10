/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Dao.OtpDAO;
import Entity.User;
import Service.OtpService;
import Service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;

/**
 *
 * @author doanh
 */
@WebServlet("/signin")
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
            HttpSession session = request.getSession();
            String role = user.getRole().getRoleName();

            // Nếu là admin thì xử lý OTP
            if ("admin".equalsIgnoreCase(role)) {
                OtpService otpService = new OtpService();
                OtpDAO otpDAO = new OtpDAO();
                String otp = otpService.generateOtp();
                otpService.sendOtpEmail(user.getEmail(), otp);

                LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(10);
                otpDAO.saveAdminOtp(user.getEmail(), otp, expiryTime);

                session.setAttribute("admin_email_for_otp", user.getEmail());
                response.sendRedirect("verifyOtp.jsp");
                return;
            }
            session.setAttribute("user", user);
//            session.setAttribute("userId", user.getUserID());


            switch (role.toLowerCase()) {
                case "student":
                    response.sendRedirect("StudentDashboardServlet");
                    break;
                case "instructor":
                    response.sendRedirect(request.getContextPath() + "/instructor/courses");
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
