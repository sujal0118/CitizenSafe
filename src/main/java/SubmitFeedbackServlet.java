import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.fraud.database.Dbconnection;
import org.json.JSONObject;

@WebServlet("/SubmitFeedbackServlet")
public class SubmitFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("user_id");
        Integer policeId = (Integer) session.getAttribute("police_id");

        if (userId == null && policeId == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "User not logged in.");

            response.sendRedirect("login.jsp?message=Please login to submit your Feebcack.");

            response.getWriter().write(jsonResponse.toString());
            return;
        }

        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (subject == null || message == null || subject.trim().isEmpty() || message.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Subject and message cannot be empty.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        Connection con = null;
        try {
            con = Dbconnection.getConnection();
            String query;

            if (userId != null) {
                query = "INSERT INTO user_feedback (user_id, subject, message) VALUES (?, ?, ?)";
            } else {
                query = "INSERT INTO police_feedback (p_id, subject, message) VALUES (?, ?, ?)";
            }

            PreparedStatement stmt = con.prepareStatement(query);
            if (userId != null) {
                stmt.setInt(1, userId);
            } else {
                stmt.setInt(1, policeId);
            }
            stmt.setString(2, subject);
            stmt.setString(3, message);

            int rowsInserted = stmt.executeUpdate();
            stmt.close();
            jsonResponse.put("success", rowsInserted > 0);
            jsonResponse.put("message", rowsInserted > 0 ? "Feedback submitted successfully!" : "Failed to submit feedback.");
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Database error occurred.");
        } finally {
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        response.getWriter().write(jsonResponse.toString());
    }
}
