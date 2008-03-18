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
	<xsl:param name="year"/> <!-- possible options of group -->
	
	<!-- Format a project reference {{{1 -->
	<xsl:template match="project">
		<li>
		<a href="../projects/{@id}.html">
			<xsl:value-of select="shortname" /> - <xsl:value-of select="projtitle" />
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
			<title>ISTLab yearly report - <xsl:value-of select="$year" /></title>
		</head>
		<body margin-left="0" margin-top="0">
		<div class="logo"><a href="http://istlab.dmst.aueb.gr/"><img src="../images/istlab-s.jpg" alt="ISTLab" align="middle" border="0" /></a></div>
		<div class="projecttitle">ISTLab yearly report - <xsl:value-of select="$year" /></div>
		
		<div class="content">
			<ul>
				<li><a href="#cprojects">Completed Projects</a></li>
				<li><a href="#nprojects">New Projects</a></li>
				<li><a href="#members">New Members</a></li>
				<li><a href="#phd">Completed PhDs</a></li>
				<li><a href="#pubs">Publications</a></li>
			</ul>
		</div>
		
		<a name="cprojects"></a>
		<div class="title">Completed Projects</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/project_list/project">
				<xsl:if test="starts-with(current()/enddate,$year)">
					<xsl:apply-templates select="current()" />
				</xsl:if>
			</xsl:for-each>
			</ul>
		</div>
		
		<a name="nprojects"></a>
		<div class="title">New Projects</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/project_list/project">
				<xsl:if test="starts-with(current()/startdate,$year)">
					<xsl:apply-templates select="current()" />
				</xsl:if>
			</xsl:for-each>
			</ul>			
		</div>
		
		<a name="members"></a>
		<div class="title">New Members</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/member_list/member">
				<xsl:if test="starts-with(current()/@joined,$year)">
					<xsl:apply-templates select="current()" />
				</xsl:if>
			</xsl:for-each>
			</ul>
		</div>
		
		<a name="phd"></a>
		<div class="title">Completed PhDs</div>
		<div class="content">
			<ul>
			<xsl:for-each select="current()/member_list/member">
				<xsl:if test="starts-with(current()/phd-info/@enddate,$year)">
					<xsl:apply-templates select="current()" />
				</xsl:if>
			</xsl:for-each>
			</ul>			
		</div>
		
		<a name="pubs"></a>
		<div class="title">Publications</div>
		<div class="content">
		
		<h2>Monographs and Edited Volumes</h2>
		<xsl:text>[book]</xsl:text>
		
		<h2>Journal Articles</h2>
		<xsl:text>[article]</xsl:text>
		
		<h2>Book Chapters</h2>
		<xsl:text>[incollection]</xsl:text>
		
		<h2>Conference Publications</h2>
		<xsl:text>[inproceedings]</xsl:text>
		
		<h2>Technical Reports</h2>
		<xsl:text>[techreport]</xsl:text>
		
		<h2>White Papers</h2>
		<xsl:text>[whitepaper]</xsl:text>
		
		<h2>Working Papers</h2>
		<xsl:text>[workingpaper]</xsl:text>
			
		</div>	
		</body>
		</html>		
	</xsl:template>
	
</xsl:stylesheet>
