<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String title = "Search Results";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	if(session.getAttribute("name") != null && request.getParameter("sSubmit") != null){
    	if(request.getParameter("order").equals("Rank") && request.getParameter("keywords").equals("")){
    		out.println("<hr>To order by rank, you must give a keyword!<hr>");
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

    		//Update indices on radiology_record
    		//try{
    		//	Statement indexStmt = conn.createStatement();
    		//	indexStmt.executeUpdate("alter index pat_index rebuild");
    		//	indexStmt.executeUpdate("alter index diag_index rebuild");
    		//	indexStmt.executeUpdate("alter index desc_index rebuild");
    		//	conn.commit();
    		//}
    		//catch(Exception ex){
        	//	out.println("<hr>" + ex.getMessage() + "<hr>");
			//}
    	
    		//select score(1), score(2), score(3), score(1)*6 + score(2)*3 + score(3) as rank, record_id from radiology_record where 
    		//contains(patient_name, ?, 1) >= 0 and contains(diagnosis, ?, 2) >= 0 and contains(description, ?, 3) >= 0 ORDER BY rank DESC;
    		String sql = "select ";
    		String startDate = request.getParameter("startdate");
    		String endDate = request.getParameter("enddate");
    		String keywords = request.getParameter("keywords");
    	    	
    		ArrayList<String> clauses = new ArrayList<String>();
    		if(!startDate.equals(""))
    			clauses.add("test_date >= ? ");
    		if(!endDate.equals(""))
    			clauses.add("test_date <= ? ");
    		if(!keywords.equals(""))    			
    			clauses.add("contains(patient_name, ?, 1) >= 0 and contains(diagnosis, ?, 2) >= 0 "+
    						"and contains(description, ?, 3) >= 0 ");

    		String userName = (String) session.getAttribute("name");
			String classtype = (String) session.getAttribute("classtype");
			if(classtype.equals("r"))
				clauses.add("radiologist_name = ? ");
			else if(classtype.equals("d"))
				clauses.add("? IN (SELECT doctor_name from family_doctor d where d.patient_name = patient_name) ");
			else if(classtype.equals("p"))
				clauses.add("patient_name = ? ");
    		
    		String orderBy = "";
    		if(request.getParameter("order").equals("Rank")){
    			String score = "score(1)*6 + score(2)*3 + score(3) as rank, ";
    			sql = sql.concat(score);
    			orderBy = "rank DESC";
    		}
    		else if(request.getParameter("order").equals("Most-Recent-First"))
    			orderBy = "test_date DESC";
    		else if(request.getParameter("order").equals("Most-Recent-Last"))
    			orderBy = "test_date ASC";
    	
    		String start = "record_id, patient_name, test_date, diagnosis from radiology_record ";
			sql = sql.concat(start);
			
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
			out.println("<hr>" + sql + "<hr>");
			
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

	        	rset = stmt.executeQuery();
	            ResultSetMetaData rsmd = rset.getMetaData();
	            int colCount = rsmd.getColumnCount();
	            out.println("<table id=\"border\"><tr>");
	            for (int j=1; j<= colCount; j++) { 
					out.println("<th id=\"border\">"+rsmd.getColumnName(j)+"</th>");
	            }
	            out.println("<tr>");
	            
	           	while(rset != null && rset.next()){
	           		if(!(request.getParameter("order").equals("Rank") && rset.getInt(1) == 0)){
	           			out.println("<tr>");
	           			for(int k=1;k<=colCount; k++) {
	           				out.println("<td id=\"border\">"+(rset.getString(k)).trim()+"</td>");
	           			}
	           			out.println("</tr>");
	           		}
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
    	}
	}
	else{
		out.println("You are not signed in.");
	}
%>
		</div>
	</BODY>
</HTML>
