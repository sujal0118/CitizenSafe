<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logging Out...</title>
  
    <meta http-equiv="refresh" content="0;url=login.jsp">
</head>
<body>
    <p>You have been logged out. Redirecting to the login page...</p>
</body>
</html>