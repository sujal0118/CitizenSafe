import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/downloadCaseReport")
public class DownloadCaseReport extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get case ID from request
        String caseId = request.getParameter("caseId");
        if (caseId == null || caseId.trim().isEmpty()) {
            response.getWriter().write("<h3>Invalid Case ID.</h3>");
            return;
        }

        // File path where the report is stored
        String filePath = "D:/Fraud detection website/tomcat/apache-tomcat-10.1.24/webapps/FraudDetectionSystem/case/case_" + caseId + ".pdf";
        File reportFile = new File(filePath);

        // Check if the file exists
        if (!reportFile.exists()) {
            response.setContentType("text/html");
            response.getWriter().write("<h3>Report not found.</h3>");
            return;
        }

        // Set response headers
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=case_" + caseId + ".pdf");

        // Read and write the file to the response
        try (FileInputStream fileInputStream = new FileInputStream(reportFile);
             OutputStream responseOutputStream = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                responseOutputStream.write(buffer, 0, bytesRead);
            }
        }
    }
}
