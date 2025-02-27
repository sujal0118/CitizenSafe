import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

import com.fraud.database.Dbconnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user-login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("✅ Login Attempt: " + email);

        // Validate input
        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email and password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = Dbconnection.getConnection()) {
            if (conn == null) {
                System.out.println("❌ Database connection failed.");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database connection error.");
                return;
            }

            String sql = "SELECT iduser, name, email, password FROM user WHERE email = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String storedHashedPassword = rs.getString("password");
                    System.out.println("🔹 Retrieved Hashed Password: " + storedHashedPassword);

                    if (BCrypt.checkpw(password, storedHashedPassword)) {
                        System.out.println("✅ Login Successful for: " + email);
                        
                        // Start a new session
                        HttpSession session = request.getSession();
                        session.setAttribute("user_id", rs.getInt("iduser"));
                        session.setAttribute("user", rs.getString("name"));
                        session.setAttribute("email", rs.getString("email"));
                        
                        // Optional: Set session timeout (e.g., 30 minutes)
                        session.setMaxInactiveInterval(30 * 60);

                        response.sendRedirect("index.jsp");
                    } else {
                        System.out.println("❌ Incorrect password for: " + email);
                        request.setAttribute("errorMessage", "Invalid email or password.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                } else {
                    System.out.println("❌ Email not found: " + email);
                    request.setAttribute("errorMessage", "User not found. Please register.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred during login.");
        }
    }
}
