<%@ page import="java.sql.*" %>
<%@ page import="com.fraud.database.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  
    String userRole = (String) session.getAttribute("user_role");
    Integer policeId = (Integer) session.getAttribute("police_id");

    if (userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String filterStatus = request.getParameter("status");
    if (filterStatus == null || filterStatus.isEmpty()) {
        filterStatus = "All";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Cases</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { width: 80%; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); }
        h2 { text-align: center; color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #333; color: white; }
        .btn { padding: 8px 12px; border: none; cursor: pointer; border-radius: 5px; text-decoration: none; }
        .btn-warning { background-color: orange; color: white; }
        .btn-warning:hover { background-color: darkorange; }
        .btn-success { background-color: green; color: white; }
        .btn-success:hover { background-color: darkgreen; }
        .btn-primary { background-color: blue; color: white; }
        .btn-primary:hover { background-color: darkblue; }
        .filter { margin-bottom: 15px; }
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
        <h2>View Cases</h2>

        <!-- Status Filter Dropdown -->
        <form method="GET" action="viewPoliceCases.jsp" class="filter">
            <label for="status">Filter by Status:</label>
            <select name="status" onchange="this.form.submit()">
                <option value="All" <%= "All".equals(filterStatus) ? "selected" : "" %>>All</option>
                <option value="Pending" <%= "Pending".equals(filterStatus) ? "selected" : "" %>>Pending</option>
                <option value="Accepted" <%= "Accepted".equals(filterStatus) ? "selected" : "" %>>Accepted</option>
                <option value="Rejected" <%= "Rejected".equals(filterStatus) ? "selected" : "" %>>Rejected</option>
                <option value="Completed" <%= "Completed".equals(filterStatus) ? "selected" : "" %>>Completed</option>
            </select>
        </form>

        <table>
            <thead>
                <tr>
                    <th>Complaint ID</th>
                    <th>User Name</th>
                    <th>Contact</th>
                    <th>Type</th>
                    <th>Incident Date</th>
                    <th>Description</th>
                    <th>Status</th>
                    <% if (!"admin".equals(userRole)) { %> <th>Actions</th> <% } %>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection con = Dbconnection.getConnection();
                        String query = "SELECT * FROM complaints";
                        
                        if (!"All".equals(filterStatus)) {
                            query += " WHERE status=?";
                            if (!"admin".equals(userRole)) {
                                query += " AND police_id=?";
                            }
                        } else if (!"admin".equals(userRole)) {
                            query += " WHERE police_id=?";
                        }

                        PreparedStatement stmt = con.prepareStatement(query);

                        if (!"All".equals(filterStatus)) {
                            stmt.setString(1, filterStatus);
                            if (!"admin".equals(userRole)) {
                                stmt.setInt(2, policeId);
                            }
                        } else if (!"admin".equals(userRole)) {
                            stmt.setInt(1, policeId);
                        }

                        ResultSet rs = stmt.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("idcomplaint") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("contact") %></td>
                    <td><%= rs.getString("type") %></td>
                    <td><%= rs.getDate("incident_date") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getString("status") %></td>
                    <% if (!"admin".equals(userRole)) { %>
                    <td>
                        <% if (!rs.getString("status").equals("Completed")) { %>
                            <button class="btn btn-warning" onclick="updateStatus(<%= rs.getInt("idcomplaint") %>, 'Accepted')">Accept</button>
                            <button class="btn btn-primary" onclick="updateStatus(<%= rs.getInt("idcomplaint") %>, 'Rejected')">Reject</button>
                            <button class="btn btn-success" onclick="updateStatus(<%= rs.getInt("idcomplaint") %>, 'Completed')">Mark as Completed</button>
                        <% } else { %>
                            <span class="btn btn-primary">Completed</span>
                        <% } %>
                    </td>
                    <% } %>
                </tr>
                <%
                        }
                        Dbconnection.closeConnection(con);
                    } catch (Exception e) {
                        out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    
    <a href="managePolice.jsp" class="btn-primary">Back to Manage Police</a>

    <% if (!"admin".equals(userRole)) { %>
    <script>
        function updateStatus(complaintId, newStatus) {
            if (confirm("Are you sure you want to mark this case as " + newStatus + "?")) {
                fetch('updateComplaintStatus.jsp?id=' + complaintId + '&status=' + newStatus, { method: 'GET' })
                    .then(response => response.text())
                    .then(data => {
                        if (data.trim() === "success") {
                            location.reload();
                        } else {
                            alert("Failed to update status: " + data);
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        }
    </script>
    <% } %>
</body>
</html>
