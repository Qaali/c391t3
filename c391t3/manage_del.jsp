<%@ page import="java.sql.*" %>
<%
	String title = "Delete doc/pat";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	if(session.getAttribute("name") != null && request.getParameter("pSubmit") != null){
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

		String doctor_name = request.getParameter("doctor_name");
		String patient_name = request.getParameter("patient_name");
		String classname = request.getParameter("class");

    	//select the user table from the underlying db and update persons
		PreparedStatement stmt = null;
    	//Statement stmt = null;
    	ResultSet rset = null;
    	
		String sql = "DELETE FROM family_doctor WHERE doctor_name = ? AND patient_name = ?";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, doctor_name);
    		stmt.setString(2, patient_name);
    		//out.println("<p>"+sql+"</p>");
    		//stmt = conn.createStatement();
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p>Delete Success!</p>");
	        if(classname.equals("d")){
				out.println("<form method=get action=manage2.jsp>");
				out.println("<input type=hidden name=name value="+doctor_name+">");
				out.println("<input type=submit value=Return>");
				out.println("</form>");
	        }else{
				out.println("<form method=get action=manage2.jsp>");
				out.println("<input type=hidden name=name value="+patient_name+">");
				out.println("<input type=submit value=Return>");
				out.println("</form>");
	        }
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
	else{
		out.println("You are not signed in.");
	}
%>
		</div>
	</BODY>
</HTML>
