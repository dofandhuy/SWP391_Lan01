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

                    <div class="section">
                        <h3><i class="fa-solid fa-circle-question"></i> Lesson Questions</h3>

                        <c:choose>

                            <c:when test="${not empty questions}">
                                <ul style="list-style:none; padding-left:0;">
                                    <c:forEach var="q" items="${questions}" varStatus="loop">
                                        <li style="margin-bottom:15px; padding:10px; background:#f1f3f5; border-radius:6px;">
                                            <strong>Q${loop.index + 1}:</strong> ${q.questionText} <br>
                                            <small style="color:#555;">Type: ${q.questionType} | Difficulty: ${q.difficultyLevel}</small>
                                            <ul style="margin-top:5px;">
                                                <c:forEach var="a" items="${q.options}">
                                                    <li>
                                                        ${a.answerText} <c:if test="${a.correct}">(Correct)</c:if>
                                                        </li>
                                                </c:forEach>
                                            </ul>

                                            <a href="${pageContext.request.contextPath}/DeleteQuestionLessonServlet?questionId=${q.questionID}&lessonId=${lesson.lessonID}"
                                               onclick="return confirm('Bạn có chắc muốn xóa câu hỏi này không?');"
                                               style="color:#dc3545; text-decoration:none;">🗑 Delete</a>

                                            <a href="${pageContext.request.contextPath}/EditQuestionLessonServlet?id=${q.questionID}&lessonId=${lesson.lessonID}"

                                               style="color: blue; text-decoration:none;">Edit</a>


                                        </li>
                                    </c:forEach>
                                </c:when>


                                <c:otherwise>
                                    <p>No questions created yet.</p>
                                </c:otherwise>
                            </c:choose>


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

                <c:when test="${lesson.lessonType == 'quiz'}">
                    <div class="section">
                        <h3><i class="fa-solid fa-circle-question"></i> Lesson Quiz Questions</h3>

                        <c:choose>
                            <c:when test="${not empty quiz}">
                                <p><strong>Quiz from Module:</strong> ${quiz.title}</p>

                                <c:choose>
                                    <c:when test="${not empty qs}">
                                        <table border="1" style="width:100%; border-collapse:collapse; margin-top:15px;">
                                            <thead style="background-color:#009688; color:white;">
                                                <tr>
                                                    <th style="padding:10px;">ID</th>
                                                    <th style="padding:10px;">Text</th>
                                                    <th style="padding:10px;">Options</th>
                                                    <th style="padding:10px;">Correct Answer</th>
                                                    <th style="padding:10px;">Category</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="q" items="${qs}">
                                                    <tr style="border-bottom:1px solid #ddd;">
                                                        <td style="padding:10px;">${q.questionID}</td>
                                                        <td style="padding:10px;">${q.questionText}</td>
                                                        <td style="padding:10px;">
                                                            <ul style="margin:0; padding-left:18px;">
                                                                <c:forEach var="a" items="${q.options}">
                                                                    <li>${a.answerText}</li>
                                                                    </c:forEach>
                                                            </ul>
                                                        </td>
                                                        <td style="padding:10px;">
                                                            <ul style="margin:0; padding-left:18px;">
                                                                <c:forEach var="a" items="${q.options}">
                                                                    <c:if test="${a.correct}">
                                                                        <li>${a.answerText}</li>
                                                                        </c:if>
                                                                    </c:forEach>
                                                            </ul>
                                                        </td>
                                                        <td style="padding:10px;">${q.categoryName}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>

                                    <c:otherwise>
                                        <p><i>No questions found in the assigned quiz of this module.</i></p>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>

                            <c:otherwise>
                                <p><i>No quiz is assigned to this module.</i></p>
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
                <form id="questionForm" method="post" action="${pageContext.request.contextPath}/CreateQuestionLesson">
                    <input type="hidden" name="lessonId" value="${lesson.lessonID}">
                    <label><strong>Question Content:</strong></label><br>
                    <textarea name="questionContent" rows="3" style="width:100%; resize:none;" placeholder="Enter question text..."></textarea>

                    <label style="margin-top:10px;"><strong>Question Type:</strong></label><br>
                    <select name="questionType">
                        <option value="MCQ">Multiple Choice</option>

                        <option value="FillBlank">FillBank</option>
                    </select>

                    <label style="margin-top:10px;"><strong>Difficulty:</strong></label><br>
                    <select name="difficulty" style="width:100%;">
                        <option value="Easy">Easy</option>
                        <option value="Medium">Medium</option>
                        <option value="Hard">Hard</option>
                    </select>

                    <div id="answersSection" style="margin-top:10px;">
                        <label><strong>Answer Options:</strong></label>
                        <div id="answerInputs">
                            <div class="answer-row">
                                <input type="text" name="answers" placeholder="Answer 1" required style="flex:1;">
                                <label><input type="checkbox" name="correct" value="0"> Correct</label>
                                <button type="button" onclick="removeAnswer(this)" style="background:#e74c3c;color:#fff;border:none;padding:2px 6px;">❌</button>
                            </div>
                        </div>
                        <button type="button" id="addOptionBtn" onclick="addAnswerInput()" style="background:#ddd; color:#333;">+ Add Option</button>
                    </div>

                    <div style="text-align:right; margin-top:15px;">
                        <button type="button" onclick="closeQuestionModal()" style="background:#ccc;">Cancel</button>
                        <button type="submit">Save</button>
                    </div>
                </form>

            </div>
        </div>     

        <div id="editModal" class="modal" style="display:none;">
            <div class="modal-content" style="width:600px;">
                <span class="close" onclick="closeEditPopup()">&times;</span>
                <h3>Edit Question</h3>
                <form id="editForm">
                    <input type="hidden" name="questionID" id="editQuestionID">

                    <label><strong>Question Text:</strong></label><br>
                    <textarea name="questionText" id="editQuestionText" rows="3" style="width:100%; resize:none;"></textarea><br>

                    <label><strong>Difficulty:</strong></label><br>
                    <select name="difficulty" id="editDifficulty" style="width:100%;">
                        <option value="Easy">Easy</option>
                        <option value="Medium">Medium</option>
                        <option value="Hard">Hard</option>
                    </select><br><br>

                    <div id="editAnswers"></div>

                    <button type="submit" style="background:#4CAF50;color:white;padding:5px 10px;">Save</button>
                </form>
            </div>
        </div>
                <script>
            let answerCount = 2;
            function openQuestionModal() {
                document.getElementById("questionModal").style.display = "block";
            }
            function closeQuestionModal() {
                document.getElementById("questionModal").style.display = "none";
            }
            // ✅ Thêm input mới
            function addAnswerInput() {
                answerCount++;
                const container = document.getElementById("answerInputs");
                const div = document.createElement("div");
                div.className = "answer-row";
                div.innerHTML = `
              <input type="text" name="answers" placeholder="Answer ${answerCount}" required style="flex:1;">
              <label><input type="checkbox" name="correct" value="${answerCount - 1}"> Correct</label>
              <button type="button" onclick="removeAnswer(this)" style="background:#e74c3c;color:#fff;border:none;padding:2px 6px;">❌</button>
          `;
                container.appendChild(div);
                updateCheckboxValues();
            }
            

            // ✅ Xóa 1 option
            function removeAnswer(btn) {
                btn.parentElement.remove();
                updateCheckboxValues();
            }

            // ✅ Cập nhật lại value cho checkbox (đảm bảo backend đọc đúng index)
            function updateCheckboxValues() {
                const checkboxes = document.querySelectorAll('#answerInputs input[type="checkbox"]');
                checkboxes.forEach((cb, idx) => cb.value = idx);
            }


            function openEditPopup(id) {
                fetch(`GetQuestionDataServlet?id=${id}`)
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById("editQuestionID").value = data.questionID;
                            document.getElementById("editQuestionText").value = data.questionText;
                            document.getElementById("editDifficulty").value = data.difficultyLevel;

                            const answersDiv = document.getElementById("editAnswers");
                            answersDiv.innerHTML = "";
                            data.options.forEach(opt => {
                                answersDiv.innerHTML += `
                  <div>
                    <input type="hidden" name="answerID" value="${opt.answerID}">
                    <input type="text" name="answerText" value="${opt.answerText}" style="width:70%">
                    <label><input type="checkbox" name="correctAnswer" value="${opt.answerID}" ${opt.correct ? "checked" : ""}> Correct</label>
                  </div>
                `;
                            });

                            document.getElementById("editModal").style.display = "block";
                        });
            }
            document.addEventListener("DOMContentLoaded", function () {
                window.openEditPopup = function (id) {
                    fetch('EditQuestionLessonServlet?id=${id}&action=getData')
                            .then(res => res.json())
                            .then(data => {
                                document.getElementById("editQuestionID").value = data.questionID;
                                document.getElementById("editQuestionText").value = data.questionText;
                                document.getElementById("editDifficulty").value = data.difficultyLevel;

                                const answersDiv = document.getElementById("editAnswers");
                                answersDiv.innerHTML = "";
                                data.options.forEach(opt => {
                                    const div = document.createElement("div");
                                    div.innerHTML = `
                    <input type="hidden" name="answerID" value="${opt.answerID}">
                    <input type="text" name="answerText" value="${opt.answerText}" style="width:70%">
                    <label><input type="checkbox" name="correctAnswer" value="${opt.answerID}" ${opt.correct ? "checked" : ""}> Correct</label>
                  `;
                                    answersDiv.appendChild(div);
                                });

                                document.getElementById("editModal").style.display = "block";
                            });
                };

                window.closeEditPopup = function () {
                    document.getElementById("editModal").style.display = "none";
                };

                document.getElementById("editForm").onsubmit = function (e) {
                    e.preventDefault();
                    const formData = new FormData(this);
                    fetch("EditQuestionLessonServlet", {
                        method: "POST",
                        body: formData
                    })
                            .then(() => {
                                alert("Cập nhật thành công!");
                                location.reload();
                            });
                };
            });
            
              document.addEventListener("DOMContentLoaded", function () {
            const form = document.getElementById("questionForm");
            if (form) {
                form.addEventListener("submit", function (event) {
                    const checked = document.querySelectorAll('#answerInputs input[type="checkbox"]:checked');
                    if (checked.length === 0) {
                        event.preventDefault(); // Ngăn form gửi
                        alert("Vui lòng chọn ít nhất 1 đáp án đúng!");
                    }
                });
            }
        });
