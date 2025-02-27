<%@ page import="java.sql.*, com.fraud.database.Dbconnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            width: 90%;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            vertical-align: top;
        }
        th {
            background-color: #333;
            color: white;
        }
        .btn {
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-danger {
            background-color: red;
            color: white;
        }
        .btn-danger:hover {
            background-color: darkred;
        }
        .btn-primary {
            background-color: blue;
            color: white;
            display: block;
            width: 200px;
            text-align: center;
            margin: 20px auto 0;
        }
        .btn-primary:hover {
            background-color: darkblue;
        }
        .feedback-box {
            background: #f9f9f9;
            padding: 8px;
            margin: 5px 0;
            border-radius: 5px;
            font-size: 14px;
        }
        .no-feedback {
            color: #888;
            font-size: 14px;
        }
    </style>
</head>

<script>
    function deleteuser(userId) {
        if (confirm('Are you sure you want to delete this user?')) {
            fetch('deleteuser.jsp?id=' + userId, { method: 'GET' })
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === "success") {
                        location.reload();
                    } else {
                        alert("Failed to delete user: " + data);
                    }
                })
                .catch(error => console.error('Fetch Error:', error));
        }
    }
</script>

<body>
    <div class="container">
        <h2>User Management</h2>
        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Reports</th>
                    <th>Complaints</th>
                    <th>Feedback</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Connection con = Dbconnection.getConnection();
                        String query = "SELECT u.iduser, u.name, u.email, " +
                                       "(SELECT COUNT(*) FROM reports r WHERE r.userID = u.iduser) AS report_count, " +
                                       "(SELECT COUNT(*) FROM complaints c WHERE c.iduser = u.iduser) AS complaint_count " +
                                       "FROM user u";
                        PreparedStatement stmt = con.prepareStatement(query);
                        ResultSet rs = stmt.executeQuery();
                        
                        while (rs.next()) {
                            int userId = rs.getInt("iduser");
                %>
                <tr>
                    <td><%= userId %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getInt("report_count") %></td>
                    <td><%= rs.getInt("complaint_count") %></td>
                    <td>
                        <%
                            String feedbackQuery = "SELECT subject, message, created_at FROM user_feedback WHERE user_id = ?";
                            PreparedStatement feedbackStmt = con.prepareStatement(feedbackQuery);
                            feedbackStmt.setInt(1, userId);
                            ResultSet feedbackRs = feedbackStmt.executeQuery();
                            
                            boolean hasFeedback = false;
                            while (feedbackRs.next()) {
                                hasFeedback = true;
                        %>
                        <div class="feedback-box">
                            <strong><%= feedbackRs.getString("subject") %></strong><br>
                            <%= feedbackRs.getString("message") %><br>
                            <small><%= feedbackRs.getTimestamp("created_at") %></small>
                        </div>
                        <% 
                            }
                            if (!hasFeedback) {
                                out.println("<span class='no-feedback'>No Feedback Available</span>");
                            }
                            feedbackStmt.close();
                        %>
                    </td>
                    <td>
                        <button class="btn btn-danger" onclick="deleteuser(<%= userId %>)">Delete</button>
                    </td>
                </tr>
                <% 
                        }
                        Dbconnection.closeConnection(con);
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        <a href="admindash.jsp" class="btn btn-primary">Back to Dashboard</a>
    </div>
</body>
</html>
