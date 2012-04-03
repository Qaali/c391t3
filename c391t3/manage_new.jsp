<%@ page import="java.sql.*" %>
<%
	String title = "Add new user";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%

	String firstName = "";
	String lastName = "";
	String address = "";
	String email = "";
	String phone = "";

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
%>
		<P>Add one new user: </P>
		
		<FORM NAME="ProfileForm" ACTION="manage_new2.jsp" METHOD="post" >
		<TABLE>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Account Name:</TH>
				<TD><INPUT TYPE="text" NAME="userName" VALUE=""></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Account type:</TH>
				<TD><INPUT TYPE="text" NAME="classname" VALUE=""></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>First Name:</TH>
				<TD><INPUT TYPE="text" NAME="firstname" VALUE="<%= firstName%>"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Last Name:</TH>
				<TD><INPUT TYPE="text" NAME="lastname" VALUE="<%= lastName%>"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Address:</TH>
				<TD><INPUT TYPE="text" NAME="address" VALUE="<%= address%>"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Email:</TH>
				<TD><INPUT TYPE="text" NAME="email" VALUE="<%= email%>"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Phone Number:</TH>
				<TD><INPUT TYPE="text" NAME="phone" VALUE="<%= phone%>"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Password:</TH>
				<TD><INPUT TYPE="password" NAME="password"></TD>
			</TR>
		</TABLE>

		<INPUT TYPE="submit" NAME="pSubmit" VALUE="Submit">
		</FORM>		
<%
	}
	else {
		out.println("You are not signed in.");
	}
%>
		</div>
	</BODY>
</HTML>
