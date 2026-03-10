<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="Entity.User" %>

<!DOCTYPE html>

<html>

<head>

    <title>Edit Profile</title>

    <style>

        /* --- Body và container chính --- */

        body {

            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;

            background: linear-gradient(135deg, #f0f4f8, #d9e2ec);

            margin: 0;

            padding: 0;

        }



        main.container {

            max-width: 800px;

            margin: 50px auto;

            background: #ffffff;

            padding: 50px 40px;

            border-radius: 16px;

            box-shadow: 0 8px 25px rgba(0,0,0,0.12);

            transition: all 0.3s;

        }



        main.container:hover {

            transform: translateY(-3px);

            box-shadow: 0 12px 30px rgba(0,0,0,0.15);

        }



        h2 {

            text-align: center;

            margin-bottom: 40px;

            color: #1f2937;

            font-size: 2em;

            letter-spacing: 0.5px;

        }



        /* --- Form --- */

        form {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 20px 40px;

        }



        label {

            font-size: 14px;

            font-weight: 600;

            color: #374151;

            display: block;

            margin-bottom: 6px;

        }



        input, select {

            width: 100%;

            padding: 14px;

            border: 1px solid #cbd5e1;

            border-radius: 10px;

            background-color: #f9fafb;

            font-size: 14px;

            color: #111827;

            outline: none;

            transition: all 0.3s;

        }



        input:focus, select:focus {

            border-color: #3b82f6;

            box-shadow: 0 0 8px rgba(59,130,246,0.2);

        }



        /* --- Submit button --- */

        .form-actions {

            grid-column: span 2;

            text-align: center;

            margin-top: 30px;

        }



        .btn {

            padding: 14px 50px;

            border: none;

            border-radius: 12px;

            font-size: 16px;

            cursor: pointer;

            transition: all 0.3s;

        }



        .btn-primary {

            background: #3b82f6;

            color: #fff;

            box-shadow: 0 4px 12px rgba(59,130,246,0.3);

        }



        .btn-primary:hover {

            background: #2563eb;

            box-shadow: 0 6px 15px rgba(37,99,235,0.35);

        }



        .btn-cancel {

            background: #e5e7eb;

            color: #374151;

            margin-left: 15px;

        }



        .btn-cancel:hover {

            background: #d1d5db;

        }



        /* --- Responsive --- */

        @media (max-width: 700px) {

            form {

                grid-template-columns: 1fr;

            }

        }

    </style>

</head>

<body>

<%
User user = (User) session.getAttribute("user");

%>

<main class="container">

    <h2>Edit Profile</h2>

    <% if (user != null) { %>

    <form action="UptProfileUser" method="post">

        <input type="hidden" name="userID" value="<%= user.getUserID() %>">

        <label>Username:

            <input type="text" name="username" value="<%= user.getUsername() %>" >

        </label>

        <label>Full Name: 

            <input type="text" name="fullName" value="<%= user.getFullName() %>" >

        </label>

        <label>Email: 

            <input type="email" name="email" value="<%= user.getEmail() %>" >

        </label>

        <label>Phone: 

            <input type="text" name="phone" value="<%= user.getPhone() %>">

        </label>

        <label>Address: 

            <input type="text" name="address" value="<%= user.getAddress() %>">

        </label>

        <label>Date of Birth: 

            <input type="date" name="dob" value="<%= user.getDob() != null ? user.getDob().toString() : "" %>">

        </label>

        <label>Gender:

            <select name="sex">

                <option value="Male" <%= "Male".equals(user.getSex()) ? "selected" : "" %>>Male</option>

                <option value="Female" <%= "Female".equals(user.getSex()) ? "selected" : "" %>>Female</option>

                <option value="Other" <%= "Other".equals(user.getSex()) ? "selected" : "" %>>Other</option>

            </select>

        </label>

        <div class="form-actions">

            <input type="submit" value="Update" class="btn btn-primary">

        </div>

    </form>

    <% } else { %>

        <p style="color:red; text-align:center;">No user data found. Please <a href="Signin.jsp">login</a>.</p>

    <% } %>

</main>

</body>

</html>