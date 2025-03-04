package com.fraud.Fetcher;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import org.json.JSONArray;
import org.json.JSONObject;

public class PhishTankFetcher {
    private static final String API_URL = "http://data.phishtank.com/data/online-valid.json";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/websitefraud";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root@Asj0118";

    public static void main(String[] args) {
        try {
            String finalUrl = getFinalRedirectedURL(API_URL);
            if (finalUrl == null) {
                System.out.println("Failed to resolve the redirected URL.");
                return;
            }

            URL urlObj = URI.create(finalUrl).toURL();
            HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
            conn.setRequestMethod("GET");

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.out.println("Error: Received HTTP " + responseCode);
                return;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // Debugging: Print response to check its structure
            System.out.println("API Response: " + response.toString());

            // Check if the response is a JSONArray or JSONObject
            JSONArray phishingSites;
            try {
                phishingSites = new JSONArray(response.toString());
            } catch (Exception e) {
                JSONObject jsonResponse = new JSONObject(response.toString());
                phishingSites = jsonResponse.getJSONArray("data"); // Adjust if needed
            }

            Connection dbConn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            String insertSQL = "INSERT IGNORE INTO fraud_data (fraud_url_or_number, category, source, risk_level) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = dbConn.prepareStatement(insertSQL);

            for (int i = 0; i < phishingSites.length(); i++) {
                String url = phishingSites.getJSONObject(i).getString("url");
                pstmt.setString(1, url);
                pstmt.setString(2, "Phishing");
                pstmt.setString(3, "PhishTank");
                pstmt.setString(4, "High");
                pstmt.addBatch();
            }

            pstmt.executeBatch();
            pstmt.close();
            dbConn.close();
            System.out.println("PhishTank data updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Method to handle redirects and get final URL
    private static String getFinalRedirectedURL(String urlString) {
        try {
            URL url = URI.create(urlString).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setInstanceFollowRedirects(false); // Do not follow redirects automatically

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_MOVED_PERM || responseCode == HttpURLConnection.HTTP_MOVED_TEMP) {
                String newUrl = conn.getHeaderField("Location");
                System.out.println("Redirected to: " + newUrl);
                return newUrl;
            }
            return urlString;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
