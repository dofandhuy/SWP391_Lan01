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
            /* ========== GLOBAL RESET ========== */
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

            /* ========== LAYOUT ========== */
            .main-layout {
                display: flex;
                flex: 1;
                width: 100%;
            }

            .sidebar-container {
                width: 230px;
                background: #fff;
                box-shadow: 2px 0 6px rgba(0, 0, 0, 0.08);
                padding-top: 10px;
            }

            .page-content {
                flex-grow: 1;
                padding-bottom: 40px;
            }

            /* ========== HEADER ========== */
            header {
                width: 100%;
                background: #ffffff; 
                color: #1e1e1e;      
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
                letter-spacing: 0.5px;
                color: #00b3b3; 
            }

            .profile {
                font-size: 22px;
                cursor: pointer;
                color: #333; 
                transition: color 0.3s;
            }

            .profile:hover {
                color: #00b3b3;
            }

            /* ========== COURSE CONTAINER ========== */
            .course-container {
                width: 95%;
                margin: 40px auto;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
                padding: 40px 50px;
                transition: transform 0.2s ease;
            }

            .course-container:hover {
                transform: translateY(-2px);
            }

            /* Nút Back */
            .back-btn {
                display: inline-block;
                background: #00b3b3;
                color: #fff;
                padding: 8px 18px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 15px;
                transition: 0.3s;
            }

            .back-btn:hover {
                background: #009595;
            }

            /* Header course info */
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
                color: #1e1e1e;
                margin-top: 10px;
            }

            .course-price {
                margin-top: 10px;
                font-size: 16px;
                font-weight: 600;
                color: #1e1e1e;
            }

            /* Enroll Card */
            .enroll-card {
                background-color: #f9fbfd;
                border-radius: 16px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
                padding: 25px 35px;
                width: 270px;
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
                background: #f0f4f8;
                color: #28c3c3;
                border: none;
                font-size: 18px;
                padding: 10px 14px;
                border-radius: 8px;
                cursor: pointer;
                transition: 0.3s;
            }

            .cart-icon-btn:hover {
                background: #e0f7f7;
            }

            .enroll-card p {
                color: #888;
                font-size: 13px;
                margin-top: 10px;
                line-height: 1.5;
            }

            /* ========== POPUP MESSAGE ========== */
            /* ✅ CSS MỚI CHO POPUP (thay thế .toast-message) */
            .popup-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5); /* Lớp mờ */
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
                max-width: 400px; /* Chiều rộng tối đa */
                text-align: center;
                position: relative;
            }
            
            .popup-modal h3 {
                font-size: 20px;
                font-weight: 700;
                color: #1e1e1e;
                margin-bottom: 15px;
            }

            .popup-modal p {
                font-size: 15px;
                color: #555;
                line-height: 1.6;
                margin-bottom: 25px;
                word-break: break-word; /* Ngăn chữ dài tràn layout */
            }

            .popup-close {
                position: absolute;
                top: 10px;
                right: 12px;
                background: none;
                border: none;
                font-size: 24px;
                font-weight: 700;
                color: #999;
                cursor: pointer;
                line-height: 1;
                transition: color 0.2s;
            }
            
            .popup-close:hover {
                color: #333;
            }
            
            .popup-ok-btn {
                background: #00b3b3; /* Dùng màu chủ đạo */
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


            /* ========== DETAILS ========== */
            .details-row {
                display: flex;
                justify-content: flex-start;
                flex-wrap: wrap;
                gap: 25px;
                margin-top: 40px;
            }

            .detail-box {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                padding: 20px 25px;
                flex: 1;
                min-width: 220px;
                text-align: center;
                transition: 0.3s ease;
            }

            .detail-box:hover {
                background: #e6f7f7;
            }

            .detail-box h3 {
                font-size: 15px;
                font-weight: 700;
                color: #1e1e1e;
                margin-bottom: 6px;
            }

            .detail-box p {
                font-size: 13px;
                color: #6b6b6b;
            }

            /* ========== LEARN SECTION ========== */
            .learn-section {
                width: 95%;
                background: linear-gradient(135deg, #e9f4ff, #f7fbff);
                border-radius: 18px;
                padding: 35px 50px;
                margin: 0 auto 40px auto;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            }

            .learn-section h2 {
                font-size: 22px;
                font-weight: 700;
                color: #1e1e1e;
                margin-bottom: 15px;
            }

            .learn-section p {
                font-size: 15px;
                color: #555;
                line-height: 1.8;
                max-width: 950px;
            }

            /* ========== FOOTER ========== */
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
                color: #28c3c3;
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
                                
                                    <%-- ✅ KHỐI TOAST CŨ ĐÃ ĐƯỢC XÓA KHỎI ĐÂY --%>

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

                    <div class="details-row">
                        <div class="detail-box">
                            <h3>4 course series</h3>
                            <p>Gain in-depth knowledge of a subject</p>
                        </div>
                        <div class="detail-box">
                            <h3>Beginner level</h3>
                            <p>No prior experience required</p>
                        </div>
                        <div class="detail-box">
                            <h3>4 weeks to complete</h3>
                            <p>At 1–4 hours a week</p>
                        </div>
                    </div>
                </section>

                <section class="learn-section">
                    <h2>What you'll learn</h2>
                    <p>
                        Artificial Intelligence (AI) is no longer science fiction. It is rapidly permeating all industries and having a profound impact on virtually every aspect of our existence.
                        Whether you are an executive, a leader, an industry professional, a researcher, or a student — understanding AI, its impact and transformative potential for your organization and our society is of paramount importance.
                    </SSc>
                </section>

                <footer>
                    <a href="#">About</a>
                    <a href="#">Outcomes</a>
                    <a href="#">Course</a>
                </footer>

            </div>
        </div>

        <%-- ✅ SCRIPT MỚI ĐỂ ĐIỀU KHIỂN POPUP --%>
        <script>
            // 1. Tìm các phần tử của popup
            const popupBackdrop = document.querySelector('.popup-backdrop');
            const popupCloseBtn = document.querySelector('.popup-close');
            const popupOkBtn = document.querySelector('.popup-ok-btn');
        
            // 2. Chỉ chạy script nếu popup tồn tại trên trang
            if (popupBackdrop) {
                
                // 3. Hàm để đóng popup
                const closePopup = () => {
                    popupBackdrop.style.display = 'none';
                };
        
                // 4. Gán sự kiện click để đóng
                popupCloseBtn.addEventListener('click', closePopup);
                popupOkBtn.addEventListener('click', closePopup);
        
                // 5. Gán sự kiện click vào lớp mờ (backdrop) để đóng
                popupBackdrop.addEventListener('click', (event) => {
                    // Chỉ đóng nếu click vào chính lớp mờ,
                    // không phải click vào hộp modal bên trong
                    if (event.target === popupBackdrop) {
                        closePopup();
                    }
                });
            }
        </script>

    </body>
</html>