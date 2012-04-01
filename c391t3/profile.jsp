<%@ page import="java.sql.*" %>
<%
	String title = "Edit Profile";
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


    	//select the user table from the underlying db and validate the user name and password
    	String userName = (String) session.getAttribute("name");
		PreparedStatement stmt = null;
    	ResultSet rset = null;
		String sql = "select * from persons where user_name = ? ";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, userName);
	        rset = stmt.executeQuery();
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}

    	String truepwd = "";

		while(rset != null && rset.next()){
    		firstName = (rset.getString(2)).trim();
    		lastName = (rset.getString(3)).trim();
    		address = (rset.getString(4)).trim();
    		email = (rset.getString(5)).trim();
    		phone = (rset.getString(6)).trim();
		}
		
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
%>
		<P>Edit your profile below</P>
		
		<FORM NAME="ProfileForm" ACTION="profileChange.jsp" METHOD="post" >
		<TABLE>
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
				<TH COLSPAN=2>Change Password <INPUT TYPE="checkbox" NAME="checkpass" VALUE="yes"></TH>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Old Password:</TH>
				<TD><INPUT TYPE="password" NAME="oldpass"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>New Password:</TH>
				<TD><INPUT TYPE="password" NAME="newpass"></TD>
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
