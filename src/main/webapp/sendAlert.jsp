<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>

<%
    // Check if police officer is logged in
    String batchId = (String) session.getAttribute("batch_id");
    if (batchId == null) {
        response.sendRedirect("police-login.jsp");
        return;
    }

    String message = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Send Alert</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { width: 400px; background: white; padding: 20px; border-radius: 8px; box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2); text-align: center; }
        h2 { color: #333; }
        input, textarea { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; }
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
    <script>
        function confirmSend() {
            return confirm("Are you sure you want to send this alert to all users?");
        }
    </script>
</head>
<body>

<div class="container">
    <h2>Send Alert</h2>

    <% if (message != null) { %>
        <p class="success"><%= message %></p>
    <% } %>

    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } %>
 
    <form method="POST" action="SendAlertServlet">
        <input type="text" name="headline" placeholder="Alert Headline" required>
        <textarea name="alertMessage" placeholder="Enter alert details..." required></textarea>
        <button type="submit" class="btn" onclick="return confirmSend()">Send Alert</button>
    </form>
</div>

<a href="police.jsp" class="btn-primary">Back to Police Dashboard</a>

</body>
</html>
