package com.fraud.report;

import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fraud.database.Dbconnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.jfree.chart.*;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.time.Day;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import javax.imageio.ImageIO;

@WebServlet("/GenerateReportServlet")
public class GenerateReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String timePeriod = request.getParameter("time");
        String reportType = request.getParameter("report");
        
        // Default values if parameters are missing
        if (timePeriod == null || timePeriod.isEmpty()) {
            timePeriod = "30"; // Default to 30 days
        }
        if (reportType == null || reportType.isEmpty()) {
            reportType = "all";
        }
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=CitizenSafe_Report.pdf");

        Document document = new Document();
        try (OutputStream out = response.getOutputStream(); Connection con = Dbconnection.getConnection()) {
            PdfWriter.getInstance(document, out);
            document.open();

            // Title
            document.add(new Paragraph("Citizen Safe Website Report", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18)));
            document.add(new Paragraph("Time Period: " + timePeriod, FontFactory.getFont(FontFactory.HELVETICA, 12)));
            document.add(new Paragraph("\n"));

            // Admin Report or All Reports
            if ( "all".equals(reportType)) {
                addReportSummary(con, document, timePeriod);
                document.add(new Paragraph("\n"));
                document.add(new LineSeparator());
                document.add(new Paragraph("\n"));
                addComplaintStatusGraph(con, document, timePeriod);
                document.add(new Paragraph("\n"));
                addUserGrowthGraph(con, document, timePeriod);
                document.add(new Paragraph("\n"));
                addPoliceUserCaseComparison(con, document, timePeriod);
            }

            // User Report
            if ("user".equals(reportType) || "all".equals(reportType)) {
            	document.add(new Paragraph("\nUser Reports\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));
            	document.add(new Paragraph("\n"));
                addUserDetailsTable(con, document, timePeriod);
                document.add(new Paragraph("\n"));
            }

            // Police Report
            if ("police".equals(reportType) || "all".equals(reportType)) {
            	document.add(new Paragraph("\nPolice Reports\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));
            	document.add(new Paragraph("\n"));
                addPoliceDetailsTable(con, document, timePeriod);
                document.add(new Paragraph("\n"));
            }

            document.close();
            out.flush();
        } catch (DocumentException | SQLException e) {
            e.printStackTrace();
            response.reset();
            response.setContentType("text/html");
            response.getWriter().println("<h3>Error generating report. Please try again.</h3>");
        }
    }

    private void addReportSummary(Connection con, Document document, String timePeriod) throws SQLException, DocumentException {
        document.add(new Paragraph("Citizen Safe Website Activity Report - " + java.time.LocalDate.now(), 
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));

        int activeUsers = 0, totalPolice = 0, totalCases = 0, pendingCases = 0, acceptedCases = 0, rejectedCases = 0, completedCases = 0;

        // Fetch total active users
        String userQuery = "SELECT COUNT(*) AS total_users FROM user WHERE DATE(submission_date) >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        try (PreparedStatement stmt = con.prepareStatement(userQuery)) {
            stmt.setInt(1, getIntervalDays(timePeriod));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    activeUsers = rs.getInt("total_users");
                }
            }
        }

        // Fetch total police count
        String policeQuery = "SELECT COUNT(*) AS total_police FROM police_officers";
        try (PreparedStatement stmt = con.prepareStatement(policeQuery);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                totalPolice = rs.getInt("total_police");
            }
        }

        // Fetch complaint status counts
        String caseQuery = "SELECT status, COUNT(*) AS case_count FROM complaints WHERE DATE(submission_date) >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY status";
        try (PreparedStatement stmt = con.prepareStatement(caseQuery)) {
            stmt.setInt(1, getIntervalDays(timePeriod));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("case_count");
                    switch (status.toLowerCase()) {
                        case "pending": pendingCases = count; break;
                        case "accepted": acceptedCases = count; break;
                        case "rejected": rejectedCases = count; break;
                        case "completed": completedCases = count; break;
                    }
                    totalCases += count;
                }
            }
        }

        // Updated Summary Format
        document.add(new Paragraph(String.format(
                "Today, the Citizen Safe website recorded %d active users and %d police with %d active cases. " +
                "Of these cases, %d are currently pending, %d cases have been accepted, " +
                "%d cases were rejected, and %d cases were completed.",
                activeUsers, totalPolice, totalCases, pendingCases, acceptedCases, rejectedCases, completedCases)));
    }

    private void addComplaintStatusGraph(Connection con, Document document, String timePeriod) throws SQLException, IOException, DocumentException {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        String query = "SELECT status, COUNT(*) AS count FROM complaints WHERE DATE(submission_date) >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY status";

        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setInt(1, getIntervalDays(timePeriod));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int count = rs.getInt("count"); // Ensure integer value
                    dataset.addValue(count, rs.getString("status"), ""); // Store only integers
                }
            }
        }

        JFreeChart barChart = ChartFactory.createBarChart("Complaint Status", "Status", "Count", dataset, PlotOrientation.VERTICAL, true, true, false);

        // **Force Integer Axis Values**
        CategoryPlot plot = barChart.getCategoryPlot();
        plot.getRangeAxis().setStandardTickUnits(NumberAxis.createIntegerTickUnits()); // Only integer values on Y-axis

        addChartToDocument(barChart, document);
    }



    private void addUserGrowthGraph(Connection con, Document document, String timePeriod) throws SQLException, IOException, DocumentException {
        TimeSeries series = new TimeSeries("User Growth");
        String query = "SELECT DATE(submission_date) AS date, COUNT(*) AS count FROM user WHERE DATE(submission_date) >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY DATE(submission_date) ORDER BY date ASC";

        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setInt(1, getIntervalDays(timePeriod));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    java.sql.Date sqlDate = rs.getDate("date");
                    int count = rs.getInt("count"); // Ensure integer value
                    series.add(new Day(sqlDate), count); // Use strictly integer values
                }
            }
        }

        TimeSeriesCollection dataset = new TimeSeriesCollection(series);
        JFreeChart timeChart = ChartFactory.createTimeSeriesChart("User Growth Trend", "Date", "Number of Users", dataset, true, true, false);
        
        XYPlot plot = (XYPlot) timeChart.getPlot();
        DateAxis axis = (DateAxis) plot.getDomainAxis();
        axis.setDateFormatOverride(new SimpleDateFormat("dd-MMM-yyyy"));

        // **Force Integer Axis Values**
        plot.getRangeAxis().setStandardTickUnits(NumberAxis.createIntegerTickUnits());

        addChartToDocument(timeChart, document);
    }

  

    private void addPoliceUserCaseComparison(Connection con, Document document, String timePeriod) throws SQLException, IOException, DocumentException {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        int userCount = 0, policeCount = 0;

        String userQuery = "SELECT COUNT(*) AS total_users FROM user WHERE DATE(submission_date) >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        try (PreparedStatement stmt = con.prepareStatement(userQuery)) {
            stmt.setInt(1, getIntervalDays(timePeriod));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    userCount = rs.getInt("total_users"); // Ensure integer value
                }
            }
        }

        String policeQuery = "SELECT COUNT(*) AS total_police FROM police_officers";
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(policeQuery)) {
            if (rs.next()) {
                policeCount = rs.getInt("total_police"); // Ensure integer value
            }
        }

        dataset.addValue(userCount, "Users", "");
        dataset.addValue(policeCount, "Police", "");

        JFreeChart barChart = ChartFactory.createBarChart("Police vs User ", "Category", "Count", dataset, PlotOrientation.VERTICAL, true, true, false);
        
        // **Force Integer Axis Values**
        CategoryPlot plot = barChart.getCategoryPlot();
        plot.getRangeAxis().setStandardTickUnits(NumberAxis.createIntegerTickUnits()); // Only integer values on Y-axis

        addChartToDocument(barChart, document);
    }



    private void addChartToDocument(JFreeChart chart, Document document) throws IOException, DocumentException {
        int width = 500;
        int height = 300;
        BufferedImage bufferedImage = chart.createBufferedImage(width, height);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(bufferedImage, "png", baos);
        Image chartImage = Image.getInstance(baos.toByteArray());
        document.add(new Paragraph("\n"));
        document.add(chartImage);
    }

    private void addUserDetailsTable(Connection con, Document document, String timePeriod) throws SQLException, DocumentException {
        PdfPTable table = new PdfPTable(4); // 4 columns: User ID, Name, Email, Feedback
        table.setWidthPercentage(100);
        table.addCell("User ID");
        table.addCell("Name");
        table.addCell("Email");
        table.addCell("Feedback");

        String query = "SELECT u.iduser, u.name, u.email, " +
                       "(SELECT GROUP_CONCAT(CONCAT(subject, ': ', message) SEPARATOR ' | ') FROM user_feedback uf WHERE uf.user_id = u.iduser) AS feedback " +
                       "FROM user u WHERE DATE(u.submission_date) >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";

        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setInt(1, getIntervalDays(timePeriod));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    table.addCell(String.valueOf(rs.getInt("iduser")));
                    table.addCell(rs.getString("name"));
                    table.addCell(rs.getString("email"));
                    
                    // Show feedback or "No Feedback"
                    String feedback = rs.getString("feedback");
                    table.addCell(feedback != null ? feedback : "No Feedback");
                }
            }
        }
        document.add(table);
    }



    private void addPoliceDetailsTable(Connection con, Document document, String timePeriod) throws SQLException, DocumentException {
        PdfPTable table = new PdfPTable(5); // 5 columns: Police ID, Name, Batch ID, Police Station, Feedback
        table.setWidthPercentage(100);
        table.addCell("Police ID");
        table.addCell("Name");
        table.addCell("Batch ID");
        table.addCell("Police Station");
        table.addCell("Feedback");

        String query = "SELECT p.p_id, p.name, p.batch_id, p.police_station, " +
                       "(SELECT GROUP_CONCAT(CONCAT(subject, ': ', message) SEPARATOR ' | ') FROM police_feedback pf WHERE pf.p_id = p.p_id) AS feedback " +
                       "FROM police_officers p";

        try (PreparedStatement stmt = con.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    table.addCell(String.valueOf(rs.getInt("p_id")));
                    table.addCell(rs.getString("name"));
                    table.addCell(rs.getString("batch_id"));
                    table.addCell(rs.getString("police_station"));
                    
                    // Show feedback or "No Feedback"
                    String feedback = rs.getString("feedback");
                    table.addCell(feedback != null ? feedback : "No Feedback");
                }
            }
        }
        document.add(table);
    }

    private int getIntervalDays(String timePeriod) {
        switch (timePeriod.toLowerCase()) {
            case "daily": return 1;
            case "weekly": return 7;
            case "monthly": return 30;
            case "yearly": return 365;
            default: 
                try {
                    return Integer.parseInt(timePeriod); // Allow numeric values
                } catch (NumberFormatException e) {
                    return 30; // Default to 30 days if invalid input
                }
        }
    }
}