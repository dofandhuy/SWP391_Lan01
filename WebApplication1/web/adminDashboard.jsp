<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home page</title>
<style>
    /* Cài đặt font chữ và nền cho toàn trang */
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background-color: #f0f2f5; /* Màu nền xám nhạt hiện đại */
        margin: 0;
        padding: 20px;
        color: #333;
    }

    /* Vùng chứa chính, căn giữa nội dung */
    .main-container {
        max-width: 500px;
        margin: 40px auto;
        text-align: center;
    }

    /* Lời chào mừng người dùng */
    .header {
        position: absolute;
        top: 15px;
        left: 25px;
        font-size: 1.1em;
        color: #555;
        font-weight: 500;
    }

    /* Tiêu đề "Trang chủ" */
    h1 {
        color: #0d47a1; /* Màu xanh đậm cho tiêu đề */
        font-size: 2.5em;
        margin-bottom: 30px;
    }

    /* Khung Menu, sử dụng fieldset và legend cho đúng ngữ nghĩa */
    fieldset {
        border: 1px solid #ccc;
        border-radius: 12px; /* Bo góc mềm mại hơn */
        padding: 25px 35px;
        background-color: #ffffff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Thêm hiệu ứng đổ bóng */
        margin-bottom: 30px;
    }

    /* Tiêu đề "Menu" của khung */
    legend {
        padding: 0 10px;
        font-size: 1.4em;
        font-weight: bold;
        color: #333;
        text-align: left;
    }

    /* Style chung cho các nút bấm */
    .btn {
        display: block;
        width: 100%;
        padding: 16px;
        margin-bottom: 15px;
        border: none;
        border-radius: 8px;
        font-size: 1.1em;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease; /* Hiệu ứng chuyển động mượt mà */
    }

    .btn:last-child {
        margin-bottom: 0;
    }

    /* Style cho các nút trong Menu */
    .btn-menu {
        background-color: #e3f2fd; /* Màu xanh dương nhạt */
        color: #1565c0; /* Chữ màu xanh đậm */
    }

    .btn-menu:hover {
        background-color: #bbdefb; /* Màu đậm hơn khi di chuột qua */
        transform: translateY(-3px); /* Hiệu ứng nhấc nút lên */
    }

    /* Style riêng cho nút Đăng xuất */
    .btn-logout {
        background-color: #ffebee; /* Màu đỏ nhạt */
        color: #c62828; /* Chữ màu đỏ đậm */
        max-width: 200px; /* Nút nhỏ hơn và căn giữa */
        margin: 0 auto;
    }

    .btn-logout:hover {
        background-color: #ffcdd2;
        transform: translateY(-3px);
    }
</style>
</head>
<body>
    <%
        // Trong ứng dụng thực tế, bạn sẽ lấy tên người dùng từ session
        // Ví dụ: String username = (String) session.getAttribute("username");
        String username = "Admin";
    %>

    <div class="header">
        <p>Hello, <%= username %></p>
    </div>

    <div class="main-container">
        <h1>Home Page</h1>

        <fieldset>
            <legend>Menu</legend>
            <button class="btn btn-menu" onclick="location.href='courseDashboard.jsp'" type="button">Course Manage</button>
            <button class="btn btn-menu" onclick="location.href='quizDashboard.jsp'" type="button">Quiz Manage</button>
            <button class="btn btn-menu" onclick="location.href='admin/users'" type="button">User Manage</button>
            <button class="btn btn-menu" onclick="location.href='reportDashboard.jsp'" type="button">Report Manage</button>
        </fieldset>

        <button class="btn btn-logout" onclick="location.href='login.jsp'" type="button">Log Out</button>
    </div>

</body>
</html>