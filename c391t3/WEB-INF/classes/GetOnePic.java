import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  CMPUT 391 Team 3
 *  
 *  This servlet sends one picture stored in the table below to the client 
 *  who requested the servlet. Based on a code sample by Li-Yan Yuan.
 *
 *  Function: The request must come with a query string as follows:
 *    GetOnePic?rec=1&pic=3:        	sends the picture in thumbnail with image_id=3 and record_id=1
 *    GetOnePic?rec=1&pic=3&size=reg: 	sends the picture in regular_size with image_id=3 and record_id=1
 *
 *  @author  Colby Warkentin(1169034) and Yiming Liu (1245022)
 *
 */
public class GetOnePic extends HttpServlet {
    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
    // Get username and password for database
    String username = "cwarkent";
    String password = "lotr0808pso";
    HttpSession session = request.getSession(true);
    if(session.getAttribute("dbuser") != null){
    	username= (String) session.getAttribute("dbuser");
    	password = (String) session.getAttribute("dbpass");
    }
    
    ServletOutputStream out = response.getOutputStream();
	
    if(session.getAttribute("name") != null){
		//  construct the query  from the client's QueryString
		int recid = Integer.parseInt(request.getParameter("rec"));	
		int picid  = Integer.parseInt(request.getParameter("pic"));
		String picsize;
		if(request.getParameter("size") != null)
			picsize = request.getParameter("size");
		else
			picsize = "small";
	
		String userName = (String) session.getAttribute("name");
		String classtype = (String) session.getAttribute("classtype");
		String adder = "";
		if(classtype.equals("r"))
			adder = " and r.radiologist_name = ? ";
		else if(classtype.equals("d"))
			adder = " and ? IN (SELECT d.doctor_name from family_doctor d where d.patient_name = r.patient_name) ";
		else if(classtype.equals("p"))
			adder = " and r.patient_name = ? ";
		
		String query;
		if ( picsize.equals("reg") )  
			query = "select p.regular_size from pacs_images p, radiology_record r where p.record_id=? and p.image_id=? and r.record_id = p.record_id";
		else if( picsize.equals("full") )
			query = "select p.full_size from pacs_images p, radiology_record r where p.record_id=? and p.image_id=? and r.record_id = p.record_id";
		else
			query = "select p.thumbnail from pacs_images p, radiology_record r where p.record_id=? and p.image_id=? and r.record_id = p.record_id";
		if(!classtype.equals("a"))
			query = query.concat(adder);
		
		Connection conn = null;
		try {
			conn = getConnected(username, password);
			PreparedStatement stmt = conn.prepareStatement(query);
			stmt.setInt(1, recid);
			stmt.setInt(2, picid);
			if(!classtype.equals("a"))
				stmt.setString(3, userName);
			ResultSet rset = stmt.executeQuery();

			if ( rset.next() ) {
				response.setContentType("image/gif");
				InputStream input = rset.getBinaryStream(1);	    
				int imageByte;
				while((imageByte = input.read()) != -1) {
					out.write(imageByte);
				}
				input.close();
			} 
			else 
				out.println("no picture available");
		} catch( Exception ex ) {
			out.println(ex.getMessage() );
		}
		// to close the connection
		finally {
			try {
				conn.close();
			} catch ( SQLException ex) {
				out.println( ex.getMessage() );
			}
		}
	}
	else 
		out.println("not signed in");
    }

    /*
     *   Connect to the specified database
     */
    private Connection getConnected(String username, String password) throws Exception {
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	String driverName = "oracle.jdbc.driver.OracleDriver";

	Class drvClass = Class.forName(driverName); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password) );
    }
}
