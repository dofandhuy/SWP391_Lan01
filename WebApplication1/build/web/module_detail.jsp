<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Module Detail</title>
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

            /* Left sidebar */
            .sidebar {
                width: 250px;
                background-color: #fff;
                border-right: 1px solid #ddd;
                overflow-y: auto;
            }

            /* Content area */
            .content-area {
                flex: 1;
                display: flex;
                flex-direction: row;
                background-color: #f9fafb;
                overflow: hidden;
            }

            /* Center module detail */
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
                background-color: #0042a8;
            }

            /* Right sidebar */
            .module-sidebar {
                width: 260px;
                background-color: #fff;
                border-left: 1px solid #ddd;
                padding: 20px;
                overflow-y: auto;
            }
            .module-sidebar h3 {
                font-size: 16px;
                margin-bottom: 15px;
            }
            .module-item {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px;
                border-radius: 6px;
                cursor: pointer;
                margin-bottom: 8px;
                transition: 0.2s;
            }
            .module-item:hover {
                background-color: #f2f6ff;
            }
            .module-item.active {
                background-color: #e8f0fe;
                border-left: 4px solid #1a73e8;
            }
            .module-item label {
                cursor: pointer;
                font-size: 14px;
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

            .module-item input[type="radio"] {
                accent-color: #1a73e8;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container">
            <aside class="sidebar">
                <jsp:include page="sidebar_student.jsp" />
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
                                    <span>${lesson.lessonType} · ${lesson.orderIndex} min</span>
                                </div>
                                <c:if test="${not empty lesson.videoUrl}">
                                    <button onclick="window.location = '${lesson.videoUrl}'">Watch</button>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <aside class="module-sidebar">
                    <h3>Course Material</h3>
                    <div class="module-list">
                        <c:forEach var="m" items="${modulesList}">
                            <div class="module-item ${m.id == module.id ? 'active' : ''}"
     onclick="window.location.href = 'ModuleDetailServlet?courseID=${m.courseId}&moduleID=${m.id}'">
    <label>Module ${m.orderIndex}: ${m.title}</label>
</div>

                        </c:forEach>
                    </div>
                </aside>


            </div>
        </div>
    </body>
</html>
