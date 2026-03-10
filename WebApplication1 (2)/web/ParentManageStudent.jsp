<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LMS - Student Management</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            :root {
                --primary-text: #212529;
                --secondary-text: #6c757d;
                --border-color: #dee2e6;
                --background-color: #f8f9fa;
                --white-color: #ffffff;
                --blue-color: #0d6efd;
                --green-color: #198754;
                --red-color: #dc3545;
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--white-color);
                color: var(--primary-text);
                font-size: 14px;
            }

            .lms-container {
                display: grid;
                grid-template-columns: 250px 1fr;
                grid-template-rows: 70px 1fr;
                min-height: 100vh;
                grid-template-areas:
                    "header header"
                    "sidebar main";
            }

            /* Header */
            .lms-header {
                grid-area: header;
                display: flex;
                align-items: center;
                padding: 0 30px;
                border-bottom: 1px solid var(--border-color);
                background-color: var(--white-color);
            }

            .logo {
                font-size: 28px;
                font-weight: 700;
                color: var(--primary-text);
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
                font-family: 'Poppins', sans-serif;
                font-size: 14px;
            }
            .search-bar input:focus {
                outline: none;
                border-color: var(--blue-color);
                box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.15);
            }

            .header-icons {
                display: flex;
                align-items: center;
                gap: 25px;
            }

            .header-icons .material-icons {
                font-size: 26px;
                color: var(--secondary-text);
                cursor: pointer;
                text-decoration: none;
            }

            /* Sidebar */
            .lms-sidebar {
                grid-area: sidebar;
                border-right: 1px solid var(--border-color);
                padding-top: 30px;
                background-color: var(--white-color);
                display: flex;
                flex-direction: column;
            }

            .lms-sidebar nav {
                flex-grow: 1;
            }

            .lms-sidebar nav ul {
                list-style: none;
            }

            .lms-sidebar nav ul li a {
                display: flex;
                align-items: center;
                padding: 15px 30px;
                text-decoration: none;
                color: var(--secondary-text);
                font-weight: 500;
                transition: all 0.2s ease-in-out;
            }

            .lms-sidebar nav ul li a.active,
            .lms-sidebar nav ul li a:hover {
                background-color: var(--background-color);
                color: var(--primary-text);
                font-weight: 600;
            }

            .lms-sidebar i {
                margin-right: 15px;
                font-size: 20px;
                width: 24px;
                text-align: center;
            }

            .logout {
                padding: 20px 30px;
                text-decoration: none;
                color: var(--primary-text);
                border-top: 1px solid var(--border-color);
                font-weight: 600;
                display: flex;
                align-items: center;
            }

            /* Content */
            .lms-content {
                grid-area: main;
                padding: 40px;
                background-color: var(--background-color);
            }

            .lms-content h1 {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 40px;
            }

            .content-section {
                background-color: var(--white-color);
                padding: 30px;
                border-radius: 8px;
                border: 1px solid var(--border-color);
                margin-bottom: 30px;
            }

            .content-section h2 {
                font-size: 18px;
                font-weight: 600;
                padding-bottom: 15px;
                margin-bottom: 20px;
                border-bottom: 1px solid var(--border-color);
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 15px;
                border-bottom: 1px solid var(--border-color);
                text-align: left;
                vertical-align: middle;
            }

            tr:last-child td {
                border-bottom: none;
            }

            th {
                color: var(--secondary-text);
                font-weight: 500;
                font-size: 12px;
                text-transform: uppercase;
            }

            .status {
                font-weight: 600;
                color: var(--green-color);
            }

            /* --- ACTION COLUMN STYLES --- */
            .action-list {
                display: flex;
                flex-direction: column;
                gap: 8px;
                align-items: flex-start;
            }

            .action-item {
                display: flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
                color: var(--secondary-text);
                font-weight: 500;
                background: none;
                border: none;
                cursor: pointer;
                padding: 0;
                font-family: 'Poppins', sans-serif;
                font-size: 14px;
            }
            .action-item:hover {
                color: var(--primary-text);
            }
            .action-item i {
                font-size: 16px;
                width: 18px;
            }
            .action-item.view {
                color: var(--blue-color);
            }
            .action-item.unlink {
                color: #fd7e14;
            } /* Orange */
            .action-item.delete {
                color: var(--red-color);
            }
            .action-item.approve {
                color: var(--green-color);
            }
            .action-item.reject {
                color: var(--red-color);
            }
        </style>
    </head>
    <body>
        <div class="lms-container">
            <header class="lms-header">
                <div class="logo">LMS</div>
                <div class="search-bar">
                    <input type="text" placeholder="Search">
                </div>
                <div class="header-icons">
                    <i class="material-icons">notifications</i>
                    <a href="profile" class="material-icons">account_circle</a>
                </div>
            </header>

            <aside class="lms-sidebar">
                <nav>
                    <ul>
                        <li><a href="ParentDashBoard">
                                <i class="fa-solid fa-house-chimney"></i> Dash Board
                            </a></li>
                        <li><a href="manage" class="active">
                                <i class="fa-solid fa-user-graduate"></i> Student Management
                            </a></li>
                        <li><a href="CourseRequestServlet">
                                <i class="fa-solid fa-book-open"></i> Course Requests
                            </a></li>

                    </ul>
                </nav>
                <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i> Log Out</a>
            </aside>

            <main class="lms-content">
                <h1>Student Management</h1>

                <%-- ========================================================== --%>
                <%-- SECTION 1: LINKED STUDENT LIST (ACTIVE)                  --%>
                <%-- ========================================================== --%>
                <div class="content-section">
                    <h3>Linked Student List</h3>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Email</th>
                                <th>Relationship</th>
                                <th>Status</th>
                                <th style="width: 220px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Vòng lặp duyệt qua danh sách linkedStudents từ Servlet --%>
                            <c:forEach var="student" items="${linkedStudents}">
                                <tr>
                                    <td>${student.studentName}</td>
                                    <td>${student.email}</td>
                                    <td>${student.relationshipName}</td>
                                    <td>
                                        <%-- Hiển thị badge màu tùy theo status --%>
                                        <c:choose>
                                            <c:when test="${student.status == 'Active'}">
                                                <span class="badge bg-success">${student.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${student.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <%-- Nút View luôn hiển thị --%>
                                        <form action="manage" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="view">
                                            <input type="hidden" name="linkID" value="${student.linkID}">
                                            <button type="submit" class="btn btn-info btn-sm">View</button>
                                        </form>

                                        <%-- Nút Unlink hoặc Relink tùy theo status --%>
                                        <c:choose>
                                            <c:when test="${student.status == 'Active'}">
                                                <form action="manage" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="unlink">
                                                    <input type="hidden" name="linkID" value="${student.linkID}">
                                                    <button type="submit" class="btn btn-warning btn-sm">Unlink</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="manage" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="relink">
                                                    <input type="hidden" name="linkID" value="${student.linkID}">
                                                    <button type="submit" class="btn btn-primary btn-sm">Relink</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <%-- Nút Delete luôn hiển thị --%>
                                        <form action="manage" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to PERMANENTLY delete this link?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="linkID" value="${student.linkID}">
                                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <%-- Hiển thị nếu không có sinh viên nào đã liên kết --%>
                            <c:if test="${empty linkedStudents}">
                                <tr>
                                    <td colspan="5" class="text-center">No active linked students.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <%-- ========================================================== --%>
                <%-- SECTION 2: LINK REQUESTS (PENDING)              --%>
                <%-- ========================================================== --%>
                <div class="content-section">
                    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                    <h3>Link Requests</h3>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Relationship</th>
                                <th>Note</th>
                                <th style="width: 250px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Vòng lặp duyệt qua danh sách pendingRequests từ Servlet --%>
                            <c:forEach var="req" items="${pendingRequests}">
                                <tr>
                                    <td>${req.studentName}</td>
                                    <td>${req.relationshipName}</td>
                                    <td>${req.note}</td>
                                    <td>
                                        <%-- Nút View Detail --%>
                                        <form action="manage" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="view">
                                            <input type="hidden" name="linkID" value="${req.linkID}">
                                            <button type="submit" class="btn btn-info btn-sm">View</button>
                                        </form>

                                        <%-- Nút Approve --%>
                                        <form action="manage" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="linkID" value="${req.linkID}">
                                            <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                        </form>

                                        <%-- Nút Reject --%>
                                        <form action="manage" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="linkID" value="${req.linkID}">
                                            <button type="submit" class="btn btn-warning btn-sm">Reject</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <%-- Hiển thị nếu không có yêu cầu nào --%>
                            <c:if test="${empty pendingRequests}">
                                <tr>
                                    <td colspan="4" class="text-center">No pending requests.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </body>
</html>