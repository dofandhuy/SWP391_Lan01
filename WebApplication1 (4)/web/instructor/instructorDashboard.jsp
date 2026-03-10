<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Instructor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f7f9fb;
            margin: 0;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
        }
        .card i {
            font-size: 28px;
            color: #007bff;
            margin-bottom: 10px;
        }
        .card h3 { margin: 5px 0; }
        .recent {
            margin-top: 40px;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
        }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 10px; border-bottom: 1px solid #eee; }
        th { background: #f3f3f3; text-align: left; }
    </style>
</head>
<body>
<div class="container">
    <h1>Welcome, ${sessionScope.user.fullName} 👋</h1>

    <div class="stats">
        <div class="card">
            <i class="fa-solid fa-book"></i>
            <h3>${stats.totalCourses}</h3>
            <p>Courses</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-layer-group"></i>
            <h3>${stats.totalModules}</h3>
            <p>Modules</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-file-lines"></i>
            <h3>${stats.totalLessons}</h3>
            <p>Lessons</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-question-circle"></i>
            <h3>${stats.totalQuizzes}</h3>
            <p>Quizzes</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-user-graduate"></i>
            <h3>${stats.totalStudents}</h3>
            <p>Students</p>
        </div>
    </div>

    <div class="recent">
        <h2>📚 Recent Courses</h2>
        <table>
            <thead>
            <tr>
                <th>Title</th>
                <th>Status</th>
                <th>Created At</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${recentCourses}">
                <tr>
                    <td>${c.title}</td>
                    <td>${c.status}</td>
                    <td>${c.createdAt}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
