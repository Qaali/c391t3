<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Display user information form to update info
 		and to add or delete doctors/patients
-->
<%@ page import="java.sql.*" %>
<%
	String title = "User Management";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	String firstName = "";
	String lastName = "";
	String address = "";
	String email = "";
	String phone = "";
	String password = "";
	String date = "";
	String[] list;
	list = new String[32];
	int size = 0;
	
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && request.getParameter("uSubmit") != null && classType.equals("a")){
		String classname = request.getParameter("classname");
		String usrName = request.getParameter("name");
		
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


    	//Get the user information form the persons table 
		PreparedStatement stmt = null;
    	ResultSet rset = null;
		String sql = "select * from persons where user_name = ?";
		try{
    		stmt = conn.prepareStatement(sql);
    		stmt.setString(1, usrName);
        	rset = stmt.executeQuery();
		}
    	catch(Exception ex){
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}


		while(rset != null && rset.next()){
    		firstName = (rset.getString(2)).trim();
    		lastName = (rset.getString(3)).trim();
    		address = (rset.getString(4)).trim();
    		email = (rset.getString(5)).trim();
    		phone = (rset.getString(6)).trim();
		}
		
		String sql2 = "select password, class, to_char(date_registered, 'DD-MON-YYYY') as test_date "+
			"from users where user_name = ?";
		
		try{    		
			stmt = conn.prepareStatement(sql2);
			stmt.setString(1, usrName);
    		rset = stmt.executeQuery();
		}
    	catch(Exception ex){
        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
		}
    	
    	while(rset != null && rset.next()){
    		password = (rset.getString(1)).trim();
    		classname = (rset.getString(2)).trim();
    		date = (rset.getString(3)).trim();
    	}
    	%>
		<P>Edit user info below</P>
		
		<FORM NAME="ProfileForm" ACTION="manage_change.jsp" METHOD="post" >
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
				<TH>Password:</TH>
				<TD><INPUT TYPE="text" NAME="password" VALUE="<%= password%>"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Registered Date:</TH>
				<TD><%= date%></TD>
			</TR>
		</TABLE>
		<INPUT TYPE=hidden NAME=usrName VALUE="<%= usrName%>">
		<INPUT TYPE="submit" NAME="pSubmit" VALUE="Edit">
		</FORM>
    	<%
    	String sql3 = "";
		if(classname.equals("d")){
    		sql3 = "select * from family_doctor where doctor_name = ?";
		}else if(classname.equals("p")){
			sql3 = "select * from family_doctor where patient_name = ?";
		}
		
		if(!(sql3.equals(""))){
			try{			
				stmt = conn.prepareStatement(sql3);
				stmt.setString(1, usrName);
    			rset = stmt.executeQuery();
			}
	    	catch(Exception ex){
	        	out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
			}
	    	if(classname.equals("d")){
	    		out.println("<h3>Here are the patients list:</h3>");
		    	while(rset != null && rset.next()){
		    		list[size] = (rset.getString(2)).trim();
		    		size++;
		    	}
	    	}else{
	    		out.println("<h3>Here are the familiy_doctor list:</h3>");
		    	while(rset != null && rset.next()){
		    		list[size] = (rset.getString(1)).trim();
		    		size++;
		    	}
	    	}
	    	for(int i=0;i<size;i++){
	    	    if(classname.equals("d")){
		    	    %>
		    	    <FORM NAME="DeleteForm" ACTION="manage_del.jsp" METHOD="post" >
		    		<INPUT TYPE=hidden NAME=doctor_name VALUE="<%= usrName%>">
		    		<INPUT TYPE=hidden NAME=patient_name VALUE="<%= list[i]%>">
		    		<INPUT TYPE=hidden NAME=class VALUE="<%=classname%>">
		    		<%=list[i]%> <INPUT TYPE="submit" NAME="pSubmit" VALUE="Delete">
		    		</FORM>
		    		<%
	    	    }else{
		    	    %>
			    	<FORM NAME="DeleteForm" ACTION="manage_del.jsp" METHOD="post" >    	    
		    		<INPUT TYPE=hidden NAME=doctor_name VALUE="<%= list[i]%>">
		    		<INPUT TYPE=hidden NAME=patient_name VALUE="<%= usrName%>">
		    		<INPUT TYPE=hidden NAME=class VALUE="<%=classname%>">
		    		<%=list[i]%> <INPUT TYPE="submit" NAME="pSubmit" VALUE="Delete">
		    		</FORM>
		    		<%    	    	
	    	    }
	    	}
			try{
	        	conn.close();
	     	}
	        catch(Exception ex){
	       		out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
	        }
	        if(classname.equals("d")){
	        	%>
	        	<FORM NAME="ProfileForm" ACTION="manage_add.jsp" METHOD="post" >
	        	<INPUT TYPE="text" NAME="patient_name">
	        	<INPUT TYPE=hidden NAME=doctor_name VALUE="<%= usrName%>">
	        	<INPUT TYPE=hidden NAME=class VALUE="<%= classname%>">
	        	<INPUT TYPE="submit" NAME="pSubmit" VALUE="add patient">
	        	</FORM>
	        	<%
	        }else{
	        	%>
	        	<FORM NAME="ProfileForm" ACTION="manage_add.jsp" METHOD="post" >
	        	<INPUT TYPE="text" NAME="doctor_name">
	        	<INPUT TYPE=hidden NAME=patient_name VALUE="<%= usrName%>">
	        	<INPUT TYPE=hidden NAME=class VALUE="<%= classname%>">
	        	<INPUT TYPE="submit" NAME="pSubmit" VALUE="add doctor">
	        	</FORM>
	        	<%
	        }
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
