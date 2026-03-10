<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        :root {
            --green-color: #198754;
            --light-green-bg: #e8f5e9;
            --border-green: #c8e6c9;
            --white-color: #ffffff;
            --primary-text: #212529;
            --secondary-text: #6c757d;
            --blue-color: #0d6efd;
        }

        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 90vh; /* Tăng chiều cao */
            background-color: #f8f9fa; /* Nền xám nhạt hơn */
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }

        .container {
            text-align: center;
            padding: 40px 50px; /* Tăng padding */
            border: 1px solid var(--border-green);
            background-color: var(--white-color); /* Nền trắng */
            border-radius: 12px; /* Bo góc nhiều hơn */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* Đổ bóng rõ hơn */
            max-width: 500px;
            width: 100%;
        }

        .icon-success {
            font-size: 60px; /* To hơn */
            color: var(--green-color);
            margin-bottom: 20px;
            display: inline-block; /* Để căn giữa */
        }

        h1 {
            color: var(--green-color);
            font-size: 2rem; /* To hơn */
            margin-bottom: 15px;
        }

        p {
            color: var(--primary-text);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 10px;
        }

        .btn {
            display: inline-block;
            margin-top: 25px; /* Tăng khoảng cách */
            padding: 12px 25px; /* Tăng padding */
            background-color: var(--blue-color);
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
            background-color: #0b5ed7; /* Màu xanh đậm hơn khi hover */
        }
        .btn-secondary {
             background-color: var(--secondary-text);
             margin-left: 10px; /* Khoảng cách giữa 2 nút */
        }
         .btn-secondary:hover {
             background-color: #5a6268;
        }


    </style>
</head>
<body>
    <div class="container">
        <span class="material-icons icon-success">check_circle</span>
        <h1>Thanh toán thành công! 🎉</h1>
        <p>Giao dịch của bạn đã được xử lý thành công.</p>
        <p>Khóa học đã được ghi danh cho học viên.</p>
        <p>Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ của chúng tôi.</p>

        <%-- Các nút điều hướng --%>
        <div>
            <a href="ParentDashBoard" class="btn">Về Trang chủ Phụ huynh</a>
            <%-- Tùy chọn: Thêm nút xem chi tiết giao dịch hoặc khóa học --%>
            <%-- <a href="viewMyCoursesServlet" class="btn btn-secondary">Xem khóa học của con</a> --%>
        </div>
    </div>
</body>
</html>