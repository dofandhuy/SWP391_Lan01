<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Course Details | LMS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* ====================== GLOBAL RESET ====================== */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Poppins", sans-serif;
            }

            body {
                background: #f4f6fb;
                color: #1e1e1e;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* ====================== LAYOUT ====================== */
            .main-layout {
                display: flex;
                flex: 1;
                width: 100%;
            }

            .sidebar-container {
                width: 240px;
                background: #fff;
                box-shadow: 2px 0 6px rgba(0, 0, 0, 0.08);
                padding-top: 10px;
            }

            .page-content {
                flex-grow: 1;
                padding: 30px 40px;
            }

            /* ====================== HEADER ====================== */
            header {
                width: 100%;
                background: #ffffff;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 40px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                border-bottom: 1px solid #e5e5e5;
            }

            .logo {
                font-size: 22px;
                font-weight: 700;
                color: #00b3b3;
            }

            .profile {
                font-size: 22px;
                cursor: pointer;
                color: #333;
                transition: 0.3s;
            }

            .profile:hover {
                color: #00b3b3;
            }

            /* ====================== COURSE CONTAINER ====================== */
            .course-container {
                width: 100%;
                margin-bottom: 40px;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
                padding: 40px 50px;
                transition: transform 0.2s ease;
            }

            .course-container:hover {
                transform: translateY(-2px);
            }

            /* Back button */
            .back-btn {
                display: inline-block;
                background: #00b3b3;
                color: #fff;
                padding: 8px 18px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 20px;
                transition: 0.3s;
            }

            .back-btn:hover {
                background: #009595;
            }

            /* Header Info */
            .course-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                flex-wrap: wrap;
                gap: 30px;
            }

            .course-info h1 {
                font-size: 32px;
                font-weight: 700;
                color: #1e1e1e;
            }

            .course-info p {
                color: #666;
                margin-top: 8px;
                line-height: 1.6;
                font-size: 15px;
                max-width: 700px;
            }

            .instructor {
                font-weight: 600;
                color: #222;
                margin-top: 10px;
            }

            .course-price {
                margin-top: 10px;
                font-size: 16px;
                font-weight: 600;
                color: #1e1e1e;
            }

            /* ====================== ENROLL CARD ====================== */
            .enroll-card {
                background-color: #f9fbfd;
                border-radius: 16px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
                padding: 25px 35px;
                width: 280px;
                text-align: center;
                transition: 0.3s ease;
            }

            .enroll-card:hover {
                transform: scale(1.03);
            }

            .enroll-card button {
                background: linear-gradient(90deg, #28c3c3, #1ea6a6);
                border: none;
                color: white;
                font-weight: 600;
                border-radius: 8px;
                padding: 12px 40px;
                font-size: 15px;
                cursor: pointer;
                transition: 0.3s;
            }

            .enroll-card button:hover {
                background: #20b1b1;
            }

            .cart-icon-btn {
                background: #eef8f8;
                color: #00b3b3;
                border: none;
                font-size: 18px;
                padding: 10px 14px;
                border-radius: 8px;
                cursor: pointer;
                transition: 0.3s;
            }

            .cart-icon-btn:hover {
                background: #d9f3f3;
            }

            .enroll-card p {
                color: #777;
                font-size: 13px;
                margin-top: 10px;
                line-height: 1.5;
            }

            /* ====================== COURSE CONTENT PREVIEW ====================== */
            .learn-section {
                width: 100%;
                background: linear-gradient(135deg, #ebf9ff, #f8fcff);
                border-radius: 18px;
                padding: 35px 50px;
                margin: 0 auto 50px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            }

            .learn-section h2 {
                font-size: 22px;
                font-weight: 700;
                color: #1e1e1e;
                margin-bottom: 20px;
            }

            .modules-container {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .module-box {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .module-box:hover {
                transform: scale(1.01);
            }

            .module-header {
                background: #f1fbfb;
                border: none;
                width: 100%;
                text-align: left;
                padding: 14px 20px;
                font-weight: 600;
                font-size: 16px;
                color: #007a7a;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: 0.3s;
            }

            .module-header:hover {
                background: #e2f5f5;
            }

            .lesson-list {
                list-style: none;
                padding: 0 25px 15px 45px;
                display: none;
            }

            .lesson-list li {
                font-size: 14px;
                color: #444;
                margin: 10px 0;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .locked-message {
                text-align: center;
                color: #888;
                font-size: 14px;
                margin-top: 25px;
            }

            .locked-message i {
                margin-right: 6px;
            }

            /* ====================== POPUP ====================== */
            .popup-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }

            .popup-modal {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
                padding: 30px 35px;
                width: 90%;
                max-width: 400px;
                text-align: center;
                position: relative;
            }

            .popup-modal h3 {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 15px;
            }

            .popup-modal p {
                font-size: 15px;
                color: #555;
                margin-bottom: 25px;
                line-height: 1.6;
            }

            .popup-close {
                position: absolute;
                top: 10px;
                right: 12px;
                background: none;
                border: none;
                font-size: 24px;
                color: #999;
                cursor: pointer;
                transition: 0.2s;
            }

            .popup-close:hover {
                color: #333;
            }

            .popup-ok-btn {
                background: #00b3b3;
                color: #fff;
                border: none;
                border-radius: 6px;
                padding: 10px 35px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.3s;
            }

            .popup-ok-btn:hover {
                background: #009595;
            }

            /* ====================== FOOTER ====================== */
            footer {
                display: flex;
                justify-content: center;
                align-items: center;
                background: #fff;
                border-top: 1px solid #e0e0e0;
                padding: 20px 30px;
                gap: 40px;
                width: 100%;
            }

            footer a {
                color: #1e1e1e;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: 0.3s;
            }

            footer a:hover {
                color: #00b3b3;
            }

            /* ====================== RESPONSIVE ====================== */
            @media (max-width: 1024px) {
                .course-header {
                    flex-direction: column;
                    align-items: center;
                }

                .enroll-card {
                    width: 100%;
                }

                .learn-section {
                    padding: 25px 30px;
                }
            }

            @media (max-width: 768px) {
                .sidebar-container {
                    display: none;
                }

                .page-content {
                    padding: 20px;
                }

                .course-info h1 {
                    font-size: 24px;
                }
            }

            .popup-backdrop {
                animation: fadeIn 0.3s ease;
            }

            .popup-backdrop.hide {
                animation: fadeOut 0.3s ease forwards;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes fadeOut {
                from {
                    opacity: 1;
                }
                to {
                    opacity: 0;
                }
            }

            /* preview */
            .lesson-list {
                list-style: none;
                padding: 8px 25px 15px 45px;
                background-color: #fff;
                border-top: 1px solid #e6f4f4;
                display: none;
                transition: all 0.3s ease;
            }

            .lesson-item {
                display: flex;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px dashed #e0eaea;
                gap: 10px;
            }

            .lesson-item:last-child {
                border-bottom: none;
            }

            .lesson-icon {
                font-size: 15px;
                color: #00b3b3;
                min-width: 18px;
                transition: color 0.2s;
            }

            .lesson-title {
                color: #333;
                font-size: 15px;
                font-weight: 500;
                transition: color 0.2s;
            }

            .lesson-item:hover .lesson-icon {
                color: #008c8c;
            }

            .lesson-item:hover .lesson-title {
                color: #008c8c;
            }


        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />    

        <%-- ✅ HTML MỚI CHO POPUP --%>
        <%-- Nó sẽ chỉ được render nếu toastMessage tồn tại --%>
        <c:if test="${not empty toastMessage}">
            <div class="popup-backdrop">
                <div class="popup-modal">
                    <button type="button" class="popup-close" aria-label="Close message">&times;</button>
                    <h3>Thông báo</h3>
                    <p>${toastMessage}</p>
                    <button type="button" class="popup-ok-btn">OK</button>
                </div>
            </div>
        </c:if>


        <div class="main-layout">
            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <div class="page-content">

                <section class="course-container">
                    <div class="course-header">
                        <div class="course-info">
                            <h1>${course.title}</h1>
                            <p>${course.description}</p>
                            <p class="instructor">By ${course.instructorName}</p>
                            <div class="course-price">
                                <strong>Price: </strong>
                                <fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                            </div>
                        </div>

                        <div class="enroll-card">
                            <c:choose>
                                <c:when test="${enrolled}">
                                    <form action="ResumeServlet" method="post">
                                        <input type="hidden" name="courseId" value="${course.courseID}" />
                                        <button type="submit">Enrolled</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; align-items: center; justify-content: center; gap: 10px;">
                                        <c:choose>
                                            <c:when test="${paymentStatus eq 'Pending'}">
                                                <button disabled style="background-color: grey;">Pending</button>
                                            </c:when>
                                            <c:when test="${paymentStatus eq 'Approved' || paymentStatus eq 'Completed'}">
                                                <button disabled>Enroll</button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="PaymentRequestServlet" method="post">
                                                    <input type="hidden" name="courseId" value="${course.courseID}" />
                                                    <button type="submit">Enroll</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <form action="AddToCartServlet" method="post" style="margin: 0;">
                                            <input type="hidden" name="courseId" value="${course.courseID}">
                                            <button type="submit" class="cart-icon-btn" title="Add to Cart">
                                                <i class="fa-solid fa-cart-plus"></i>
                                            </button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <p>Access provided by FPT University<br>${course.enrolledCount} students enrolled</p>
                        </div>
                    </div>
                </section>

                <!-- ✅ Di chuyển section preview vào trong page-content -->
                <section class="learn-section">
                    <h2>Course Content Preview</h2>

                    <div class="modules-container">
                        <c:forEach var="module" items="${moduleList}">
                            <div class="module-box">
                                <!-- Nút tiêu đề module -->
                                <button class="module-header" onclick="toggleLessons(${module.id})">
                                    <i class="fa-solid fa-chevron-right"></i>
                                    ${module.title}
                                </button>

                                <!-- Danh sách bài học bên trong -->
                                <ul class="lesson-list" id="lesson-list-${module.id}">
                                    <c:forEach var="lesson" items="${lessonListMap[module.id]}">
                                        <li>
                                            <div class="lesson-item">
                                                <i class="fa-regular fa-circle-play lesson-icon"></i>
                                                <span class="lesson-title">${lesson.title}</span>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>

                            </div>
                        </c:forEach>

                        <div class="locked-message">
                            <i class="fa-solid fa-lock"></i>
                            Unlock full course by enrolling to access all modules.
                        </div>
                    </div>
                </section>

            </div> <!-- 🔹 Kết thúc .page-content -->
        </div> <!-- 🔹 Kết thúc .main-layout -->


        <%-- ✅ SCRIPT MỚI ĐỂ ĐIỀU KHIỂN POPUP --%>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const popupBackdrop = document.querySelector('.popup-backdrop');
                const popupCloseBtn = document.querySelector('.popup-close');
                const popupOkBtn = document.querySelector('.popup-ok-btn');

                if (popupBackdrop) {
                    // Hàm đóng popup
                    const closePopup = () => {
                        popupBackdrop.classList.add('hide');
                        setTimeout(() => popupBackdrop.remove(), 300); // gỡ hoàn toàn sau animation
                    };

                    // Gán sự kiện
                    popupCloseBtn?.addEventListener('click', closePopup);
                    popupOkBtn?.addEventListener('click', closePopup);

                    popupBackdrop.addEventListener('click', (e) => {
                        if (e.target === popupBackdrop)
                            closePopup();
                    });
                }
            });
        </script>


    </body>
    <script>
        function toggleLessons(moduleId) {
            const list = document.getElementById('lesson-list-' + moduleId);
            const icon = event.currentTarget.querySelector('i');

            if (!list)
                return; // Nếu không tìm thấy danh sách, thoát

            // Toggle ẩn/hiện danh sách
            if (list.style.display === "block") {
                list.style.display = "none";
                icon.style.transform = "rotate(0deg)";
            } else {
                list.style.display = "block";
                icon.style.transform = "rotate(90deg)";
            }
        }
    </script>


</html>