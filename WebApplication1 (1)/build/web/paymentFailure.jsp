<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thất bại</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        :root {
            --red-color: #dc3545;
            --light-red-bg: #ffebee;
            --border-red: #ffcdd2;
            --white-color: #ffffff;
            --primary-text: #212529;
            --secondary-text: #6c757d;
            --blue-color: #0d6efd; /* Giữ màu xanh cho nút phụ */
        }

        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 90vh;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }

        .container {
            text-align: center;
            padding: 40px 50px;
            border: 1px solid var(--border-red);
            background-color: var(--white-color);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            width: 100%;
        }

        .icon-failure {
            font-size: 60px;
            color: var(--red-color);
            margin-bottom: 20px;
            display: inline-block;
        }

        h1 {
            color: var(--red-color);
            font-size: 2rem;
            margin-bottom: 15px;
        }

        p {
            color: var(--primary-text);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 10px;
        }

        p.error-code {
            color: #b71c1c; /* Đỏ đậm hơn cho mã lỗi */
            font-weight: 500; /* Không quá đậm */
            margin-top: 15px;
            margin-bottom: 15px; /* Tăng khoảng cách dưới */
            font-size: 0.9rem; /* Nhỏ hơn chút */
            background-color: var(--light-red-bg); /* Nền đỏ nhạt */
            padding: 8px 12px;
            border-radius: 4px;
            display: inline-block; /* Để vừa với nội dung */
        }
        p.error-code strong {
             font-weight: 600; /* Đậm hơn chữ Mã lỗi */
        }


        .btn {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 25px;
            background-color: var(--red-color); /* Nút chính màu đỏ */
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: background-color 0.2s ease;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
        }
        .btn:hover {
            background-color: #c82333; /* Đỏ đậm hơn khi hover */
        }
        .btn-secondary {
             background-color: var(--secondary-text); /* Nút phụ màu xám */
             margin-left: 10px;
        }
         .btn-secondary:hover {
             background-color: #5a6268;
        }

    </style>
</head>
<body>
    <div class="container">
        <span class="material-icons icon-failure">error_outline</span>
        <h1>Thanh toán thất bại! 😥</h1>
        <p>Đã xảy ra lỗi trong quá trình xử lý thanh toán.</p>

        <%-- Hiển thị thông tin lỗi chi tiết hơn nếu có --%>
        <c:if test="${not empty param.errorCode}">
            <p class="error-code">
                Mã lỗi: <strong>${param.errorCode}</strong>
                <c:choose>
                    <c:when test="${param.errorCode == 'INVALID_SIGNATURE'}"> - Lỗi xác thực chữ ký.</c:when>
                    <c:when test="${param.errorCode == 'DB_ERROR'}"> - Lỗi cập nhật cơ sở dữ liệu.</c:when>
                    <c:when test="${param.errorCode == 'INVALID_REQUEST'}"> - Không tìm thấy yêu cầu thanh toán.</c:when>
                    <c:when test="${param.errorCode == 'INVALID_TXNREF'}"> - Mã giao dịch không hợp lệ.</c:when>
                    <c:when test="${param.errorCode == 'UNKNOWN'}"> - Lỗi không xác định.</c:when>
                    <%-- Các mã lỗi khác của VNPAY --%>
                    <c:when test="${param.errorCode == '07'}"> - Trừ tiền thành công. Giao dịch bị nghi ngờ (liên hệ VNPAY).</c:when>
                    <c:when test="${param.errorCode == '09'}"> - Thẻ/Tài khoản chưa đăng ký Internet Banking tại ngân hàng.</c:when>
                    <c:when test="${param.errorCode == '10'}"> - Xác thực thẻ/tài khoản không thành công quá 3 lần.</c:when>
                    <c:when test="${param.errorCode == '11'}"> - Đã hết hạn chờ thanh toán.</c:when>
                    <c:when test="${param.errorCode == '12'}"> - Thẻ/Tài khoản bị khóa.</c:when>
                    <c:when test="${param.errorCode == '13'}"> - Nhập sai mật khẩu xác thực giao dịch (OTP).</c:when>
                    <c:when test="${param.errorCode == '24'}"> - Khách hàng hủy giao dịch.</c:when>
                    <c:when test="${param.errorCode == '51'}"> - Tài khoản không đủ số dư để thực hiện giao dịch.</c:when>
                    <c:when test="${param.errorCode == '65'}"> - Tài khoản đã vượt quá hạn mức giao dịch trong ngày.</c:when>
                    <c:when test="${param.errorCode == '75'}"> - Ngân hàng bảo trì.</c:when>
                    <c:when test="${param.errorCode == '79'}"> - Khách hàng nhập sai mật khẩu thanh toán quá số lần quy định.</c:when>
                    <c:when test="${param.errorCode == '99'}"> - Các lỗi khác (không xác định).</c:when>
                    <c:otherwise> - Mã lỗi từ VNPAY.</c:otherwise>
                </c:choose>
            </p>
        </c:if>

        <p>Vui lòng thử lại hoặc liên hệ bộ phận hỗ trợ nếu cần.</p>

        <%-- Các nút điều hướng --%>
        <div>
            <a href="CourseRequestServlet" class="btn">Thử lại</a> <%-- Link về trang trước đó --%>
            <a href="ParentDashBoard" class="btn btn-secondary">Về Trang chủ</a>
        </div>
    </div>
</body>
</html>