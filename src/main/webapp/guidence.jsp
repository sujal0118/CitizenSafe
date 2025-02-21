<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fraud Prevention Guidance</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            font-size: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .back-button {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            font-size: 16px;
        }
        .back-button:hover {
            text-decoration: underline;
        }
        .content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .fraud-types {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .fraud-type {
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        .fraud-type:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .fraud-type h2 {
            color: #2c3e50;
            margin-top: 0;
            font-size: 20px;
        }
        .fraud-type p {
            color: #666;
            margin: 0;
        }
        .resources {
            margin-top: 40px;
        }
        .resources h2 {
            color: #2c3e50;
            font-size: 24px;
            margin-bottom: 20px;
        }
        .resource-item {
            display: flex;
            align-items: center;
            padding: 15px;
            background-color: #f5f6f7;
            margin-bottom: 10px;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
            transition: background-color 0.2s;
        }
        .resource-item:hover {
            background-color: #e9ecef;
        }
        .resource-icon {
            margin-right: 10px;
            width: 24px;
            height: 24px;
        }
    </style>
</head>
<body>
    <div class="header">
        <span>Fraud Prevention Guidance</span>
        <a href="index.jsp" class="back-button">
            ← Back to Main Page
        </a>
    </div>
    
    <div class="content">
       <div class="fraud-types">
    <div class="fraud-type" onclick="location.href='phone-fraud.jsp';">
        <h2>Phone Fraud</h2>
        <p>Learn to identify and prevent phone scams</p>
    </div>
    
    <div class="fraud-type" onclick="location.href='online-fraud.jsp';">
        <h2>Online Fraud</h2>
        <p>Protect yourself from online scams</p>
    </div>
    
    <div class="fraud-type" onclick="location.href='identity-theft.jsp';">
        <h2>Identity Theft</h2>
        <p>Safeguard your personal information</p>
    </div>
    
    <div class="fraud-type" onclick="location.href='bank-fraud.jsp';">
        <h2>Bank Fraud</h2>
        <p>Protect your financial accounts and transactions</p>
    </div>
</div>

        
        <div class="resources">
            <h2>Resources</h2>
            
            <a href="fraud-guide.jsp" class="resource-item">
               
                Fraud Prevention Guide
            </a>
            
            <a href="video-tutorials.jsp" class="resource-item">
                
                Video Tutorials
            </a>
            
            <a href="case-studies.jsp" class="resource-item">
                
                Case Studies
            </a>
        </div>
    </div>
</body>
</html>
