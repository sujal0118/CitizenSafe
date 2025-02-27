
import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fraud.database.Dbconnection;

@WebServlet("/downloadEvidence")
public class DownloadEvidenceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String EVIDENCE_FOLDER = "D:/Fraud detection website/tomcat/apache-tomcat-10.1.24/webapps/FraudDetectionSystem/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String evidenceIdParam = request.getParameter("evidence_id");
        if (evidenceIdParam == null || evidenceIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing evidence ID.");
            return;
        }

        int evidenceId;
        try {
            evidenceId = Integer.parseInt(evidenceIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid evidence ID format.");
            return;
        }

        String filePath = null;
        String fileType = null;

        try (Connection conn = Dbconnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT path, file_type FROM evidence WHERE evidence_id = ?")) {
            ps.setInt(1, evidenceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    filePath = rs.getString("path");
                    fileType = rs.getString("file_type");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            return;
        }

        // Debugging logs
        System.out.println("Evidence ID: " + evidenceId);
        System.out.println("Retrieved file path from DB: " + filePath);

        if (filePath == null || filePath.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Evidence not found in database.");
            return;
        }

        // Remove any absolute path if present
        if (filePath.startsWith("D:/") || filePath.startsWith("C:/")) {
            filePath = filePath.replaceFirst("^D:/Fraud detection website/tomcat/apache-tomcat-10.1.24/webapps/FraudDetectionSystem/", "");
        }

        File file = new File(EVIDENCE_FOLDER, filePath);
        System.out.println("Attempting to serve file: " + file.getAbsolutePath());

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found: " + file.getAbsolutePath());
            return;
        }

        response.setContentType(fileType != null ? fileType : "application/octet-stream");
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
        response.setContentLengthLong(file.length());

        try (FileInputStream fis = new FileInputStream(file);
             ServletOutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error streaming file: " + e.getMessage());
        }
    }
}
