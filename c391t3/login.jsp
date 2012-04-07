<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Validate login for database website
-->
<%@ page import="java.sql.*" %>
<% 
		boolean success = false;
		String errorString = "";
		String userName = "";
		//Check if form submitted
        if(request.getParameter("bSubmit") != null) {
	        //get the user input from the login page
        	userName = (request.getParameter("USERID")).trim();
	        String passwd = (request.getParameter("PASSWD")).trim();
	        //establish the connection to the underlying database
        	Connection conn = null;
	        String driverName = "oracle.jdbc.driver.OracleDriver";
            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	        try{
		        //load and register the driver
        		Class drvClass = Class.forName(driverName); 
	        	DriverManager.registerDriver((Driver) drvClass.newInstance());
	        	//Check for custom database connection
	        	if(request.getParameter("checkdb") != null){
	        		String dbUser = (request.getParameter("DBUSER")).trim();
	        		String dbPass = (request.getParameter("DBPASS")).trim();
			        conn = DriverManager.getConnection(dbstring, dbUser, dbPass);
	        	}
	        	else
			        conn = DriverManager.getConnection(dbstring,"cwarkent","lotr0808pso");
        		conn.setAutoCommit(false);
        	}
	        catch(Exception ex){
		        out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
	        }

	        if(conn != null){
	        	//select the user table from the underlying db and validate the user name and password
        		PreparedStatement stmt = null;
	        	ResultSet rset = null;
        		String sql = "select password, class from users where user_name = ? ";
        		try{
        			stmt = conn.prepareStatement(sql);
        			stmt.setString(1, userName);
		        	rset = stmt.executeQuery();
        		}
	        	catch(Exception ex){
		        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
        		}

	        	//Check password using sample code from Li-Yan Yuan
	        	String truepwd = "";
	        	String type = "";
        		while(rset != null && rset.next()){
	        		truepwd = (rset.getString(1)).trim();
	        		type = (rset.getString(2)).trim();
        		}	
	
        		//If password is correct, save information in session
	        	if(passwd.equals(truepwd)){
	        		success = true;
	        		session.setAttribute("name", userName);
	        		session.setAttribute("classtype", type);
	        		if(request.getParameter("checkdb") != null){
	        			String dbUser = (request.getParameter("DBUSER")).trim();
	        			String dbPass = (request.getParameter("DBPASS")).trim();
	        			session.setAttribute("dbuser", dbUser);
	        			session.setAttribute("dbpass", dbPass);
	        		}
		        	response.sendRedirect("main.jsp");
	        	}
        		else
	        		errorString = "<p style=\"color: red\">Either your userName or Your password is inValid!</p>";

        		try{
            		conn.close();
         		}
            	catch(Exception ex){
           			out.println("<p style=\"color: red\">" + ex.getMessage() + "</p>");
            	}
	        }
        }
		//If logging out, invalidate cookie
        else if(request.getParameter("logout") != null){
        	session.invalidate();
        	session = request.getSession(true);
        }
		
        //If login failed, redisplay the login form
        if (!success) {
%>
<HTML>
<HEAD>
<TITLE>CMPUT 391 Team 3  Radiology Database Login</TITLE>
</HEAD>

<BODY>
<!--This is the login page-->
<H1><CENTER>Radiology Database Login</CENTER></H1>
<h3 style="text-align:center; margin-top:0px">CMPUT 391 Team 3 - Colby Warkentin, Yiming Liu</h3>

<FORM NAME="LoginForm" ACTION="login.jsp" METHOD="post" >

<%= errorString %>
<P>Please submit a valid username and password</P>
<TABLE>
	<TR VALIGN=TOP ALIGN=LEFT>
		<TH>Userid:</TH>
		<TD><INPUT TYPE="text" NAME="USERID" VALUE="<%= userName %>"></TD>
	</TR>
	<TR VALIGN=TOP ALIGN=LEFT>
		<TH>Password:</TH>
		<TD><INPUT TYPE="password" NAME="PASSWD"></TD>
	</TR>
</TABLE>

<BR><P>Use a different Database <INPUT TYPE="checkbox" NAME="checkdb" VALUE="yes"></P>
<TABLE>
	<TR VALIGN=TOP ALIGN=LEFT>
		<TH>UserName:</TH>
		<TD><INPUT TYPE="text" NAME="DBUSER"></TD>
	</TR>
	<TR VALIGN=TOP ALIGN=LEFT>
		<TH>Password:</TH>
		<TD><INPUT TYPE="password" NAME="DBPASS"></TD>
	</TR>
</TABLE>

<INPUT TYPE="submit" NAME="bSubmit" VALUE="LOGIN">
</FORM>

</BODY>
</HTML>
<%
        }      
%>