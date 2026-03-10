<%-- 
    Document   : EditProfile
    Created on : Sep 28, 2025, 6:21:08 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Modern Profile Page</title>
        <style>
            :root {
                --primary: #2563eb;
                --secondary: #6366f1;
                --bg-light: #f3f4f6;
                --bg-dark: #1f2937;
                --text-dark: #111827;
                --text-light: #9ca3af;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Inter", sans-serif;
            }

            body {
                display: flex;
                min-height: 100vh;
                background: var(--bg-light);
                color: var(--text-dark);
            }

            /* Sidebar */
            .sidebar {
                width: 220px;
                background: var(--bg-dark);

                color: white;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 20px;
            }

            .sidebar h3 {
                font-size: 14px;
                text-transform: uppercase;
                margin-bottom: 20px;
                color: var(--text-light);
                letter-spacing: 1px;
            }

            .sidebar a {
                text-decoration: none;
                color: white;
                font-size: 16px;
                padding: 12px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: 0.3s;
            }

            .sidebar a:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .logout {
                color: #f87171;
                font-size: 15px;
            }

            /* Main */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            .header {
                /*background: linear-gradient(to right, var(--primary), var(--secondary));*/
                background: linear-gradient(to right, #a5d8ff, #ffe29a);

                padding: 20px 30px;
                color: white;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header h1 {
                font-size: 26px;
                font-weight: bold;
            }

            .header-icons {
                display: flex;
                gap: 20px;
                font-size: 20px;
                cursor: pointer;
            }

            /* Profile */
            .profile-container {
                flex: 1;
                display: flex;
                gap: 40px;
                padding: 40px;
                align-items: flex-start;
            }

            .profile-pic {
                width: 250px;
                text-align: center;
                background: white;
                padding: 20px;
                border-radius: 16px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }

            .profile-pic img {
                width: 140px;
                height: 140px;
                border-radius: 50%;
                border: 4px solid var(--primary);
                object-fit: cover;
                margin-bottom: 15px;
            }

            .profile-pic p {
                font-weight: bold;
                font-size: 16px;
            }

            .profile-form {
                flex: 1;
                background: white;
                padding: 30px;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            .profile-form label {
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 6px;
                display: block;
            }

            .profile-form input {
                width: 100%;
                padding: 12px;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
                transition: 0.3s;
            }

            .profile-form input:focus {
                border-color: var(--primary);
                outline: none;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
            }

            .edit-btn {
                text-align: center;
                margin-top: 10px;
            }

            .edit-btn button {
                background: linear-gradient(to right, var(--primary), var(--secondary));
                color: white;
                border: none;
                padding: 14px 50px;
                font-size: 16px;
                border-radius: 8px;
                cursor: pointer;
                transition: 0.3s;
            }

            .edit-btn button:hover {
                opacity: 0.9;
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div>
                <h3>Overview</h3>
                <a href="#">📊 Dashboard</a>
            </div>
            <a href="#" class="logout">⎋ Logout</a>
        </div>

        <!-- Main -->
        <div class="main">
            <div class="header">
                <h1>Profile</h1>
                <div class="header-icons">🔔 👤</div>
            </div>

            <div class="profile-container">
                <!-- Avatar -->
                <div class="profile-pic">
                    <img src="https://via.placeholder.com/140" alt="Profile Picture">
                    <p>Nguyen Van A</p>
                </div>

                <!-- Form -->
                <div class="profile-form">
                    <label>Name</label>
                    <input type="text" placeholder="Your Name">

                    <label>Email Address</label>
                    <input type="email" placeholder="Your Email Address">

                    <label>Gender</label>
                    <input type="text" placeholder="Your Gender">

                    <label>Phone Number</label>
                    <input type="text" placeholder="Your Phone Number">

                    <label>Date of Birth</label>
                    <input type="date">

                    <label>Address</label>
                    <input type="text" placeholder="Your Address">

                    <label>Password</label>
                    <input type="password" placeholder="Your Password">

                    <div class="edit-btn">
                        <button>Edit Profile</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

