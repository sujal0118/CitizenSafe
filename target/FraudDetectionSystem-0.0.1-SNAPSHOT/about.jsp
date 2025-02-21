<!DOCTYPE html>
<html>
<head>
    <title>About Us - Fraud Detection Platform</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        
        .header {
            background-color: #1f3347;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .mission {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
            text-align: center;
        }
        
        .welcome-section {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #f5f5f5;
            border-radius: 8px;
        }
        
        .team-section {
            display: flex;
            justify-content: center;
            gap: 2rem;
            padding: 2rem;
            flex-wrap: wrap;
        }
        
        .team-member {
            text-align: center;
            width: 250px;
        }
        
        .team-member img {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 1rem;
        }
        
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #1f3347;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 1rem;
        }
        
        .back-button:hover {
            background-color: #2c4760;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>About Us</h1>
    </div>

    <a href="index.jsp" class="back-button">Back to Main Page</a>

    <div class="mission">
        <h2>Our Mission</h2>
        <p>Protecting citizens from fraud through awareness and prevention</p>
    </div>

    <div class="welcome-section">
        <h2>Welcome to our Fraud Detection and Prevention Platform!</h2>
        <p>We are a team of two passionate and dedicated developers, <strong>Sujal Jawalkar</strong> and <strong>Khushdill Gupta</strong>, working to create a safer digital space for everyone. As students with a shared interest in technology and cybersecurity, we embarked on this project to tackle the growing challenges of online fraud and cybercrime.</p>
        <p>Our mission is to empower users with tools to report and combat fraudulent activities, providing guidance and resources to safeguard their digital lives. With a focus on accessibility and innovation, our platform offers features like fraud reporting, complaint filing, and guidance on what to do after experiencing fraud.</p>
        <p>We believe in leveraging technology to solve real-world problems and aim to make our platform a reliable ally in the fight against cybercrime.</p>
    </div>

    <div class="team-section">
        <div class="team-member">
            <img src="/FraudDetectionSystem/src/main/webapp/pic.jpg" alt="Sujal Jawalkar">
            <h3>Sujal Jawalkar</h3>
            <p>Developer</p>
        </div>
        <div class="team-member">
            <img src="#" alt="Khushdill Gupta">
            <h3>Khushdill Gupta</h3>
            <p>Developer</p>
        </div>
    </div>
</body>
</html>