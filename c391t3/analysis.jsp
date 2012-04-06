<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String title = "Data Analysis ";
%>
<%@ include file="header.jsp" %>
<div id="main">
<%
	if(session.getAttribute("name") != null && request.getParameter("pSubmit") != null){
		%>
		<P>Get the number of images for each patient ,  test type, and/or period of time</P>
		
		<FORM NAME="ProfileForm" ACTION="analysis.jsp" METHOD="post" >
		<TABLE>
			<p>Cannot be all empty</p>
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
		</TABLE>
		<br>
		
		</br>
		<INPUT TYPE="submit" NAME="pSubmit" VALUE="Submit">
		</FORM>		
<%		
		
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

        String sql = "select SUM(m.recnum)";
        List myList = new ArrayList();
        
		if(request.getParameter("check_patient") != null){
			//out.println("yes patient");
			sql = sql+" ,m.patient_name";
			myList.add("Patient");
		}
		if(request.getParameter("check_test") != null){
			//out.println("yes type");
			sql = sql+" ,m.test_type";
			myList.add("Test Type");
		}
		if(!request.getParameter("mydropdown").equals("")){
			//out.println(request.getParameter("mydropdown"));
			if(request.getParameter("mydropdown").equals("Week")){
				sql = sql+", week from rec_week m group by m.week";
				myList.add("Week(WW-YYYY)");
			}else if(request.getParameter("mydropdown").equals("Month")){
				sql = sql+", month from rec_month m group by m.month";
				myList.add("Month(MMM-YYYY)");
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
//		out.println(sql);
//		out.println(myList.size());
//		out.println(myList.get(0));
		
		Statement stmt = null;
		ResultSet rset = null;
		
		try{
			stmt = conn.createStatement();
	    	rset = stmt.executeQuery(sql);
	    	
	        ResultSetMetaData rsmd = rset.getMetaData();
	        int colCount = rsmd.getColumnCount();
	        
	        out.println("<table id=\"border\"><tr>");
	        out.println("<th id=\"border\">Number</th>");
	        for (int j=0; j< myList.size(); j++) { 
				out.println("<th id=\"border\">"+myList.get(j)+"</th>");
	        }
	        out.println("</tr>");
	        
	       	while(rset != null && rset.next()){
	       		//out.println("!!!!!!!!!!!!!!!!");
	  			out.println("<tr>");
	  			for(int k=1;k<=colCount; k++) {
	  				out.println("<td id=\"border\">"+(rset.getString(k)).trim()+"</td>");
	  			}
	  			out.println("</tr>");
	       	}

			out.println("</table>");	
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
		
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
		
 
		
		
		
	}else if(session.getAttribute("name") != null && request.getParameter("pSubmit") == null){


    	//select the user table from the underlying db and validate the user name and password

%>
		<P>Get the number of images for each patient ,  test type, and/or period of time</P>
		
		<FORM NAME="ProfileForm" ACTION="analysis.jsp" METHOD="post" >
		<TABLE>
			<p>Cannot be all empty</p>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH COLSPAN=1>For each patient <INPUT TYPE="checkbox" NAME="check_patient" VALUE="yes"></TH>
				<TH COLSPAN=2>For each test type <INPUT TYPE="checkbox" NAME="check_test" VALUE="yes"></TH>
				<TH COLSPAN=2>Period:
				<select name="mydropdown">
				<option value=""></option>
				<option value="Week">week</option>
				<option value="Month">month</option>
				<option value="Year">year</option>
				</select>
				</TH>
			</TR>
		</TABLE>
		<br>
		
		</br>
		<INPUT TYPE="submit" NAME="pSubmit" VALUE="Submit">
		</FORM>		
<%
	}
%>
	</div>
	</BODY>
</HTML>