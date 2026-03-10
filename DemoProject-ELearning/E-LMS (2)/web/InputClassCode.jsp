<%-- 
    Document   : InputClassCode
    Created on : Sep 28, 2025, 3:10:24 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Join Class</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background-color: #f9f9f9;
      margin: 0;
    }
    .container {
      text-align: center;
      background: #fff;
      padding: 40px 30px;
      border-radius: 16px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.08);
      width: 340px;
    }
    h1 {
      font-size: 22px;
      font-weight: 600;
      color: #222;
      margin-bottom: 8px;
    }
    p {
      font-size: 14px;
      color: #6b6b8d;
      margin: 0 0 25px 0;
    }
    input[type="text"] {
      width: auto;
      padding: 14px 50px;
      font-size: 18px;
      border: 2px solid #ccc;
      border-radius: 10px;
      text-align: center;
      letter-spacing: 8px;
      transition: 0.2s;
    }
    input[type="text"]:focus {
      border-color: #41b5b5;
      outline: none;
      box-shadow: 0 0 6px rgba(65,181,181,0.4);
    }
    .btn {
      width: 100%;
      background-color: #41b5b5;
      border: none;
      border-radius: 10px;
      padding: 14px;
      color: #fff;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      margin: 20px 0;
      transition: 0.2s;
    }
    .btn:hover {
      background-color: #369e9e;
    }
    .return {
      display: inline-block;
      font-size: 15px;
      color: #555;
      text-decoration: none;
      transition: 0.2s;
    }
    .return:hover {
      color: #000;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Join Class With Class Code</h1>
    <p>Class code must be 6 digits, provided by instructor</p>

    <form action="JoinClassServlet" method="post">
      <input type="text" name="classCode" maxlength="6" placeholder="Enter 6 digits" required>
      <% 
        String error = (String) request.getAttribute("errorMsg");
        if (error != null) {
      %>
        <div class="error"><%= error %></div>
      <% } %>
      <button type="submit" class="btn">Find Class</button>
    </form>

    <a href="StudentDashboard.jsp" class="return">← Return</a>
  </div>
</body>
</html>



