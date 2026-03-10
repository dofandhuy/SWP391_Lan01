/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Dao.PaymentDAO;
import Entity.Course;
import Entity.Lesson;
import Entity.PaymentRequest;
import Service.CourseService;
import Service.LessonService;
import Service.ModuleService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author doanh
 */
public class PaymentServlet extends HttpServlet {
   private CourseService courseService = new CourseService();
    private ModuleService moduleService = new ModuleService();
    private LessonService lessonService = new LessonService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String idStr = request.getParameter("id"); // lấy từ input hidden
        int requestId = Integer.parseInt(idStr);
        if ("view".equals(action)) {
            Course course = courseService.getCourseById1(requestId);
            List<Entity.Module> modules = moduleService.getModulesByCourseId(requestId);

            Map<Integer, List<Lesson>> lessonsByModule = new HashMap<>();
            for (Entity.Module m : modules) {
                try {
                    lessonsByModule.put(m.getId(), lessonService.getLessonsByModuleId(m.getId()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("lessonsByModule", lessonsByModule);
            request.getRequestDispatcher("ParentViewCourse.jsp").forward(request, response);
        } else if ("approve".equals(action)) {
            // Bước 1: Lấy thông tin request từ DB
            PaymentDAO crDAO = new PaymentDAO();
            PaymentRequest cr = crDAO.getPaymentRequestById(requestId);

            if (cr == null) {
                request.setAttribute("error", "Không tìm thấy yêu cầu với ID: " + requestId);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // Bước 2: Tạo PaymentDetails (hoặc DTO)
            // Bước 3: Gửi dữ liệu sang trang xác nhận
            request.setAttribute("paymentDetails", cr);
            request.getRequestDispatcher("Payforcourse.jsp").forward(request, response);

        } else if ("reject".equals(action)) {
            // Cập nhật trạng thái bị từ chối trong DB
            PaymentDAO dao = new PaymentDAO();
            dao.updateStatus(requestId, "Rejected");
            response.sendRedirect("CourseRequestServlet");
        }

    }
}
