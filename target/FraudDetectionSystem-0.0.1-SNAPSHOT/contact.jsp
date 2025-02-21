<!DOCTYPE html>
<html>
<head>
    <title>Contact Us - Fraud Detection Platform</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
            background-color: #f5f5f5;
        }
        
        .header {
            background-color: #1f3347;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .contact-container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
        }
        
        input[type="text"],
        input[type="email"],
        textarea {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        
        textarea {
            height: 150px;
            resize: vertical;
        }
        
        .submit-btn {
            background-color: #1f3347;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .submit-btn:hover {
            background-color: #2c4760;
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
        
        .success-message {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 4px;
            display: none;
        }
        
        .error-message {
            background-color: #f2dede;
            color: #a94442;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 4px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Contact Us</h1>
    </div>

    <a href="index.jsp" class="back-button">Back to Main Page</a>

    <div class="contact-container">
        <div class="success-message" id="successMessage">
            Thank you for your feedback! We'll get back to you soon.
        </div>
        <div class="error-message" id="errorMessage">
            There was an error sending your feedback. Please try again.
        </div>
        
        <form action="submitFeedback.jsp" method="POST" id="feedbackForm">
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="subject">Subject:</label>
                <input type="text" id="subject" name="subject" required>
            </div>
            
            <div class="form-group">
                <label for="message">Message:</label>
                <textarea id="message" name="message" required></textarea>
            </div>
            
            <button type="submit" class="submit-btn">Send Message</button>
        </form>
    </div>

    <script>
        document.getElementById('feedbackForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(this);
            
            // Send form data to server
            fetch('submitFeedback.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('successMessage').style.display = 'block';
                    document.getElementById('errorMessage').style.display = 'none';
                    this.reset();
                } else {
                    document.getElementById('errorMessage').style.display = 'block';
                    document.getElementById('successMessage').style.display = 'none';
                }
            })
            .catch(error => {
                document.getElementById('errorMessage').style.display = 'block';
                document.getElementById('successMessage').style.display = 'none';
            });
        });
    </script>
</body>
</html>