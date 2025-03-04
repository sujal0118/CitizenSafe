<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, com.fraud.database.Dbconnection" %>
<%
    // Default SEO values (in case no data is found in DB)
    String seoTitle = "CitizenSafe - Stay Safe, Stay Informed";
    String seoDescription = "A trusted platform for fraud prevention, reporting fraudulent numbers, and providing guidance.";
    String seoKeywords = "fraud detection, report scam, cybercrime, scam alert, online fraud prevention";

    try (Connection con = Dbconnection.getConnection()) {
        String query = "SELECT title, description, keywords FROM seo_settings WHERE id = 1";
        PreparedStatement stmt = con.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            seoTitle = rs.getString("title");
            seoDescription = rs.getString("description");
            seoKeywords = rs.getString("keywords");
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace(); // Log error in case DB connection fails
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script defer  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBdBvu5yIpWkgaSEtwB_Id6XLDRir7wPoQ&libraries=places&callback=initMap"></script>
    
    <!-- Dynamic Meta Tags -->
    <title><%= seoTitle %></title>
    <meta name="description" content="<%= seoDescription %>">
    <meta name="keywords" content="<%= seoKeywords %>">
    <meta name="author" content="CitizenSafe">
    <meta name="robots" content="index, follow">
    
    <style>
/* General Styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body {
    background-color: #f4f4f4;
    color: #333;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

/* Header */
header {
    background-color: #0d4b87;
    color: white;
    padding: 0 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 60px;
    position: relative;
    z-index: 1000;
}

.logo {
    display: flex;
    align-items: center;
    font-size: 2rem;
}

.logo img {
    height: 30px;
    margin-right: 10px;
}

/* Navigation */
nav {
    display: flex;
    align-items: center;
}

nav a {
    color: white;
    text-decoration: none;
    margin: 0 15px;
    font-size: 1rem;
}

.login-btn {
    background-color: #4CAF50;
    color: white;
    border: none;
    padding: 7px 20px;
    border-radius: 4px;
    cursor: pointer;
    text-decoration: none;
    font-size: 0.9rem;
}

/* Hero Section */
.hero {
    background: url('images/bg-img.png') no-repeat center center/cover;
    color: white;
    text-align: center;
    padding: 50px 20px;
    position: relative;
    z-index: 1;
}

.hero-content {
    max-width: 800px;
    margin: 0 auto;
    position: relative;
    z-index: 2;
}

.shield-icon {
    margin: 0 15px;
    font-size: 3rem;
}

.hero h1 {
    font-size: 2.2rem;
    margin: 15px 0;
}

/* Features Section */
.features {
    display: flex;
    justify-content: center;
    gap: 30px;
    padding: 50px 20px;
    max-width: 1200px;
    margin: 0 auto;
    flex-wrap: wrap;
}

.feature-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    padding: 30px;
    text-align: center;
    flex: 1 1 300px;
}

.feature-icon {
    font-size: 3rem;
    width: 50px;
    height: 50px;
    margin: 0 auto 20px;
}

.feature-card h3 {
    margin-bottom: 10px;
    color: #0d4b87;
}

.feature-card p {
    margin-bottom: 20px;
    color: #555;
    font-size: 0.9rem;
}

.feature-btn {
    background-color: #0d4b87;
    color: white;
    border: none;
    padding: 8px 15px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
}

/* News Section */
.news-section {
    background-color: #f8f8f8;
    padding: 50px 20px;
}

.news-section h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
}

.news-container {
    display: flex;
    justify-content: center;
    gap: 30px;
    max-width: 1200px;
    margin: 0 auto;
    flex-wrap: wrap;
}

.news-card {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    overflow: hidden;
    width: 350px;
}

.news-image {
    height: 180px;
    background-color: #ddd;
}

.news-content {
    padding: 20px;
}

.news-date {
    color: #666;
    font-size: 0.8rem;
    margin-bottom: 10px;
}

.news-title {
    color: #0d4b87;
    margin-bottom: 10px;
    font-size: 1.2rem;
}

.news-text {
    color: #555;
    margin-bottom: 15px;
    font-size: 0.9rem;
    line-height: 1.5;
}

/* FAQ Section */
.faq-section {
    padding: 50px 20px;
    max-width: 800px;
    margin: 0 auto;
}

.faq-section h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
}

