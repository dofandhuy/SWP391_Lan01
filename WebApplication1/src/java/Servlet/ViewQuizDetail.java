/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.QuizDetailsDTO;
import Entity.User;
import Service.QuizService;
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
public class ViewQuizDetail extends HttpServlet {

  private QuizService quizService;

    @Override
    public void init() {
        // Khởi tạo Service khi Servlet được load
        quizService = new QuizService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // --- BƯỚC 1: LẤY DỮ LIỆU ĐẦU VÀO ---
            
            // 1a. Lấy StudentID từ Session
            HttpSession session = request.getSession(false); // false: không tạo session mới
            
            // Kiểm tra đăng nhập
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("signin"); // Yêu cầu đăng nhập
                return;
            }
            
            User currentUser = (User) session.getAttribute("user");
            
            // === THAY ĐỔI 3: Thêm lại phần kiểm tra vai trò ===
            // Bạn yêu cầu: "chỉ cần là student là vào được"
            // (Giả sử User có hàm getRole() và Role có hàm getRoleName())
            if (currentUser.getRole() == null || !currentUser.getRole().getRoleName().equals("Student")) { 
                // Nếu không phải Student, gửi đến trang lỗi
                request.setAttribute("errorMessage", "You do not have permission to access this page.");
                request.getRequestDispatcher("errorPage.jsp").forward(request, response);
                return;
            }
            
            int studentId = currentUser.getUserID(); // Giả sử User có hàm getUserId()

            // 1b. Lấy QuizID
            // Bạn đã comment phần này ra để test, tôi giữ nguyên
//            String quizIdStr = request.getParameter("quizId");
//            if (quizIdStr == null || quizIdStr.isEmpty()) {
//                request.setAttribute("errorMessage", "No Quiz ID provided.");
//                request.getRequestDispatcher("errorPage.jsp").forward(request, response);
//                return;
//            }
//            
//            int quizId = Integer.parseInt(quizIdStr);

            // --- BƯỚC 2: GỌI SERVICE ---
            
            // Bạn đang fix cứng quizId=2 để test. OK!
            QuizDetailsDTO quizData = quizService.getQuizDetailsForStudent(2, studentId);

            // --- BƯỚC 3: GỬI DỮ LIỆU SANG VIEW (JSP) ---
            
            if (quizData != null) {
                // Đặt tên là "data" để khớp với ${data.quizTitle} trong JSP
                request.setAttribute("data", quizData);
                
                // Chuyển tiếp đến file JSP
                request.getRequestDispatcher("ViewQuizDetail.jsp").forward(request, response);
            } else {
                // Xử lý nếu Service trả về null (ví dụ: quizId=2 không tồn tại)
                request.setAttribute("errorMessage", "Could not load quiz details. The quiz may not exist.");
                request.getRequestDispatcher("errorPage.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Quiz ID format.");
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console
            request.setAttribute("errorMessage", "An unexpected error occurred.");
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        }
    }
}
