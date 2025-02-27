import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import com.fraud.database.Dbconnection;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

@WebServlet("/RegisterPoliceServlet")
public class RegisterPoliceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String batchId = request.getParameter("batch_id");
        String password = request.getParameter("password"); // Plain password
        String policeStation = request.getParameter("police_station");
        String city = request.getParameter("city");
        String email = request.getParameter("email"); 

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = Dbconnection.getConnection();

            // ✅ **Hash the password before storing it**
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

            String sql = "INSERT INTO police_officers (name, batch_id, password, police_station, city, email) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, batchId);
            stmt.setString(3, hashedPassword); // ✅ Store the hashed password
            stmt.setString(4, policeStation);
            stmt.setString(5, city);
            stmt.setString(6, email);

            int result = stmt.executeUpdate();
            if (result > 0) {
                // Send email with login details
                sendEmail(email, name, batchId, password);
                response.sendRedirect("managePolice.jsp?success=1");
            } else {
                response.sendRedirect("managePolice.jsp?error=1");
            }
        } catch (Exception e) {
            response.sendRedirect("managePolice.jsp?error=" + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) Dbconnection.closeConnection(con);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void sendEmail(String recipientEmail, String name, String username, String password) {
        final String senderEmail = "fruaddetectionwebsite@gmail.com";
        final String senderPassword = "naat krtu vtmn vphc"; // Use an App Password instead of your real password

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
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Police Officer Account Created - Fraud Detection System");

            String emailContent = "<h3>Dear " + name + ",</h3>"
                    + "<p>Your account has been created successfully.</p>"
                    + "<p><strong>Username:</strong> " + username + "<br>"
                    + "<strong>Password:</strong> " + password + "</p>"
                    + "<p>For security reasons, please change your password immediately after logging in.</p>"
                
                    + "<p>Regards,<br>CitizenSafe Team</p>";

            message.setContent(emailContent, "text/html");

            Transport.send(message);
            System.out.println("Email sent successfully to " + recipientEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
