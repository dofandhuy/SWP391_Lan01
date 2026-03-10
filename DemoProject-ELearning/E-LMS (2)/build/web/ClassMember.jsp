
<%-- 
    Document   : ClassManagement
    Created on : Sep 28, 2025
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Management</title>
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
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
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

        .search-sort {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .search-sort input[type="text"] {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid var(--border);
            border-radius: 20px;
            font-size: 14px;
        }

        .search-sort select {
            padding: 8px;
            border: 1px solid var(--border);
            border-radius: 6px;
        }

        .search-sort button {
            background: #14b8a6;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.3s;
        }

        .search-sort button:hover {
            opacity: 0.9;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th {
            text-align: left;
            padding: 12px;
            font-size: 14px;
            border-bottom: 2px solid #e9d5ff;
            color: #6b7280;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
        }

        .action-icons {
            display: flex;
            gap: 10px;
            font-size: 16px;
            cursor: pointer;
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
            <h2>Class Members</h2>
            <div class="menu-item schedule">● Schedule</div>
            <div class="menu-item member">■ Member</div>
            <div class="menu-item assignment">■ Assignment</div>
            <div class="menu-item report">■ Mark report</div>
            <div class="menu-item lessons">■ Lessons</div>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Class name</h2>

            <div class="search-sort">
                <input type="text" placeholder="🔍 Search">
                <select>
                    <option>Sort Student</option>
                    <option>A → Z</option>
                    <option>Z → A</option>
                </select>
                <button>+ Add to student via email</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Student name</th>
                        <th>Email</th>
                        <th>Average point</th>
                        <th>Assignment</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Name</td>
                        <td>adf</td>
                        <td>amount</td>
                        <td>amount</td>
                        <td class="action-icons">✏️ 🗑️</td>
                    </tr>
                    <tr>
                        <td>Name</td>
                        <td>adf</td>
                        <td>amount</td>
                        <td>amount</td>
                        <td class="action-icons">✏️ 🗑️</td>
                    </tr>
                    <tr>
                        <td>Name</td>
                        <td>adf</td>
                        <td>amount</td>
                        <td>amount</td>
                        <td class="action-icons">✏️ 🗑️</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

