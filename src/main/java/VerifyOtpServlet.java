import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Retrieve OTP from session (as Integer)
        Integer generatedOtp = (Integer) session.getAttribute("otp");

        // Get OTP entered by user
        String enteredOtpStr = request.getParameter("otp");

        if (generatedOtp == null) {
            response.getWriter().println("Session expired or OTP not found.");
            return;
        }

        try {
            // Convert user input to Integer
            int enteredOtp = Integer.parseInt(enteredOtpStr);

            // Compare entered OTP with generated OTP
            if (generatedOtp.equals(enteredOtp)) {
            	response.sendRedirect("reset-password.jsp");
            } else {
                response.getWriter().println("❌ Invalid OTP. Please try again.");
            }
        } catch (NumberFormatException e) {
            response.getWriter().println("❌ Invalid OTP format. Please enter a numeric OTP.");
        }
    }
}
