package Servlet;

import Dao.UserDAO;
import Entity.Role;
import Entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/admin/users"})
public class UserDashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("export".equals(action)) {
            handleExport(request, response);
        } else {
            showUserList(request, response);
        }
    }

    private void showUserList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy các tham số lọc và tìm kiếm từ request
        int roleId = parseInt(request.getParameter("role"), 0);
        String gender = request.getParameter("gender") == null ? "" : request.getParameter("gender");
        int status = parseInt(request.getParameter("status"), -1);
        String searchCategory = request.getParameter("searchCategory") == null ? "" : request.getParameter("searchCategory");
        String searchValue = request.getParameter("searchValue") == null ? "" : request.getParameter("searchValue");

        // Gọi phương thức getFilteredUsers đã được cập nhật trong UserDAO
        List<User> userList = userDAO.getFilteredUsers(roleId, gender, status, searchCategory, searchValue);

        // Lấy danh sách role để hiển thị dropdown
        List<Role> roleList = userDAO.getAllRoles();

        // Gửi dữ liệu sang JSP
        request.setAttribute("userList", userList);
        request.setAttribute("roleList", roleList);

        // Giữ lại giá trị lọc và tìm kiếm trên form
        request.setAttribute("selectedRoleId", roleId);
        request.setAttribute("selectedGender", gender);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("searchCategory", searchCategory);
        request.setAttribute("searchValue", searchValue);

        // Forward sang JSP
        request.getRequestDispatcher("/userDashboard.jsp").forward(request, response);
    }

    private void handleExport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Lấy dữ liệu đã lọc tương tự như showUserList
        int roleId = parseInt(request.getParameter("role"), 0);
        String gender = request.getParameter("gender") == null ? "" : request.getParameter("gender");
        int status = parseInt(request.getParameter("status"), -1);
        String searchCategory = request.getParameter("searchCategory") == null ? "" : request.getParameter("searchCategory");
        String searchValue = request.getParameter("searchValue") == null ? "" : request.getParameter("searchValue");
        
        // Gọi phương thức DAO với các tham số đã cập nhật
        List<User> userList = userDAO.getFilteredUsers(roleId, gender, status, searchCategory, searchValue);

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_export.csv\"");

        try (PrintWriter writer = response.getWriter()) {
            writer.println("UserID,Username,Email,Gender,Role,Status");
            
            for (User user : userList) {
                writer.printf("%d,%s,%s,%s,%s,%s\n",
                        user.getUserID(),
                        user.getUsername(),
                        user.getEmail(),
                        user.getSex() != null ? user.getSex() : "N/A",
                        user.getRole().getRoleName(),
                        user.isStatus() ? "Active" : "Inactive"
                );
            }
        }
    }
    
    // Hàm helper để parse int an toàn
    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}