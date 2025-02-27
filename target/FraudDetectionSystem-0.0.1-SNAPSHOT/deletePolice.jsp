<%@ page import="java.sql.*" %>
<%@ page import="com.fraud.database.Dbconnection" %>

<%
    String policeId = request.getParameter("id");

    if (policeId != null && !policeId.isEmpty()) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = Dbconnection.getConnection();
            String deleteQuery = "DELETE FROM police_officers WHERE p_id=?";
            stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, Integer.parseInt(policeId));

            int rowsDeleted = stmt.executeUpdate();

            if (rowsDeleted > 0) {
                out.print("success");
            } else {
                out.print("error: no rows affected");
            }
        } catch (Exception e) {
            out.print("error: " + e.getMessage());
        } finally {
            if (stmt != null) stmt.close();
            if (con != null) Dbconnection.closeConnection(con);
        }
    } else {
        out.print("error: invalid id");
    }
%>
