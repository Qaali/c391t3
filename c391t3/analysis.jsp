<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Display OLAP data
-->
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String title = "Data Analysis ";
%>
<%@ include file="header.jsp" %>
<div id="main">
<%
	//Make sure user is admin
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && classType.equals("a")){
		%>
		<P>Get the number of records for each patient, test type, and/or period of time</P>
		
		<FORM NAME="AnalysisForm" ACTION="analysis.jsp" METHOD="post" >
		<TABLE>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH COLSPAN=1>Group by patient <INPUT TYPE="checkbox" NAME="check_patient" VALUE="yes"></TH>
				<TH COLSPAN=2>Group by test type <INPUT TYPE="checkbox" NAME="check_test" VALUE="yes"></TH>
				<TH COLSPAN=2>Group by Period:
				<select name="mydropdown">
				<option value=""></option>
				<option value="Week">week</option>
				<option value="Month">month</option>
				<option value="Year">year</option>
				</select>
				</TH>
			</TR>
			<TR>
				<td COLSPAN=5><p style="margin:0px">*Cannot be all empty</p></td>
			</TR>
		</TABLE>
		</br>
		<INPUT TYPE="submit" NAME="aSubmit" VALUE="Submit">
		</FORM>		
<%		
		if(request.getParameter("aSubmit") != null){
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

    		//Create sql query
        	String sql = "select SUM(m.recnum)";
        	List myList = new ArrayList();   
			if(request.getParameter("check_patient") != null){
				sql = sql+" ,m.patient_name";
				myList.add("Patient");
			}
			if(request.getParameter("check_test") != null){
				sql = sql+" ,m.test_type";
				myList.add("Test Type");
			}
			if(!request.getParameter("mydropdown").equals("")){
				if(request.getParameter("mydropdown").equals("Week")){
					sql = sql+", week from rec_week m group by m.week";
					myList.add("Week(WW-YYYY)");
				}else if(request.getParameter("mydropdown").equals("Month")){
					sql = sql+", month from rec_month m group by m.month";
					myList.add("Month(MON-YYYY)");
				}else{
					sql = sql+", d.Year from rec_month m, rec_date d where m.Month = d.Month group by d.Year";
					myList.add("Year(YYYY)");
				}
			
				if(request.getParameter("check_patient") != null){
					sql = sql+" ,m.patient_name";
				}
				if(request.getParameter("check_test") != null){
					sql = sql+" ,m.test_type";
				}
			}else{
				sql = sql+" from rec_week m group by ";
				boolean first = true;
				if(request.getParameter("check_patient") != null){
					if(first){
						sql = sql+" m.patient_name";
						first = false;
					}else{
						sql = sql+" ,m.patient_name";	
					}
				}
				if(request.getParameter("check_test") != null){
					if(first){
						sql = sql+" m.test_type";
						first = false;
					}else{
						sql = sql+" ,m.test_type";				
					}
				}
			}
//			out.println(sql);
//			out.println(myList.size());
//			out.println(myList.get(0));
		
			Statement stmt = null;
			ResultSet rset = null;
		
			try{
				stmt = conn.createStatement();
	    		rset = stmt.executeQuery(sql);
	    	
	        	ResultSetMetaData rsmd = rset.getMetaData();
	        	int colCount = rsmd.getColumnCount();
	        
	        	out.println("<table id=\"border\"><tr>");
	        	out.println("<th id=\"border\">Number of Record</th>");
	        	for (int j=0; j< myList.size(); j++) { 
					out.println("<th id=\"border\">"+myList.get(j)+"</th>");
	        	}
	        	out.println("</tr>");
	        
	       		while(rset != null && rset.next()){
	  				out.println("<tr>");
	  				for(int k=1;k<=colCount; k++) {
	  					out.println("<td id=\"border\">"+(rset.getString(k)).trim()+"</td>");
	  				}
	  				out.println("</tr>");
	       		}

				out.println("</table>");	
			}
    		catch(Exception ex){
        		out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
			}
		
			try{
        		conn.close();
     		}
        	catch(Exception ex){
       			out.println("<p style=\"color:red\">" + ex.getMessage() + "</p>");
        	}
		
		}
	}
	else if(session.getAttribute("name") != null){
		out.println("<p style=\"color:red\">You are not an admin.</p>");
	}
	else{
		out.println("<p style=\"color:red\">You are not signed in.</p>");
	}
%>
	</div>
	</BODY>
</HTML>