package Servlet;

import Entity.LinkedStudent;
import Entity.User;
import Service.ParentStudentService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

public class ParentManageServlet extends HttpServlet {
     private final ParentStudentService parentService = new ParentStudentService();
    private final EnrollmentService enrollmentService= new EnrollmentService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User parent = (User) session.getAttribute("user");

        if (parent == null || !"Parent".equalsIgnoreCase(parent.getRole().getRoleName())) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        int parentID = parent.getUserID();

        // Lấy danh sách các yêu cầu đang chờ ('Pending')
        List<LinkedStudent> pendingRequests = parentService.getPendingRequests(parentID);

        // Lấy danh sách các sinh viên đã được liên kết ('Active')
        List<LinkedStudent> activeLinks = parentService.getActiveLinkedStudents(parentID);

        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("linkedStudents", activeLinks); // Giữ tên cũ cho danh sách active

        request.getRequestDispatcher("ParentManageStudent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User parent = (User) session.getAttribute("user");

        if (parent == null || !"Parent".equalsIgnoreCase(parent.getRole().getRoleName())) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        int parentID = parent.getUserID();
        String action = request.getParameter("action");

        // Giữ nguyên khối kiểm tra action null
        if (action == null) {
            // Nếu không có action, tải lại cả 2 danh sách và hiển thị trang
            List<LinkedStudent> pendingRequests = parentService.getPendingRequests(parentID);
            List<LinkedStudent> activeLinks = parentService.getActiveLinkedStudents(parentID);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("linkedStudents", activeLinks);
            request.getRequestDispatcher("ParentManageStudent.jsp").forward(request, response);
            return;
        }

        // Lấy linkID ở ngoài để tránh lặp code
        int linkID = Integer.parseInt(request.getParameter("linkID"));

        switch (action) {
            // Gộp approve và relink vì chúng cùng gọi 1 hàm
            case "approve", "relink" ->
                parentService.approveLinkRequest(linkID);

            // Xử lý reject từ bảng pending
            case "reject" ->
                parentService.rejectLinkRequest(linkID);

            // Xử lý unlink từ bảng active
            case "unlink" ->
                parentService.deactivateLink(linkID);

            // Xử lý delete
            case "delete" ->
                parentService.deleteLink(linkID);

            // Xử lý view
            case "view" -> {
                User student = parentService.getStudentDetailByLinkId(linkID);
                List<Course> enrolledCourses =  enrollmentService.getEnrolledCoursesByStudent(student.getUserID()) ;
                request.setAttribute("enrolledCourses", enrolledCourses);
                request.setAttribute("student", student);
                request.getRequestDispatcher("ViewStudentDetail.jsp").forward(request, response);
                return; // Rất quan trọng: Dừng lại ngay đây để tránh forward 2 lần
            }

            default ->
                request.setAttribute("error", "Invalid action.");
        }

        // === PHẦN CUỐI CÙNG: TẢI LẠI DỮ LIỆU VÀ FORWARD ===
        // Sau khi thực hiện action, tải lại toàn bộ dữ liệu mới nhất từ DB
        List<LinkedStudent> pendingRequests = parentService.getPendingRequests(parentID);
        List<LinkedStudent> activeLinks = parentService.getActiveLinkedStudents(parentID);

        // Gửi 2 danh sách cập nhật về lại trang JSP
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("linkedStudents", activeLinks);
        request.getRequestDispatcher("ParentManageStudent.jsp").forward(request, response);
    }
}
