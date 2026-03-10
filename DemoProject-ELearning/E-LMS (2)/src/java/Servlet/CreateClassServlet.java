package Servlet;

import Entity.User;
import Service.ClassService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CreateClassServlet extends HttpServlet {

    private ClassService classService = new ClassService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy user từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Kiểm tra role teacher
        if (!"instructor".equalsIgnoreCase(user.getRole().getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        int instructorId = user.getUserID(); // lấy từ user login

        String className = request.getParameter("className");
        String description = request.getParameter("description");

        // Tạo lớp
        classService.createClass(className, description, instructorId);

        // Redirect về dashboard của instructor
        response.sendRedirect(request.getContextPath() + "/instructordashboard");
    }
}
