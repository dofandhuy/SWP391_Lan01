/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Servlet;

import Context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
public class ResumeServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ResumeServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResumeServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // Tham số: courseId (nếu muốn mở course), lessonId (nếu resume cụ thể)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        String lessonIdStr = req.getParameter("lessonId");

        if (courseIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);

        // 1) thêm record RecentlyViewed
        try (Connection conn = new DBContext().getConnection()) {
            // optional: add recently viewed
            String insertRecent = "INSERT INTO dbo.RecentlyViewed(UserID, CourseID, ViewedAt) VALUES (?, ?, SYSUTCDATETIME())";
            try (PreparedStatement ps = conn.prepareStatement(insertRecent)) {
                ps.setInt(1, userId);
                ps.setInt(2, courseId);
                ps.executeUpdate();
            }catch(Exception e){
                System.out.println(e);
            }

            // 2) Nếu có lessonId: đánh dấu StudentProgress completed (ví dụ toggle or create)
            if (lessonIdStr != null) {
                int lessonId = Integer.parseInt(lessonIdStr);

                // tìm EnrollmentID
                String findEnroll = "SELECT EnrollmentID FROM dbo.Enrollments WHERE StudentID = ? AND CourseID = ?";
                Integer enrollmentId = null;
                try (PreparedStatement ps = conn.prepareStatement(findEnroll)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, courseId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) enrollmentId = rs.getInt("EnrollmentID");
                    rs.close();
                }

                if (enrollmentId != null) {
                    // upsert StudentProgress
                    String upsert = "IF EXISTS (SELECT 1 FROM dbo.StudentProgress WHERE EnrollmentID = ? AND LessonID = ?) " +
                            " UPDATE dbo.StudentProgress SET IsCompleted = 1, CompletedAt = SYSUTCDATETIME() WHERE EnrollmentID = ? AND LessonID = ? " +
                            " ELSE INSERT INTO dbo.StudentProgress(EnrollmentID, LessonID, IsCompleted, CompletedAt) VALUES(?, ?, 1, SYSUTCDATETIME())";
                    try (PreparedStatement ps = conn.prepareStatement(upsert)) {
                        ps.setInt(1, enrollmentId);
                        ps.setInt(2, lessonId);
                        ps.setInt(3, enrollmentId);
                        ps.setInt(4, lessonId);
                        ps.setInt(5, enrollmentId);
                        ps.setInt(6, lessonId);
                        ps.executeUpdate();
                    }
                }
            }

            // 3) chuyển hướng: tới page course/lesson (ở đây redirect tới course detail giả định)
            resp.sendRedirect(req.getContextPath() + "/ModuleDetailServlet?courseId=" + courseId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
