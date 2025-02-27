import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import com.fraud.database.Dbconnection;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/VisitorStatsServlet")
public class VisitorStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = Dbconnection.getConnection()) {
            Map<String, Object> stats = new HashMap<>();

            // 1️⃣ Fetch User Growth Data
            String userGrowthQuery = "SELECT DATE(submission_date) as date, COUNT(*) as count FROM user GROUP BY DATE(submission_date) ORDER BY date ASC";
            PreparedStatement stmt1 = conn.prepareStatement(userGrowthQuery);
            ResultSet rs1 = stmt1.executeQuery();

            List<String> dates = new ArrayList<>();
            List<Integer> userGrowth = new ArrayList<>();

            while (rs1.next()) {
                dates.add(rs1.getString("date"));
                userGrowth.add(rs1.getInt("count"));  // Ensuring integer count
            }
            stats.put("dates", dates);
            stats.put("userGrowth", userGrowth);

            // 2️⃣ Fetch Total User & Police Cases (Ensure Integer Values)
            String userCaseQuery = "SELECT COUNT(*) AS total FROM complaints";
            PreparedStatement stmt2 = conn.prepareStatement(userCaseQuery);
            ResultSet rs2 = stmt2.executeQuery();
            int userCases = rs2.next() ? rs2.getInt("total") : 0;
            stats.put("userCases", userCases);  // Always an integer

            String policeCaseQuery = "SELECT COUNT(*) AS ongoing FROM complaints WHERE status IN ('Pending', 'Accepted')";

            PreparedStatement stmt3 = conn.prepareStatement(policeCaseQuery);
            ResultSet rs3 = stmt3.executeQuery();
            int policeCases = rs3.next() ? rs3.getInt("ongoing") : 0;

            stats.put("policeCases", policeCases);  // Always an integer

            // 3️⃣ Fetch Complaint Status Distribution (Ensure Integer Values)
            String statusQuery = "SELECT status, COUNT(*) AS count FROM complaints GROUP BY status";
            PreparedStatement stmt4 = conn.prepareStatement(statusQuery);
            ResultSet rs4 = stmt4.executeQuery();

            int pending = 0, accepted = 0, rejected = 0, completed = 0;
            while (rs4.next()) {
                String status = rs4.getString("status");
                int count = rs4.getInt("count");  // Ensure integer

                switch (status) {
                    case "Pending": pending = count; break;
                    case "Accepted": accepted = count; break;
                    case "Rejected": rejected = count; break;
                    case "Completed": completed = count; break;
                }
            }
            stats.put("pending", pending);
            stats.put("accepted", accepted);
            stats.put("rejected", rejected);
            stats.put("completed", completed);

            // Convert to JSON and send response
            String json = new Gson().toJson(stats);
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"Data fetching error\"}");
        }
    }
}
