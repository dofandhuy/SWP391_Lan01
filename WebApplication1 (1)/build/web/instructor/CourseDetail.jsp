<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>${course.title} - Course Detail</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            /* ===== Reset & Body ===== */
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                display: flex;
                min-height: 100vh;
            }

            /* ===== Sidebar ===== */
            .sidebar {
                width: 240px;
                background: #fff;
                border-right: 1px solid #eee;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                height: 100vh;
                overflow-y: auto;
                padding: 20px;
            }

            .sidebar img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 8px;
                margin-bottom: 15px;
            }

            .sidebar h3 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #1b1f3b;
                text-transform: uppercase;
            }

            .sidebar ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar li {
                padding: 10px;
                cursor: pointer;
                color: #222;
                border-radius: 6px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: 0.3s;
            }

            .sidebar li:hover,
            .sidebar li.active {
                background: #22c1c3;
                color: #fff;
            }

            .sidebar .bottom-links {
                border-top: 1px solid #eee;
                margin-top: 20px;
                padding-top: 15px;
            }

            .sidebar .bottom-links li {
                color: #444;
                font-weight: 500;
            }

            /* ===== Main Content ===== */
            .main-content {
                flex: 1;
                padding: 30px 40px;
                overflow-y: auto;
            }

            .search-bar {
                margin-bottom: 20px;
            }

            .search-bar input {
                width: 300px;
                padding: 10px 15px;
                border: 1px solid #ccc;
                border-radius: 25px;
                outline: none;
            }

            h2 {
                font-weight: 600;
                color: #1b1f3b;
                margin-bottom: 15px;
            }

            /* ===== Lesson List ===== */
            .lesson-list {
                margin-top: 15px;
            }

            .lesson-item {
display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 15px;
                background: #fff;
                border-radius: 8px;
                margin-bottom: 10px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                transition: 0.3s;
            }

            .lesson-item:hover {
                background: #f5f5f5;
            }

            .lesson-left {
                display: flex;
                align-items: center;
                gap: 10px;
                color: #333;
                font-weight: 500;
            }

            .lesson-left i {
                color: #22c1c3;
            }

            .lesson-actions {
                position: relative;
            }

            .lesson-actions i {
                cursor: pointer;
                font-size: 18px;
                color: #444;
            }

            .action-menu {
                display: none;
                position: absolute;
                top: 25px;
                right: 0;
                background: #fff;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                z-index: 10;
            }

            .action-menu button {
                background: none;
                border: none;
                width: 100%;
                text-align: left;
                padding: 8px 12px;
                cursor: pointer;
                font-size: 14px;
            }

            .action-menu button:hover {
                background: #f0f0f0;
            }

            .lesson-actions.active .action-menu {
                display: block;
            }
        </style>
    </head>

    <body>
        <!-- ===== Sidebar ===== -->
        <div class="sidebar">
            <div>
                <img src="${course.thumbnail != null ? course.thumbnail : 'https://via.placeholder.com/200x120'}" alt="Course Thumbnail">
                <h3 style="display:flex; align-items:center; justify-content:space-between;">
                    ${course.title}
                    <i class="fa-solid fa-plus" 
                       title="Add Module" 
                       style="cursor:pointer; font-size:16px; color:#22c1c3;"
                       onclick="createModule(${course.id})"></i>
                </h3>

                <ul id="module-list">
                    <c:forEach var="m" items="${modules}" varStatus="status">
                        <li class="${status.first ? 'active' : ''}" onclick="showModule(${m.id}, this)">
                            › ${m.title} 
                            <i class="fa-regular fa-pen-to-square"
                               title="Edit Module"
                               style="cursor:pointer; color:#22c1c3;"
                               onclick="event.stopPropagation(); editModule(${m.id});"></i>
                        </li>
