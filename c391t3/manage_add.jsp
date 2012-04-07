<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Add family_doctor doc/pat pair to database
-->
<%@ page import="java.sql.*" %>
<%
	String title = "Add Doc/Pat";
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
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
    	}

		String doctor_name = request.getParameter("doctor_name");
		String patient_name = request.getParameter("patient_name");
		String classname = request.getParameter("class");
		
    	//select the user table from the underlying db and update persons
		PreparedStatement stmt = null;
    	ResultSet rset = null;
    	
    	//Check if doctor and patient are valid
    	boolean valid = false;
    	try{
    		stmt = conn.prepareStatement("SELECT user_name FROM users WHERE user_name=? AND class='d'");
    		stmt.setString(1, doctor_name);
    		rset = stmt.executeQuery();
    		if(rset !=null && rset.next()){
    			stmt = conn.prepareStatement("SELECT user_name FROM users WHERE user_name=? AND class='p'");
        		stmt.setString(1, patient_name);
        		rset = stmt.executeQuery();
        		if(rset !=null && rset.next())
        			valid = true;
    		}
    	}
    	catch(Exception ex){
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}  	
    	
    	//If input is valid, insert row into family doctor table
    	if(valid){
			String sql = "insert into family_doctor values(?,?)";
			try{
				stmt = conn.prepareStatement(sql);
    			stmt.setString(1, doctor_name);
    			stmt.setString(2, patient_name);
	        	stmt.executeUpdate();
	        	conn.commit();
	        	out.println("<p style=\"color:green\">Add Success!</p>");
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
    	}
    	else
    		out.println("<p style=\"color:red\">doctor or patient is not valid</p>");
	    	
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
