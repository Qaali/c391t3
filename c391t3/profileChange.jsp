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
        	conn = DriverManager.getConnection(dbstring,"cwarkent","lotr0808pso");
			conn.setAutoCommit(false);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

		String fname = request.getParameter("firstname");
		String lname = request.getParameter("lastname");
		String addr = request.getParameter("address");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
    	
    	//select the user table from the underlying db and update persons
		Statement stmt = null;
    	ResultSet rset = null;
		String sql = "update persons set first_name = '"+fname+"', last_name = '"+lname+"', address = '"+addr+
					 "', email = '"+email+"', phone = '"+phone+"' where user_name = '"+session.getAttribute("name")+"'";
		out.println(sql+"<BR>");
		try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(sql);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}
    	
    	if(request.getParameter("checkpass") != null){
    		String oldpass = request.getParameter("oldpass");
    		String newpass = request.getParameter("newpass");
    		sql = "select password from users where user_name = '"+session.getAttribute("name")+"'";
			out.println(sql+"<BR>");
			try{
				stmt = conn.createStatement();
				rset = stmt.executeQuery(sql);
			}
			catch(Exception ex){
				out.println("<hr>" + ex.getMessage() + "<hr>");
			}
			
			String truepwd = "";
			while(rset != null && rset.next())
		   		truepwd = (rset.getString(1)).trim();
			if(oldpass.equals(truepwd)){
				sql = "update users set password = '"+newpass+"' where user_name = '"+session.getAttribute("name")+"'";
				out.println(sql+"<BR>");
				try{
					stmt = conn.createStatement();
					rset = stmt.executeQuery(sql);
				}
				catch(Exception ex){
					out.println("<hr>" + ex.getMessage() + "<hr>");
				}
			}
    	}
		
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
	}
%>
		<P>Edit Success</P>
		</div>
	</BODY>
</HTML>
