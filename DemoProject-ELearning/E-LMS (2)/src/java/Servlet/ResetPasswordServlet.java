/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Servlet;

import DAO.TokenForgetDAO;
import DAO.UserDAO;
import Entity.TokenForgetPassword;
import Entity.User;
import Service.ResetService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.security.MessageDigest;

/**
 *
 * @author ASUS
 */
@WebServlet(name="ResetPasswordServlet", urlPatterns={"/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {
   TokenForgetDAO DAOToken = new TokenForgetDAO();
    UserDAO DAOUser = new UserDAO();
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
            out.println("<title>Servlet ResetPasswordServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResetPasswordServlet at " + request.getContextPath () + "</h1>");
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
        String token = request.getParameter("token");
        HttpSession session = request.getSession();
        if(token != null) {
            TokenForgetPassword tokenForgetPassword = DAOToken.getTokenPassword(token);
            ResetService service = new ResetService();
            if(tokenForgetPassword == null) {
                request.setAttribute("mess", "token invalid");
                request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
                return;
            }
            if(tokenForgetPassword.isIsUsed()) {
                request.setAttribute("mess", "token is used");
                request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
                return;
            }
            if(service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
                request.setAttribute("mess", "token is expiry time");
                request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
                return;
            }
            User user = DAOUser.getUserById(tokenForgetPassword.getUserId());
            request.setAttribute("email", user.getEmail());
            session.setAttribute("token", tokenForgetPassword.getToken());
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
        }
    } 

    
    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        //validate password...
        if (!password.equals(confirmPassword)) {
            request.setAttribute("mess", "confirm password must same password");
            request.setAttribute("email", email);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        if (!password.matches(passwordRegex)) {
            request.setAttribute("mess", "Password must be at least 8 characters, include uppercase, lowercase, number, and special character!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession();
        String tokenStr = (String) session.getAttribute("token");
        TokenForgetPassword tokenForgetPassword = DAOToken.getTokenPassword(tokenStr);
        //check token is valid, of time, of used
        ResetService service = new ResetService();
        if (tokenForgetPassword == null) {
            request.setAttribute("mess", "token invalid");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }
        if (tokenForgetPassword.isIsUsed()) {
            request.setAttribute("mess", "token is used");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }
        if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
            request.setAttribute("mess", "token is expiry time");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        //update is used of token
        tokenForgetPassword.setToken(tokenStr);
        tokenForgetPassword.setIsUsed(true);

        // Hash password trước khi update vào DB
String passwordHash = hashPassword(password);
DAOUser.updatePassword(email, passwordHash);
DAOToken.updateStatus(tokenForgetPassword);

        //save user in session and redirect to home
        request.getRequestDispatcher("Signin.jsp").forward(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5"); // demo
            byte[] hashBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
