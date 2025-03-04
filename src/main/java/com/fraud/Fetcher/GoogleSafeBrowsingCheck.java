package com.fraud.Fetcher;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import com.fraud.database.Dbconnection;

@WebServlet("/GoogleSafeBrowsingCheck")
public class GoogleSafeBrowsingCheck extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String API_KEY = "AIzaSyCOiwHTDmK_W_qltWBMwRgJwnL8JEA0hB4";
    private static final String API_URL = "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=" + API_KEY;


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportedUrl = request.getParameter("url");

        String jsonRequest = "{ \"client\": {\"clientId\": \"yourcompany\", \"clientVersion\": \"1.0\"}, " +
                             "\"threatInfo\": {\"threatTypes\": [\"MALWARE\", \"SOCIAL_ENGINEERING\"], " +
                             "\"platformTypes\": [\"ANY_PLATFORM\"], " +
                             "\"threatEntryTypes\": [\"URL\"], " +
                             "\"threatEntries\": [{\"url\": \"" + reportedUrl + "\"}]}}";

        // **Fix for URL(String) deprecation in Java 20+**
        HttpURLConnection conn = (HttpURLConnection) URI.create(API_URL).toURL().openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonRequest.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (responseCode == HttpURLConnection.HTTP_OK) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                StringBuilder responseString = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    responseString.append(responseLine.trim());
                }

                JSONObject jsonResponse = new JSONObject(responseString.toString());
                boolean isFraudulent = jsonResponse.has("matches"); // If matches exist, it's fraudulent

                // Store the result in MySQL
                storeResultInDatabase(reportedUrl, isFraudulent ? "Yes" : "No");

                response.getWriter().write(responseString.toString());
            }
        } else {
            response.getWriter().write("{\"error\": \"Failed to fetch Safe Browsing results. HTTP Code: " + responseCode + "\"}");
        }
    }

    private void storeResultInDatabase(String url, String verifiedFraud) {
        try {
           
            try (Connection conn = Dbconnection.getConnection()) {
                String checkSql = "SELECT * FROM google_safe_browsing WHERE url = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setString(1, url);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next()) {
                        // If URL already exists, update the verification status
                        String updateSql = "UPDATE google_safe_browsing SET verified_fraud = ?, last_checked = NOW() WHERE url = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, verifiedFraud);
                            updateStmt.setString(2, url);
                            updateStmt.executeUpdate();
                        }
                    } else {
                        // If URL doesn't exist, insert a new record
                        String insertSql = "INSERT INTO google_safe_browsing (url, verified_fraud) VALUES (?, ?)";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setString(1, url);
                            insertStmt.setString(2, verifiedFraud);
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
