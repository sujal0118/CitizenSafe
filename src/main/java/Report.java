import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.fraud.database.Dbconnection;

@WebServlet("/Report")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file size
public class Report extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("reportfraud.jsp"); 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	  HttpSession session = request.getSession();
    	
    	 System.out.println("Session Attributes:");
    	    session.getAttributeNames().asIterator().forEachRemaining(attr -> 
    	        System.out.println(attr + ": " + session.getAttribute(attr))
    	    );

    	    // Check user_id in session
    	    int userId = 0;
    	    Object userIdObj = session.getAttribute("user_id");
    	    if (userIdObj != null) {
    	        try {
    	            userId = Integer.parseInt(userIdObj.toString()); // Convert String to int
    	        } catch (NumberFormatException e) {
    	            e.printStackTrace();
    	        }
    	    }

    	    if (userId == 0) {
    	        System.out.println("User ID is missing, redirecting to login...");
    	        response.sendRedirect("login.jsp"); 
    	        return;
    	    }


        String no_orurl = request.getParameter("no_orurl");
        String date = request.getParameter("date");
        String description = request.getParameter("description");
        Part filePart = request.getPart("evidence");

        PreparedStatement stmt = null;

        try (Connection conn = Dbconnection.getConnection()) {
            
            String sql = "INSERT INTO reports (no_orurl, date, description, evidence, userID) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, no_orurl);
            stmt.setString(2, date);
            stmt.setString(3, description);

            if (filePart != null && filePart.getSize() > 0) {
                InputStream fileContent = filePart.getInputStream();
                stmt.setBinaryStream(4, fileContent, (int) filePart.getSize());
            } else {
                stmt.setNull(4, java.sql.Types.BLOB);
            }

            stmt.setInt(5, userId); 

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                request.setAttribute("message", "Report submitted successfully.");
                request.setAttribute("no_orurl", no_orurl);
                request.setAttribute("date", date);
                request.setAttribute("description", description);
            } else {
                request.setAttribute("message", "Failed to submit report. Try again.");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        request.getRequestDispatcher("reportConfirmation.jsp").forward(request, response);
    }
}
