<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Complaint Submission Status</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 50px;
        }
        .container {
            width: 50%;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 2px 2px 12px rgba(0, 0, 0, 0.2);
            text-align: left;
        }
        .success {
            color: green;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
        }
        .error {
            color: red;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        .details p {
            margin: 5px 0;
        }
        button {
            margin: 10px;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .back-btn { background-color: #007bff; color: white; }
        .retry-btn { background-color: #28a745; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <% String status = (String) request.getAttribute("status"); %>
        <% if ("success".equals(status)) { %>
            <p class="success">Complaint Submitted Successfully!</p>
            <div class="details">
                <p><strong>Complaint ID:</strong> <%= request.getAttribute("complaintId") %></p>
                <p><strong>Full Name:</strong> <%= request.getAttribute("fullName") %></p>
                <p><strong>Contact Number:</strong> <%= request.getAttribute("contactNumber") %></p>
                <p><strong>Fraud Type:</strong> <%= request.getAttribute("fraudType") %></p>
                <p><strong>Incident Date:</strong> <%= request.getAttribute("incidentDate") %></p>
                <p><strong>Description:</strong> <%= request.getAttribute("description") %></p>
                <p><strong>Nearest Police Station:</strong> ${nearestPoliceStation}</p>
                
            </div>

            <p><strong>Uploaded Evidence Files:</strong></p>
            <ul>
                <% 
                    Object filesObj = request.getAttribute("evidenceFiles");
                    if (filesObj instanceof String[]) {
                        String[] files = (String[]) filesObj;
                        if (files.length > 0) {
                            for (String file : files) { %>
                                <li><%= file %></li>
                            <% }
                        } else { %>
                            <li>No files uploaded.</li>
                        <% }
                    } else { %>
                        <li>No files uploaded.</li>
                    <% }
                %>
            </ul>

            <p><strong>Recorded Audio:</strong> 
                <% 
                    String audioFile = (String) request.getAttribute("audioFile");
                    if (audioFile != null && !audioFile.isEmpty()) { %>
                        <%= audioFile %>
                    <% } else { %>
                        No Audio Recorded.
                    <% } %>
            </p>
        <% } else { %>
            <p class="error">Submission Failed!</p>
            <p>Error Details: <%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <button class="back-btn" onclick="window.location.href='dashboard.jsp'">Go to Dashboard</button>
        <button class="retry-btn" onclick="window.location.href='complaint_form.jsp'">Submit Another Complaint</button>
    </div>
</body>
</html>
