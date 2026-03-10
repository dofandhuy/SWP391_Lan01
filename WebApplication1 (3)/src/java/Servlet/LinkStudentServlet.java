package Servlet;

import Entity.ParentStudentLink;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This part is correct, it loads the relationships for the form's dropdown
        List<Relationship> relationships = parentService.getAllRelationships();
        request.setAttribute("relationships", relationships);
        // Make sure the JSP file name is correct
        request.getRequestDispatcher("LinkStudent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // The logged-in user is the STUDENT, not the parent
        User student = (User) session.getAttribute("user");

        // Validate that the user is a student
        if (student == null || !"Student".equalsIgnoreCase(student.getRole().getRoleName())) {
            // If not a student, redirect to login or an appropriate page
            response.sendRedirect("Signin.jsp");
            return;
        }

        // Get the parent's email from the form.
        // NOTE: Your JSP form field is named "student-email", which is confusing.
        // It should ideally be named "parent-email".
        String parentEmail = request.getParameter("student-email");
        String relationshipName = request.getParameter("relationship");
        String note = request.getParameter("note");

        // The student's ID comes from the session
        int studentID = student.getUserID();

        // Find the parent's ID using their email
        // Assumption: You have a method like this in your service layer
        int parentID = parentService.getParentIDByEmail(parentEmail); 
        
        int relationshipID = parentService.findRelationshipID(relationshipName);

        // --- Validation Logic ---
        if (student.getEmail().equalsIgnoreCase(parentEmail)) {
             request.setAttribute("error", "You cannot link to your own account.");
        } else if (parentID == -1) {
            request.setAttribute("error", "Parent account with this email not found.");
        } else if (relationshipID == -1) {
            request.setAttribute("error", "Invalid relationship selected.");
        } else if (parentService.checkLinkExists(parentID, studentID)) {
            request.setAttribute("error", "An active or pending link with this parent already exists.");
        } else {
          ParentStudentLink existingLink = parentService.getLinkByParentAndStudentId(parentID, studentID);
        boolean success = false;
        
        // TRƯỜNG HỢP 1: Có link cũ và trạng thái là 'Rejected' -> Cập nhật nó
        if (existingLink != null && "Rejected".equalsIgnoreCase(existingLink.getStatus())) {
            success = parentService.updateRejectedLink(parentID, studentID, relationshipID, note);
            if (success) {
                request.setAttribute("error", "Your rejected request has been resent successfully!");
            }
        } 
        // TRƯỜNG HỢP 2: Không có link nào cả -> Tạo mới
        else {
            success = parentService.createLinkRequest(parentID, studentID, relationshipID, note);
            if (success) {
                request.setAttribute("error", "Link request sent to your parent successfully!");
            }
        }

        // Đặt thông báo lỗi chung nếu cả hai trường hợp trên đều thất bại
        if (!success) {
            request.setAttribute("error", "An error occurred. Please try again.");
        }
        }
        
        // Always re-populate the relationships list before forwarding back to the JSP
        request.setAttribute("relationships", parentService.getAllRelationships());
        request.getRequestDispatcher("LinkStudent.jsp").forward(request, response);
    }
}