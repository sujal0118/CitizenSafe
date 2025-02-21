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

@WebServlet("/police-login")
public class PoliceLogin extends HttpServlet {
   
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String batchId = request.getParameter("policeId");
        String password = request.getParameter("password");

        try (Connection con = Dbconnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM police_officers WHERE batch_id = ? AND password = ?")) {

            ps.setString(1, batchId);
            ps.setString(2, password);  // Use hashed password verification in production

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("officer", rs.getString("name"));
                session.setAttribute("officer_id", rs.getString("batch_id"));

                session.setAttribute("p_id", rs.getInt("p_id"));
                response.sendRedirect("police.jsp");  // Redirect to dashboard on success
            } else {
                response.sendRedirect("police-login.jsp?error=Invalid credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("police-login.jsp?error=Database error");
        }
    }
}
