/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Service.InstructorService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author doanh
 */
public class DeleteClassServlet extends HttpServlet {

    private InstructorService instructorService;

    @Override
    public void init() {
        instructorService = new InstructorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int classId = Integer.parseInt(idParam);
                instructorService.deleteClass(classId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // quay lại trang danh sách lớp
        response.sendRedirect(request.getContextPath() + "/instructordashboard");
    }
}
