package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;


public class ChatAIServlet extends HttpServlet {
    private String apiKey;
    private String apiUrl;

    @Override
    public void init() throws ServletException {
        apiKey = getServletContext().getInitParameter("GEMINI_API_KEY");
        apiUrl = getServletContext().getInitParameter("GEMINI_API_URL");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        String userMessage = request.getParameter("message");

        if (userMessage == null || userMessage.isEmpty()) {
            response.getWriter().print("{\"error\":\"Message is empty\"}");
            return;
        }

        // JSON body gửi đến Gemini API
        String inputJson = "{ \"contents\": [ { \"parts\": [ { \"text\": \"" 
                         + userMessage.replace("\"", "\\\"") + "\" } ] } ] }";

        // Tạo connection
        URL url = new URL(apiUrl + "?key=" + apiKey);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(inputJson.getBytes("UTF-8"));
        }

        // Đọc response từ Gemini
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(sb.toString());
        }
    }
}
