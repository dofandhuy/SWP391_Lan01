<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Course Wish List</title>

        <style>
            * {
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
            }

            body {
                background-color: #f3f6fa;
                color: #333;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* ================= HEADER ================= */
            header {
                background-color: #00bcd4;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 40px;
                color: #fff;
            }

            .logo {
                font-size: 24px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            /* ================= MAIN LAYOUT ================= */
            .main-layout {
                display: grid;
                grid-template-columns: 250px 1fr;
                flex-grow: 1;
            }

            .sidebar-container {
                background: #fff;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);
                padding: 20px 0;
            }

            .dashboard-content {
                padding: 20px 30px;
            }

            /* ================= CART STYLING ================= */
            .section {
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 25px;
            }

            .section h2 {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .cart-container {
                display: grid;
                grid-template-columns: 1.1fr 1fr;
                gap: 20px;
            }

            .cart-list, .summary {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                padding: 16px;
            }

            .course-item {
                display: flex;
                gap: 14px;
                align-items: center;
                border-bottom: 1px solid #eee;
                padding: 12px 0;
            }

            .thumb {
                width: 84px;
                height: 56px;
                border-radius: 8px;
                background: linear-gradient(135deg,#dff6ff,#eafbf6);
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:600;
                color:#075985;
            }

            .course-meta {
                flex: 1;
            }

            .course-title {
                font-weight: 600;
                font-size: 1rem;
                color: #0f1724;
            }

            .course-desc {
                font-size: 0.9rem;
                color: #475569;
                margin-top: 6px;
            }

            .small {
                font-size: 0.86rem;
                color:#64748b;
            }

            .course-extra {
                text-align: right;
                min-width: 120px;
            }

            .price {
                font-weight: 700;
            }

            /* Buttons */
            .btn {
                display:inline-block;
                padding:8px 12px;
                border-radius:10px;
                text-decoration:none;
                font-weight:600;
                cursor:pointer;
                font-size: 13px;
            }

            .btn-danger {
                background:#fee2e2;
                color:#b91c1c;
                border:1px solid rgba(185,28,28,0.08);
            }

            .btn-ghost {
                background:transparent;
                border:1px solid rgba(15,23,36,0.06);
                color:#0f1724;
            }

            .btn-primary {
                background: linear-gradient(90deg, #00ADC3 0%, #00ADC3 100%);
                color: #ffffff;
                border: none;
                border-radius: 10px;
                padding: 8px 12px;
                font-weight: 600;
                cursor: pointer;
                box-shadow: 0 6px 18px rgba(0, 173, 195, 0.15);
                transition: all 0.2s ease-in-out;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 10px 24px rgba(0, 173, 195, 0.18);
            }

            .summary h3 {
                margin-bottom: 10px;
                font-size: 18px;
            }

            .summary-row {
                display:flex;
                justify-content:space-between;
                margin:8px 0;
                font-size:0.98rem;
            }

            .total {
                font-size:1.15rem;
                font-weight:700;
            }

            .checkout {
                margin-top:14px;
                display:flex;
                gap:10px;
            }

            @media (max-width: 900px) {
                .main-layout {
                    grid-template-columns: 1fr;
                }
                .cart-container {
                    grid-template-columns: 1fr;
                }
                .sidebar-container {
                    display: none;
                }
            }
        </style>
    </head>
    <body>

        <!-- HEADER -->
        <jsp:include page="header.jsp" />

        <div class="main-layout">

            <!-- SIDEBAR -->
            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <!-- MAIN CONTENT -->
            <div class="dashboard-content">
                <div class="section">
                    <h2>🛒 My Wish List</h2>

                    <div class="cart-container">

                        <!-- Danh sách khoá học -->
                        <div class="cart-list">
                            <h3>My wish list (${fn:length(cartCourse)})</h3>

                            <c:if test="${empty cartCourse}">
                                <div class="cart-empty-message">
                                    <p>Your wish list is empty.</p>
                                </div>
                            </c:if>

                            <c:if test="${not empty cartCourse}">
                                <c:set var="totalPrice" value="0" scope="page" />
                                <c:forEach var="course" items="${cartCourse}">
                                    <div class="course-item">
                                        <img src="${course.thumbnail}" alt="${course.title}" class="thumb">

                                        <div class="course-meta">
                                            <div class="course-title">${course.title}</div>
                                            <div class="small">Bởi ${course.instructorName}</div>
                                        </div>

                                        <div class="course-extra">
                                            <div class="price">
                                                <fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </div>
                                            <a href="CartRemoveServlet?courseId=${course.courseID}" 
                                               class="btn btn-danger" 
                                               style="margin-top: 8px;">Xoá</a>
                                        </div>
                                    </div>

                                    <!-- Cộng dồn giá -->
                                    <c:if test="${not empty course.price}">
                                        <c:set var="totalPrice" value="${totalPrice + course.price}" scope="page" />
                                    </c:if>
                                </c:forEach>
                            </c:if>

                        </div>

                        <!-- Tóm tắt đơn hàng -->
                        <div class="summary">
                            <h3>Tóm tắt đơn hàng</h3>

                            <div class="summary-row">
                                <span>Số khoá học</span>
                                <span>${fn:length(cartCourse)}</span>
                            </div>

                            <div class="summary-row">
                                <span>Tạm tính</span>
                                <span><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></span>
                            </div>

                            <div class="summary-row">
                                <span>Giảm giá</span>
                                <span>0₫</span>
                            </div>

                            <div class="summary-row total">
                                <span>Tổng</span>
                                <span><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></span>
                            </div>

                            <div class="checkout">
                                <form action="checkout" method="post" style="display:flex;gap:10px;">
                                    <button type="submit" class="btn btn-primary" style="flex:1;">Thanh toán</button>
                                </form>

                                <form action="ClearCartServlet" method="post">
                                    <button type="submit" class="btn btn-ghost">Xoá tất cả</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </body>

</html>
