import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import com.fraud.database.Dbconnection;

@WebServlet("/SendAlertServlet")
public class SendAlertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String batchId = (String) session.getAttribute("batch_id");  // Get logged-in officer's batch ID

        if (batchId == null) {
            response.sendRedirect("police-login.jsp");
            return;
        }

        String headline = request.getParameter("headline");
        String alertMessage = request.getParameter("alertMessage");

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> emailList = new ArrayList<>();

        try {
            con = Dbconnection.getConnection();

            // **1. Store the alert in the database**
            String sql = "INSERT INTO alerts (headline, message, created_by) VALUES (?, ?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, headline);
            stmt.setString(2, alertMessage);
            stmt.setString(3, batchId);

            int result = stmt.executeUpdate();
            stmt.close();

            if (result > 0) {
                System.out.println("✅ Alert saved in database successfully.");

                // **2. Get all user emails**
                stmt = con.prepareStatement("SELECT email FROM user");
                rs = stmt.executeQuery();
                while (rs.next()) {
                    emailList.add(rs.getString("email"));
                }

                // **3. Send emails**
                if (!emailList.isEmpty()) {
                    sendEmail(emailList, headline, alertMessage);
                    response.sendRedirect("sendAlert.jsp?success=Alert sent successfully!");
                } else {
                    response.sendRedirect("sendAlert.jsp?error=No users found to send alerts!");
                }
            } else {
                response.sendRedirect("sendAlert.jsp?error=Failed to save alert!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sendAlert.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // **Function to send emails**
    private void sendEmail(List<String> recipients, String headline, String messageBody) {
        final String senderEmail = "fruaddetectionwebsite@gmail.com";
        final String senderPassword = "naat krtu vtmn vphc"; // App password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            for (String recipientEmail : recipients) {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(senderEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
                message.setSubject("Alert: " + headline);

                String emailContent = "<h3>" + headline + "</h3>"
                        + "<p>" + messageBody + "</p>"
                        + "<p>Stay alert and safe.<br>CitizenSafe Team</p>";

                message.setContent(emailContent, "text/html");

                Transport.send(message);
                System.out.println("📧 Alert email sent to: " + recipientEmail);
            }
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
