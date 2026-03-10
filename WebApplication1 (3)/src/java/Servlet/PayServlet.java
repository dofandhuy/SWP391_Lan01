/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import Dao.PaymentDAO;
import Entity.PaymentRequest;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

/**
 *
 * @author doanh
 */
public class PayServlet extends HttpServlet {

   private static final String vnp_TmnCode = "RTIAZ1HY";
    private static final String vnp_HashSecret = "FFCEDSHES9QPBX4IUS05N04TDJ65DS43";
    private static final String vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String vnp_ReturnUrl = "http://localhost:8080/WebApplication1/payment_return";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Bỏ: resp.setContentType("text/plain;charset=UTF-8");
        String action = req.getParameter("action");
        String paymentIdStr = req.getParameter("paymentId"); // Lấy ID (dạng String)

        if (action == null || !action.equals("createVnpayUrl")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            return;
        }

        if (paymentIdStr == null || paymentIdStr.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: Payment ID is empty.");
            return;
        }

        int paymentId;
        try {
            paymentId = Integer.parseInt(paymentIdStr);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: Invalid Payment ID format.");
            return;
        }

        // === 3. TRUY VẤN CSDL ĐỂ LẤY THÔNG TIN ===
        PaymentDAO dao = new PaymentDAO();
        PaymentRequest paymentDetails = dao.getPaymentRequestById(paymentId); // Dùng paymentId (kiểu int)

        if (paymentDetails == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Error: Payment ID " + paymentId + " not found.");
            return;
        }

        // === 4. TÍNH TOÁN GIÁ TIỀN TỪ BIGDECIMAL ===
        BigDecimal price = paymentDetails.getCoursePrice();
        BigDecimal multiplier = new BigDecimal(100);
        long amountAsLong = price.multiply(multiplier).longValue();
        String vnp_Amount = String.valueOf(amountAsLong); // Đây là giá đúng

        String vnp_OrderInfo = "Thanh toan khoa hoc: " + paymentDetails.getCourseName();

        // ==== Bắt đầu cấu hình VNPAY ====
        String vnp_TxnRef = String.valueOf(paymentId);
        String vnp_OrderType = "billpayment";
        String vnp_Locale = "vn";
        String vnp_BankCode = "NCB";
        String vnp_IpAddr = req.getRemoteAddr();

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", vnp_Amount);
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", vnp_OrderType);
        vnp_Params.put("vnp_Locale", vnp_Locale);
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        // Tạo query string và hash
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        // === 5. DÙNG UTF-8 (Giữ nguyên) ===
        for (Iterator<String> itr = fieldNames.iterator(); itr.hasNext();) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName).append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8));
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8))
                        .append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8));
                if (itr.hasNext()) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        String vnp_SecureHash = hmacSHA512(vnp_HashSecret, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnp_SecureHash);

        String paymentUrl = vnp_Url + "?" + query.toString();

        // === SỬA ĐỔI QUAN TRỌNG: DÙNG sendRedirect ===
        // Bỏ: resp.getWriter().write(paymentUrl);
        // Thêm:
        resp.sendRedirect(paymentUrl);
    }

    // (Hàm hmacSHA512 giữ nguyên y hệt)
    private static String hmacSHA512(String key, String data) {
        try {
            javax.crypto.Mac hmac512 = javax.crypto.Mac.getInstance("HmacSHA512");
            javax.crypto.spec.SecretKeySpec secretKey
                    = new javax.crypto.spec.SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
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
        } catch (Exception e) {
            return "";
        }
    }
}
