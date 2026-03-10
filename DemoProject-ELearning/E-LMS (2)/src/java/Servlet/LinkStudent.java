package Servlet;

import Entity.Relationship;
import Entity.User;
import Service.ParentStudentService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class LinkStudent extends HttpServlet {
    private final ParentStudentService parentService = new ParentStudentService();

 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          List<Relationship> relationships = parentService.getAllRelationships();
        request.setAttribute("relationships", relationships);
        request.getRequestDispatcher("LinkStudent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

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

        if (studentID == -1) {
            request.setAttribute("error", "Student not found.");
        } else if (relationshipID == -1) {
            request.setAttribute("error", "Invalid relationship selected.");
        } else if (parentService.checkLinkExists(parentID, studentID)) {
            request.setAttribute("error", "Link already exists.");
        } else if (parentService.createLinkRequest(parentID, studentID, relationshipID, note)) {
            request.setAttribute("message", "Link request created successfully!");
        } else {
            request.setAttribute("error", "Failed to create link request.");
        }

        request.setAttribute("relationships", parentService.getAllRelationships());
        request.getRequestDispatcher("manage").forward(request, response);
    }
}
