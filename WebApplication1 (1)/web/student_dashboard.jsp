<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>LMS Dashboard</title>
        <style>
            /* (Giữ nguyên toàn bộ CSS của bạn) */

            * {
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
            }
            body {
                background-color: #f3f6fa;
                color: #333;
            }

            /* Header */
            header {
                background-color: #00bcd4;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 40px;
                color: #fff;
            }
            .logo {
                font-size: 24px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .logo i {
                font-size: 22px;
            }
            .search-box {
                width: 40%;
                position: relative;
            }
            .search-box input {
                width: 100%;
                padding: 10px 40px 10px 15px;
                border-radius: 20px;
                border: none;
                outline: none;
                font-size: 14px;
            }
            .user-icon {
                font-size: 22px;
                background: #fff;
                color: #00bcd4;
                padding: 8px;
                border-radius: 50%;
                cursor: pointer;
            }

            /* ==================================== */
            /* BỐ CỤC MỚI: Sidebar và Nội dung Chính */
            /* Để fix lỗi layout, ta cần thêm display:flex hoặc display:grid cho body hoặc wrapper */
            body {
                /* Cần thiết lập flex/grid cho body nếu header không nằm trong main-layout */
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Container bọc Sidebar và Main Content */
            .main-layout {
                display: grid;
                grid-template-columns: 250px 1fr;
                flex-grow: 1; /* Cho phép nó mở rộng hết chiều cao còn lại */
            }

            /* Sidebar styles */
            .main-layout > .sidebar-container {
                background: #fff;
                box-shadow: 2px 0 5px rgba(0,0,0,0.05);
                padding: 20px 0;
            }

            /* Vùng chứa toàn bộ nội dung của Dashboard */
            .dashboard-content {
                padding: 10px 20px;
            }

            /* Điều chỉnh lại các container con */
            .container {
                width: 100%;
                max-width: 1300px;
                margin: 10px 0;
                display: grid;
                grid-template-columns: 1.1fr 1fr;
                gap: 20px;
            }

            .full-section {
                width: 100%;
                max-width: 1300px;
                margin: 20px 0;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
            }
            /* ==================================== */

            .section {
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
            }
            .section h2 {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 15px;
            }

            /* Continue Learning */
            .course-card {
                display: flex;
                gap: 15px;
                align-items: center;
                margin-bottom: 20px;
                background-color: #f8fafc;
                border-radius: 12px;
                padding: 10px;
            }
            .course-card img {
                width: 100px;
                height: 70px;
                object-fit: cover;
                border-radius: 8px;
            }
            .course-info {
                flex: 1;
            }
            .course-info h3 {
                font-size: 16px;
                font-weight: 600;
            }
            .course-info p {
                font-size: 13px;
                color: #666;
                margin: 5px 0;
            }
            .progress-bar {
                height: 8px;
                width: 100%;
                background: #e0e0e0;
                border-radius: 10px;
                margin: 8px 0;
                overflow: hidden;
            }
            .progress {
                height: 8px;
                background: #00bcd4;
                width: 0%;
            }
            .resume-btn {
                background-color: #00bcd4;
                border: none;
                color: #fff;
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 13px;
                cursor: pointer;
            }

            /* Right column sections */
            .small-courses {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
            }
            .small-card {
                background: #e8eefc;
                border-radius: 10px;
                text-align: center;
                padding: 10px;
            }
            .small-card img {
                width: 100%;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
            }
            .small-card h4 {
                font-size: 14px;
                margin-top: 8px;
            }
            .small-card p {
                font-size: 12px;
                color: #666;
            }
            .course-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }
            .course-grid .small-card {
                background: #e8eefc;
            }
        </style>
    </head>
    <body>

        <c:set var="root" value="${pageContext.request.contextPath}"/>

        <jsp:include page="header.jsp" />

        <div class="main-layout">

            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <div class="dashboard-content">

                <div class="container">
                    <div class="section">
                        <h2>Continue Learning</h2>
                        <c:forEach var="c" items="${continueLearning}">
                            <div class="course-card">

                                <%-- VỊ TRÍ 1: Continue Learning --%>
                                <img src="${c.thumbnail != null ? c.thumbnail : root}/image/course.jpg" alt="course">

                                <div class="course-info">
                                    <h3><a href="CourseDetailServlet_1?id=${c.courseID}" style="text-decoration:none; color:#333;">
                                            ${c.title}
                                        </a></h3>
                                    <p>${c.description}</p>
                                    <div class="progress-bar">
                                        <div class="progress" style="width: ${c.progress}%;"></div>
                                    </div>
                                    <p>End on Dec 1, 2025</p>
                                </div>
                                <form action="${root}/ResumeServlet" method="post">
                                    <input type="hidden" name="courseId" value="${c.courseID}" />
                                    <button class="resume-btn" type="submit">Resume</button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>


                    <div class="section">
                        <h2>Recently Viewed</h2>
                        <div class="small-courses">
                            <c:forEach var="c" items="${recentlyViewed}">
                                <div class="small-card">
                                    <img src="${c.thumbnail != null ? c.thumbnail : root}/image/course.jpg" alt="course">
                                    <h4><a href="CourseDetailServlet_1?id=${c.courseID}">${c.title}</a></h4>
                                    <p>${c.description}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="full-section">
                    <h2>Most Popular Courses/Certificates</h2>
                    <div class="course-grid">
                        <c:if test="${not empty mostPopular}">
                            <c:forEach var="c" items="${mostPopular}">
                                <div class="small-card">

                                    <%-- VỊ TRÍ 3: Most Popular --%>
                                    <img src="${c.thumbnail != null ? c.thumbnail : root}/image/course.jpg" alt="course">

                                    <h4><a href="CourseDetailServlet_1?id=${c.courseID}" style="text-decoration:none; color:#333;">
                                            ${c.title}
                                        </a></h4>
                                    <p>${c.description}</p>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty mostPopular}">
                            <p>No popular courses available.</p>
                        </c:if>
                    </div>

                </div>

                <div class="full-section">
                    <h2>Recommended for You</h2>
                    <div class="course-grid">
                        <c:if test="${not empty recommendedCourses}"> <c:forEach var="c" items="${recommendedCourses}">
                                <div class="small-card">

                                    <%-- VỊ TRÍ 4: Recommended for You --%>
                                    <img src="${c.thumbnail != null ? c.thumbnail : root}/image/course.jpg" alt="course">

                                    <h4><a href="CourseDetailServlet_1?id=${c.courseID}" style="text-decoration:none; color:#333;"> ${c.title}
                                        </a></h4>
                                    <p>${c.description}</p>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty recommendedCourses}"> <p>No recommended courses available.</p> </c:if>
                        </div>
                    </div>


                    <div class="full-section">
                        <h2>Earn Credit</h2>
                        <div class="course-grid">
                        <c:if test="${not empty earnCredit}">
                            <c:forEach var="c" items="${earnCredit}">
                                <div class="small-card">

                                    <%-- VỊ TRÍ 5: Earn Credit --%>
                                    <img src="${c.thumbnail != null ? c.thumbnail : root}/image/course.jpg" alt="course">

                                    <h4><a href="CourseDetailServlet_1?id=${c.courseID}" style="text-decoration:none; color:#333;">
                                            ${c.title}
                                        </a></h4>
                                    <p>${c.description}</p>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty earnCredit}">
                            <p>No earn-credit courses available.</p>
                        </c:if>
                    </div>

                </div>

            </div> 
        </div> 
        <script src="https://kit.fontawesome.com/a2e0e9b9d4.js" crossorigin="anonymous"></script>
    </body>
</html>