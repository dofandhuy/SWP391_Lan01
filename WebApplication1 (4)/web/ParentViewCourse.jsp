<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>LMS - Course Detail</title>

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            :root {
                --primary: #007bff;
                --primary-dark: #0056b3;
                --text-dark: #212529;
                --text-muted: #6c757d;
                --bg-light: #f8f9fa;
                --bg-white: #fff;
                --border: #dee2e6;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background: var(--bg-light);
                color: var(--text-dark);
            }

            /* --- Layout --- */
            .lms-container {
                display: grid;
                grid-template-columns: 260px 1fr;
                grid-template-rows: 70px 1fr;
                grid-template-areas:
                    "header header"
                    "sidebar main";
                min-height: 100vh;
            }

            /* --- Header --- */
            header.lms-header {
                grid-area: header;
                background: var(--bg-white);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 30px;
                border-bottom: 1px solid var(--border);
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            .logo {
                font-size: 24px;
                font-weight: 700;
                color: var(--primary-dark);
            }

            .search-bar input {
                width: 400px;
                padding: 10px 15px;
                border: 1px solid var(--border);
                border-radius: 30px;
                transition: 0.2s;
            }
            .search-bar input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 4px rgba(0,123,255,0.3);
                outline: none;
            }

            .header-icons i {
                font-size: 24px;
                color: var(--text-muted);
                margin-left: 20px;
                cursor: pointer;
                transition: color 0.2s;
            }
            .header-icons i:hover {
                color: var(--primary-dark);
            }

            /* --- Sidebar --- */
            aside.lms-sidebar {
                grid-area: sidebar;
                background: var(--bg-white);
                border-right: 1px solid var(--border);
                padding-top: 25px;
                display: flex;
                flex-direction: column;
            }

            aside nav ul {
                list-style: none;
            }
            aside nav ul li a {
                display: flex;
                align-items: center;
                padding: 14px 25px;
                color: var(--text-muted);
                text-decoration: none;
                font-weight: 500;
                transition: 0.2s;
            }
            aside nav ul li a.active,
            aside nav ul li a:hover {
                background: var(--bg-light);
                color: #000;
                font-weight: 600;
            }
            aside nav ul li i {
                margin-right: 12px;
                font-size: 18px;
            }

            .logout {
                margin-top: auto;
                padding: 15px 25px;
                border-top: 1px solid var(--border);
                color: #000;
                text-decoration: none;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .logout:hover {
                background: #f9f9f9;
            }

            /* --- Main --- */
            main.lms-content {
                grid-area: main;
                padding: 40px;
            }

            .back-container {
                margin-bottom: 15px;
            }
            .back-button {
                background: var(--primary);
                color: #fff;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                transition: 0.2s;
            }
            .back-button:hover {
                background: var(--primary-dark);
            }

            .course-detail-title {
                font-size: 24px;
                font-weight: 700;
                color: var(--primary-dark);
                margin-bottom: 20px;
            }

            /* --- Course Card --- */
            .payment-card {
                background: var(--bg-white);
                display: grid;
                grid-template-columns: 320px 1fr;
                gap: 30px;
                border-radius: 18px;
                box-shadow: 0 8px 30px rgba(0,0,0,0.08);
                overflow: hidden;
                max-width: 1100px;
                margin: auto;
            }

            .course-meta {
                background: linear-gradient(180deg, #e8f6f3, #f6fefc);
                padding: 25px;
                text-align: center;
            }

            .thumbnail {
                width: 100%;
                height: 200px;
                border-radius: 14px;
                background-size: cover;
                background-position: center;
            }

            .price-badge {
                display: inline-block;
                margin-top: 8px;
                font-weight: 700;
                color: #06473A;
                background: rgba(6,71,58,0.1);
                padding: 6px 14px;
                border-radius: 999px;
                font-size: 15px;
            }

            .course-details {
                padding: 25px 30px;
            }
            .course-details h2 {
                margin-bottom: 8px;
                font-size: 22px;
            }

            .desc {
                margin: 18px 0;
                color: #444;
                line-height: 1.6;
            }

            .meta-grid {
                display: flex;
                gap: 25px;
                margin-bottom: 20px;
                font-size: 13px;
            }
            .meta-item label {
                font-weight: 600;
                color: #495057;
            }

            /* --- Modules --- */
            .modules-section h2 {
                font-size: 18px;
                margin-bottom: 10px;
            }
            .modules-list {
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 12px;
                background: #fafafa;
                max-height: 240px;
                overflow-y: auto;
            }
            .module {
                background: #fff;
                padding: 10px 15px;
                margin-bottom: 8px;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            }

            @media (max-width: 992px) {
                .payment-card {
                    grid-template-columns: 1fr;
                }
            }
            /* ... Thêm vào cuối khối <style> ... */

            .m-desc {
                font-size: 14px;
                color: #555;
                padding-left: 18px; /* Căn lề cho mô tả module */
            }

            .lessons-list {
                margin-top: 12px;
                padding-left: 25px; /* Căn lề cho danh sách bài học */
            }

            .lessons-list ul {
                list-style: none;
            }

            .lesson-item {
                font-size: 14px;
                padding: 8px 0;
                border-top: 1px dashed #eee; /* Đường phân cách mờ */
                display: flex;
                align-items: center;
                gap: 8px;
                color: var(--text-dark);
            }

            .lesson-item i {
                color: var(--primary);
                font-size: 13px;
            }

            .lesson-item-empty {
                font-size: 13px;
                color: #888;
                font-style: italic;
                padding: 5px 0;
            }
        </style>
    </head>

    <body>
        <div class="lms-container">
            <header class="lms-header">
                <div class="logo">LMS</div>
                <div class="search-bar"><input type="text" placeholder="Tìm kiếm khóa học..."></div>
                <div class="header-icons">
                    <i class="material-icons">notifications</i>
                    <a href="profile" class="material-icons">account_circle</a>
                </div>
            </header>

            <aside class="lms-sidebar">
                <nav>
                    <ul>
                        <li><a href="ParentDashBoard"><i class="fa-solid fa-house-chimney"></i>Dashboard</a></li>
                        <li><a href="manage"><i class="fa-solid fa-user-graduate"></i>Students Management</a></li>
                        <li><a href="CourseRequestServlet" class="active"><i class="fa-solid fa-book-open"></i>Course Requests</a></li>
                    </ul>
                </nav>
                <a href="logout" class="logout"><i class="fa fa-sign-out-alt"></i>Logout</a>
            </aside>

            <main class="lms-content">
                <div class="back-container">
                    <button class="back-button" onclick="window.history.back()">← Back</button>
                </div>

                <h2 class="course-detail-title">${course.title}</h2>

                <div class="course-card">
                    <!-- Left: thumbnail & info -->
                    <div class="course-card-left">
                        <div class="thumbnail" style="background-image:url('<c:out value="${course.thumbnail}"/>');"></div>
                        <div class="category">${course.categoryName}</div>
                        <div class="price">
                            <c:choose>
                                <c:when test="${course.price == 0}">Miễn phí</c:when>
                                <c:otherwise><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫"/></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="instructor">${course.instructorName}</div>
                    </div>

                    <!-- Right: description & modules -->
                    <div class="course-card-right">
                        <p class="desc">${course.description}</p>

                        <div class="meta-grid">
                            <div class="meta-item">
                                <label>Modules</label>
                                <div><c:out value="${fn:length(modules)}"/></div>
                            </div>
                            <div class="meta-item">
                                <label>Category</label>
                                <div>${course.categoryName}</div>
                            </div>
                        </div>

                        <div class="modules-section">
                            <h3>Modules</h3>
                            <c:if test="${not empty modules}">
                                <c:forEach var="m" items="${modules}" varStatus="s">
                                    <div class="module-card">
                                        <div class="module-header" onclick="toggleLessons('module-${s.index}')">
                                            <span class="module-title">${s.index + 1}. ${m.title}</span>
                                            <span class="toggle-icon">+</span>
                                        </div>
                                        <div class="module-desc">${m.description}</div>
                                        <ul class="lessons-list" id="module-${s.index}" style="display:none;">
                                            <c:set var="currentLessons" value="${lessonsByModule[m.id]}" />
                                            <c:choose>
                                                <c:when test="${not empty currentLessons}">
                                                    <c:forEach var="l" items="${currentLessons}">
                                                        <li>
                                                            <i class="fa-solid
                                                               <c:choose>
                                                                   <c:when test="${l.lessonType == 'video'}">fa-video</c:when>
                                                                   <c:when test="${l.lessonType == 'quiz'}">fa-clipboard</c:when>
                                                                   <c:otherwise>fa-book-open</c:otherwise>
                                                               </c:choose>"></i>
                                                            <c:out value="${l.title}" />
                                                        </li>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="lessons-empty">(Module này chưa có bài học)</li>
                                                    </c:otherwise>
                                                </c:choose>
                                        </ul>
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty modules}">
                                <div class="lessons-empty">Khoá học hiện chưa có module nào.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <!-- Accordion JS -->
                <script>
                    function toggleLessons(id) {
                        const el = document.getElementById(id);
                        const icon = el.previousElementSibling.querySelector('.toggle-icon');
                        if (el.style.display === "none") {
                            el.style.display = "block";
                            icon.textContent = "−"; // dấu trừ khi mở
                        } else {
                            el.style.display = "none";
                            icon.textContent = "+"; // dấu cộng khi đóng
                        }
                    }
                </script>
                <style>
        /* Main content redesign */
        .course-card {
            display: flex;
            flex-wrap: wrap;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .course-card-left {
            flex: 0 0 300px;
            background: linear-gradient(180deg, #e8f6f3, #f6fefc);
            padding: 25px;
            text-align: center;
        }
        .course-card-left .thumbnail {
            width: 100%;
            height: 180px;
            background-size: cover;
            background-position: center;
            border-radius: 12px;
        }
        .course-card-left .category {
            margin-top: 12px;
            font-weight: 700;
            font-size: 14px;
            color: #06473A;
        }
        .course-card-left .price {
            margin-top: 8px;
            font-weight: 700;
            background: rgba(6,71,58,0.1);
            padding: 6px 14px;
            border-radius: 999px;
            display: inline-block;
            font-size: 15px;
            color: #06473A;
        }
        .course-card-left .instructor {
            margin-top: 12px;
            font-weight: 600;
            color: #333;
        }

        .course-card-right {
            flex: 1;
            padding: 25px 30px;
        }

        .course-card-right .desc {
            margin-bottom: 20px;
            color: #444;
            line-height: 1.6;
        }

        .meta-grid {
            display: flex;
            gap: 25px;
            margin-bottom: 20px;
        }
        .meta-item label {
            font-weight: 600;
            font-size: 13px;
            color: #495057;
        }

        .modules-section h3 {
            font-size: 18px;
            margin-bottom: 12px;
        }

        .module-card {
            background: #fafafa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 12px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        }
        .module-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            padding: 4px 0;
        }
        .module-title {
            font-weight: 600;
        }
        .toggle-icon {
            font-weight: bold;
            font-size: 18px;
            transition: transform 0.2s;
        }
        .module-desc {
            font-size: 14px;
            color: #555;
            margin-bottom: 8px;
        }
        .lessons-list {
            list-style: none;
            padding-left: 18px;
        }
        .lessons-list li {
            padding: 6px 0;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #333;
        }
        .lessons-list li i {
            color: #007bff;
            font-size: 13px;
        }
        .lessons-empty {
            font-size: 13px;
            font-style: italic;
            color: #888;
            padding-left: 18px;
        }

        @media (max-width: 992px) {
            .course-card {
                flex-direction: column;
            }
            .course-card-left {
                flex: 1 0 auto;
            }
        }
    </style>
            </main>
        </div>
    </body>
</html>