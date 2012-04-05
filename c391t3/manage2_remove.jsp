<%@ page import="java.sql.*" %>
<%
	String title = "Remove a user";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%

	String usrName = request.getParameter("name");
	out.println("<p>"+usrName+"</p>");
	if(session.getAttribute("name") != null){
    	//establish the connection to the underlying database
		Connection conn = null;

    	String driverName = "oracle.jdbc.driver.OracleDriver";
    	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

    	try{
        	//load and register the driver
			Class drvClass = Class.forName(driverName); 
    		DriverManager.registerDriver((Driver) drvClass.newInstance());
    		//establish the connection 
    		if(session.getAttribute("dbuser") != null){
    			String dbUser = (String) session.getAttribute("dbuser");
    			String dbPass = (String) session.getAttribute("dbpass");
    			conn = DriverManager.getConnection(dbstring, dbUser, dbPass);
    		}
    		else
        		conn = DriverManager.getConnection(dbstring,"cwarkent","lotr0808pso");
			conn.setAutoCommit(false);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
    	
		PreparedStatement stmt = null;
    	ResultSet rset = null;
    	
    	String sql = "DELETE FROM family_doctor WHERE patient_name = ?";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, usrName);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p>Remove Success!</p>");
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
    	sql = "DELETE FROM persons WHERE user_name = ?";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, usrName);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p>Remove Success!</p>");
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
    	sql = "DELETE FROM users WHERE user_name = ?";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, usrName);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p>Remove Success!</p>");
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
		out.println("<form method=get action=manage.jsp>");
		out.println("<input type=submit value=Return>");
		out.println("</form>");
		
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
	}
	else {
		out.println("You are not signed in.");
	}
%>
		</div>
	</BODY>
</HTML>
