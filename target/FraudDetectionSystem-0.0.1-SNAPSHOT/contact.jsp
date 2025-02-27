<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    HttpSession userSession = request.getSession(false);
    Integer userId = (Integer) userSession.getAttribute("user_id");
    Integer policeId = (Integer) userSession.getAttribute("officer_id");

    if (userId == null && policeId == null) {
        response.sendRedirect("login.jsp"); // Redirect if not logged in
        return;
    }

    // Determine the role (User or Police)
    String role = (userId != null) ? "User" : "Police";
    
    // Determine the appropriate redirect page based on role
    String backPage = (userId != null) ? "index.jsp" : "police.jsp";

    // Variables for messages
    String successMessage = null;
    String errorMessage = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (subject != null && message != null && !subject.trim().isEmpty() && !message.trim().isEmpty()) {
            try (Connection con = com.fraud.database.Dbconnection.getConnection()) {
                String query;
                if (userId != null) {
                    query = "INSERT INTO user_feedback (user_id, subject, message) VALUES (?, ?, ?)";
                } else {
                    query = "INSERT INTO police_feedback (p_id, subject, message) VALUES (?, ?, ?)";
                }

                try (PreparedStatement stmt = con.prepareStatement(query)) {
                    if (userId != null) {
                        stmt.setInt(1, userId);
                    } else {
                        stmt.setInt(1, policeId);
                    }
                    stmt.setString(2, subject);
                    stmt.setString(3, message);

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        successMessage = "✅ Feedback submitted successfully!";
                    } else {
                        errorMessage = "❌ Failed to submit feedback.";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                errorMessage = "❌ Database error occurred.";
            }
        } else {
            errorMessage = "❌ Subject and message cannot be empty.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Feedback - Fraud Detection</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: #f0f2f5;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .contact-container {
            width: 100%;
            max-width: 450px;
            padding: 25px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        h2 {
            margin-bottom: 10px;
            color: #1f3347;
        }

        p {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border 0.3s ease-in-out;
        }

        input:focus, textarea:focus {
            border: 1px solid #1f3347;
            outline: none;
        }

        textarea {
            height: 120px;
            resize: none;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background: #1f3347;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
            transition: background 0.3s;
        }

        .submit-btn:hover {
            background: #2c4760;
        }

        .message {
            padding: 12px;
            margin-top: 10px;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .back-btn {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: 500;
            transition: background-color 0.2s;
            align-self: flex-start;
        }
        
        .back-btn:hover {
            background-color: #5a6268;
        }

        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }

    </style>
</head>
<body>
    <a href="<%= backPage %>" class="back-btn">← Back to Main Page</a>

    <div class="contact-container">
        <h2>Submit Feedback</h2>
        <p>Your feedback helps us improve our fraud detection services.</p>

        <% if (successMessage != null) { %>
            <div class="message success"><%= successMessage %></div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="message error"><%= errorMessage %></div>
        <% } %>

        <form action="contact.jsp" method="POST">
            <input type="hidden" name="role" value="<%= role %>">
            <input type="text" name="subject" placeholder="Enter Subject" required>
            <textarea name="message" placeholder="Write your message..." required></textarea>
            <button type="submit" class="submit-btn">Send Message</button>
        </form>
    </div>

</body>
</html>