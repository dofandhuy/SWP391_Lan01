<%-- 
    Document   : ClassOverview
    Created on : Sep 28, 2025, 11:02:53 AM
    Author     : Admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Classroom</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                display: flex;
                height: 100vh;
            }

            /* Sidebar */
            .sidebar {
                width: 220px;
                background: #fff;
                border-right: 1px solid #ddd;
                padding: 20px;
            }
            .sidebar h2 {
                margin-bottom: 20px;
                font-size: 18px;
            }
            .menu a {
                display: block;
                padding: 10px;
                margin-bottom: 8px;
                text-decoration: none;
                border-radius: 6px;
                color: #333;
                font-weight: 500;
            }
            .menu a:hover {
                background: #f2f2f2;
            }
            .schedule {
                background: #ffe9c8;
            }
            .member {
                background: #d9ecff;
            }
            .assignment {
                background: #ffd6d6;
            }
            .mark {
                background: #e5e5ff;
            }
            .lessons {
                background: #fff4d6;
            }

            /* Main */
            .main {
                flex: 1;
                padding: 20px;
                background: #f9fafb;
                display: flex;
                flex-direction: column;
            }

            /* Header */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .header-info h1 {
                margin: 0;
                font-size: 22px;
            }
            .header-info p {
                margin: 0;
                color: #555;
            }
            .icons {
                display: flex;
                gap: 15px;
            }
            .icon {
                width: 30px;
                height: 30px;
                background: #ccc;
                border-radius: 50%;
            }

            /* Stats */
            .stats {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
                margin-bottom: 20px;
            }
            .stat-box {
                background: #fff;
                padding: 15px;
                text-align: center;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .stat-box h3 {
                font-size: 14px;
                color: #666;
                margin-bottom: 8px;
            }
            .stat-box p {
                font-size: 20px;
                font-weight: bold;
            }

            /* Schedule */
            .week {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 10px;
                flex: 1;
            }
            .day {
                background: #fff;
                padding: 10px;
                border-radius: 6px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .day h4 {
                margin: 0 0 8px;
                font-size: 14px;
                font-weight: bold;
            }
            .day p {
                font-size: 12px;
                color: #777;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Class Overview</h2>
            <div class="menu">
                <a href="#" class="schedule">📅 Schedule</a>
                <a href="ClassMember.jsp" class="member">👥 Member</a>
                <a href="AssignmentList.jsp" class="assignment">📝 Assignment</a>
                <a href="#" class="mark">📊 Mark Report</a>
                <a href="LessonList.jsp" class="lessons">📖 Lessons</a>
            </div>
        </div>

        <!-- Main -->
        <div class="main">
            <!-- Header -->
            <div class="header">
                <div class="header-info">
                    <h1>Class name: ${clazz.className}</h1>
                    <p>Class code: ${clazz.classCode}</p>

                </div>
                <div class="icons">
                    <div class="icon">🔔</div>
                    <a href ="EditProfile.jsp">
                        <div class="icon">👤</div>
                    </a>
                </div>
            </div>

            <!-- Stats -->
            <div class="stats">
                <div class="stat-box">
                    <h3>Number of Students</h3>
                    <p>${studentCount}</p>
                </div>
                <div class="stat-box">
                    <h3>Number of Exercises</h3>
                    <p>${exerciseCount}</p>
                </div>
                <div class="stat-box">
                    <h3>Submitted on time</h3>
                    <p>${submittedCount}</p>
                </div>
            </div>

            <!-- Week -->
            <div class="week">
                <c:set var="days" value="SUN,MON,TUE,WED,THU,FRI,SAT" />

                <c:forTokens items="${days}" delims="," var="day" varStatus="status">
                    <div class="day">
                        <h4>${day}</h4>
                        <c:set var="hasEvent" value="false" />
                        <c:forEach var="event" items="${events}">
                            <%-- Lấy thứ trong tuần từ event.startTime --%>
                            <fmt:formatDate value="${event.startTime}" pattern="u" var="dayOfWeek"/> 
                            <%-- pattern="u" trả về 1=MON ... 7=SUN --%>

                            <c:if test="${(day == 'SUN' and dayOfWeek == 7) 
                                          or (day == 'MON' and dayOfWeek == 1) 
                                          or (day == 'TUE' and dayOfWeek == 2)
                                          or (day == 'WED' and dayOfWeek == 3)
                                          or (day == 'THU' and dayOfWeek == 4)
                                          or (day == 'FRI' and dayOfWeek == 5)
                                          or (day == 'SAT' and dayOfWeek == 6)}">
                                  <p>${event.eventType}: ${event.title} 
                                      (<fmt:formatDate value="${event.startTime}" pattern="HH:mm"/> 
                                  - <fmt:formatDate value="${event.endTime}" pattern="HH:mm"/>)
                                  </p>
                                  <c:set var="hasEvent" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${!hasEvent}">
                            <p>No events</p>
                        </c:if>
                    </div>
                </c:forTokens>
            </div>

        </div>

    </body>
</html>
                