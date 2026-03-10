<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LMS - Student Management</title>
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
                background-color: #f7f9fc;
                color: #333;
                font-size: 14px;
            }

            .lms-container {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                background-color: white;
            }

            /* Header */
            .lms-header {
                display: flex;
                align-items: center;
                padding: 15px 30px;
                border-bottom: 1px solid #eee;
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
            }

            .lms-content h1 {
                font-size: 26px;
                font-weight: 600;
                margin-bottom: 25px;
            }

            .add-student-btn {
                background-color: #00bcd4;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.2s;
            }

            .add-student-btn:hover {
                background-color: #009eb3;
            }

            /* Table */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 8px;
                overflow: hidden;
                margin-top: 20px;
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

            .status {
                font-weight: 600;
            }
            .status.active {
                color: #4CAF50;
            }
            .status.inactive {
                color: #d9534f;
            }

            .action-cell {
                display: flex;
                gap: 10px;
            }

            .action-btn {
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                border: none;
                background: none;
                color: #007BFF;
            }

            .action-btn.unlink {
                color: #FFC107;
            }
            .action-btn.delete {
                color: #d9534f;
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
                    <i class="material-icons">account_circle</i>
                </div>
            </header>

            <div class="main-content-area">
                <!-- SIDEBAR -->
                <aside class="lms-sidebar">
                    <nav>
                        <ul>
                            <li><a href="ParentDashBoard">
                                    <i class="fa-solid fa-house-chimney"></i> Dashboard
                                </a></li>
                            <li><a href="ParentManageStudent.jsp" class="active">
                                    <i class="fa-solid fa-user-graduate"></i> Student Management
                                </a></li>
                            <li><a href="courseRequests.jsp">
                                    <i class="fa-solid fa-book-open"></i> Course Requests
                                </a></li>
                            <li><a href="paymentHistory.jsp">
                                    <i class="fa-solid fa-receipt"></i> Payment History
                                </a></li>
                        </ul>
                    </nav>
                    <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i> Log Out</a>
                </aside>

                <!-- CONTENT -->
                <main class="lms-content">
                    <h1>Student Management</h1>
                    <button class="add-student-btn" onclick="location.href = 'link'">+ Add Student</button>

                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student Name</th>
                                <th>Email</th>
                                <th>Relationship Name</th>
                                <th>Note</th>
                                <th>Link Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty linkedStudents}">
                                <c:forEach var="s" items="${linkedStudents}" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td>${s.studentName}</td>
                                        <td>${s.email}</td>

                                        <%-- Cột Relationship Name --%>
                                        <td>${s.relationshipName}</td>

                                        <%-- Cột Note --%>
                                        <td>${s.note}</td>

                                        <%-- Cột Link Date, sử dụng JSTL fmt để định dạng --%>
                                        <td><fmt:formatDate value="${s.linkDate}" pattern="dd/MM/yyyy HH:mm"/></td>

                                        <%-- Cột Status --%>
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

                                        <%-- Cột Action --%>
                                        <td class="action-cell">
                                            <%-- Nút View luôn hiển thị --%>
                                            <form action="manage" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="view">
                                                <input type="hidden" name="linkID" value="${s.linkID}">
                                                <button type="submit" class="action-btn view">View</button>
                                            </form>

                                            <%-- Sử dụng c:choose để hiển thị Unlink hoặc Relink --%>
                                            <c:choose>
                                                <%-- TRƯỜNG HỢP 1: Nếu status là 'Active' --%>
                                                <c:when test="${s.status == 'Active'}">
                                                    <form action="manage" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="unlink">
                                                        <input type="hidden" name="linkID" value="${s.linkID}">
                                                        <button type="submit" class="action-btn unlink">Unlink</button>
                                                    </form>
                                                </c:when>

                                                <%-- TRƯỜNG HỢP 2: Ngược lại (status là 'Inactive' hoặc trạng thái khác) --%>
                                                <c:otherwise>
                                                    <form action="manage" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="link">  <%-- Gửi action là 'relink' --%>
                                                        <input type="hidden" name="linkID" value="${s.linkID}">
                                                        <button type="submit" class="action-btn relink">Relink</button> <%-- Hiển thị nút 'Relink' --%>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>

                                            <%-- Nút Delete luôn hiển thị --%>
                                            <form action="manage" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this link?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="linkID" value="${s.linkID}">
                                                <button type="submit" class="action-btn delete">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>

                            <c:if test="${empty linkedStudents}">
                                <tr>
                                    <td colspan="8" style="text-align:center;color:#777;">No linked students found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </main>
            </div>
        </div>

    </body>
</html>
