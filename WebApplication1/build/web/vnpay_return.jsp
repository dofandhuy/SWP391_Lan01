<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .result-box {
            background: #fff;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.1);
            width: 450px;
            text-align: center;
        }
        h2 {
            color: #007bff;
        }
        .success {
            color: green;
            font-weight: 600;
        }
        .fail {
            color: red;
            font-weight: 600;
        }
        .info {
            margin-top: 20px;
            text-align: left;
            color: #444;
        }
        a {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            background: #007bff;
            color: #fff;
            padding: 10px 16px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        a:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
<div class="result-box">
    <h2>Kết quả thanh toán</h2>

    <% String msg = (String) request.getAttribute("msg"); %>
    <% if (msg != null) { %>
        <p class="<%= msg.contains("thành công") ? "success" : "fail" %>"><%= msg %></p>
    <% } else { %>
        <p class="fail">Không nhận được kết quả thanh toán.</p>
    <% } %>

    <div class="info">
        <p><b>Mã giao dịch:</b> <%= request.getParameter("vnp_TxnRef") %></p>
        <p><b>Số tiền:</b> <%= request.getParameter("vnp_Amount") != null ? (Integer.parseInt(request.getParameter("vnp_Amount")) / 100) + " VNĐ" : "" %></p>
        <p><b>Mã phản hồi:</b> <%= request.getParameter("vnp_ResponseCode") %></p>
        <p><b>Thời gian:</b> <%= request.getParameter("vnp_PayDate") %></p>
    </div>

    <a href="vnpay_payment.jsp">← Quay lại trang thanh toán</a>
</div>
</body>
</html>
