<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
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
            }

            .lms-sidebar nav ul li a:hover,
            .lms-sidebar nav ul li a.active {
                background-color: #f0f4f8;
                color: #000;
                font-weight: bold;
            }

            .lms-sidebar i {
                margin-right: 15px;
                font-size: 18px;
            }

            .logout {
                padding: 20px 30px;
                text-decoration: none;
                color: #333;
                border-top: 1px solid #eee;
                font-weight: 500;
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
            <!-- HEADER -->
            <header class="lms-header">
                <div class="logo">LMS</div>
                <div class="search-bar">
                    <input type="text" placeholder="Search">
                </div>
                <div class="header-icons">
                    <i class="material-icons">notifications</i>
                    <a href="profile"class="material-icons">account_circle</a>
                </div>
            </header>

            <!-- MAIN -->
            <div class="main-content-area">
                <!-- SIDEBAR -->
                <aside class="lms-sidebar">
                    <nav>
                        <ul>
                            <li><a href="ParentDashBoard" class="active">
                                    <i class="fa-solid fa-house-chimney"></i> Dashboard
                                </a></li>
                            <li><a href="manage">
                                    <i class="fa-solid fa-user-graduate"></i> Student Management
                                </a></li>
                            <li><a href="CourseRequestServlet">
                                    <i class="fa-solid fa-book-open"></i> Course Requests
                                </a></li>

                        </ul>
                    </nav>
                    <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i> Log Out</a>
                </aside>

                <!-- CONTENT -->
                <main class="lms-content">
                    <h1>Welcome, Parent!</h1>

                    <!-- Linked Students -->
                    <div class="dashboard-widget">
                        <div class="widget-title">Linked Students</div>
                        <table class="linked-student-table">
                            <thead>
                                <tr>
                                    <th>Student Name</th>
                                    <th>Email</th>
                                    <th>Relationship</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${linkedStudents}">
                                    <tr>
                                        <td>${s.studentName}</td>
                                        <td>${s.email}</td>
                                        <td>${s.relationshipName}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${s.status == 'Active'}">
                                                    <span class="status active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>


                    <div class="dashboard-widget">
                        <div class="widget-title">Pending Course Requests</div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Course Name</th>
                                    <th>Student</th>
                                    <th>Date Requested</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty pendingRequests}">
                                        <c:forEach var="r" items="${pendingRequests}">
                                            <tr>
                                                <td>${r.courseName}</td>
                                                <td>${r.studentName}</td>
                                                <td><fmt:formatDate value="${r.requestedAt}" pattern="yyyy-MM-dd" /></td>
                                        <td>${r.coursePrice} ₫</td>
                                        <td>
                                            <span class="status ${r.status eq 'Pending' ? 'pending' 
                                                                  : r.status eq 'Approved' ? 'approved' 
                                                                  : 'rejected'}">${r.status}</span>
                                        </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4" class="no-data">No pending requests.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>




                </main>
            </div>
        </div>
    </body>
</html>
