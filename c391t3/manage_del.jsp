<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Delete row from family_doctor table
-->
<%@ page import="java.sql.*" %>
<%
	String title = "Delete Family Doctor";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && request.getParameter("pSubmit") != null && classType.equals("a")){
    	//establish the connection to the underlying database
		Connection conn = null;

    	String driverName = "oracle.jdbc.driver.OracleDriver";
    	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

    	try{
        	//load and register the driver
			Class drvClass = Class.forName(driverName); 
    		DriverManager.registerDriver((Driver) drvClass.newInstance());
    		//Check for custom database signin
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
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
    	}

		String doctor_name = request.getParameter("doctor_name");
		String patient_name = request.getParameter("patient_name");
		String classname = request.getParameter("class");

    	//delete the corresponding patient/doctor row in family_doctor
		PreparedStatement stmt = null;
    	ResultSet rset = null;
		String sql = "DELETE FROM family_doctor WHERE doctor_name = ? AND patient_name = ?";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, doctor_name);
    		stmt.setString(2, patient_name);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p style=\"color:green\">Delete Success!</p>");
	        if(classname.equals("d")){
				out.println("<form method=get action=manage2.jsp>");
				out.println("<input type=hidden name=name value="+doctor_name+">");
				out.println("<input type=submit name=uSubmit value=Return>");
				out.println("</form>");
	        }else{
				out.println("<form method=get action=manage2.jsp>");
				out.println("<input type=hidden name=name value="+patient_name+">");
				out.println("<input type=submit name=uSubmit value=Return>");
				out.println("</form>");
	        }
		}
    	catch(Exception ex){
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}
	    	
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
        }
	}
	else if(session.getAttribute("name") != null){
		out.println("<p style=\"color:red\">You are not an admin.</p>");
	}
	else {
		out.println("<p style=\"color:red\">You are not signed in.</p>");
	}
%>
		</div>
	</BODY>
</HTML>