.faq-item {
    margin-bottom: 15px;
}

.faq-question {
    background-color: #0d4b87;
    color: white;
    padding: 15px;
    border-radius: 4px;
    cursor: pointer;
}

.faq-answer {
    padding: 15px;
    background-color: #f1f1f1;
    border-radius: 0 0 4px 4px;
    display: none;
}

/* Map Section */
.map-section {
    padding: 50px 20px;
    text-align: center;
}

.map-section h2 {
    margin-bottom: 30px;
    color: #333;
}

.map-container {
    max-width: 800px;
    height: 300px;
    margin: 0 auto;
    background-color: #ddd;
    border-radius: 8px;
    overflow: hidden;
}

/* Footer */
footer {
    background-color: #333;
    color: white;
    text-align: center;
    padding: 20px;
    margin-top: auto;
}

 /* Chatbot Icon */
    #chatbot-icon {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background-color: #0d4b87;
        color: white;
        font-size: 24px;
        padding: 10px;
        border-radius: 50%;
        cursor: pointer;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
    /* Chatbot Popup */
    #chatbot-container {
        position: fixed;
        bottom: 80px;
        right: 20px;
        width: 350px;
        height: 400px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        display: none;
        flex-direction: column;
        overflow: hidden;
        z-index: 9999;
    }
    .chat-header {
        background: #0d4b87;
        color: white;
        padding: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .chat-header button {
        background: none;
        border: none;
        color: white;
        font-size: 16px;
        cursor: pointer;
    }
    #chatbot-frame {
        width: 100%;
        height: 100%;
        border: none;
    } border: none;
    }
/* Burger Menu (Mobile) */
.burger-menu {
    display: none;
    cursor: pointer;
    flex-direction: column;
    gap: 5px;
}

