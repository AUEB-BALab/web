<?xml version="1.0"?>
<!--
 -
 - Transform the eltrun data into HTML web pages
 -
 - (C) Copyright 2004 Diomidis Spinellis
 -
 - $Id$
 -
 -->

<!-- Global definitions {{{1 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="today"/>	<!-- today's date -->
<xsl:param name="ogroup"/>	<!-- limit output to (projects/members) of a given group -->
<xsl:param name="oproject"/>	<!-- limit output to a given project -->
<xsl:param name="omember"/>	<!-- limit output to a given member -->
<xsl:param name="what"/>	<!-- Output:
					  members
					| alumni
					| current-projects
					| completed-projects
					| member-details
					| project-details
					| group-details
					| group-publications
					| member-publications
					| project-publications
				-->

	<!-- Generate heading with group name {{{1 -->
	<xsl:template match="group" mode="heading">
		<xsl:if test="@id = $ogroup">
			ELTRUN - <xsl:value-of select="shortname" />:
			<xsl:value-of select="grouptitle" />
		</xsl:if>
	</xsl:template>

	<!-- Create a bib2html template{{{1 -->
	<xsl:template name="bib2html">
		<xsl:param name="pubid" />
		<xsl:param name="type" />
<!-- Do not change the formatting of the following lines -->
<xsl:text>
</xsl:text>
<xsl:comment><xsl:text> </xsl:text>BEGIN BIBLIOGRAPHY build/<xsl:value-of select="$pubid" />-<xsl:value-of select="$type" /><xsl:text> </xsl:text></xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment><xsl:text> </xsl:text>END BIBLIOGRAPHY build/<xsl:value-of select="$pubid" />-<xsl:value-of select="$type" /><xsl:text> </xsl:text></xsl:comment>
<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- Format an ISO date {{{1 -->
	<xsl:template name="date">
		<xsl:param name="date" />
		<!-- Date (00 means unknown) -->
		<xsl:variable name="day" select="number(substring($date, 7, 2))" />
		<xsl:if test="$day != 0">
			<xsl:value-of select="$day"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<!-- Month (00 means unknown)-->
		<xsl:variable name="month" select="substring($date, 5, 2)" />
		<xsl:choose>
			<xsl:when test="$month = '01'">January</xsl:when>
			<xsl:when test="$month = '02'">February</xsl:when>
			<xsl:when test="$month = '03'">March</xsl:when>
			<xsl:when test="$month = '04'">April</xsl:when>
			<xsl:when test="$month = '05'">May</xsl:when>
			<xsl:when test="$month = '06'">June</xsl:when>
			<xsl:when test="$month = '07'">July</xsl:when>
			<xsl:when test="$month = '08'">August</xsl:when>
			<xsl:when test="$month = '09'">September</xsl:when>
			<xsl:when test="$month = '10'">October</xsl:when>
			<xsl:when test="$month = '11'">November</xsl:when>
			<xsl:when test="$month = '12'">December</xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<!-- Year -->
		<xsl:value-of select="substring($date, 1, 4)"/>
	</xsl:template>

	<!-- Format a publication type for the contents list {{{1 -->
	<xsl:template match="publication_type" mode="toc" >
		<ul>
		<xsl:if test="count(has_book) != 0">
			<li><a href="#book">Monographs and edited volumes</a></li>
		</xsl:if>
		<xsl:if test="count(has_article) != 0">
			<li><a href="#article">Journal articles</a></li>
		</xsl:if>
		<xsl:if test="count(has_incollection) != 0">
			<li><a href="#incollection">Book chapters</a></li>
		</xsl:if>
		<xsl:if test="count(has_inproceedings) != 0">
			<li><a href="#inproceedings">Conference publications</a></li>
		</xsl:if>
		<xsl:if test="count(has_techreport) != 0">
			<li><a href="#techreport">Technical reports</a></li>
		</xsl:if>
		<xsl:if test="count(has_whitepaper) != 0">
			<li><a href="#whitepaper">White papers</a></li>
		</xsl:if>
		<xsl:if test="count(has_workingpaper) != 0">
			<li><a href="#workingpaper">Working papers</a></li>
		</xsl:if>
		</ul>
	</xsl:template>

	<!-- Format a publication type for including BibTeX results {{{1 -->
	<xsl:template match="publication_type" mode="full" >
		<xsl:param name="pubid" />
		<xsl:if test="count(has_book) != 0">
			<a name="book"> </a><h2>Monographs and Edited Volumes</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'book'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_article) != 0">
			<a name="article"> </a><h2>Journal Articles</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'article'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_incollection) != 0">
			<a name="incollection"> </a><h2>Book Chapters</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'incollection'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_inproceedings) != 0">
			<a name="inproceedings"> </a><h2>Conference Publications</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'inproceedings'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_techreport) != 0">
			<a name="techreport"> </a><h2>Technical Reports</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'techreport'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_whitepaper) != 0">
			<a name="whitepaper"> </a><h2>White Papers</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'whitepaper'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_workingpaper) != 0">
			<a name="workingpaper"> </a><h2>Working Papers</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'workingpaper'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="simple-ref" >
		<xsl:if test="count(alumnus) = 0">
			<a href="../members/{@id}.html">
			<xsl:if test="count(memb_title) != 0">
				<xsl:value-of select="memb_title"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
		</xsl:if>		
	</xsl:template>
	
	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="ref" >
		<xsl:if test="count(alumnus) = 0">
			<li>
			<a href="../members/{@id}.html">
			<xsl:if test="count(memb_title) != 0">
				<xsl:value-of select="memb_title"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
			</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="shortref">
		<xsl:if test="count(alumnus) = 0">
		<li>
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Format a member reference {{{1-->
	<xsl:template match="member" mode="alumnus-ref">
		<xsl:if test="count(alumnus) != 0">
		<li>
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		</li>	
		</xsl:if>
	</xsl:template>
	
	<!-- Format members information {{{1 --> 
	<xsl:template match="member" mode="full">
		<h2>
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title" />
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</h2>
		<xsl:if test="photo">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="photo"/></xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:if test="count(memb_title) != 0">
						<xsl:value-of select="memb_title" />
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="givenname" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="surname" />						
				</xsl:attribute>
				<xsl:attribute name="width">80</xsl:attribute>
				<xsl:attribute name="height">80</xsl:attribute>
			</xsl:element>										
		</xsl:if>
		<br /> <br />
		<xsl:if test="count(alumnus) != 0">
			<font color="#FF0000">
			<h4>This member is no longer active.</h4>
			</font>
		</xsl:if>
		<xsl:if test="count(email) != 0">
			E-mail: <xsl:value-of select="email" />
			<br />
		</xsl:if>
		<xsl:if test="count(office_phone) != 0">
			Office Phone: <xsl:value-of select="office_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(mobile_phone) != 0">
			Mobile Phone: <xsl:value-of select="mobile_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(Fax) != 0">
			Fax: <xsl:value-of select="fax" />
			<br />
		</xsl:if>	
		<xsl:if test="count(office_phone) != 0">
			Office Phone: <xsl:value-of select="office_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(office_address) != 0">
			Office Address: <xsl:value-of select="office_address"/>
			<br />
		</xsl:if>
		<xsl:if test="count(web_site) != 0">
			Web Site:
			<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="web_site"/>
					</xsl:attribute>
				<xsl:value-of select="web_site"/>
			</xsl:element>
			<br /><br />
		</xsl:if>
		Groups: <xsl:apply-templates select="/eltrun/group_list/group [contains(current()/@group, @id)]" mode="shortref"/>
		<br />
		<a href="../publications/{$omember}-publications.html">Publications</a>
		<br />
		<br />
		Short CV
		<br />
		<xsl:apply-templates select="current()/shortcv"/>
	</xsl:template>
	
	<!-- Format a short cv -->
	<xsl:template match="shortcv">
		<xsl:copy-of select="*|text()"/>
	</xsl:template>

	<!-- Format a short group reference {{{1 -->
	<xsl:template match="group" mode="shortref" >
		<a href="../groups/{@id}-details.html">
		<xsl:value-of select="shortname" />
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<!-- Format a group reference for the menu {{{1-->
	<xsl:template match="group" mode="menuref">
		<xsl:if test="@id != 'g_eltrun'">
		<li>
		<a href="../groups/{@id}-details.html"><xsl:value-of select="shortname" /></a>
		</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Format a full group description {{{1-->
	<xsl:template match="group" mode="full">
		<h2>
		<xsl:value-of select="shortname"/>
		<xsl:text> - </xsl:text>
		<xsl:value-of select="grouptitle"/>
		</h2>
		<br />
		<xsl:if test="count(logo) != 0">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="logo"/></xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:value-of select="shortname"/>
					<xsl:text> - </xsl:text>
					<xsl:value-of select="grouptitle"/>						
				</xsl:attribute>
			</xsl:element>
			<br /><br />
		</xsl:if>
		Director: 
		<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@director]" mode="simple-ref" />
		<br />
		Contact:
		<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@contact]" mode="simple-ref" />
		<br /><br />
		Research group information:
		<br /><br />
		<xsl:apply-templates select="current()/description" />
		<br /><br />
		<xsl:if test="count(rel_link) != 0">
			Relative Links:
			<br /><br />
			<xsl:apply-templates select="current()/rel_link" />
			<br />
		</xsl:if>
		Members:
		<br /><br />
		<xsl:apply-templates select="/eltrun/member_list/member[contains(@group,$ogroup)]" mode="shortref"/>
	</xsl:template>
	
	<!-- Format description {{{1 -->
	<xsl:template match="description">
		<xsl:copy-of select="*|text()"/>
	</xsl:template>
	
	<!-- Format relative links {{{1 -->
	<xsl:template match="rel_link">
		<xsl:copy-of select="*"/><br />
	</xsl:template>
	
	<!-- Format a project reference {{{1 -->
	<xsl:template match="project" mode="ref">
		<li>
		<a href="../projects/{@id}.html">
		<xsl:value-of select="shortname" />
		-
		<xsl:value-of select="projtitle" />
		</a>
		</li>
	</xsl:template>

	<!-- List project details {{{1 -->
	<xsl:template match="project" mode="full">
		<h1>
		<xsl:value-of select="shortname" />
		-
		<xsl:value-of select="projtitle" />
		</h1>
		<!-- Show starting date -->
		<xsl:if test="startdate != ''">
			Starting date:
			<xsl:call-template name="date">
				<xsl:with-param name="date" select="startdate" />
			</xsl:call-template>
			<br/>
		</xsl:if>
		<!-- Show scientific coordinator, if given -->
		<xsl:if test="@scientific_coordinator != ''">
			Scientific coordinator:
			<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@scientific_coordinator]" mode="simple-ref" />
		</xsl:if>
		<!-- Show groups this project belongs to -->
		Groups: <xsl:apply-templates select="/eltrun/group_list/group [contains(current()/@group, @id)]" mode="shortref"/>
		<!-- Provide publications link, if any publications exist -->
		<xsl:if test="count(/eltrun/publication_type_list/publication_type [@for = current()/@id]/has_any) != 0">
			<br/><a href="../publications/{@id}-publications.html">Publications</a>
		</xsl:if>
	</xsl:template>

	<!-- Format a group heading {{{1 -->
	<xsl:template name="group-head">
		<!-- Generate ELTRUN or group heading -->
		<xsl:choose>
			<xsl:when test="$ogroup = 'g_eltrun'">
				ELTRUN
			</xsl:when>
			<xsl:when test="$ogroup != 'g_eltrun'">
				<xsl:apply-templates select="/eltrun/group_list/group [@id=$ogroup]" mode="heading" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- body menu -->
	<xsl:template name="body-menu">
		<xsl:apply-templates select="/eltrun/group_list/group[@id = $ogroup]" mode="shortref"/>
		<br />
		<hr />
		<a href="../groups/{$ogroup}-members.html">Members</a>
		<br />
		<a href="../groups/{$ogroup}-current-projects.html">Current Projects</a>
		<br />
		<a href="../groups/{$ogroup}-completed-projects.html">Completed Projects</a>
		<br />
		<a href="../publications/{$ogroup}-publications.html">Publications</a>
		<br />
		<a href="../groups/{$ogroup}-alumni.html">Alumni</a>
	</xsl:template>
	
	<!-- Main transformation {{{1 -->
	<xsl:template match="eltrun">
		<html>
		<!-- HEAD -->
		<head>
		<link href="../images/styles.css" type="text/css" rel="stylesheet" />
		<xsl:comment>Generated by $Id$</xsl:comment>
		<title>ELTRUN <xsl:text> - </xsl:text>
		<!-- Append the appropriate title -->
		<xsl:choose>
			<xsl:when test="$what = 'current-projects'">
				<xsl:text>Current Projects</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'completed-projects'">
				<xsl:text>Completed Projects</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'members'">
				<xsl:text>Members</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'project-details'">
				<xsl:text>Project Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'member-publications'">
				<xsl:text>Member publications</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'group-publications'">
				<xsl:text>Group publications</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'member-details'">
				<xsl:text>Member Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'group-details'">
				<xsl:text>Group Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'alumni'">
				<xsl:text>Alumni</xsl:text>
			</xsl:when>
		</xsl:choose>
		</title>
		</head>
		
		<!-- BODY -->
		<body>
		<a href="http://www.eltrun.gr/"><img src="../images/heading.jpg" alt="ELTRUN - The e-Business Center" border="0" /></a>
		<br />
		<table width="750" border="0">
			<tbody valign="top">
			<tr>
			<xsl:if test="$what != 'group-publications'">
				<xsl:if test="$what != 'member-publications'">
					<xsl:if test="$ogroup != ''">
						<th height="800" width="150" align="left" bgcolor="#8B9DC3">
						<xsl:call-template name="body-menu" />
						</th>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<th align="left">
			<!-- choose which HTML to show -->
			<xsl:choose>
				<!-- Current projects -->
				<xsl:when test="$what = 'current-projects'">
				<h2>Current Projects</h2>
					<xsl:apply-templates select="/eltrun/project_list/project [contains(@group, $ogroup)] [enddate &gt;= $today]" mode="ref">
						<xsl:sort select="shortname" order="ascending"/>
					</xsl:apply-templates>
				</xsl:when>
				<!-- Completed Projects -->
				<xsl:when test="$what = 'completed-projects'">
				<h2>Completed Projects</h2>
					<xsl:apply-templates select="/eltrun/project_list/project [contains(@group, $ogroup)] [enddate &lt; $today]" mode="ref" >
						<xsl:sort select="shortname" order="ascending"/>
					</xsl:apply-templates>
				</xsl:when>
				<!-- members -->
				<xsl:when test="$what = 'members'">
				<h2>Group Members</h2>
				<xsl:apply-templates select="/eltrun/member_list/member[contains(@group,$ogroup)]" mode="ref">
					<xsl:sort select="surname" order="ascending"/>
				</xsl:apply-templates>
				</xsl:when>
				<!-- project details -->
				<xsl:when test="$what = 'project-details'">
					<xsl:apply-templates select="/eltrun/project_list/project [@id = $oproject]" mode="full" />
				</xsl:when>
				<!-- Member Publications -->
				<xsl:when test="$what = 'member-publications'">
					<h1>
					<xsl:apply-templates select="/eltrun/member_list/member [@id=$omember]" mode="simple-ref" /> : Publications
					</h1>
					<h2>Contents</h2>
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $omember]" mode="toc" />
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $omember]" mode="full" >
					<xsl:with-param name="pubid" select="$omember" />
					</xsl:apply-templates>
				</xsl:when>
				<!-- group publications -->
				<xsl:when test="$what = 'group-publications'">
					<h1>
					<xsl:call-template name="group-head"/>: Publications
					</h1>
					<h2>Contents</h2>
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $ogroup]" mode="toc" />
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $ogroup]" mode="full" >
						<xsl:with-param name="pubid" select="$ogroup" />
					</xsl:apply-templates>
				</xsl:when>
				<!-- member details -->
				<xsl:when test="$what = 'member-details'">
					<xsl:apply-templates select="/eltrun/member_list/member[@id = $omember]" mode="full" />
				</xsl:when>
				<!-- group details -->
				<xsl:when test="$what = 'group-details'">
					<xsl:apply-templates select="/eltrun/group_list/group[@id = $ogroup]" mode="full" />
				</xsl:when>
				<!-- alumni -->
				<xsl:when test="$what = 'alumni'">
					<h2>Alumni</h2>
					<xsl:apply-templates select="/eltrun/member_list/member [contains(@group,$ogroup)]" mode="alumnus-ref" />
				</xsl:when>
			</xsl:choose>
			</th>
			</tr>
			</tbody>
		</table>
		</body>		
		</html>
	</xsl:template>
</xsl:stylesheet>
