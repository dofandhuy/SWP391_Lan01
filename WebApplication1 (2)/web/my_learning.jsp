<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Learning</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                background: #f4f6f9;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            header {
                background: #0056d2;
                color: white;
                padding: 16px;
                text-align: center;
                display: none;
            }

            /* --- Layout chính --- */
            .main-layout {
                display: flex;
                flex: 1;
            }

            .sidebar-container {
                width: 250px;
                background: white;
                box-shadow: 2px 0 8px rgba(0,0,0,0.05);
                padding-top: 20px;
            }

            .content-area {
                flex-grow: 1;
                padding: 30px 40px;
                overflow-y: auto;
            }

            h2 {
                color: #222;
                margin-bottom: 20px;
                font-weight: 600;
            }

            /* --- Tabs --- */
            .tab-bar {
                display: flex;
                gap: 12px;
                margin-bottom: 20px;
            }

            .tab {
                text-decoration: none;
                color: #555;
                padding: 10px 20px;
                border-radius: 25px;
                border: 1px solid #ccc;
                transition: all 0.25s ease;
                font-weight: 500;
            }

            .tab:hover {
                background: #e8f0ff;
                border-color: #0056d2;
                color: #0056d2;
            }

            .tab.active {
                background: #0056d2;
                color: white;
                border-color: #0056d2;
            }

            /* --- Khối khóa học --- */
            .course-container {
                background: white;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            .sub-course {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 0;
                border-bottom: 1px solid #eee;
                transition: all 0.25s ease;
            }

            .sub-course:last-child {
                border-bottom: none;
            }

            .sub-course:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.05);
                border-radius: 10px;
                background: #fafafa;
            }

            .sub-left {
                display: flex;
                gap: 20px;
                align-items: center;
            }

            .sub-left img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            }

            .sub-text h3 {
                margin: 0 0 6px 0;
                font-size: 18px;
                color: #222;
                font-weight: 600;
            }

            .sub-text p {
                font-size: 14px;
                color: #555;
                margin: 0 0 6px 0;
                line-height: 1.4;
            }

            /* --- Progress bar --- */
            .progress-bar {
                background: #eee;
                height: 10px;
                width: 200px;
                border-radius: 5px;
                overflow: hidden;
                margin-top: 4px;
            }

            .progress {
                height: 100%;
                background: linear-gradient(90deg, #00bcd4, #0056d2);
                border-radius: 5px;
                transition: width 0.4s ease;
            }

            /* --- Buttons --- */
            button, .get-started-btn {
                background: #0056d2;
                color: white;
                border: none;
                padding: 8px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            button:hover, .get-started-btn:hover {
                background: #003c99;
                transform: translateY(-1px);
            }

            /* --- Empty message --- */
            .empty-message {
                text-align: center;
                padding: 50px;
                color: #666;
                font-size: 16px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                margin-top: 30px;
            }

            /* --- Responsive --- */
            @media (max-width: 768px) {
                .sidebar-container {
                    display: none;
                }

                .content-area {
                    padding: 20px;
                }

                .sub-course {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }

                .progress-bar {
                    width: 100%;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />    

        <div class="main-layout">
            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <div class="content-area">
                <h2>My FPTU Fall 2025 Learning</h2> 

                <div class="tab-bar">
                    <a href="MyLearningServlet?tab=inprogress" class="tab ${tab=='inprogress'?'active':''}">In Progress</a>
                    <a href="MyLearningServlet?tab=completed" class="tab ${tab=='completed'?'active':''}">Completed</a>
                </div>

                <div class="course-container">
                    <c:set var="visibleCount" value="${0}" scope="page" />

                    <c:forEach var="c" items="${courses}">
                        <c:choose>
                            <c:when test="${tab == 'inprogress' && c.progress < 100}">
                                <c:set var="visibleCount" value="${visibleCount + 1}" scope="page" />

                                <div class="sub-course">
                                    <div class="sub-left">
                                        <img src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d" alt="${c.title}">
                                        <div class="sub-text">
                                            <h3>${c.title}</h3>
                                            <p>${c.description}</p>
                                            <div>Progress: ${c.progress}%</div>
                                            <div class="progress-bar"><div class="progress" style="width:${c.progress}%;"></div></div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="ResumeServlet" method="post">
                                            <input type="hidden" name="courseId" value="${c.courseID}" />
                                            <button type="submit">Continue</button>
                                        </form>
                                    </div>
                                </div>
                            </c:when>

                            <c:when test="${tab == 'completed' && c.progress >= 100}">
                                <c:set var="visibleCount" value="${visibleCount + 1}" scope="page" />

                                <div class="sub-course">
                                    <div class="sub-left">
                                        <img src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d" alt="${c.title}">
                                        <div class="sub-text">
                                            <h3>${c.title}</h3>
                                            <p>${c.description}</p>
                                            <div>Progress: 100% (Completed)</div>
                                            <div class="progress-bar"><div class="progress" style="width:100%;"></div></div>
                                        </div>
                                    </div>
                                    <div>
                                        <button class="get-started-btn">Review</button>
                                    </div>
                                </div>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${visibleCount == 0}">
                        <div class="empty-message">
                            <c:choose>
                                <c:when test="${tab == 'inprogress'}">
                                    Bạn chưa có khóa học nào đang tiến hành.
                                </c:when>
                                <c:when test="${tab == 'completed'}">
                                    Bạn chưa hoàn thành khóa học nào. Hãy bắt đầu học ngay!
                                </c:when>
                                <c:otherwise>
                                    Không có khóa học nào được tìm thấy.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>
