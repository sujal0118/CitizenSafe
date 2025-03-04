<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Fraud</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            color: #333;
        }
        
        /* Navbar/Header */
        .navbar {
            background-color: #0b3d6f;
            padding: 10px 15px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        
        .logo {
            color: white;
            font-size: 20px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
        }
        
        /* Page Header */
        .page-header {
            background-color: #0b3d6f;
            color: white;
            padding: 20px 10px;
            text-align: center;
            margin-bottom: 15px;
        }
        
        .page-header h1 {
            margin: 0;
            font-size: 32px;
            margin-bottom: 8px;
        }
        
        /* Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            gap: 30px;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        /* Side Content */
        .side-content {
            width: 300px;
            flex-shrink: 0;
        }
        
        /* Form Elements */
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 5px;
            color: #4a5568;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            background-color: #f8f9fa;
            box-sizing: border-box;
            font-size: 16px;
        }
        
        /* Buttons */
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        
        .submit-btn {
            background-color: #0b3d6f;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        
        .submit-btn:hover {
            background-color: #0a2f55;
        }
        
        .back-btn {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        
        .back-btn:hover {
            background-color: #5a6268;
        }
        
        /* Section Titles */
        .section-title {
            color: #0b3d6f;
            margin-bottom: 20px;
            font-size: 20px;
            border-bottom: 2px solid #eaeaea;
            padding-bottom: 10px;
        }
        
        h2 {
            font-size: 1.5em;
            margin-bottom: 20px;
            color: #0b3d6f;
        }
        
        /* Tips Section */
        .tips-section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .tips-section h2 {
            background-color: #0b3d6f;
            color: white;
            padding: 15px 20px;
            margin: 0;
            font-size: 18px;
            text-align: center;
        }
        
        .tips-list {
            list-style: none;
            padding: 20px;
            margin: 0;
        }
        
        .tips-list li {
            margin-bottom: 10px;
            position: relative;
            padding-left: 20px;
        }
        
        .tips-list li:before {
            content: "•";
            position: absolute;
            left: 0;
            color: #0b3d6f;
            font-weight: bold;
        }
        
        /* Warning Box */
        .warning {
            background-color: #fff2f2;
            color: #dc3545;
            padding: 15px;
            border-radius: 4px;
            margin: 20px;
        }
        
        /* Small Text */
        .form-text {
            font-size: 0.9em;
            color: #6c757d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <span>🛡️</span>
            CitizenSafe
        </div>
    </div>
    
    <div class="page-header">
        <h1>Report Fraud Websites/Numbers</h1>
        <p>Help others by reporting fraudulent websites or phone numbers</p>
    </div>
    
    <% 
    if (session.getAttribute("user") == null) { 
        response.sendRedirect("login.jsp?message=Please login first to submit a report");
        return; 
    } 
    %>
    
    <div class="container">
        <div class="main-content">
            <a href="index.jsp" class="back-btn">← Back to Main Page</a>
            <h2 class="section-title">Report Details</h2>
            
            <form action="Report" method="POST">
                <div class="form-group">
                    <label for="no_orurl" class="form-label">Phone Number/Website URL*</label>
                    <input type="text" name="no_orurl" id="no_orurl" 
                           class="form-control" 
                           placeholder="Enter phone number or website URL" required>
                           
                </div>

              <div class="form-group">
    <label class="form-label">Date of Incident*</label>
    <input type="date" name="incidentDate" class="form-control" id="incidentDate" required>
</div>

                <div class="form-group">
                    <label for="description" class="form-label">Description of Fraud*</label>
                    <textarea name="description" id="description" 
                              class="form-control" rows="5"
                              placeholder="Provide detailed description of the fraudulent activity..." required></textarea>
                </div>

               

                <button type="submit" class="submit-btn" onclick="return confirmSubmission()">Submit Report</button>
            </form>
        </div>

        <div class="side-content">
            <div class="tips-section">
                <h2>Reporting Tips</h2>
                <ul class="tips-list">
                    <li>Provide accurate details about the website or phone number</li>
                    <li>Include specific dates when the fraud occurred</li>
                    <li>Describe the incident in detail</li>
                    <li>Be honest and objective in your description</li>
                </ul>
                
                <div class="warning">
                    <strong>Important:</strong>
                    <p>False reporting may lead to legal consequences. Please ensure all information provided is accurate to the best of your knowledge.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmSubmission() {
            return confirm("You cannot change the details after submitting. Do you want to proceed?");
        }
        var today = new Date().toISOString().split('T')[0];
        document.getElementById("incidentDate").setAttribute("max", today);
    </script>
</body>
</html>