/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import DAO.ClassDAO;
import Entity.User;
import jakarta.servlet.RequestDispatcher;
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
public class JoinClassServlet extends HttpServlet {

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
            out.println("<title>Servlet JoinClassServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JoinClassServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        String classCode = request.getParameter("classCode");

        HttpSession session = request.getSession();

        // Nếu chưa có UserID trong session thì set tạm 1 giá trị để test
//        if (session.getAttribute("studentId") == null) {
//            session.setAttribute("studentId", 2); // giả sử StudentID = 2 trong DB
//        }
//        int studentId = (int) request.getSession().getAttribute("UserID"); // Lấy từ session login

//        int studentId = (Integer) session.getAttribute("UserID");
        ClassDAO dao = new ClassDAO();
        User user = (User) session.getAttribute("user");
        
        int studentId = user.getUserID();
        int classId = dao.getClassIdByCode(classCode);

        if (classId == -1) {
            // Mã lớp không tồn tại
            request.setAttribute("errorMsg", "❌ Invalid class code. Please try again.");
            RequestDispatcher rd = request.getRequestDispatcher("InputClassCode.jsp");
            rd.forward(request, response);
            return;
        }

        if (dao.isStudentEnrolled(studentId, classId)) {
            // Sinh viên đã enroll lớp này
            request.setAttribute("errorMsg", "⚠️ You have already joined this class.");
            RequestDispatcher rd = request.getRequestDispatcher("InputClassCode.jsp");
            rd.forward(request, response);
            return;
        }

        if (dao.enrollStudent(studentId, classId)) {
            // Enroll thành công → chuyển đến trang overview của lớp
            response.sendRedirect("ClassOverview.jsp?classId=" + classId);
        } else {
            // Có lỗi khi insert
            request.setAttribute("errorMsg", "❌ Something went wrong. Please try again.");
            RequestDispatcher rd = request.getRequestDispatcher("InputClassCode.jsp");
            rd.forward(request, response);
        }
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
