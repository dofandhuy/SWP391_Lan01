<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Đặt isErrorPage="true" để JSP có thể truy cập
     đối tượng 'exception' (nếu một trang khác ném lỗi) --%>
<%@ page isErrorPage="true" %> 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }

        .error-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }

        .error-icon {
            font-size: 4rem;
            color: #d9534f; /* Màu đỏ lỗi */
            line-height: 1;
        }

        .error-title {
            font-size: 2rem;
            font-weight: 600;
            margin-top: 20px;
            margin-bottom: 15px;
            color: #d9534f;
        }

        .error-message {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        /* * Đây là khu vực hiển thị chi tiết lỗi kỹ thuật.
         * Nó chỉ hiển thị nếu có đối tượng 'exception'
         * (chỉ nên dùng khi đang phát triển (debug), không nên hiển thị cho người dùng cuối)
         */
        .error-details {
            font-size: 0.85rem;
            color: #777;
            background-color: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 4px;
            padding: 15px;
            text-align: left;
            white-space: pre-wrap; /* Giữ các ký tự xuống dòng */
            font-family: monospace;
            overflow-wrap: break-word;
        }

        .error-action {
            display: inline-block;
            text-decoration: none;
            background-color: #007bff; /* Màu xanh dương chính */
            color: #ffffff;
            padding: 12px 25px;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color 0.2s ease;
        }

        .error-action:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="error-icon">😟</div>
        <h1 class="error-title">Oops! Something went wrong.</h1>

        <div class="error-message">
            <%-- 
              Đây là phần quan trọng nhất:
              Nó sẽ kiểm tra xem Servlet có gửi một 'errorMessage' không.
              Nếu có, nó hiển thị thông báo đó.
              Nếu không, nó hiển thị một thông báo mặc định.
              
              <c:out> dùng để ngăn chặn lỗi XSS.
            --%>
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    <c:out value="${errorMessage}" />
                </c:when>
                <c:otherwise>
                    We couldn't process your request. Please try again later or return to the previous page.
                </c:otherwise>
            </c:choose>
        </div>

        <%-- 
          (CHỈ DÙNG KHI DEBUG)
          Nếu bạn muốn xem chi tiết lỗi kỹ thuật khi đang code,
          hãy bỏ comment (uncomment) khối <c:if> dưới đây.
          Tuyệt đối KHÔNG hiển thị cái này cho người dùng cuối.
        --%>
        <%--
        <c:if test="${not empty exception}">
            <pre class="error-details">
                <strong>Debug Info:</strong>
                <c:out value="${pageContext.errorData.throwable}" />
            </pre>
        </c:if>
        --%>

        <%-- 
          Nút này cho phép người dùng quay lại trang trước đó
          một cách an toàn bằng JavaScript.
        --%>
        <a href="javascript:history.back()" class="error-action">
            Go Back
        </a>
        
        <%-- Hoặc, một link về trang chủ --%>
        <%--
        <a href="${pageContext.request.contextPath}/home" class="error-action">
            Go to Homepage
        </a>
        --%>
    </div>

</body>
</html>