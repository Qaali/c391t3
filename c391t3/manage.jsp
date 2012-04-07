<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Display users to edit or add
-->
<%@ page import="java.sql.*" %>
<%
	String title = "User Management";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	String usrName = "";
	String classname = "";
	
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && classType.equals("a")){
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


    	//select the user table from the underlying db and validate the user name and password
		Statement stmt = null;
    	ResultSet rset = null;
		String sql = "select * from users";
		try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(sql);
		}
    	catch(Exception ex){
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}

    	out.println("<p3><b>Click to add a new user:<b></p3>");
		out.println("<TR VALIGN=TOP ALIGN=LEFT><TH>");
		out.println("<form method=get action=manage_new.jsp>");
		out.println("<input type=hidden name=name value="+usrName+">");
		out.println("<input type=submit value=\"add new user\">");
		out.println("</form>");
		out.println("</TH></TR>");
    	
    	
    	out.println("<h3>Radiology Database Users:</h3>");
    	out.println("<TABLE>");
		while(rset != null && rset.next()){
			usrName = (rset.getString(1)).trim();
			classname = (rset.getString(3)).trim();
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TH>");
			out.println("<form method=get action=manage2.jsp>");
			out.println(usrName+"<input type=hidden name=name value="+usrName+">");
			out.println("<input type=hidden name=classname value="+classname+">");
			out.println("<input type=submit name=\"uSubmit\" value=\"view>\"");
			out.println("</form>");
			out.println("</TH></TR>");
		}
		out.println("</TABLE>");
		
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