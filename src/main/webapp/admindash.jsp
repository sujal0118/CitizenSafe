<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || !"admin".equals(adminSession.getAttribute("user_role"))) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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

        .logout-btn {
            display: inline-block;
            padding: 10px 15px;
            background-color: #d9534f;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            position: absolute;
            top: 20px;
            right: 20px;
        }

        .logout-btn:hover {
            background-color: #c9302c;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: transform 0.2s;
            text-align: center;
        }

        .card:hover {
            transform: scale(1.05);
        }

        .card-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #1e40af;
        }

        .card-desc {
            font-size: 14px;
            color: #666;
        }

    </style>
</head>
<body>

    <a href="admin-logout" class="logout-btn">Logout</a>

    <div class="container">
        <h2>Admin Dashboard</h2>

        <div class="dashboard-grid">
            <div class="card" onclick="location.href='adminuserview.jsp'">
                <div class="card-title">View Users</div>
                <div class="card-desc">Manage users, reports, feedback, and complaints.</div>
            </div>

            <div class="card" onclick="location.href='visitorCount.jsp'">
                <div class="card-title">Website Statistics</div>
                <div class="card-desc">Track user and visitor count on the website.</div>
            </div>

            <div class="card" onclick="location.href='manageSEO.jsp'">
                <div class="card-title">SEO Management</div>
                <div class="card-desc">Manage SEO settings and website optimization.</div>
            </div>

            <div class="card" onclick="location.href='managePolice.jsp'">
                <div class="card-title">Manage Police</div>
                <div class="card-desc">Register and monitor police activities.</div>
            </div>

            <div class="card" onclick="location.href='downloadReports.jsp'">
                <div class="card-title">Download Reports</div>
                <div class="card-desc">Generate and download website reports.</div>
            </div>
        </div>
    </div>

</body>
</html>
