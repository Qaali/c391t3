import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  This servlet sends one picture stored in the table below to the client 
 *  who requested the servlet. Based on a code sample by Li-Yan Yuan.
 *n
 *
 *  The request must come with a query string as follows:
 *    GetOnePic?rec=1&pic=3:        	sends the picture in thumbnail with image_id=3 and record_id=1
 *    GetOnePic?rec=1&pic=3&size=reg: 	sends the picture in regular_size with image_id=3 and record_id=1
 *
 *  @author  Colby Warkentin
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
	
		String query;
		if ( picsize.equals("reg") )  
			query = "select regular_size from pacs_images where record_id=? and image_id=?";
		else if( picsize.equals("full") )
			query = "select full_size from pacs_images where record_id=? and image_id=?";
		else
			query = "select thumbnail from pacs_images where record_id=? and image_id=?";

		Connection conn = null;
		try {
			conn = getConnected(username, password);
			PreparedStatement stmt = conn.prepareStatement(query);
			stmt.setInt(1, recid);
			stmt.setInt(2, picid);
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