.burger-menu div {
    width: 30px;
    height: 3px;
    display: none;
    background-color: white;
    transition: 0.3s;
}
.guidance-section {
  background-color: #f0f7f0;
  padding: 50px 0;
  text-align: center;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.guidance-section h2 {
  font-size: 2.2rem;
  color: #333;
  margin-bottom: 30px;
  font-weight: 600;
}

.guidance-btn {
  display: inline-block;
  background-color: #4CAF50;
  color: white;
  text-decoration: none;
  padding: 16px 30px;
  border-radius: 4px;
  font-size: 1.1rem;
  transition: background-color 0.3s;
  max-width: 600px;
  margin: 0 auto;
}

.guidance-btn:hover {
  background-color: #3e9142;
}
/* Responsive Styles */
@media (max-width: 768px) {
    .features, .news-container {
        flex-direction: column;
        align-items: center;
    }

    .feature-card, .news-card {
        width: 100%;
        max-width: 400px;
    }

    .hero h1 {
        font-size: 1.8rem;
    }

    .burger-menu {
        display: flex;
    }
    .burger-menu div{
    background-color: black;
    display: flex;
    }

    nav {
        display: none;
        flex-direction: column;
        position: absolute;
        top: 60px;
        left: 0;
        width: 100%;
        background-color: #0d4b87;
        text-align: center;
        padding: 10px 0;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    nav a {
        display: block;
        padding: 10px;
        color: white;
        font-size: 1.2rem;
    }

    .login-btn {
        display: block;
        width: 80%;
        margin: 10px auto;
        text-align: center;
    }
   .guidance-section h2 {
    font-size: 1.8rem;
  }
  
  .guidance-btn {
    padding: 14px 20px;
    font-size: 1rem;
    width: 100%;
  }
}

/* Additional custom classes */
.name {
    font-size: 2rem;
}

    </style>
</head>
<body>
<header>
    <div class="logo">
        <span class="logo">🛡️CitizenSafe</span>
    </div>

    <div class="burger-menu" onclick="toggleMenu()">
        <div></div>
        <div></div>
        <div></div>
    </div>

    <nav id="nav-links">
        <a href="index.jsp">Home</a>
        <a href="about.jsp">About Us</a>
        <a href="contact.jsp">Contact</a>

        <%
            String user = (String) session.getAttribute("user");
            if (user != null) { 
        %>
            <a href="dashboard.jsp" class="login-btn">Dashboard</a>
        <% } else { %>
            <a href="login.jsp" class="login-btn">Login</a>
        <% } %>
    </nav>
</header>

    <section class="hero">
        <div class="hero-content">
            <%
                if (user != null) {
            %>
                <span class="shield-icon">🛡️</span>
                <span class=name>Welcome, <%= user %></span>
                <span class="shield-icon">🛡️</span>
            <% } %>
            <h1>Stay Safe, Stay Informed</h1>
            <p>Your trusted platform for fraud prevention and reporting</p>
        </div>
    </section>

    <section class="features">
        <div class="feature-card">
            <div class="feature-icon">📝</div>
            <h3>Report Fraud</h3>
            <p>Report fraudulent numbers and websites to protect others in the community</p>
            <button class="feature-btn" onclick="location.href='reportfraud.jsp';">Report Now</button>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔍</div>
            <h3>Check Database</h3>
            <p>View flagged fraud numbers and websites before engaging with unknown contacts</p>
            <button class="feature-btn" onclick="location.href='reported_numbers_websites.jsp';">Search Database</button>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📋</div>
            <h3>File Complaints</h3>
            <p>Submit fraud-related complaints and get assistance from relevant authorities</p>
            <button class="feature-btn" onclick="location.href='complaint.jsp';">File Now</button>
        </div>
    </section>
    <section class="guidance-section">
  <div class="container">
    <h2>Need Guidance?</h2>
    <a href="guidence.jsp" class="guidance-btn">Get expert advice on identifying and preventing fraud</a>
  </div>
</section>

    <section class="news-section">
        <h2>Latest News and Alerts</h2>
        <div class="news-container">
            <%
                try (Connection con = Dbconnection.getConnection()) {
                    String newsQuery = "SELECT id, headline, message, created_at FROM alerts ORDER BY created_at DESC LIMIT 3";
                    PreparedStatement newsStmt = con.prepareStatement(newsQuery);
                    ResultSet newsRs = newsStmt.executeQuery();
                    
                    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
                    
                    while (newsRs.next()) {
                        String headline = newsRs.getString("headline");
                        String message = newsRs.getString("message");
                        Timestamp createdAt = newsRs.getTimestamp("created_at");
                        String formattedDate = dateFormat.format(createdAt);
                        
                        // Truncate message if too long for preview
                        String truncatedMessage = message.length() > 100 ? message.substring(0, 100) + "..." : message;
            %>
            <div class="news-card">
            
                <div class="news-content">
                    <div class="news-date"><%= formattedDate %></div>
                    <h3 class="news-title"><%= headline %></h3>
                    <p class="news-text"><%= truncatedMessage %></p>
                </div>
            </div>
            <%
                    }
                    newsRs.close();
                    newsStmt.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    // If database error or no results, show sample news items as fallback
                    if (true) { // This ensures the fallback always displays for now
            %>
          
            <div class="news-card">
               
                <div class="news-content">
                    <div class="news-date">February 20, 2025</div>
                    <h3 class="news-title">CitizenSafe Partners with National Cybercrime Unit</h3>
                    <p class="news-text">CitizenSafe has established a direct reporting channel with the National Cybercrime Unit to expedite fraud investigations.</p>
                </div>
            </div>
            <div class="news-card">
              
                <div class="news-content">
                    <div class="news-date">February 15, 2025</div>
                    <h3 class="news-title">5 Warning Signs of Investment Fraud</h3>
                    <p class="news-text">Learn to identify the common red flags that could indicate you're dealing with an investment scam.</p>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </section>

<section class="faq-section">
    <h2>Frequently Asked Questions</h2>
    
    <!-- Report Fraud Section -->
    <div class="faq-item">
        <div class="faq-question">What is the difference between "Report Fraud" and "File Complaint"?</div>
        <div class="faq-answer">
            "Report Fraud" allows users to report suspicious websites or phone numbers, which are added to the "Check Database" for public reference.  
            "File Complaint" is for filing official complaints that are reviewed by police officers for legal action.
        </div>
    </div>

    <div class="faq-item">
        <div class="faq-question">How do I report a suspicious website or phone number?</div>
        <div class="faq-answer">
            Navigate to the "Report Fraud" section, choose "Website" or "Phone Number," and enter the required details. Once submitted, it will be listed in the "Check Database" after verification.
        </div>
    </div>

    <div class="faq-item">
        <div class="faq-question">Where can I check if a website or number has been reported?</div>
        <div class="faq-answer">
            Go to the "Check Database" section and search for the website URL or phone number. If it has been reported, you will see details of the complaint.
        </div>
    </div>

    <!-- File Complaint Section -->
    <div class="faq-item">
        <div class="faq-question">How do I file a complaint?</div>
        <div class="faq-answer">
            Go to "File Complaint," fill in the necessary details, record or upload audio evidence, and submit. You will receive an email confirmation with a PDF summary.
        </div>
    </div>

    <div class="faq-item">
        <div class="faq-question">Who reviews my complaint?</div>
        <div class="faq-answer">
            Filed complaints are reviewed by verified police officers who analyze the provided evidence and take appropriate action.
        </div>
    </div>

    <div class="faq-item">
        <div class="faq-question">How do I track my complaint?</div>
        <div class="faq-answer">
            Log in to your dashboard to check the status of your complaint. It will be marked as "Pending," "Accepted," "Rejected," or "Completed."
        </div>
    </div>

  <div class="faq-item">
    <div class="faq-question">Can I upload more evidence after submitting my complaint?</div>
    <div class="faq-answer">
        No, all evidence, including audio recordings and documents, must be uploaded at the time of complaint submission. Once submitted, no further modifications or additions can be made.
    </div>
</div>


    <div class="faq-item">
        <div class="faq-question">Will I be notified when my complaint is reviewed?</div>
        <div class="faq-answer">
            Yes, you will receive an email notification when your complaint is accepted or rejected. If accepted, a case report (PDF) will be sent to you.
        </div>
    </div>

    <div class="faq-item">
        <div class="faq-question">How do I receive fraud alerts?</div>
        <div class="faq-answer">
            Fraud alerts are sent via email by the police. You can also check the "News and Alerts" section on your dashboard.
        </div>
    </div>

</section>


    <section class="map-section">
        <h2>Find Nearest Police Stations</h2>
       <div class="map-container" style="height: 400px; width: 100%;">
        <div id="map" style="width: 100%; height: 100%;"></div>
    </div>
    </section>
    
<div id="chatbot-icon" onclick="openChatbot()">
    💬
</div>

<!-- Chatbot Popup (Initially Hidden) -->
<div id="chatbot-container">
    <div class="chat-header">
        <span>Chatbot</span>
        <button onclick="closeChatbot()">✖</button>
    </div>
    <iframe id="chatbot-frame" src="chatbot.jsp"></iframe> <!-- Loads chatbot.jsp -->
</div>
    <footer>
        <p>&copy; 2025 Fraud Detection System. All rights reserved.</p>
    </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // FAQ toggle
            const faqQuestions = document.querySelectorAll('.faq-question');
            
            faqQuestions.forEach(question => {
                question.addEventListener('click', function() {
                    const answer = this.nextElementSibling;
                    const isVisible = answer.style.display === 'block';
                    
                    // Close all answers
                    document.querySelectorAll('.faq-answer').forEach(answer => {
                        answer.style.display = 'none';
                    });
                    
                    // Open this answer if it wasn't already open
                    if (!isVisible) {
                        answer.style.display = 'block';
                    }
                });
            });
        });
        
        function toggleMenu() {
            const nav = document.getElementById("nav-links");
            if (nav.style.display === "block") {
                nav.style.display = "none";
            } else {
                nav.style.display = "block";
            }
        }
        
        function initMap() {
            const pune = { lat: 18.5204, lng: 73.8567 };
            const map = new google.maps.Map(document.getElementById("map"), {
                center: pune,
                zoom: 12,
            });

            const service = new google.maps.places.PlacesService(map);
            const request = {
                query: "police station in Pune",
                fields: ["name", "geometry"],
            };

            service.textSearch(request, function (results, status) {
                if (status === google.maps.places.PlacesServiceStatus.OK) {
                    for (let i = 0; i < results.length; i++) {
                        createMarker(results[i], map);
                    }
                } else {
                    console.error("Error fetching police stations:", status);
                }
            });
        }

        function createMarker(place, map) {
            new google.maps.Marker({
                position: place.geometry.location,
                map,
                title: place.name,
            });
        }
        
        
        function openChatbot() {
            document.getElementById("chatbot-container").style.display = "flex";
        }

        function closeChatbot() {
            document.getElementById("chatbot-container").style.display = "none";
        }


    </script>


</body>
</html>