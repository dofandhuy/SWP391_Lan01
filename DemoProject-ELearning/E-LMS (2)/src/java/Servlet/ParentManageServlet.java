/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.LinkedStudent;
import Entity.User;
import Service.ParentStudentService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author doanh
 */
public class ParentManageServlet extends HttpServlet {

    private final ParentStudentService parentService = new ParentStudentService();

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
        List<LinkedStudent> linkedStudents = parentService.getLinkedStudents(parentID);
        request.setAttribute("linkedStudents", linkedStudents);
        request.getRequestDispatcher("ParentManageStudent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User parent = (User) session.getAttribute("user");
        int parentID = parent.getUserID();
        switch (action) {
            case "delete":
                parentService.deleteLink(Integer.parseInt(request.getParameter("linkID")));
                break;
            case "link":
                parentService.approveLinkRequest(Integer.parseInt(request.getParameter("linkID")));
                break;
            case "unlink":
                parentService.rejectLinkRequest(Integer.parseInt(request.getParameter("linkID")));
                break;
            case "view":
                int linkId = Integer.parseInt(request.getParameter("linkID"));
                User student = parentService.getStudentDetailByLinkId(linkId);
                request.setAttribute("student", student);
                request.getRequestDispatcher("viewStudentDetail.jsp").forward(request, response);
                break;
        }

        // Load lại danh sách để JSP hiển thị
        List<LinkedStudent> linkedStudents = parentService.getLinkedStudents(parentID);
        request.setAttribute("linkedStudents", linkedStudents);
        request.getRequestDispatcher("ParentManageStudent.jsp").forward(request, response);
    }
}
