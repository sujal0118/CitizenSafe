<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Online Fraud Awareness</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            max-width: 900px;
            margin: 20px auto;
            background: white;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #0056b3;
            margin-bottom: 20px;
        }
        .section {
            background: #ffffff;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            border-left: 5px solid #0056b3;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }
        .section h3 {
            color: #0056b3;
            margin-bottom: 10px;
        }
        .section ul {
            margin: 0;
            padding-left: 20px;
        }
        .footer {
            text-align: center;
            background: #0056b3;
            color: white;
            padding: 10px;
            margin-top: 20px;
            border-radius: 0 0 8px 8px;
        }
        a {
            color: #0056b3;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        
                .back-button {
            display: block;
            text-align: center;
            margin-top: 20px;
        }
        .back-button a {
            text-decoration: none;
            color: white;
            background-color: #007bff;
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
        }
        .back-button a:hover {
            background-color: #0056b3;
        }
        /* Responsive Design */
        @media (max-width: 600px) {
            .container {
                width: 95%;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Online Fraud Awareness</h2>

    <div class="section">
        <h3>Common Types of Online Fraud</h3>
        <ul>
            <li><strong>Phishing:</strong> Fake emails or websites that steal personal information.</li>
            <li><strong>Fake Shopping Websites:</strong> Fraudulent e-commerce sites that scam buyers.</li>
            <li><strong>Job Scams:</strong> Fake recruiters asking for registration fees.</li>
            <li><strong>Investment Fraud:</strong> Ponzi schemes promising high returns.</li>
        </ul>
    </div>

    <div class="section">
        <h3>How Scammers Trick People?</h3>
        <ul>
            <li><strong>Fake Websites:</strong> Websites that mimic real brands to steal data.</li>
            <li><strong>Social Engineering:</strong> Creating urgency to manipulate victims.</li>
            <li><strong>Malware Links:</strong> Links that install spyware and steal data.</li>
        </ul>
    </div>

    <div class="section">
        <h3>Examples of Real Scams</h3>
        <ul>
            <li><strong>Fake Courier Messages:</strong> SMS claiming your package is pending with fake payment links.</li>
            <li><strong>PayTM/KYC Fraud:</strong> Fraudsters posing as PayTM support to steal your data.</li>
        </ul>
    </div>

    <div class="section">
        <h3>How to Protect Yourself?</h3>
        <ul>
            <li><strong>Check Website Legitimacy:</strong> Always look for HTTPS and verify URLs.</li>
            <li><strong>Enable Two-Factor Authentication:</strong> Adds extra security to your accounts.</li>
            <li><strong>Beware of Unrealistic Offers:</strong> If it's too good to be true, it’s likely a scam.</li>
            <li><strong>Keep Software Updated:</strong> Use antivirus and update software regularly.</li>
        </ul>
    </div>

    <div class="section">
        <h3>Steps to Take If Scammed?</h3>
        <ul>
            <li><strong>Change Passwords Immediately:</strong> Secure your affected accounts.</li>
            <li><strong>Report to Cybercrime:</strong> Visit <a href="https://www.cybercrime.gov.in" target="_blank">Cybercrime Portal</a> or call 1930.</li>
            <li><strong>Contact Your Bank:</strong> Freeze your account if banking details were stolen.</li>
            <li><strong>Scan for Malware:</strong> Run a security scan if you clicked on suspicious links.</li>
        </ul>
    </div>
    
     <div class="back-button">
            <a href="guidence.jsp">⬅ Back to Guidance</a>
        </div>
</div>

<div class="footer">
    &copy; 2025 Fraud Awareness | Stay Safe Online
</div>

</body>
</html>