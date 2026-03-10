<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #ffffff; /* nền trắng */
            margin: 0;
            padding: 0;
        }
        .container {
            width: 400px;
            margin: 60px auto;
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }
        .back-link {
            text-decoration: none;
            color: #17a589; /* xanh ngọc bích đậm */
            font-weight: 600;
            margin-right: 10px;
            font-size: 1.1em;
        }
        .back-link:hover {
            color: #138d75; /* hover đậm hơn */
        }
        h2 {
            color: #17a589; /* xanh ngọc bích đậm */
            font-weight: 600;
            margin: 0;
            font-size: 1.5em;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #b2dfdb;
            border-radius: 6px;
            box-sizing: border-box;
            transition: 0.3s;
        }
        input:focus {
            border-color: #17a589; /* xanh đậm */
            box-shadow: 0 0 5px rgba(23,165,137,0.4);
            outline: none;
        }
        .btn {
            background: #17a589; /* xanh đậm */
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            font-size: 1em;
            font-weight: 500;
            transition: 0.3s;
        }
        .btn:hover {
            background: #138d75; /* hover đậm hơn */
        }
        .forgot-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #17a589; /* xanh đậm */
            font-weight: 500;
        }
        .forgot-link:hover {
            color: #138d75; /* hover đậm hơn */
        }
        .error, .success {
            text-align: center;
            margin-top: 15px;
            font-weight: 500;
        }
        .error { color: #ff4d4f; }
        .success { color: #17a589; } /* xanh đậm */
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="profile.jsp" class="back-link">&larr;</a>
            <h2>Change Password</h2>
        </div>
        <form id="changePasswordForm" action="ChangePasswordServlet" method="post">
            <div class="form-group">
                <label>Current Password:</label>
                <input type="password" name="currentPassword" required/>
            </div>
            <div class="form-group">
                <label>New Password:</label>
                <input type="password" name="newPassword" required/>
            </div>
            <div class="form-group">
                <label>Confirm New Password:</label>
                <input type="password" name="confirmPassword" required/>
            </div>
            <button type="submit" class="btn">Update Password</button>
        </form>
        <a href="forgotPassword.jsp" class="forgot-link">Forgot Password?</a>
        <p class="success"><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %></p>
        <p class="error"><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %></p>
    </div>

    <script>
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const newPassword = this.newPassword.value;
            const confirmPassword = this.confirmPassword.value;
            const passRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

            if (!passRegex.test(newPassword)) {
                alert("Mật khẩu phải ≥ 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt!");
                e.preventDefault();
                return;
            }

            if (newPassword !== confirmPassword) {
                alert("Xác nhận mật khẩu không khớp!");
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>
