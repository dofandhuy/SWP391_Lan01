<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<html>
<head>
    <title>Instructor Dashboard</title>
    <link rel="stylesheet" href="css/style2.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>


<div class="sidebar">
    <ul>
        <li><a href="instructor/dashboard" class="active">Dashboard</a></li>
        <li><a href="instructor/classes">My Class</a></li>
        <li><a href="instructor/reports">Report/Grade</a></li>
        <li><a href="uploadMaterial.jsp">Upload File</a></li>
    </ul>
    <a href="logout" class="logout">Logout</a>
</div>

<div class="main">
    <div class="topbar">
        <form action="instructordashboard" method="get" class="search-form">
            <input type="text" name="search" placeholder="Search"/>
            <button type="submit">Go</button>
        </form>

        <div class="actions">
            <select name="sort" onchange="this.form.submit()">
                <option value="">Sort Class</option>
                <option value="name">By Name</option>
                <option value="student">By Student</option>
            </select>
            <a href="createClass.jsp" class="enroll-btn">+ Create class</a>
            <i class="fa fa-bell"></i> 
        <a href="profile" class="fa fa-user-circle"></a>
        </div>
       
    </div>

    <table class="class-table">
        <thead>
            <tr>
                <th>Class code</th>
                <th>Class name</th>
                <th>Student</th>
                <th>Lesson</th>
                <th>Assignment</th>
                <th>Document</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${classes}">
                <tr>
                    <td>${c.classCode}</td>
                    <td>${c.className}</td>
                    <td>${c.studentCount}</td>
                    <td>${c.lessonCount}</td>
                    <td>${c.assignmentCount}</td>
                    <td>${c.documentCount}</td>
                    <td>
<a href="${pageContext.request.contextPath}/editClass?classId=${c.classId}" title="Edit">✏️</a>
<a href="${pageContext.request.contextPath}/deleteClass?id=${c.classId}" title="Delete">🗑️</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
