package com.fraud.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

public class Dbconnection {
    private static final String URL = "jdbc:mysql://localhost:3306/websitefraud";
    private static final String USER = "root";
    private static final String PASSWORD = "root@Asj0118";

    // Load MySQL Driver (Static block ensures it loads only once)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL JDBC Driver not found.");
        }
    }

    // Method to get a new database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Method to properly close a connection
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to cleanup MySQL connections when the app shuts down
    public static void shutdown() throws InterruptedException {
        AbandonedConnectionCleanupThread.checkedShutdown();
		System.out.println("MySQL cleanup thread stopped.");
    }

    // Method to test the database connection
    public static void main(String[] args) {
        try (Connection conn = Dbconnection.getConnection()) {
            if (conn != null) {
                System.out.println("Database connected successfully!");
            }
        } catch (SQLException e) {
            System.out.println("Database connection failed: " + e.getMessage());
        }
    }
}
