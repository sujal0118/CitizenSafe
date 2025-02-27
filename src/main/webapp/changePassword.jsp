<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, org.mindrot.jbcrypt.BCrypt, com.fraud.database.Dbconnection" %>

<%
    // Check if police officer is logged in
    String batchId = (String) session.getAttribute("batch_id");

    if (batchId == null) {
        response.sendRedirect("police-login.jsp");
        return;
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword.length() >= 8) { // ✅ Ensure password is at least 8 characters long
            if (newPassword.equals(confirmPassword)) {
                Connection con = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    con = Dbconnection.getConnection();

                    // Fetch the hashed password from the database
                    stmt = con.prepareStatement("SELECT password FROM police_officers WHERE batch_id = ?");
                    stmt.setString(1, batchId);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String storedHashedPassword = rs.getString("password");

                        // Verify the entered current password
                        if (BCrypt.checkpw(currentPassword, storedHashedPassword)) {
                            // Hash the new password using BCrypt
                            String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

                            // Update the password in the database
                            stmt = con.prepareStatement("UPDATE police_officers SET password = ? WHERE batch_id = ?");
                            stmt.setString(1, hashedNewPassword);
                            stmt.setString(2, batchId);
                            stmt.executeUpdate();

                            message = "Password changed successfully!";
                        } else {
                            message = "Incorrect current password!";
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    message = "An error occurred. Please try again.";
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                }
            } else {
                message = "New password and confirm password do not match!";
            }
        } else {
            message = "New password must be at least 8 characters long!";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { width: 400px; background: white; padding: 20px; border-radius: 8px; box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2); text-align: center; }
        h2 { color: #333; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; }
        .btn { background: #007bff; color: white; padding: 10px; border: none; border-radius: 5px; cursor: pointer; width: 100%; }
        .btn:hover { background: #0056b3; }
        .error { color: red; }
        .success { color: green; }
        
          .btn-primary {
            background-color: #007bff;
            color: white;
            display: block;
            width: 200px;
            text-align: center;
            padding: 10px;
            border-radius: 5px;
            text-decoration: none;
            margin: 20px auto 0;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Change Password</h2>
    
    <% if (!message.isEmpty()) { %>
        <p class="<%= message.equals("Password changed successfully!") ? "success" : "error" %>"><%= message %></p>
    <% } %>

    <form method="POST" onsubmit="return validatePassword();">
        <input type="password" id="currentPassword" name="currentPassword" placeholder="Current Password" required>
        <input type="password" id="newPassword" name="newPassword" placeholder="New Password (Min. 8 characters)" required>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm New Password" required>
        <button type="submit" class="btn">Change Password</button>
    </form>
    <a href="police.jsp" class="btn-primary">Back to Police Dashboard</a>
    
</div>


<script>
    function validatePassword() {
        let newPassword = document.getElementById("newPassword").value;
        let confirmPassword = document.getElementById("confirmPassword").value;

        if (newPassword.length < 8) {
            alert("New password must be at least 8 characters long!");
            return false;
        }

        if (newPassword !== confirmPassword) {
            alert("New password and confirm password do not match!");
            return false;
        }

        return true;
    }
</script>

</body>
</html>
