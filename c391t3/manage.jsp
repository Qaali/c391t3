<%@ page import="java.sql.*" %>
<%
	String title = "User Management";
%>
<%@ include file="header.jsp" %>
<%
	String usrName = "";
	String firstName = "";
	String lastName = "";
	String address = "";
	String email = "";
	String phone = "";

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
        	conn = DriverManager.getConnection(dbstring,"yiming7","a2188601Z");
			conn.setAutoCommit(false);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
    	}


    	//select the user table from the underlying db and validate the user name and password
		Statement stmt = null;
    	ResultSet rset = null;
		String sql = "select * from persons";
		try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(sql);
		}
    	catch(Exception ex){
        	out.println("<hr>" + ex.getMessage() + "<hr>");
		}

    	String truepwd = "";

    	out.println("<h3>Here are the persons listed:</h3>");
		while(rset != null && rset.next()){
			usrName = (rset.getString(1)).trim();
			out.println("<html>");
			out.println("<form method=get action=manage2.jsp>");
			out.println(usrName+"<input type=hidden name=name value="+usrName+">");
			out.println("<input type=submit value=view>");
			out.println("</form>");
			out.println("</html>");
		}
		
		try{
        	conn.close();
     	}
        catch(Exception ex){
       		out.println("<hr>" + ex.getMessage() + "<hr>");
        }
	}
%>
