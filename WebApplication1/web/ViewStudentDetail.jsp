<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LMS - View Student Detail</title>

        <%-- Import Google Fonts and Font Awesome Icons --%>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">


        <style>
            :root {
                --primary-bg: #FFFFFF;
                --secondary-bg: #F8F9FA;
                --border-color: #DEE2E6;
                --text-color: #212529;
                --text-muted: #6C757D;
                --sidebar-width: 250px;
                --header-height: 70px;
                --active-link-bg: #E9ECEF;
                --active-link-text: #007BFF;
                --status-active: #28a745;
                --status-inactive: #dc3545;
                --progress-bar-bg: #e9ecef;
                --progress-bar-fill: #007bff;
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Roboto', sans-serif;
                background-color: var(--secondary-bg);
                color: var(--text-color);
                font-size: 14px;
            }

            .lms-container {
                display: flex;
                min-height: 100vh;
            }

            /* ---------------- Sidebar ---------------- */
            .lms-sidebar {
                width: var(--sidebar-width);
                background-color: var(--primary-bg);
                border-right: 1px solid var(--border-color);
                display: flex;
                flex-direction: column;
                position: fixed;
                top: var(--header-height);
                left: 0;
                bottom: 0;
            }

            .sidebar-nav {
                flex-grow: 1;
                padding-top: 20px;
            }

            .sidebar-nav ul {
                list-style: none;
            }

            .sidebar-nav li a {
                display: flex;
                align-items: center;
                padding: 15px 30px;
                text-decoration: none;
                color: var(--text-color);
                font-weight: 500;
                transition: background-color 0.2s;
            }

            .sidebar-nav li a i {
                margin-right: 15px;
                width: 20px;
                text-align: center;
            }

            .sidebar-nav li a.active,
            .sidebar-nav li a:hover {
                background-color: var(--active-link-bg); /* Chỉ đổi màu nền */
                color: var(--text-color);                /* Giữ nguyên màu chữ gốc cho cả hai trạng thái */
            }

            .logout-link {
                padding: 20px 30px;
                text-decoration: none;
                color: var(--text-muted);
                font-weight: 500;
                border-top: 1px solid var(--border-color);
                display: flex;
                align-items: center;
            }
            .logout-link i {
                margin-right: 15px;
            }

            /* ---------------- Header ---------------- */
            .lms-header {
                height: var(--header-height);
                background-color: var(--primary-bg);
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                padding: 0 30px;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            .logo {
                font-size: 28px;
                font-weight: bold;
                color: var(--text-color);
                width: var(--sidebar-width);
            }

            .search-bar {
                flex-grow: 1;
                display: flex;
                justify-content: center;
            }

            .search-bar input {
                width: 450px;
                padding: 10px 20px;
                border: 1px solid var(--border-color);
                border-radius: 50px;
                outline: none;
                font-size: 14px;
            }

            .header-icons {
                display: flex;
                align-items: center;
                gap: 25px;
            }

            .header-icons .material-icons {
                font-size: 24px;
                color: var(--text-muted);
                cursor: pointer;
            }

            /* ---------------- Main Content ---------------- */
            .lms-main {
                margin-left: var(--sidebar-width);
                margin-top: var(--header-height);
                flex-grow: 1;
                padding: 30px;
                background-color: #fff;
            }

            .content-header h1 {
                font-size: 24px;
                font-weight: 500;
                color: #495057;
            }

            .profile-section {
                text-align: center;
                margin-top: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid var(--border-color);
                display: flex;             /* Kích hoạt chế độ Flexbox */
                flex-direction: column;    /* Sắp xếp các phần tử theo chiều dọc */
                align-items: center;       /* Căn giữa các phần tử theo chiều ngang */
            }

            .avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;

                /* Thuộc tính cho background image */
                background-size: cover; /* Tương đương object-fit: cover */
                background-position: center; /* Căn ảnh vào giữa */
                background-repeat: no-repeat;

                border: 4px solid var(--primary-bg);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .account-info {
                display: grid;
                grid-template-columns: 1fr 1fr;

                /* --- THAY ĐỔI Ở ĐÂY --- */
                /* Thay thế 'gap' bằng hai thuộc tính cụ thể hơn */
                row-gap: 20px;     /* Giữ khoảng cách giữa các hàng ở mức vừa phải (ví dụ: 20px) */
                column-gap: 300px; /* TĂNG mạnh khoảng cách giữa hai cột (ví dụ: 100px) */

                text-align: left;
                max-width: 800px;
                margin: 20px auto 0 auto;
            }
            .info-item {
                font-size: 15px;
            }

            .info-item .label {
                font-weight: 500;
                color: var(--text-muted);
                margin-right: 8px;
            }

            .info-item .value {
                font-weight: 500;
                color: var(--text-color);
            }

            .status-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-weight: 700;
                font-size: 12px;
            }

            .status-badge.active {
                background-color: #D4EDDA;
                color: #155724;
            }

            .status-badge.inactive {
                background-color: #F8D7DA;
                color: #721C24;
            }


            .courses-section {
                margin-top: 40px;
            }

            .courses-section h2 {
                font-size: 20px;
                font-weight: 500;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid var(--border-color);
            }

            th {
                background-color: var(--secondary-bg);
                font-weight: 500;
                color: var(--text-muted);
            }

            tr:last-child td {
                border-bottom: none;
            }

            .empty-row td {
                text-align: center;
                padding: 30px;
                color: var(--text-muted);
            }
        </style>
    </head>
    <body>
        <header class="lms-header">
            <div class="logo">LMS</div>
            <div class="search-bar">
                <input type="text" placeholder="Search">
            </div>
            <div class="header-icons">
                <span class="material-icons">notifications</span>
                <span class="material-icons">account_circle</span>
            </div>
        </header>

        <div class="lms-container">
            <aside class="lms-sidebar">
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="ParentDashBoard"><i class="fa-solid fa-house-chimney"></i> Dash Board</a></li>
                        <li><a href="manage" class="active"><i class="fas fa-user-graduate"></i> Student Management</a></li>
                        <li><a href="#"><i class="fas fa-book-open"></i> Course Requests</a></li>
                        <li><a href="#"><i class="fas fa-receipt"></i> Payment History</a></li>
                    </ul>
                </nav>
                <a href="logout" class="logout-link"><i class="fas fa-sign-out-alt"></i> Log Out</a>
            </aside>

            <main class="lms-main">
                <div class="content-header">
                    <h1>Student Management > View Detail</h1>
                </div>

                <section class="profile-section">
                    <%-- Sửa src thành ${student.avatar} để khớp với tên cột trong DB và tên thuộc tính trong lớp Users --%>
                    <img src="${student.avatar}" alt="Student Avatar" class="avatar">

                    <h3># Account Information</h3>

                    <div class="account-info">
                        <div class="info-item">
                            <span class="label">Username:</span>
                            <span class="value">${student.username}</span> <%-- Giữ nguyên --%>
                        </div>
                        <div class="info-item">
                            <span class="label">Email:</span>
                            <span class="value">${student.email}</span> <%-- Giữ nguyên --%>
                        </div>
                        <div class="info-item">
                            <span class="label">Status:</span>
                            <%-- Logic này vẫn đúng vì DAO đã chuyển Status sang dạng chuỗi --%>
                            <c:choose>
                                <c:when test="${student.status == 'Active'}">
                                    <span class="value status-badge active">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="value status-badge inactive">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="info-item">
                            <span class="label">Total Courses Enrolled:</span>
                            <span class="value">${enrolledCourses.size()}</span> <%-- Giữ nguyên --%>
                        </div>
                    </div>
                </section>
                <section class="courses-section">
                    <h2># Courses List</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Course Name</th>
                                <th>Instructor</th>
                                <th>Progress</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Loop through the enrolled courses list --%>
                            <c:forEach var="course" items="${enrolledCourses}" varStatus="loop">
                                <tr>
                                    <td>${loop.count}</td>
                                    <td>${course.name}</td>
                                    <td>${course.instructorName}</td>
                                    <td>
                                        <%-- Bạn có thể thêm một thanh progress bar ở đây nếu muốn --%>
                                        ${course.progress}%
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${course.status == 'In Progress'}">
                                                <span class="status-badge active">In Progress</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge inactive">${course.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <%-- Show a message if the list is empty --%>
                            <c:if test="${empty enrolledCourses}">
                                <tr class="empty-row">
                                    <td colspan="5">This student is not enrolled in any courses.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </section>
            </main>
        </div>
    </body>
</html>