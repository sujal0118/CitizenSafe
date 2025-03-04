<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.util.LinkedHashMap, java.util.ArrayList" %>
<%@ page import="com.fraud.database.Dbconnection" %>

<%
    String user = (String) session.getAttribute("user");
    String userEmail = (String) session.getAttribute("email");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (user == null || userEmail == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>
       <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        header, footer {
            background-color: #0047AB;
            color: white;
            padding: 15px;
            text-align: center;
        }
        .container {
            max-width: 990px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #0047AB;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .view-link {
            color: blue;
            text-decoration: underline;
        }
        .btn {
            display: inline-block;
            padding: 10px 15px;
            margin: 10px 5px;
            background-color: #0047AB;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .btn:hover {
            background-color: #003380;
        }
    </style>
</head>
<body>
    <header>
        <h1>User Dashboard</h1>
    </header>
    <div class="container">
        <h2>Welcome, <%= user %>!</h2>
        <p>Email: <%= userEmail %></p>
        <a href="index.jsp" class="btn">Back to Home</a>
        <a href="logout.jsp" class="btn">Logout</a>
    </div>

    <!-- Complaints Section -->
    <div class="container">
        <h3>Your Complaints</h3>
        <table>
            <tr>
                <th>Complaint ID</th>
                <th>Incident Date</th>
                <th>Description</th>
                <th>Nearest Police Station</th>
                <th>Status</th>
                <th>Evidence</th>
                <th>Case Report</th>
                

            </tr>

            <%
            class Complaint {
                int id;
                String incidentDate;
                String description;
                String nearestPoliceStation; 
                String status; 
                String caseReport;
                
                ArrayList<String> evidenceList = new ArrayList<>();

                public Complaint(int id, String incidentDate, String description , String nearestPoliceStation, String status,String caseReport) {
                    this.id = id;
                    this.incidentDate = incidentDate;
                    this.description = description;
                    this.nearestPoliceStation = nearestPoliceStation;
                    this.status = status;
                    this.caseReport = caseReport;
                }
            }

            LinkedHashMap<Integer, Complaint> complaintsMap = new LinkedHashMap<>();
            try (Connection conn = Dbconnection.getConnection();
            	     PreparedStatement ps = conn.prepareStatement(
            	    		 "SELECT c.idcomplaint, c.incident_date, c.description, c.nearest_police_station, c.status, e.evidence_id, e.name, c.case_report_path " +
            	    				 " FROM complaints c " +
            	    				 " LEFT JOIN evidence e ON c.idcomplaint = e.complaint_id " +
            	    				 " WHERE c.iduser = ? ORDER BY c.idcomplaint"
)) {


                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int complaintId = rs.getInt("idcomplaint");
                    String incidentDate = rs.getString("incident_date");
                    String description = rs.getString("description");
                    String policeStation = rs.getString("nearest_police_station");
                    String status = rs.getString("status");
                    String caseReport = rs.getString("case_report_path");


                    // Get or create complaint object
                   Complaint complaint = complaintsMap.getOrDefault(complaintId, new Complaint(complaintId, incidentDate, description, policeStation, status,caseReport));


                    // Add evidence if available
                    if (rs.getString("name") != null) {
                        String evidenceFile = rs.getString("name") + " (<a class='view-link' href='" + request.getContextPath() + "/downloadEvidence?evidence_id=" + rs.getInt("evidence_id") + "'>View</a>)";
                        complaint.evidenceList.add(evidenceFile);
                    }

                    complaintsMap.put(complaintId, complaint);
                }

                for (Complaint complaint : complaintsMap.values()) {
            %>
            <tr>
                <td><%= complaint.id %></td>
                <td><%= complaint.incidentDate %></td>
                <td><%= complaint.description %></td>
                <td><%= complaint.nearestPoliceStation %></td>
                <td><%= complaint.status %></td>
                <td><%= complaint.evidenceList.isEmpty() ? "No Evidence" : String.join(", ", complaint.evidenceList) %></td>
       <td>
        <% if ("Accepted".equalsIgnoreCase(complaint.status) || "Completed".equalsIgnoreCase(complaint.status)) { %>
            <a class="btn" href="<%= request.getContextPath() %>/downloadCaseReport?caseId=<%= complaint.id %>" target="_blank">View Case Report</a>
        <% } else { %>
            Not Available
        <% } %>
    </td>
      
            </tr>
            <% 
                }
            } catch (Exception e) { 
                e.printStackTrace(); // Debugging
                out.println("<tr><td colspan='4'>Error fetching data: " + e.getMessage() + "</td></tr>");
            }
            %>
        </table>
    </div>
      
    <!-- Reports Section -->
<div class="container">
    <h3>Your Reports</h3>
    <table>
        <tr>
            <th>Report ID</th>
            <th>Date</th>
            <th>Website URL / Phone Number</th>
            <th>Description</th>
        </tr>
        <%
            try (Connection conn = Dbconnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                    "SELECT idreports, date, no_orurl, description FROM reports WHERE userID = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("idreports") %></td>
            <td><%= rs.getDate("date") %></td>
            <td><%= rs.getString("no_orurl") %></td>
            <td><%= rs.getString("description") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='4' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</div>


    <footer>
        &copy; 2025 Fraud Detection System. All rights reserved.
    </footer>
</body>
</html>