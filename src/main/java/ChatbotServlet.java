import java.io.*;
import java.net.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.HashMap;

@WebServlet("/ChatbotServlet")
public class ChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final HashMap<String, String> faqResponses = new HashMap<>();
    private static final String GEMINI_API_KEY = System.getenv("GEMINI_API_KEY");

    public void init() {
        // Define FAQ responses
        faqResponses.put("how to report fraud", "You can report fraud using our 'Report Fraud' section.");
        faqResponses.put("how to file a complaint", "To file a complaint, go to the 'File Complaint' section.");
        faqResponses.put("contact police", "If you need to contact the police, visit your nearest station.");
        faqResponses.put("fraud types", "Common fraud types include phishing, identity theft, and investment scams.");
        faqResponses.put("how to check complaint status", "You can check your complaint status from the 'Dashboard' section.");
        faqResponses.put("how long does complaint processing take", "The processing time varies, but most complaints are reviewed within 7 days.");
        faqResponses.put("can i update my complaint", "No, once submitted, a complaint cannot be modified. However, you can add more evidence.");
        faqResponses.put("how to add more evidence", "You can upload additional evidence files in the 'Dashboard' under your complaint.");
        faqResponses.put("will i get updates on my complaint", "Yes, you will receive email notifications regarding the status of your complaint.");
        faqResponses.put("who reviews complaints", "Complaints are reviewed by authorized police officers registered on our system.");
        faqResponses.put("how do i identify a fraudulent website", "Check for HTTPS security, avoid entering sensitive information, and verify official sources.");
        faqResponses.put("how do i avoid phishing scams", "Avoid clicking on unknown links, verify email senders, and never share personal details online.");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String userMessage = request.getParameter("message").toLowerCase();
        String chatbotType = request.getParameter("type");

        if ("faq".equals(chatbotType)) {
            String botResponse = faqResponses.getOrDefault(userMessage, "I don't understand. Please ask something else.");
            out.print(botResponse);
        } else if ("ai".equals(chatbotType)) {
            String aiResponse = getGeminiAIResponse(userMessage);
            out.print(aiResponse);
        }

        out.flush();
    }

    private String getGeminiAIResponse(String userMessage) {
        if (GEMINI_API_KEY == null || GEMINI_API_KEY.isEmpty()) {
            return "Error: Gemini API key is missing. Please set the environment variable.";
        }

        try {
            // ✅ Correct API URL
        	URI uri = new URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=" + GEMINI_API_KEY);

            URL url = uri.toURL();

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // ✅ Correct JSON structure
            JSONObject requestBody = new JSONObject();
            JSONArray contents = new JSONArray();

            JSONObject textPart = new JSONObject();
            textPart.put("text", userMessage);

            JSONArray parts = new JSONArray();
            parts.put(textPart);

            JSONObject content = new JSONObject();
            content.put("role", "user");  // ✅ Added role field
            content.put("parts", parts);

            contents.put(content);
            requestBody.put("contents", contents);

            // Send request
            try (OutputStream os = conn.getOutputStream()) {
                os.write(requestBody.toString().getBytes());
                os.flush();
            }

            int responseCode = conn.getResponseCode();
            String responseMessage = conn.getResponseMessage();

            // ✅ Debugging logs
            System.out.println("Response Code: " + responseCode);
            System.out.println("Response Message: " + responseMessage);

            if (responseCode != 200) {
                return "Error: Gemini AI response failed (Code " + responseCode + ")";
            }

            // ✅ Using BufferedReader for efficient reading
            StringBuilder responseText = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    responseText.append(line);
                }
            }

            // ✅ Debugging API response
            System.out.println("Full API Response: " + responseText.toString());

            JSONObject jsonResponse = new JSONObject(responseText.toString());

            // ✅ Correct response parsing
            return jsonResponse.getJSONArray("candidates")
                .getJSONObject(0)
                .getJSONObject("content")
                .getJSONArray("parts")
                .getJSONObject(0)
                .getString("text");

        } catch (Exception e) {
            e.printStackTrace();
            return "Error: Failed to connect to Gemini AI.";
        }
    }
}
