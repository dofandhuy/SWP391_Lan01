<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Report an Issue</title>

        <style>
            /* CSS nội tuyến */
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #f0f2f5; /* Màu nền mờ bên ngoài */
                color: #1c1e21;
                margin: 0;
                padding: 0;
            }

            /* Lớp phủ mờ toàn màn hình */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.4);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }

            /* Nội dung của Modal */
            .modal-content {
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                width: 100%;
                max-width: 500px;
                padding: 24px;
                box-sizing: border-box;
                position: relative;
            }

            /* Phần Header: Tiêu đề và nút đóng */
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .modal-header h2 {
                font-size: 1.8rem;
                font-weight: 700;
                margin: 0;
            }

            .close-button {
                font-family: Arial, sans-serif;
                font-size: 2rem;
                font-weight: 300;
                color: #606770;
                cursor: pointer;
                line-height: 1;
                padding: 0 5px;
            }
            .close-button:hover {
                color: #000;
            }

            /* Phần Thân: Form */
            .modal-body {
                /* không cần style đặc biệt */
            }

            .modal-body p,
            .modal-body .form-label {
                font-size: 1rem;
                font-weight: 600;
                color: #1c1e21;
                margin-bottom: 12px;
            }

            /* Tùy chỉnh Radio Button */
            .radio-group {
                margin-bottom: 20px;
            }

            .radio-option {
                display: block;
                position: relative;
                padding-left: 35px;
                margin-bottom: 12px;
                cursor: pointer;
                font-size: 1rem;
                color: #1c1e21;
                /* Đảm bảo chiều cao để căn chỉnh */
                min-height: 22px;
                display: flex;
                align-items: center;
            }

            /* Ẩn radio button gốc */
            .radio-option input {
                position: absolute;
                opacity: 0;
                cursor: pointer;
            }

            /* Tạo radio button giả */
            .radio-checkmark {
                position: absolute;
                top: 50%;
                left: 0;
                transform: translateY(-50%);
                height: 20px;
                width: 20px;
                background-color: #fff;
                border: 2px solid #adb5bd; /* Màu xám khi chưa check */
                border-radius: 50%;
            }

            /* Hiệu ứng khi check */
            .radio-option input:checked ~ .radio-checkmark {
                border-color: #007bff; /* Màu xanh dương khi check */
            }

            /* Tạo dấu chấm ở giữa */
            .radio-checkmark:after {
                content: "";
                position: absolute;
                display: none;
            }

            .radio-option input:checked ~ .radio-checkmark:after {
                display: block;
            }

            .radio-option .radio-checkmark:after {
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #007bff; /* Màu xanh dương */
            }

            /* Textarea mô tả */
            .form-group {
                margin-bottom: 24px;
            }

            .form-group textarea {
                width: 100%;
                height: 100px;
                border: 1px solid #ccd0d5;
                border-radius: 8px;
                padding: 12px;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                font-size: 1rem;
                color: #1c1e21;
                resize: vertical;
                box-sizing: border-box; /* Quan trọng */
            }
            .form-group textarea::placeholder {
                color: #8a9199;
            }

            /* Phần Footer: Các nút bấm */
            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                border-top: 1px solid #e0e0e0;
                padding-top: 20px;
            }

            .btn {
                padding: 10px 24px;
                border-radius: 6px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                border: none;
                transition: background-color 0.2s ease;
            }

            .btn-cancel {
                background-color: #ffffff;
                color: #007bff;
                border: 2px solid #007bff;
            }
            .btn-cancel:hover {
                background-color: #f0f8ff;
            }

            .btn-submit {
                background-color: #e4e6eb; /* Màu xám khi disabled */
                color: #bcc0c4;
                border: 2px solid #e4e6eb;
                cursor: not-allowed;
            }

            /* Nếu muốn nút submit có thể active */
            .btn-submit:not(:disabled) {
                background-color: #007bff;
                border-color: #007bff;
                color: #ffffff;
                cursor: pointer;
            }
            .btn-submit:not(:disabled):hover {
                background-color: #0056b3;
                border-color: #0056b3;
            }

        </style>
    </head>
    <body>

        <div class="modal-overlay">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>Report an issue</h2>
                    <span class="close-button">&times;</span>
                </div>

                <form action="#" method="post">
                    <div class="modal-body">

                        <p>Select an issue you'd like to report</p>

                        <div class="radio-group">
                            <label class="radio-option">Content improvement
                                <input type="radio" name="issueType" value="improvement">
                                <span class="radio-checkmark"></span>
                            </label>
                            <label class="radio-option">Offensive content
                                <input type="radio" name="issueType" value="offensive" checked>
                                <span class="radio-checkmark"></span>
                            </label>
                        </div>

                        <div class="form-group">
                            <label for="issueDescription" class="form-label">Describe the issue</label>
                            <textarea id="issueDescription" name="description"
                                      placeholder="Example: The language used in this video by the interviewer is offensive towards women"></textarea>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-submit" disabled>Submit</button>
                        <button type="button" class="btn btn-cancel">Cancel</button>
                    </div>
                </form>

            </div>
        </div>

    </body>
</html>