</c:forEach>
                </ul>

                <ul class="bottom-links">
                    <li onclick="viewResources(${course.id})">Resources</li>
                    <li>Course Info</li>
                </ul>
            </div>

            <div>
                <i class="fa-solid fa-arrow-left"
                   title="Back to My Courses"
                   style="cursor:pointer; font-size:18px; color:#22c1c3;"
                   onclick="goBackToCourses()"></i>
            </div>

        </div>

        <!-- ===== Main Content ===== -->
        <div class="main-content">
            <div class="search-bar">
                <input type="text" placeholder="🔍 Search lessons...">
            </div>

            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:10px;">
                <h2>Lessons</h2>
                <button onclick="createLesson()" 
                        style="background:#22c1c3;color:white;border:none;padding:10px 18px;border-radius:8px;font-weight:500;cursor:pointer;display:flex;align-items:center;gap:8px;">
                    <i class="fa-solid fa-plus"></i> Create Lesson
                </button>
            </div>

            <div id="module-content">
                <c:forEach var="m" items="${modules}" varStatus="loop">
                    <div id="module-${m.id}" class="lesson-list" style="${!loop.first ? 'display:none;' : ''}">
                        <c:forEach var="l" items="${lessonsByModule[m.id]}">
                            <div class="lesson-item">
                                <div class="lesson-left">
                                    <i class="fa-solid
                                       <c:choose>
                                           <c:when test="${l.lessonType == 'video'}">fa-video</c:when>
                                           <c:when test="${l.lessonType == 'quiz'}">fa-clipboard</c:when>
                                           <c:otherwise>fa-book-open</c:otherwise>
                                       </c:choose>">
                                    </i>
                                    ${l.title}
                                </div>

                                <div class="lesson-actions" onclick="toggleMenu(this)">
                                    <i class="fa-solid fa-ellipsis"></i>
                                    <div class="action-menu">
                                        <button onclick="editLesson(${l.lessonID})">Edit</button>
                                        <button onclick="deleteLesson(${l.lessonID}, ${course.id})">Delete</button>
                                        <button>Move Up</button>
                                        <button>Move Down</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
</div>

        <script>
            function createLesson() {
                const activeModule = document.querySelector('#module-list li.active');
                if (!activeModule) {
                    alert('Please select a module first!');
                    return;
                }
                const moduleId = activeModule.getAttribute('onclick').match(/\d+/)[0];
                window.location.href = '${pageContext.request.contextPath}/instructor/createLesson.jsp?moduleId=' + moduleId;
            }
            function createModule(courseId) {
                window.location.href = '${pageContext.request.contextPath}/instructor/createModule.jsp?courseId=' + courseId;
            }
            function editModule(moduleId) {
                window.location.href = '${pageContext.request.contextPath}/instructor/editModule.jsp?moduleId=' + moduleId;
            }


            function showModule(moduleId, el) {
                document.querySelectorAll('#module-list li').forEach(li => li.classList.remove('active'));
                el.classList.add('active');

                document.querySelectorAll('.lesson-list').forEach(div => div.style.display = 'none');
                document.getElementById('module-' + moduleId).style.display = 'block';
            }

            function toggleMenu(el) {
                document.querySelectorAll('.lesson-actions').forEach(a => a.classList.remove('active'));
                el.classList.toggle('active');
            }

            function editLesson(id) {
                window.location.href = '${pageContext.request.contextPath}/instructor/EditLessonServlet?lessonId=' + id;
            }

            function deleteLesson(id, courseId) {
                if (confirm('Are you sure you want to delete this lesson?')) {
                    window.location.href =
                            '${pageContext.request.contextPath}/instructor/DeleteLessonServlet?lessonId='
                            + id + '&courseId=' + courseId;
                }
            }
            function viewResources(courseId) {
                window.location.href = '${pageContext.request.contextPath}/ResourcesServlet?courseId=' + courseId;
            }
            function goBackToCourses() {
                window.location.href = '${pageContext.request.contextPath}/instructor/courses';
            }
        </script>
    </body>
</html>
