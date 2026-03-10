<%-- 
    Document   : ParentViewDetail
    Created on : Oct 11, 2025, 10:41:46 AM
    Author     : doanh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS - Student Detail</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        /* General Reset and Base Styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: white;
            color: #333;
            font-size: 14px;
        }

        .lms-container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: white; 
        }

        /* Header Styles */
        .lms-header {
            display: flex;
            align-items: center;
            padding: 15px 30px;
            border-bottom: 1px solid #eee;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            width: 250px; 
            margin-right: 50px; 
        }

        .search-bar {
            flex-grow: 1; 
            display: flex;
            justify-content: center;
        }

        .search-bar input {
            width: 400px;
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 20px;
            outline: none;
            font-size: 14px;
        }

        .header-icons {
            display: flex;
            align-items: center;
            margin-left: auto;
        }

        .header-icons .material-icons {
            font-size: 24px;
            color: #555;
            cursor: pointer;
            margin-left: 20px;
        }

        /* Main Content Area */
        .main-content-area {
            display: flex;
            flex-grow: 1;
        }

        /* Sidebar Styles */
        .lms-sidebar {
            width: 250px;
            border-right: 1px solid #eee;
            padding: 20px 0 0 0; 
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: calc(100vh - 58px); 
        }

        .lms-sidebar nav ul {
            list-style: none;
            padding: 0;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 12px 30px;
            cursor: pointer;
            color: #333;
            transition: background-color 0.2s;
            font-size: 15px;
            font-weight: 500;
        }

        .nav-item.active {
            background-color: #f0f4f8; 
            font-weight: bold;
            color: #000;
        }
        
        .nav-item i {
            margin-right: 15px;
            font-size: 18px;
            width: 20px;
        }

        /* Custom Icon Colors */
        .icon-red { color: #d9534f; }
        .icon-yellow { color: #ffc107; }
        .icon-blue { color: #03a9f4; }
        .icon-brown { color: #795548; }

        .logout {
            padding: 20px 30px;
            cursor: pointer;
            color: #333;
            font-size: 16px;
            font-weight: 500;
            border-top: 1px solid #eee;
        }

        /* Content Styles */
        .lms-content {
            flex-grow: 1;
            padding: 30px;
        }

        /* TIÊU ĐỀ H1 */
        .lms-content h1 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            padding-bottom: 0; 
            margin-bottom: 0; 
        }
        
        /* CONTENT WRAPPER: Nơi tạo thanh ngang và định vị avatar */
 .content-wrapper {
            position: relative; 
            padding-top: 60px; /* Khoảng trống cho avatar */
            
            /* CẬP NHẬT: Tăng khoảng cách với header */
            margin-top: 100px; 
            
            border-top: 1px solid #ccc; /* THANH NGANG CẮT QUA AVATAR */
        }


        /* ACCOUNT INFO SECTION */
        .account-info-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px; /* Thêm padding để nội dung không bị avatar che mất */
            margin-bottom: 30px; 
        }
        
        /* AVATAR CONTAINER */
        .profile-pic-container {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid #eee;
            background-color: white; /* Nền trắng để avatar "cắt" qua đường kẻ */
            
            /* ĐỊNH VỊ AVATAR NỔI LÊN TRÊN ĐƯỜNG KẺ */
            position: absolute;
            top: -60px; /* Di chuyển lên trên 1/2 chiều cao */
            left: 50%; 
            transform: translateX(-50%); 
            
            /* Đảm bảo avatar luôn nằm trên đường kẻ */
            z-index: 10; 
        }
        
        .profile-pic {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #555;
            margin-bottom: 25px;
            text-align: center;
        }

        /* CSS cho bố cục 2 cột thẳng hàng */
        .info-grid-container {
            display: flex;
            justify-content: space-between;
            width: 80%; 
            max-width: 700px;
            margin: 0 auto;
            font-size: 15px;
        }

        .info-column {
            width: 48%; 
        }

        .detail-item {
            display: flex; 
            align-items: center;
            margin-bottom: 10px;
        }

        .detail-label {
            width: 150px; 
            min-width: 120px;
            font-weight: 500;
            color: #555;
            margin-right: 10px;
        }

        .detail-value {
            flex-grow: 1;
            font-weight: 400;
            color: #333;
        }

        /* Cột Status: Active */
        .status-active {
            color: #4CAF50 !important; 
            font-weight: 600;
        }
        
        /* Courses List Section */
        .courses-list-section {
            font-size: 16px;
            font-weight: 600;
            color: #555;
            margin-bottom: 20px;
            text-align: center;
        }

        /* Course Table Styles */
        .course-table-container {
            overflow-x: auto;
            width: 80%; 
            margin: 0 auto;
        }

        .course-table {
            width: 100%;
            border-collapse: collapse;
        }

        .course-table thead th {
            background-color: transparent; 
            color: #666;
            font-weight: 500;
            text-align: left;
            padding: 10px 15px;
            border-bottom: 1px solid #ccc; 
            font-size: 13px;
        }
        
        .course-table thead th:nth-child(1) { width: 5%; }
        .course-table thead th:nth-child(2) { width: 35%; }
        .course-table thead th:nth-child(3) { width: 25%; }
        .course-table thead th:nth-child(4) { width: 20%; }
        .course-table thead th:nth-child(5) { width: 15%; }

        .course-table tbody td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            color: #555;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <div class="lms-container">
        <header class="lms-header">
            <div class="logo">LMS</div>
            <div class="search-bar">
                <input type="text" placeholder="Search">
            </div>
            <div class="header-icons">
                <i class="material-icons">notifications</i>
                <i class="material-icons">account_circle</i>
            </div>
        </header>

        <div class="main-content-area">
            <aside class="lms-sidebar">
                <nav>
                    <ul>
                        <li class="nav-item">
                            <i class="fa-solid fa-house-chimney icon-red"></i>
                            <span>Dash Board</span>
                        </li>
                        <li class="nav-item active">
                            <i class="fa-solid fa-user-graduate icon-yellow"></i>
                            <span>Student Management</span>
                        </li>
                        <li class="nav-item">
                            <i class="fa-solid fa-book-open icon-blue"></i>
                            <span>Course Requests</span>
                        </li>
                        <li class="nav-item">
                            <i class="fa-solid fa-receipt icon-brown"></i>
                            <span>Payment History</span>
                        </li>
                    </ul>
                </nav>
                <div class="logout">Log Out</div>
            </aside>

            <main class="lms-content">
                <h1>Student Management > View Detail</h1>

                <div class="content-wrapper"> 
                    
                    <div class="profile-pic-container">
                        <img src="https://i.imgur.com/8Q9K3aA.jpeg" alt="Student Profile" class="profile-pic">
                    </div>

                    <div class="account-info-section">
                        
                        <div class="section-title"># Account Information</div>
                        
                        <div class="info-grid-container">
                            
                            <div class="info-column">
                                <div class="detail-item">
                                    <span class="detail-label">Username:</span>
                                    <span class="detail-value">anna.nguyen_2024</span> 
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Status:</span>
                                    <span class="detail-value status-active">Active</span>
                                </div>
                            </div>

                            <div class="info-column">
                                <div class="detail-item">
                                    <span class="detail-label">Email:</span>
                                    <span class="detail-value">anna.nguyen@example.com</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Total Courses Enrolled:</span>
                                    <span class="detail-value">3</span>
                                </div>
                            </div>
                            
                        </div>
                    </div>

                    <div class="courses-list-section"># Courses List</div>

                    <div class="course-table-container">
                        <table class="course-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Course Name</th>
                                    <th>Instructor</th>
                                    <th>Progress</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>Advanced Math (Grade 7)</td>
                                    <td>Mr. Smith</td>
                                    <td>75%</td>
                                    <td style="color: #FFC107;">In Progress</td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>IELTS Preparation (Level B)</td>
                                    <td>Ms. Johnson</td>
                                    <td>100%</td>
                                    <td style="color: #4CAF50; font-weight: 600;">Completed</td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>Creative Writing Workshop</td>
                                    <td>Dr. Lee</td>
                                    <td>10%</td>
                                    <td style="color: #03A9F4;">Not Started</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div> </main>
        </div>
    </div>

</body>
</html>