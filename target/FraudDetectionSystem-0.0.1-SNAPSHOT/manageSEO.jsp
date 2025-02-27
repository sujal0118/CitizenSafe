<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.fraud.database.Dbconnection" %>

<%
    // Admin Authentication Check (Fixed session key)
    String adminUsername = (String) session.getAttribute("admin_username");
    if (adminUsername == null) {
        response.sendRedirect("admin-login.jsp"); // Redirect if not logged in
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage SEO Settings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            padding: 20px;
        }
        .container {
            width: 50%;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        input, textarea {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            padding: 10px 15px;
            border: none;
            background: #28a745;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
        }
        button:hover {
            background: #218838;
        }
        
.btn-primary {
    background-color: blue;
    color: white;
    display: inline-block;
    padding: 12px 20px;
    border-radius: 5px;
    font-size: 16px;
    text-decoration: none; /* Remove underline */
    text-align: center;
    margin-top: 20px;
    transition: background 0.3s ease-in-out;
}

.btn-primary:hover {
    background-color:darkblue;
}
    </style>
</head>
<body>

    <div class="container">
        <h2>Manage SEO Settings</h2>
        <p>Welcome, <b><%= adminUsername %></b> 
        <%
            String title = "", description = "", keywords = "";
            Connection con = null;
            try {
                con = Dbconnection.getConnection();
                String query = "SELECT title, description, keywords FROM seo_settings WHERE id = 1";
                PreparedStatement stmt = con.prepareStatement(query);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    title = rs.getString("title");
                    description = rs.getString("description");
                    keywords = rs.getString("keywords");
                }
                rs.close();
                stmt.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (con != null) con.close();
            }
        %>

        <form method="post">
            <label>Website Title:</label><br>
            <input type="text" name="title" value="<%= title %>" required><br>

            <label>Meta Description:</label><br>
            <textarea name="description" required><%= description %></textarea><br>

            <label>Meta Keywords:</label><br>
            <input type="text" name="keywords" value="<%= keywords %>" required><br>

            <button type="submit">Update SEO Settings</button>
        </form>
        <div> <a href="admindash.jsp" class="btn btn-primary">Back to Dashboard</a></div>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String newTitle = request.getParameter("title");
                String newDescription = request.getParameter("description");
                String newKeywords = request.getParameter("keywords");

                if (newTitle != null && newDescription != null && newKeywords != null) {
                    try {
                        con = Dbconnection.getConnection();
                        String updateQuery = "UPDATE seo_settings SET title=?, description=?, keywords=? WHERE id=1";
                        PreparedStatement updateStmt = con.prepareStatement(updateQuery);
                        updateStmt.setString(1, newTitle);
                        updateStmt.setString(2, newDescription);
                        updateStmt.setString(3, newKeywords);
                        int rowsUpdated = updateStmt.executeUpdate();
                        updateStmt.close();
                        if (rowsUpdated > 0) {
                            out.println("<p style='color:green;'>SEO settings updated successfully!</p>");
                        } else {
                            out.println("<p style='color:red;'>Failed to update settings!</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (con != null) con.close();
                    }
                }
            }
        %>

    </div>

</body>
</html>
