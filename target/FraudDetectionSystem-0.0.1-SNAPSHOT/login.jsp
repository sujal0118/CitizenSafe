<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Login and Registration</title>
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

        .auth-container {
            width: 100%;
            max-width: 1000px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            display: flex;
            overflow: hidden;
        }

        .auth-form {
            flex: 2;
            padding: 2rem;
        }

        .benefits-sidebar {
            flex: 1;
            background-color: #f3f4f6;
            padding: 2rem;
        }

        .tabs {
            display: flex;
            border-bottom: 2px solid #e5e7eb;
            margin-bottom: 2rem;
        }

        .tab {
            padding: 1rem 2rem;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            color: #6b7280;
            transition: all 0.3s;
        }

        .tab.active {
            color: #0d9488;
            border-bottom-color: #0d9488;
        }

        .tab-content {
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .tab-content.active {
            display: block;
            opacity: 1;
        }

        .form-header {
            margin-bottom: 2rem;
        }

        .form-header h1 {
            color: #1e40af;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
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
        }

        .show-password-container {
            display: flex;
            align-items: center;
            margin-top: 0.5rem;
        }

        .show-password-container input[type="checkbox"] {
            margin-right: 8px;
        }

        .show-password-container label {
            font-size: 0.9rem;
            color: #374151;
        }

        .submit-button {
            width: 100%;
            padding: 0.75rem;
            margin:10px;
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

        .login-options {
            text-align: center;
            margin-top: 1rem;
        }

        .login-options a {
            color: #0d9488;
            text-decoration: none;
            margin: 0 10px;
        }

        .login-options a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .auth-container {
                flex-direction: column;
            }

            .benefits-sidebar {
                order: -1;
            }
        }
        .modal {
        display: none; /* Initially hidden */
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent background */
        z-index: 1000;
        align-items: center;
        justify-content: center;
    }

    .modal-content {
        background-color: #fff;
        padding: 1.5rem 2rem;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        max-width: 400px;
        width: 90%;
    }

    .modal-content p {
        font-size: 1rem;
        margin-bottom: 1.5rem;
        color: #374151;
    }

    .modal-button {
        background-color: #0d9488;
        color: white;
        border: none;
        padding: 0.75rem 1.5rem;
        border-radius: 4px;
        cursor: pointer;
        font-size: 1rem;
    }

    .modal-button:hover {
        background-color: #0f766e;
    }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-form">
            <div class="tabs">
                <div class="tab active" data-tab="login">Login</div>
                <div class="tab" data-tab="register">Register</div>
            </div>

            <!-- Login Form -->
            <div id="login" class="tab-content active">
                <div class="form-header">
                <%  String errorMessage = request.getParameter("errormessage");
                        if (errorMessage != null && !errorMessage.isEmpty()) {  %>
                           <p style="color: red;"><%= errorMessage %></p><% } %>
                 
                    <h1>User Login</h1>
                    <p>Welcome back! Please login to your account</p>
                </div>
                <form action="user-login" method="POST">
                    <div class="form-group">
                        <label for="loginEmail">Email</label>
                        <input type="email" id="loginEmail" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="loginPassword">Password</label>
                        <input type="password" id="loginPassword" name="password" required>
                    </div>
                    <div class="show-password-container">
                        <input type="checkbox" id="showLoginPassword" onclick="toggleLoginPasswordVisibility()">
                        <label for="showLoginPassword">Show Password</label>
                    </div>
                    <div style="text-align: right; margin-top: -10px; margin-bottom: 15px;">
                        <a href="forgot-password.jsp" style="color: #0d9488; text-decoration: none;">Forgot Password?</a>
                    </div>
                    <button type="submit" class="submit-button">Login</button>
                </form>
                <div class="login-options">
                    <a href="police-login.jsp">Police Login</a>
                    <a href="admin-login.jsp">Admin Login</a>
                </div>
            </div>

            <!-- Registration Form -->
            <div id="register" class="tab-content">
                <div class="form-header">
                    <h1>Register Account</h1>
                    <p>Create your account to get started</p>
                </div>
                <form action="register" method="POST" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" pattern="[A-Za-z ]+" 
                               title="Name can only contain letters (A-Z or a-z)" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <div class="show-password-container">
                        <input type="checkbox" id="showPassword" onclick="toggleRegisterPasswordVisibility()">
                        <label for="showPassword">Show Password</label>
                    </div>
                    <button type="submit" class="submit-button">Register</button>
                </form>
            </div>
        </div>
        <div class="benefits-sidebar">
            <h2 style="color: #1e40af; margin-bottom: 1.5rem;">Why Register?</h2>
            <ul style="list-style: none;">
                <li style="margin-bottom: 1rem;">&#x2713; File complaints easily</li>
                <li style="margin-bottom: 1rem;">&#x2713; Track complaint status</li>
                <li style="margin-bottom: 1rem;">&#x2713; Receive updates</li>
                <li style="margin-bottom: 1rem;">&#x2713; Access support 24/7</li>
            </ul>
        </div>
    </div>
     <div id="modalDialog" class="modal">
    <div class="modal-content">
        <p id="modalText"></p>
        <button onclick="closeModal()" class="modal-button">OK</button>
    </div>
</div>

    <script>
        // Switch Tabs
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');

        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tabContents.forEach(content => content.classList.remove('active'));

                tab.classList.add('active');
                const tabId = tab.getAttribute('data-tab');
                document.getElementById(tabId).classList.add('active');
            });
        });

        // Toggle Password Visibility for Registration
        function toggleRegisterPasswordVisibility() {
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const isPasswordVisible = password.type === 'text';
            password.type = isPasswordVisible ? 'password' : 'text';
            confirmPassword.type = isPasswordVisible ? 'password' : 'text';
        }

        // Toggle Password Visibility for Login
        function toggleLoginPasswordVisibility() {
            const loginPassword = document.getElementById('loginPassword');
            loginPassword.type = loginPassword.type === 'text' ? 'password' : 'text';
        }

        // Validate Form
               // Validate Form
        function validateForm() {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // Name validation: Only letters and spaces allowed
            const nameRegex = /^[A-Za-z ]+$/;
            if (!nameRegex.test(name)) {
                showModal("Please enter a valid name (letters and spaces only).");
                return false;
            }

            // Email validation: Simple email format check
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showModal("Please enter a valid email address.");
                return false;
            }

            // Password validation: Minimum 6 characters
            if (password.length < 6) {
                showModal("Password must be at least 6 characters long.");
                return false;
            }

            // Confirm password validation: Match check
            if (password !== confirmPassword) {
                showModal("Passwords do not match. Please re-enter.");
                return false;
            }

            return true; // Form is valid
        }

        // Show Modal for validation errors
        function showModal(message) {
            const modal = document.getElementById('modalDialog');
            const modalText = document.getElementById('modalText');
            modalText.textContent = message;
            modal.style.display = 'flex'; // Show the modal
        }

        // Close Modal
        function closeModal() {
            const modal = document.getElementById('modalDialog');
            modal.style.display = 'none'; // Hide the modal
        }

        <% if (request.getAttribute("errorMessage") != null) { %>
        showModal("<%= request.getAttribute("errorMessage") %>");
        
    <% } %>

       
    </script>
</body>
</html>