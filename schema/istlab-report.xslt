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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="year" /> <!-- year -->
	<xsl:param name="cyear" /> <!-- current year -->
	
	<!-- Format a project reference {{{1 -->
	<xsl:template match="project">
		<li>
		<a href="../projects/{@id}.html">
			<xsl:value-of select="shortname" /> &#8212; <xsl:value-of select="projtitle" />
		</a>
		</li>
	</xsl:template>
	
	<!-- Format a member reference {{{1 -->
	<xsl:template match="member">
		<xsl:if test="count(alumnus) = 0">
		<li>
		<a href="../members/{@id}.html">
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		<xsl:if test="count(current()/phd-info) = 1">
			<xsl:text> (PhD student)</xsl:text>
		</xsl:if>
		</li>
		</xsl:if>
	</xsl:template>
	
	<!-- main transformation {{{1 -->
	<xsl:template match="istlab">
		<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<link href="../images/styles.css" type="text/css" rel="stylesheet" />
			<link rel="shortcut icon" href="../images/favicon.ico" />
			<xsl:if test="$year != $cyear">
				<title>ISTLab Yearly Report &#8212; <xsl:value-of select="$year" /></title>
			</xsl:if>
			<xsl:if test="$year = $cyear">
				<title>ISTLab Interim Yearly Report &#8212; <xsl:value-of select="$year" /></title>
			</xsl:if>
		</head>
		<body margin-left="0" margin-top="0">
		<div class="logo"><a href="http://istlab.dmst.aueb.gr/"><img src="../images/istlab-s.jpg" alt="ISTLab" align="middle" border="0" /></a></div>
		<xsl:if test="$year != $cyear">
			<div class="projecttitle">ISTLab Yearly Report &#8212; <xsl:value-of select="$year" /></div>
		</xsl:if>
		<xsl:if test="$year = $cyear">
			<div class="projecttitle">ISTLab Interim Yearly Report &#8212; <xsl:value-of select="$year" /></div>
		</xsl:if>		
		<div class="content">
			<ul>
				<li><a href="#pubs">Publications</a></li>
				<xsl:if test='count(current()/project_list/project [starts-with(enddate,$year)]) != 0'>
					<li><a href="#cprojects">Completed Projects</a></li>
				</xsl:if>
				<xsl:if test="count(current()/project_list/project [starts-with(startdate,$year)]) != 0">
					<li><a href="#nprojects">New Projects</a></li>
				</xsl:if>
				<xsl:if test="count(current()/member_list/member [starts-with(@joined,$year)]) != 0">
					<li><a href="#members">New Members</a></li>
				</xsl:if>
				<xsl:if test="count(current()/member_list/member/phd-info [starts-with(@enddate,$year)]) != 0">
					<li><a href="#phd">Completed PhDs</a></li>
				</xsl:if>
			</ul>
		</div>

		<a name="pubs"></a>
		<div class="title">Publications</div>
		<div class="content">
		
		<xsl:text>&#10;[book]&#10;</xsl:text>
		
		<xsl:text>&#10;[article]&#10;</xsl:text>
		
		<xsl:text>&#10;[incollection]&#10;</xsl:text>
		
		<xsl:text>&#10;[inproceedings]&#10;</xsl:text>
		
		<xsl:text>&#10;[techreport]&#10;</xsl:text>
		
		<xsl:text>&#10;[whitepaper]&#10;</xsl:text>
		
		<xsl:text>&#10;[workingpaper]&#10;</xsl:text>
			
		</div>
		
		<xsl:if test='count(current()/project_list/project [starts-with(enddate,$year)]) != 0'>
		<a name="cprojects"></a>	
		<div class="title">Completed Projects</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/project_list/project [starts-with(enddate,$year)]">
				<xsl:apply-templates select="current()" />
			</xsl:for-each>
			</ul>
		</div>
		</xsl:if>
		
		<xsl:if test="count(current()/project_list/project [starts-with(startdate,$year)]) != 0">
		<a name="nprojects"></a>
		<div class="title">New Projects</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/project_list/project [starts-with(startdate,$year)]">
					<xsl:apply-templates select="current()" />
			</xsl:for-each>
			</ul>		
		</div>
		</xsl:if>
		
		<xsl:if test="count(current()/member_list/member [starts-with(@joined,$year)]) != 0">
		<a name="members"></a>
		<div class="title">New Members</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/member_list/member [starts-with(@joined,$year)]">
				<xsl:apply-templates select="current()" />
			</xsl:for-each>
			</ul>
		</div>
		</xsl:if>
		
		<xsl:if test="count(current()/member_list/member/phd-info [starts-with(@enddate,$year)]) != 0">
		<a name="phd"></a>
		<div class="title">Completed PhDs</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/member_list/member/phd-info [starts-with(@enddate,$year)]">
				<xsl:apply-templates select=".." />
			</xsl:for-each>
			</ul>			
		</div>
		</xsl:if>
		
		</body>
		</html>		
	</xsl:template>
	
</xsl:stylesheet>
