<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, com.fraud.database.Dbconnection" %>

<%
    // Ensure police officer is logged in
    String batchId = (String) session.getAttribute("batch_id");
    if (batchId == null) {
        response.sendRedirect("police-login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String name = "", email = "", city = "", policeStation = "";
    int totalCases = 0, pendingCases = 0, acceptedCases = 0, rejectedCases = 0, closedCases = 0;

    try {
        con = Dbconnection.getConnection();

        // Fetch police officer details using batch_id
        stmt = con.prepareStatement("SELECT p_id, name, email, city, police_station FROM police_officers WHERE batch_id = ?");
        stmt.setString(1, batchId);
        rs = stmt.executeQuery();

        int officerId = -1; // Placeholder for police ID
        if (rs.next()) {
            officerId = rs.getInt("p_id");
            name = rs.getString("name");
            email = rs.getString("email");
            city = rs.getString("city");
            policeStation = rs.getString("police_station");
            
        }
        rs.close();
        stmt.close();

        // Store police ID in session for complaint filtering
        session.setAttribute("officer_id", officerId);
        session.setAttribute("police_station", policeStation);
        		

        // Fetch case statistics (all complaints)
        stmt = con.prepareStatement("SELECT COUNT(*) FROM complaints");
        rs = stmt.executeQuery();
        if (rs.next()) totalCases = rs.getInt(1);
        rs.close();
        stmt.close();

        stmt = con.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status = 'Pending'");
        rs = stmt.executeQuery();
        if (rs.next()) pendingCases = rs.getInt(1);
        rs.close();
        stmt.close();

        stmt = con.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status = 'Accepted'");
        rs = stmt.executeQuery();
        if (rs.next()) acceptedCases = rs.getInt(1);
        rs.close();
        stmt.close();

        stmt = con.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status = 'Rejected'");
        rs = stmt.executeQuery();
        if (rs.next()) rejectedCases = rs.getInt(1);
        rs.close();
        stmt.close();

        stmt = con.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status = 'Completed'");
        rs = stmt.executeQuery();
        if (rs.next()) closedCases = rs.getInt(1);
        rs.close();
        stmt.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (con != null) con.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Police Case Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;  }
        .container { display: flex; height: 100vh; flex-direction: row;}
.sidebar { 
    width: 180px; /* Fixed width for sidebar */
    height: 94vh; /* Full height */
    background: #2c3e50; 
    color: white; 
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    text-wrap:wrap;
    overflow-y: hidden;
}

        .sidebar h2 { font-size: 20px; margin-bottom: 15px; border-bottom: 1px solid white; padding-bottom: 10px; }
        .sidebar p { font-size: 14px; margin: 5px 0; }
        .sidebar .menu a { display: block; text-decoration: none; color: white; padding: 10px; background: #34495e; border-radius: 5px; margin: 5px 0; text-align: center; }
        .sidebar .menu a:hover { background: #1abc9c; }
        .main-content { flex-grow: 1; padding: 20px;  overflow-y: auto; }
        .dashboard { display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; }
        .card { background: #fff; padding: 15px; border-radius: 8px; box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2); text-align: center; width: 140px; cursor: pointer; font-weight: bold; }
        .card:hover { background-color: #e0e0e0; }
        .case-table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
        .case-table th, .case-table td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        .case-table th { background: #007bff; color: white; }
        .btn-view { background: #28a745; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; }
        canvas { max-width: 600px; margin: auto; }
    </style>
</head>
<body>

    <div class="container">

        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Officer Details</h2>
            <p><strong>Name:</strong> <%= name %></p>
            <p><strong>Batch ID:</strong> <%= batchId %></p>
            <p><strong>Email:</strong> <%= email %></p>
            <p><strong>City:</strong> <%= city %></p>
            <p><strong>Police Station:</strong> <%= policeStation %></p>

            <div class="menu">
                <a href="changePassword.jsp">Change Password</a>
                <a href="contact.jsp">Give Feedback</a>
                 <a href="sendAlert.jsp">Send Alert</a>
                <a href="logout.jsp" style="background: #e74c3c;">Logout</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h2>Police Case Dashboard</h2>

           
               <div class="dashboard">
        <div class="card" onclick="filterCases('all')">Total Cases: <%= totalCases %></div>
        <div class="card" onclick="filterCases('Pending')">Pending: <%= pendingCases %></div>
        <div class="card" onclick="filterCases('Accepted')">Accepted: <%= acceptedCases %></div>
        <div class="card" onclick="filterCases('Rejected')">Rejected: <%= rejectedCases %></div>
        <div class="card" onclick="filterCases('Completed')">Closed: <%= closedCases %></div>
    </div>
            

            <canvas id="caseChart"></canvas>

            <!-- Case Table -->
            <table class="case-table">
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
    con = Dbconnection.getConnection();
    String officerPoliceStation = (String) session.getAttribute("police_station");

    stmt = con.prepareStatement("SELECT * FROM complaints WHERE nearest_police_station = ?");
    stmt.setString(1, officerPoliceStation);
    rs = stmt.executeQuery();

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
    <td><a class="btn-view" href="viewCase.jsp?caseId=<%= rs.getInt("idcomplaint") %>">View</a></td>
</tr>

                <%
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                %>
            </table>
        </div>
    </div>

    <script>
    new Chart(document.getElementById('caseChart').getContext('2d'), {
        type: 'bar',
        data: { 
            labels: ['Total', 'Pending', 'Accepted', 'Rejected', 'Closed'], 
            datasets: [{ 
                label: 'Case Status', // Add label to fix "undefined" issue
                data: [<%= totalCases %>, <%= pendingCases %>, <%= acceptedCases %>, <%= rejectedCases %>, <%= closedCases %>], 
                backgroundColor: ['blue', 'orange', 'green', 'red', 'purple'] 
            }] 
        },
        options: {  
            plugins: {
                legend: {
                    display: false  
                }
            }
        }
    });


        function filterCases(status) {
            let rows = document.querySelectorAll(".caseRow");

            rows.forEach(row => {
                let caseStatus = row.getAttribute("data-status").trim();
                if (status === "all" || caseStatus.toLowerCase() === status.toLowerCase()) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>

</body>
</html>
