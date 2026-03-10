<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>LMS Header</title>

        <!-- Google Material Icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

        <style>
            /* Header container */
            .lms-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 15px 30px;
                border-bottom: 1px solid #eee;
                background-color: #fff;
                position: relative;
            }

            /* Logo */
            .logo {
                font-size: 24px;
                font-weight: bold;
                color: #333;
                flex: 0 0 200px;
            }

            /* Search bar */
            .search-bar {
                position: absolute;
                left: 50%;
                transform: translateX(-50%);
                width: 400px;
            }

            .search-bar form {
                display: flex;
            }

            .search-bar input {
                width: 100%;
                padding: 8px 15px;
                border: 1px solid #ddd;
                border-radius: 20px;
                outline: none;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .search-bar input:focus {
                border-color: #4a90e2;
                box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
            }

            /* Header icons */
            .header-icons {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .header-icons .material-icons {
                font-size: 26px;
                color: #555;
                cursor: pointer;
                transition: color 0.3s ease;
                position: relative;
            }

            .header-icons .material-icons:hover {
                color: #000;
            }

            .header-icons a {
                text-decoration: none;
                color: inherit;
                position: relative;
            }

            /* Gi? hàng badge */
            .cart-badge {
                position: absolute;
                top: -5px;
                right: -10px;
                background: #e74c3c;
                color: white;
                border-radius: 50%;
                font-size: 11px;
                padding: 2px 6px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .lms-header {
                    flex-wrap: wrap;
                    justify-content: center;
                    padding: 10px 15px;
                }

                .logo {
                    flex: 1 1 100%;
                    text-align: center;
                    margin-bottom: 10px;
                }

                .search-bar {
                    position: static;
                    transform: none;
                    width: 100%;
                    max-width: 300px;
                    margin-bottom: 10px;
                }

                .header-icons {
                    flex: 1 1 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>

    <body>
        <header class="lms-header">
            <!-- Logo -->
            <div class="logo">LMS</div>

            <!-- Search -->
            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/SearchServlet" method="get">
                    <input type="text" name="keyword" placeholder="Search for courses..." />
                </form>
            </div>

            <!-- Icons -->
            <div class="header-icons">
                <!-- ? Gi? hàng -->
                <a href="ViewCartServlet">
                    <i class="material-icons">shopping_cart</i>
                    <c:if test="${not empty sessionScope.cartCourse}">
                        <span class="cart-badge">${fn:length(sessionScope.cartCourse)}</span>
                    </c:if>
                </a>

                <!-- ? Tài kho?n -->
                <a href="profile"><i class="material-icons">account_circle</i></a>
            </div>
        </header>
    </body>
</html>
