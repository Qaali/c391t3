<%@ page import="java.sql.*" %>
<%
	String title = "Search Module";
%>
<%@ include file="header.jsp" %>
		<div id="main">
<%
	if(session.getAttribute("name") != null){
%>
		<P>Search the Radiology Database </P>	
		<FORM NAME="SearchForm" ACTION="searchResults.jsp" METHOD="post" >
		<TABLE>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Keywords:</TH>
				<TD><INPUT TYPE="text" SIZE="50" NAME="keywords"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TD COLSPAN=2><I>*Separate Keywords By Commas</I></TD>
			</TR>
			<tr><td><br></td></tr>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH COLSPAN=2><U>And/Or</U></TH>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH COLSPAN=2><I>Valid Date Format "DD-MON-YYYY"</I></TH>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Start Date:</TH>
				<TD><INPUT TYPE="text" NAME="startdate"></TD>
			</TR>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>End Date:</TH>
				<TD><INPUT TYPE="text" NAME="enddate"></TD>
			</TR>
			<tr><td><br></td></tr>
			<TR VALIGN=TOP ALIGN=LEFT>
				<TH>Order By:</TH>
				<TH><SELECT NAME="order" SIZE="1">
					<OPTION>Rank</OPTION>
					<OPTION>Most-Recent-First</OPTION>
					<OPTION>Most-Recent-Last</OPTION>
					</SELECT>
				</TH>
			</TR>
		</TABLE>

		<INPUT TYPE="submit" NAME="sSubmit" VALUE="Search">
		</FORM>		
<%
	}
	else {
		out.println("You are not signed in.");
	}
%>
		</div>
	</BODY>
</HTML>
