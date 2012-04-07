<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Add new user to database
-->
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	String title = "Add New User";
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

    	String userName = request.getParameter("userName");
		String fname = request.getParameter("firstname");
		String lname = request.getParameter("lastname");
		String addr = request.getParameter("address");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String password = request.getParameter("password");
		String classname = request.getParameter("classname");
    	
    	//select the user table from the underlying db and update persons
		PreparedStatement stmt = null;
    	ResultSet rset = null;
    	
    	String sql = "insert into users values(?, ?, ?, ?)";
		try{
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, userName);
			stmt.setString(2, password);
			stmt.setString(3, classname);
			
			Calendar currentDate = Calendar.getInstance();
			SimpleDateFormat formatter= 
			new SimpleDateFormat("dd/MMM/yy");
			String dateNow = formatter.format(currentDate.getTime());
			
			stmt.setString(4, dateNow);
			stmt.executeUpdate();
			conn.commit();
			out.println("<p style=\"color:green\">Added New User!</p>");
		}
		catch(Exception ex){
			out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}

    	
		sql = "insert into persons values(?, ?, ?, ?, ?, ?)";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, userName);
    		stmt.setString(2, fname);
    		stmt.setString(3, lname);
    		stmt.setString(4, addr);
    		stmt.setString(5, email);
    		stmt.setString(6, phone);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p style=\"color:green\">Added Personal Info Success!</p>");
		}
    	catch(Exception ex){
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}
    	
		out.println("<form method=get action=manage.jsp>");
		out.println("<input type=submit value=Return>");
		out.println("</form>");
		
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
