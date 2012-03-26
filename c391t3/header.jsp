<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
	<HEAD>
		<TITLE>CMPUT 391 Team 3 <%= title %></TITLE>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
		<style type="text/css">
		#sidebar {
			float: left; 
			width:200px;
			margin-top:0px;
			padding-top:0px;
			height:100%;
		}
		
		#main {
			margin-left: 200px;
			border-left: 1px solid black;
			padding-left: 30px;
		}
		</style>
	</HEAD>

	<BODY>
		<div style="float:top">
			<h1 style="text-align:center">CMPUT 391 Team 3 <%= title %></h1>
		
			<% 
				if(session.getAttribute("name") != null){
					out.println("<p style=\"text-align:right\">Hello, "+session.getAttribute("name"));
					out.println("<a href=\"login.jsp?logout=true\">logout</a></p>");
				}
				else{
					out.println("<p style=\"text-align:right\">Please ");
					out.println("<a href=\"login.jsp\">Login</a><p>");
				}
			%>
		<div>
		<div id="sidebar">
			<b><u>Menu</u></b><br>
		<%
			if(session.getAttribute("classtype") != null){
				String id = (String) session.getAttribute("classtype");
				if(id.equals("a")){
					//Add junk here
					out.println("<a href=\"manage.jsp\">User Management</a><br>");
					out.println("<a href=\"report.jsp\">Report Generator</a><br>");
					out.println("<a href=\"analysis.jsp\">Data Analysis</a><br>");
				}
				else if(id.equals("r"))
					out.println("<a href=\"upload.jsp\">Record Upload</a><br>");
				out.println("<a href=\"search.jsp\">Search</a><br>");
				out.println("<a href=\"profile.jsp\">Edit Profile</a>");
			}
		%>
		</div>