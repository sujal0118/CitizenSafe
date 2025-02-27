import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.fraud.database.Dbconnection;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

@SuppressWarnings("unused")
@WebServlet("/SubmitComplaint")
@MultipartConfig(
    fileSizeThreshold = 10 * 1024 * 1024, // 10MB
    maxFileSize = 100 * 1024 * 1024, // 100MB
    maxRequestSize = 150 * 1024 * 1024 // 150MB
)
public class SubmitComplaint extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
        	
            response.sendRedirect("login.jsp?message=Please login to submit your complaint.");
        
            return;
        }
        int userId = (int) session.getAttribute("user_id");

        // Retrieve form data
        String fullName = request.getParameter("fullName");
        String contactNumber = request.getParameter("contactNumber");
        String fraudType = request.getParameter("fraudType");
        String incidentDate = request.getParameter("incidentDate");
        String description = request.getParameter("description");
        String nearestPoliceStation = request.getParameter("policeStation");



        int complaintId = -1;
        boolean isSuccess = false;
        String errorMessage = "";
        List<String> uploadedFiles = new ArrayList<>();
        String recordedAudioFile = null;

        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement stmtEvidence = null;
        PreparedStatement stmtAudio = null;
        ResultSet rs = null;

        try {
            conn = Dbconnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            String sql = "INSERT INTO complaints (iduser, name, contact, type, incident_date, description, status, nearest_police_station) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
       stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
       stmt.setInt(1, userId);
       stmt.setString(2, fullName);
       stmt.setString(3, contactNumber);
       stmt.setString(4, fraudType);
       stmt.setString(5, incidentDate);
       stmt.setString(6, description);
       stmt.setString(7, "Pending");
       stmt.setString(8, nearestPoliceStation);

                
            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    complaintId = rs.getInt(1);
                    isSuccess = true;
                }
            }
            
            if (complaintId == -1) {
                errorMessage = "Failed to insert complaint into the database.";
                conn.rollback();
                isSuccess = false;
            } else {
                // Update the evidence storage path
                String baseFolder = "D:/Fraud detection website/tomcat/apache-tomcat-10.1.24/webapps/FraudDetectionSystem/src/main/webapp/evidence/" + userId + "/" + complaintId;
                File uploadDir = new File(baseFolder);
                if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                    errorMessage = "Failed to create directory for evidence.";
                    conn.rollback();
                    isSuccess = false;
                } else {
                    Collection<Part> fileParts = request.getParts();
                    String sqlEvidence = "INSERT INTO evidence (complaint_id, evidence_type, name, path, file_type) VALUES (?, ?, ?, ?, ?)";
                    stmtEvidence = conn.prepareStatement(sqlEvidence);
                    for (Part filePart : fileParts) {
                        if (filePart.getSubmittedFileName() != null && filePart.getSize() > 0) {
                            String fileName = System.nanoTime() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                            String filePath = baseFolder + "/" + fileName;
                            try (InputStream fileContent = filePart.getInputStream()) {
                                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                            }
                            String fileType = filePart.getContentType();
                            String evidenceType = (fileType.startsWith("audio") || fileType.startsWith("video")) ? "recording" : "document";
                            stmtEvidence.setInt(1, complaintId);
                            stmtEvidence.setString(2, evidenceType);
                            stmtEvidence.setString(3, fileName);
                            stmtEvidence.setString(4, filePath);
                            stmtEvidence.setString(5, fileType);
                            stmtEvidence.addBatch();
                            uploadedFiles.add(fileName);
                        }
                    }
                    stmtEvidence.executeBatch();

                    // Handling recorded audio
                    String audioBlobData = request.getParameter("audioBlobData");
                    if (audioBlobData != null && !audioBlobData.isEmpty()) {
                        try {
                            String base64Audio = audioBlobData.split(",")[1];
                            byte[] audioBytes = Base64.getDecoder().decode(base64Audio);
                            recordedAudioFile = "recorded_audio_" + System.nanoTime() + ".webm";
                            String audioFilePath = baseFolder + "/" + recordedAudioFile;
                            Files.write(Paths.get(audioFilePath), audioBytes);
                            stmtAudio = conn.prepareStatement(sqlEvidence);
                            stmtAudio.setInt(1, complaintId);
                            stmtAudio.setString(2, "recording");
                            stmtAudio.setString(3, recordedAudioFile);
                            stmtAudio.setString(4, audioFilePath);
                            stmtAudio.setString(5, "audio/webm");
                            stmtAudio.executeUpdate();
                        } catch (Exception e) {
                            errorMessage = "Error saving recorded audio.";
                            conn.rollback();
                            isSuccess = false;
                        }
                    }
                    conn.commit();
                }
            }
        } catch (SQLException e) {
            errorMessage = "Database error: " + e.getMessage();
            isSuccess = false;
        } finally {
            // Close resources in finally block
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (stmtEvidence != null) stmtEvidence.close();
                if (stmtAudio != null) stmtAudio.close();
                if (conn != null) Dbconnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("status", isSuccess ? "success" : "error");
        request.setAttribute("complaintId", complaintId);
        request.setAttribute("fullName", fullName);
        request.setAttribute("contactNumber", contactNumber);
        request.setAttribute("fraudType", fraudType);
        request.setAttribute("incidentDate", incidentDate);
        request.setAttribute("description", description);
        request.setAttribute("nearestPoliceStation", nearestPoliceStation);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("evidenceFiles", uploadedFiles.toArray(new String[0]));
        request.setAttribute("audioFile", recordedAudioFile);

        request.getRequestDispatcher("status.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        super.destroy();
        try {
            Dbconnection.shutdown(); // Stop MySQL cleanup thread
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
