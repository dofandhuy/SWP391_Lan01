<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="Entity.User" %>



<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>User Profile</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>

        body {

            font-family: 'Poppins', sans-serif;

            margin: 0;

            padding: 0;

            background-color: #f4f7f9;

            display: flex;

            min-height: 100vh;

        }

        .sidebar {

            width: 250px;

            background-color: #ffffff;

            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);

            display: flex;

            flex-direction: column;

            padding-top: 20px;

            position: fixed;

            height: 100%;

        }

        .sidebar-header { padding: 0 20px 20px; text-transform: uppercase; font-size: 0.8em; color: #888; font-weight: 600; }

        .menu-item { padding: 15px 20px; display: flex; align-items: center; color: #333; text-decoration: none; transition: background-color 0.2s; font-weight: 400; }

        .menu-item:hover, .menu-item.active { background-color: #e6f7ff; color: #1890ff; border-right: 3px solid #1890ff; }

        .menu-item i { margin-right: 10px; }

        .logout { margin-top: auto; padding: 20px; border-top: 1px solid #eee; }

        .logout a { color: #ff4d4f; text-decoration: none; display: flex; align-items: center; transition: color 0.2s; }

        .logout a:hover { color: #ff7875; }

        .main-content { margin-left: 250px; flex-grow: 1; padding: 30px; box-sizing: border-box; }

        .profile-header { background: linear-gradient(to right, #fceabb, #f8b500); height: 150px; border-radius: 8px; position: relative; margin-bottom: 70px; }

        .avatar { width: 120px; height: 120px; border-radius: 50%; overflow: hidden; border: 4px solid #ffffff; position: absolute; top: 50%; left: 50%; transform: translate(-50%, 0%); box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); }

        .avatar img { width: 100%; height: 100%; object-fit: cover; }

        .profile-form { background-color: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 40px; }

        .form-group { display: flex; flex-direction: column; }

        .form-group label { font-size: 0.9em; color: #555; margin-bottom: 5px; font-weight: 600; }

        .form-control { padding: 10px 12px; border: 1px solid #d9d9d9; border-radius: 4px; font-size: 1em; transition: border-color 0.2s, box-shadow 0.2s; box-sizing: border-box; }

        .form-control:focus { border-color: #40a9ff; outline: none; box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2); }

        .gender-input { width: 150px; }
.edit-button-container { display: flex; justify-content: center; margin-top: 40px; }

        .edit-button { background-color: #1890ff; color: white; padding: 12px 40px; border: none; border-radius: 4px; font-size: 1.1em; font-weight: 600; cursor: pointer; transition: background-color 0.2s, transform 0.1s; }

        .edit-button:hover { background-color: #40a9ff; }

        .edit-button:active { transform: scale(0.99); }

    </style>

</head>

<body>



<div class="sidebar">

    <div class="sidebar-header">OVERVIEW</div>

   <li><a href="instructor/dashboard" class="active">Dashboard</a></li>

    <div class="logout">

        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>

    </div>

</div>



<div class="main-content">

    <div class="profile-header">

        <div class="avatar">

            <img src="https://i.ibb.co/L5hY5X1/image-297db2.png" alt="Profile Picture">

        </div>

    </div>



    <div class="profile-form">

        <% User profileUser = (User) request.getAttribute("user");

        if (profileUser != null) {

           

        %>

        <div class="form-grid">

            <div class="form-group">

                <label>Username</label>

                <input type="text" class="form-control" value="<%= profileUser.getUsername() %>" readonly>

            </div>

            <div class="form-group">

                <label>Full Name</label>

                <input type="text" class="form-control" value="<%= profileUser.getFullName() %>" readonly>

            </div>

            <div class="form-group">

                <label>Email Address</label>

                <input type="email" class="form-control" value="<%= profileUser.getEmail() %>" readonly>

            </div>

            <div class="form-group">

                <label>Phone Number</label>

                <input type="tel" class="form-control" value="<%= profileUser.getPhone() %>" readonly>

            </div>

            <div class="form-group">

                <label>Address</label>

                <input type="text" class="form-control" value="<%= profileUser.getAddress() %>" readonly>

            </div>

            <div class="form-group">

                <label>Gender</label>

                <input type="text" class="form-control gender-input" value="<%= profileUser.getSex() %>" readonly>

            </div>

            <div class="form-group">

                <label>Date of Birth</label>

                <input type="date" class="form-control" value="<%= profileUser.getDob() %>" readonly>

            </div>

        </div>



        <div class="edit-button-container">

            <a href="Edit.jsp" class="edit-button">Edit Profile</a>

        </div>

        <%

            } else {

        %>

        <p style="color:red; text-align:center;">User not logged in.</p>

        <a href="Signin.jsp" style="display:block; text-align:center; margin-top:20px;">Login here</a>

        <%
}

        %>

    </div>

</div>



</body>

</html>
