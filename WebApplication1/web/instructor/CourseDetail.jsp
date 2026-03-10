<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>${course.title} - Course Detail</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            /* ===== Modal Popup ===== */
            .modal {
                display: none;
                position: fixed;
                z-index: 999;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.4);
                justify-content: center;
                align-items: center;
                backdrop-filter: blur(2px);
            }

            .modal-content {
                background: #fff;
                padding: 30px 40px;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.15);
                width: 450px;
                position: relative;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .close-btn {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 20px;
                cursor: pointer;
                color: #666;
            }

            .close-btn:hover {
                color: #000;
            }

            .modal h2 {
                text-align: center;
                margin-bottom: 20px;
                color: #1b1f3b;
            }

            .modal label {
                font-weight: 500;
                color: #333;
            }

            .modal input[type="text"],
            .modal textarea,
            .modal select {
                width: 100%;
                padding: 10px 12px;
                margin-top: 5px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 15px;
            }

            .modal textarea {
                height: 100px;
                resize: none;
            }

            .modal button {
                width: 100%;
                background: #22c1c3;
                border: none;
                padding: 12px;
                border-radius: 8px;
                color: #fff;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.3s;
            }

            .modal button:hover {
                background: #1aa0a3;
            }

            /* ===== Khi modal mở, khóa scroll nền ===== */
            body.modal-open {
                overflow: hidden;
                position: fixed;
                width: 100%;
            }

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
                                    <a href="${pageContext.request.contextPath}/LessonDetailServlet?lessonId=${l.lessonID}">
                                        ${l.title}
                                    </a>
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
            /* ==== Hàm mở & đóng modal chung ==== */
            function openModal(id) {
                document.body.classList.add('modal-open');
                document.getElementById(id).style.display = 'flex';
            }

            function closeModal(id) {
                document.body.classList.remove('modal-open');
                document.getElementById(id).style.display = 'none';
            }

            /* ===== Create Lesson ===== */
            function createLesson() {
                const activeModule = document.querySelector('#module-list li.active');
                if (!activeModule) {
                    alert('Please select a module first!');
                    return;
                }
                const moduleId = activeModule.getAttribute('onclick').match(/\d+/)[0];
                document.getElementById('moduleIdField').value = moduleId;
                openModal('createLessonModal');
            }

            function closeLessonModal() {
                closeModal('createLessonModal');
            }

            window.onclick = function (e) {
                const createModal = document.getElementById('createLessonModal');
                const editModal = document.getElementById('editLessonModal');
                if (e.target === createModal)
                    closeLessonModal();
                if (e.target === editModal)
                    closeEditLessonModal();
            };

            function toggleFileUpload(checkbox) {
                document.getElementById('fileUpload').style.display = checkbox.checked ? 'block' : 'none';
            }

            function createModule(courseId) {
                window.location.href = '${pageContext.request.contextPath}/instructor/createModule.jsp?courseId=' + courseId;
            }

            function editLesson(id) {
                fetch('${pageContext.request.contextPath}/instructor/EditLessonServlet?lessonId=' + id)
                        .then(res => res.text())
                        .then(html => {
                            document.querySelector('#editLessonFormContainer').innerHTML = html;
                            openModal('editLessonModal');
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Không thể tải nội dung chỉnh sửa bài học!');
                        });
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

            /* ===== Edit Lesson ===== */
            function editLesson(id) {
                fetch('${pageContext.request.contextPath}/instructor/EditLessonServlet?lessonId=' + id)
                        .then(res => res.text())
                        .then(html => {
                            document.querySelector('#editLessonModal .modal-content').innerHTML = html;
                            openModal('editLessonModal');
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Không thể tải nội dung chỉnh sửa bài học!');
                        });
            }

            function closeEditLessonModal() {
                closeModal('editLessonModal');
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
            /* ======== MODULE FUNCTIONS ======== */

            /* Mở modal Create Module */
            function createModule(courseId) {
                document.querySelector('#createModuleForm input[name="courseId"]').value = courseId;
                openModal('createModuleModal');
            }

            /* Đóng modal */
            function closeCreateModuleModal() {
                closeModal('createModuleModal');
            }

            /* Xử lý submit Create Module qua AJAX */
            document.getElementById('createModuleForm').addEventListener('submit', function (e) {
                e.preventDefault();

                const formData = new FormData(this);

                fetch('${pageContext.request.contextPath}/instructor/CreateModuleServlet', {
                    method: 'POST',
                    body: formData
                })
                        .then(res => res.text())
                        .then(result => {
                            alert('Module created successfully!');
                            closeCreateModuleModal();
                            location.reload(); // reload để cập nhật danh sách module
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Failed to create module.');
                        });
            });

            /* Edit Module */
            function editModule(id) {
                fetch('${pageContext.request.contextPath}/instructor/EditModuleServlet?moduleId=' + id)
                        .then(res => res.text())
                        .then(html => {
                            document.querySelector('#editModuleFormContainer').innerHTML = html;
                            openModal('editModuleModal');
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Cannot load edit module form!');
                        });
            }

            /* Đóng modal Edit Module */
            function closeEditModuleModal() {
                closeModal('editModuleModal');
            }

        </script>

        <div id="createLessonModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeLessonModal()">&times;</span>
                <h2>Create Lesson</h2>

                <form id="createLessonForm"
                      action="${pageContext.request.contextPath}/instructor/CreateLessonServlet"
                      method="post">
                    <input type="hidden" name="moduleId" id="moduleIdField" />
                    <label>Lesson Title:</label>
                    <input type="text" name="title" placeholder="Enter title..." required />
                    <label>Description:</label>
                    <textarea name="content" placeholder="Enter description..."></textarea>
                    <label>Select Type:</label>
                    <select name="lessonType" required>
                        <option value="video">Video</option>
                        <option value="document">Document</option>
                        <option value="quiz">Quiz</option>
                    </select>
                    <button type="submit">Save</button>
                </form>
            </div>
        </div>


        <div id="editLessonModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeEditLessonModal()">&times;</span>
                <h2>Edit Lesson</h2>
                <div id="editLessonFormContainer"></div>
            </div>
        </div>
        <!-- ===== Create Module Modal ===== -->
        <div id="createModuleModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeCreateModuleModal()">&times;</span>
                <h2>Create Module</h2>

                <form id="createModuleForm" action="${pageContext.request.contextPath}/CreateModuleServlet" method="post">
                    <input type="hidden" name="courseId" value="${course.id}">
                    <label>Module Title:</label>
                    <input type="text" name="title" required>

                    <label>Description:</label>
                    <textarea name="description" rows="4"></textarea>

                    <button type="submit">Create Module</button>
                </form>
            </div>
        </div>

        <!-- ===== Edit Module Modal ===== -->
        <div id="editModuleModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeEditModuleModal()">&times;</span>
                <div id="editModuleFormContainer">
                    <!-- AJAX load Edit Form here -->
                </div>
            </div>
        </div>


    </body>
</html>
