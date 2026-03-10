<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Verify OTP</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8f9fa;
        }
        .verify-container {
            max-width: 400px;
            padding: 2rem;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            background-color: white;
        }
    </style>
</head>
<body>
    <div class="verify-container">
        <h2 class="text-center mb-4">Authentication</h2>
        <p>OTP is sended to your email. Please check your mail and enter OTP to finish login.</p>
        <form action="OtpServlet" method="post">
            <div class="form-group">
                <label for="otp">Code OTP:</label>
                <input type="text" class="form-control" id="otp" name="otp" required maxlength="6" autofocus>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Comfirm</button>
        </form>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger mt-3" role="alert">
                ${error}
            </div>
        <% } %>
    </div>
</body>
</html>