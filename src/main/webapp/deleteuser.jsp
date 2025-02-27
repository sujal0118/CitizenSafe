<%@ page import="java.sql.*" %>
<%@ page import="com.fraud.database.Dbconnection" %>

<%
    String userId = request.getParameter("id");

    if (userId != null && !userId.isEmpty()) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = Dbconnection.getConnection();
            String deleteQuery = "DELETE FROM user WHERE iduser=?";
            stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, Integer.parseInt(userId));

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
