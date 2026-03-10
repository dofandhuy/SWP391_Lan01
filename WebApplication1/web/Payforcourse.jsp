<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Thanh toán</title>
    
    <%-- 
      ===============================================================
      == GIỮ NGUYÊN TOÀN BỘ PHẦN <style>...<style> CỦA BẠN TẠI ĐÂY ==
      ===============================================================
    --%>
    <style>
        /* ============================
           STYLES CHUNG
           ============================ */
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

        /* ... (Toàn bộ CSS khác của bạn) ... */
        
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

    <div class="payment-container">
        <form id="vnpay-form" class="payment-form">
            
            <input type="hidden" id="payment-id-field" value="${paymentDetails.paymentID}">

            <div class="form-group">
                <label for="course-name">Course name</label>
                <input type="text" id="course-name" value="${paymentDetails.courseTitle}" disabled>
            </div>
            <div class="form-group">
                <label for="student">Student</label>
                <input type="text" id="student" value="${paymentDetails.studentName}" disabled>
            </div>
            <div class="form-group">
                <label for="price">Price</label>
                <fmt:setLocale value="vi_VN"/>
                <input type="text" id="price" 
                       value="<fmt:formatNumber value="${paymentDetails.amount}" type="currency"/>" disabled>
            </div>
            <div class="form-group">
                <label for="duration">Duration</label>
                <input type="text" id="duration" value="${paymentDetails.courseDuration}" disabled>
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

    <script>
        // DOM Elements (Giữ nguyên)
        const termsCheckbox = document.getElementById('terms-check');
        const confirmButton = document.getElementById('confirm-pay-btn');
        const paymentForm = document.getElementById('vnpay-form');
        const cancelButton = document.querySelector('.btn-cancel');
        
        // CẬP NHẬT: Lấy PaymentID từ trường ẩn
        const paymentId = document.getElementById('payment-id-field').value;

        // Logic Checkbox (Giữ nguyên)
        termsCheckbox.addEventListener('change', function() {
            confirmButton.disabled = !this.checked;
        });

        // Logic Submit (Giữ nguyên logic 'fetch', nhưng cập nhật URL và body)
        paymentForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Giữ nguyên: Ngăn form submit
            if (!termsCheckbox.checked) {
                alert("Please agree to the Terms & Conditions first.");
                return;
            }

            confirmButton.textContent = 'Processing...';
            confirmButton.disabled = true;

            // --- BẮT ĐẦU KHỐI FETCH ĐÃ CẬP NHẬT ---
            // Chúng ta sẽ gọi servlet 'payment'
            fetch('payment', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                // CẬP NHẬT: Gửi ID thanh toán dưới dạng JSON
                body: JSON.stringify({ 
                    action: 'createVnpayUrl',
                    paymentId: paymentId // Lấy từ trường ẩn
                }) 
            })
            .then(response => response.json()) // Mong đợi phản hồi JSON
            .then(data => {
                // Servlet sẽ trả về JSON có key là 'paymentUrl'
                if (data.paymentUrl) {
                    // 3. Nhận URL và chuyển hướng người dùng đến VNPAY
                    window.location.href = data.paymentUrl;
                } else {
                    // Xử lý lỗi từ server (nếu có)
                    alert(data.error || 'Error creating payment URL.');
                    confirmButton.textContent = 'Confirm & Pay';
                    confirmButton.disabled = false; // Kích hoạt lại nút nếu lỗi
                }
            })
            .catch(error => {
                // Xử lý lỗi mạng
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
                confirmButton.textContent = 'Confirm & Pay';
                confirmButton.disabled = false;
            });
            // --- KẾT THÚC KHỐI FETCH ---
        });

        // Logic Cancel (Cập nhật để quay về trang request)
        cancelButton.addEventListener('click', function() {
            console.log('Hủy thanh toán');
            // Quay lại trang danh sách request
            window.location.href = 'courserequest'; 
        });
    </script>

</body>
</html>