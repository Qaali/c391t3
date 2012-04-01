<%@ page import="java.sql.*" %>
<%
	String title = "User Management";
%>
<%@ include file="header.jsp" %>
<%
	String usrName = request.getParameter("name");
	String firstName = "";
	String lastName = "";
	String address = "";
	String email = "";
	String phone = "";
	String classname = "";
	Date date;
	
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
        	conn = DriverManager.getConnection(dbstring,"yiming7","a2188601Z");
			conn.setAutoCommit(false);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
    	}


    	//select the user table from the underlying db and validate the user name and password
		Statement stmt = null;
    	ResultSet rset = null;
		String sql = "select * from persons where user_name = '"+usrName+"'";
		try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(sql);
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
		
		String sql2 = "select * from users where user_name = '"+usrName+"'";
		
		try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(sql2);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
    	while(rset != null && rset.next()){
    		classname = (rset.getString(3)).trim();
    		//date = (rset.getDate(4));
    	}
    	
    	String sql3;
		if(classname=='d'){
    		sql3 = "select * from family_doctor where doctor_name = '"+usrName+"'";
		}else if(classname=='p'){
			sql3 = "select * from family_doctor where patient_name = '"+usrName+"'";
		}
		
		try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(sql3);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
    	while(rset != null && rset.next()){
    		classname = (rset.getString(3)).trim();
    		//date = (rset.getDate(4));
    	}
    	
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
	}
%>
		<div id="main">
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
				<TH>class:</TH>
				<TD><INPUT TYPE="text" NAME="classname" VALUE="<%= classname%>"></TD>
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
		</div>
	</BODY>
</HTML>