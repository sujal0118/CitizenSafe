<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fraud Detection System</title>
    <style>
        body {
            font-family: sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            overflow-x: hidden;
        }

        header {
    background-color: #0047AB;
    color: white;
    padding: 5px 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 0;
    z-index: 100;
    width: 100%;
    box-sizing: border-box;
    height: 50px; 
}

.logo {
    font-size: 1em; 
}

nav a {
    color: white;
    text-decoration: none;
    margin: 0 8px; 
    padding: 3px 6px; 
    border-radius: 3px;
    font-size: 0.9em; 
    transition: background-color 0.3s ease;
}

.menu-toggle {
    font-size: 1.2em; 
    padding: 5px;
    display: none;
}

.bar {
    width: 20px; 
    height: 2px; 
    margin: 3px auto; 
    background-color: white;
}


        .container {
            max-width: 960px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            flex: 1 0 auto;
            box-sizing: border-box;
            width: 100%;
        }

        .cta-section {
            display: flex;
            justify-content: center; 
            margin-top: 40px;
            flex-wrap: wrap;
            box-sizing: border-box;
            width: 100%;
            gap: 20px; 
        }

        .cta-box {
            border: 1px solid #ddd;
            padding: 20px;
            width: calc(33% - 40px); 
            box-sizing: border-box;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .cta-box:hover {
            transform: scale(1.05);
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
        }

        .cta-box h2 {
            font-size: 1.2em;
        }

        .cta-button {
            display: inline-block;
            margin: 20px auto;
            padding: 15px 30px;
            background-color: #00A36C;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 1em;
            transition: background-color 0.3s ease;
        }

        .cta-button:hover {
            background-color: #008055;
        }

        footer {
            text-align: center;
            padding: 5px 10px;
            font-size: 0.8em;
            background-color: #333;
            color: white;
            width: 100%;
            box-sizing: border-box;
        }

        @media (max-width: 768px) {
            nav {
                display: none;
                flex-direction: column;
                position: absolute;
                top: 60px;
                right: 0;
                background-color: #0047AB;
                width: 150px;
                box-shadow: -2px 2px 5px rgba(0, 0, 0, 0.2);
                border-radius: 5px;
                z-index: 100;
            }

            nav.active {
                display: flex;
            }

            nav a {
                margin: 4px 0;;
                padding: 8px;
                display: block;
                font-size: 1em;
                text-align: center;
                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            }
            nav a:last-child{
                border-bottom: none;
            }

            .menu-toggle {
            font-size: 1.3em;
                display: block;
            }
             .bar {
        width: 22px; 
    }

            .cta-box {
                width: 90%; 
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo"><h1>Fraud Detection System</h1></div>
        <div class="menu-toggle" id="mobile-menu">
            <div class="bar"></div>
            <div class="bar"></div>
            <div class="bar"></div>
        </div>
        <nav id="main-nav">
            <a href="index.jsp">Home</a>
            <a href="about.jsp">About Us</a>
            <a href="contact.jsp">Contact</a>
    

<%
    String user = (String) session.getAttribute("user");
    if (user != null) { 
%>
    <a href="dashboard.jsp">Dashboard</a>
    
<% } else { %>
    <a href="login.jsp">Login</a>
<% } %>
        </nav>
    </header>

    <div class="container">
    <%
     
        if (user != null) {
    %>
        <h2>Welcome, <%= user %>!</h2>
    <% } %>
        <h2>Stay Safe, Stay Informed</h2>
        <p>Your trusted platform for fraud prevention and reporting</p>

        <div class="cta-section">
            <div class="cta-box" onclick="location.href='reportfraud.jsp';">
                <h2>Report Fraud</h2>
                <p>Report fraudulent numbers and websites</p>
            </div>
            <div class="cta-box" onclick="location.href='reported_numbers_websites.jsp';">
                <h2>Check Database</h2>
                <p>View flagged fraud numbers and websites</p>
            </div>
            <div class="cta-box" onclick="location.href='complaint.jsp';">
                <h2>File Complaints</h2>
                <p>Submit fraud-related complaints</p>
            </div>
        </div>

        <a href="guidence.jsp" class="cta-button">Need Guidance? <br> Get expert advice on identifying and preventing fraud</a>
    </div>

    <footer>
        <p>&copy; 2025 Fraud Detection System. All rights reserved.</p>
    </footer>
    <script>
        const menuToggle = document.getElementById('mobile-menu');
        const nav = document.getElementById('main-nav');

        menuToggle.addEventListener('click', () => {
            nav.classList.toggle('active');
        });
    </script>
</body>
</html>