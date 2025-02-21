import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fraud.database.Dbconnection;

@WebServlet("/UpdateCase")
public class UpdateCase extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int caseId = Integer.parseInt(request.getParameter("caseId"));
        String newStatus = request.getParameter("status");
        String feedback = request.getParameter("feedback");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String userEmail = "";
        String policeStation = "";

        try {
            con = Dbconnection.getConnection();

            // Retrieve user's email and assigned police station
            pstmt = con.prepareStatement("SELECT u.email, c.nearest_police_station FROM complaints c JOIN user u ON c.iduser = u.iduser WHERE c.idcomplaint = ?");
            pstmt.setInt(1, caseId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userEmail = rs.getString("email");
                policeStation = rs.getString("nearest_police_station");
            }
            rs.close();
            pstmt.close();

            // Update complaint status and feedback
            pstmt = con.prepareStatement("UPDATE complaints SET status = ?, feedback = ? WHERE idcomplaint = ?");
            pstmt.setString(1, newStatus);
            pstmt.setString(2, feedback);
            pstmt.setInt(3, caseId);
            int rowsUpdated = pstmt.executeUpdate();
            pstmt.close();

            if (rowsUpdated > 0) {
                // Send email notification with proper instructions
                sendStatusEmail(userEmail, caseId, newStatus, feedback, policeStation);
                response.sendRedirect("police.jsp?msg=Case Updated Successfully");
            } else {
                response.sendRedirect("viewCase.jsp?caseId=" + caseId + "&msg=Error Updating Case");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void sendStatusEmail(String toEmail, int caseId, String status, String feedback, String policeStation) {
        String fromEmail = "fruaddetectionwebsite@gmail.com";
        String host = "smtp.gmail.com";
        String username = "fruaddetectionwebsite@gmail.com";
        String password = "naat krtu vtmn vphc";

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Complaint Status Update");

            String emailBody = "Dear User,\n\nYour complaint (ID: " + caseId + ") has been **" + status + "**.\n\n";

            if ("Accepted".equalsIgnoreCase(status)) {
                emailBody += "✅ Your case has been accepted and is under investigation.\n";
                emailBody += "📌 Next Steps:\n";
                emailBody += "   - Please visit the assigned police station:" + policeStation + ".\n";
                emailBody += "   - Carry all necessary documents and evidence.\n";
                emailBody += "   - The officers at the station will guide you on the next steps.\n\n";
            } else if ("Rejected".equalsIgnoreCase(status)) {
                emailBody += "⚠️ Unfortunately, your case has been rejected.\n";
                emailBody += "📌 Possible Reasons:\n";
                emailBody += "   - Insufficient evidence or lack of required details.\n";
                emailBody += "   - The complaint does not meet the required criteria for investigation.\n";
                emailBody += "   - You can resubmit with additional supporting evidence.\n\n";
            } else if ("Completed".equalsIgnoreCase(status)) {
                emailBody += "🎉 Your case has been marked as Completed.\n";
                emailBody += "📌 Final Steps:\n";
                emailBody += "   - The investigation has been concluded, and necessary actions have been taken.\n";
                emailBody += "   - No further action is required from your side.\n\n";
            }

            emailBody += "📌 **Feedback from Police:** " + feedback + "\n\n";
            emailBody += "Regards,\n CitizenSafe";

            message.setText(emailBody);
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
