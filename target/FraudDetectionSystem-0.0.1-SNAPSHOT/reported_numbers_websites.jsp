<%@page import="com.fraud.database.Dbconnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.*" %>

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
        .navbar {
            background-color: #0b3d6f;
            padding: 15px 20px;
            text-align: center;
            color: white;
            font-size: 22px;
            font-weight: bold;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .logo {
            display: flex;
            align-items: center;
            font-size: 1rem;
            margin-bottom: 10px;
        }
        .logo img {
            height: 30px;
            margin-right: 10px;
        }
        .container {
            max-width: 100%;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .back-btn {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: 500;
            display: inline-block;
        }
        .back-btn:hover {
            background-color: #5a6268;
        }
        .table-container {
            width: 100%;
            overflow-x: auto; /* Enables horizontal scrolling if needed */
            margin-top: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed; /* Prevents column resizing */
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eaeaea;
            word-wrap: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap; /* Prevents text from breaking */
        }
        th {
            background-color: #0b3d6f;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #e9ecef;
        }
        .verified-fraud {
            background-color: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.9em;
        }
        .not-verified {
            background-color: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.9em;
        }
        .table-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-top: 20px;
            margin-bottom: 5px;
            color: #0b3d6f;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            🛡️CitizenSafe
        </div>
        Reported Websites
    </div>

    <div class="container">
        <a href="index.jsp" class="back-btn">← Back to Main Page</a>
        
        <% 
        try (Connection conn = Dbconnection.getConnection()) { 
            String sql1 = "SELECT r.no_orurl, COUNT(*) as report_count, MAX(r.date) as latest_report, " +
                          "IFNULL(g.verified_fraud, 'Not Checked') as verified_fraud " +
                          "FROM reports r " +
                          "LEFT JOIN google_safe_browsing g ON r.no_orurl = g.url " +
                          "GROUP BY r.no_orurl ORDER BY report_count DESC";
            
            try (PreparedStatement stmt1 = conn.prepareStatement(sql1);
                 ResultSet rs1 = stmt1.executeQuery()) {
        %>

        <div class="table-title">Fraud Reports Summary</div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 40%;">Website URL</th>
                        <th style="width: 15%;">Reports</th>
                        <th style="width: 20%;">Latest Report</th>
                        <th style="width: 25%;">Verified Fraud</th>
                    </tr>
                </thead>
                <tbody>
                    <% while(rs1.next()) { %>
                    <tr>
                        <td><%= rs1.getString("no_orurl") %></td>
                        <td><%= rs1.getInt("report_count") %></td>
                        <td><%= rs1.getDate("latest_report") %></td>
                        <td>
                            <% if("Yes".equals(rs1.getString("verified_fraud"))) { %>
                                <span class="verified-fraud">Verified Fraud</span>
                            <% } else { %>
                                <span class="not-verified">Not Verified</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% 
            }
            String sql2 = "SELECT fraud_url_or_number, category, source, risk_level, added_on " +
                          "FROM fraud_data ORDER BY added_on DESC LIMIT 50";
            
            try (PreparedStatement stmt2 = conn.prepareStatement(sql2);
                 ResultSet rs2 = stmt2.executeQuery()) {
        %>

        <div class="table-title">PhishTank Data</div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 35%;">Website URL / Number</th>
                        <th style="width: 20%;">Category</th>
                        <th style="width: 15%;">Source</th>
                        <th style="width: 15%;">Risk Level</th>
                        <th style="width: 15%;">Submit Time</th>
                    </tr>
                </thead>
                <tbody>
                    <% while (rs2.next()) { %>
                    <tr>
                        <td><%= rs2.getString("fraud_url_or_number") %></td>
                        <td><%= rs2.getString("category") %></td>
                        <td><%= rs2.getString("source") %></td>
                        <td><%= rs2.getString("risk_level") %></td>
                        <td><%= rs2.getTimestamp("added_on") %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% 
            }
        } catch(Exception e) { 
        %>
        <div class="error-message">Error: <%= e.getMessage() %></div>
        <% } %>
    </div>
</body>
</html>
