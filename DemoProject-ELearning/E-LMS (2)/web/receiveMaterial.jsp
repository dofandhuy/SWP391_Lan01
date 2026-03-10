<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="Entity.Material" %>

<%@ page import="java.util.List" %>

<!DOCTYPE html>

<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Quản lý Lớp học - JSP</title>

    <style>

        body {

            font-family: Arial, sans-serif;

            margin: 0;

            padding: 0;

            background-color: #f4f7f9;

        }



        .container { display: flex; min-height: 100vh; }



        .sidebar {

            width: 250px;

            background-color: #ffffff;

            padding: 20px;

            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);

        }



        .menu-title { font-size: 1.2em; font-weight: bold; margin-bottom: 30px; color: #333; }

        .menu-list { list-style: none; padding: 0; }

        .menu-item a {

            display: flex; align-items: center;

            padding: 12px 15px; margin: 8px 0;

            text-decoration: none; color: #555;

            border-radius: 5px; transition: background-color 0.2s, color 0.2s;

        }

        .menu-item.active a { background-color: #ffe6c7; color: #333; font-weight: bold; }

        .menu-item:nth-child(2) a:hover { background-color: #c7e6ff; }

        .menu-item:nth-child(3) a:hover { background-color: #ffc7c7; }

        .menu-item:nth-child(4) a:hover { background-color: #c7d8ff; }



        .main-content { flex-grow: 1; padding: 30px; }

        .class-header { text-align: center; margin-bottom: 40px; }

        .class-name-box {

            display: inline-block; background-color: #4dc2a8;

            color: white; padding: 10px 30px; border-radius: 8px;

            font-size: 1.5em; font-weight: bold;

            box-shadow: 0 4px 6px rgba(0,0,0,0.1);

        }

        .class-name-details { font-size: 0.9em; color: #ccc; margin-top: 5px; }



        .info-panel {

            display: flex;

            flex-direction: column;

            gap: 20px;

        }



        .material-row {

            display: flex;

            background-color: white;

            border-radius: 8px;

            box-shadow: 0 2px 10px rgba(0,0,0,0.05);

            min-height: 120px;

            overflow: hidden;

        }



        .info-column {

            flex: 1;

            padding: 20px;

            border-right: 1px solid #eee;

            position: relative;

        }

        .info-column:last-child { border-right: none; }

        .info-column:nth-child(2)::before {

            content: ''; position: absolute; left: 0; top: 0; height: 100%; width: 1px;

            background-color: #d1c4e9;

        }



        .column-title { font-size: 1.1em; font-weight: 600; color: #555; margin-bottom: 10px; }

        .input-value {

            background-color: #f0f0f0; border: 1px solid #ccc; padding: 10px;
border-radius: 4px; color: #333; word-break: break-word;

        }



        .file-upload-box {

            background-color: #eee; padding: 10px; border-radius: 4px; display: flex; align-items: center;

        }

        .file-link-bar {

            background-color: #5c6bc0; color: white; padding: 5px 10px;

            border-radius: 4px; font-size: 0.8em; margin-right: 10px;

        }

    </style>

</head>

<body>



<%

    List<Material> materials = (List<Material>) request.getAttribute("materials");

    String className = (String) request.getAttribute("className");

%>



<div class="container">

    <div class="sidebar">

        <div class="menu-title">Menu</div>

        <ul class="menu-list">

            <li class="menu-item active"><a href="schedule.jsp">Schedule</a></li>

            <li class="menu-item"><a href="ClassMember.jsp">Member</a></li>

            <li class="menu-item"><a href="AssignmentList.jsp">Assignment</a></li>

            <li class="menu-item"><a href="report.jsp">Mark report</a></li>

        </ul>

    </div>



    <div class="main-content">

        <div class="class-header">

            <div class="class-name-box">

                <%= (className != null ? className : "N/A") %>

            </div>

        </div>



        <div class="info-panel">

            <%

                if (materials != null && !materials.isEmpty()) {

                    for (Material material : materials) {

            %>

            <div class="material-row">

                <div class="info-column">

                    <div class="column-title">Title:</div>

                    <div class="input-value"><%= material.getTitle() %></div>

                </div>

                <div class="info-column">

                    <div class="column-title">Person upload:</div>

                    <div class="input-value"><%= material.getUploadedBy() %></div>

                </div>

                <div class="info-column">

                    <div class="column-title">File uploaded:</div>

                    <div class="file-upload-box">

                        <div class="file-link-bar">Link</div>

                        <a href="<%= request.getContextPath() + "/" + material.getFilePath() %>" target="_blank">

                            <%= material.getFilePath() %>

                        </a>

                    </div>

                </div>

            </div>

            <%

                    }

                } else {

            %>

            <p>Chưa có tài liệu nào được upload.</p>

            <%

                }

            %>

        </div>

    </div>

</div>



</body>

</html>
