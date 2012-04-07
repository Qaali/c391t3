<!--
	CMPUT 391 Team 3
	Authors: Colby Warkentin(1169034) and Yiming Liu (1245022)
 	Function: Display form for report generation
-->
<%@ page import="java.sql.*" %>
<%
	String title = "Generate Report";
%>
<%@ include file="header.jsp" %>
<div id="main">
<%
	String classType = (String) session.getAttribute("classtype");
	if(session.getAttribute("name") != null && classType.equals("a")){
%>
		<P>To get the list of all patients with a specified diagnosis for a given time period</P>
		
		<FORM NAME="ReportForm" ACTION="report_generate.jsp" METHOD="post" >
		<TABLE>
			<p>Time format: DD-MON-YYYY</p>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Diagnosis:</TH>
				<TD><INPUT TYPE="text" NAME="diagnosis" ></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>FROM:</TH>
				<TD><INPUT TYPE="text" NAME="begin" ></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>TO:</TH>
				<TD><INPUT TYPE="text" NAME="end" ></TD>
			</TR>
		</TABLE>
		<INPUT TYPE="submit" NAME="rSubmit" VALUE="Submit">
		</FORM>		
<%
	}
	else if(session.getAttribute("name") != null){
		out.println("<p style=\"color:red\">You are not an admin.</p>");
	}
	else {
		out.println("<p style=\"color:red\">You are not signed in.</p>");
	}
%>
	</div>
	</BODY>
</HTML>