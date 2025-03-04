import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import org.json.JSONArray;  // ✅ Correct import
import org.json.JSONObject;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URI;
import java.io.OutputStream;
import java.util.Scanner;

@WebServlet("/ChatbotServlet")
public class ChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final HashMap<String, String> faqResponses = new HashMap<>();

    public void init() {
        // Define FAQ responses
        faqResponses.put("hello", "Hello! How can I assist you?");
        faqResponses.put("how to report fraud", "You can report fraud using our 'Report Fraud' section.");
        faqResponses.put("how to file a complaint", "To file a complaint, go to the 'File Complaint' section and provide necessary details.");
        faqResponses.put("contact police", "If you need to contact the police, visit your nearest station or call emergency numbers.");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String userMessage = request.getParameter("message").toLowerCase();
        String chatbotType = request.getParameter("type");

        if ("faq".equals(chatbotType)) {
            // Rule-based FAQ chatbot
            String botResponse = faqResponses.getOrDefault(userMessage, "I don't understand. Please ask something else.");
            out.print(botResponse);
        } else if ("ai".equals(chatbotType)) {
            // AI-Based Chatbot using Google Gemini API
            String aiResponse = getAIResponse(userMessage);
            out.print(aiResponse);
        }
        
        out.flush();
    }

    private String getAIResponse(String userMessage) {
        try {
            String apiKey = System.getenv("GEMINI_API_KEY");
            System.out.println("GEMINI_API_KEY: " + System.getenv("GEMINI_API_KEY"));
// Use environment variable for security
            if (apiKey == null || apiKey.isEmpty()) {
                return "API key is missing. Please set it in your environment variables.";
            }

            URI uri = new URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + apiKey);
            URL url = uri.toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            JSONObject requestBody = new JSONObject();
            JSONArray messageArray = new JSONArray();
            JSONObject userMessageObj = new JSONObject();
            userMessageObj.put("text", userMessage);
            
            JSONObject userRoleObj = new JSONObject();
            userRoleObj.put("role", "user");
            userRoleObj.put("parts", new JSONArray().put(userMessageObj));
            messageArray.put(userRoleObj);

            requestBody.put("contents", messageArray);

            // Send request
            try (OutputStream os = conn.getOutputStream()) {
                os.write(requestBody.toString().getBytes());
                os.flush();
            }

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                return "Error: API request failed with response code " + responseCode;
            }

            // Read response
            Scanner scanner = new Scanner(conn.getInputStream());
            StringBuilder responseText = new StringBuilder();
            while (scanner.hasNext()) {
                responseText.append(scanner.nextLine());
            }
            scanner.close();

            JSONObject jsonResponse = new JSONObject(responseText.toString());
            return jsonResponse.getJSONArray("candidates")
                               .getJSONObject(0)
                               .getJSONArray("content")
                               .getJSONObject(0)
                               .getJSONArray("parts")
                               .getJSONObject(0)
                               .getString("text");

        } catch (Exception e) {
            e.printStackTrace();
            return "Sorry, I couldn't process your request at the moment.";
        }
    }

    }

