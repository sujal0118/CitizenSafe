<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .message {
            font-size: 20px;
            color: green;
            margin-bottom: 20px;
        }
        .error {
            color: red;
        }
        .details {
            text-align: left;
            margin-top: 20px;
        }
        .details p {
            font-size: 16px;
            margin: 5px 0;
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Report Status</h2>
        <p class="message">${message}</p>

        <div class="details">
            <h3>Report Details:</h3>
            <p><strong>Fraud No or URL:</strong> ${no_orurl}</p>
            <p><strong>Date of Incident:</strong> ${incidentDate}</p>
            <p><strong>Description:</strong> ${description}</p>
        </div>

        <p><a href="index.jsp" class="back-btn">Back to Home</a></p>
    </div>
</body>
</html>
