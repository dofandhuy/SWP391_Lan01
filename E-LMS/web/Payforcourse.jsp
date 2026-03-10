<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận Thanh toán</title>
        <style>
            /* ... (Tất cả CSS của bạn giữ nguyên y hệt) ... */
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                background-color: #f4f7f6;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                padding: 20px;
                box-sizing: border-box;
            }
            .payment-container {
                background-color: #ffffff;
                border-radius: 12px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                padding: 28px 32px;
                width: 100%;
                max-width: 500px;
                border: 1px solid #e0e0e0;
            }
            .payment-form {
                display: flex;
                flex-direction: column;
            }
            .form-group {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }
            .form-group label {
                font-weight: 600;
                color: #333;
                flex-basis: 30%;
            }
            .form-group input[type="text"] {
                flex-basis: 70%;
                padding: 10px 12px;
                border: 1px solid #dcdcdc;
                border-radius: 6px;
                background-color: #f9f9f9;
                font-size: 1rem;
                color: #555;
                cursor: not-allowed;
            }
            .terms-section {
                margin-top: 10px;
                border-top: 1px solid #eee;
                padding-top: 20px;
            }
            .terms-section h4 {
                margin-top: 0;
                margin-bottom: 12px;
                color: #222;
            }
            .terms-section p {
                font-size: 0.875rem;
                color: #555;
                line-height: 1.5;
                margin-bottom: 8px;
            }
            .form-check {
                margin-top: 20px;
                display: flex;
                align-items: center;
                user-select: none;
            }
            .form-check input[type="checkbox"] {
                margin-right: 10px;
                width: 18px;
                height: 18px;
                cursor: pointer;
            }
            .form-check label {
                font-size: 0.95rem;
                color: #444;
                cursor: pointer;
            }
            .button-group {
                margin-top: 25px;
                display: flex;
                justify-content: flex-end;
                gap: 12px;
            }
            .btn {
                padding: 12px 20px;
                border: none;
                border-radius: 6px;
                font-weight: 600;
                font-size: 0.95rem;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .btn-cancel {
                background-color: #f0f0f0;
                color: #555;
                border: 1px solid #ccc;
            }
            .btn-cancel:hover {
                background-color: #e0e0e0;
            }
            .btn-confirm {
                background-color: #007bff;
                color: #ffffff;
            }
            .btn-confirm:hover {
                background-color: #0056b3;
            }
            .btn-confirm:disabled {
                background-color: #a0cffc;
                color: #e0f0ff;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>

        <%-- Kiểm tra null (giữ nguyên) --%>
        <c:if test="${empty paymentDetails}">
            <div class="payment-container" style="text-align: center; padding: 40px;">
                <h2 style="color: #dc3545; margin-bottom: 15px;">Tải dữ liệu thất bại</h2>
                <p style="font-size: 1.1rem; color: #333;">Không thể tải thông tin thanh toán.</p>
                <p style="color: #6c757d; margin-top: 10px;">
                    Nguyên nhân: Không tìm thấy chi tiết yêu cầu thanh toán (biến 'paymentDetails' bị rỗng).
                </p>
                <button onclick="window.location.href = 'courserequest'" class="btn btn-cancel" style="margin-top: 25px; background-color: #007bff; color: white;">
                    Quay lại trang yêu cầu
                </button>
            </div>
        </c:if>

        <%-- Hiển thị form (giữ nguyên) --%>
        <c:if test="${not empty paymentDetails}">
            <div class="payment-container">
                
                <%-- === SỬA ĐỔI FORM (Thêm action="PayServlet" và method="POST") === --%>
                <form id="vnpay-form" class="payment-form" action="PayServlet" method="POST">

                    <%-- === THÊM TRƯỜNG ẨN ĐỂ GỬI ĐI === --%>
                    <input type="hidden" name="action" value="createVnpayUrl">
                    <input type="hidden" name="paymentId" value="${paymentDetails.requestID}">
                    
                    <%-- (Giữ lại trường này cho JavaScript) --%>
                    <input type="hidden" id="payment-id-field" value="${paymentDetails.requestID}">


                    <%-- (Tất cả các .form-group hiển thị giữ nguyên) --%>
                    <div class="form-group">
                        <label for="course-name">Course name</label>
                        <input type="text" id="course-name" value="${paymentDetails.courseName}" disabled>
                    </div>
                    <div class="form-group">
                        <label for="student">Student</label>
                        <input type="text" id="student" value="${paymentDetails.studentName}" disabled>
                    </div>
                    <div class="form-group">
                        <label for="price">Price</label>
                        <fmt:setLocale value="vi_VN"/>
                        <input type="text" id="price" 
                               value="<fmt:formatNumber value="${paymentDetails.coursePrice}" type="currency"/>" disabled>
                    </div>
                    <div class="form-group">
                        <label for="instructor">Instructor</label>
                        <input type="text" id="instructor" value="${paymentDetails.instructorName}" disabled>
                    </div>

                    <div class="terms-section">
                        <h4>Terms & Conditions</h4>
                        <p>By confirming, you agree to pay for this course on behalf of your child.</p>
                        <p>Once approved, the course fee is non-refundable unless the course is canceled by the provider.</p>
                        <p>You can track your child's progress in the Parent Dashboard anytime.</p>
                    </div>

                    <div class="form-check">
                        <input type="checkbox" id="terms-check">
                        <label for="terms-check">I have read and agree to the Terms &Conditions.</label>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-cancel">Cancel</button>
                        <button type="submit" id="confirm-pay-btn" class="btn btn-confirm" disabled>
                            Confirm & Pay
                        </button>
                    </div>
                </form>
            </div>

            <%-- === SỬA ĐỔI JAVASCRIPT (BỎ FETCH) === --%>
            <script>
                // DOM Elements
                const termsCheckbox = document.getElementById('terms-check');
                const confirmButton = document.getElementById('confirm-pay-btn');
                const paymentForm = document.getElementById('vnpay-form');
                const cancelButton = document.querySelector('.btn-cancel');
                
                // (Trường này không cần nữa nhưng để lại cũng không sao)
                const paymentId = document.getElementById('payment-id-field').value; 

                // Logic Checkbox (Giữ nguyên)
                termsCheckbox.addEventListener('change', function () {
                    confirmButton.disabled = !this.checked;
                });

                // === LOGIC SUBMIT MỚI (KHÔNG FETCH) ===
                paymentForm.addEventListener('submit', function (event) {
                    if (!termsCheckbox.checked) {
                        event.preventDefault(); // Ngăn submit nếu chưa check
                        alert("Please agree to the Terms & Conditions first.");
                        return;
                    }
                    
                    // Nếu đã check, form sẽ tự động submit 
                    // (không cần event.preventDefault() hay fetch)
                    confirmButton.textContent = 'Processing...';
                    confirmButton.disabled = true;
                });

                // Logic Cancel (Giữ nguyên)
                cancelButton.addEventListener('click', function () {
                    console.log('Hủy thanh toán');
                    window.location.href = 'CourseRequestServlet';
                });
            </script>
        </c:if>

    </body>
</html>