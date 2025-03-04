import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.fraud.database.Dbconnection;

@WebServlet("/Report")

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
    	      
    	        response.sendRedirect("login.jsp?message=Please login to submit your Report.");
    	     
    	        return;
    	    }


        String no_orurl = request.getParameter("no_orurl");
        
        String date = request.getParameter("incidentDate");
        String description = request.getParameter("description");
   

        PreparedStatement stmt = null;

        try (Connection conn = Dbconnection.getConnection()) {
            
            String sql = "INSERT INTO reports (no_orurl, date, description, userID) VALUES (?, ?, ?,?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, no_orurl);
            stmt.setString(2, date);
            stmt.setString(3, description);
            stmt.setInt(4, userId); 

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                request.setAttribute("message", "Report submitted successfully.");
                request.setAttribute("no_orurl", no_orurl);
                request.setAttribute("incidentDate", date);
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
