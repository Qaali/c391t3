<!--A simple example to demonstrate how to use JSP to 
    connect and query a database. 
    @author  Hong-Yu Zhang, University of Alberta
 -->
<%@ page import="java.sql.*" %>
<% 
		boolean success = false;
		String errorString = "";
		String userName = "";
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
	        	//establish the connection 
		        conn = DriverManager.getConnection(dbstring,"cwarkent","lotr0808pso");
        		conn.setAutoCommit(false);
        	}
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
	        }


	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
        	String sql = "select password, class from users where user_name = '"+userName+"'";
	        //out.println(sql);
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}

	        String truepwd = "";
	        String type = "";
	
        	while(rset != null && rset.next()){
	        	truepwd = (rset.getString(1)).trim();
	        	type = (rset.getString(2)).trim();
        	}	
	
        	//display the result
	        if(passwd.equals(truepwd)){
	        	success = true;
	        	session.setAttribute("name", userName);
	        	session.setAttribute("classtype", type);
		        response.sendRedirect("main.jsp");
	        }
        	else
	        	errorString = "<p style=\"color: red\"><b>Either your userName or Your password is inValid!</b></p>";

        	try{
            	conn.close();
         	}
            catch(Exception ex){
           		out.println("<hr>" + ex.getMessage() + "<hr>");
            }
        }
        else if(request.getParameter("logout") != null){
        	session.invalidate();
        	session = request.getSession(true);
        }
        
        
        if (!success) {
%>
<HTML>
<HEAD>
<TITLE>CMPUT 391 Team 3 Login</TITLE>
</HEAD>

<BODY>
<!--This is the login page-->
<H1><CENTER>CMPUT 391 Team 3 Login</CENTER></H1>

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

<INPUT TYPE="submit" NAME="bSubmit" VALUE="LOGIN">
</FORM>

</BODY>
</HTML>
<%
        }      
%>