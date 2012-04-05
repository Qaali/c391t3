<%@ page import="java.sql.*" %>
<%
	String title = "Report Generating";
%>
<%@ include file="header.jsp" %>
<div id="main">
<%
	String usrName = "";
	String firstName = "";
	String lastName = "";
	String address = "";
	String email = "";
	String phone = "";
	String classname = "";

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

%>
		<P>To get the list of all patients with a specified diagnosis for a given time period</P>
		
		<FORM NAME="ProfileForm" ACTION="report_generate.jsp" METHOD="post" >
		<TABLE>
			<p>Time format: DD-MMM-YY</p>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Diagnosis:</TH>
				<TD><INPUT TYPE="text" NAME="diagnosis" ></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>FROM:</TH>
				<TD><INPUT TYPE="text" NAME="begin" ></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>TO:</TH>
				<TD><INPUT TYPE="text" NAME="end" ></TD>
			</TR>
		</TABLE>
		<INPUT TYPE="submit" NAME="pSubmit" VALUE="Submit">
		</FORM>		
<%
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