/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Dao.EnrollmentDAO;
import Dao.PaymentDAO;
import Entity.PaymentRequest;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 *
 * @author doanh
 */
public class PaymentReturnServlet extends HttpServlet {


    private static final String vnp_HashSecret = "FFCEDSHES9QPBX4IUS05N04TDJ65DS43"; 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("--- VNPAY RETURN RECEIVED ---");

        Map<String, String> fields = new HashMap<>();

        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

         String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash"); 
        }
         if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType"); 
        }


        try {
 
            if (verifySignature(fields, vnp_SecureHash)) {
                System.out.println("Signature VALID"); 
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                String vnp_TxnRef = request.getParameter("vnp_TxnRef"); 

                System.out.println("Response Code: " + vnp_ResponseCode); 
                System.out.println("TxnRef (RequestID): " + vnp_TxnRef);  


                if ("00".equals(vnp_ResponseCode)) {

                    System.out.println("Payment SUCCESS"); 
                    try {
                        int requestId = Integer.parseInt(vnp_TxnRef);

                        PaymentDAO paymentDAO = new PaymentDAO();
                        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

                        
                        PaymentRequest pr = paymentDAO.getPaymentRequestById(requestId);

                        if (pr != null) {
                          
                            if (!"Completed".equals(pr.getStatus())) {

                               
                                boolean updateStatusSuccess = paymentDAO.updateStatus(requestId, "Completed");

                              
                                boolean enrollSuccess = false; 
                                try {
                                     enrollmentDAO.enrollStudent(pr.getStudentID(), pr.getCourseID());
                                     enrollSuccess = true; 
                                     System.out.println("enrollStudent completed without exceptions for RequestID: " + requestId); // Log
                                } catch (Exception enrollEx) {
                                     System.err.println("Error calling enrollStudent for RequestID: " + requestId + " - " + enrollEx.getMessage()); // Log lỗi
                                     enrollEx.printStackTrace();
                                     enrollSuccess = false; 
                                }


                                
                                if (updateStatusSuccess && enrollSuccess) {
                                    System.out.println("DB Update SUCCESS (assumed) for RequestID: " + requestId); 
                                    response.sendRedirect("paymentSuccess.jsp"); 
                                } else {
                                    System.err.println("DB Update FAILED for RequestID: " + requestId + " (updateStatus=" + updateStatusSuccess + ", enrollSuccess=" + enrollSuccess + ")"); // Log chi tiết hơn
                                  
                                    response.sendRedirect("paymentFailure.jsp?errorCode=DB_ERROR");
                                }
                            } else {
                                System.out.println("RequestID " + requestId + " already processed. Redirecting to success."); 
                                response.sendRedirect("paymentSuccess.jsp");
                            }
                        } else {
                            System.out.println("RequestID " + requestId + " not found in DB."); 
                            response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_REQUEST");
                        }

                    } catch (NumberFormatException e) {
                        System.out.println("Invalid TxnRef format: " + vnp_TxnRef); // Log
                        response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_TXNREF");
                    } catch (Exception e) {
                        System.out.println("DB Error: " + e.getMessage()); // Log
                        e.printStackTrace();
                        response.sendRedirect("paymentFailure.jsp?errorCode=DB_ERROR");
                    }
                } else {
                   
                    System.out.println("Payment FAILED with code: " + vnp_ResponseCode); 
                    response.sendRedirect("paymentFailure.jsp?errorCode=" + vnp_ResponseCode); 
                }
            } else {

                System.out.println("Signature INVALID"); //
                response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_SIGNATURE");
            }
        } catch (Exception e) {
            System.out.println("General Error: " + e.getMessage()); // Log
            e.printStackTrace();
            response.sendRedirect("paymentFailure.jsp?errorCode=UNKNOWN");
        }
        System.out.println("--- VNPAY RETURN PROCESSING END ---"); // Log
    }

    // (Hàm verifySignature giữ nguyên)
    private boolean verifySignature(Map<String, String> fields, String inputHash) throws NoSuchAlgorithmException, InvalidKeyException {
         List<String> fieldNames = new ArrayList<>(fields.keySet());
         Collections.sort(fieldNames);
         StringBuilder hashData = new StringBuilder();
         for (String fieldName : fieldNames) {
             String fieldValue = fields.get(fieldName);
             if ((fieldValue != null) && (fieldValue.length() > 0)) {
                 try {
                     hashData.append(fieldName);
                     hashData.append('=');
                     hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                     hashData.append('&');
                 } catch (IOException e) { e.printStackTrace(); }
             }
         }
         if (hashData.length() > 0) {
             hashData.setLength(hashData.length() - 1);
         }
         String calculatedHash = hmacSHA512(vnp_HashSecret, hashData.toString());
         return calculatedHash.equalsIgnoreCase(inputHash);
     }



     private static String hmacSHA512(String key, String data) throws NoSuchAlgorithmException, InvalidKeyException {
         Mac hmac512 = Mac.getInstance("HmacSHA512");
         SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
         hmac512.init(secretKey);
         byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
         StringBuilder hash = new StringBuilder();
         for (byte b : bytes) {
             String hex = Integer.toHexString(0xff & b);
             if (hex.length() == 1) {
                 hash.append('0');
             }
             hash.append(hex);
         }
         return hash.toString();
     }
}
