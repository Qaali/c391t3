<%@ page import="java.sql.*" %>
<%
	String title = "Upload Image";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && classType.equals("r")){
    	if(request.getParameter("recid") != null){
    		String recid = request.getParameter("recid");
    		//Print result
    		if(request.getParameter("result") != null){
    			String result = request.getParameter("result");
    			if(result.equals("ok"))
    				out.println("<p style=\"color:green\">Upload Successful!</p>");
    			else if (result.equals("fail"))
    				out.println("<p style=\"color:red\">Upload Failed!</p>");
    			else if (result.equals("recok"))
    				out.println("<p style=\"color:green\">Record uploaded with ID: "+recid+"</p>");
    			else
    				out.println("<p style=\"color:red\">"+result+"</p>");
    		}
%>
		<P>Add An Image To Current Record</P>
		
		<FORM NAME="upload-image" METHOD="POST" ENCTYPE="multipart/form-data" ACTION="UploadImage">
		<INPUT TYPE="hidden" NAME="recid" VALUE="<%= recid %>">
		<TABLE>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Image File:</TH>
				<TD><INPUT TYPE="file" SIZE="30" NAME="filepath"></TD>
			</TR>
		</TABLE>

		<INPUT TYPE="submit" NAME="iSubmit" VALUE="Add Image">
		</FORM>			
<%
    	}
    	else {
    		out.println("Record ID not given");
    	}
	}
	else if(session.getAttribute("name") != null){
		out.println("You are not a radiologist. Get out of here!");
	}
	else {
		out.println("You are not signed in.");
	}
%>
		</div>
	</BODY>
</HTML>
