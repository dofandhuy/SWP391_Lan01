package Servlet;

import Dao.EnrollmentDAO;
import Dao.PaymentDAO;
import Entity.PaymentRequest;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
            if (fieldValue != null && fieldValue.length() > 0) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        try {
            if (verifySignature(fields, vnp_SecureHash)) {
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
                String vnp_TxnRef = request.getParameter("vnp_TxnRef");

                System.out.println("✅ Signature VALID");
                System.out.println("TxnRef = " + vnp_TxnRef + ", ResponseCode = " + vnp_ResponseCode);

                // === Giải mã RequestID từ vnp_TxnRef ===
                // vnp_TxnRef có dạng: "{paymentId}-{timestamp}"
                String[] parts = vnp_TxnRef.split("-");
                if (parts.length == 0) {
                    response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_TXNREF");
                    return;
                }

                int paymentId;
                try {
                    paymentId = Integer.parseInt(parts[0]); // chỉ lấy phần paymentId
                } catch (NumberFormatException e) {
                    response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_TXNREF_FORMAT");
                    return;
                }

                PaymentDAO paymentDAO = new PaymentDAO();
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

                // === Kiểm tra trùng giao dịch (TxnRef đã xử lý chưa) ===
                if (paymentDAO.isTxnRefExists(vnp_TxnRef)) {
                    System.out.println("⚠️ Transaction already exists: " + vnp_TxnRef);
                    response.sendRedirect("paymentSuccess.jsp");
                    return;
                }

                // === Lưu lại TxnRef vào DB để không xử lý lại lần sau ===
                paymentDAO.saveTxnRef(vnp_TxnRef, paymentId);

                // === Nếu giao dịch thành công (mã 00) ===
                if ("00".equals(vnp_ResponseCode)) {

                    PaymentRequest pr = paymentDAO.getPaymentRequestById(paymentId);

                    if (pr != null) {
                        if (!"Completed".equals(pr.getStatus())) {
                            boolean updated = paymentDAO.updateStatus(paymentId, "Completed");

                            boolean enrolled = false;
                            try {
                                enrollmentDAO.enrollStudent(pr.getStudentID(), pr.getCourseID());
                                enrolled = true;
                            } catch (Exception ex) {
                                System.err.println("Enroll failed: " + ex.getMessage());
                            }

                            if (updated && enrolled) {
                                System.out.println("✅ Payment & Enrollment SUCCESS for paymentId=" + paymentId);
                                response.sendRedirect("paymentSuccess.jsp");
                            } else {
                                System.err.println("❌ DB update/enroll failed for paymentId=" + paymentId);
                                response.sendRedirect("paymentFailure.jsp?errorCode=DB_ERROR");
                            }
                        } else {
                            System.out.println("⚠️ Payment already marked Completed, skipping duplicate process.");
                            response.sendRedirect("paymentSuccess.jsp");
                        }
                    } else {
                        response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_PAYMENT");
                    }

                } else {
                    // === Giao dịch thất bại ===
                    System.out.println("❌ Payment FAILED, code = " + vnp_ResponseCode);
                    response.sendRedirect("paymentFailure.jsp?errorCode=" + vnp_ResponseCode);
                }

            } else {
                System.out.println("❌ INVALID SIGNATURE");
                response.sendRedirect("paymentFailure.jsp?errorCode=INVALID_SIGNATURE");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("paymentFailure.jsp?errorCode=EXCEPTION");
        }

        System.out.println("--- VNPAY RETURN END ---");
    }

    private boolean verifySignature(Map<String, String> fields, String inputHash)
            throws NoSuchAlgorithmException, InvalidKeyException {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                try {
                    hashData.append(fieldName)
                            .append('=')
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()))
                            .append('&');
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        if (hashData.length() > 0) {
            hashData.setLength(hashData.length() - 1);
        }

        String calculatedHash = hmacSHA512(vnp_HashSecret, hashData.toString());
        return calculatedHash.equalsIgnoreCase(inputHash);
    }

    private static String hmacSHA512(String key, String data)
            throws NoSuchAlgorithmException, InvalidKeyException {
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
