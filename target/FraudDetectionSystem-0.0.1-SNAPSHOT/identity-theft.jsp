<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Identity Theft Awareness</title>
    <style>
        /* General Page Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        /* Header Styling */
        .header {
            background-color: #007bff;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 24px;
            font-weight: bold;
        }

        /* Container for sections */
        .container {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            padding: 15px;
        }

        /* Section Styling */
        .section {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .section h2 {
            color: #dc3545;
            font-weight: bold;
        }

        .section ul {
            padding-left: 20px;
        }

        /* Important text highlights */
        .important {
            color: #28a745;
            font-weight: bold;
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
        /* Report button */
        .btn-report {
            display: block;
            width: 100%;
            text-align: center;
            background-color: #dc3545;
            color: white;
            padding: 12px;
            font-size: 18px;
            font-weight: bold;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 15px;
        }

        .btn-report:hover {
            background-color: #c82333;
        }

        /* Links */
        a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }
        
        
    </style>
</head>
<body>

<div class="header">Identity Theft Awareness</div>

<div class="container">

    <div class="section">
        <h2>What is Identity Theft?</h2>
        <p>Identity theft occurs when criminals steal personal information—such as <span class="important">Aadhaar details, PAN number, bank details, or login credentials</span>—to commit fraud. They may open bank accounts, apply for loans, or make purchases in the victim's name.</p>
    </div>

    <div class="section">
        <h2>How Do Criminals Steal Identities?</h2>
        <ul>
            <li><strong>Data Breaches:</strong> Hackers steal databases containing personal data from banks, e-commerce sites, or government portals.</li>
            <li><strong>Card Skimming:</strong> Fraudsters install devices on ATMs or POS machines to steal credit/debit card details.</li>
            <li><strong>Phishing:</strong> Fake emails or messages trick users into providing sensitive details.</li>
            <li><strong>Social Media Exploitation:</strong> Personal information shared publicly can be used for fraudulent purposes.</li>
        </ul>
    </div>

    <div class="section">
        <h2>Signs Your Identity is Stolen</h2>
        <ul>
            <li>Unfamiliar transactions in your bank account.</li>
            <li>Receiving OTPs or alerts for activities you didn’t initiate.</li>
            <li>Getting calls/emails about loans or purchases you never made.</li>
            <li>Being locked out of your social media or banking accounts.</li>
        </ul>
    </div>

    <div class="section">
        <h2>Ways to Protect Your Identity</h2>
        <ul>
            <li>Use <span class="important">strong and unique passwords</span>.</li>
            <li>Enable <span class="important">two-factor authentication (2FA)</span> for bank and email accounts.</li>
            <li>Avoid using <span class="important">public Wi-Fi</span> for financial transactions.</li>
            <li>Regularly monitor <span class="important">bank statements and credit scores</span>.</li>
            <li>Do not share <span class="important">OTPs or sensitive details</span> over calls or messages.</li>
        </ul>
    </div>

    <div class="section">
        <h2>What to Do if Your Identity is Stolen?</h2>
        <ul>
            <li><span class="important">Freeze your bank accounts</span> to prevent unauthorized transactions.</li>
            <li>Report the fraud to the cybercrime portal: <a href="https://cybercrime.gov.in" target="_blank">Cybercrime Portal</a></li>
            <li>Alert <span class="important">credit bureaus (CIBIL, Experian, Equifax)</span> to prevent fraudulent loans in your name.</li>
            <li>Change all your passwords and enable 2FA on all accounts.</li>
            <li>File a <span class="important">police report</span> to document the incident officially.</li>
        </ul>
        <a href="complaint.jsp" target="_blank" class="btn-report">Report Identity Theft</a>
    </div>
  <!-- Back to Guidance Page -->
        <div class="back-button">
            <a href="guidence.jsp">⬅ Back to Guidance</a>
        </div>
</div>

</body>
</html>
