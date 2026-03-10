package Servlet;

import Entity.User;
import Service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;


public class ChangePasswordServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }

    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    // Regex kiểm tra password
    String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\W_]).{8,}$";
    if (!newPassword.matches(passwordPattern)) {
        request.setAttribute("errorMessage", "Mật khẩu phải ≥ 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt!");
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
        return;
    }

    if (!newPassword.equals(confirmPassword)) {
        request.setAttribute("errorMessage", "Xác nhận mật khẩu không khớp!");
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
        return;
    }

    boolean success = userService.changePassword(currentUser.getUserID(), currentPassword, newPassword);

    if (success) {
        request.setAttribute("successMessage", "Password updated successfully!");
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    } else {
        request.setAttribute("errorMessage", "Mật khẩu hiện tại không chính xác!");
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
    }
}
