<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Fraud</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            gap: 30px;
        }
        .header {
            background-color: #2d3748;
            color: white;
            padding: 15px 20px;
            margin: -20px -20px 20px -20px;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .main-content {
            flex: 1;
        }
        .side-content {
            width: 300px;
            flex-shrink: 0;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .submit-btn {
            background-color: #1dc9b7;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }
        .back-btn {
            background-color: #6c757d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
        }
        .back-btn:hover {
            background-color: #5a6268;
        }
        .tips-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
        }
        .tips-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .tips-list li {
            margin-bottom: 10px;
            position: relative;
            padding-left: 15px;
        }
        .tips-list li:before {
            content: "•";
            position: absolute;
            left: 0;
        }
        .warning {
            background-color: #fff2f2;
            color: #dc3545;
            padding: 15px;
            border-radius: 4px;
            margin-top: 20px;
        }
        h2 {
            font-size: 1.5em;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="header">
        <h1>Report Fraud Websites/Numbers</h1>
    </div>
    <% 
    if (session.getAttribute("user") == null) { 
        response.sendRedirect("login.jsp?error=Please login first to submit a report");
        return; 
    } 
%>
    <div class="container">
        <div class="main-content">
            <a href="index.jsp" class="back-btn">← Back to Main Page</a>
            <h2>Report Details</h2>
            <form action="Report" method="POST" enctype="multipart/form-data">

                <div class="form-group">
                    <label for="contactInfo">Phone Number/Website URL*</label>
                    <input type="text" name="no_orurl" id="no_orurl" 
                           class="form-control" 
                           placeholder="Enter phone number or website URL" required>
                </div>

                <div class="form-group">
                    <label for="incidentDate">Date of Incident*</label>
                    <input type="date" name="date" id="date" 
                           class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="description">Description of Fraud*</label>
                    <textarea name="description" id="description" 
                              class="form-control" rows="5"
                              placeholder="Provide detailed description of the fraudulent activity..." required></textarea>
                </div>

                <div class="form-group">
                    <label for="evidence">Upload Evidence (Optional)</label>
                    <input type="file" name="evidence" id="evidence" multiple
                           class="form-control" 
                           accept="image/*,.pdf,.doc,.docx">
                    <small class="form-text text-muted">
                        You can upload screenshots, recordings, or any other relevant documents
                    </small>
                </div>

                <button type="submit" class="submit-btn" onclick="return confirmSubmission()">Submit Report</button>
            </form>
        </div>

        <div class="side-content">
            <div class="tips-section">
                <h2>Reporting Tips</h2>
                <ul class="tips-list">
                    <li>Provide accurate details</li>
                    <li>Include specific dates</li>
                    <li>Describe the incident</li>
                    <li>Upload evidence if any</li>
                </ul>
                
                <div class="warning">
                    <strong>Important:</strong>
                    <p>False reporting may lead to legal consequences</p>
                </div>
            </div>
        </div>
    </div>

    <%-- Processing form submission --%>
    <%
        if (request.getMethod().equals("POST")) {
           
            String contactInfo = request.getParameter("contactInfo");
            String incidentDate = request.getParameter("incidentDate");
            String description = request.getParameter("description");
            
            
        }
    %>
    <script>
    function confirmSubmission() {
        return confirm("You cannot change the details after submitting. Do you want to proceed?");
    }
</script>
</body>
</html>