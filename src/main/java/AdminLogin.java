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
import com.fraud.database.Dbconnection;

@WebServlet("/admin-login")
public class AdminLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adminId = request.getParameter("adminId");
        String password = request.getParameter("password");

        try {
            Connection con = Dbconnection.getConnection();
            String query = "SELECT * FROM admin WHERE username = ? AND password = ?";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, adminId);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Set session attribute for admin
                HttpSession session = request.getSession();
                session.setAttribute("user_role", "admin");
                session.setAttribute("admin_username", adminId);
                response.sendRedirect("admindash.jsp"); // Redirect to admin dashboard
            } else {
                request.setAttribute("error", "Invalid Admin ID or Password");
                request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred!");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
}