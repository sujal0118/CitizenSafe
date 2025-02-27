<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reported Websites List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            color: #333;
        }
        
        /* Navbar/Header */
        .navbar {
            background-color: #0b3d6f;
            padding: 15px 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        
        .logo {
            color: white;
            font-size: 20px;
            font-weight: bold;
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .navbar h1 {
            color: white;
            margin: 0;
            padding: 0;
            font-size: 22px;
            border-bottom: none;
        }
        
        /* Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Back Button */
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
        }
        
        .back-btn:hover {
            background-color: #5a6268;
        }
        
        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eaeaea;
        }
        
        th {
            background-color: #0b3d6f;
            color: white;
            font-weight: 500;
        }
        
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        tr:hover {
            background-color: #e9ecef;
        }
        
        /* Report Count */
        .report-count {
            font-weight: bold;
            color: #dc3545;
        }
        
        /* Status Indicators */
        .status {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.9em;
            display: inline-block;
        }
        
        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }
        
        .status-reviewed {
            background-color: #28a745;
            color: white;
        }
        
        /* Error Message */
        .error-message {
            color: #dc3545;
            font-size: 0.9em;
            margin-top: 15px;
            padding: 10px;
            background-color: #f8d7da;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <span>🛡️</span>
            CitizenSafe
        </div>
        <h1>Reported Websites</h1>
    </div>
    
    <div class="container">
        <a href="index.jsp" class="back-btn">← Back to Main Page</a>
        
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
        
        <table>
            <thead>
                <tr>
                    <th>Website URL</th>
                    <th>Number of Reports</th>
                    <th>Latest Report Date</th>
                </tr>
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
        %>
        <div class="error-message">
            Error: <%= e.getMessage() %>
        </div>
        <%
        }
        %>
    </div>
</body>
</html>