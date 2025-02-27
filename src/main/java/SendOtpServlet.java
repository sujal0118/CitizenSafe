import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/SendOtpServlet")
public class SendOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        // Generate 6-digit OTP
        int otp = new Random().nextInt(900000) + 100000;

        // Store OTP in session
        HttpSession session = request.getSession();
        session.setAttribute("email", email);
        session.setAttribute("otp", Integer.valueOf(otp)); // Ensure it's always Integer


        // Send OTP via Email
        boolean emailSent = sendOtpByEmail(email, otp);

        if (emailSent) {
            response.sendRedirect("verify-otp.jsp");
        } else {
            response.getWriter().println("Failed to send OTP. Please try again.");
        }
    }

    private boolean sendOtpByEmail(String email, int otp) {
        final String fromEmail = "fruaddetectionwebsite@gmail.com";  // Change to your email
        final String password = "naat krtu vtmn vphc";    // Use an app password if using Gmail

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Your OTP Code");
            message.setText("Your OTP is: " + otp + "\n\nDo not share it with anyone.");

            Transport.send(message);
            return true; // Email sent successfully
        } catch (MessagingException e) {
            e.printStackTrace();
            return false; // Email sending failed
        }
    }
}
