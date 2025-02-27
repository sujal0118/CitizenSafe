<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page import="com.fraud.database.Dbconnection" %>

<%
    // Check if police officer is logged in

    Integer officerId = (Integer) session.getAttribute("officer_id"); // Correct way
    if (officerId == null) {
        response.sendRedirect("police-login.jsp");
        return;
    }



    // Retrieve case ID from request
    int caseId = Integer.parseInt(request.getParameter("caseId"));
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Case</title>
     <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            margin: 0;
            padding: 20px;
        }
        .container {
            width: 80%;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            text-align: left;
        }
        h1, h2, h3 {
            color: #0047AB;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background: #0047AB;
            color: white;
        }
        .btn {
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            color: white;
            text-align: center;
            display: inline-block;
            margin-top: 10px;
        }
        .btn-accept { background-color: green; }
        .btn-reject { background-color: red; }
        .btn-back { background-color: #007bff; text-decoration: none; padding: 10px; display: inline-block; }
        .btn-primary{background-color: green;}
        textarea {
            width: 100%;
            height: 80px;
            margin-top: 10px;
        }
        .view-link {
            color: blue;
            text-decoration: underline;
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
</head>
<body>
<a href="police.jsp" class="btn-primary">Back to Police Dashboard</a>
<header>
    <h1>Case Details</h1>
</header>

<div class="container">
    <h2>Case ID: <%= caseId %></h2>

    <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = Dbconnection.getConnection();
            pstmt = con.prepareStatement("SELECT * FROM complaints WHERE idcomplaint = ?");
            pstmt.setInt(1, caseId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
    %>

   <table>
    <tr><th>Complaint ID</th><td><%= rs.getInt("idcomplaint") %></td></tr>
    <tr><th>User Name</th><td><%= rs.getString("name") %></td></tr>
    <tr><th>Contact</th><td><%= rs.getString("contact") %></td></tr>
    <tr><th>Type</th><td><%= rs.getString("type") %></td></tr>
    <tr><th>Incident Date</th><td><%= rs.getDate("incident_date") %></td></tr>
    <tr><th>Description</th><td><%= rs.getString("description") %></td></tr>
    <tr><th>Status</th><td id="statusText"><%= rs.getString("status") %></td></tr>
    <tr><th>Police Station</th><td><%= rs.getString("nearest_police_station") %></td></tr>
</table>

    <h3>Evidence Files</h3>
    <table>
        <tr>
            <th>File Name</th>
            <th>Type</th>
            <th>View</th>
        </tr>
        <%
            // Fetch evidence files related to the case
           PreparedStatement pstmtEvidence = con.prepareStatement("SELECT evidence_id, name, file_type, path FROM evidence WHERE complaint_id = ?");
pstmtEvidence.setInt(1, caseId);
ResultSet rsEvidence = pstmtEvidence.executeQuery();

while (rsEvidence.next()) {
    int fileId = rsEvidence.getInt("evidence_id");
    String fileName = rsEvidence.getString("name");
    String fileType = rsEvidence.getString("file_type");
    String filePath = rsEvidence.getString("path");
%>
<tr>
    <td><%= fileName %></td>
    <td><%= fileType %></td>
    <td><a class="view-link" href="<%= request.getContextPath() %>/downloadEvidence?evidence_id=<%= fileId %>" target="_blank">View</a></td>
</tr>
<% } rsEvidence.close(); pstmtEvidence.close(); %>

    </table>

<h3>Provide Feedback</h3>
<form action="UpdateCase" method="post">
    <input type="hidden" name="caseId" value="<%= caseId %>">
    <textarea name="feedback" placeholder="Enter your feedback..." required></textarea>
    <br>

    <% 
        String caseStatus = rs.getString("status");
    if ("Accepted".equalsIgnoreCase(caseStatus) || "Completed".equalsIgnoreCase(caseStatus)) { 

    %>
        <!-- Show Case Report & Mark as Completed button if the case is Accepted -->
     <button class="btn btn-primary" onclick="window.open('<%= request.getContextPath() %>/downloadCaseReport?caseId=<%= caseId %>', '_blank')"> View Case Report</button>
        <button type="submit" name="status" value="Completed" class="btn btn-accept">Mark as Completed</button>
    <% } else if ("Rejected".equalsIgnoreCase(caseStatus)) { %>
        <!-- Show nothing if the case is Rejected -->
        <p style="color: red;"><b>This case has been rejected.</b></p>
    <% } else if ("Completed".equalsIgnoreCase(caseStatus)) { %>
        <!-- Show only Case Report if the case is Completed -->
        <a href="<%= request.getContextPath() %>/downloadCaseReport?caseId=<%= caseId %>" class="btn btn-primary" target="_blank">View Case Report</a>
        <p style="color: green;"><b>This case has been completed.</b></p>
    <% } else { %>
        <!-- Show Accept & Reject buttons if the case is still pending -->
        <button type="submit" name="status" value="Accepted" class="btn btn-accept">Accept Case</button>
        <button type="submit" name="status" value="Rejected" class="btn btn-reject">Reject Case</button>
    <% } %>
</form>


    <%
            } else {
                out.println("<p>Case not found.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error fetching case details: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</div>

<footer>
    &copy; 2025 Fraud Detection System. All rights reserved.
</footer>

</body>
</html>
