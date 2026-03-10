<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. Tính toán phân trang --%>
<c:set var="totalQuestions" value="${fn:length(quizData.questions)}" />
<c:set var="questionsPerPage" value="5" />
<c:set var="totalPages" value="${Math.ceil(totalQuestions / questionsPerPage)}" />

<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz: <c:out value="${quizData.quizTitle}" /></title>
    
    <style>
        /* === CÀI ĐẶT CƠ BẢN & TOÀN MÀN HÌNH === */
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f0f2f5;
            overflow: hidden; 
        }

        /* === LỚP PHỦ BẮT ĐẦU THI === */
        #start-quiz-overlay {
            position: fixed; top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.7);
            display: flex; justify-content: center; align-items: center;
            z-index: 200; color: white;
            flex-direction: column; text-align: center;
        }
        #start-quiz-overlay h1 { font-size: 2.5rem; }
        #start-quiz-overlay p { font-size: 1.2rem; max-width: 600px; line-height: 1.5; }
        #start-quiz-button {
            padding: 15px 30px; font-size: 1.2rem; font-weight: bold;
            background-color: #28a745; color: white; border: none;
            border-radius: 8px; cursor: pointer; margin-top: 20px;
        }
        #start-quiz-button:hover { background-color: #218838; }

        /* === BỐ CỤC THI ĐẤU === */
        .quiz-layout { display: flex; height: 100vh; width: 100%; }

        /* === KHUNG BÊN TRÁI (Câu hỏi & Header) === */
        .question-panel {
            flex-grow: 1;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* === TOP BAR === */
        .top-bar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 25px; border-bottom: 1px solid #ddd;
            background-color: #fff; flex-shrink: 0; z-index: 100;
        }
        .top-bar .quiz-info h2 { margin: 0; font-size: 1.2rem; color: #333; }
        .top-bar .countdown {
            font-size: 1.2rem; font-weight: bold; color: #d9534f;
            background-color: #fcf8e3; border: 1px solid #faebcc;
            padding: 8px 15px; border-radius: 5px;
        }
        .top-bar .countdown.low-time { animation: pulse 1s infinite; }
        @keyframes pulse {
            0% { background-color: #f2dede; }
            50% { background-color: #d9534f; color: white; }
            100% { background-color: #f2dede; }
        }

        /* === DANH SÁCH CÂU HỎI (KHU VỰC CUỘN) === */
        .question-list-wrapper {
            flex-grow: 1; 
            overflow-y: auto; 
            padding: 25px;
            background-color: #f0f2f5;
        }
        
        /* Ẩn tất cả câu hỏi mặc định */
        .question-item {
            display: none; /* Sẽ được kích hoạt bằng JS */
            background: #fff; border: 1px solid #ddd; border-radius: 8px;
            padding: 20px; margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        /* Lớp để JS hiển thị câu hỏi của trang hiện tại */
        .question-item.active {
            display: block;
        }

        .question-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
        .question-number { font-weight: bold; font-size: 1.1rem; color: #333; margin-right: 10px; }
        .question-text { flex-grow: 1; font-size: 1.1rem; line-height: 1.5; color: #333; }
        .question-points { background-color: #e0f7fa; color: #00796b; padding: 5px 10px; border-radius: 4px; font-size: 0.85rem; font-weight: bold; white-space: nowrap; }
        
        /* === CÁC LỰA CHỌN TRẢ LỜI === */
        .options-group { margin-top: 10px; }
        .option-item { margin-bottom: 10px; display: flex; align-items: flex-start; }
        .option-item input[type="radio"] { margin-top: 5px; margin-right: 10px; min-width: 16px; min-height: 16px; }
        .option-item label { cursor: pointer; font-size: 1rem; color: #444; flex-grow: 1; }
        .fill-blank-input { width: 80%; padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; margin-top: 5px; }
        
        /* === NÚT NỘP BÀI (Trong khu vực cuộn) === */
        .submit-button-container {
            padding: 20px 0; /* Điều chỉnh padding */
            text-align: center;
            display: none; /* Ẩn mặc định, chỉ JS hiện ở trang cuối */
        }
        .submit-quiz-button {
            background-color: #007bff; color: white; padding: 15px 40px;
            border: none; border-radius: 5px; font-size: 1.1rem;
            font-weight: bold; cursor: pointer;
        }
        .submit-quiz-button:hover { background-color: #0056b3; }
        
        /* === THANH ĐIỀU HƯỚNG PHÂN TRANG (Trong khu vực cuộn) === */
        .pagination-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0; /* Điều chỉnh padding */
            margin-top: 20px;
        }
        .pagination-controls button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
        }
        .pagination-controls button:hover {
            background-color: #0056b3;
        }
        .pagination-controls button:disabled {
            background-color: #c0c0c0;
            cursor: not-allowed;
        }
        .pagination-controls #page-indicator {
            font-size: 1rem;
            font-weight: bold;
            color: #555;
        }

        /* === KHUNG BÊN PHẢI (BẢNG ĐIỀU HƯỚNG) === */
        .navigation-panel {
            width: 280px; flex-shrink: 0; background: #fff;
            border-left: 1px solid #ddd; height: 100vh;
            display: flex; flex-direction: column; z-index: 50;
        }
        .nav-header { padding: 20px; font-size: 1.1rem; font-weight: bold; border-bottom: 1px solid #eee; text-align: center; flex-shrink: 0; }
        .palette-wrapper { padding: 20px; overflow-y: auto; flex-grow: 1; }
        .palette-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(45px, 1fr));
            gap: 10px;
        }
        .palette-item {
            display: flex; justify-content: center; align-items: center;
            height: 45px; width: 45px; text-decoration: none;
            color: #007bff; background-color: #f8f9fa;
            border: 1px solid #dee2e6; border-radius: 5px;
            font-weight: bold; transition: all 0.2s ease;
        }
        .palette-item:hover { background-color: #e9ecef; border-color: #adb5bd; }
        .palette-item.answered { background-color: #28a745; color: white; border-color: #28a745; }
        
    </style>
</head>
<body>

    <div id="start-quiz-overlay">
        <h1><c:out value="${quizData.quizTitle}" /></h1>
        <p>
            Bài kiểm tra này sẽ chạy ở chế độ toàn màn hình. Bạn sẽ không thể rời khỏi màn hình bài làm.
            Đồng hồ sẽ bắt đầu đếm ngược ngay khi bạn nhấn "Bắt đầu".
        </p>
        <p>Chúc bạn làm bài tốt!</p>
        <button id="start-quiz-button">Bắt đầu làm bài</button>
    </div>

    <div class="quiz-layout" style="visibility: hidden;">
        
        <%-- =================================================== --%>
        <%-- KHU VỰC BÊN TRÁI (Header + Form câu hỏi) --%>
        <%-- =================================================== --%>
        <div class="question-panel">
            
            <div class="top-bar">
                <div class="quiz-info">
                    <h2><c:out value="${quizData.quizTitle}" /></h2>
                </div>
                <div class="countdown">
                    Thời gian: <span id="countdown-timer">--:--:--</span>
                </div>
            </div>

            <form id="quizForm" action="SubmitQuizServlet" method="post" 
                  data-duration-minutes="<c:out value='${quizData.durationInMinutes}' default='30' />"
                  data-questions-per-page="${questionsPerPage}"
                  data-total-pages="<fmt:formatNumber value='${totalPages}' maxFractionDigits='0' />">
                
                <input type="hidden" name="attemptId" value="${quizData.attemptId}">
                <input type="hidden" name="quizId" value="${quizData.quizId}">

                <%-- Khu vực cuộn chứa CÂU HỎI, NÚT PHÂN TRANG, NÚT NỘP BÀI --%>
                <div class="question-list-wrapper">
                    
                    <%-- 1. Danh sách câu hỏi (ẩn/hiện theo trang) --%>
                    <div class="question-list">
                        
                        <c:forEach var="question" items="${quizData.questions}" varStatus="loop">
                            
                            <%-- Tính toán trang cho câu hỏi này --%>
                            <c:set var="pageNumber" value="${(loop.index div questionsPerPage) + 1}" />

                            <div class="question-item" 
                                 id="q-anchor-${loop.count}" 
                                 data-page="${pageNumber}"
                                 data-question-index="${loop.count}">
                                
                                <div class="question-header">
                                    <span class="question-number">${loop.count}.</span>
                                    <div class="question-text"><c:out value="${question.questionText}" /></div>
                                    <span class="question-points">
                                        <fmt:formatNumber value="${quizData.pointPerQuestion}" maxFractionDigits="1" /> point(s)
                                    </span>
                                </div>
                                
                                <div class="options-group">
                                    <c:choose>
                                        <c:when test="${question.questionType eq 'MCQ' || question.questionType eq 'TrueFalse'}">
                                            <c:forEach var="option" items="${question.options}">
                                                <div class="option-item">
                                                    <input type="radio" 
                                                           id="q${question.questionID}o${option.answerID}" 
                                                           name="q${question.questionID}" 
                                                           value="${option.answerID}"
                                                           data-question-index="${loop.count}"
                                                           required>
                                                    <label for="q${question.questionID}o${option.answerID}"><c:out value="${option.answerText}" /></label>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        
                                        <c:when test="${question.questionType eq 'FillBlank'}">
                                            <div class="option-item">
                                                <input type="text" 
                                                       id="q${question.questionID}fill" 
                                                       name="q${question.questionID}" 
                                                       class="fill-blank-input" 
                                                       placeholder="Your answer" 
                                                       data-question-index="${loop.count}"
                                                       required>
                                            </div>
                                        </c:when>
                                        
                                        <c:otherwise>
                                            <p>Unsupported question type: <c:out value="${question.questionType}" /></p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div> <%-- end .question-list --%>

                    
                    <%-- 2. Thanh điều khiển phân trang (nằm trong khu vực cuộn) --%>
                    <div class="pagination-controls">
                        <button type="button" id="btn-prev">&laquo; Trang trước</button>
                        <span id="page-indicator">Trang 1 / <fmt:formatNumber value='${totalPages}' maxFractionDigits='0' /></span>
                        <button type="button" id="btn-next">Trang sau &raquo;</button>
                    </div>

                    
                    <%-- 3. Nút Nộp bài (nằm trong khu vực cuộn, chỉ hiện ở trang cuối) --%>
                    <div class="submit-button-container" id="submit-container">
                        <button type="submit" class="submit-quiz-button">Nộp bài và Kết thúc</button>
                    </div>
                    
                </div> <%-- end .question-list-wrapper --%>
                
            </form>

        </div> <%-- end .question-panel --%>
        
        
        <%-- =================================================== --%>
        <%-- KHU VỰC BÊN PHẢI (Bảng điều hướng câu hỏi) --%>
        <%-- =================================================== --%>
        <div class="navigation-panel">
            <div class="nav-header">Danh sách câu hỏi</div>
            
            <div class="palette-wrapper">
                <div class="palette-grid">
                    <%-- Vòng lặp tạo các ô điều hướng --%>
                    <c:forEach begin="1" end="${totalQuestions}" varStatus="loop">
                        <c:set var="pageNumber" value="${((loop.index) div questionsPerPage) + 1}" />
                        <a href="#q-anchor-${loop.count}" 
                           class="palette-item" 
                           id="pal-item-${loop.count}"
                           data-question-index="${loop.count}"
                           data-target-page="${pageNumber}">
                            ${loop.count}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div> <%-- end .navigation-panel --%>

    </div> <%-- end .quiz-layout --%>


    <%-- =================================================== --%>
    <%-- JAVASCRIPT CHO TRẢI NGHIỆM QUIZ --%>
    <%-- =================================================== --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            // --- BIẾN TOÀN CỤC ---
            const startButton = document.getElementById('start-quiz-button');
            const overlay = document.getElementById('start-quiz-overlay');
            const quizLayout = document.querySelector('.quiz-layout');
            const quizForm = document.getElementById('quizForm');
            const timerDisplay = document.getElementById('countdown-timer');
            const countdownContainer = document.querySelector('.countdown');
            let timerInterval;

            // Biến cho phân trang
            let currentPage = 1;
            const totalPages = parseInt(quizForm.dataset.totalPages, 10);
            const questionsPerPage = parseInt(quizForm.dataset.questionsPerPage, 10);
            const btnPrev = document.getElementById('btn-prev');
            const btnNext = document.getElementById('btn-next');
            const pageIndicator = document.getElementById('page-indicator');
            const submitContainer = document.getElementById('submit-container');
            const paginationControls = document.querySelector('.pagination-controls');
            const allQuestions = document.querySelectorAll('.question-item');
            const questionWrapper = document.querySelector('.question-list-wrapper');

            // --- 1. HÀNH ĐỘNG BẮT ĐẦU QUIZ ---
            startButton.addEventListener('click', function() {
                requestAppFullscreen();
                overlay.style.display = 'none';
                quizLayout.style.visibility = 'visible';
                
                startQuizTimer();
                setupSecurityListeners();
                
                // Kích hoạt các trình xử lý của quiz
                setupPagination();
                setupPaletteAnswerUpdater();
                setupPaletteNavigation();
            });

            // --- 2. HÀM YÊU CẦU TOÀN MÀN HÌNH ---
            function requestAppFullscreen() {
                const elem = document.documentElement;
                if (elem.requestFullscreen) elem.requestFullscreen();
                else if (elem.mozRequestFullScreen) elem.mozRequestFullScreen();
                else if (elem.webkitRequestFullscreen) elem.webkitRequestFullscreen();
                else if (elem.msRequestFullscreen) elem.msRequestFullscreen();
            }
            
            // --- 3. HÀM ĐỒNG HỒ ĐẾM NGƯỢC ---
            function startQuizTimer() {
                let durationInMinutes = parseInt(quizForm.dataset.durationMinutes, 10);
                if (isNaN(durationInMinutes) || durationInMinutes <= 0) durationInMinutes = 30;
                
                let timeInSeconds = durationInMinutes * 60;

                timerInterval = setInterval(function() {
                    timeInSeconds--;
                    let hours = String(Math.floor(timeInSeconds / 3600)).padStart(2, '0');
                    let minutes = String(Math.floor((timeInSeconds % 3600) / 60)).padStart(2, '0');
                    let seconds = String(timeInSeconds % 60).padStart(2, '0');
                    
                    timerDisplay.textContent = `${hours}:${minutes}:${seconds}`;
                    
                    // Cảnh báo khi còn ít thời gian
                    if (timeInSeconds <= 300) { 
                        countdownContainer.classList.add('low-time');
                    }
                    
                    // Tự động nộp bài
                    if (timeInSeconds <= 0) {
                        clearInterval(timerInterval);
                        alert("Đã hết thời gian làm bài! Hệ thống sẽ tự động nộp bài của bạn.");
                        quizForm.submit();
                    }
                }, 1000);
            }

            // --- 4. HÀM BẢO MẬT MÔI TRƯỜNG ---
            function setupSecurityListeners() {
                document.addEventListener('contextmenu', e => e.preventDefault());
                document.addEventListener('copy', e => e.preventDefault());
                document.addEventListener('paste', e => e.preventDefault());
                document.addEventListener('cut', e => e.preventDefault());
                // Cảnh báo khi rời tab (có thể không hoạt động 100% khi full-screen)
                window.addEventListener('blur', () => console.warn("User attempted to leave tab!"));
                // Cảnh báo khi tải lại/đóng
                window.addEventListener('beforeunload', e => {
                    e.preventDefault();
                    e.returnValue = 'Bạn có chắc chắn muốn rời khỏi? Bài làm sẽ bị nộp.';
                });
            }
            
            // --- 5. HÀM CẬP NHẬT MÀU BẢNG ĐIỀU HƯỚNG (Khi trả lời) ---
            function setupPaletteAnswerUpdater() {
                const allInputs = document.querySelectorAll('input[data-question-index]');
                allInputs.forEach(input => {
                    const eventType = (input.type === 'radio' || input.type === 'checkbox') ? 'change' : 'input';
                    input.addEventListener(eventType, function(e) {
                        const questionIndex = e.target.dataset.questionIndex;
                        const paletteItem = document.getElementById(`pal-item-${questionIndex}`);
                        if (!paletteItem) return;

                        let isAnswered = (e.target.type === 'radio') ? e.target.checked : (e.target.value.trim() !== '');
                        
                        if (isAnswered) {
                            paletteItem.classList.add('answered');
                        } else {
                            paletteItem.classList.remove('answered');
                        }
                    });
                });
            }

            // --- 6. HÀM THIẾT LẬP PHÂN TRANG ---
            function setupPagination() {
                // Nút trang sau
                btnNext.addEventListener('click', () => {
                    if (currentPage < totalPages) {
                        showPage(currentPage + 1);
                    }
                });

                // Nút trang trước
                btnPrev.addEventListener('click', () => {
                    if (currentPage > 1) {
                        showPage(currentPage - 1);
                    }
                });

                // Hiển thị trang đầu tiên
                showPage(1);
            }

            // --- 7. HÀM CHÍNH ĐỂ HIỂN THỊ TRANG ---
            function showPage(pageNumber) {
                currentPage = pageNumber;

                // Ẩn tất cả câu hỏi
                allQuestions.forEach(q => q.classList.remove('active'));

                // Hiển thị câu hỏi cho trang này
                const questionsOnThisPage = document.querySelectorAll(`.question-item[data-page="${pageNumber}"]`);
                questionsOnThisPage.forEach(q => q.classList.add('active'));

                // Cập nhật trạng thái nút
                btnPrev.disabled = (currentPage === 1);
                btnNext.disabled = (currentPage === totalPages);

                // Cập nhật chỉ số trang
                pageIndicator.textContent = `Trang ${currentPage} / ${totalPages}`;

                // Chỉ hiển thị nút Nộp bài và Thanh phân trang nếu có nhiều hơn 1 trang
                if (totalPages <= 1) {
                    paginationControls.style.display = 'none';
                }

                // Chỉ hiển thị nút Nộp bài ở trang cuối
                if (currentPage === totalPages) {
                    submitContainer.style.display = 'block';
                } else {
                    submitContainer.style.display = 'none';
                }

                // Cuộn lên đầu wrapper khi chuyển trang
                questionWrapper.scrollTop = 0;
            }

            // --- 8. HÀM ĐIỀU HƯỚNG BẰNG BẢNG PALETTE ---
            function setupPaletteNavigation() {
                const paletteItems = document.querySelectorAll('.palette-item[data-target-page]');
                
                paletteItems.forEach(item => {
                    item.addEventListener('click', function(e) {
                        e.preventDefault(); // Ngăn hành vi nhảy anchor mặc định

                        const targetPage = parseInt(this.dataset.targetPage, 10);
                        const targetAnchorId = this.getAttribute('href').substring(1);
                        
                        // 1. Chuyển đến trang chứa câu hỏi đó
                        if (targetPage !== currentPage) {
                            showPage(targetPage);
                        }

                        // 2. Cuộn đến câu hỏi (cần 1 delay nhỏ để DOM kịp hiển thị)
                        setTimeout(() => {
                            const targetElement = document.getElementById(targetAnchorId);
                            if (targetElement) {
                                // Tính toán vị trí cuộn
                                const wrapperRect = questionWrapper.getBoundingClientRect();
                                const targetRect = targetElement.getBoundingClientRect();
                                const offset = targetRect.top - wrapperRect.top + questionWrapper.scrollTop - 10; // 10px padding
                                
                                questionWrapper.scrollTo({
                                    top: offset,
                                    behavior: 'smooth'
                                });
                            }
                        }, 100); 
                    });
                });
            }

        });
    </script>
</body>
</html>