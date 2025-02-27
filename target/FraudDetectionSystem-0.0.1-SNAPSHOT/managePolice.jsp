<%@ page import="java.sql.*, com.fraud.database.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Police Officers</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f1f1;
            margin: 0;
            padding: 20px;
        }

        .container {
            width: 90%;
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 15px;
        }

        .form-container {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn-submit {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background-color: #218838;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 5px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            vertical-align: top;
        }

        th {
            background-color: #343a40;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        tr:hover {
            background-color: #e9ecef;
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

        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

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
        function deletePolice(policeId) {
            if (confirm('Are you sure you want to delete this officer?')) {
                fetch('deletePolice.jsp?id=' + policeId, { method: 'GET' })
                    .then(response => response.text())
                    .then(data => {
                        if (data.trim() === "success") {
                            location.reload();
                        } else {
                            alert("Failed to delete officer: " + data);
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Register New Police Officer</h2>

        <%-- Success/Error Messages --%>
        <% if (request.getParameter("success") != null) { %>
            <p style="color: green; text-align: center;">Police officer registered successfully!</p>
        <% } else if (request.getParameter("error") != null) { %>
            <p style="color: red; text-align: center;">Error: <%= request.getParameter("error") %></p>
        <% } %>

       
    <form action="RegisterPoliceServlet" method="post">
        <label>Name:</label>
        <input type="text" name="name" required>

        <label>Batch ID:</label>
        <input type="text" name="batch_id" required>

        <label>Password:</label>
        <input type="password" name="password" required>

        <label>Police Station:</label>
        <select name="police_station" class="form-control" required>
            <option value="">Select Police Station ▼</option>
            <option value="Shivajinagar Police Station">Shivajinagar Police Station</option>
            <option value="Bund Garden Police Station">Bund Garden Police Station</option>
            <option value="Deccan Gymkhana Police Station">Deccan Gymkhana Police Station</option>
            <option value="Kothrud Police Station">Kothrud Police Station</option>
            <option value="Khadki Police Station">Khadki Police Station</option>
            <option value="Hadapsar Police Station">Hadapsar Police Station</option>
            <option value="Swargate Police Station">Swargate Police Station</option>
            <option value="Wanowrie Police Station">Wanowrie Police Station</option>
            <option value="Yerwada Police Station">Yerwada Police Station</option>
            <option value="Chaturshringi Police Station">Chaturshringi Police Station</option>
            <option value="Warje Malwadi Police Station">Warje Malwadi Police Station</option>
            <option value="Sinhagad Road Police Station">Sinhagad Road Police Station</option>
            <option value="Pimpri Police Station">Pimpri Police Station</option>
            <option value="Chinchwad Police Station">Chinchwad Police Station</option>
        </select>

        <label>City:</label>
        <input type="text" name="city" required>
        
        <label>Email:</label>
<input type="email" name="email" required>

        <button type="submit" class="btn-submit">Register</button>
    </form>
</div>


        <h2>Registered Police Officers</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Batch ID</th>
                    <th>Police Station</th>
                    <th>City</th>
                    <th>Solved Cases</th>
                    <th>Ongoing Cases</th>
                    <th>Feedback</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Connection con = Dbconnection.getConnection();
                        String query = "SELECT p.*, " +
                                       "(SELECT COUNT(*) FROM complaints WHERE p_id = p.p_id AND status = 'Completed') AS solved_cases, " +
                                       "(SELECT COUNT(*) FROM complaints WHERE p_id = p.p_id AND status = 'Accepted') AS ongoing_cases " +
                                       "FROM police_officers p";
                        PreparedStatement stmt = con.prepareStatement(query);
                        ResultSet rs = stmt.executeQuery();
                        
                        while (rs.next()) {
                            int policeId = rs.getInt("p_id");
                %>
                <tr>
                    <td><%= policeId %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("batch_id") %></td>
                    <td><%= rs.getString("police_station") %></td>
                    <td><%= rs.getString("city") %></td>
                    <td><%= rs.getInt("solved_cases") %></td>
                    <td><%= rs.getInt("ongoing_cases") %></td>
                    <td>
                        <%
                            String feedbackQuery = "SELECT subject, message, created_at FROM police_feedback WHERE p_id = ?";
                            PreparedStatement feedbackStmt = con.prepareStatement(feedbackQuery);
                            feedbackStmt.setInt(1, policeId);
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
                        <button class="btn-danger" onclick="deletePolice(<%= policeId %>)">Delete</button>
                    </td>
                </tr>
                <% 
                        }
                        Dbconnection.closeConnection(con);
                    } catch (Exception e) {
                        out.println("<tr><td colspan='9'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        <div>
        <a href="viewPoliceCases.jsp" class="btn-primary">View Cases</a>
        <a href="admindash.jsp" class="btn-primary">Back to Dashboard</a>
    </div>
</body>
</html>
