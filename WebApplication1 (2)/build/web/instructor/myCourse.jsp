<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
    <head>
        <title>My Course</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            /* ===== Body & Container ===== */
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #fafafa;
                margin: 0;
                padding: 0;
                display: flex;
            }

            .container {
                flex: 1;
                margin-left: 220px;
                max-width: 1200px;
                padding: 40px 20px;
            }

            /* ===== Sidebar ===== */
            .sidebar {
                width: 220px;
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

            /* ===== Top Bar ===== */
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
            }

            .btn-create:hover {
                background: #1aa3a5;
            }

            /* ===== Course Card ===== */
            .course-card {
                display: flex;
                flex-direction: column;
                background: #fff;
                border-radius: 12px;
                margin-bottom: 20px;
                padding: 20px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
                transition: transform 0.2s;
            }

            .course-card:hover {
                transform: translateY(-3px);
            }

            .course-header {
                display: flex;
                flex-direction: row;
                align-items: flex-start;
                gap: 20px;
                flex-wrap: wrap;
            }

            .course-thumb {
                width: 160px;
                height: 100px;
                border-radius: 8px;
                overflow: hidden;
                flex-shrink: 0;
                background: #eaeaea;
            }

            .course-thumb img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .course-info {
                flex: 1;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .course-title {
                font-weight: 600;
                font-size: 18px;
                color: #1b1f3b;
                text-decoration: none;
                margin-bottom: 5px;
            }

            .course-title:hover {
                color: #22c1c3;
            }

            .course-desc {
                color: #555;
                font-size: 14px;
                line-height: 1.4;
                margin-bottom: 10px;
            }

            /* ===== Course Actions ===== */
            .course-actions {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                align-items: center;
                margin-top: 10px;
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

            /* ===== Status badge ===== */
            .course-status {
                font-size: 13px;
                font-weight: 600;
                padding: 2px 8px;
                border-radius: 6px;
                color: #fff;
            }

            .status-pending {
                background: #f39c12;
            }
            .status-approved {
                background: #27ae60;
            }
            .status-rejected {
                background: #e74c3c;
            }
            .status-other {
                background: #888;
            }

            /* ===== Module Section ===== */
            .module-section {
                margin-top: 15px;
                background: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
            }

            .module-icons {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-bottom: 10px;
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
                font-size: 14px;
                color: #333;
            }

            /* ===== Responsive ===== */
            @media (max-width: 768px) {
                .course-header {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .course-thumb {
                    width: 100%;
                    height: 180px;
                }

                .course-actions {
                    margin-top: 15px;
                }

                .container {
                    margin-left: 0;
                    padding: 20px 10px;
                }

                .sidebar {
                    display: none;
                }
            }
            /* Popup modal */
            .modal {
                display: none;
                position: fixed;
                z-index: 9999;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.4);
                justify-content: center;
                align-items: center;
            }

            .modal-content {
                position: relative;
                background: white;
                border-radius: 12px;
                padding: 30px;
                width: 420px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.2);
                animation: fadeIn 0.3s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .modal h2 {
                text-align: center;
                margin-bottom: 20px;
                color: #1b1f3b;
            }

            .modal input, .modal textarea, .modal select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-family: inherit;
            }

            .modal button {
                width: 100%;
                padding: 10px;
                background: #22c1c3;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
            }

            .modal button:hover {
                background: #1aa3a5;
            }

            .close-btn {
                position: absolute;
                top: 15px;
                right: 20px;
                background: none;
                border: none;
                font-size: 24px;
                color: #555;
                cursor: pointer;
                transition: color 0.2s;
            }

            .close-btn:hover {
                color: #000;
                background: none;
            }

        </style>

        <script>
            const modulesCache = {};

            async function loadModules(courseId) {
                const iconsContainer = document.getElementById("module-icons-" + courseId);
                const contentDiv = document.getElementById("module-content-" + courseId);
                contentDiv.innerHTML = "<em>Loading modules...</em>";

                try {
                    const response = await fetch('${pageContext.request.contextPath}/ModuleServlet?courseId=' + courseId);

                    if (!response.ok)
                        throw new Error("Cannot fetch modules");

                    const modules = await response.json();
                    console.log("📦 Modules for course " + courseId, modules);


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
                console.log("👉 Clicked module:", modules[index]);


                const module = modules[index];
                document.querySelectorAll(`#module-icons-${courseId} span`).forEach(s => s.classList.remove("active"));
                document.getElementById(`mod-${courseId}-${index}`).classList.add("active");
                console.log("👉 Type of description:", typeof module.description, module.description);
                console.log("Is truthy?:", Boolean(module.description));
                console.log("Description raw:", JSON.stringify(module.description));
                console.log("Length:", module.description?.length);


                contentDiv.innerHTML = `
      <div style="background:#f9f9f9; padding:10px; border-radius:8px;">
          <b>\${module.title}</b><br>
          <span style='color:#555;'>\${module.description ? module.description : "No description"}</span>
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
                <li><i class="fa-solid fa-house"></i> EMLS</li>
                <li class="active"><i class="fa-solid fa-book"></i> My Course</li>
                <li><i class="fa-solid fa-chart-line"></i> Dashboard</li>
                <li><a href="<%=request.getContextPath()%>/CreateQuestionServlet"><i class="fa-solid fa-question"></i> Create Question</a></li>
                <li><a href="<%=request.getContextPath()%>/createQuiz.jsp"><i class="fa-solid fa-list-check"></i> Create Quiz</a></li>
                <li><a href="<%=request.getContextPath()%>/questionBank.jsp"><i class="fa-solid fa-database"></i> Question Bank</a></li>
                <li><a href="<%=request.getContextPath()%>/QuizListServlet"><i class="fa-solid fa-gear"></i> Quiz Management</a></li>
            </ul>
            <div class="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div style="display:flex; align-items:center;">
                <div style="margin-left:auto; display:flex; gap:10px;">
                    <i class="fa fa-bell"></i>
                    <a href="<%=request.getContextPath()%>/profile.jsp">
                        <i class="fa fa-user-circle"></i>
                    </a>
                </div>
            </div>
            <c:if test="${not empty sessionScope.msg}">
                <div style="background:#d1f2eb; color:#148f77; padding:10px 15px; border-radius:6px; margin-bottom:20px;">
                    ${sessionScope.msg}
                </div>
                <c:remove var="msg" scope="session"/>
            </c:if>



            <h2>My Course</h2>

            <div class="top-bar">
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/instructor/courses" method="get">
                        <input type="text" name="search" value="${param.search}" placeholder="🔍 Search course...">
                    </form>
                </div>
                <button class="btn-create" onclick="openModal()">Create</button>
            </div>

            <div id="createCourseModal" class="modal">
                <div class="modal-content">
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                    <div id="modal-body">
                        <em>Loading...</em>
                    </div>
                </div>
            </div>


            <!-- Course List -->
            <c:choose>
                <c:when test="${empty courses}">
                    <h3>No courses found</h3>
                </c:when>
                <c:otherwise>
                    <c:forEach var="c" items="${courses}">
                        <div class="course-card">
                            <div class="course-header">
                                <div class="course-thumb">
                                    <c:choose>
                                        <c:when test="${not empty c.thumbnail}">
                                            <img src="${pageContext.request.contextPath}/uploads/${c.thumbnail}" alt="${c.title}" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/uploads/default-course.png" alt="Default course" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="course-info">
                                    <a href="${pageContext.request.contextPath}/CourseDetailServlet?courseId=${c.id}" class="course-title">${c.title}</a>
                                    <div class="course-desc">
                                        ${empty c.description ? 'No description' : c.description}
                                    </div>
                                </div>
                                <div class="course-actions">
                                    <!-- Hiển thị trạng thái -->
                                    <div style="display:flex; align-items:center; gap:8px;">
                                        <span style="font-size:13px; font-weight:600; color:
                                              <c:choose>
                                                  <c:when test="${c.status eq 'Pending'}">#f39c12</c:when>
                                                  <c:when test="${c.status eq 'Approved'}">#27ae60</c:when>
                                                  <c:when test="${c.status eq 'Rejected'}">#e74c3c</c:when>
                                                  <c:otherwise>#888</c:otherwise>
                                              </c:choose>;">
                                            ${c.status}
                                        </span>

                                        <!-- Dòng mô tả trạng thái -->
                                        <c:choose>
                                            <c:when test="${c.status eq 'Pending'}">
                                                <span style="font-size:12px; color:#f39c12;">⏳ Waiting for Approval</span>
                                            </c:when>
                                            <c:when test="${c.status eq 'Approved'}">
                                                <span style="font-size:12px; color:#27ae60;">🌍 In Public</span>
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <!-- Nếu KHÔNG phải Pending/Approved thì mới cho Edit/Delete/Publish -->
                                    <c:if test="${fn:toLowerCase(fn:trim(c.status)) ne 'pending' and fn:toLowerCase(fn:trim(c.status)) ne 'approved'}">
                                        <!-- Nút Edit -->
                                        <button type="button" class="icon-btn" title="Edit" onclick="openEditModal(${c.id})">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>


                                        <!-- Nút Delete -->
                                        <form action="${pageContext.request.contextPath}/instructor/courses" method="post"
                                              style="display:inline;" onsubmit="return confirmDelete('${c.title}')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="courseId" value="${c.id}">
                                            <button type="submit" class="icon-btn delete" title="Delete">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>

                                        <!-- Nút Publish -->
                                        <form action="${pageContext.request.contextPath}/instructor/courses" method="post" 
                                              style="display:inline;" 
                                              onsubmit="return confirmPublish('${c.title}')">
                                            <input type="hidden" name="action" value="publish">
                                            <input type="hidden" name="courseId" value="${c.id}">
                                            <button type="submit" class="icon-btn" title="Publish" style="color:#22c1c3;">
                                                <i class="fa-solid fa-upload"></i>
                                            </button>
                                        </form>
                                    </c:if>

                                </div>



                            </div>
                            <div class="module-section" id="modules-${c.id}">
                                <div class="module-icons" id="module-icons-${c.id}"></div>
                                <div class="module-content" id="module-content-${c.id}">
                                    <em>Loading modules...</em>
                                </div>
                            </div>
                            <script>loadModules("${c.id}");</script>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <script>
            const modal = document.getElementById("createCourseModal");

            async function openModal() {
                modal.style.display = "flex";
                document.getElementById("modal-body").innerHTML = "<em>Loading...</em>";

                try {
                    const response = await fetch('${pageContext.request.contextPath}/instructor/courses?action=create');
                    const html = await response.text();
                    document.getElementById("modal-body").innerHTML = html;
                } catch (e) {
                    document.getElementById("modal-body").innerHTML = "<span style='color:red'>Error loading form</span>";
                }
            }
            async function openEditModal(courseId) {
                const modal = document.getElementById("createCourseModal");
                modal.style.display = "flex";
                document.getElementById("modal-body").innerHTML = "<em>Loading...</em>";

                try {
                    const response = await fetch(
                            `${pageContext.request.contextPath}/instructor/courses?action=edit&courseId=` + courseId
                            );
                    const html = await response.text();
                    document.getElementById("modal-body").innerHTML = html;
                } catch (e) {
                    document.getElementById("modal-body").innerHTML = "<span style='color:red'>Error loading form</span>";
                }
            }



            function closeModal() {
                modal.style.display = "none";
            }

            window.onclick = function (e) {
                if (e.target === modal)
                    closeModal();
            }
            function confirmPublish(title) {
                return confirm(`Do you want to publish the course "${title}"? It will be sent for admin approval.`);
            }

        </script>
        <c:if test="${not empty sessionScope.msg}">
            <script>
                Swal.fire({
                    icon: "${sessionScope.msgType}",
                    title: 'Notification',
                    text: "${fn:escapeXml(sessionScope.msg)}",
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                });
            </script>
            <c:remove var="msg" scope="session"/>
            <c:remove var="msgType" scope="session"/>
        </c:if>


    </body>
</html>
