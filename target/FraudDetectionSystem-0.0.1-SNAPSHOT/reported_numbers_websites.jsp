<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reported Websites List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .report-count {
            font-weight: bold;
            color: #e74c3c;
        }
        .status {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.9em;
        }
        .status-pending {
            background-color: #f1c40f;
            color: #000;
        }
        .status-reviewed {
            background-color: #2ecc71;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Reported Websites</h1>
        
        <%
            // Database connection parameters
            String url = "jdbc:mysql://localhost:3306/websitefraud";
            String username = "root";
            String password = "root@Asj0118";
            
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, username, password);
                
                // Query to get reported websites with count
               String sql = "SELECT r.no_orurl, " +
                              "COUNT(*) as report_count, " +
                             "MAX(r.date) as latest_report " + 
                               "FROM reports r " +
                                "GROUP BY r.no_orurl " + 
                                 "ORDER BY report_count DESC";

                           
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
        %>
        
        <a href="index.jsp" class="back-btn">← Back to Main Page</a>
                <table>
                    <thead>
                        <tr>
                            <th>Website URL</th>
                            <th>Number of Reports</th>
                            <th>Latest Report Date</th>
                           
                    </thead>
                    <tbody>
                        <% while(rs.next()) { %>
                            <tr>
                                <td><%= rs.getString("no_orurl") %></td>
                                <td class="report-count"><%= rs.getInt("report_count") %></td>
                                <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("latest_report")) %></td>
                               
                                
                            </tr>
                        <% } %>
                    </tbody>
                </table>
        <%
                rs.close();
                stmt.close();
                conn.close();
            } catch(Exception e) {
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>