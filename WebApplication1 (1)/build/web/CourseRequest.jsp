<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LMS - Course Requests</title>
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
                --orange-color: #fd7e14;
                --yellow-color: #ffc107;
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
                font-size: 28px; /* Giảm kích thước font */
                font-weight: 700;
                margin-bottom: 20px; /* Giảm margin */
            }

            .content-section {
                background-color: var(--white-color);
                padding: 30px;
                border-radius: 8px;
                border: 1px solid var(--border-color);
                margin-bottom: 30px;
            }

            /* ---- BẮT ĐẦU CSS MỚI CHO TRANG NÀY ---- */

            /* Filter Bar */
            .filter-bar {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                align-items: center;
            }

            .filter-dropdown {
                background-color: var(--white-color);
                border: 1px solid var(--border-color);
                border-radius: 6px;
                padding: 8px 12px;
                font-family: 'Poppins', sans-serif;
                font-size: 14px;
                cursor: pointer;
            }

            /* Bảng */
            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 15px;
                border-bottom: 1px solid var(--border-color);
                text-align: left;
                vertical-align: middle;
                line-height: 1.6;
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

            /* Status Badges */
            .status-badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 12px;
                text-transform: capitalize;
            }
            .status-badge.status-pending {
                background-color: #fff7e6; /* Light Yellow/Orange */
                color: #f59e0b; /* Dark Yellow/Orange */
            }
            .status-badge.status-approved,
            .status-badge.status-success {
                background-color: #e8f5e9; /* Light Green */
                color: var(--green-color);
            }
            .status-badge.status-rejected,
            .status-badge.status-failed {
                background-color: #fdecea; /* Light Red */
                color: var(--red-color);
            }

            /* --- ACTION COLUMN STYLES (ĐÃ THAY THẾ) --- */
            /* Style này thay thế style cũ để khớp với ảnh (không icon, gạch chân) */
            .action-list {
                display: flex;
                flex-direction: column;
                gap: 5px; /* Giảm gap */
                align-items: flex-start;
            }

            .action-item {
                display: inline; /* Chỉ là link */
                text-decoration: underline;
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
                text-decoration: none;
            }
            /* Màu cho các action */
            .action-item.view {
                color: var(--blue-color);
            }
            .action-item.approve {
                color: var(--green-color);
            }
            .action-item.reject {
                color: var(--red-color);
            }
            /* ---- KẾT THÚC CSS MỚI ---- */

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
                        <li><a href="manage"> <i class="fa-solid fa-user-graduate"></i> Student Management
                            </a></li>
                        <li><a href="CourseRequestServlet" class="active"> <i class="fa-solid fa-book-open"></i> Course Requests
                            </a></li>

                    </ul>
                </nav>
                <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i> Log Out</a>
            </aside>

            <%-- ========================================================== --%>
            <%-- PHẦN NỘI DUNG CHÍNH (ĐÃ THAY THẾ)                         --%>
            <%-- ========================================================== --%>
            <main class="lms-content">
                <h1>Course request</h1>

                <%-- Bảng Yêu cầu --%>
                <div class="content-section">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student Name</th>
                                <th>Course Title</th>
                                <th>Instructor</th>
                                <th>Price</th>
                                <th>Date Requested</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${requestList}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td>${req.studentName}</td>
                                    <td>${req.courseName}</td>
                                    <td>${req.instructorName}</td>
                                    <td>${req.coursePrice} ₫</td>
                                    <td><fmt:formatDate value="${req.requestedAt}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <span class="status-badge
                                              ${req.status == 'Pending' ? 'status-pending' : 
                                                req.status == 'Completed' ? 'status-success' : 'status-rejected'}">
                                                  ${req.status}
                                              </span>
                                        </td>

                                        <td>
                                            <div class="action-list">

                                                 <form action="PaymentServlet" method="POST" style="display: inline; margin: 0; padding: 0;">
                                                        <input type="hidden" name="action" value="view">
                                                        <input type="hidden" name="id" value="${req.courseID}">
                                                        <button type="submit" class="action-item view">View Detail</button>
                                                    </form>

                                                <c:if test="${req.status == 'Pending'}">

                                                    <form action="PaymentServlet" method="POST" style="display: inline; margin: 0; padding: 0;">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="id" value="${req.requestID}">
                                                        <button type="submit" class="action-item approve">Approve</button>
                                                    </form>

                                                    <form action="PaymentServlet" method="POST" style="display: inline; margin: 0; padding: 0;">
                                                        <input type="hidden" name="action" value="reject">
                                                        <input type="hidden" name="id" value="${req.requestID}">
                                                        <button type="submit" class="action-item reject">Reject</button>
                                                    </form>

                                                </c:if>
                                            </div>
                                        </td>


                                    </tr>
                                </c:forEach>
                            </tbody>

                        </table>
                        <!-- Pagination -->
                        <div style="display: flex; justify-content: center; margin-top: 25px;">
                            <c:if test="${totalPages > 1}">
                                <ul style="list-style: none; display: flex; gap: 8px; padding: 0;">

                                    <!-- Nút Previous -->
                                    <li>
                                        <c:if test="${currentPage > 1}">
                                            <a href="CourseRequestServlet?page=${currentPage - 1}"
                                               style="padding: 8px 14px;
                                               border: 1px solid var(--border-color);
                                               border-radius: 6px;
                                               background-color: var(--white-color);
                                               text-decoration: none;
                                               color: var(--blue-color);
                                               font-weight: 500;">
                                                &laquo; Prev
                                            </a>
                                        </c:if>
                                    </li>

                                    <!-- Số trang -->
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li>
                                            <a href="CourseRequestServlet?page=${p}"
                                               style="padding: 8px 14px;
                                               border: 1px solid var(--border-color);
                                               border-radius: 6px;
                                               text-decoration: none;
                                               font-weight: 500;
                                               ${p == currentPage ? 
                                                 'background-color: var(--blue-color); color: white;' : 
                                                 'color: var(--blue-color); background-color: var(--white-color);'}">
                                                   ${p}
                                               </a>
                                            </li>
                                        </c:forEach>

                                        <!-- Nút Next -->
                                        <li>
                                            <c:if test="${currentPage < totalPages}">
                                                <a href="CourseRequestServlet?page=${currentPage + 1}"
                                                   style="padding: 8px 14px;
                                                   border: 1px solid var(--border-color);
                                                   border-radius: 6px;
                                                   background-color: var(--white-color);
                                                   text-decoration: none;
                                                   color: var(--blue-color);
                                                   font-weight: 500;">
                                                    Next &raquo;
                                                </a>
                                            </c:if>
                                        </li>
                                    </ul>
                                </c:if>
                            </div>

                        </div>
                    </main>

                </div>
            </body>
        </html>