<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Student Dashboard</title>
        <link rel="stylesheet" href="css/style2.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    </head>
    <body>
        <div class="sidebar">
            <div class="menu">
                <p class="overview">OVERVIEW</p>
                <ul>
                    <li><a href="dashboard" class="active"><i class="fa fa-home"></i> Dashboard</a></li>
                    <li><a href="assignment"><i class="fa fa-file-alt"></i> Assignment</a></li>
                    <li><a href="grade"><i class="fa fa-graduation-cap"></i> Grade</a></li>
                </ul>
            </div>
            <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i> Logout</a>
        </div>

        <div class="main">
            <div class="topbar">
                <form action="/studentdashboard" method="get" class="search-form">
                    <i class="fa fa-search"></i>
                    <input type="text" name="search" placeholder="Search"/>
                </form>
                <div class="actions">
                    <select name="sort">
                        <option value="">Sort Class</option>
                        <option value="name">By Name</option>
                        <option value="student">By Student</option>
                    </select>
                    <button class="enroll-btn" onclick="window.location.href = 'InputClassCode.jsp'">
                        + Enroll class
                    </button>

                    <i class="fa fa-bell"></i>
                    <a href="profile" class="fa fa-user-circle"></a>
                </div>
            </div>

            <table class="class-table">
                <thead>
                    <tr>
                        <th>Class Name</th>
                        <th>Student</th>
                        <th>Lesson</th>
                        <th>Assignment</th>
                        <th>Document</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${classes}">
                        <tr>
                            <td><b>${c.className}</b></td>
                            <td><b>${c.studentCount}</b></td>
                            <td>${c.lessonCount}</td>
                            <td>${c.assignmentCount}</td>
                            <td>${c.documentCount}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
