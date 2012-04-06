<%@ page import="java.sql.*" %>
<%
	String title = "Upload Record";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && classType.equals("r")){
%>
		<P>Add a Radiology Record </P>	
		<FORM NAME="RecordForm" ACTION="uploadRecord.jsp" METHOD="post" >
		<TABLE>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Patient Name:</TH>
				<TD><INPUT TYPE="text" NAME="patname"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Doctor Name:</TH>
				<TD><INPUT TYPE="text" NAME="docname"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Radiologist Name:</TH>
				<TD><INPUT TYPE="text" NAME="radname"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Test Type:</TH>
				<TD><INPUT TYPE="text" NAME="testtype"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH COLSPAN=2><I>Valid Date Format "DD-MMM-YY"</I></TH>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Prescribing Date:</TH>
				<TD><INPUT TYPE="text" NAME="presdate"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Test Date:</TH>
				<TD><INPUT TYPE="text" NAME="testdate"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Diagnosis:</TH>
				<TD><INPUT TYPE="text" SIZE="39" NAME="diag"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Description:</TH>
				<TD><TEXTAREA COLS="50" ROWS="5" NAME="desc"></TEXTAREA></TD>
			</TR>
		</TABLE>

		<INPUT TYPE="submit" NAME="rSubmit" VALUE="Add Record">
		</FORM>		
		
		<HR><P>Add An Image to An Existing Record</P>
		<FORM NAME="upload-image" METHOD="POST" ENCTYPE="multipart/form-data" ACTION="UploadImage">
		<TABLE>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Record ID:</TH>
				<TD><INPUT TYPE="text" NAME="recid"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Image File:</TH>
				<TD><INPUT TYPE="file" SIZE="30" NAME="filepath"></TD>
			</TR>
		</TABLE>

		<INPUT TYPE="submit" NAME="iSubmit" VALUE="Add Image">
		</FORM>	
<%
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