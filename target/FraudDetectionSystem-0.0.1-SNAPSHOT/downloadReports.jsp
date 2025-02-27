<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Download Reports</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .card {
            display: inline-block;
            width: 45%;
            padding: 15px;
            margin: 10px;
            background: #007bff;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }
        .card:hover {
            background: #0056b3;
        }
        select, button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            background: #28a745;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background: #218838;
        }
        
  .btn-primary {
    background-color: blue;
    color: white;
    display: inline-block;
    padding: 12px 20px;
    border-radius: 5px;
    font-size: 16px;
    text-decoration: none; /* Remove underline */
    text-align: center;
    margin-top: 20px;
    transition: background 0.3s ease-in-out;
}

.btn-primary:hover {
    background-color: darkblue;
}
    </style>
</head>
<body>
    <div class="container">
        <h2>Select Report Type</h2>
        
        <div class="card" onclick="selectReport('user')">User Reports</div>
        <div class="card" onclick="selectReport('police')">Police Reports</div>
        <div class="card" onclick="selectReport('all')">All Reports</div>
        
        <h3>Select Time Period</h3>
        <select id="timePeriod">
            <option value="daily">Daily</option>
            <option value="weekly">Weekly</option>
            <option value="monthly">Monthly</option>
            <option value="yearly">Yearly</option>
        </select>
        
        <button onclick="downloadReport()">Download Report</button>
       
    </div>
    <div> <a href="admindash.jsp" class="btn btn-primary">Back to Dashboard</a></div>

    <script>
        let selectedReport = '';

        function selectReport(reportType) {
            selectedReport = reportType;
            alert("Selected: " + reportType + " Reports");
        }
        
        function downloadReport() {
            if (!selectedReport) {
                alert("Please select a report type.");
                return;
            }
            let timePeriod = document.getElementById("timePeriod").value;
            window.location.href = "GenerateReportServlet?report=" + selectedReport + "&time=" + timePeriod;
        }

    </script>
</body>
</html>