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
	<xsl:template match="member" mode="ref" >
		<ul>
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
		</ul>
	</xsl:template>
	
	<xsl:template match="member" mode="shortref">
		<li><a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		</li>
	</xsl:template>
	
	<!-- Format members information --> 
	<xsl:template match="member" mode="full">
		<!-- header -->
		<head>
			<title>eLTRUN - Member Information</title>
			<link href="../images/styles.css" type="text/css" rel="stylesheet" />
		</head>
		<!--  body -->
		<body>
		<xsl:call-template name="body-head" />
		<br />
		<table width="750" border="0">
			<tbody>
			<tr>
				<th width="150" valign="top">
				<xsl:call-template name="body-menu" />
				</th>
				<th align="left">
				<!-- add info -->
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
				<table>
					<tbody>
					<xsl:if test="count(email) != 0">
						<tr>
							<th align="left" class="SMALL">E-mail:</th>
							<th align="left" class="SMALL"><xsl:value-of select="email" /></th>
						</tr>
					</xsl:if>
					<xsl:if test="count(office_phone) != 0">
						<tr>
							<th align="left" class="SMALL">Office Phone:</th>
							<th align="left" class="SMALL"><xsl:value-of select="office_phone" /></th>
						</tr>
					</xsl:if>	
					<xsl:if test="count(mobile_phone) != 0">
						<tr>
							<th align="left" class="SMALL">Mobile Phone:</th>
							<th align="left" class="SMALL"><xsl:value-of select="mobile_phone" /></th>
						</tr>
					</xsl:if>	
					<xsl:if test="count(Fax) != 0">
						<tr>
							<th align="left" class="SMALL">Fax:</th>
							<th align="left" class="SMALL"><xsl:value-of select="fax" /></th>
						</tr>
					</xsl:if>	
					<xsl:if test="count(office_phone) != 0">
						<tr>
							<th align="left" class="SMALL">Office Phone:</th>
							<th align="left" class="SMALL"><xsl:value-of select="office_phone" /></th>
						</tr>
					</xsl:if>	
					<xsl:if test="count(office_address) != 0">
						<tr>
							<th align="left" class="SMALL">Office Address:</th>
							<th align="left" class="SMALL">
							<xsl:value-of select="office_address"/>
							</th>
						</tr>
					</xsl:if>
					<xsl:if test="count(web_site) != 0">
						<tr>
							<th align="left" class="SMALL">Web Site:</th>
							<th align="left" class="SMALL">
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="web_site"/></xsl:attribute>
								<xsl:value-of select="web_site"/>
							</xsl:element>							
							</th>
						</tr>
					</xsl:if>
					<tr>
						<th align="left" class="SMALL">Groups:</th>
						<th align="left" class="SMALL"><xsl:apply-templates select="/eltrun/group_list/group [contains(current()/@group, @id)]" mode="shortref"/></th>
					</tr>
					<tr>
						<th colspan="2" align="left" class="SMALL">
						<a href="../publications/{$omember}-publications.html">Publications</a>
						</th>
					</tr>
					<tr>
						<th colspan="2"> </th>
					</tr>
					<tr>
						<th colspan="2"> </th>						
					</tr>					
					<tr>
						<th colspan="2" class="SMALL" align="left"><u>Short CV</u></th>			
					</tr>
					<tr>
						<th colspan="2" align="left" class="SMALL">
							<xsl:value-of select="shortcv"/>
						</th>
					</tr>
					</tbody>
				</table>						
				</th>
			</tr>
			</tbody>
		</table>	
		</body>
	</xsl:template>

	<!-- Format a short group reference {{{1 -->
	<xsl:template match="group" mode="shortref" >
		<a href="../groups/{@id}-details.html">
		<xsl:value-of select="shortname" />
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="group" mode="menuref">
		<xsl:if test="@id != 'g_eltrun'">
		<tr>
			<th align="left">
			<a href="../groups/{@id}-details.html">
				<xsl:value-of select="shortname" />
			</a>			
			</th>
		</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="group" mode="full">
		<!-- header -->
		<head>
			<title>eLTRUN - Group Information</title>
			<link href="../images/styles.css" type="text/css" rel="stylesheet" />
		</head>
		<!--  body -->
		<body>
		<xsl:call-template name="body-head" />
		<br />
		<table width="750" border="0">
			<tbody>
			<tr>
				<th width="150" valign="top">
				<xsl:call-template name="body-menu" />
				</th>
				<th valign="top" align="left">
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
				</xsl:if>
				<table>
					<tbody valign="top">
						<tr>
							<th class="SMALL" align="left"><u>Research group information:</u></th>
						</tr>
						<tr>
							<th> </th>
						</tr>
						<tr>
							<th class="SMALL" align="left">
							<xsl:value-of select="description"/>
							</th>
						</tr>
						<tr>
							<th><xsl:text> </xsl:text></th>
						</tr>
						<tr>
							<th><xsl:text> </xsl:text></th>
						</tr>
						<tr>
							<th><xsl:text> </xsl:text></th>
						</tr>
						<tr>
							<th class="SMALL" align="left"><u>Relative Links:</u></th>
						</tr>
						<tr>
							<th class="SMALL" align="left">						
							<xsl:value-of select="addlinks"/>
							</th>
						</tr>
						<tr>
							<th><xsl:text> </xsl:text></th>
						</tr>
						<tr>
							<th><xsl:text> </xsl:text></th>
						</tr>
						<tr>
							<th><xsl:text> </xsl:text></th>
						</tr>
						<tr>
							<th class="SMALL" align="left"><u>Members:</u></th>
						</tr>
						<tr>
							<th>
							<br />
							<ul>
							<xsl:apply-templates select="/eltrun/member_list/member[contains(@group,$ogroup)]" mode="shortref"/>
							</ul>
							</th>
						</tr>
					</tbody>
				</table>
				</th>
			</tr>
			</tbody>
		</table>
		</body>
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
			<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@scientific_coordinator]" mode="ref" />
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

	<!-- the body heading -->
	<xsl:template name="body-head">
		<img src="../images/heading.jpg" alt="eLTRUN - The e-Business Center" border="0" />
	</xsl:template>
	
	<!-- body menu -->
	<xsl:template name="body-menu">
		<table align="left" bgcolor="#f4c225" border="1">
			<tbody>
			<tr class="TableHeader">
				<th align="left">General</th>
			</tr>
			<tr>
				<th align="left"><a href="../groups/g_eltrun-members.html">Members</a></th>
			</tr>
			<tr>
				<th align="left"><a href="../groups/g_eltrun-current-projects.html">Current Projects</a></th>
			</tr>
			<tr>
				<th align="left"><a href="../groups/g_eltrun-completed-projects.html">Completed Projects</a></th>
			</tr>
			<tr>
				<th align="left"><a href="../publications/g_eltrun-publications.html">Publications</a></th>
			</tr>
			<tr>
				<th align="left"><a href="../groups/g_eltrun-alumni.html">Alumni</a></th>
			</tr>
			<tr>
				<th class="Tableheader" align="left">Research groups</th>
			</tr>	
			<xsl:apply-templates select="/eltrun/group_list/group" mode="menuref"/>
			</tbody>
		</table>
	</xsl:template>
	
	<!-- Main transformation {{{1 -->
	<xsl:template match="eltrun">
		<html>
		<xsl:comment>Generated by $Id$</xsl:comment>
		
		<!-- Output the element(s) -->
		<xsl:choose>
			
			<!-- if we choose current projects then -->
			<xsl:when test="$what = 'current-projects'">
				<!-- header -->
				<head>
					<title>eLTRUN - Current Projects</title>
					<link href="../images/styles.css" type="text/css" rel="stylesheet" />
				</head>
				<!--  body -->
				<body>
				<xsl:call-template name="body-head" />
				<br />
				<table width="750" border="0">
					<tbody valign="top">
					<tr>
						<th width="150">
						<xsl:call-template name="body-menu" />
						</th>
						<th align="left">
						<h2>Current Projects</h2>
						<xsl:apply-templates select="/eltrun/project_list/project [contains(@group, $ogroup)] [enddate &gt;= $today]" mode="ref">
							<xsl:sort select="shortname" order="ascending"/>
						</xsl:apply-templates>
						</th>
					</tr>
					</tbody>
				</table>	
				<br />
				</body>
			</xsl:when>

			<!-- Completed Projects -->
			<xsl:when test="$what = 'completed-projects'">
				<!-- header -->
				<head>
					<title>eLTRUN - Completed Projects</title>
					<link href="../images/styles.css" type="text/css" rel="stylesheet" />
				</head>
				<!--  body -->
				<body>
				<xsl:call-template name="body-head" />
				<br />				
				<table width="750" border="0">
					<tbody valign="top">
					<tr>
						<th width="150">
						<xsl:call-template name="body-menu" />
						</th>
						<th align="left">
						<h2>Completed Projects</h2>
						<xsl:apply-templates select="/eltrun/project_list/project [contains(@group, $ogroup)] [enddate &lt; $today]" mode="ref" >
							<xsl:sort select="shortname" order="ascending"/>
						</xsl:apply-templates>
						</th>
					</tr>
					</tbody>
				</table>	
				</body>
			</xsl:when>
			
			<!-- Members -->
			<xsl:when test="$what = 'members'">
				<!-- header -->
				<head>
					<title>eLTRUN - Members</title>
					<link href="../images/styles.css" type="text/css" rel="stylesheet" />
				</head>
				<!--  body -->
				<body>
				<xsl:call-template name="body-head" />
				<br />
				<table width="750" border="0">
					<tbody valign="top">
					<tr>
						<th width="150" valign="top">
						<xsl:call-template name="body-menu" />
						</th>
						<th align="left">
						<h2>
						Group Members
						</h2>
						<xsl:apply-templates select="/eltrun/member_list/member[contains(@group,$ogroup)]" mode="ref">
							<xsl:sort select="surname" order="ascending"/>
						</xsl:apply-templates>
						</th>
					</tr>
					</tbody>
				</table>	
				</body>
			</xsl:when>

			<!-- Project Details -->
			<xsl:when test="$what = 'project-details'">
				<xsl:apply-templates select="/eltrun/project_list/project [@id = $oproject]" mode="full" />
			</xsl:when>

			<!-- Member Publications -->
			<xsl:when test="$what = 'member-publications'">
				<h1>
				<xsl:apply-templates select="/eltrun/member_list/member [@id=$omember]" mode="ref" />
				: Publications
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
				<xsl:call-template name="group-head"/>
				: Publications
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
		</xsl:choose>
		</html>
	</xsl:template>
</xsl:stylesheet>
