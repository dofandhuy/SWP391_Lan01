<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>My Course</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #fafafa;
                margin: 0;
                padding: 0;
                display: flex;
            }

            /* Sidebar */
            .sidebar {
                width: 200px;
                background: #fff;
                border-right: 1px solid #eee;
                height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 25px 0;
                position: fixed;
            }

            .sidebar ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar li {
                padding: 15px 25px;
                color: #1b1f3b;
                cursor: pointer;
                transition: 0.3s;
                font-weight: 500;
            }

            .sidebar li:hover,
            .sidebar li.active {
                background: #22c1c3;
                color: white;
            }

            .logout {
                padding: 15px 25px;
                color: #1b1f3b;
                cursor: pointer;
                font-weight: 500;
                border-top: 1px solid #eee;
            }

            .logout:hover {
                background: #f5f5f5;
            }

            /* Main content */
            .container {
                flex: 1;
                margin-left: 220px;
                max-width: 1100px;
                padding: 40px;
            }

            h2 {
                color: #1b1f3b;
                font-weight: 600;
                margin-bottom: 25px;
            }

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .search-bar input {
                width: 260px;
                padding: 10px 15px;
                border-radius: 30px;
                border: 1px solid #ccc;
                outline: none;
                font-size: 14px;
            }

            .btn-create {
                background: #22c1c3;
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.3s;
                text-decoration: none;
            }

            .btn-create:hover {
                background: #1aa3a5;
            }

            /* Course Card */
            .course-card {
                background: #f0f0f0;
                border-radius: 10px;
                margin-bottom: 20px;
                padding: 20px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            }

            .course-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
            }

            .course-info {
                font-size: 15px;
                color: #333;
            }

            .course-title {
                font-weight: bold;
                font-size: 17px;
                color: #1b1f3b;
                text-decoration: none;
            }

            .course-title:hover {
                color: #22c1c3;
            }

            .course-desc {
                color: #555;
                font-size: 14px;
                margin-top: 5px;
            }

            /* Edit/Delete buttons */
            .course-actions {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .icon-btn {
                background: none;
                border: none;
                color: #1b1f3b;
                font-size: 18px;
                cursor: pointer;
                transition: 0.2s;
            }

            .icon-btn:hover {
                color: #22c1c3;
            }

            .icon-btn.delete:hover {
                color: #e74c3c;
            }

            /* Module Section */
            .module-section {
                margin-top: 15px;
                background: #fff;
                padding: 15px;
                border-radius: 8px;
            }

            .module-icons {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-bottom: 15px;
            }

            .module-icons span {
                background: #e6e6e6;
                border-radius: 50%;
                width: 35px;
                height: 35px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-weight: bold;
                color: #222;
                cursor: pointer;
                transition: 0.2s;
            }

            .module-icons span:hover,
            .module-icons span.active {
                background: #22c1c3;
                color: white;
            }

            .module-content {
                border-top: 1px solid #ddd;
                padding-top: 10px;
                min-height: 40px;
                font-size: 14px;
                color: #333;
            }
        </style>

        <script>
            const modulesCache = {};

            async function loadModules(courseId) {
                const iconsContainer = document.getElementById("module-icons-" + courseId);
                const contentDiv = document.getElementById("module-content-" + courseId);
                contentDiv.innerHTML = "<em>Loading modules...</em>";

                try {
                    const contextPath = "<%= request.getContextPath() %>";
                    const response = await fetch(`${contextPath}/ModuleServlet?courseId=${courseId}`);

                    if (!response.ok)
                        throw new Error("Cannot fetch modules");

                    const modules = await response.json();
                    modulesCache[courseId] = modules;
                    iconsContainer.innerHTML = "";

                    if (!modules || modules.length === 0) {
                        contentDiv.innerHTML = "<em>No modules found.</em>";
                        return;
                    }

                    modules.forEach((m, i) => {
                        const span = document.createElement("span");
                        span.textContent = i + 1;
                        span.id = `mod-${courseId}-${i}`;
                        span.onclick = () => showModule(courseId, i);
                        iconsContainer.appendChild(span);
                    });

                    contentDiv.innerHTML = "Click a module to view details.";

                } catch (err) {
                    console.error(err);
                    contentDiv.innerHTML = "<span style='color:red;'>Error loading modules.</span>";
                }
            }

            function showModule(courseId, index) {
                const modules = modulesCache[courseId];
                const contentDiv = document.getElementById("module-content-" + courseId);

                if (!modules || modules.length === 0) {
                    contentDiv.innerHTML = "<em>No modules available.</em>";
                    return;
                }

                const module = modules[index];
                document.querySelectorAll(`#module-icons-${courseId} span`).forEach(s => s.classList.remove("active"));
                document.getElementById(`mod-${courseId}-${index}`).classList.add("active");

                contentDiv.innerHTML = `
                    <div style="background:#f9f9f9; padding:10px; border-radius:8px;">
                        <b>${module.title}</b><br>
                        <span style='color:#555;'>${module.description || "No description"}</span>
                    </div>
                `;
            }

            function confirmDelete(title) {
                return confirm(`Are you sure you want to delete the course "${title}"?`);
            }
        </script>
    </head>

    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <ul>
                <li class="active">HomePage</li>
                <li>My Course</li>
                <li>DashBoard</li>
                <li><a href="<%=request.getContextPath()%>/createQuestion.jsp">
            createQuestion
        </a></li>
                <li><a href="<%=request.getContextPath()%>/createQuiz.jsp">
            createQuiz
        </a></li>
                
            </ul>
            <div class="logout">Logout</div>
        </div>

        <!-- Main Content -->
        
        <div class="container">
           <div style="display: flex; align-items: center;">
    <!-- Khoảng trống bên trái nếu cần, hoặc các phần tử khác -->

    <!-- Bọc 2 icon sang phải -->
    <div style="margin-left: auto; display: flex; gap: 10px;">
        <!-- Icon chuông -->
        <i class="fa fa-bell"></i>

        <!-- Icon người -->
        <a href="<%=request.getContextPath()%>/profile">
            <i class="fa fa-user-circle"></i>
        </a>
    </div>
</div>

    <h2>My Course</h2>

    <div class="top-bar">
        <div class="search-bar">
            <form action="${pageContext.request.contextPath}/instructor/courses" method="get">
                <input type="text" name="search" value="${param.search}" placeholder="🔍 Search course...">
            </form>
        </div>
        <a href="createCourse.jsp" class="btn-create">Create</a>
    </div>

            <c:choose>
                <c:when test="${empty courses}">
                    <h3>No courses found</h3>
                </c:when>
                <c:otherwise>
                    <c:forEach var="c" items="${courses}">
                        <div class="course-card">
                            <div class="course-header">
                                <div class="course-info">
                                    <a href="${pageContext.request.contextPath}/CourseDetailServlet?courseId=${c.id}" class="course-title">${c.title}</a>
                                    <div class="course-desc">
                                        ${empty c.description ? 'No description' : c.description}
                                    </div>
                                </div>

                                <!-- Edit / Delete buttons -->
                                <div class="course-actions">
                                    <a href="${pageContext.request.contextPath}/instructor/editCourse.jsp?courseId=${c.id}"
                                       title="Edit" class="icon-btn"><i class="fa-solid fa-pen-to-square"></i></a>

                                    <form action="${pageContext.request.contextPath}/instructor/courses" method="post"
                                          style="display:inline;" onsubmit="return confirmDelete('${c.title}')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="courseId" value="${c.id}">
                                        <button type="submit" class="icon-btn delete"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </div>
                            </div>

                            <div class="module-section" id="modules-${c.id}">
                                <div class="module-icons" id="module-icons-${c.id}"></div>
                                <div class="module-content" id="module-content-${c.id}">
                                    <em>Loading modules...</em>
                                </div>
                            </div>

                            <script>
                                loadModules("${c.id}");
                            </script>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
