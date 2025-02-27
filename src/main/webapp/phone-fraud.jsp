<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phone Fraud Awareness</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .section {
            margin-bottom: 20px;
            padding: 10px;
            border-left: 4px solid #007bff;
            background: #f1f1f1;
            border-radius: 5px;
        }
        h1, h2 {
            color: #007bff;
        }
        ul {
            padding-left: 20px;
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
    <div class="container">
        <h1>Phone Fraud Awareness</h1>

        <!-- What is Phone Fraud? -->
        <div class="section">
            <h2>What is Phone Fraud?</h2>
            <p>Phone fraud refers to scams conducted via phone calls, where fraudsters attempt to steal money or personal information by impersonating legitimate organizations.</p>
            <ul>
                <li><b>Spam Calls:</b> Unwanted sales or promotional calls.</li>
                <li><b>Robocalls:</b> Automated calls with pre-recorded messages, often scams.</li>
                <li><b>Fake Customer Service:</b> Scammers pretending to be bank representatives, telecom providers, or government officials.</li>
            </ul>
        </div>

        <!-- Signs of a Scam Call -->
        <div class="section">
            <h2>Signs of a Scam Call</h2>
            <p>Scammers often use these tactics to deceive victims:</p>
            <ul>
                <li>🔴 Pressure Tactics: Urging you to act immediately.</li>
                <li>🔴 Request for Personal Information: Asking for OTPs, PINs, or passwords.</li>
                <li>🔴 Caller ID Spoofing: Showing fake numbers to appear legitimate.</li>
                <li>🔴 Threats or Fake Offers: Claiming legal action, lottery wins, or discounts.</li>
            </ul>
        </div>

        <!-- Common Phone Scams -->
        <div class="section">
            <h2>Examples of Common Phone Scams</h2>
            <p>Scammers use various tricks to target unsuspecting individuals:</p>
            <ul>
                <li>⚠️ <b>Lottery or Prize Scams:</b> "Congratulations! You've won ₹10 Lakh! Pay a processing fee to claim it."</li>
                <li>⚠️ <b>Bank OTP Scams:</b> "Sir/Madam, we are from XYZ Bank. Please share your OTP to prevent account deactivation."</li>
                <li>⚠️ <b>Tax Fraud Calls:</b> "This is the Income Tax Department. You owe ₹50,000 in unpaid taxes. Pay now to avoid arrest."</li>
                <li>⚠️ <b>Fake Tech Support:</b> "Your computer has a virus! We can fix it if you install remote access software."</li>
                <li>⚠️ <b>Insurance And Loan Scams:</b> "Get a loan at 0% interest! Just share your Aadhaar and PAN details."</li>
            </ul>
        </div>

        <!-- How to Protect Yourself -->
        <div class="section">
            <h2>How to Protect Yourself?</h2>
            <ul>
                <li>✅ Use Caller ID Apps like Truecaller to identify fraud calls.</li>
                <li>✅ Never Share OTPs, CVV, or PINs with anyone over the phone.</li>
                <li>✅ Do Not Click on Unknown Links received via SMS or WhatsApp.</li>
                <li>✅ Register for DND (Do Not Disturb): Block unwanted marketing calls.</li>
                <li>✅ Verify Before Trusting: Call your bank or company directly if in doubt.</li>
            </ul>
        </div>

        <!-- What to Do if You Fall Victim? -->
        <div class="section">
            <h2>What to Do if You Fall Victim?</h2>
            <p>If you suspect a scam, take immediate action:</p>
            <ul>
                <li>📌 Report to TRAI (Telecom Regulatory Authority of India) via <b>1909</b> or <a href="https://www.trai.gov.in" target="_blank">TRAI website</a>.</li>
                <li>📌 File a complaint on Cybercrime Portal: <a href="https://www.cybercrime.gov.in" target="_blank">cybercrime.gov.in</a></li>
                <li>📌 Block the scam number using your phone settings.</li>
                <li>📌 Call your bank immediately if financial fraud has occurred.</li>
                <li>📌 Visit the nearest police station for serious cases.</li>
            </ul>
        </div>

        <!-- Important Helpline Numbers -->
        <div class="section">
            <h2>Important Helpline Numbers</h2>
            <ul>
                <li>📞 <b>Cyber Crime Helpline:</b> 1930</li>
                <li>📞 <b>TRAI Complaint (DND And Scam Calls):</b> 1909</li>
                <li>📞 <b>SBI Customer Care:</b> 1800 1234 / 1800 2100</li>
                <li>📞 <b>HDFC Bank:</b> 1800 202 6161</li>
                <li>📞 <b>ICICI Bank:</b> 1800 1080</li>
                <li>📞 <b>Axis Bank:</b> 1800 419 5555</li>
            </ul>
        </div>

        <!-- Back to Guidance Page -->
        <div class="back-button">
            <a href="guidence.jsp">⬅ Back to Guidance</a>
        </div>
    </div>
</body>
</html>
