<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Learning</title>
        <style>
            /* (GIỮ NGUYÊN CSS CỦA BẠN CHO BỐ CỤC VÀ STYLE) */
            body {
                font-family: Arial;
                margin: 0;
                background: #f9f9f9;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            header {
                background: #0056d2;
                color: white;
                padding: 16px;
                text-align: center;
                display: none;
            }

            /* --- CSS cho Bố cục Toàn trang (Sidebar và Nội dung) --- */
            .main-layout {
                display: flex;
                flex: 1;
            }
            .sidebar-container {
                width: 250px;
                flex-shrink: 0;
                background: white;
                box-shadow: 2px 0 5px rgba(0,0,0,0.05);
                padding-top: 20px;
            }
            .content-area {
                flex-grow: 1;
                padding: 20px;
                overflow-y: auto;
            }
            .tab-bar {
                justify-content: flex-start;
                background: none;
                padding: 0 0 10px 0;
            }
            .course-container {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 6px rgba(0,0,0,0.1);
                margin-top: 20px;
                max-width: none;
                margin: 0;
                /* Thêm thuộc tính ẩn mặc định */
                display: block;
            }
            /* Thêm style cho thông báo không có khóa học */
            .empty-message {
                text-align: center;
                padding: 40px;
                color: #777;
                font-size: 1.1em;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 0 6px rgba(0,0,0,0.1);
            }

            /* GIỮ NGUYÊN CÁC STYLE CÒN LẠI */
            .tab {
                margin: 0 10px 0 0;
            }
            .tab.active {
                background: #0056d2;
                color: white;
            }
            .sub-course {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px solid #ddd;
            }
            .sub-left {
                display: flex;
                gap: 15px;
            }
            .sub-left img {
                width: 90px;
                height: 90px;
                object-fit: cover;
                border-radius: 10px;
            }
            .sub-text h3 {
                margin: 0;
                font-size: 18px;
                color: #222;
            }
            .progress-bar {
                background: #eee;
                height: 8px;
                width: 100%;
                border-radius: 5px;
                margin: 6px 0;
            }
            .progress {
                height: 8px;
                background: #00BCD4;
                border-radius: 5px;
            }
            .get-started-btn {
                background: #00BCD4;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
            }
            .get-started-btn:hover {
                background: #003c99;
            }
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />    

        <div class="main-layout">
            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <div class="content-area">
                <h2>My FPTU Fall 2025 Learning</h2> 

                <div class="tab-bar">
                    <a href="MyLearningServlet?tab=inprogress" class="tab ${tab=='inprogress'?'active':''}">In Progress</a>
                    <a href="MyLearningServlet?tab=completed" class="tab ${tab=='completed'?'active':''}">Completed</a>
                </div>

                <div class="course-container">
                    <%-- Khởi tạo biến đếm khóa học được hiển thị --%>
                    <c:set var="visibleCount" value="${0}" scope="page" />

                    <c:forEach var="c" items="${courses}">

                        <c:choose>
                            <%-- 1. Tab đang chọn là "In Progress" VÀ tiến độ < 100% --%>
                            <c:when test="${tab == 'inprogress' && c.progress < 100}">
                                <c:set var="visibleCount" value="${visibleCount + 1}" scope="page" />

                                <div class="sub-course">
                                    <div class="sub-left">
                                        <img src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d" alt="${c.title}">
                                        <div class="sub-text">
                                            <h3>${c.title}</h3>
                                            <p style="font-size:13px; color:#555;">${c.description}</p>
                                            <div>Progress: ${c.progress}%</div>
                                            <div class="progress-bar"><div class="progress" style="width:${c.progress}%;"></div></div>
                                        </div>
                                    </div>
                                    <div>
                                        <button class="get-started-btn" >Continue</button>
                                    </div>
                                </div>

                            </c:when>

                            <%-- 2. Tab đang chọn là "Completed" VÀ tiến độ >= 100% --%>
                            <c:when test="${tab == 'completed' && c.progress >= 100}">
                                <c:set var="visibleCount" value="${visibleCount + 1}" scope="page" />

                                <div class="sub-course">
                                    <div class="sub-left">
                                        <img src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d" alt="${c.title}">
                                        <div class="sub-text">
                                            <h3>${c.title}</h3>
                                            <p style="font-size:13px; color:#555;">${c.description}</p>
                                            <div>Progress: ${c.progress}% (Completed)</div>
                                            <div class="progress-bar"><div class="progress" style="width:100%;"></div></div>
                                        </div>
                                    </div>
                                    <div>
                                        <button class="get-started-btn">Review</button>
                                    </div>
                                </div>

                            </c:when>

                        </c:choose>

                    </c:forEach>

                    <%-- Thông báo nếu không có khóa học nào khớp với tab hiện tại --%>
                    <c:if test="${visibleCount == 0}">
                        <div class="empty-message">
                            <c:choose>
                                <c:when test="${tab == 'inprogress'}">
                                    Bạn chưa có khóa học nào đang tiến hành.
                                </c:when>
                                <c:when test="${tab == 'completed'}">
                                    Bạn chưa hoàn thành khóa học nào. Hãy bắt đầu học ngay!
                                </c:when>
                                <c:otherwise>
                                    Không có khóa học nào được tìm thấy.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
    </body>
</html>