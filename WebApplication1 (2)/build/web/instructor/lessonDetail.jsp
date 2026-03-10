<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <title>${lesson.title} - Lesson Detail</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: #f8f9fa;
                display: flex;
                gap: 20px;
                margin: 0;
            }
            .sidebar {
                width: 220px;
                /*background: white;*/
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                padding: 20px;
                height: 100vh;
                overflow-y: auto;
            }
            .sidebar a {
                display: block;
                padding: 8px;
                color: #333;
                text-decoration: none;
                border-radius: 6px;
            }
            .sidebar a.active, .sidebar a:hover {
                background: #22c1c3;
                color: white;
            }
            .main {
                flex: 1;
                padding: 20px 40px;
            }
            .lesson-video iframe, .lesson-video video {
                width: 100%;
                border-radius: 12px;
                height: 360px;
            }
            .section {
                margin-top: 25px;
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 8px rgba(0,0,0,0.05);
            }
            .section h3 {
                margin-bottom: 10px;
                color: #1b1f3b;
            }
            .section a {
                color: #007bff;
                text-decoration: none;
            }
            button {
                background: #22c1c3;
                color: white;
                border: none;
                padding: 8px 12px;
                border-radius: 6px;
                cursor: pointer;
            }
            button:hover {
                background: #1aa0a3;
            }

            /* ================= Modal Style ================= */
            .modal {
                display: none;
                position: fixed;
                z-index: 9999;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.4);
            }

            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 20px;
                border-radius: 10px;
                width: 400px;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                animation: fadeIn 0.3s ease-in-out;
            }

            .modal-content h3 {
                margin-top: 0;
                color: #1b1f3b;
            }

            .close {
                color: #aaa;
                float: right;
                font-size: 24px;
                cursor: pointer;
            }

            .close:hover {
                color: black;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }
        </style>

        <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>

    </head>

    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <h3>${module.title}</h3>
            <c:forEach var="ls" items="${moduleLessons}">
                <a href="${pageContext.request.contextPath}/instructor/lessonDetail?lessonId=${ls.lessonID}"
                   class="${ls.lessonID == lesson.lessonID ? 'active' : ''}">
                    ${ls.title}
                </a>
            </c:forEach>

            <!-- ===== Back to Course Detail Button ===== -->
            <div style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                <a href="${pageContext.request.contextPath}/CourseDetailServlet?courseId=${module.courseId}"
                   style="display:flex; align-items:center; gap:8px; color:#22c1c3; font-weight:500; text-decoration:none;">
                    <i class="fa-solid fa-arrow-left"></i> Back to Course
                </a>
            </div>
        </div>


        <!-- Main -->
        <div class="main">
            <h2>${lesson.title}</h2>
            <p style="color:#555;">${lesson.content}</p>
            <c:if test="${not empty sessionScope.status}">
                <div style="background:#e0f7fa; padding:10px; border-radius:6px; margin:15px; color:#00695c;">
                    ${sessionScope.status}
                </div>
                <%
                    session.removeAttribute("status");
                %>
            </c:if>

            <c:choose>
                <%-- ================= VIDEO LESSON ================= --%>
                <c:when test="${lesson.lessonType == 'video'}">
                    <div class="section lesson-video">
                        <c:forEach var="v" items="${videos}">
                            <div style="margin-bottom:10px;">
                                <c:choose>
                                    <c:when test="${v.videoType == 'External'}">
                                        <iframe src="${v.videoUrl}" frameborder="0" allowfullscreen></iframe>
                                        </c:when>
                                        <c:otherwise>
                                        <video controls>
                                            <source src="${v.filePath}" type="video/mp4">
                                        </video>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/instructor/deleteVideo?videoId=${v.videoID}&lessonId=${lesson.lessonID}"
                                   onclick="return confirm('Are you sure you want to delete this video?');"
                                   style="display:inline-block; margin-top:5px; color:#dc3545;">🗑 Delete</a>
                            </div>
                        </c:forEach>

                    </div>

                    <div class="section">
                        <form action="${pageContext.request.contextPath}/instructor/uploadVideo" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="lessonId" value="${lesson.lessonID}">
                            <label>Upload local video:</label>
                            <input type="file" name="file">
                            <button type="submit">Upload</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/instructor/uploadVideoUrl" method="post" style="margin-top:10px;">
                            <input type="hidden" name="lessonId" value="${lesson.lessonID}">
                            <label>Or link external video:</label>
                            <input type="text" name="videoUrl" placeholder="https://..." style="width:70%">
                            <button type="submit">Add URL</button>
                        </form>
                    </div>

                    <div class="section">
                        <h3>Documents</h3>
                        <ul>
                            <c:forEach var="d" items="${documents}">
                                <li>
                                    <c:choose>
                                        <c:when test="${fn:endsWith(d.fileName, '.pdf')}">
                                            <a href="javascript:void(0);" onclick="openPdfViewer('${pageContext.request.contextPath}/${d.filePath}')">
                                                <i class="fa-solid fa-file-pdf" style="color:#d32f2f;"></i> ${d.fileName}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/${d.filePath}" target="_blank">
                                                <i class="fa fa-file"></i> ${d.fileName}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/instructor/deleteDocument?documentId=${d.documentID}&lessonId=${lesson.lessonID}"
                                       onclick="return confirm('Delete this document?');"
                                       style="color:#dc3545; margin-left:10px;">🗑 Delete</a>
                                </li>
                            </c:forEach>
                        </ul>


                        <form action="${pageContext.request.contextPath}/instructor/uploadDocument" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="lessonId" value="${lesson.lessonID}">
                            <label>Add Document:</label>
                            <input type="file" name="file">
                            <button type="submit">Upload</button>
                        </form>
                    </div>

                    <<div class="section">
                        <h3><i class="fa-solid fa-circle-question"></i> Lesson Questions</h3>

                        <!-- Danh sách câu hỏi (demo tĩnh) -->
                        <c:choose>
                            <c:when test="${not empty questions}">
                                <ul>
                                    <c:forEach var="q" items="${questions}">
                                        <li>
                                            <strong>Q${q.questionID}:</strong> ${q.content}
                                            <br>
                                            <small style="color:#777;">Type: ${q.questionType}</small>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <p>No questions created yet.</p>
                            </c:otherwise>
                        </c:choose>

                        <!-- Nút thêm câu hỏi -->
                        <button type="button" onclick="openQuestionModal()">+ Add Question</button>
                    </div>
                </c:when>

                <%-- ================= DOCUMENT LESSON ================= --%>
                <c:when test="${lesson.lessonType == 'document'}">
                    <div class="section">
                        <h3>Documents</h3>
                        <ul>
                            <c:forEach var="d" items="${documents}">
                                <li><a href="${d.filePath}" target="_blank"><i class="fa fa-file"></i> ${d.fileName}</a></li>
                                </c:forEach>
                        </ul>
                        <form action="uploadDocument" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="lessonId" value="${lesson.lessonID}">
                            <label>Add Document:</label>
                            <input type="file" name="file">
                            <button type="submit">Upload</button>
                        </form>
                    </div>
                </c:when>

                <%-- ================= QUIZ LESSON ================= --%>
                <c:when test="${lesson.lessonType == 'quiz'}">
                    <div class="section">
                        <h3><i class="fa-solid fa-circle-question"></i> Lesson Quiz Questions</h3>

                        <c:choose>
                            <c:when test="${not empty quiz}">
                                <p><strong>Quiz from Module:</strong> ${quiz.title}</p>
                                <p style="color:#777;">${quiz.description}</p>

                                <c:choose>
                                    <c:when test="${not empty questions}">
                                        <ul>
                                            <c:forEach var="q" items="${questions}">
                                                <li style="margin-bottom:10px;">
                                                    <strong>Q${q.questionID}:</strong> ${q.content}<br>
                                                    <small style="color:#777;">Type: ${q.questionType}</small>

                                                    <c:if test="${not empty q.answerOptions}">
                                                        <ul style="margin-top:5px;">
                                                            <c:forEach var="a" items="${q.answerOptions}">
                                                                <li>
                                                                    <c:choose>
                                                                        <c:when test="${a.isCorrect}">
                                                                            ✅ <strong>${a.content}</strong>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${a.content}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:if>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <p>No questions found in the assigned quiz of this module.</p>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>

                            <c:otherwise>
                                <p>No quiz is assigned to this module.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>


            </c:choose>
        </div>

        <div id="assignQuizModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeAssignModal()">&times;</span>
                <h3><i class="fa-solid fa-link"></i> Assign Quiz to Lesson</h3>

                <form action="${pageContext.request.contextPath}/instructor/assignQuizToLesson" method="post">
                    <input type="hidden" name="lessonId" value="${lesson.lessonID}">

                    <label><strong>Select a quiz:</strong></label><br>
                    <select name="quizId" style="width:100%; padding:6px;">
                        <c:forEach var="q" items="${availableQuizzes}">
                            <option value="${q.quizID}">${q.title}</option>
                        </c:forEach>
                    </select>

                    <div style="text-align:right; margin-top:15px;">
                        <button type="button" onclick="closeAssignModal()" style="background:#ccc;">Cancel</button>
                        <button type="submit">Assign</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="questionModal" class="modal">
            <div class="modal-content" style="width:500px;">
                <span class="close" onclick="closeQuestionModal()">&times;</span>
                <h3><i class="fa-solid fa-plus-circle"></i> Add New Question</h3>

                <form id="questionForm">
                    <label><strong>Question Content:</strong></label><br>
                    <textarea name="questionContent" rows="3" style="width:100%; resize:none;" placeholder="Enter question text..."></textarea>

                    <label style="margin-top:10px;"><strong>Question Type:</strong></label><br>
                    <select name="questionType" style="width:100%;">
                        <option value="multiple">Multiple Choice</option>
                        <option value="truefalse">True / False</option>
                        <option value="shortanswer">Short Answer</option>
                    </select>


                    <div id="answersSection" style="margin-top:10px;">
                        <label><strong>Answer Options:</strong></label>
                        <div id="answerInputs">
                            <div style="display:flex; gap:6px; margin-bottom:5px;">
                                <input type="text" name="answer1" placeholder="Answer 1" style="flex:1;">
                                <input type="checkbox" name="correct1"> Correct
                            </div>
                            <div style="display:flex; gap:6px; margin-bottom:5px;">
                                <input type="text" name="answer2" placeholder="Answer 2" style="flex:1;">
                                <input type="checkbox" name="correct2"> Correct
                            </div>
                        </div>
                        <button type="button" onclick="addAnswerInput()" style="background:#ddd; color:#333;">+ Add Option</button>
                    </div>

                    <div style="text-align:right; margin-top:15px;">
                        <button type="button" onclick="closeQuestionModal()" style="background:#ccc;">Cancel</button>
                        <button type="button" onclick="saveQuestion()">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="pdfViewerModal" class="modal">
            <div class="modal-content" style="width:80%; max-width:900px; height:80vh;">
                <span class="close" onclick="closePdfViewer()">&times;</span>
                <iframe id="pdfFrame" style="width:100%; height:90%; border:none;"></iframe>
            </div>
        </div>


        <script>

            function openQuestionModal() {
                document.getElementById("questionModal").style.display = "block";
            }
            function closeQuestionModal() {
                document.getElementById("questionModal").style.display = "none";
                document.getElementById("questionForm").reset();
            }
            window.onclick = function (event) {
                const modal = document.getElementById("questionModal");
                if (event.target === modal) {
                    closeQuestionModal();
                }
            };


            let answerCount = 2;
            function addAnswerInput() {
                answerCount++;
                const container = document.getElementById("answerInputs");
                const div = document.createElement("div");
                div.style.display = "flex";
                div.style.gap = "6px";
                div.style.marginBottom = "5px";
                div.innerHTML = `
            <input type="text" name="answer${answerCount}" placeholder="Answer ${answerCount}" style="flex:1;">
            <input type="checkbox" name="correct${answerCount}"> Correct
        `;
                container.appendChild(div);
            }


            function saveQuestion() {
                alert("Question saved (frontend only). You can connect this form to a servlet later.");
                closeQuestionModal();
            }
        </script>
        <!-- ================= PDF VIEWER MODAL ================= -->
        <div id="pdfViewerModal" class="modal" style="display:none;">
            <div class="modal-content" style="width:90%; height:90%; max-width:1200px; position:relative;">
                <span class="close" onclick="closePdfViewer()" style="position:absolute; top:10px; right:20px; font-size:28px; color:#333; cursor:pointer;">&times;</span>
                <iframe id="pdfFrame" src="" width="100%" height="100%" frameborder="0"></iframe>
            </div>
        </div>

        <script>
            // Open PDF in modal using Mozilla PDF.js online viewer
            function openPdfViewer(filePath) {
                const viewerUrl = "https://mozilla.github.io/pdf.js/web/viewer.html?file=" + encodeURIComponent(filePath);
                document.getElementById("pdfFrame").src = viewerUrl;
                document.getElementById("pdfViewerModal").style.display = "block";
            }

            function closePdfViewer() {
                document.getElementById("pdfViewerModal").style.display = "none";
                document.getElementById("pdfFrame").src = "";
            }

            window.onclick = function (event) {
                const modal = document.getElementById("pdfViewerModal");
                if (event.target === modal) {
                    closePdfViewer();
                }
            };

            function openAssignModal() {
                document.getElementById("assignQuizModal").style.display = "block";
            }
            function closeAssignModal() {
                document.getElementById("assignQuizModal").style.display = "none";
            }
        </script>

    </body>
</html>
