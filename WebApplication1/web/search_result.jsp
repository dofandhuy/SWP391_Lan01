<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>LMS - Category</title>
        <style>
            * {
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }

            body {
                display: flex;
                margin: 0;
                background-color: #f7f7f7;
            }

            /* Sidebar */
            .sidebar {
                width: 220px;
                background-color: #fff;
                height: 100vh;
                padding: 20px 0;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                border-right: 1px solid #ddd;
            }

            .sidebar .logo {
                text-align: center;
                font-size: 24px;
                font-weight: bold;
                color: #00bfbf;
                margin-bottom: 30px;
            }

            .sidebar nav {
                display: flex;
                flex-direction: column;
                padding: 0 15px;
            }

            .sidebar nav a {
                padding: 10px 15px;
                text-decoration: none;
                color: #333;
                margin-bottom: 5px;
                border-radius: 8px;
                transition: 0.3s;
            }

            .sidebar nav a:hover,
            .sidebar nav a.active {
                background-color: #00bfbf;
                color: white;
            }

            .sidebar .logout {
                padding: 15px;
                color: red;
                text-align: center;
                cursor: pointer;
                font-weight: bold;
            }

            /* Main content */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                height: 100vh;
            }

            /* Topbar */
            .topbar {
                background-color: #00bfbf;
                padding: 10px 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .topbar .search-bar input {
                padding: 8px 12px;
                border-radius: 20px;
                border: none;
                width: 300px;
            }

            .topbar .icons {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .icon {
                width: 25px;
                height: 25px;
                background-color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
            }

            /* Breadcrumb */
            .breadcrumb {
                background-color: #00bfbf;
                color: white;
                padding: 12px 20px;
                margin: 20px;
                border-radius: 10px;
                font-size: 16px;
            }

            .breadcrumb a {
                color: white;
                text-decoration: none;
            }

            .breadcrumb span {
                margin: 0 5px;
            }

            /* Course grid */
            .course-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                padding: 0 20px;
            }

            .course-card {
                background-color: #e8edfb;
                padding: 10px;
                border-radius: 10px;
                text-align: center;
                transition: 0.3s;
                cursor: pointer;
            }

            .course-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .course-card img {
                width: 100%;
                border-radius: 10px;
                margin-bottom: 10px;
            }

            .course-card h4 {
                margin: 5px 0;
                font-size: 16px;
            }

            .course-card p {
                font-size: 14px;
                color: #666;
            }

            /* Pagination */
            .pagination {
                text-align: center;
                padding: 20px;
                font-size: 16px;
            }

            .pagination a {
                margin: 0 5px;
                text-decoration: none;
                color: #00bfbf;
                font-weight: bold;
            }

            .pagination a.active {
                text-decoration: underline;
            }

            /* Responsive */
            @media (max-width: 992px) {
                .course-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 600px) {
                .sidebar {
                    display: none;
                }
                .course-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <aside>
            <jsp:include page="header.jsp" />   
            <jsp:include page="sidebar_student.jsp" />
        </aside>
        <!-- Main Content -->
        <div class="main">
            <!-- Topbar -->
            <div class="topbar">
                <div class="search-bar">
                    <form action="SearchServlet" method="get">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Search courses...">
                    </form>
                </div>
                <div class="icons">
                    <div class="icon">🔔</div>
                    <div class="icon">👤</div>
                </div>
            </div>

            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="HomeServlet">Home</a> <span>›</span> 
                <span>Search Results for "<c:out value='${keyword}'/>"</span>
            </div>

            <!-- Course grid -->
            <div class="course-grid">
                <c:choose>
                    <c:when test="${not empty searchResults}">
                        <c:forEach var="c" items="${searchResults}">
                            <div class="course-card">
                                <img src="${c.image}" alt="Course Image">
                                <h4><a href="CourseDetailServlet_1?id=${c.courseID}">${c.title}</a></h4>
                                <p>${c.description}</p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="grid-column: 1 / -1; text-align:center; color:#666;">No courses found.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <a href="#">«</a>
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">»</a>
            </div>
        </div>
    </body>
</html>
