/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.ClassDAO;
import Entity.ClassModel;
import Entity.Event;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author doanh
 */
public class ClassOverviewServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ClassOverviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ClassOverviewServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ClassDAO dao = new ClassDAO();
        int classId = Integer.parseInt(request.getParameter("classId"));

//        // Mock dữ liệu
//        ClassModel clazz = new ClassModel(1, "Java Web Development", "123456", 2);
//        request.setAttribute("clazz", clazz);
//        request.setAttribute("studentCount", 25);
//        request.setAttribute("exerciseCount", 5);
//        request.setAttribute("submittedCount", 20);
//
//        // Mock events
//        List<Event> events = new ArrayList<>();
//        events.add(new Event(
//                1,
//                "Servlet & JSP Lecture",
//                "Lecture",
//                Timestamp.valueOf("2025-10-06 09:00:00"),
//                Timestamp.valueOf("2025-10-06 11:00:00")
//        ));
//
//        events.add(new Event(
//                2,
//                "Assignment 1 Deadline",
//                "Assignment",
//                Timestamp.valueOf("2025-10-07 23:59:00"),
//                Timestamp.valueOf("2025-10-07 23:59:00")
//        ));
//
//        events.add(new Event(
//                3,
//                "Lab Session - JDBC",
//                "Lab",
//                Timestamp.valueOf("2025-10-10 14:00:00"),
//                Timestamp.valueOf("2025-10-10 16:00:00")
//        ));
//
//        events.add(new Event(
//                4,
//                "Project Meeting",
//                "Meeting",
//                Timestamp.valueOf("2025-10-11 10:00:00"),
//                Timestamp.valueOf("2025-10-11 12:00:00")
//        ));
//

        ClassModel clazz = dao.getClassById(classId);
        int studentCount = dao.countStudentsInClass(classId);
        int exerciseCount = dao.countExercises(classId);
        int submittedCount = dao.countSubmittedOnTime(classId);
        List<Event> events = dao.getEventsByClass(classId);

        request.setAttribute("clazz", clazz);
        request.setAttribute("studentCount", studentCount);
        request.setAttribute("exerciseCount", exerciseCount);
        request.setAttribute("submittedCount", submittedCount);

        request.setAttribute("events", events);
        request.getRequestDispatcher("ClassOverview.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
