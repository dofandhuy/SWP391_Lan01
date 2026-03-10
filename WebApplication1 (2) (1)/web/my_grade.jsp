<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Grades</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            /* CSS nội tuyến */
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #ffffff;
                color: #2d2f31;
                margin: 0;
                padding: 0;
            }

            .grades-container {
                max-width: 1100px;
                margin: 40px auto;
                padding: 0 20px;
            }

            h1 {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 30px;
            }

            /* ----- Header của bảng ----- */
            .grades-header {
                display: flex;
                border-bottom: 1px solid #d1d7dc;
                padding: 10px 0;
                color: #6a6f73;
                font-weight: 700;
                font-size: 0.9rem;
                text-transform: uppercase;
            }

            /* ----- Cấu trúc cột chung ----- */
            /* * Chúng ta sử dụng flexbox để chia cột.
             * Tỉ lệ: Item (4) / Status (2) / Due (2) / Weight (1) / Grade (1)
            */
            .col-item {
                flex: 4; /* Rộng nhất */
                padding-left: 10px;
            }
            .col-status {
                flex: 2;
                padding-left: 10px;
            }
            .col-due {
                flex: 2;
                padding-left: 10px;
            }
            .col-weight, .col-grade {
                flex: 1; /* Hẹp nhất */
                text-align: left;
                padding-left: 10px;
            }

            /* ----- Các hàng điểm (Grade Items) ----- */
            .grade-item {
                display: flex;
                align-items: center;
                border-bottom: 1px solid #f0f0f0;
                padding: 20px 0;
            }

            .grade-item:last-child {
                border-bottom: none;
            }

            .grade-item .col-item {
                display: flex;
                align-items: flex-start; /* Căn trên để icon khớp với dòng đầu tiên */
            }

            .grade-item .item-icon {
                font-size: 1.2rem;
                margin-right: 15px;
                width: 20px; /* Đảm bảo các icon chiếm không gian như nhau */
                text-align: center;
                margin-top: 3px;
            }

            .grade-item .item-details .title {
                display: block;
                font-size: 1rem;
                font-weight: 700;
                color: #0056d2; /* Màu xanh giống link */
                text-decoration: none;
                cursor: pointer;
            }
            .grade-item .item-details .title:hover {
                text-decoration: underline;
            }

            .grade-item .item-details .type {
                font-size: 0.85rem;
                color: #6a6f73;
                margin-top: 4px;
            }

            /* ----- Các biến thể của Item ----- */

            /* 1. Trượt (Failed) */
            .grade-item.failed .item-icon {
                color: #d9534f; /* Màu đỏ */
            }
            .grade-item.failed .col-status {
                color: #d9534f;
                font-weight: 700;
            }
            .grade-item.failed .col-grade {
                font-weight: 700;
            }

            /* 2. Bị khoá (Locked) */
            .grade-item.locked .item-icon {
                color: #2d2f31; /* Màu xám đen */
            }
            .grade-item.locked .col-status {
                color: #2d2f31;
            }
            .grade-item.locked .col-status .fa-lock {
                font-size: 0.9rem;
                margin-right: 5px;
            }

            /* 3. Item cha (Peer review) */
            .grade-item.parent-item .item-details .type {
                max-width: 350px; /* Giúp text "Submit your assignment..." xuống dòng */
            }

            /* 4. Item con (Sub-item) */
            .grade-item.sub-item {
                background-color: #f7f9fa; /* Nền hơi xám để phân biệt */
                border-bottom: 1px solid #e8e8e8;
            }
            .grade-item.sub-item .col-item {
                /* Thụt lề cho item con */
                padding-left: 60px;
            }
            .grade-item.sub-item .item-icon {
                color: #0056d2; /* Màu xanh */
            }

            /* ----- Các cột khác ----- */
            .col-due {
                font-size: 0.9rem;
                color: #2d2f31;
                line-height: 1.4;
            }
            .col-due .fa-calendar {
                margin-right: 8px;
                color: #6a6f73;
            }

            .col-weight, .col-grade {
                font-size: 0.9rem;
                font-weight: 500;
            }

            .col-grade {
                font-weight: 700;
            }

            /* ----- Nút bấm nổi (Floating Action Button) ----- */
            .fab {
                position: fixed;
                bottom: 30px;
                right: 30px;
                width: 60px;
                height: 60px;
                background-color: #0056d2;
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.8rem;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                cursor: pointer;
                transition: transform 0.2s ease;
            }
            .fab:hover {
                transform: scale(1.05);
            }
        </style>
    </head>
    <body>

        <div class="grades-container">
            <h1>Grades</h1>

            <div class="grades-header">
                <div class="col-item">Item</div>
                <div class="col-status">Status</div>
                <div class="col-due">Due</div>
                <div class="col-weight">Weight</div>
                <div class="col-grade">Grade</div>
            </div>

            <div class="grades-list">

                <div class="grade-item failed">
                    <div class="col-item">
                        <i class="fa-solid fa-circle-exclamation item-icon"></i>
                        <div class="item-details">
                            <a class="title">What is futures thinking?</a>
                            <span class="type">Graded Assignment</span>
                        </div>
                    </div>
                    <div class="col-status">Didn't Pass</div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 23<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight">5%</div>
                    <div class="col-grade">0%</div>
                </div>

                <div class="grade-item locked">
                    <div class="col-item">
                        <i class="fa-solid fa-lock item-icon"></i>
                        <div class="item-details">
                            <a class="title">When does the future start?</a>
                            <span class="type">Graded Assignment</span>
                        </div>
                    </div>
                    <div class="col-status">
                        <i class="fa-solid fa-lock"></i> Locked
                    </div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 23<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight">5%</div>
                    <div class="col-grade">--</div>
                </div>

                <div class="grade-item locked">
                    <div class="col-item">
                        <i class="fa-solid fa-lock item-icon"></i>
                        <div class="item-details">
                            <a class="title">What are the seven benefits of futures thinking?</a>
                            <span class="type">Graded Assignment</span>
                        </div>
                    </div>
                    <div class="col-status">
                        <i class="fa-solid fa-lock"></i> Locked
                    </div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 23<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight">5%</div>
                    <div class="col-grade">--</div>
                </div>

                <div class="grade-item locked parent-item">
                    <div class="col-item">
                        <i class="fa-solid fa-lock item-icon"></i>
                        <div class="item-details">
                            <a class="title">Choose your own future</a>
                            <span class="type">Submit your assignment and review 2 peers' assignments to get your grade.</span>
                        </div>
                    </div>
                    <div class="col-status"></div>
                    <div class="col-due"></div>
                    <div class="col-weight">10%</div>
                    <div class="col-grade">--</div>
                </div>

                <div class="grade-item sub-item locked">
                    <div class="col-item">
                        <i class="fa-solid fa-user-pen item-icon"></i> <div class="item-details">
                            <a class="title">Submit your assignment</a>
                        </div>
                    </div>
                    <div class="col-status">
                        <i class="fa-solid fa-lock"></i> Locked
                    </div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 25<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight"></div>
                    <div class="col-grade"></div>
                </div>

                <div class="grade-item sub-item locked">
                    <div class="col-item">
                        <i class="fa-solid fa-users item-icon"></i> <div class="item-details">
                            <a class="title">Review 2 peers' assignments.</a>
                        </div>
                    </div>
                    <div class="col-status">
                        <i class="fa-solid fa-lock"></i> Locked
                    </div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 28<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight"></div>
                    <div class="col-grade"></div>
                </div>

                <div class="grade-item">
                    <div class="col-item">
                        <i class="fa-solid fa-clipboard-list item-icon"></i> <div class="item-details">
                            <a class="title">What's a signal of change?</a>
                            <span class="type">Graded Assignment</span>
                        </div>
                    </div>
                    <div class="col-status">--</div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 28<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight">5%</div>
                    <div class="col-grade">--</div>
                </div>

                <div class="grade-item locked">
                    <div class="col-item">
                        <i class="fa-solid fa-lock item-icon"></i>
                        <div class="item-details">
                            <a class="title">Future of Work - Signals of Change</a>
                            <span class="type">Graded Assignment</span>
                        </div>
                    </div>
                    <div class="col-status">
                        <i class="fa-solid fa-lock"></i> Locked
                    </div>
                    <div class="col-due">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Oct 28<br>11:59 PM +07</span>
                    </div>
                    <div class="col-weight">5%</div>
                    <div class="col-grade">--</div>
                </div>

            </div> </div> <div class="fab">
            <i class="fa-solid fa-comment-dots"></i>
        </div>

    </body>
</html>