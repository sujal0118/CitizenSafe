import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;
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
        String enteredPassword = request.getParameter("password");

        try (Connection con = Dbconnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT p_id, name, password FROM police_officers WHERE batch_id = ?")) {

            ps.setString(1, batchId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int officerId = rs.getInt("p_id");
                String officerName = rs.getString("name");
                String storedHashedPassword = rs.getString("password");

              
                if (BCrypt.checkpw(enteredPassword, storedHashedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("officer", officerName);
                    session.setAttribute("batch_id", batchId);
                    session.setAttribute("officer_id", officerId); 

                    response.sendRedirect("police.jsp"); 
                } else {
                    response.sendRedirect("police-login.jsp?message=Invalid credentials");
                }
            } else {
                response.sendRedirect("police-login.jsp?message=Invalid credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect("police-login.jsp?message=Database Error.");

        }
    }
}
