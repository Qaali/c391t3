<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Perform the search with proper permissions and ranking
-->
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String title = "Search Results";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	// Check if form submitted
	if(session.getAttribute("name") != null && request.getParameter("sSubmit") != null){
		//If order by rank, keywords must be used
    	if(request.getParameter("order").equals("Rank") && request.getParameter("keywords").equals("")){
    		out.println("<p style=\"color:red\">To order by rank, you must give a keyword!</p>");
    	}
    	else{
    		//establish the connection to the underlying database
			Connection conn = null;
    		String driverName = "oracle.jdbc.driver.OracleDriver";
    		String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    		try{
        		//load and register the driver
				Class drvClass = Class.forName(driverName); 
    			DriverManager.registerDriver((Driver) drvClass.newInstance());
    			//Check for custom database login
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
    	
    		//The start of the sql query
    		String sql = "select ";
    		String startDate = request.getParameter("startdate");
    		String endDate = request.getParameter("enddate");
    		String keywords = request.getParameter("keywords");
    	    	
    		//List of clauses for WHERE section
    		ArrayList<String> clauses = new ArrayList<String>();
    		//Add start and end date clauses
    		if(!startDate.equals(""))
    			clauses.add("test_date >= ? ");
    		if(!endDate.equals(""))
    			clauses.add("test_date <= ? ");
    		if(!keywords.equals("")){ 	
    			//Add CONTAINS and SCRORE for rankings
    			clauses.add("contains(r.patient_name, ?, 1) >= 0 and contains(r.diagnosis, ?, 2) >= 0 "+
    						"and contains(r.description, ?, 3) >= 0 ");
    			String score = "score(1)*6 + score(2)*3 + score(3) as rank, ";
    			sql = sql.concat(score);
    		}

    		//Add extra clause depending on user class
    		String userName = (String) session.getAttribute("name");
			String classtype = (String) session.getAttribute("classtype");
			if(classtype.equals("r"))
				clauses.add("r.radiologist_name = ? ");
			else if(classtype.equals("d"))
				clauses.add("? IN (SELECT d.doctor_name from family_doctor d where d.patient_name = r.patient_name) ");
			else if(classtype.equals("p"))
				clauses.add("r.patient_name = ? ");
    		
			//Add ordering
    		String orderBy = "";
    		if(request.getParameter("order").equals("Rank"))
    			orderBy = "rank DESC";
    		else if(request.getParameter("order").equals("Most-Recent-First"))
    			orderBy = "r.test_date DESC";
    		else if(request.getParameter("order").equals("Most-Recent-Last"))
    			orderBy = "r.test_date ASC";
    	
    		//Columns for table
    		String start = "r.record_id, r.patient_name, r.doctor_name, r.radiologist_name, r.test_type, "+
    			"to_char(r.prescribing_date, 'DD-MON-YYYY') as prescribing_date, to_char(r.test_date, 'DD-MON-YYYY') as test_date, "+
    			"r.diagnosis, r.description from radiology_record r ";
			sql = sql.concat(start);
			
			//Add in clauses to query
			boolean first = true;
			for (String value : clauses){
				if(first){
					first = false;
					sql = sql.concat("WHERE "+ value);
				}
				else
					sql = sql.concat(" AND "+ value);
			}		
			sql = sql.concat("ORDER BY "+orderBy);
			
			//Set up prepared statement
			PreparedStatement stmt = null;
    		ResultSet rset = null;
			try{
				stmt = conn.prepareStatement(sql);
				int i = 1;
				if(!startDate.equals(""))
					stmt.setString(i++, startDate);
	    		if(!endDate.equals(""))
	    			stmt.setString(i++, endDate);
	    		if(!keywords.equals("")){
	    			stmt.setString(i++, keywords);
	    			stmt.setString(i++, keywords);
	    			stmt.setString(i++, keywords);
	    		}
	    		if(!classtype.equals("a"))
	    			stmt.setString(i++, userName);

	    		//Get table column titles
	        	rset = stmt.executeQuery();
	            ResultSetMetaData rsmd = rset.getMetaData();
	            int colCount = rsmd.getColumnCount();
	            int loop = 1;
	            if(!keywords.equals(""))
	            	loop = 2;
	            out.println("<table id=\"border\"><tr>");
	            for (int j=loop; j<= colCount; j++) { 
					out.println("<th id=\"border\">"+rsmd.getColumnName(j)+"</th>");
	            }
	            out.println("<tr>");
	            
	            //Print rows
	           	while(rset != null && rset.next()){
	           		if(!(!keywords.equals("") && rset.getInt(1) == 0)){
	           			int recid = 2;
	           			if(keywords.equals(""))
	           				recid = 1;
	           			out.println("<tr>");
	           			for(int k=loop;k<=colCount; k++) {
	           				out.println("<td id=\"border\">"+(rset.getString(k)).trim()+"</td>");
	           			}
	           			out.println("</tr>");
	           			
	           			//Print pictures corresponding to row
	           			Statement picStmt = conn.createStatement();
	           			String pquery = "select image_id from pacs_images where record_id = "+rset.getString(recid);
	           			ResultSet picset = picStmt.executeQuery(pquery);
	           			if(picset != null && picset.next()){
	           				out.println("<tr><td COLSPAN="+colCount+">Images for record_id "+rset.getString(recid)+":");
	           				String end = "rec="+rset.getString(recid)+"&pic="+picset.getString(1);
           					out.println("<a href=\"GetOnePic?size=full&"+end+"\" target=\"_blank\">");
           					out.println("<img src=\"GetOnePic?"+end+"\" height=\"45\" width=\"60\"></a>");
	           				while(picset.next()){
	           					end = "rec="+rset.getString(recid)+"&pic="+picset.getString(1);
	           					out.println("<a href=\"GetOnePic?size=full&"+end+"\" target=\"_blank\">");
	           					out.println("<img src=\"GetOnePic?"+end+"\" height=\"45\" width=\"60\"></a>");
	           				}
	           				out.println("</td></tr>");
	           			}
	           		}
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
	else{
		out.println("<p style=\"color:red\">You are not signed in.</p>");
	}
%>
		</div>
	</BODY>
</HTML>
