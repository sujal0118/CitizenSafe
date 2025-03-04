<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Video Tutorials</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #343a40;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 24px;
            font-weight: bold;
        }
        .container {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            padding: 15px;
        }
        .video-section {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .video-section h2 {
            color: #dc3545;
            font-weight: bold;
        }
        iframe {
            width: 100%;
            height: 315px;
            border: none;
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

<div class="header">Video Tutorials</div>

<div class="container">
    <div class="video-section">
        <h2>Fraud Prevention Tips</h2>
        <iframe src="https://www.youtube.com/embed/3MC0wVM7DxE" ></iframe>

    </div>
    <div class="video-section">
        <h2>बैंक फ्रॉड से कैसे बचे ? | How to Stay Safe from Bank Fraud</h2>
        <iframe src="https://www.youtube.com/embed/T5h-pMsScjE?si=nepko58FM34hZNi4" ></iframe>
    </div>
    <div class="video-section">
        <h2>Protect Your Smartphone - Best Tips For 100% Security And Privacy </h2>
        <iframe src="https://www.youtube.com/embed/PXJ3NxUoaLg?si=gDv4Gv10hM8HZrLU" ></iframe>
    </div>
    <div class="video-section">
        <h2>Best Identity Theft Protection REVEALED: Watch Before You Buy (2025 Guide)</h2>
        <iframe src="https://www.youtube.com/embed/XODyBI_ekvA?si=c0DvjpQtqXUgzd0y"  ></iframe>
    </div>
    <div class="video-section">
        <h2>Google One Monitor the Dark Web Feature | Data Leak On Dark Web | Find Your Data breach or not?</h2>
        <iframe src="https://www.youtube.com/embed/wVxeU7xqYN0?si=k7jJamM2JeLBJYk8" ></iframe>
    </div>
    
        <!-- Back to Guidance Page -->
    <div class="back-button">
        <a href="guidence.jsp">⬅ Back to Guidance</a>
    </div>
</div>
  

<script>
    document.querySelectorAll("iframe").forEach(frame => {
        frame.setAttribute("allowfullscreen", "");
    });
</script>

</body>
</html>
