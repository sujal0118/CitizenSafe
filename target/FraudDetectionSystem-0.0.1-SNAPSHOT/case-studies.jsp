<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cybercrime Case Studies</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        /* Header */
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

        /* Accordion */
        .accordion {
            background-color: white;
            color: #333;
            cursor: pointer;
            padding: 15px;
            width: 100%;
            border: none;
            text-align: left;
            outline: none;
            font-size: 18px;
            transition: 0.4s;
            border-radius: 5px;
            margin-bottom: 5px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        .accordion:hover {
            background-color: #ddd;
        }

        .accordion.active {
            background-color: #007bff;
            color: white;
        }

        .panel {
            padding: 15px;
            display: none;
            background-color: white;
            overflow: hidden;
            border-radius: 5px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 10px;
        }

        .panel p {
            margin: 0;
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

        .important {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="header">Famous Cybercrime Cases in India</div>

<div class="container">

    <!-- Case 1 -->
    <button class="accordion">1. Cosmos Bank Cyber Heist (2018)</button>
    <div class="panel">
        <p><strong>What Happened?</strong> Hackers infiltrated the servers of Pune-based Cosmos Bank and stole **₹94 crores** through fraudulent transactions.</p>
        <p><strong>How?</strong> Malware was injected into the bank’s **SWIFT system**, allowing attackers to approve fake transactions.</p>
        <p><strong>Recovery:</strong> The bank detected irregularities and reported the fraud immediately. Law enforcement agencies traced some transactions and arrested key suspects.</p>
        <p><strong>Lesson:</strong> Always monitor **real-time banking transactions** and use **multi-layered cybersecurity systems**.</p>
    </div>

    <!-- Case 2 -->
    <button class="accordion">2. RBI Fake Website Scam (2019)</button>
    <div class="panel">
        <p><strong>What Happened?</strong> Fraudsters created a **fake RBI website** that mimicked the original, tricking people into entering their banking details.</p>
        <p><strong>How?</strong> Victims received **phishing emails** directing them to the fake site, where their credentials were stolen.</p>
        <p><strong>Recovery:</strong> The Indian Cyber Cell shut down the website, but many victims lost money before reporting the fraud.</p>
        <p><strong>Lesson:</strong> Always verify **official URLs** and avoid clicking on links from unknown sources.</p>
    </div>

    <!-- Case 3 -->
    <button class="accordion">3. Justdial Data Leak (2020)</button>
    <div class="panel">
        <p><strong>What Happened?</strong> A security flaw in Justdial’s API exposed **over 100 million user records**, including names, mobile numbers, and addresses.</p>
        <p><strong>How?</strong> Weak API security allowed **unauthorized access to sensitive user data**.</p>
        <p><strong>Recovery:</strong> Justdial patched the security loophole after an ethical hacker reported it.</p>
        <p><strong>Lesson:</strong> Companies must **regularly test APIs for vulnerabilities** and encrypt sensitive data.</p>
    </div>

    <!-- Case 4 -->
    <button class="accordion">4. Jamtara Phishing Scams (Ongoing)</button>
    <div class="panel">
        <p><strong>What Happened?</strong> The town of **Jamtara, Jharkhand** became India’s cybercrime hub, with fraudsters tricking people into sharing OTPs and bank details.</p>
        <p><strong>How?</strong> Fraudsters posed as **bank officials**, convincing victims to disclose OTPs, leading to financial fraud.</p>
        <p><strong>Recovery:</strong> Multiple raids by police resulted in several arrests, but the scam continues.</p>
        <p><strong>Lesson:</strong> Never **share OTPs** with anyone, even if they claim to be from a bank.</p>
    </div>

    <!-- Case 5 -->
    <button class="accordion">5. Bengaluru Bitcoin Scam (2021)</button>
    <div class="panel">
        <p><strong>What Happened?</strong> A hacker stole **over ₹11 crore worth of Bitcoin** by breaching wallets.</p>
        <p><strong>How?</strong> The hacker used **SIM swapping** to gain access to cryptocurrency wallets.</p>
        <p><strong>Recovery:</strong> Authorities seized part of the stolen assets and arrested the hacker.</p>
        <p><strong>Lesson:</strong> Always use **multi-factor authentication (MFA)** for crypto wallets.</p>
    </div>

    <!-- Case 6 -->
    <button class="accordion">6. Paytm KYC Fraud (2022)</button>
    <div class="panel">
        <p><strong>What Happened?</strong> Fraudsters posed as **Paytm KYC agents** and convinced users to install remote access apps.</p>
        <p><strong>How?</strong> Using apps like **AnyDesk**, scammers controlled victims’ devices and stole money.</p>
        <p><strong>Recovery:</strong> Many banks flagged fraudulent transactions, but some victims suffered huge losses.</p>
        <p><strong>Lesson:</strong> Never install apps or share screen access with unknown people.</p>
    </div>

</div>
  <!-- Back to Guidance Page -->
        <div class="back-button">
            <a href="guidence.jsp">⬅ Back to Guidance</a>
        </div>

<script>
    // Accordion Functionality
    var acc = document.getElementsByClassName("accordion");
    for (var i = 0; i < acc.length; i++) {
        acc[i].addEventListener("click", function() {
            this.classList.toggle("active");
            var panel = this.nextElementSibling;
            if (panel.style.display === "block") {
                panel.style.display = "none";
            } else {
                panel.style.display = "block";
            }
        });
    }
</script>

</body>
</html>
