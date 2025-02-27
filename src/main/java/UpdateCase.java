import java.io.*;
import java.sql.*;
import java.util.Properties;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fraud.database.Dbconnection;

@WebServlet("/UpdateCase")
public class UpdateCase extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int caseId = Integer.parseInt(request.getParameter("caseId"));
        String newStatus = request.getParameter("status");
        String feedback = request.getParameter("feedback");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String userEmail = "", policeStation = "";

        try {
            con = Dbconnection.getConnection();
            pstmt = con.prepareStatement("SELECT u.email, c.nearest_police_station FROM complaints c JOIN user u ON c.iduser = u.iduser WHERE c.idcomplaint = ?");
            pstmt.setInt(1, caseId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userEmail = rs.getString("email");
                policeStation = rs.getString("nearest_police_station");
            }
            rs.close();
            pstmt.close();

            int officerId = (int) request.getSession().getAttribute("officer_id"); 

            pstmt = con.prepareStatement("UPDATE complaints SET status = ?, feedback = ?, police_id = ? WHERE idcomplaint = ?");
            pstmt.setString(1, newStatus);
            pstmt.setString(2, feedback);
            pstmt.setInt(3, officerId);  
            pstmt.setInt(4, caseId);

            int rowsUpdated = pstmt.executeUpdate();
            pstmt.close();

            if (rowsUpdated > 0) {
                String pdfPath = null;
                if ("Accepted".equalsIgnoreCase(newStatus)) {
                    pdfPath = generateCaseReport(caseId);
                }
                sendStatusEmail(userEmail, caseId, newStatus, feedback, policeStation, pdfPath);
                response.sendRedirect("police.jsp?msg=Case Updated Successfully");
            } else {
                response.sendRedirect("viewCase.jsp?caseId=" + caseId + "&msg=Error Updating Case");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String generateCaseReport(int caseId) throws Exception {
    	String filePath = "D:/Fraud detection website/tomcat/apache-tomcat-10.1.24/webapps/FraudDetectionSystem/case/case_" + caseId + ".pdf";
    	File file = new File(filePath);

   
    	if (!file.getParentFile().exists()) {
    	    file.getParentFile().mkdirs();
    	}
        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream(filePath));
        document.open();

        Connection con = Dbconnection.getConnection();
        PreparedStatement pstmt = con.prepareStatement(
            "SELECT c.idcomplaint, c.description, c.status, c.incident_date, c.feedback, " +
            "u.name, u.email, c.nearest_police_station, c.police_id " +
            "FROM complaints c JOIN user u ON c.iduser = u.iduser WHERE c.idcomplaint = ?"
        );
        pstmt.setInt(1, caseId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Paragraph title = new Paragraph("Case Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph("\n"));

            Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            Font textFont = new Font(Font.FontFamily.HELVETICA, 12);

            document.add(new Paragraph("Case ID: " + rs.getInt("idcomplaint"), headerFont));
            document.add(new Paragraph("Description: " + rs.getString("description"), textFont));
            document.add(new Paragraph("Status: " + rs.getString("status"), textFont));
            document.add(new Paragraph("Date Filed: " + rs.getString("incident_date"), textFont));
            document.add(new Paragraph("Feedback: " + rs.getString("feedback"), textFont));
            document.add(new Paragraph("Nearest Police Station: " + rs.getString("nearest_police_station"), textFont));
            document.add(new Paragraph("\n"));

            // Retrieve evidence details
            document.add(new Paragraph("Evidence List:", headerFont));

            PreparedStatement evidenceStmt = con.prepareStatement(
                "SELECT name, path, evidence_type FROM evidence WHERE complaint_id = ?"
            );
            evidenceStmt.setInt(1, caseId);
            ResultSet evidenceRs = evidenceStmt.executeQuery();

            while (evidenceRs.next()) {
                String evidenceName = evidenceRs.getString("name");
                String evidencePath = evidenceRs.getString("path");
                String evidenceType = evidenceRs.getString("evidence_type");

                document.add(new Paragraph(" - " + evidenceName + " (" + evidenceType + ")", textFont));

                if ("recording".equalsIgnoreCase(evidenceType)) {
                    // Perform Speech-to-Text conversion
                    try {
                        String transcript = SpeechToTextUtil.transcribeAudio(evidencePath);
                        document.add(new Paragraph("   Transcription: " + transcript, textFont));
                    } catch (Exception e) {
                        document.add(new Paragraph("   Transcription Failed: " + e.getMessage(), textFont));
                    }
                }
            }

            evidenceRs.close();
            evidenceStmt.close();

            document.add(new Paragraph("\n--------------------------------------------\n", textFont));
            document.add(new Paragraph("Generated by Fraud Complaint and Guidance System", textFont));
        }

        rs.close();
        pstmt.close();
        con.close();

        document.close();

        // Store file path in database
        con = Dbconnection.getConnection();
        pstmt = con.prepareStatement("UPDATE complaints SET case_report_path = ? WHERE idcomplaint = ?");
        pstmt.setString(1, filePath);
        pstmt.setInt(2, caseId);
        pstmt.executeUpdate();
        pstmt.close();
        con.close();

        return filePath;
    }

    private void sendStatusEmail(String toEmail, int caseId, String status, String feedback, String policeStation, String pdfPath) {
        String fromEmail = "fruaddetectionwebsite@gmail.com";
        String host = "smtp.gmail.com";
        String username = "fruaddetectionwebsite@gmail.com";
        String password = "ioyx xnyo mjsn acsq";

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Complaint Status Update");

            Multipart multipart = new MimeMultipart();

            // Construct email body
            String emailBody = "Dear User,\n\nYour complaint (ID: " + caseId + ") has been **" + status + "**.\n\n";

            if ("Accepted".equalsIgnoreCase(status)) {
                emailBody += "✅ Your case has been accepted and is under investigation.\n";
                emailBody += "📌 **Next Steps:**\n";
                emailBody += "   - Please visit the assigned police station: **" + policeStation + "**.\n";
                emailBody += "   - Carry all necessary documents and evidence.\n";
                emailBody += "   - The officers at the station will guide you on the next steps.\n\n";
            } else if ("Rejected".equalsIgnoreCase(status)) {
                emailBody += "⚠️ Unfortunately, your case has been rejected.\n";
                emailBody += "📌 **Possible Reasons:**\n";
                emailBody += "   - Insufficient evidence or lack of required details.\n";
                emailBody += "   - The complaint does not meet the required criteria for investigation.\n";
                emailBody += "   - You can resubmit with additional supporting evidence.\n\n";
            } else if ("Completed".equalsIgnoreCase(status)) {
                emailBody += "🎉 Your case has been marked as **Completed**.\n";
                emailBody += "📌 **Final Steps:**\n";
                emailBody += "   - The investigation has been concluded, and necessary actions have been taken.\n";
                emailBody += "   - No further action is required from your side.\n\n";
            }

            emailBody += "📌 **Feedback from Police:** " + feedback + "\n\n";
            emailBody += "Regards,\n**CitizenSafe**";

            // Add text content
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(emailBody, "utf-8");
            multipart.addBodyPart(textPart);

            // Attach PDF only if the complaint is Accepted or Completed
            if (("Accepted".equalsIgnoreCase(status)  && pdfPath != null)) {
                MimeBodyPart attachmentPart = new MimeBodyPart();
                attachmentPart.attachFile(new File(pdfPath));
                multipart.addBodyPart(attachmentPart);
            }

            message.setContent(multipart);
            Transport.send(message);
        } catch (MessagingException | IOException e) {
            e.printStackTrace();
        }
    }

    }

