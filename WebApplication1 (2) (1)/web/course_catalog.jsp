<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Khám Phá Khóa Học</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            /* CÁC STYLE KHÔNG THAY ĐỔI (RESET, CARD, PAGINATION) */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                background-color: #f5f5f5;
                color: #333;
                display: flex; /* MỚI */
                flex-direction: column; /* MỚI */
                min-height: 100vh; /* MỚI */
            }
            .page-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 15px;
            }

            /* LAYOUT MỚI */
            .main-layout {
                display: flex;
                flex: 1;
                width: 100%;
            }
            .sidebar-container {
                width: 250px;
                flex-shrink: 0;
                background: #fff;
                border-right: 1px solid #eee;
            }
            .content-wrapper {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                background-color: #f5f5f5; /* Giữ nền của content area */
            }
            .content-main {
                flex-grow: 1;
                padding: 30px; /* Padding chính cho nội dung */
                max-width: 100%;
                margin: 0 auto;
            }
            /* End LAYOUT MỚI */


            /* Breadcrumb Bar (Điều chỉnh) */
            .breadcrumb-bar {
                background-color: white;
                color: black;
                padding: 15px 0;
                margin-bottom: 0; /* Loại bỏ margin để dễ kiểm soát hơn */
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .breadcrumb {
                width: 100%;
                padding: 0 30px; /* Padding ngang cho breadcrumb */
                font-size: 16px;
                font-weight: 500;
                /* Bỏ max-width: 1200px; margin: 0 auto; vì đã dùng Flexbox */
            }
            .breadcrumb a {
                color: black;
                text-decoration: none;
                opacity: 0.8;
                transition: opacity 0.2s;
            }
            .breadcrumb a:hover {
                opacity: 1;
            }
            .breadcrumb span {
                margin: 0 8px;
                opacity: 0.6;
            }

            /* Course Grid */
            .course-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                padding-bottom: 30px; /* Điều chỉnh padding */
            }
            /* Course Item (Khóa học) */
            .course-card {
                display: flex;
                gap: 15px;
                align-items: center;
                margin-bottom: 20px;
                background-color: #f8fafc;
                border-radius: 12px;
                padding: 10px;
            }
            .course-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            /*            .course-image-container {
                            background-color: #00ADC3;
                            padding: 15px;
                        }*/
            .course-image {
                width: 100px;
                height: 70px;
                object-fit: cover;
                border-radius: 8px;
            }
            .course-info {
                flex: 1;
            }
            .course-name {
                font-size: 16px;
                font-weight: 600;
                color: #0056d2;
                margin-bottom: 5px;
            }
            .course-description {
                font-size: 13px;
                color: #777;
            }

            /* Pagination */
            .pagination {
                text-align: center;
                padding: 20px 0;
                font-size: 15px;
            }
            .pagination a {
                color: #0056d2;
                text-decoration: none;
                padding: 5px 10px;
                margin: 0 2px;
                border-radius: 4px;
                transition: background-color 0.2s;
            }
            .pagination a:hover {
                background-color: #e6f7ff;
            }
            .pagination .current {
                font-weight: bold;
                color: #333;
            }
            .pagination .disabled {
                color: #ccc;
                pointer-events: none;
            }
        </style>
    </head>
    <body>

        <jsp:include page="header.jsp" /> 

        <div class="main-layout">

            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <div class="content-wrapper">

                <div class="breadcrumb-bar">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/">Home</a>
                        <span>&gt;</span>
                        Category name
                    </div>
                </div>

                <div class="content-main">

                    <div class="course-grid">
                        <c:choose>
                            <c:when test="${not empty courses}">
                                <c:forEach var="course" items="${courses}">
                                    <div class="course-card">
                                        <div class="course-image-container">
                                            <a href="CourseDetailServlet_1?id=${course.courseID}">
                                                <img src="${course.thumbnail != null ? course.thumbnail : 'image/course.jpg'}" 
                                                     alt="${course.title} Illustration" 
                                                     class="course-image">
                                            </a>
                                        </div>
                                        <div class="course-info">
                                            <a href="CourseDetailServlet_1?id=${course.courseID}">
                                                <div class="course-name">${course.title}</div>
                                            </a>
                                            <div class="course-description">${course.description}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="grid-column: 1 / -1; text-align: center; padding: 50px;">
                                    Không có khóa học nào được tìm thấy.
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="pagination">
                        <a href="#" class="disabled">«</a>
                        <a href="#" class="current">1</a>
                        <a href="#">2</a>
                        <a href="#">3</a>
                        <a href="#">...</a>
                        <a href="#">»</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>