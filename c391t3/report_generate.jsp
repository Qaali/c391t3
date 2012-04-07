<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Display generated report
-->
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String title = "Report Findings";
%>
<%@ include file="header.jsp" %>
<div id="main">
<%
	//Initialize variables
	String begin = "";
	String end = "";
	String diagnosis = "";
	String name = "";
	String address = "";
	String phone = "";
	String test_date = "";
	
	if( request.getParameter("rSubmit") != null){
		begin = request.getParameter("begin");
		end = request.getParameter("end");
		diagnosis = request.getParameter("diagnosis");
	}
	
	boolean check = (begin.equals("") || end.equals("") || diagnosis.equals(""));	
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && classType.equals("a") && !check){
		//Display title
		out.println("<h3>Here are the users that have been diagnosed with "+diagnosis+" from "+begin+" to "+end+".</h3>");
    	
		//establish the connection to the underlying database
		Connection conn = null;
    	String driverName = "oracle.jdbc.driver.OracleDriver";
    	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    	try{
        	//load and register the driver
			Class drvClass = Class.forName(driverName); 
    		DriverManager.registerDriver((Driver) drvClass.newInstance());
    		//Check for custom database info
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

    	//query the database for any records that fit the form
		PreparedStatement stmt = null;
    	ResultSet rset = null;
		String sql = "select p.user_name, p.address, p.phone, r.record_id, to_char(r.test_date, 'DD-MON-YYYY') as test_date " +
			"from radiology_record r,persons p where r.patient_name = p.user_name and " +
			"r.diagnosis = ? and r.test_date BETWEEN ? and ? ORDER BY r.test_date asc";
    	try{
    		stmt = conn.prepareStatement(sql);
    		stmt.setString(1, diagnosis);
    		stmt.setString(2, begin);
    		stmt.setString(3, end);
	        rset = stmt.executeQuery();
    	}
        catch(Exception ex){
	        out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
    	}

        ArrayList<String> list=new ArrayList<String>();
    	while(rset != null && rset.next()){
    		name = (rset.getString(1)).trim();
    		address = (rset.getString(2)).trim();
    		phone = (rset.getString(3)).trim();
    		test_date = (rset.getString(5)).trim();
    		if(!list.contains(name)){
    			list.add(name);
    			%>
    			<TABLE>
    			<TR VALIGN=TOP ALIGN=LEFT>
    				<TH>Patient Name:</TH>
    				<TD><%=name%></TD>
    			</TR>
    			<TR VALIGN=TOP ALIGN=LEFT>
    				<TH>Address:</TH>
    				<TD><%=address%></TD>
    			</TR>
    			<TR VALIGN=TOP ALIGN=LEFT>
    				<TH>Phone:</TH>
    				<TD><%=phone%></TD>
    			</TR>
    			<TR VALIGN=TOP ALIGN=LEFT>
    				<TH>Test Date:</TH>
    				<TD><%=test_date%></TD>
    			</TR>
    			</TABLE>
    			<p>_________________________________________</p>
    			<%
    		}
    	}	
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
        }
	}
	else if(session.getAttribute("name") != null && classType.equals("a") && check){
		out.println("<p style=\"color:red\">You failed to complete the form</p>");
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