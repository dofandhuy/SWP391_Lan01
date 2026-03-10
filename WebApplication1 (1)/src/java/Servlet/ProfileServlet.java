package Servlet;

import Entity.LinkedStudent;
import Entity.ParentStudentLink;
import Entity.User;
import Service.ParentStudentService; // Cần import service này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


public class ProfileServlet extends HttpServlet {

    // Khởi tạo service để sử dụng
    private final ParentStudentService parentStudentService = new ParentStudentService();
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User currentUser = null;

    if (session != null) {
        currentUser = (User) session.getAttribute("user");
    }

    if (currentUser == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }

    if ("Student".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
        
        // Gọi phương thức để lấy TẤT CẢ các liên kết
        List<LinkedStudent> allLinks = parentStudentService.getAllLinksByStudentId(currentUser.getUserID());
        
        // Gửi danh sách này tới JSP
        request.setAttribute("allLinks", allLinks);
    }

    // Forward tới trang JSP
    request.getRequestDispatcher("profile.jsp").forward(request, response);
}
}