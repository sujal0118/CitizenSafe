<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fraud Guide - Stay Aware</title>
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
            background-color: #343a40;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 24px;
            font-weight: bold;
        }

        /* Container */
        .container {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            padding: 15px;
        }

        /* Sections */
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
            color: #007bff;
            font-weight: bold;
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

        /* Button */
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
    </style>
</head>
<body>

<div class="header">Fraud Prevention Guide</div>

<div class="container">

    <div class="section">
        <h2>Detailed Guide on Different Fraud Types</h2>
        <ul>
            <li><strong>Online Scams:</strong> Phishing emails, fake job offers, lottery scams.</li>
            <li><strong>Banking Frauds:</strong> Card skimming, fake UPI links, OTP frauds.</li>
            <li><strong>Investment Scams:</strong> Ponzi schemes, fake stock tips, crypto scams.</li>
            <li><strong>Identity Theft:</strong> Stolen PAN, Aadhaar, and personal data misuse.</li>
            <li><strong>Social Media Frauds:</strong> Fake profiles, hacked accounts, scam messages.</li>
        </ul>
    </div>

    <div class="section">
        <h2>Laws and Legal Protections in India</h2>
        <ul>
            <li><strong>IT Act, 2000:</strong> Covers cybercrimes and online frauds.</li>
            <li><strong>Indian Penal Code (IPC):</strong> Sections 419 and 420 deal with cheating.</li>
            <li><strong>RBI Guidelines:</strong> Protects users against banking frauds.</li>
            <li><strong>Consumer Protection Act, 2019:</strong> Safeguards against e-commerce scams.</li>
        </ul>
    </div>

    <div class="section">
        <h2>How to Report Fraud and Where to File Complaints</h2>
        <ul>
            <li>Report cyber fraud at: <a href="https://cybercrime.gov.in" target="_blank">Cybercrime Portal</a></li>
            <li>Bank fraud? Call your bank’s <strong>fraud department</strong> immediately.</li>
            <li>Investment scam? Lodge a complaint with <a href="https://www.sebi.gov.in" target="_blank">SEBI</a></li>
            <li>Consumer fraud? File a complaint on <a href="https://consumerhelpline.gov.in" target="_blank">National Consumer Helpline</a></li>
        </ul>
        <a href="complaint.jsp" target="_blank" class="btn-report">Report a Fraud</a>
    </div>

    <div class="section">
        <h2>Educational Resources on Cyber Safety</h2>
        <ul>
            <li><a href="https://cybercrime.gov.in/UploadMedia/CyberSafetyEng.pdf" target="_blank">Cyber Safety Handbook (English)</a></li>
            <li><a href="https://cybercrime.gov.in/UploadMedia/CyberSafetyHindi.pdf" target="_blank">Cyber Safety Handbook (Hindi)</a></li>
            <li><a href="https://cybercrime.gov.in/UploadMedia/TSWSW-HandbookforTacklingCyberCrimes.pdf" target="_blank">Handbook for Tackling Cyber Crimes</a></li>

        </ul>
    </div>
  <!-- Back to Guidance Page -->
        <div class="back-button">
            <a href="guidence.jsp">⬅ Back to Guidance</a>
        </div>
</div>

</body>
</html>
