<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Module Detail</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --primary-color: #00ADC3;
                --primary-color-dark: #008a9e;
                --primary-color-light: #e0f7fa;
                --primary-color-highlight: #b2ebf2;
                --text-color-primary: #222;
                --text-color-secondary: #555;
                --text-color-light: #777;
                --bg-color: #f9fafb;
                --surface-color: #ffffff;
                --border-color: #e0e0e0;
                --shadow: 0 2px 4px rgba(0,0,0,0.06);
            }

            * {
                box-sizing: border-box;
                font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }
            body {
                margin: 0;
                display: flex;
                flex-direction: column;
                height: 100vh;
                background-color: var(--bg-color);
                color: var(--text-color-primary);
                font-size: 16px;
            }
            header {
                width: 100%;
                height: 60px;
                background-color: var(--surface-color);
                border-bottom: 1px solid var(--border-color);
                box-shadow: 0 1px 3px rgba(0,0,0,0.03);
            }
            .main-container {
                flex: 1;
                display: flex;
                height: calc(100vh - 60px);
                overflow: hidden;
            }
            .module-sidebar {
                width: 300px;
                background-color: var(--surface-color);
                border-right: 1px solid var(--border-color);
                padding: 24px;
                overflow-y: auto;
                display: flex;
                flex-direction: column;
            }
            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background-color: var(--primary-color-light);
                color: var(--primary-color-dark);
                border: none;
                border-radius: 8px;
                padding: 10px 14px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 600;
                transition: 0.2s;
                margin-bottom: 24px;
                text-decoration: none;
            }
            .back-btn:hover {
                background-color: var(--primary-color-highlight);
            }
            .module-sidebar h3 {
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: var(--text-color-light);
                margin-top: 10px;
                margin-bottom: 10px;
            }
            .module-list {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .module-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 12px;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.2s;
                border-left: 4px solid transparent;
            }
            .module-item:hover {
                background-color: #f5f5f5;
            }
            .module-item.active {
                background-color: var(--primary-color-light);
                border-left: 4px solid var(--primary-color);
                font-weight: 600;
                color: var(--primary-color-dark);
            }

            .sidebar-links {
                margin-top: 24px;
            }
            .sidebar-divider {
                border: 0;
                border-top: 1px solid var(--border-color);
                margin: 16px 0;
            }
            .sidebar-link-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 8px;
                border-radius: 6px;
                text-decoration: none;
                color: var(--text-color-secondary);
                font-size: 15px;
                font-weight: 500;
                transition: 0.2s;
            }
            .sidebar-link-item i {
                width: 20px;
                text-align: center;
                color: var(--text-color-light);
            }
            .sidebar-link-item:hover {
                background-color: #f5f5f5;
            }

            .content-area {
                flex: 1;
                display: flex;
                flex-direction: column;
                background-color: var(--bg-color);
                overflow-y: auto;
                padding: 24px;
            }
            .module-detail {
                background-color: var(--surface-color);
                border-radius: 8px;
                padding: 32px 40px;
                box-shadow: var(--shadow);
            }
            .module-detail h2 {
                font-size: 28px;
                font-weight: 700;
                margin: 0 0 10px 0;
            }
            .module-detail p {
                line-height: 1.7;
                color: var(--text-color-secondary);
                font-size: 16px;
                max-width: 80ch;
            }

            .lesson-section {
                margin-top: 30px;
                border-top: 1px solid var(--border-color);
                padding-top: 20px;
            }

            /* * ======================================
             * PHẦN CSS ĐÃ ĐƯỢC CẬP NHẬT (BẮT ĐẦU)
             * ======================================
            */

            /* 1. Sửa .lesson-item: Bỏ padding và gap */
            .lesson-item {
                display: flex;
                flex-direction: column;
                width: 100%;
                /* gap: 20px; */ /* Đã xóa */
                /* padding: 24px 8px; */ /* Đã xóa */
                border-bottom: 1px solid #f0f0f0;
            }
            .lesson-item:hover {
                background-color: transparent; /* Hover sẽ xử lý trên nút */
            }
            .lesson-item:last-child {
                border-bottom: none;
            }

            /* 2. Sửa .lesson-header (giờ là <button>) */
            .lesson-header.accordion-trigger {
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
                background: linear-gradient(to right, #e0f7fa, #ffffff);
                border-left: 5px solid var(--primary-color);
                border-radius: 8px;
                padding: 12px 18px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                transition: background 0.3s;

                /* Thuộc tính cho <button> */
                width: 100%;
                border: none;
                cursor: pointer;
                font-family: inherit;
                font-size: inherit;
                color: inherit;
                text-align: left;
            }
            .lesson-header.accordion-trigger:hover,
            .lesson-header.accordion-trigger.active {
                background: var(--primary-color-light);
            }

            /* Đảm bảo text bên trong button giữ nguyên style */
            .lesson-header.accordion-trigger strong {
                font-size: 20px;
                font-weight: 700;
                color: var(--primary-color-dark);
            }

            /* Giữ lại style cho .lesson-type */
            .lesson-header .lesson-type {
                background: var(--primary-color);
                color: white;
                font-size: 13px;
                padding: 4px 10px;
                border-radius: 12px;
                font-weight: 600;
                text-transform: capitalize;
            }

            /* 3. CSS cho icon và nhóm bên phải */
            .lesson-meta-group {
                display: flex;
                align-items: center;
                gap: 16px; /* Khoảng cách giữa "Type" và icon */
            }
            .accordion-icon {
                transition: transform 0.3s ease;
                font-size: 14px;
                color: var(--text-color-light);
            }
            .accordion-trigger.active .accordion-icon {
                transform: rotate(180deg);
            }

            /* 4. CSS cho panel (nội dung ẩn) */
            .accordion-panel {
                /* Đây là class cũ .lesson-content */
                width: 100%;

                /* CSS Ẩn/hiện */
                max-height: 0;
                overflow: hidden;
                transition: max-height 0.3s ease-out;
                background-color: var(--surface-color);
            }

            /* 5. CSS cho wrapper bên trong panel */
            .panel-content-inner {
                /* Thêm padding để tạo khoảng cách cho nội dung */
                padding: 24px 18px;
            }

            /* * ======================================
             * PHẦN CSS ĐÃ ĐƯỢC CẬP NHẬT (KẾT THÚC)
             * ======================================
            */

            /* VIDEO & QUIZ: Căn đều chiều ngang */
            .lesson-content {
                width: 100%;
                /* Bỏ class này đi vì .accordion-panel đã thay thế */
            }

            .lesson-video-embed {
                position: relative;
                padding-bottom: 56.25%;
                height: 0;
                overflow: hidden;
                border-radius: 8px;
                background: #000;
            }
            .lesson-video-embed iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: 0;
            }

            .lesson-quiz {
                margin-top: 20px;
                background-color: #f9fafb;
                border-radius: 6px;
                padding: 20px;
                border: 1px solid #e0e0e0;
                width: 100%;
            }
            .quiz-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 16px;
                color: var(--primary-color-dark);
            }
            .quiz-question {
                margin-bottom: 18px;
            }
            .quiz-question p {
                margin: 0 0 8px 0;
                font-weight: 600;
            }
            .quiz-question label {
                display: block;
                margin-bottom: 6px;
                cursor: pointer;
                color: var(--text-color-secondary);
            }
            .btn-submit-quiz {
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 18px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .btn-submit-quiz:hover {
                background-color: var(--primary-color-dark);
            }
            .quiz-result {
                margin-top: 16px;
                font-weight: 600;
                color: var(--primary-color-dark);
            }
            .btn-start-lesson {
                display: inline-block;
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 6px;
                padding: 12px 24px;
                font-weight: 600;
                font-size: 16px;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.2s;
                text-align: center;
            }
            .btn-start-lesson:hover {
                background-color: var(--primary-color-dark);
            }
            /* Thêm icon cho nút Quiz */
            .btn-quiz::before {
                font-family: 'Font Awesome 6 Free';
                content: '\f0ae'; /* Icon list-check */
                font-weight: 900;
                margin-right: 8px;
            }

            /* --- SỬA CLASS NÀY --- */
            .lesson-reading {
                color: var(--text-color-secondary);
                line-height: 1.7;
                font-size: 16px;

                /* THÊM 2 DÒNG NÀY */
                max-width: 800px;
                margin: 0 auto;
            }

            .lesson-documents {
                margin-top: 10px;
                background: #f9f9f9;
                padding: 12px 18px;
                border-radius: 10px;
                border-left: 4px solid #007bff;
            }

            .lesson-documents h4 {
                margin-bottom: 10px;
            }

            .document-item {
                background: white;
                padding: 10px;
                border-radius: 8px;
                margin-bottom: 10px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .accordion-panel {
                max-height: 0;
                overflow: hidden;
                transition: max-height 0.3s ease-out;
            }


            /*quiz-detail*/
            .quiz-header h1 {
                font-size: 2.5rem;
                font-weight: bold;
                color: #333;
            }
            .instructor-info {
                font-size: 1.2rem;
                color: #555;
                margin-bottom: 20px;
            }
            .card {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                padding: 24px;
                margin-bottom: 20px;
            }
            .assignment-details {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #f0f5ff;
                border: 1px solid #d6e4ff;
            }
            .details-group p {
                margin: 4px 0;
            }
            .details-group .label {
                font-size: 0.9rem;
                font-weight: bold;
                color: #333;
            }
            .details-group .value {
                font-size: 1rem;
                color: #555;
            }
            .details-group .value-highlight {
                font-size: 1rem;
                color: #008000;
                font-weight: bold;
            }
            .start-button {
                background-color: #0056d6;
                color: white;
                font-size: 1rem;
                font-weight: bold;
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
            }
            .start-button:disabled {
                background-color: #a0a0a0;
                cursor: not-allowed;
            }
            .wait-message {
                color: #d90000;
                font-size: 0.9rem;
                text-align: right;
                margin-top: 5px;
            }
            .grade-details .status {
                color: #666;
                font-size: 0.9rem;
            }
            .grade-details .score {
                font-size: 2rem;
                font-weight: bold;
                color: #333;
                margin-top: 10px;
            }
            .grade-details .score-and-review {
                display: flex; /* Bật Flexbox */
                align-items: center; /* Căn giữa các phần tử theo chiều dọc */
                justify-content: space-between; /* Đẩy điểm sang trái, nút sang phải */
                margin-top: 15px; /* Thêm khoảng cách phía trên */
            }

            .grade-details .score {
                margin-top: 0; /* Xóa margin-top mặc định của score */
                margin-bottom: 0; /* Xóa margin-bottom nếu có */
            }

            .grade-details .review-button {
                /* Điều chỉnh kích thước/margin nút nếu cần */
                padding: 10px 20px; /* Làm nút nhỏ hơn một chút */
                font-size: 0.9rem;
                margin-left: 20px; /* Thêm khoảng cách bên trái nút */
            }
            /* Style cũ cho .result-action vẫn được giữ */
            .result-action {
                display: inline-block;
                text-decoration: none;
                background-color: #007bff;
                color: #ffffff;
                padding: 12px 25px; /* Giữ padding gốc nếu review-button không ghi đè */
                border-radius: 6px;
                font-size: 1rem; /* Giữ font gốc nếu review-button không ghi đè */
                font-weight: 500;
                transition: background-color 0.2s ease;
                margin: 5px; /* Giữ margin gốc nếu review-button không ghi đè */
            }
            .result-action:hover {
                background-color: #0056b3;
            }

        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container">
            <aside class="module-sidebar">
                <a href="StudentDashboardServlet" class="back-btn">
                    <i class="fa-solid fa-arrow-left"></i>
                    <span>Trở về</span>
                </a>

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

            <main class="content-area">
                <div class="module-detail">
                    <h2>${module.title}</h2>
                    <p>${module.description}</p>

                    <div class="lesson-section">
                        <c:forEach var="lesson" items="${lessonsList}">
                            <div class="lesson-item">

                                <%-- 1. Đây là NÚT BẤM (đã đổi từ div sang button) --%>
                                <button class="lesson-header accordion-trigger">
                                    <strong><i class="fa-solid fa-book-open"></i> ${lesson.title}</strong>

                                    <%-- 2. Bọc phần bên phải để thêm icon --%>
                                    <span class="lesson-meta-group">
                                        <span class="lesson-type">${lesson.lessonType}</span>
                                        <i class="fa-solid fa-chevron-down accordion-icon"></i>
                                    </span>
                                </button>

                                <%-- 3. Đây là NỘI DUNG ẨN (thêm class accordion-panel) --%>
                                <div class="lesson-content accordion-panel">
                                    <%-- 4. Thêm wrapper để có padding --%>
                                    <div class="panel-content-inner">

                                        <c:set var="docs" value="${lessonDocsMap[lesson.lessonID]}"/>
                                        <c:set var="videos" value="${lessonVidMap[lesson.lessonID]}" />

                                        <%-- 🎥 VIDEO --%>
                                        <c:if test="${fn:toLowerCase(lesson.lessonType) == 'video'}">
                                            <c:choose>
                                                <c:when test="${empty videos}">
                                                    <p>Chưa có video nào được gán link.</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="vid" items="${videos}">
                                                        <div class="lesson-video-embed">
                                                            <iframe src="${vid.videoUrl}" allowfullscreen></iframe>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                            <%-- 🧠 QUIZ --%>
                                            <h3 style="color:green">
                                                Quick Test
                                            </h3>
                                            <c:set var="lessonQuestions" value="${lessonQuestionsMap[lesson.lessonID]}" />
                                            <form id="quizForm_${lesson.lessonID}">
                                                <c:forEach var="q" items="${lessonQuestions}" varStatus="loop">
                                                    <div class="quiz-question">
                                                        <p>${loop.index + 1}. ${q.questionText}</p>
                                                        <c:forEach var="opt" items="${q.options}">
                                                            <label>
                                                                <input type="radio"
                                                                       name="q_${lesson.lessonID}_${q.questionID}"
                                                                       value="${opt.correct == true ? 'true' : 'false'}">
                                                                ${opt.answerText}
                                                            </label><br>
                                                        </c:forEach>
                                                    </div>
                                                </c:forEach>

                                                <button type="button"
                                                        class="btn-submit-quiz"
                                                        onclick="checkAnswers(${lesson.lessonID})">
                                                    Kiểm tra đáp án
                                                </button>

                                                <div id="result_${lesson.lessonID}" class="quiz-result"></div>
                                            </form>
                                        </c:if>



                                        <%-- 📄 TÀI LIỆU (Reading) --%>
                                        <c:if test="${not empty docs}">
                                            <div class="lesson-documents mt-3">
                                                <h3>Learning Materials</h3>
                                                <c:forEach var="doc" items="${docs}">
                                                    <div class="document-item">
                                                        <p><i class="fa-solid fa-file-word text-primary"></i> ${doc.fileName}</p>

                                                        <c:choose>
                                                            <%-- PDF / DOCX / PPTX hiển thị bằng ViewerJS --%>
                                                            <c:when test="${fn:endsWith(doc.fileName, '.pdf') 
                                                                            || fn:endsWith(doc.fileName, '.doc') 
                                                                            || fn:endsWith(doc.fileName, '.docx') 
                                                                            || fn:endsWith(doc.fileName, '.ppt') 
                                                                            || fn:endsWith(doc.fileName, '.pptx')}">
                                                                    <iframe 
                                                                        src="${pageContext.request.contextPath}/viewerjs/#../${doc.filePath}" 
                                                                        width="100%" height="600px" frameborder="0"
                                                                        allowfullscreen webkitallowfullscreen>
                                                                    </iframe>

                                                            </c:when>

                                                            <%-- Ảnh --%>
                                                            <c:when test="${fn:endsWith(doc.fileName, '.png') || fn:endsWith(doc.fileName, '.jpg') || fn:endsWith(doc.fileName, '.jpeg')}">
                                                                <img src="${pageContext.request.contextPath}/${doc.filePath}" class="img-fluid rounded" />
                                                            </c:when>
                                                            <c:otherwise>
                                                            </c:otherwise>
                                                        </c:choose>

                                                    </div>
                                                </c:forEach>

                                            </div>
                                        </c:if>



                                        <c:if test="${fn:toLowerCase(lesson.lessonType) == 'quiz'}">

                                            <div class="container">

                                                <div class="quiz-header">
                                                    <h1><c:out value="${data.quizTitle}" /></h1>
                                                </div>




                                                <div class="card assignment-details">

                                                    <div class="details-group">
                                                        <p class="label">Due Date</p>
                                                        <c:choose>
                                                            <c:when test="${not empty data.deadline}">
                                                                <p class="value">
                                                                    <fmt:formatDate value="${data.deadline}" pattern="MMM d, yyyy, hh:mm a Z" />
                                                                </p>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <p class="value">No due date</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="details-group">
                                                        <p class="label">Attempts</p>

                                                        <c:choose>
                                                            <c:when test="${data.maxAttempts > 0}">
                                                                <p class="value-highlight">${data.attemptsLeft} left</p>
                                                                <p class="value">(Max ${data.maxAttempts} attempts
                                                                    <c:if test="${data.attemptCooldownHours > 0}">
                                                                        , ${data.attemptCooldownHours} hours apart
                                                                    </c:if>
                                                                    )</p>
                                                                </c:when>
                                                                <c:otherwise>
                                                                <p class="value-highlight">Unlimited</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="details-group">
                                                        <p class="label">Time Limit</p>
                                                        <p class="value">${data.durationMinutes} minutes</p>
                                                    </div>

                                                    <div class="start-action">
                                                        <c:choose>
                                                            <c:when test="${data.canStart}">

                                                                <a href="DoQuizServlet?quizId=${data.quizId}" class="start-button">Start</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="start-button" disabled>Start</button>
                                                                <p class="wait-message"><c:out value="${data.waitMessage}" /></p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="card grade-details">
                                                    <p class="label">Your Grade</p>

                                                    <c:choose>
                                                        <c:when test="${not empty data.highestScore}">
                                                            <p class="status">Your highest score is recorded.</p>

                                                            <%-- === BỌC ĐIỂM SỐ VÀ NÚT TRONG DIV MỚI === --%>
                                                            <div class="score-and-review">
                                                                <p class="score">
                                                                    <fmt:formatNumber value="${data.highestScore.score}" maxFractionDigits="2" />
                                                                </p>
                                                                <a href="reviewQuizAttempt?attemptId=${data.highestScore.attemptId}" class="result-action review-button">Review Highest Attempt</a>
                                                            </div>
                                                            <%-- ======================================= --%>

                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="status">You haven't submitted this yet. We keep your highest score.</p>
                                                            <p class="score">--</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                            </div>


                                        </c:if>



                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </main>
        </div>


        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Tìm tất cả các nút bấm có class 'accordion-trigger'
                var triggers = document.getElementsByClassName("accordion-trigger");

                for (var i = 0; i < triggers.length; i++) {
                    triggers[i].addEventListener("click", function () {
                        // Thêm/xóa class 'active' trên nút bấm (để xoay icon)
                        this.classList.toggle("active");

                        // Lấy ra phần tử nội dung (panel) ngay sau nút bấm
                        var panel = this.nextElementSibling;

                        // Kiểm tra nếu panel đang mở (có max-height)
                        if (panel.style.maxHeight) {
                            // Nếu đang mở, đóng nó lại
                            panel.style.maxHeight = null;
                        } else {
                            // Nếu đang đóng, mở ra bằng chiều cao thực của nội dung bên trong
                            // Chúng ta dùng .scrollHeight của wrapper bên trong
                            var innerContent = panel.querySelector('.panel-content-inner');
                            panel.style.maxHeight = innerContent.scrollHeight + "px";
                        }
                    });
                }
            });

            // (Bạn có thể thêm script cho modal "Report" hoặc "Quiz" ở đây nếu cần)
        </script>

        <script>
            function checkAnswers(lessonID) {
                const form = document.getElementById("quizForm_" + lessonID);
                const resultDiv = document.getElementById("result_" + lessonID);

                if (!form || !resultDiv) {
                    console.error("Không tìm thấy form hoặc resultDiv cho lessonID:", lessonID);
                    return;
                }

                const allRadios = form.querySelectorAll("input[type='radio']");
                const selectedRadios = form.querySelectorAll("input[type='radio']:checked");

                const questionNames = new Set();
                allRadios.forEach(r => questionNames.add(r.name));

                const totalQuestions = questionNames.size;
                let correctCount = 0;

                allRadios.forEach(r => {
                    const label = r.parentElement;
                    label.style.color = "";
                    label.style.fontWeight = "normal";
                });

                selectedRadios.forEach(r => {
                    const label = r.parentElement;
                    if (r.value === "true") {
                        correctCount++;
                        label.style.color = "green";
                        label.style.fontWeight = "600";
                    } else {
                        label.style.color = "red";
                    }
                });

                console.log("correctCount =", correctCount, " / totalQuestions =", totalQuestions);

                if (selectedRadios.length < totalQuestions) {
                    resultDiv.style.color = "orange";
                    resultDiv.textContent = "⚠️ Vui lòng chọn đáp án cho tất cả câu hỏi!";
                    return;
                }

                resultDiv.style.color = correctCount === totalQuestions ? "green" : "red";
                resultDiv.textContent = `Đã hoàn tất việc kiểm tra câu trả lời!`;


            }

        </script>

    </body>
</html>