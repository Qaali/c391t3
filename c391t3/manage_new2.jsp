<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	String title = "Edit user info";
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

    	String userName = request.getParameter("userName");
		String fname = request.getParameter("firstname");
		String lname = request.getParameter("lastname");
		String addr = request.getParameter("address");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String password = request.getParameter("password");
		String classname = request.getParameter("classname");
    	
    	//select the user table from the underlying db and update persons
		PreparedStatement stmt = null;
    	ResultSet rset = null;
    	
    	String sql = "insert into users values(?, ?, ?, ?)";
		try{
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, userName);
			stmt.setString(2, password);
			stmt.setString(3, classname);
			
			Calendar currentDate = Calendar.getInstance();
			SimpleDateFormat formatter= 
			new SimpleDateFormat("dd/MMM/yy");
			String dateNow = formatter.format(currentDate.getTime());
			
			stmt.setString(4, dateNow);
			stmt.executeUpdate();
			conn.commit();
			out.println("<p>Password Change Successful!</p>");
		}
		catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}

    	
		sql = "insert into persons values(?, ?, ?, ?, ?, ?)";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, userName);
    		stmt.setString(2, fname);
    		stmt.setString(3, lname);
    		stmt.setString(4, addr);
    		stmt.setString(5, email);
    		stmt.setString(6, phone);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p>Edit Success!</p>");
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
		out.println("<form method=get action=manage.jsp>");
		out.println("<input type=submit value=Return>");
		out.println("</form>");
		
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
