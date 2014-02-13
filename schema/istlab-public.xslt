<?xml version="1.0"?>
<!--
 -
 - Transform the ISTLab data into HTML web pages
 -
 - (C) Copyright 2004 Diomidis Spinellis
 -
 - $Id$
 -
 -->

<!-- Global definitions {{{1 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:param name="today" />	<!-- today's date -->
<xsl:param name="ogroup" />	<!-- limit output to (projects/members) of a given group -->
<xsl:param name="oproject" />	<!-- limit output to a given project -->
<xsl:param name="omember" />	<!-- limit output to a given member -->
<xsl:param name="opage" />	<!-- limit output to a given page -->
<xsl:param name="what" />	<!-- Output:
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
					| rel-pages
					| announce
				-->
<xsl:param name="menu"/>        <!-- Turn Side menu:
					  on (default is on)
					| off
				-->
	<!-- Generate heading with group name {{{1 -->
	<xsl:template match="group" mode="heading">
		<xsl:if test="@id = $ogroup">
			ISTLab &#8212; <xsl:value-of select="shortname" />:
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
	
	<!-- Format an ISO date ommiting day {{{1 -->
	<xsl:template name="date-phd">
		<xsl:param name="date" />
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
		<xsl:if test="count(has_magazine) != 0">
			<li><a href="#magazine">Magazines</a></li>
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
		<xsl:if test="count(has_magazine) != 0">
			<a name="magazine"> </a><h2>Magazines</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'magazine'" />
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
			<xsl:if test="count(memb_title) != 0 and current()/memb_title = 'Dr.'">
				<xsl:value-of select="memb_title" />
				<xsl:text> </xsl:text>
			</xsl:if>				
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
		</xsl:if>
	</xsl:template>
	
	<!-- Format a member reference {{{1-->
	<xsl:template match="member" mode="pub-ref" >
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0 and current()/memb_title = 'Dr.'">
			<xsl:value-of select="memb_title" />
			<xsl:text> </xsl:text>
		</xsl:if>				
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
	</xsl:template>

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="ref">
		<xsl:if test="count(alumnus) = 0">
			<li>
			<a href="../members/{@id}.html">
			<xsl:if test="count(memb_title) != 0 and current()/memb_title = 'Dr.'">
				<xsl:value-of select="memb_title" />
				<xsl:text> </xsl:text>
			</xsl:if>				
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
			<xsl:if test="$ogroup = 'g_istlab' and /istlab/group_list/group [@id = $ogroup]/@director = @id">
			&#8212; current lab director
			</xsl:if>
			<xsl:if test="/istlab/group_list/group/@director = @id">
				<xsl:variable name="tmpgroup" select="/istlab/group_list/group [@director = current()/@id and @id != 'g_istlab']/@id" />
				&#8212; <a href="../groups/{$tmpgroup}-details.html"><xsl:value-of select="/istlab/group_list/group[@id = $tmpgroup]/shortname" /></a> group leader
			</xsl:if>
			</li>
		</xsl:if>
	</xsl:template>

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="alumnus-ref">
		<xsl:if test="count(alumnus) != 0">
		<li>
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0 and current()/memb_title = 'Dr.'">
			<xsl:value-of select="memb_title" />
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
		<xsl:if test="count(memb_title) != 0 and current()/memb_title = 'Dr.'">
			<xsl:value-of select="memb_title" />
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Format member plain text -->
	<xsl:template match="member" mode="plaintext">
		<xsl:value-of select="current()/givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="current()/surname" />
	</xsl:template>
	
	<!-- Format members information {{{1 -->
	<xsl:template match="member" mode="full">
		<div class="projecttitle">
		<xsl:text> </xsl:text>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		<xsl:if test="count(current()/phd-info) = 1">
			<xsl:if test="current()/phd-info/@completed = 0">
				(PhD Student)
			</xsl:if>
		</xsl:if>
		</div>
		<table border="0">
		<tr>
		<td valign="top" class="content">
		<xsl:if test="count(photo) != 0">
			<img src="{current()/photo}" alt="{current()/givenname} {current()/surname}" />
		</xsl:if>
		<!-- TODO: put a smaller icon for a non-existing photo -->
		<xsl:if test="count(photo) = 0">
			<img src="../images/lamp.png" width="80%" height="80%" alt="{current()/givenname} {current()/surname}"/>
		</xsl:if>
		<br /> <br />
		</td>
		<td class="content">
		<xsl:if test="count(alumnus) != 0">
			<font color="#FF0000">
			<h4>(ISTLab associate)</h4>
			</font>
		</xsl:if>
		<xsl:if test="count(email) != 0">
			<!-- print the email in 'bkarak at aueb.gr form -->
			E-mail: <xsl:value-of select="substring-before(current()/email,'@')"/><img src="../images/at.gif" align="top" /><xsl:value-of select="substring-after(current()/email,'@')"/>
			<br />
		</xsl:if>
		<xsl:if test="count(office_phone) != 0">
			Office phone: <xsl:value-of select="office_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(mobile_phone) != 0">
			Mobile phone: <xsl:value-of select="mobile_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(Fax) != 0">
			Fax: <xsl:value-of select="fax" />
			<br />
		</xsl:if>
		<xsl:if test="count(office_address) != 0">
			Office address: <xsl:value-of select="office_address"/>
			<br />
		</xsl:if>
		<xsl:if test="count(postal_address) != 0">
			Postal address: <xsl:value-of select="postal_address"/>
			<br />
		</xsl:if>
		<xsl:if test="count(web_site) != 0">
			Web site: <a href="{web_site}"><xsl:value-of select="web_site"/></a>
			<br />
		</xsl:if>
		<xsl:if test="count(web_log) != 0">
		    Web Log: <a href="{web_log}"><xsl:value-of select="web_log"/></a>
		    <br/>
		</xsl:if>
		<xsl:if test="count(github) != 0">
		    Github: <a href="{github}"><xsl:value-of select="github"/></a>
		    <br/>
		</xsl:if>
		<!-- List group membership, if any -->
		<xsl:if test="@group != 'g_istlab'">
			Groups: <xsl:apply-templates select="/istlab/group_list/group [contains(current()/@group, @id)]" mode="shortref"/>
			<br />
		</xsl:if>
		</td></tr>
		</table>
		<div class="content">
		<!-- Provide publications link, if any publications exist -->
		<xsl:if test="count(/istlab/publication_type_list/publication_type [@for = current()/@id]/has_any) != 0">
			<br />
			<a href="../publications/{$omember}-publications.html">Publication list</a>
		</xsl:if>		
		<br />
		<br />
		<h3>Summary</h3>
		<xsl:copy-of select="current()/shortcv"/>
		</div>
		<xsl:if test="count(current()/phd-info) = 1 and current()/phd-info/@completed = 0">
		<div class="content">
		<h3>PhD Thesis</h3>
		<b>Title: </b><xsl:value-of select="current()/phd-info/phd-title"/><br/>
		<b>Supervisor: </b>
			<xsl:choose>
				<xsl:when test="count(current()/phd-info/@supervisor) = 1">
					<xsl:apply-templates select="/istlab/member_list/member [@id=current()/phd-info/@supervisor]" mode="simple-ref" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="current()/phd-info/@supervisor-external"/>
				</xsl:otherwise>
			</xsl:choose><br/>
		<b>Starting date: </b> 
		<xsl:call-template name="date-phd">
			<xsl:with-param name="date" select="current()/phd-info/@startdate" />
		</xsl:call-template>
		<br/><br/>
		<xsl:copy-of select="current()/phd-info/phd-summary"/>
		</div>
		</xsl:if>
	</xsl:template>

	<!-- Format a short group reference {{{1 -->
	<xsl:template match="group" mode="shortref" >
		<xsl:if test="@id != 'g_istlab'">
			<a href="../groups/{@id}-details.html">
			<xsl:value-of select="shortname" />
			</a>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Format a full group description {{{1-->
	<xsl:template match="group" mode="full">
		<xsl:if test="$ogroup != 'g_istlab'">
		<div class="title">Group Details</div>
		<br />
		</xsl:if>
		<div class="content">
		<xsl:if test="count(logo) != 0">
			<img src="{current()/logo}" alt="{current()/shortname} &#8212; {current()/grouptitle}" />
		</xsl:if>
		<xsl:if test='count(director_photo) != 0'>
			<img src="{current()/director_photo}" alt="{current()/surname}" />
			<br />
		</xsl:if>
		<xsl:if test="$ogroup != 'g_istlab'">
		<br /><br />
		Group leader:
		<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@director]" mode="simple-ref" />
		<br /><br />
		</xsl:if>
		<xsl:if test='current()/@director != current()/@contact'>
		Contact:
		<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@contact]" mode="simple-ref" />
		<br /><br />
		</xsl:if>
		<xsl:copy-of select="current()/description" />
		</div>
	</xsl:template>
	
	<!-- Format a project reference {{{1 -->
	<xsl:template match="project" mode="ref">
		<li>
		<a href="../projects/{@id}.html">
			<xsl:value-of select="shortname" /> &#8212; <xsl:value-of select="projtitle" />
		</a>
		</li>
	</xsl:template>

	<!-- List project details {{{1 -->
	<xsl:template match="project" mode="full">
		<div class="projecttitle">
		<xsl:value-of select="shortname" />
		-
		<xsl:value-of select="projtitle" />
		</div>
		<!-- Show Logo -->
		<div class="content">
		<xsl:if test="count(logo) != 0">
			<img src="{current()/logo}" alt="{current()/shortname} Logo" />
		</xsl:if>
		<br /><br />		
		<!-- Project Summary information -->
		<xsl:if test="count(project_code) != 0">
			Project Code:
			<xsl:value-of select="project_code" />
			<xsl:if test="@international = 'yes'">(International)</xsl:if>
			<br/>
		</xsl:if>
		<xsl:if test="count(funding_programme) != 0">
			Funding programme: <xsl:value-of select="funding_programme" />
			<br />
		</xsl:if>
		<xsl:if test="count(funding_agency) != 0">
			Funding Agency: <xsl:value-of select="funding_agency" />
			<br />
		</xsl:if>
		<xsl:if test="@type != ''">
			Project type:
			<xsl:choose>
				<xsl:when test="@type = 'rtd'">RTD</xsl:when>
				<xsl:when test="@type = 'consulting'">Consulting</xsl:when>
				<xsl:when test="@type = 'training'">Training</xsl:when>
				<xsl:when test="@type = 'dissemination'">Dissemination</xsl:when>
			</xsl:choose>
			<br />
		</xsl:if>
		<xsl:if test="count(web_site) != 0">
			Web site: <a href="{current()/web_site}"><xsl:value-of select="web_site" /></a>
			<br /><br />
		</xsl:if>
		<!-- Show starting date -->
		<xsl:if test="startdate != ''">
			Starting date:
			<xsl:call-template name="date">
				<xsl:with-param name="date" select="startdate" />
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:if test="enddate != ''">
			Ending date:
			<xsl:call-template name="date">
				<xsl:with-param name="date" select="enddate" />
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:if test="count(our_budget) != 0">
			ISTLab budget: <xsl:value-of select="our_budget" />
			<br />
		</xsl:if>
		<xsl:if test="count(total_budget) != 0">
			Total budget: <xsl:value-of select="total_budget" />
			<br />
		</xsl:if>
		<br />
		<!-- Show ISTLab related info -->
		<xsl:if test="@scientific_coordinator != ''">
			Scientific coordinator:
			<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@scientific_coordinator]" mode="simple-ref" />
			<br />
		</xsl:if>
		<xsl:if test="@project_manager != ''">
			Project Manager:
			<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@project_manager]" mode="simple-ref" />
			<br />
		</xsl:if>
		<xsl:if test="@contact != ''">
			Contact:
			<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@contact]" mode="simple-ref" />
		<br />
		</xsl:if>
		<!-- Show groups this project belongs to -->
		Groups:
		<xsl:apply-templates select="/istlab/group_list/group [contains(current()/@group, @id)]" mode="shortref" />
		<!-- Provide publications link, if any publications exist -->
		<xsl:if test="count(/istlab/publication_type_list/publication_type [@for = current()/@id]/has_any) != 0">
			<br/><br />
			<a href="../publications/{@id}-publications.html">Publication List</a>
		</xsl:if>
		<br />
		<br />
		<xsl:if test="count(description) != 0">
			<h2>Description</h2>
			<xsl:copy-of select="current()/description" />
			<br />
		</xsl:if>
		<xsl:if test="count(partner) != 0">
			<h2>Partners</h2>
			<ul>
			<xsl:for-each select="current()/partner">
				<li>
				<xsl:if test="count(web_site) != 0">
					<a href="{current()/web_site}"><xsl:value-of select="current()/shortname"/> (<xsl:value-of select="current()/country"/>)</a>
				</xsl:if>
				<xsl:if test="count(web_site) = 0">
					<xsl:value-of select="current()/shortname"/> (<xsl:value-of select="current()/country"/>)
				</xsl:if>
				</li>
			</xsl:for-each>
			</ul>
		</xsl:if>
		</div>
	</xsl:template>

	<!-- body menu {{{1-->
	<xsl:template name="body-menu">
		<xsl:param name="bodygroup" />
		<div class="leftmenutitle">
			<xsl:choose>
				<xsl:when test="$bodygroup = 'g_istlab'">ISTLab</xsl:when>
				<xsl:otherwise>
					ISTLab &#8212; <xsl:value-of select="/istlab/group_list/group[@id = $bodygroup]/shortname" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="leftmenu">
			<xsl:if test="$bodygroup != 'g_istlab'">
				<a href="../groups/{$bodygroup}-details.html">Group Details</a><br />
			</xsl:if>
			<a href="../groups/{$bodygroup}-members.html">Members</a><br />
			<a href="../groups/{$bodygroup}-current-projects.html">Current Projects</a><br />
			<a href="../groups/{$bodygroup}-completed-projects.html">Completed Projects</a><br />
			<a href="../publications/{$bodygroup}-publications.html">Publications</a><br />
			<xsl:if test="count(/istlab/member_list/member[contains(@group,$bodygroup)]/alumnus) != 0">
				<a href="../groups/{$bodygroup}-alumni.html">Associates</a><br />
			</xsl:if>
			<xsl:if test="count(/istlab/page_list/page[@group = $bodygroup]) != 0">				
				<xsl:for-each select="/istlab/page_list/page[@group = $bodygroup]">
					<a href="../rel_pages/{@id}-page.html"><xsl:value-of select="page_name" /></a><br />
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="count(/istlab/group_list/group[@id = $bodygroup]/rel_link) != 0">
				<xsl:for-each select="/istlab/group_list/group[@id = $bodygroup]/rel_link">
					<xsl:copy-of select="current()/*" /><br />
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="$bodygroup = 'g_istlab'">
				<a href="../announce/announcements.html">Announcements</a><br />
			</xsl:if>
		</div>
	</xsl:template>

	<!-- page transformation {{{1-->
	<xsl:template match="page" mode="full">
		<div class="title"><xsl:value-of select="page_name" /></div>
		<div class="content">
		<xsl:copy-of select="current()/page_body" />
		</div>
	</xsl:template>
	
	<xsl:template match="announce">
		<h2><xsl:value-of select="current()/announce_title" /></h2>	
		<p>
			<xsl:copy-of select="current()/announce_body" /><br />
			<small>
				<xsl:text>Posted by </xsl:text>
				<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@member]" mode="simple-ref" />
				<xsl:text> @ </xsl:text>
				<xsl:call-template name="date">
					<xsl:with-param name="date" select="current()/@last_update" />
				</xsl:call-template>
			</small>
		</p>
	</xsl:template>

	<!-- Main transformation {{{1 -->
	<xsl:template match="istlab">
		<html>
		<!-- HEAD -->
		<head>
		<link href="../images/styles.css" type="text/css" rel="stylesheet" />
		<link rel="shortcut icon" href="../images/favicon.ico" />
		<xsl:comment>Generated by $Id$</xsl:comment>
		<title>
		<!-- Append the appropriate title -->
		<xsl:if test="$ogroup != ''">
			<xsl:value-of select="/istlab/group_list/group[@id = $ogroup]/shortname" />
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$what = 'project-publications'">
				<xsl:value-of select="/istlab/project_list/project[@id = $oproject]/shortname" />
				<xsl:text> publication list</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'current-projects'">
				<xsl:text> &#8212; Current Projects</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'completed-projects'">
				<xsl:text> &#8212; Completed Projects</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'members'">
				<xsl:text> &#8212; Members</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'project-details'">
				<xsl:value-of select="/istlab/project_list/project[@id = $oproject]/shortname" />
				<xsl:text> &#8212; Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'member-publications'">
				<xsl:apply-templates select="/istlab/member_list/member[@id = $omember]" mode="plaintext" />
				<xsl:text> publication list</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'group-publications'">
				<xsl:text> publication list</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'member-details'">
				<xsl:apply-templates select="/istlab/member_list/member[@id = $omember]" mode="plaintext" />
				<xsl:text> Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'group-details'">
				<xsl:text> &#8212; Group Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'alumni'">
				<xsl:text> &#8212; Research Associates</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'rel-pages'">
				<xsl:variable name="tmpgroup" select="/istlab/page_list/page[@id = $opage]/@group" />
				<xsl:value-of select="/istlab/group_list/group[@id = $tmpgroup]/shortname" />
				-
				<xsl:value-of select="/istlab/page_list/page[@id = $opage]/page_name" />
			</xsl:when>
			<xsl:when test="$what = 'announce'">
				<xsl:text>&#8212; Announcements</xsl:text>
			</xsl:when>
		</xsl:choose>
		</title>
		</head>

		<!-- BODY -->
		<body margin-left="0" margin-top="0">
		<div class="logo">
			<a href="http://istlab.dmst.aueb.gr/"><img src="../images/istlab-s.jpg" alt="ISTLab" align="middle" border="0" /></a>
		</div>
		<xsl:choose>
			<xsl:when test="$what = 'rel-pages'">
			<div class="projecttitle">
				<xsl:variable name="tmpgroup" select="/istlab/page_list/page[@id = $opage]/@group" />
				<xsl:value-of select="/istlab/group_list/group[@id = $tmpgroup]/shortname" />
				-
				<xsl:value-of select="/istlab/group_list/group[@id = $tmpgroup]/grouptitle" />
			</div>
			</xsl:when>
			<!-- No Title Bar with Group name for these -->
			<xsl:when test="$what = 'project-details'"></xsl:when>
			<xsl:when test="$what = 'member-details'"></xsl:when>
			<xsl:when test="$what = 'member-publications'"></xsl:when>
			<xsl:when test="$what = 'project-publications'"></xsl:when>
			<!--<xsl:when test="$what = 'announce'"></xsl:when>
			<xsl:when test="$what = 'group-details'">
				<div class="projecttitle">
				<xsl:value-of select="/istlab/group_list/group[@id = $ogroup]/shortname" />
				-
				<xsl:value-of select="/istlab/group_list/group[@id = $ogroup]/grouptitle" />
				</div>
			</xsl:when> -->
			<!-- For all the rest, announce and group-details -->
			<xsl:otherwise>
				<div class="projecttitle">
				<xsl:value-of select="/istlab/group_list/group[@id = $ogroup]/shortname" />
				-
				<xsl:value-of select="/istlab/group_list/group[@id = $ogroup]/grouptitle" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
			<xsl:if test="$menu != 'off'">
				<td valign="top">
				<xsl:if test="$what = 'rel-pages'">
					<xsl:call-template name="body-menu">
						<xsl:with-param name="bodygroup" select="/istlab/page_list/page[@id = $opage]/@group" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$what != 'rel-pages'">
					<xsl:call-template name="body-menu">
						<xsl:with-param name="bodygroup" select="$ogroup" />
					</xsl:call-template>
				</xsl:if>
				</td>
			</xsl:if>			
			<td valign="top" width="100%">
			<!-- choose which HTML to show -->
			<xsl:choose>
				<!-- Current projects -->
				<xsl:when test="$what = 'current-projects'">
					<div class="title">Current Projects</div>
					<div class="content">
					<ul>
						<xsl:apply-templates select="/istlab/project_list/project [contains(@group, $ogroup)] [enddate &gt;= $today]" mode="ref">
							<xsl:sort select="shortname" order="ascending"/>
						</xsl:apply-templates>
					</ul>
					</div>
				</xsl:when>
				<!-- Completed Projects -->
				<xsl:when test="$what = 'completed-projects'">
					<div class="title">Completed Projects</div>
					<div class="content">
					<ul>
						<xsl:apply-templates select="/istlab/project_list/project [contains(@group, $ogroup)] [enddate &lt; $today]" mode="ref" >
							<xsl:sort select="shortname" order="ascending"/>
						</xsl:apply-templates>
					</ul>
					</div>
				</xsl:when>
				<!-- members -->
				<xsl:when test="$what = 'members'">
					<div class="title">Members</div>
					<div class="content">
					<ul>
						<xsl:apply-templates select="/istlab/member_list/member[contains(@group,$ogroup)]" mode="ref">
							<xsl:sort select="surname" order="ascending"/>
						</xsl:apply-templates>
					</ul>
					</div>
				</xsl:when>
				<!-- project details -->
				<xsl:when test="$what = 'project-details'">
					<xsl:apply-templates select="/istlab/project_list/project [@id = $oproject]" mode="full" />
				</xsl:when>
				<!-- Member Publications -->
				<xsl:when test="$what = 'member-publications'">
					<div class="projecttitle">
					<xsl:apply-templates select="/istlab/member_list/member [@id=$omember]" mode="pub-ref" /> : Publications
					</div>
					<div class="content">
					<h2>Contents</h2>
					<xsl:apply-templates select="/istlab/publication_type_list/publication_type [@for = $omember]" mode="toc" />
					<xsl:apply-templates select="/istlab/publication_type_list/publication_type [@for = $omember]" mode="full" >
						<xsl:with-param name="pubid" select="$omember" />
					</xsl:apply-templates>
					</div>
				</xsl:when>
				<!-- project publications -->
				<xsl:when test="$what = 'project-publications'">
					<div class="projecttitle">
					<a href="../projects/{$oproject}.html">
						<xsl:apply-templates select="/istlab/project_list/project[@id = $oproject]/shortname" />
					</a>
					: Publications
					</div>
					<div class="content">
					<h2>Contents</h2>
					<xsl:apply-templates select="/istlab/publication_type_list/publication_type [@for = $oproject]" mode="toc" />
					<xsl:apply-templates select="/istlab/publication_type_list/publication_type [@for = $oproject]" mode="full">
						<xsl:with-param name="pubid" select="$oproject" />
					</xsl:apply-templates>
					</div>
				</xsl:when>
				<!-- group publications -->
				<xsl:when test="$what = 'group-publications'">
					<div class="title">
					<xsl:if test="$ogroup != 'g_istlab'">
					<a href="../groups/{$ogroup}-details.html">
						<xsl:apply-templates select="/istlab/group_list/group [@id = $ogroup]/shortname" />
					</a>
					:
					</xsl:if>
					Publications
					</div>
					<div class="content">
					<h2>Contents</h2>
					<xsl:apply-templates select="/istlab/publication_type_list/publication_type [@for = $ogroup]" mode="toc" />
					<xsl:apply-templates select="/istlab/publication_type_list/publication_type [@for = $ogroup]" mode="full" >
						<xsl:with-param name="pubid" select="$ogroup" />
					</xsl:apply-templates>
					</div>
				</xsl:when>
				<!-- member details -->
				<xsl:when test="$what = 'member-details'">
					<xsl:apply-templates select="/istlab/member_list/member[@id = $omember]" mode="full" />
				</xsl:when>
				<!-- group details -->
				<xsl:when test="$what = 'group-details'">
					<xsl:apply-templates select="/istlab/group_list/group[@id = $ogroup]" mode="full" />
				</xsl:when>
				<!-- alumni -->
				<xsl:when test="$what = 'alumni'">
					<div class="title">Research Associates</div>
					<div class="content">
					<ul>
						<xsl:apply-templates select="/istlab/member_list/member [contains(@group,$ogroup)]" mode="alumnus-ref" />
					</ul>
					</div>
				</xsl:when>				
				<!-- rel-pages -->
				<xsl:when test="$what = 'rel-pages'">
					<xsl:apply-templates select="/istlab/page_list/page[@id = $opage]" mode="full"/>
				</xsl:when>
				<!-- announcements -->
				<xsl:when test="$what = 'announce'">
					<div class="title">Announcements</div>
					<div class="content">						
						<xsl:for-each select="/istlab/announce_list/announce">
							<xsl:sort select="current()/@date" data-type="text" order="ascending" />
							<!--<xsl:if test="current()/@date">-->
								<xsl:apply-templates select="current()" />
							<!--</xsl:if>-->
						</xsl:for-each>
					</div>
				</xsl:when>
			</xsl:choose>
			</td>
			</tr>
		</table>
		<hr />
		<font size="-2">
		<!--Creative Commons License--><a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/2.5/"><img hspace="4" align="left" alt="Creative Commons License" style="border-width: 0" src="http://creativecommons.org/images/public/somerights20.png"/></a>
		Unless otherwise expressly stated, all original material on this page created by members of the ISTLab is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/2.5/">Creative Commons Attribution-Noncommercial-No Derivative Works 2.5  License</a>.
		<!--/Creative Commons License--><!-- <rdf:RDF xmlns="http://web.resource.org/cc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
			<Work rdf:about="">
				<license rdf:resource="http://creativecommons.org/licenses/by-nc-nd/2.5/" />
			<dc:date>2006</dc:date>
			<dc:rights><Agent><dc:title>Diomidis Spinellis</dc:title></Agent></dc:rights>
			<dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
			</Work>
			<License rdf:about="http://creativecommons.org/licenses/by-nc-nd/2.5/"><permits rdf:resource="http://web.resource.org/cc/Reproduction"/><permits rdf:resource="http://web.resource.org/cc/Distribution"/><requires rdf:resource="http://web.resource.org/cc/Notice"/><requires rdf:resource="http://web.resource.org/cc/Attribution"/><prohibits rdf:resource="http://web.resource.org/cc/CommercialUse"/></License></rdf:RDF> -->
		</font>
<!--	<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
		<script type="text/javascript">
			_uacct = "UA-1927509-1";
			urchinTracker();
		</script> -->
		</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
