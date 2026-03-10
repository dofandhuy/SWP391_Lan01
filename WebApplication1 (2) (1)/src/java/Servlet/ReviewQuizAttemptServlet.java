/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Entity.QuizReviewDTO;
import Entity.User;
import Service.QuizReviewService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 *
 * @author doanh
 */
public class ReviewQuizAttemptServlet extends HttpServlet {

   // Only need the service now
    private QuizReviewService reviewService;

    @Override
    public void init() {
        // Initialize the service
        this.reviewService = new QuizReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // --- Authentication/Authorization Check ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("signin");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (!currentUser.getRole().getRoleName().equals("Student")) {
             response.sendRedirect("signin"); // Or access denied
            return;
        }
        // --- End Check ---

        try {
            // --- STEP 1: GET AttemptID FROM URL ---
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));

            // --- STEP 2: CALL THE SERVICE ---
            // Service does all the heavy lifting now
            QuizReviewDTO reviewData = reviewService.getReviewData(attemptId);

            // --- STEP 3: FORWARD TO JSP (or handle errors) ---
            if (reviewData != null) {
                request.setAttribute("reviewData", reviewData); // Send DTO named "reviewData"
                request.getRequestDispatcher("quizReview.jsp").forward(request, response);
            } else {
                // Service returned null (e.g., attempt not found)
                request.setAttribute("errorMessage", "Could not load the quiz review for the specified attempt.");
                request.getRequestDispatcher("errorPage.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
             request.setAttribute("errorMessage", "Invalid Attempt ID format.");
             request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred while loading the quiz review.");
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        }
    }
}
