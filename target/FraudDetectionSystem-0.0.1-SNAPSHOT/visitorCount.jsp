<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website Visitor Statistics</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f4f4f4;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }

        .container {
            max-width: 900px;
            width: 100%;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .chart-container {
            width: 100%;
            margin: 20px 0;
        }

        canvas {
            max-width: 100%;
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
    background-color:darkblue;
}
    </style>
</head>
<body>

    <div class="container">
        <h2>Website Visitor and Case Statistics</h2>

        <!-- Line Chart (User Growth) -->
        <div class="chart-container">
            <h3>User Growth Over Time</h3>
            <canvas id="lineChart"></canvas>
        </div>

        <!-- Bar Chart (Police vs. User Cases) -->
        <div class="chart-container">
            <h3>Police and User Case Count</h3>
            <canvas id="barChart"></canvas>
        </div>

        <!-- Pie Chart (Complaint Status Distribution) -->
        <div class="chart-container">
            <h3>Complaint Status Distribution</h3>
            <canvas id="pieChart"></canvas>
        </div>
        
       
    </div>
 <div><a href="admindash.jsp" class="btn btn-primary">Back to Dashboard</a></div>
 
    
     
      

    <script>
        // Fetch statistics from servlet
        fetch('VisitorStatsServlet')
            .then(response => response.json())
            .then(data => {
                // Ensure only whole numbers are used
                const userGrowth = data.userGrowth.map(Math.round);
                const userCases = Math.round(data.userCases);
                const policeCases = Math.round(data.policeCases);
                const pending = Math.round(data.pending);
                const accepted = Math.round(data.accepted);
                const rejected = Math.round(data.rejected);
                const completed = Math.round(data.completed);

                // Line Chart (User Growth)
                new Chart(document.getElementById("lineChart"), {
                    type: 'line',
                    data: {
                        labels: data.dates,  // X-axis: Dates
                        datasets: [{
                            label: 'User Growth',
                            data: userGrowth,  // Y-axis: Growth Numbers
                            borderColor: '#1e90ff',
                            fill: false
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true, // Ensure Y-axis starts from 0
                                ticks: {
                                    precision: 0  // No decimal values
                                }
                            }
                        }
                    }
                });

                // Bar Chart (Police vs. User )
                new Chart(document.getElementById("barChart"), {
                    type: 'bar',
                    data: {
                        labels: ["Users", "Police "],
                        datasets: [{
                            label: 'Total Cases',
                            data: [userCases, policeCases],  // Y-axis values
                            backgroundColor: ['#ff6384', '#36a2eb']
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true, // Ensure Y-axis starts from 0
                                ticks: {
                                    precision: 0  // No decimal values
                                }
                            }
                        }
                    }
                });

                // Pie Chart (Complaint Status Distribution)
                new Chart(document.getElementById("pieChart"), {
                    type: 'pie',
                    data: {
                        labels: ["Pending", "Accepted", "Rejected", "Completed"],
                        datasets: [{
                            data: [pending, accepted, rejected, completed],
                            backgroundColor: ['#f39c12', '#2ecc71', '#e74c3c', '#3498db']
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'bottom'  // Improve visibility
                            }
                        }
                    }
                });
            })
            .catch(error => console.error('Error fetching data:', error));
    </script>

</body>
</html>
