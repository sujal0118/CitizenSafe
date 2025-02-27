<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verify OTP</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .otp-container {
            width: 100%;
            max-width: 400px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            text-align: center;
        }

        .form-header h2 {
            color: #1e40af;
            font-size: 1.8rem;
            margin-bottom: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            font-size: 1rem;
            text-align: center;
        }

        .submit-button {
            width: 100%;
            padding: 0.75rem;
            background-color: #0d9488;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .submit-button:hover {
            background-color: #0f766e;
        }

        .back-link {
            text-align: center;
            margin-top: 1rem;
        }

        .back-link a {
            color: #0d9488;
            text-decoration: none;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="otp-container">
        <div class="form-header">
            <h2>Enter OTP</h2>
            <p>Please enter the OTP sent to your email.</p>
        </div>

        <form action="VerifyOtpServlet" method="POST">
            <div class="form-group">
                <label for="otp">Enter OTP:</label>
                <input type="number" id="otp" name="otp" required>
            </div>
            <button type="submit" class="submit-button">Verify</button>
        </form>
        
        <div class="back-link">
            <a href="forgot_password.jsp">Resend OTP</a>
        </div>
    </div>
</body>
</html>
