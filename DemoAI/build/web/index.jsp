<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Chatbot</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <script>
        async function sendMessage(event) {
            event.preventDefault();

            const message = document.getElementById("message").value.trim();
            if (!message) return;

            const resultDiv = document.getElementById("result");
            resultDiv.innerHTML = "<em>Đang suy nghĩ...</em>";

            try {
                const response = await fetch("chat", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: "message=" + encodeURIComponent(message)
                });

                const data = await response.json();

                let output = "";
                if (data.candidates && data.candidates.length > 0) {
                    output = data.candidates[0].content.parts[0].text;
                } else {
                    output = "Không có phản hồi từ AI.";
                }

                resultDiv.innerText = output;
            } catch (e) {
                resultDiv.innerText = "❌ Lỗi khi gọi API: " + e;
            }
        }
    </script>
</head>
<body>
    <div class="chat-container">
        <h1>💬 Gemini AI Chat</h1>
        <form onsubmit="sendMessage(event)">
            <input type="text" id="message" name="message" placeholder="Nhập câu hỏi của bạn..." required>
            <button type="submit">Gửi</button>
        </form>
        <div id="result" class="result-box"></div>
    </div>
</body>
</html>
