<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>View Certificate</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            /* ==================================== */
            /* CSS TỪ LAYOUT (ModuleDetail) */
            /* ==================================== */
            * {
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, sans-serif;
            }
            body {
                margin: 0;
                display: flex;
                flex-direction: column;
                height: 100vh;
                background-color: #f9fafb; /* Nền xám nhạt */
            }

            /* Header (Giả định từ header.jsp) */
            header {
                width: 100%;
                height: 60px;
                background-color: #fff;
                border-bottom: 1px solid #ddd;
            }

            /* Main container */
            .main-container {
                flex: 1;
                display: flex;
                height: calc(100vh - 60px);
            }

            /* Sidebar (Giả định từ sidebar_student.jsp) */
            .module-sidebar { /* Đổi tên class này thành .sidebar-container nếu bạn dùng chung 1 layout */
                width: 260px;
                background-color: #fff;
                border-right: 1px solid #ddd;
                padding: 20px;
                overflow-y: auto;
            }

            /* Content area */
            .content-area {
                flex: 1;
                display: flex;
                flex-direction: column; /* Cho phép action-bar và cert-container xếp chồng */
                background-color: #f9fafb;
                overflow-y: auto;
                padding: 20px;
            }

            /* ==================================== */
            /* CSS MỚI CHO TRANG CERTIFICATE */
            /* ==================================== */

            .cert-page-container {
                width: 100%;
                max-width: 1000px; /* Giới hạn chiều rộng */
                margin: 0 auto; /* Căn giữa */
            }

            /* -- THÊM CSS CHO NÚT BACK -- */
            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background-color: #e8f0fe;
                color: #1a73e8;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: 0.2s;
                margin-bottom: 20px; /* Đã có margin-bottom */
            }
            .back-btn:hover {
                background-color: #d2e3fc;
            }
            /* -- HẾT CSS NÚT BACK -- */

            .cert-page-container h1 {
                font-size: 2rem;
                color: #222;
                margin-bottom: 20px;
            }

            /* Thanh chứa các nút Download/Share */
            .action-bar {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-bottom: 20px;
            }

            .action-bar .btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                border-radius: 6px;
                font-size: 0.9rem;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                transition: background-color 0.2s ease;
            }

            .btn-download {
                background-color: #0056d2;
                color: #ffffff;
                border: 1px solid #0056d2;
            }
            .btn-download:hover {
                background-color: #0041a3;
            }

            .btn-share {
                background-color: #fff;
                color: #333;
                border: 1px solid #ccc;
            }
            .btn-share:hover {
                background-color: #f8f8f8;
            }


            /* Khung chứng chỉ */
            .certificate-wrapper {
                background-color: #ffffff;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                padding: 40px 50px;
                text-align: center;
            }

            /* Khung viền trang trí bên trong */
            .certificate-border {
                border: 3px double #0041a3; /* Viền double */
                padding: 25px;
                background-color: #fcfdff; /* Nền hơi xanh nhạt */
            }

            .cert-logo {
                font-size: 4rem;
                color: #ffd700; /* Màu vàng */
                margin-bottom: 20px;
            }

            .cert-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #1c1e21;
                margin-bottom: 20px;
            }

            .cert-subtitle {
                font-size: 1.1rem;
                color: #555;
                margin-bottom: 10px;
            }

            .student-name {
                font-family: 'Georgia', 'Times New Roman', serif; /* Font trang trọng */
                font-size: 3rem;
                font-weight: bold;
                color: #0056d2;
                margin: 20px 0;
            }

            .course-name {
                font-size: 1.75rem;
                font-weight: 600;
                color: #333;
                margin: 20px 0;
            }

            /* Đường kẻ ngang */
            .divider {
                width: 80%;
                height: 1px;
                background-color: #ccc;
                margin: 30px auto;
            }

            /* Khu vực chữ ký và ngày tháng */
            .cert-footer {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-top: 30px;
                text-align: left;
            }

            .footer-item {
                width: 45%;
            }

            .footer-item strong {
                font-size: 1rem;
                color: #333;
                display: block;
            }

            .footer-item span {
                font-size: 0.9rem;
                color: #666;
            }

            .signature-line {
                border-top: 1px solid #555;
                margin-top: 25px;
                padding-top: 5px;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container">


            <div class="content-area">

                <div class="cert-page-container">

                    <button class="back-btn" onclick="history.back()">← Back to Course</button>

                    <h1>Certificate of Completion</h1>

                    <div class="action-bar">
                        <a href="DownloadCertificateServlet?certId=${certificate.id}" class="btn btn-download">
                            <i class="fa-solid fa-download"></i>
                            Download
                        </a>
                        <button class="btn btn-share">
                            <i class="fa-solid fa-share-nodes"></i>
                            Share
                        </button>
                    </div>

                    <div class="certificate-wrapper">
                        <div class="certificate-border">

                            <div class="cert-logo">
                                <i class="fa-solid fa-award"></i>
                            </div>

                            <h2 class="cert-title">Certificate of Completion</h2>

                            <p class="cert-subtitle">PRESENTED TO</p>

                            <h3 class="student-name">${student.fullName}</h3>

                            <p class="cert-subtitle">For successfully completing the course</p>

                            <h4 class="course-name">${course.title}</h4>

                            <div class="divider"></div>

                            <div class="cert-footer">
                                <div class="footer-item">
                                    <strong>Date Completed</strong>
                                    <span>
                                        <%-- Định dạng ngày tháng cho đẹp --%>
                                        <fmt:formatDate value="${certificate.completionDate}" pattern="MMMM dd, yyyy" />
                                    </span>
                                </div>
                                <div class="footer-item" style="text-align: right;">
                                    <strong>Instructor</strong>
                                    <div class="signature-line">
                                        <span>${course.instructorName}</span>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </div>
    </body>
</html>