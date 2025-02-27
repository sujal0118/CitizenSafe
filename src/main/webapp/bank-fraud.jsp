<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Fraud Awareness</title>
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
        .dropdown {
            margin-bottom: 20px;
        }
        .dropdown button {
            width: 100%;
            padding: 10px;
            background: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 18px;
            text-align: left;
        }
        .dropdown-content {
            display: none;
            padding: 10px;
            background: #f1f1f1;
            border-left: 4px solid #007bff;
        }
        .show {
            display: block;
        }
        

    </style>
    <script>
        function toggleDropdown(id) {
            var content = document.getElementById(id);
            content.classList.toggle("show");
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Bank Fraud Awareness</h1>

        <!-- UPI Frauds -->
        <div class="dropdown">
            <button onclick="toggleDropdown('upi-fraud')">UPI Frauds ⬇</button>
            <div id="upi-fraud" class="dropdown-content">
                <ul>
                    <li>Fake UPI payment links</li>
                    <li>QR code scams</li>
                    <li>Fraudulent cashback offers</li>
                    <li>Fake customer care calls asking for UPI PIN</li>
                </ul>
                <h3>Example:</h3>
                <p>Rahul received a WhatsApp message claiming he won a cashback. When he clicked the link, his bank account was emptied.</p>
            </div>
        </div>

        <!-- Card Frauds -->
        <div class="dropdown">
            <button onclick="toggleDropdown('card-fraud')">Card Frauds ⬇</button>
            <div id="card-fraud" class="dropdown-content">
                <ul>
                    <li>ATM skimming</li>
                    <li>Fake customer service calls asking for OTP/CVV</li>
                    <li>Cloned debit/credit cards</li>
                    <li>Unusual transactions from foreign locations</li>
                </ul>
                <h3>Example:</h3>
                <p>Shyam’s credit card was used for unauthorized purchases abroad. He reported it and received a refund.</p>
            </div>
        </div>

        <!-- How to Stay Safe -->
        <div class="dropdown">
            <button onclick="toggleDropdown('safety')">How to Stay Safe? ⬇</button>
            <div id="safety" class="dropdown-content">
                <ul>
                    <li>Never share OTP, PIN, or CVV</li>
                    <li>Use only official banking apps and websites</li>
                    <li>Enable transaction alerts for all bank activities</li>
                    <li>Regularly update passwords and enable two-factor authentication</li>
                    <li>Be cautious of unknown callers claiming to be from the bank</li>
                </ul>
            </div>
        </div>

        <!-- What to Do If You Lose Money? -->
        <div class="dropdown">
            <button onclick="toggleDropdown('lose-money')">What to Do If You Lose Money? ⬇</button>
            <div id="lose-money" class="dropdown-content">
                <ul>
                    <li>Block your debit/credit card immediately via mobile banking</li>
                    <li>Call your bank’s customer care helpline and report the fraud</li>
                    <li>File a complaint with RBI’s Ombudsman if not resolved</li>
                    <li>Report UPI fraud on NPCI’s Help Portal</li>
                    <li>Raise a dispute with Google Pay, PhonePe, Paytm, etc.</li>
                    <li>Visit the nearest police station to file a cybercrime complaint</li>
                </ul>
            </div>
        </div>

        <!-- Customer Care Numbers -->
        <div class="dropdown">
            <button onclick="toggleDropdown('customer-care')">Bank Customer Care Numbers ⬇</button>
            <div id="customer-care" class="dropdown-content">
                <ul>
                    <li><strong>SBI:</strong> 1800 1234 / 1800 2100</li>
                    <li><strong>HDFC Bank:</strong> 1800 202 6161</li>
                    <li><strong>ICICI Bank:</strong> 1800 1080</li>
                    <li><strong>Axis Bank:</strong> 1800 419 5555</li>
                    <li><strong>Kotak Mahindra Bank:</strong> 1860 266 2666</li>
                    <li><strong>Punjab National Bank:</strong> 1800 180 2222</li>
                    <li><strong>Google Pay Help:</strong> 1800 419 0157</li>
                    <li><strong>PhonePe Help:</strong> 080 6872 7374</li>
                    <li><strong>Paytm Help:</strong> 0120 4456 456</li>
                </ul>
                <p><b>Note:</b> If fraud occurs, immediately call your bank’s customer care and report the issue.</p>
            </div>
        </div>
 </div>
 
   <!-- Back to Guidance Page -->
        <div class="back-button">
            <a href="guidence.jsp">⬅ Back to Guidance</a>
        </div>
</body>
</html>
