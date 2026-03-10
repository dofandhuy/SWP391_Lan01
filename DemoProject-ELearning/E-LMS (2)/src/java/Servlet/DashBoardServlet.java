/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.ClassInfo;
import Entity.User;
import Service.ClassService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author doanh
 */
public class DashBoardServlet extends HttpServlet {

     private ClassService classService = new ClassService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        int userId = user.getUserID();
        String keyword = request.getParameter("search");
        String sort = request.getParameter("sort");

        List<ClassInfo> classes = classService.getStudentClasses(userId, keyword, sort);

        request.setAttribute("classes", classes);
        request.getRequestDispatcher("/StudentDashboard.jsp").forward(request, response);
    }
}
