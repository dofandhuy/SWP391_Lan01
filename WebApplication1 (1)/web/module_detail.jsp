<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Module Detail</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            * {
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, sans-serif;
            }
            body {
                margin: 0;
                display: flex;
                flex-direction: column;
                height: 100vh;
                background-color: #f9fafb;
            }

            /* Header */
            header {
                width: 100%;
                height: 60px;
                background-color: #fff;
                border-bottom: 1px solid #ddd;
            }

            /* Main container */
            .main-container {
                flex: 1;
                display: flex;
                height: calc(100vh - 60px);
            }

            /* Sidebar - Course Material */
            .module-sidebar {
                width: 260px;
                background-color: #fff;
                border-right: 1px solid #ddd;
                padding: 20px;
                overflow-y: auto;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
            }

            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background-color: #e8f0fe;
                color: #1a73e8;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: 0.2s;
                margin-bottom: 20px;
            }
            .back-btn:hover {
                background-color: #d2e3fc;
            }

            .module-sidebar h3 {
                font-size: 16px;
                margin-bottom: 15px;
            }
            .module-list {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .module-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 8px;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .module-item:hover {
                background-color: #f2f6ff;
            }
            .module-item.active {
                background-color: #e8f0fe;
                border-left: 4px solid #00ADC3;
            }
            .module-item label {
                cursor: pointer;
                font-size: 14px;
            }

            /* * MỤC CSS MỚI: Dành cho Grade và Report
            */
            .sidebar-links {
                margin-top: 20px;
            }
            .sidebar-divider {
                border: 0;
                border-top: 1px solid #eee;
                margin: 15px 0;
            }
            .sidebar-link-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 8px;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.2s;
                text-decoration: none;
                color: #333;
                font-size: 14px;
                font-weight: 500;
            }
            .sidebar-link-item i {
                width: 16px; /* Căn chỉnh icon */
                text-align: center;
                color: #555;
            }
            .sidebar-link-item:hover {
                background-color: #f2f6ff;
            }
            /* Hết mục CSS mới */


            /* Content area */
            .content-area {
                flex: 1;
                display: flex;
                flex-direction: row;
                background-color: #f9fafb;
                overflow: hidden;
            }

            /* Module detail */
            .module-detail {
                flex: 1;
                background-color: #fff;
                border-radius: 8px;
                margin: 20px;
                padding: 25px 30px;
                overflow-y: auto;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }

            .module-detail h2 {
                font-size: 20px;
                margin-bottom: 10px;
            }
            .module-detail p {
                line-height: 1.6;
                color: #444;
            }

            .lesson-section {
                margin-top: 20px;
                border-top: 1px solid #eee;
                padding-top: 15px;
            }
            .lesson {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            .lesson-info strong {
                display: block;
                font-size: 15px;
                color: #222;
            }
            .lesson-info span {
                font-size: 13px;
                color: #777;
            }

            .lesson button {
                background-color: #00ADC3;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 6px 12px;
                cursor: pointer;
                font-size: 14px;
            }
            .lesson button:hover {
                background-color: #008a9e; /* Đổi màu hover */
            }


            /* * MỤC CSS MỚI: Dành cho Modal "Report an Issue"
            */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.4);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
                /* Ẩn modal ban đầu */
                display: none;
            }
            .modal-content {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                width: 100%;
                max-width: 500px;
                padding: 24px;
                box-sizing: border-box;
                position: relative;
            }
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .modal-header h2 {
                font-size: 1.8rem;
                font-weight: 700;
                margin: 0;
            }
            .close-button {
                font-family: Arial, sans-serif;
                font-size: 2rem;
                font-weight: 300;
                color: #606770;
                cursor: pointer;
                line-height: 1;
            }
            .modal-body p, .modal-body .form-label {
                font-size: 1rem;
                font-weight: 600;
                color: #1c1e21;
                margin-bottom: 12px;
            }
            .radio-group {
                margin-bottom: 20px;
            }
            .radio-option {
                display: block;
                position: relative;
                padding-left: 35px;
                margin-bottom: 12px;
                cursor: pointer;
                font-size: 1rem;
                color: #1c1e21;
                min-height: 22px;
                display: flex;
                align-items: center;
            }
            .radio-option input {
                position: absolute;
                opacity: 0;
            }
            .radio-checkmark {
                position: absolute;
                top: 50%;
                left: 0;
                transform: translateY(-50%);
                height: 20px;
                width: 20px;
                background-color: #fff;
                border: 2px solid #adb5bd;
                border-radius: 50%;
            }
            .radio-option input:checked ~ .radio-checkmark {
                border-color: #007bff;
            }
            .radio-checkmark:after {
                content: "";
                position: absolute;
                display: none;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #007bff;
            }
            .radio-option input:checked ~ .radio-checkmark:after {
                display: block;
            }
            .form-group {
                margin-bottom: 24px;
            }
            .form-group textarea {
                width: 100%;
                height: 100px;
                border: 1px solid #ccd0d5;
                border-radius: 8px;
                padding: 12px;
                font-size: 1rem;
                resize: vertical;
                box-sizing: border-box;
            }
            .form-group textarea::placeholder {
                color: #8a9199;
            }
            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                border-top: 1px solid #e0e0e0;
                padding-top: 20px;
            }
            .btn {
                padding: 10px 24px;
                border-radius: 6px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                border: none;
            }
            .btn-cancel {
                background-color: #ffffff;
                color: #007bff;
                border: 2px solid #007bff;
            }
            .btn-submit {
                background-color: #e4e6eb;
                color: #bcc0c4;
                border: 2px solid #e4e6eb;
                cursor: not-allowed;
            }
            /* Hết CSS modal */

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container">

            <aside class="module-sidebar">
                <button class="back-btn" onclick="history.back()">← Trở về</button>

                <h3>Course Material</h3>
                <div class="module-list">
                    <c:forEach var="m" items="${modulesList}">
                        <div class="module-item ${m.id == module.id ? 'active' : ''}"
                             onclick="window.location.href = 'ModuleDetailServlet?courseID=${m.courseId}&moduleID=${m.id}'">
                            <label>Module ${m.orderIndex}: ${m.title}</label>
                        </div>
                    </c:forEach>
                </div>

                <div class="sidebar-links">
                    <hr class="sidebar-divider">

                    <a href="GradesServlet?courseID=${module.courseId}" class="sidebar-link-item">
                        <i class="fa-solid fa-graduation-cap"></i>
                        <span>Grade</span>
                    </a>

                    <a href="#" class="sidebar-link-item" onclick="openReportModal(event)">
                        <i class="fa-solid fa-flag"></i>
                        <span>Report Admin</span>
                    </a>
                </div>
            </aside>

            <div class="content-area">
                <div class="module-detail">
                    <h2>${module.title}</h2>
                    <p>${module.description}</p>

                    <div class="lesson-section">
                        <c:forEach var="lesson" items="${lessonsList}">
                            <div class="lesson">
                                <div class="lesson-info">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${lesson.lessonType eq 'Video'}">🎥</c:when>
                                            <c:when test="${lesson.lessonType eq 'Reading'}">📖</c:when>
                                            <c:otherwise>📄</c:otherwise>
                                        </c:choose>
                                        ${lesson.title}
                                    </strong>
                                    <%-- Sửa lại: Hiển thị duration (nếu có) thay vì orderIndex --%>
                                    <span>${lesson.lessonType} · ${lesson.duration} min</span>
                                </div>
                                <c:if test="${not empty lesson.videoUrl or not empty lesson.readingContent}">
                                    <button onclick="window.location.href = 'LessonDetailServlet?lessonID=${lesson.id}'">Start</button>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal-overlay" id="reportModal">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>Report an issue</h2>
                    <span class="close-button" onclick="closeReportModal()">&times;</span>
                </div>

                <form action="ReportServlet" method="post">
                    <div class="modal-body">

                        <input type="hidden" name="courseId" value="${module.courseId}" />
                        <input type="hidden" name="moduleId" value="${module.id}" />

                        <p>Select an issue you'd like to report</p>

                        <div class="radio-group">
                            <label class="radio-option">Content improvement
                                <input type="radio" name="issueType" value="improvement">
                                <span class="radio-checkmark"></span>
                            </label>
                            <label class="radio-option">Offensive content
                                <input type="radio" name="issueType" value="offensive" checked>
                                <span class="radio-checkmark"></span>
                            </label>
                            <label class="radio-option">Technical issue
                                <input type="radio" name="issueType" value="technical">
                                <span class="radio-checkmark"></span>
                            </label>
                        </div>

                        <div class="form-group">
                            <label for="issueDescription" class="form-label">Describe the issue</label>
                            <textarea id="issueDescription" name="description"
                                      placeholder="Example: The language used in this video by the interviewer is offensive..."></textarea>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-submit" disabled>Submit</button>
                        <button type="button" class="btn btn-cancel" onclick="closeReportModal()">Cancel</button>
                    </div>
                </form>

            </div>
        </div>
        <script>
            const modal = document.getElementById('reportModal');

            function openReportModal(event) {
                event.preventDefault(); // Ngăn thẻ <a> nhảy lên đầu trang
                if (modal) {
                    modal.style.display = 'flex';
                }
            }

            function closeReportModal() {
                if (modal) {
                    modal.style.display = 'none';
                }
            }

            // Đóng modal nếu bấm ra ngoài
            window.onclick = function (event) {
                if (event.target === modal) {
                    closeReportModal();
                }
            }

            // Kích hoạt nút Submit khi người dùng nhập mô tả
            const descriptionTextarea = document.getElementById('issueDescription');
            const submitButton = modal.querySelector('.btn-submit');

            if (descriptionTextarea && submitButton) {
                descriptionTextarea.addEventListener('input', function () {
                    if (descriptionTextarea.value.trim().length > 0) {
                        submitButton.disabled = false;
                        submitButton.style.backgroundColor = '#007bff';
                        submitButton.style.borderColor = '#007bff';
                        submitButton.style.color = '#ffffff';
                        submitButton.style.cursor = 'pointer';
                    } else {
                        submitButton.disabled = true;
                        submitButton.style.backgroundColor = '#e4e6eb';
                        submitButton.style.borderColor = '#e4e6eb';
                        submitButton.style.color = '#bcc0c4';
                        submitButton.style.cursor = 'not-allowed';
                    }
                });
            }
        </script>
    </body>
</html>