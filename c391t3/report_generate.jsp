<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String title = "Report Generating";
%>
<%@ include file="header.jsp" %>
<div id="main">
<%
	String begin = request.getParameter("begin");
	String end = request.getParameter("end");
	String diagnosis = request.getParameter("diagnosis");
	String name = "";
	String address = "";
	String phone = "";
	String test_date = "";
	
	out.println("<h3>Here are the users have test of "+diagnosis+" during "+begin+" to "+end+".</h3>");

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
		PreparedStatement stmt = null;
    	ResultSet rset = null;
		String sql = "select p.user_name, p.address, p.phone, r.record_id, to_char(r.test_date, 'DD-MON-YYYY') as test_date from radiology_record r,persons p where r.patient_name = p.user_name and diagnosis= 'a' and test_date BETWEEN '12-JUN-89' and '17-JUN-89' ORDER BY record_id asc";
		sql =        "select p.user_name, p.address, p.phone, r.record_id, to_char(r.test_date, 'DD-MON-YYYY') as test_date from radiology_record r,persons p where r.patient_name = p.user_name and diagnosis = ? and test_date BETWEEN ? and ? ORDER BY record_id asc";
    	try{
    		stmt = conn.prepareStatement(sql);
    		stmt.setString(1, diagnosis);
    		stmt.setString(2, begin);
    		stmt.setString(3, end);
	        rset = stmt.executeQuery();
    	}
        catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

        ArrayList<String> list=new ArrayList<String>();
    	while(rset != null && rset.next()){
    		name = (rset.getString(1)).trim();
    		address = (rset.getString(2)).trim();
    		phone = (rset.getString(3)).trim();
    		test_date = (rset.getString(5)).trim();
    		if(list.contains(name)){
    			//do nothing
    		}else{
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

//		while(rset != null && rset.next()){

		//}
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
	}
%>
	</div>
	</BODY>
</HTML>