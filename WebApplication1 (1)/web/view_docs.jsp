<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Important Notice</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            /* CSS nội tuyến */
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #ffffff;
                color: #2d2f31; /* Màu chữ đen mờ */
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                min-height: 100vh;
            }

            /* Container chính để giới hạn chiều rộng và căn giữa */
            .notice-container {
                max-width: 900px;
                width: 100%;
                margin-top: 40px;
            }

            /* Tiêu đề */
            .notice-container h1 {
                font-size: 2.5rem; /* 40px */
                font-weight: 700;
                line-height: 1.2;
                margin-bottom: 40px;
                color: #1c1e21; /* Màu chữ đen đậm hơn 1 chút */
            }

            /* Khung chứa nội dung bullet list */
            .notice-content {
                /* không cần style đặc biệt */
            }

            .notice-content ul {
                list-style-type: disc; /* Dấu chấm tròn đen */
                padding-left: 25px; /* Thụt lề cho list */
                margin: 0;
            }

            .notice-content li {
                font-size: 1rem; /* 16px */
                line-height: 1.6;
                margin-bottom: 20px; /* Khoảng cách giữa các mục */
                padding-left: 10px; /* Khoảng cách giữa dấu chấm và chữ */
            }

            /* Link email */
            .notice-content a {
                color: #0056d2; /* Màu xanh dương */
                text-decoration: none;
                font-weight: 600;
            }
            .notice-content a:hover {
                text-decoration: underline;
            }

            /* Thanh hành động (chứa nút bấm và status) */
            .action-bar {
                display: flex;
                align-items: center;
                gap: 20px; /* Khoảng cách giữa nút và chữ "Completed" */
                margin-top: 40px;
            }

            /* Nút "Go to next item" */
            .btn-next {
                background-color: #00ADC3; /* Màu xanh dương */
                color: #ffffff;
                border: none;
                padding: 12px 24px;
                border-radius: 6px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }
            .btn-next:hover {
                background-color: #0041a3;
            }

            /* Trạng thái "Completed" */
            .status-completed {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #006400; /* Màu xanh lá cây đậm */
                font-weight: 600;
                font-size: 1rem;
            }
            .status-completed .icon {
                font-size: 1.2rem; /* Cho icon to hơn chữ một chút */
            }

            /* Đường kẻ ngang mờ ở cuối */
            hr {
                border: 0;
                height: 1px;
                background-color: #e0e0e0;
                margin-top: 40px;
            }

        </style>
    </head>
    <body>

        <div class="notice-container">
            <h1>Important notice for Ready, Set, Future learners</h1>

            <div class="notice-content">
                <ul>
                    <li>Nội dung docs ....</li>
                    <li>IFTF will never request personal information such as phone numbers or encourage engagement in external groups on platforms like WhatsApp or others.</li>
                    <li>Be cautious when interacting with other learners outside of the Coursera platform. Any external communication is at your own discretion and risk--please evaluate carefully.</li>
                    <li>If you notice any suspicious posts in the discussion forums requesting learners to click on links or join external groups, please let us know at <a href="mailto:info@iftf.org">info@iftf.org</a>.</li>
                </ul>
            </div>

            <div class="action-bar">
                <button class="btn-next">Go to next item</button>
                <div class="status-completed">
                    <i class="fa-solid fa-check-circle icon"></i>
                    <span>Completed</span>
                </div>
            </div>

            <hr>

        </div>

    </body>
</html>