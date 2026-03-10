<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Lấy URI để xác định trang hiện tại --%>
<c:set var="pagePath" value="${pageContext.request.requestURI}" />
<c:set var="pageName" value="${pagePath.substring(pagePath.lastIndexOf('/') + 1)}" />

<!DOCTYPE html>
<html lang="vi">
    <head>

        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LMS - Parent Dashboard</title>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                background-color: #fafafa;
                color: #333;
                font-size: 14px;
            }

            .lms-container {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Header */
            .lms-header {
                display: flex;
                align-items: center;
                padding: 15px 30px;
                border-bottom: 1px solid #eee;
                background-color: #fff;
            }

            .logo {
                font-size: 24px;
                font-weight: bold;
                color: #333;
                width: 250px;
                margin-right: 50px;
            }

            .search-bar {
                flex-grow: 1;
                display: flex;
                justify-content: center;
            }

            .search-bar input {
                width: 400px;
                padding: 8px 15px;
                border: 1px solid #ddd;
                border-radius: 20px;
                outline: none;
            }

            .header-icons {
                display: flex;
                align-items: center;
                margin-left: auto;
            }

            .header-icons .material-icons {
                font-size: 24px;
                color: #555;
                cursor: pointer;
                margin-left: 20px;
            }

            /* Layout */
            .main-content-area {
                display: flex;
                flex-grow: 1;
            }

            /* Sidebar */
            .lms-sidebar {
                width: 250px;
                border-right: 1px solid #eee;
                padding-top: 20px;
                background-color: #fff;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .lms-sidebar nav ul {
                list-style: none;
            }

            .lms-sidebar nav ul li a {
                display: flex;
                align-items: center;
                padding: 12px 30px;
                text-decoration: none;
                color: #333;
                font-weight: 500;
                transition: background-color 0.2s;
                position: relative;
            }

            /* CẬP NHẬT: Đảm bảo icon có màu mặc định */
            .lms-sidebar nav ul li a i {
                color: #555; /* Icon màu xám mặc định */
                margin-right: 15px;
                font-size: 18px;
            }

            /* CẬP NHẬT MỚI: Màu sắc active (nền trắng/trong suốt, chữ và icon nổi bật) */
            .lms-sidebar nav ul li a.active {
                background-color: transparent; /* Nền trắng, không có màu xám/xanh nhạt */
                color: #222; /* Chữ đen đậm */
                font-weight: bold;
            }

            /* CẬP NHẬT MỚI: Đặt màu icon cho trạng thái Active (màu xanh chủ đạo) */
            .lms-sidebar nav ul li a.active i {
                color: #0056d2; /* Icon màu xanh đậm */
            }

            /* THÊM MỚI: Thanh dọc bên trái (Active indicator) */
            .lms-sidebar nav ul li a.active::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 4px; /* Độ dày của thanh dọc */
                background-color: #0056d2; /* Màu xanh đậm */
                border-radius: 0 4px 4px 0;
            }

            /* XỬ LÝ HOVER: Giữ cho hover vẫn hoạt động trên các item không active */
            .lms-sidebar nav ul li a:hover:not(.active) {
                background-color: #f0f4f8; /* Nền xám nhạt cho hover */
                color: #333;
                font-weight: 500;
            }

            .logout {
                padding: 20px 30px;
                text-decoration: none;
                color: #333;
                border-top: 1px solid #eee;
                font-weight: 500;
                display: flex;
                align-items: center;
            }

            .logout:hover {
                background-color: #f9f9f9;
            }

            /* Content */
            .lms-content {
                flex-grow: 1;
                padding: 30px;
                background-color: #fafafa;
            }

            .lms-content h1 {
                font-size: 26px;
                font-weight: 600;
                margin-bottom: 25px;
            }

            /* Table */
            .widget-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #222;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 8px;
                overflow: hidden;
                margin-bottom: 40px;
            }

            th, td {
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
                text-align: left;
            }

            th {
                background-color: #f4f6f8;
                font-weight: 600;
            }

            tr:hover {
                background-color: #f9f9f9;
            }

            .no-data {
                text-align: center;
                color: #777;
                padding: 15px 0;
            }

            /* Status label */
            .status {
                padding: 4px 10px;
                border-radius: 12px;
                font-weight: 500;
                font-size: 13px;
            }

            .status.pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status.approved {
                background-color: #d4edda;
                color: #155724;
            }

            .status.rejected {
                background-color: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>

    <body>
        <div class="lms-container">
            <div class="main-content-area">

                <%-- MÃ GỠ LỖI (DEBUG) TẠM THỜI (Xóa dòng này nếu không cần gỡ lỗi nữa) --%>
                <%-- <c:if test="${!empty pageName}">
                    <div style="position: absolute; top: 10px; left: 300px; padding: 5px; background: yellow; color: black; z-index: 9999;">
                        DEBUG: Tên trang hiện tại JSTL thấy là: <b>${pageName}</b>
                    </div>
                </c:if> --%>

                <aside class="lms-sidebar">
                    <nav>
                        <ul>
                            <%-- 1. Dashboard --%>
                            <li>
                                <a href="StudentDashboardServlet" 
                                   class="${pageName == 'StudentDashboardServlet' || pageName == '' ? 'active' : ''}">
                                    <i class="fa-solid fa-house-chimney"></i> Dashboard
                                </a>
                            </li>

                            <%-- 2. My Learning --%>
                            <li>
                                <a href="MyLearningServlet"
                                   class="${pageName == 'MyLearningServlet' ? 'active' : ''}">
                                    <i class="fa-solid fa-user-graduate"></i> My Learning
                                </a>
                            </li>

                            <%-- 3. Explore --%>
                            <li>
                                <a href="CourseCatalogServlet"
                                   class="${pageName == 'CourseCatalogServlet' ? 'active' : ''}">
                                    <i class="fa-solid fa-book-open"></i> Explore
                                </a>
                            </li>
                        </ul>
                    </nav>
                    <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i> Log Out</a>
                </aside>


            </div>
        </div>
    </body>
</html>