
<%-- 
    Document   : AssignmentPage
    Created on : Sep 28, 2025
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignment Page</title>
    <style>
        :root {
            --primary: #2563eb;
            --secondary: #6366f1;
            --bg-light: #f9fafb;
            --text-dark: #111827;
            --border: #e5e7eb;
            --menu-schedule: #fcd9a9;
            --menu-member: #dbeafe;
            --menu-assignment: #fecaca;
            --menu-report: #dbeafe;
            --menu-lessons: #fcd9a9;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Inter", sans-serif;
        }

        body {
            background: var(--bg-light);
            color: var(--text-dark);
        }

        /* Header */
        .header {
            border: 1px solid var(--primary);
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-left {
            font-size: 14px;
            color: gray;
        }

        .header-right {
            display: flex;
            gap: 15px;
            font-size: 18px;
            cursor: pointer;
        }

        /* Layout */
        .container {
            display: flex;
            margin: 20px;
        }

        /* Sidebar */
        .sidebar {
            width: 200px;
            padding: 10px;
        }

        .sidebar h2 {
            font-size: 18px;
            margin-bottom: 20px;
        }

        .menu-item {
            padding: 12px;
            margin-bottom: 12px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .schedule { background: var(--menu-schedule); }
        .member { background: var(--menu-member); }
        .assignment { background: var(--menu-assignment); }
        .report { background: var(--menu-report); }
        .lessons { background: var(--menu-lessons); }

        /* Content */
        .content {
            flex: 1;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }

        .content h2 {
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: bold;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 12px;
            font-size: 14px;
            border-bottom: 2px solid #e9d5ff;
            color: #6b7280;
        }

        td {
            padding: 14px;
            border-bottom: 1px solid var(--border);
            font-size: 15px;
            font-weight: 600;
            color: #4b5563;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            Class code / abcdxyz
        </div>
        <div class="header-right">
            🔔 👤
        </div>
    </div>

    <!-- Layout -->
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Assignment List</h2>
            <div class="menu-item schedule">● Schedule</div>
            <div class="menu-item member">📘 Member</div>
            <div class="menu-item assignment">📕 Assignment</div>
            <div class="menu-item report">📘 Mark report</div>
            <div class="menu-item lessons">📘 Lessons</div>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Class name</h2>

            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Due date</th>
                        <th>Time</th>
                        <th>Created by</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Name</td>
                        <td>adf</td>
                        <td>date</td>
                        <td>45''</td>
                        <td>Name</td>
                    </tr>
                    <tr>
                        <td>Name</td>
                        <td>adf</td>
                        <td>date</td>
                        <td>45''</td>
                        <td>Name</td>
                    </tr>
                    <tr>
                        <td>Name</td>
                        <td>adf</td>
                        <td>date</td>
                        <td>45''</td>
                        <td>Name</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

