<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Course Details | LMS</title>
        <style>
            /* ========= GLOBAL ========= */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Poppins", sans-serif;
            }

            body {
                background-color: #f8fafc;
                color: #1e1e1e;
                display: flex; /* MỚI: Kích hoạt Flexbox cho body */
                flex-direction: column; /* MỚI: Header trên, Layout dưới */
                min-height: 100vh;
            }
            
            /* ========= LAYOUT 2 CỘT ========= */
            .main-layout {
                display: flex; /* MỚI */
                flex: 1; /* MỚI: Chiếm hết chiều cao */
                width: 100%;
            }

            .sidebar-container {
                width: 220px; /* MỚI: Chiều rộng cố định */
                flex-shrink: 0;
                background-color: #fff;
                box-shadow: 2px 0 5px rgba(0,0,0,0.05);
                padding-top: 10px;
            }
            
            .page-content {
                flex-grow: 1; /* MỚI: Chiếm hết không gian còn lại */
                background-color: #f8fafc;
                padding-bottom: 40px;
            }

            /* ========= HEADER (Giữ nguyên) ========= */
            header {
                width: 100%;
                background-color: #00c2c2;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 40px;
            }
            .header-left { display: flex; align-items: center; gap: 8px; }
            .header-left .logo { font-size: 22px; font-weight: 600; color: white; }
            .search-container { flex: 1; display: flex; justify-content: center; }
            .search-container input { width: 400px; padding: 8px 15px; border-radius: 25px; border: none; outline: none; font-size: 14px; }
            .profile { font-size: 22px; color: white; cursor: pointer; }

            /* ========= COURSE SECTION (Điều chỉnh Margin/Width) ========= */
            .course-container {
                /* CẬP NHẬT */
                width: 95%;
                max-width: none; 
                margin: 40px 30px 40px 30px; 
                background-color: #fff;
                border-radius: 15px;
                box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.05);
                padding: 40px 50px;
            }

            .course-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                flex-wrap: wrap;
                gap: 30px;
            }

            .course-info h1 { font-size: 32px; font-weight: 700; color: #1e1e1e; }
            .course-info p { color: #8a8a8a; font-size: 15px; margin-top: 6px; }
            .instructor { font-weight: 600; margin-top: 12px; color: #1e1e1e; }

            /* Enroll Card */
            .enroll-card {
                background-color: #fafafa;
                border-radius: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                padding: 25px 35px;
                width: 270px;
                text-align: center;
            }

            .enroll-card button { background-color: #28c3c3; border: none; color: white; font-weight: 600; border-radius: 8px; padding: 12px 40px; font-size: 16px; cursor: pointer; transition: 0.3s; }
            .enroll-card button:hover { background-color: #20b1b1; }
            .enroll-card p { color: #8b8b8b; font-size: 13px; margin-top: 10px; line-height: 1.5; }

            /* ========= COURSE DETAILS ========= */
            .details-row {
                display: flex;
                justify-content: flex-start;
                align-items: stretch;
                flex-wrap: wrap;
                gap: 25px;
                margin-top: 40px;
            }

            .detail-box {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
                padding: 18px 25px;
                flex: 1;
                min-width: 220px;
            }

            .detail-box h3 { font-size: 15px; font-weight: 600; color: #1e1e1e; margin-bottom: 6px; }
            .detail-box p { font-size: 13px; color: #8b8b8b; line-height: 1.4; }

            /* ========= WHAT YOU'LL LEARN (Điều chỉnh Margin/Width) ========= */
            .learn-section {
                /* CẬP NHẬT */
                width: 95%;
                max-width: none; 
                background-color: #f0f4ff;
                border-radius: 15px;
                padding: 35px 50px;
                margin: 0px 30px 40px 30px; /* Đảm bảo căn lề trái phù hợp */
            }

            .learn-section h2 { font-size: 22px; font-weight: 700; color: #1e1e1e; margin-bottom: 15px; }
            .learn-section p { font-size: 15px; color: #707070; line-height: 1.8; max-width: 950px; }

            /* ========= FOOTER (Điều chỉnh vị trí) ========= */
            footer {
                display: flex;
                justify-content: flex-start; /* Căn lề trái */
                align-items: center;
                background: #fff;
                border-top: 1px solid #e0e0e0;
                padding: 20px 30px; /* Thêm padding trái */
                margin-top: 0;
                gap: 40px;
                width: 100%;
            }

            footer a { color: #1e1e1e; text-decoration: none; font-weight: 600; font-size: 14px; }
            footer a:hover { color: #28c3c3; }
        </style>
    </head>
    <body>

        <jsp:include page="header.jsp" />   
        
        <div class="main-layout">

            <div class="sidebar-container">
                <jsp:include page="sidebar_student.jsp" />
            </div>

            <div class="page-content">

                <section class="course-container">
                    <div class="course-header">
                        <div class="course-info">
                            <h1>${course.title}</h1>
                            <p>${course.description}</p>
                            <p class="instructor">By ${course.instructorName}</p>
                        </div>

                        <div class="enroll-card">
                            <c:choose>
                                <c:when test="${enrolled}">
                                    <button disabled>Already Enrolled</button>
                                </c:when>
                                <c:otherwise>
                                    <form action="ModuleDetailServlet" method="get">
                                        <input type="hidden" name="courseId" value="${course.courseID}">
                                        <button type="submit">Enroll</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                            <p>Access provided by FPT University<br>${course.enrolledCount} already enrolled</p>
                        </div>
                    </div>

                    <div class="details-row">
                        <div class="detail-box">
                            <h3>4 course series</h3>
                            <p>Gain in-depth knowledge of a subject</p>
                        </div>

                        <div class="detail-box">
                            <h3>Beginner level</h3>
                            <p>No prior experience required</p>
                        </div>

                        <div class="detail-box">
                            <h3>4 weeks to complete</h3>
                            <p>At 1–4 hours a week</p>
                        </div>
                    </div>
                </section>

                <section class="learn-section">
                    <h2>What you'll learn</h2>
                    <p>
                        Artificial Intelligence (AI) is no longer science fiction. It is rapidly permeating all industries and having a profound impact on virtually every aspect of our existence.
                        Whether you are an executive, a leader, an industry professional, a researcher, or a student — understanding AI, its impact and transformative potential for your organization and our society is of paramount importance.
                    </p>
                </section>
                
                <footer>
                    <a href="#">About</a>
                    <a href="#">Outcomes</a>
                    <a href="#">Course</a>
                </footer>

            </div>
            </div>
        </body>
</html>