<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chatbot</title>
    <style>
        /* Chatbot Styles */
        #chat-window {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        #chat-header {
            background: #0d4b87;
            color: white;
            padding: 10px;
            text-align: center;
            font-weight: bold;
        }
        #chat-messages {
            flex-grow: 1;
            padding: 10px;
            overflow-y: auto;
        }
        .user-message {
            text-align: right;
            background: #d1e7ff;
            padding: 5px;
            border-radius: 5px;
            margin: 5px;
        }
        .bot-message {
            text-align: left;
            background: #e6e6e6;
            padding: 5px;
            border-radius: 5px;
            margin: 5px;
        }
        #chat-input-container {
            display: flex;
            padding: 10px;
            background: #f8f9fa;
        }
        #chat-input {
            flex-grow: 1;
            padding: 5px;
        }
        button {
            padding: 5px 10px;
            background: #0d4b87;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<!-- Chatbot UI (Always Visible in Popup) -->
<div id="chat-window">
    <div id="chat-header">Fraud Guidance Chatbot</div>
    <div id="chat-messages"></div>
    <div id="chat-input-container">
        <input type="text" id="chat-input" placeholder="Type your message...">
        <button onclick="sendMessage()">Send</button>
    </div>
</div>

<script>
function sendMessage() {
    let inputField = document.getElementById("chat-input");
    let userMessage = inputField.value.trim();
    if (userMessage === "") return;

    // Display user message
    let chatMessages = document.getElementById("chat-messages");
    chatMessages.innerHTML += "<div class='user-message'>" + userMessage + "</div>";

    // Determine chatbot type
    let chatbotType = (userMessage.toLowerCase().includes("fraud") || userMessage.toLowerCase().includes("scam")) ? "ai" : "faq";

    // Send message to servlet
    fetch("ChatbotServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "message=" + encodeURIComponent(userMessage) + "&type=" + chatbotType
    })
    .then(response => response.text())
    .then(reply => {
        chatMessages.innerHTML += "<div class='bot-message'>" + reply + "</div>";
        chatMessages.scrollTop = chatMessages.scrollHeight;
    });

    inputField.value = "";
}
</script>

</body>
</html>
