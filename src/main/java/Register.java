import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import org.mindrot.jbcrypt.BCrypt;

import com.fraud.database.Dbconnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        try (Connection conn = Dbconnection.getConnection()) {
            // Check if email already exists
            String checkQuery = "SELECT * FROM user WHERE email = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkQuery);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Email already registered
                request.setAttribute("errorMessage", "Email already registered. Please log in.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Insert new user
            String insertQuery = "INSERT INTO user (name, email, password) VALUES (?, ?, ?)";
            PreparedStatement insertPs = conn.prepareStatement(insertQuery);
            insertPs.setString(1, name);
            insertPs.setString(2, email);
            insertPs.setString(3, hashedPassword);

            int rows = insertPs.executeUpdate();
            if (rows > 0) {
                sendConfirmationEmail(email);
                response.sendRedirect("login.jsp?message=Registration successful! Please log in.");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred during registration.");
        }
    }

    private void sendConfirmationEmail(String toEmail) {
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
            message.setSubject("Registration Successful!");
            message.setText("Hello, \n\nThank you for registering with us! We're excited to have you on board.\n\nBest regards,\n CitizenSafe");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
