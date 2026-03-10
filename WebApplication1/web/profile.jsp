<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.User" %>
<%@ page import="Entity.ParentStudentLink" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Profile</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        /* --- General & Reset --- */
        <style>
            * {

                box-sizing: border-box;

                margin: 0;

                padding: 0;

            }

            body {

                font-family: 'Poppins', sans-serif;

                background-color: #f7f9fc;

                color: #333;

                font-size: 14px;

            }

            .lms-container {

                display: flex;

                flex-direction: column;

                min-height: 100vh;

            }

            /* --- Header --- */

            .lms-header {

                display: flex;

                align-items: center;

                padding: 15px 30px;

                border-bottom: 1px solid #eee;

                background-color: #ffffff;

                position: fixed;

                top: 0;

                left: 0;

                right: 0;

                z-index: 1000;

                height: 70px; /* Set a fixed height */

            }

            .logo {

                font-size: 24px;

                font-weight: bold;

                color: #333;

                width: 250px; /* Match sidebar width */

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

                font-family: 'Poppins', sans-serif;

            }

            .header-icons {

                display: flex;

                align-items: center;

                margin-left: auto;

            }

            .header-icons .material-icons {

                font-size: 26px;

                color: #555;

                cursor: pointer;

                margin-left: 25px;

                text-decoration: none;

            }

            /* --- Main Layout --- */

            .main-content-area {

                display: flex;

                flex-grow: 1;

                padding-top: 70px; /* Offset for fixed header */

            }

            /* --- Sidebar --- */

            .lms-sidebar {

                width: 250px;

                background-color: #ffffff;

                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);

                display: flex;

                flex-direction: column;

                position: fixed;

                height: calc(100% - 70px); /* Adjust height for header */

                top: 70px;

            }

            .sidebar-menu {

                padding-top: 20px;

                flex-grow: 1;

            }

            .sidebar-header {

                padding: 0 20px 15px;

                text-transform: uppercase;

                font-size: 0.8em;

                color: #888;

                font-weight: 600;

            }

            .menu-item {

                padding: 15px 20px;

                display: flex;

                align-items: center;

                color: #333;

                text-decoration: none;

                transition: all 0.2s;

                font-weight: 500;

            }

            .menu-item:hover, .menu-item.active {

                background-color: #e6f7ff;

                color: #0d6efd;

                border-right: 3px solid #0d6efd;

            }

            .menu-item.delete-link:hover {

                background-color: #fff1f0;

                color: #ff4d4f;

                border-right: 3px solid #ff4d4f;

            }

            .menu-item i {

                margin-right: 15px;

                width: 20px; /* Align icons */

                text-align: center;

            }

            .logout {

                padding: 20px;

                border-top: 1px solid #eee;

            }

            .logout a {

                color: #ff4d4f;

                text-decoration: none;

                display: flex;

                align-items: center;

                transition: color 0.2s;

                font-weight: 500;

            }

            .logout a:hover {

                color: #cf1322;

            }

            /* --- Main Content --- */

            .lms-content {

                margin-left: 250px; /* Offset for fixed sidebar */

                flex-grow: 1;

                padding: 30px;

                box-sizing: border-box;

            }

            .profile-header {

                background-color: #00796b;

                height: 150px;

                border-radius: 8px;

                position: relative;

                margin-bottom: 70px;

            }

            .avatar {

                width: 120px;

                height: 120px;

                border-radius: 50%;

                overflow: hidden;

                border: 4px solid #ffffff;

                position: absolute;

                top: 50%;

                left: 50%;

                transform: translate(-50%, 0%);

                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);

            }

            .avatar img {

                width: 100%;

                height: 100%;

                object-fit: cover;

            }

            .profile-form {

                background-color: #ffffff;

                padding: 30px;

                border-radius: 8px;

                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);

            }

            .form-grid {

                display: grid;

                grid-template-columns: 1fr 1fr;

                gap: 20px 40px;

            }

            .form-group {

                display: flex;

                flex-direction: column;

            }

            .form-group label {

                font-size: 0.9em;

                color: #555;

                margin-bottom: 5px;

                font-weight: 600;

            }

            .form-control {

                padding: 10px 12px;

                border: 1px solid #d9d9d9;

                border-radius: 4px;

                font-size: 1em;

                transition: border-color 0.2s, box-shadow 0.2s;

                box-sizing: border-box;

                background-color: #f5f5f5; /* Indicate readonly */

                cursor: not-allowed;

            }

            .gender-input {

                width: 150px;

            }
            .badge { display: inline-block; padding: .35em .65em; font-size: .75em; font-weight: 700; line-height: 1; color: #fff; text-align: center; white-space: nowrap; vertical-align: baseline; border-radius: .25rem; }
            .bg-success {
                background-color: #198754;
            }
            .bg-secondary {
                background-color: #6c757d;
            }
            .bg-warning {
                background-color: #ffc107;
            }
            .bg-danger {
                background-color: #dc3545;
            }
        </style>
    </head>
    <body>
        <c:set var="user" value="${sessionScope.user}" />
        <c:set var="role" value="${user.role.roleName}" />
        <c:set var="dashboardUrl" value="#" />
        <c:if test="${role == 'Student'}"><c:set var="dashboardUrl" value="StudentDashboardServlet" /></c:if>
        <c:if test="${role == 'Instructor'}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/instructor/courses" /></c:if>
        <c:if test="${role == 'Parent'}"><c:set var="dashboardUrl" value="ParentDashBoard" /></c:if>

            <div class="lms-container">
                <header class="lms-header">
                    <div class="logo">E-LEARNING</div>
                    <div class="search-bar">
                        <input type="text" placeholder="Search for courses, users, etc...">
                    </div>
                    <div class="header-icons">
                        <i class="material-icons">notifications</i>
                        <a href="profile" class="material-icons">account_circle</a>
                    </div>
                </header>

                <div class="main-content-area">
                    <aside class="lms-sidebar">
                        <div class="sidebar-menu">
                            <div class="sidebar-header">Overview</div>
                            <a href="${dashboardUrl}" class="menu-item">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>

                        <div class="sidebar-header" style="padding-top: 20px;">Account Settings</div>
                        <a href="profile" class="menu-item active">
                            <i class="fas fa-user-circle"></i> My Profile
                        </a>
                        <a href="Edit.jsp" class="menu-item">
                            <i class="fas fa-user-edit"></i> Edit Profile
                        </a>
                        <a href="changePassword.jsp" class="menu-item">
                            <i class="fas fa-key"></i> Change Password
                        </a>

                        <c:if test="${role == 'Student'}">
                            <a href="link" class="menu-item">
                                <i class="fas fa-link"></i> Link Parent Account
                            </a>
                        </c:if>

                        <c:if test="${not empty user}">
                            <a href="DeleteAccountServlet?userId=${user.userID}"
                               class="menu-item delete-link"
                               onclick="return confirm('Are you sure you want to delete your account? This action cannot be undone.');">
                                <i class="fas fa-trash-alt"></i> Delete Account
                            </a>
                        </c:if>
                    </div>

                    <div class="logout">
                        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </aside>

                <div class="lms-content">
                    <div class="profile-header">
                        <div class="avatar">
                            <img src="https://i.ibb.co/L5hY5X1/image-297db2.png" alt="Profile Picture">
                        </div>
                    </div>

                    <div class="profile-form">
                        <c:if test="${not empty user}">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Username</label>
                                    <input type="text" class="form-control" value="${user.username}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Full Name</label>
                                    <input type="text" class="form-control" value="${user.fullName}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Email Address</label>
                                    <input type="email" class="form-control" value="${user.email}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Phone Number</label>
                                    <input type="tel" class="form-control" value="${user.phone}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Address</label>
                                    <input type="text" class="form-control" value="${user.address}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Gender</label>
                                    <input type="text" class="form-control gender-input" value="${user.sex}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Date of Birth</label>
                                    <input type="date" class="form-control" value="${user.dob}" readonly>
                                </div>

                                <%-- SỬA LẠI HOÀN TOÀN KHỐI NÀY --%>
                                <%-- Nó sẽ chỉ hiển thị nếu role của người dùng trong session là 'Student' --%>
                                <c:if test="${role == 'Student'}">
                                    <div class="form-group">
                                        <label>Linked Parent Account(s)</label>

                                        <c:if test="${empty allLinks}">
                                            <input type="text" class="form-control" value="No parent account linked." readonly>
                                        </c:if>

                                        <c:forEach var="link" items="${allLinks}">
                                            <div class="input-group mb-2">
                                                <input type="text" class="form-control" value="${link.email}" readonly>

                                                <%-- THÊM LẠI PHẦN HIỂN THỊ STATUS BỊ MẤT --%>
                                                <span class="input-group-text">
                                                    <c:choose>
                                                        <c:when test="${link.status == 'Active'}"><span class="badge bg-success">Active</span></c:when>
                                                        <c:when test="${link.status == 'Inactive'}"><span class="badge bg-secondary">Inactive</span></c:when>
                                                        <c:when test="${link.status == 'Pending'}"><span class="badge bg-warning text-dark">Pending</span></c:when>
                                                        <c:when test="${link.status == 'Rejected'}"><span class="badge bg-danger">Rejected</span></c:when>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <%-- KẾT THÚC KHỐI SỬA --%>

                            </div>
                        </c:if>
                        <c:if test="${empty user}">
                            <p style="color:red; text-align:center;">User not logged in.</p>
                            <a href="Signin.jsp" style="display:block; text-align:center; margin-top:20px;">Login here</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>