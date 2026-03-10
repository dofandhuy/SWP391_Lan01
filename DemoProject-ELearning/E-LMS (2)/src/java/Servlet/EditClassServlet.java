/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.ClassEntity;
import Entity.User;
import Service.InstructorService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author doanh
 */
public class EditClassServlet extends HttpServlet {

    private InstructorService instructorService = new InstructorService();

    // Hiển thị form edit (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
         String idParam = req.getParameter("classId");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing classId");
            return;
        }

        int classId = Integer.parseInt(idParam);
        ClassEntity ic = instructorService.getClassById(classId);

        if (ic == null) {
            resp.sendRedirect("instructorDashboard.jsp?error=ClassNotFound");
            return;
        }

        req.setAttribute("classObj", ic);
        req.getRequestDispatcher("/EditClass.jsp").forward(req, resp);
    }


    // Cập nhật class (POST)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

         String idParam = req.getParameter("classId");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing classId");
            return;
        }

        int classId = Integer.parseInt(idParam);
        String className = req.getParameter("className");
        String description = req.getParameter("description");

        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        int instructorId = currentUser.getUserID();

        boolean success = instructorService.updateClass(classId, className, description, instructorId);

        if (success) {
            resp.sendRedirect("instructordashboard");
        } else {
            req.setAttribute("error", "UpdateFailed");
            req.setAttribute("classObj", instructorService.getClassById(classId));
            req.getRequestDispatcher("/EditClass.jsp").forward(req, resp);
        }
    }
    }

