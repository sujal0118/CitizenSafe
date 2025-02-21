<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page import="com.fraud.database.Dbconnection" %>

<%
    // Check if police officer is logged in
   String officerId = (String) session.getAttribute("officer_id");

    if (officerId== null) {
        response.sendRedirect("police-login.jsp");
        return;
    }


%>
<!DOCTYPE html>
<html>
<head>
    <title>Police Case Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
        }
        .navbar {
            background-color: #007bff;
            color: white;
            padding: 15px;
            font-size: 18px;
        }
        .dashboard {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            margin: 20px;
        }
        .card {
            background: #fff;
            padding: 20px;
            margin: 10px;
            border-radius: 8px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 150px;
            cursor: pointer;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background: #007bff;
            color: white;
        }
        .btn-view {
            background: #28a745;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
        }
        canvas {
            max-width: 600px;
            margin: auto;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Police Case Dashboard</h2>
    </div>
    
    <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        int totalCases = 0, pendingCases = 0, acceptedCases = 0, rejectedCases = 0, closedCases = 0;

        try {
            con = Dbconnection.getConnection();
            if (con != null) {
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT COUNT(*) FROM complaints");
                if (rs.next()) { totalCases = rs.getInt(1); }
                rs = stmt.executeQuery("SELECT COUNT(*) FROM complaints WHERE status='Pending'");
                if (rs.next()) { pendingCases = rs.getInt(1); }
                rs = stmt.executeQuery("SELECT COUNT(*) FROM complaints WHERE status='Accepted'");
                if (rs.next()) { acceptedCases = rs.getInt(1); }
                rs = stmt.executeQuery("SELECT COUNT(*) FROM complaints WHERE status='Rejected'");
                if (rs.next()) { rejectedCases = rs.getInt(1); }
                rs = stmt.executeQuery("SELECT COUNT(*) FROM complaints WHERE status='Completed'");
                if (rs.next()) { closedCases = rs.getInt(1); }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

    <div class="dashboard">
        <div class="card" onclick="filterCases('all')">Total Cases: <%= totalCases %></div>
        <div class="card" onclick="filterCases('Pending')">Pending: <%= pendingCases %></div>
        <div class="card" onclick="filterCases('Accepted')">Accepted: <%= acceptedCases %></div>
        <div class="card" onclick="filterCases('Rejected')">Rejected: <%= rejectedCases %></div>
        <div class="card" onclick="filterCases('Completed')">Closed: <%= closedCases %></div>
    </div>

    <canvas id="caseChart"></canvas>
    
    <table border="1" id="casesTable">
        <tr>
            <th>Complaint ID</th>
            <th>User Name</th>
            <th>Contact</th>
            <th>Type</th>
            <th>Incident Date</th>
            <th>Status</th>
            <th>Police Station</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                con = Dbconnection.getConnection();
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT * FROM complaints");
                while (rs.next()) {
        %>
        <tr class="caseRow" data-status="<%= rs.getString("status") %>">
            <td><%= rs.getInt("idcomplaint") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("contact") %></td>
            <td><%= rs.getString("type") %></td>
            <td><%= rs.getDate("incident_date") %></td>
            <td><%= rs.getString("status") %></td>
            <td><%= rs.getString("nearest_police_station") %></td>
            <td>
                <a class="btn-view" href="viewCase.jsp?caseId=<%= rs.getInt("idcomplaint") %>">View</a>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </table>
    
    <script>
        function filterCases(status) {
            let rows = document.querySelectorAll(".caseRow");

            rows.forEach(row => {
                let caseStatus = row.getAttribute("data-status");
                if (status === "all" || caseStatus === status) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }

        const ctx = document.getElementById('caseChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Total', 'Pending', 'Accepted', 'Rejected', 'Closed'],
                datasets: [{
                    label: 'Case Status',
                    data: [<%= totalCases %>, <%= pendingCases %>, <%= acceptedCases %>, <%= rejectedCases %>, <%= closedCases %>],
                    backgroundColor: ['blue', 'orange', 'green', 'red', 'purple']
                }]
            }
        });
    </script>
</body>
</html>