// ✅ Ẩn/hiện nút Add Option theo loại câu hỏi
document.addEventListener("DOMContentLoaded", function () {
    const questionTypeSelect = document.querySelector('select[name="questionType"]');
    const addOptionBtn = document.getElementById("addOptionBtn");
    const answerInputs = document.getElementById("answerInputs");

    function toggleAddOption() {
        const type = questionTypeSelect.value;

        if (type === "FillBlank") {
            // Ẩn nút +Add Option
            addOptionBtn.style.display = "none";

            // Giữ lại 1 dòng duy nhất
            const rows = answerInputs.querySelectorAll(".answer-row");
            rows.forEach((row, index) => {
                if (index > 0) row.remove();
            });

            // ✅ Lấy dòng còn lại
            const firstRow = answerInputs.querySelector(".answer-row");
            if (firstRow) {
                const checkbox = firstRow.querySelector('input[type="checkbox"]');
                const checkboxLabel = firstRow.querySelector("label");

                // Ẩn checkbox nhưng tick sẵn là đúng
                if (checkbox) {
                    checkbox.checked = true;
                    checkbox.style.display = "none";
                }

                if (checkboxLabel) checkboxLabel.style.display = "none";
            }
        } else {
            // Hiện lại nút Add Option
            addOptionBtn.style.display = "inline-block";

            // Hiện lại checkbox trong dòng đầu
            const firstRow = answerInputs.querySelector(".answer-row");
            if (firstRow) {
                const checkbox = firstRow.querySelector('input[type="checkbox"]');
                const checkboxLabel = firstRow.querySelector("label");

                if (checkbox) checkbox.style.display = "inline-block";
                if (checkboxLabel) checkboxLabel.style.display = "inline-block";
                checkbox.checked = false; // bỏ tick khi quay lại MCQ
            }
        }
    }

    // Gọi khi load trang
    toggleAddOption();

    // Gọi lại khi user đổi loại câu hỏi
    questionTypeSelect.addEventListener("change", toggleAddOption);
});
        </script>

        <div id="pdfViewerModal" class="modal">
            <div class="modal-content" style="width:80%; max-width:900px; height:80vh;">
                <span class="close" onclick="closePdfViewer()">&times;</span>
                <iframe id="pdfFrame" style="width:100%; height:90%; border:none;"></iframe>
            </div>
        </div>



        <!-- ================= PDF VIEWER MODAL ================= -->
        <div id="pdfViewerModal" class="modal" style="display:none;">
            <div class="modal-content" style="width:90%; height:90%; max-width:1200px; position:relative;">
                <span class="close" onclick="closePdfViewer()" style="position:absolute; top:10px; right:20px; font-size:28px; color:#333; cursor:pointer;">&times;</span>
                <iframe id="pdfFrame" src="" width="100%" height="100%" frameborder="0"></iframe>
            </div>
        </div>

        <script>
            let answerCount = 2;

// Hàm thêm input câu trả lời mới
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

// Hàm mở modal
            function openQuestionModal() {
                document.getElementById("questionModal").style.display = "block";
            }

// ❌ Không reset form khi đóng modal — chỉ ẩn đi thôi
            function closeQuestionModal() {
                document.getElementById("questionModal").style.display = "none";
            }

// ✅ Reset form chỉ khi thêm xong (gọi từ servlet hoặc sau khi submit)
            function resetQuestionForm() {
                const form = document.getElementById("questionForm");
                form.reset();

                // Đặt lại 2 ô mặc định đầu tiên
                const container = document.getElementById("answerInputs");
                container.innerHTML = `
        <div style="display:flex; gap:6px; margin-bottom:5px;">
            <input type="text" name="answer1" placeholder="Answer 1" style="flex:1;">
            <input type="checkbox" name="correct1"> Correct
        </div>
        <div style="display:flex; gap:6px; margin-bottom:5px;">
            <input type="text" name="answer2" placeholder="Answer 2" style="flex:1;">
            <input type="checkbox" name="correct2"> Correct
        </div>
    `;
                answerCount = 2; // reset lại biến đếm
            }

            function saveQuestion() {
                document.getElementById("questionForm").submit();
            }

        </script>

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
