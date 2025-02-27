import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.fraud.database.Dbconnection;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String newPassword = request.getParameter("password");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            System.out.println("🔴 Session expired or email not found in session.");
            response.getWriter().write("Session expired. Request a new OTP.");
            return;
        }

        try (Connection con = Dbconnection.getConnection()) {
            if (con == null) {
                response.getWriter().write("Database connection failed.");
                return;
            }

            // Get the old hashed password
            String getPasswordQuery = "SELECT password FROM user WHERE email=?";
            try (PreparedStatement psCheck = con.prepareStatement(getPasswordQuery)) {
                psCheck.setString(1, email);
                ResultSet rs = psCheck.executeQuery();

                if (rs.next()) {
                    String storedHashedPassword = rs.getString("password");
                    if (storedHashedPassword != null && BCrypt.checkpw(newPassword, storedHashedPassword)) {
                    	  response.sendRedirect("reset-password.jsp?error=New password cannot be the same as the old password.");
                    	    return;
                    }
                }
            }

            // Hash and update the new password
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            System.out.println("🔹 Storing hashed password for email: " + email);
            System.out.println("🔹 Hashed Password: " + hashedPassword);

            String updateQuery = "UPDATE user SET password=? WHERE email=?";
            try (PreparedStatement psUpdate = con.prepareStatement(updateQuery)) {
                psUpdate.setString(1, hashedPassword);
                psUpdate.setString(2, email);

                if (psUpdate.executeUpdate() > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    response.getWriter().write("Error updating password.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("An error occurred while updating password.");
        }
    }
}
