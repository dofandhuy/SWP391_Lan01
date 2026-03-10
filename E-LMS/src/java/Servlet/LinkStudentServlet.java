package Servlet;

import Entity.Relationship;
import Entity.User;
import Service.ParentStudentService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

public class LinkStudentServlet extends HttpServlet {

    private final ParentStudentService parentService = new ParentStudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Relationship> relationships = parentService.getAllRelationships();
        request.setAttribute("relationships", relationships);
        request.getRequestDispatcher("LinkStudent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 🔹 Kiểm tra đăng nhập
        User parent = (User) session.getAttribute("user");
        if (parent == null || !"Parent".equalsIgnoreCase(parent.getRole().getRoleName())) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        int parentID = parent.getUserID();
        String studentEmail = request.getParameter("student-email");
        String relationshipName = request.getParameter("relationship");
        String note = request.getParameter("note");

        int studentID = parentService.getStudentIDByEmail(studentEmail);
        int relationshipID = parentService.findRelationshipID(relationshipName);

        // 🔹 Kiểm tra dữ liệu nhập
        if (studentID == -1) {
            request.setAttribute("error", "Student not found.");
        } else if (relationshipID == -1) {
            request.setAttribute("error", "Invalid relationship selected.");
        } 
        // 🔹 Kiểm tra đã có link giữa parent và student này chưa
        else if (parentService.checkLinkExists(parentID, studentID)) {
            request.setAttribute("error", "You already linked with this student.");
        } 
        // 🔹 Kiểm tra học sinh đã có phụ huynh khác chưa
        else if (parentService.isStudentAlreadyLinked(studentID)) {
            request.setAttribute("error", "This student is already linked with another parent.");
        } 
        // 🔹 Nếu chưa có liên kết thì tạo mới
        else if (parentService.createLinkRequest(parentID, studentID, relationshipID, note)) {
            request.setAttribute("message", "Link request created successfully!");
        } else {
            request.setAttribute("error", "Failed to create link request.");
        }

        // Luôn load lại danh sách quan hệ để hiển thị
        request.setAttribute("relationships", parentService.getAllRelationships());
        request.getRequestDispatcher("LinkStudent.jsp").forward(request, response);
    }
}
