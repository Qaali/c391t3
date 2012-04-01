<%@ page import="java.sql.*" %>
<%
	String title = "Edit Profile";
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

    	String userName = (String) session.getAttribute("name");
		String fname = request.getParameter("firstname");
		String lname = request.getParameter("lastname");
		String addr = request.getParameter("address");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
    	
    	//select the user table from the underlying db and update persons
		PreparedStatement stmt = null;
    	ResultSet rset = null;
		String sql = "update persons set first_name = ?, last_name = ?, address = ?,"+
					 " email = ?, phone = ? where user_name = ? ";
		try{
			stmt = conn.prepareStatement(sql);
    		stmt.setString(1, fname);
    		stmt.setString(2, lname);
    		stmt.setString(3, addr);
    		stmt.setString(4, email);
    		stmt.setString(5, phone);
    		stmt.setString(6, userName);
	        stmt.executeUpdate();
	        conn.commit();
	        out.println("<p>Edit Success!</p>");
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
    	if(request.getParameter("checkpass") != null){
    		String oldpass = (request.getParameter("oldpass")).trim();
    		String newpass = (request.getParameter("newpass")).trim();
    		sql = "select password from users where user_name = ? ";
			try{
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, userName);
				rset = stmt.executeQuery();
			}
			catch(Exception ex){
				out.println("<hr>" + ex.getMessage() + "<hr>");
			}
			
			String truepwd = "";
			while(rset != null && rset.next())
		   		truepwd = (rset.getString(1)).trim();
			if(oldpass.equals(truepwd)){
				sql = "update users set password = ? where user_name = ? ";
				try{
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, newpass);
					stmt.setString(2, userName);
					stmt.executeUpdate();
					conn.commit();
					out.println("<p>Password Change Successful!</p>");
				}
				catch(Exception ex){
					out.println("<hr>" + ex.getMessage() + "<hr>");
				}
			}
			else {
				out.println("<p>Old Password Incorrect.</p>");
			}
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
