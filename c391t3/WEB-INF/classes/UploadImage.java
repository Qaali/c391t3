/***
 *  Adapted from a sample program by Fan Deng, License below:
 * 
 		*  A sample program to demonstrate how to use servlet to 
 		*  load an image file from the client disk via a web browser
 		*  and insert the image into a table in Oracle DB.
 		*  
 		*  Copyright 2007 COMPUT 391 Team, CS, UofA                             
 		*  Author:  Fan Deng
 		*                                                                  
 		*  Licensed under the Apache License, Version 2.0 (the "License");
 		*  you may not use this file except in compliance with the License.        
 		*  You may obtain a copy of the License at                                 
 		*      http://www.apache.org/licenses/LICENSE-2.0                          
 		*  Unless required by applicable law or agreed to in writing, software
 		*  distributed under the License is distributed on an "AS IS" BASIS,
 		*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 		*  See the License for the specific language governing permissions and
 		*  limitations under the License.
 *
 * CMPUT 391 Team 3
 *
 * Function: Accept image from radiologist and upload to the database
 * 
 * @author  Colby Warkentin(1169034) and Yiming Liu (1245022)
 * 
 ***/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import oracle.sql.*;
import oracle.jdbc.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

/**
 *  The package commons-fileupload-1.0.jar is downloaded from 
 *         http://jakarta.apache.org/commons/fileupload/ 
 *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
 *  One shall also modify the CLASSPATH to include this jar file.
 */
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;

public class UploadImage extends HttpServlet {
    public String result;
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
    String username = "cwarkent";
	String password = "lotr0808pso";
	HttpSession session = request.getSession(true);
    if(session.getAttribute("dbuser") != null){
		username= (String) session.getAttribute("dbuser");
		password = (String) session.getAttribute("dbpass");
	}
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
	String recid = "";
	if(session.getAttribute("name") != null){
		try {
			//Parse the HTTP request to get the image stream
			DiskFileUpload fu = new DiskFileUpload();
			List FileItems = fu.parseRequest(request);
	        
			// Process the uploaded items, assuming only 1 image file uploaded
			Iterator i = FileItems.iterator();
			FileItem item = (FileItem) i.next();
			while (i.hasNext() && item.isFormField()) {
				if(item.getFieldName().equals("recid"))
					recid = item.getString();
				item = (FileItem) i.next();
			}

			//Get the image stream
			InputStream instream = item.getInputStream();

			BufferedImage img = ImageIO.read(instream);
			BufferedImage thumbNail = shrink(img, 10);

			// Connect to the database and create a statement
			Connection conn = getConnected(drivername,dbstring, username,password);
			Statement stmt = conn.createStatement();
			
			String userName = (String) session.getAttribute("name");
			String secQuery = "SELECT radiologist_name FROM radiology_record WHERE record_id = ? AND radiologist_name = ?";
			PreparedStatement secStmt = conn.prepareStatement(secQuery);
			secStmt.setInt(1, Integer.parseInt(recid));
			secStmt.setString(2, userName);
			ResultSet secSet = secStmt.executeQuery();
			
			if(secSet != null && secSet.next()){
				//First, to generate a unique pic_id using an SQL sequence
				ResultSet rsetPic = stmt.executeQuery("SELECT pic_seq.nextval from dual");
				rsetPic.next();
				int image_id = rsetPic.getInt(1);

				//Insert an empty blob into the table first. Note that you have to 
				//use the Oracle specific function empty_blob() to create an empty blob
				String prepIn = "INSERT INTO pacs_images VALUES(?, ?, empty_blob(), empty_blob(), empty_blob())";
				PreparedStatement prepStmt = conn.prepareStatement(prepIn);
				prepStmt.setInt(1, Integer.parseInt(recid));
				prepStmt.setInt(2, image_id);
				prepStmt.executeQuery();
 
				// Retrieve the lob_locator 
				String cmd = "SELECT * FROM pacs_images WHERE record_id = ? and image_id = ? FOR UPDATE";
				PreparedStatement cmdStmt = conn.prepareStatement(cmd);
				cmdStmt.setInt(1, Integer.parseInt(recid));
				cmdStmt.setInt(2, image_id);			
				ResultSet rset = cmdStmt.executeQuery();
				
				rset.next();
				BLOB thumbblob = ((OracleResultSet)rset).getBLOB(3);
				BLOB regblob = ((OracleResultSet)rset).getBLOB(4);
				BLOB fullblob = ((OracleResultSet)rset).getBLOB(5);

				//Write the image to the blob object
				OutputStream thumbout = thumbblob.getBinaryOutputStream();
				ImageIO.write(thumbNail, "jpg", thumbout);

				OutputStream regout = regblob.getBinaryOutputStream();
				ImageIO.write(img, "jpg", regout);
	    
				OutputStream fullout = fullblob.getBinaryOutputStream();
				ImageIO.write(img, "jpg", fullout);

				instream.close();
				thumbout.close();
				regout.close();
				fullout.close();

				conn.commit();
				result = "ok";
				conn.close();
			}
			else
				result = "Permission Denied";
		}
		catch( Exception ex ) {
			result = ex.getMessage();
		}
	}
	else 
		result = "not logged in";

	//Output response to the client
	response.sendRedirect("uploadAfter.jsp?recid="+recid+"&result="+result);
    }

    /*
      /*   To connect to the specified database
    */
    private static Connection getConnected( String drivername,
					    String dbstring,
					    String username, 
					    String password  ) 
	throws Exception {
	Class drvClass = Class.forName(drivername); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password));
    } 

    //shrink image by a factor of n, and return the shrinked image
    public static BufferedImage shrink(BufferedImage image, int n) {

        int w = image.getWidth() / n;
        int h = image.getHeight() / n;

        BufferedImage shrunkImage =
            new BufferedImage(w, h, image.getType());

        for (int y=0; y < h; ++y)
            for (int x=0; x < w; ++x)
                shrunkImage.setRGB(x, y, image.getRGB(x*n, y*n));

        return shrunkImage;
    }
}
