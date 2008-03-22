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
	<xsl:param name="today"/>
	
	<!-- page transformation {{{1-->
	<xsl:template match="page">
		<xsl:copy-of select="current()/page_body" />
	</xsl:template>

	<!-- Format a project reference {{{1 -->
	<xsl:template match="project">
		<li>
		<a href="../projects/{@id}.html">
			<xsl:value-of select="shortname" /> &#8212; <xsl:value-of select="projtitle" />
		</a>
		</li>
	</xsl:template>
	
	<!-- Format a member reference (with <li>) {{{1 -->
	<xsl:template match="member">
		<xsl:if test="count(alumnus) = 0">
			<li>
			<a href="../members/{@id}.html">
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
			</li>
		</xsl:if>
	</xsl:template>

	<!-- Format a member reference (without <li>) {{{1 -->
	<xsl:template match="member" mode="simple-ref">
		<xsl:if test="count(alumnus) = 0">
			<a href="../members/{@id}.html">
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
		</xsl:if>
	</xsl:template>
	
	<!-- Format a full group description {{{1-->
	<xsl:template match="group">
		<xsl:copy-of select="current()/description" />
		<p />
		<xsl:value-of select="current()/shortname" /><xsl:text> is headed by  </xsl:text>
		<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@director]" mode="simple-ref" /><xsl:text>.  </xsl:text>
		<br />
		<xsl:if test='current()/@director != current()/@contact'>
		Contact:
		<xsl:apply-templates select="/istlab/member_list/member [@id=current()/@contact]" mode="simple-ref" />
		</xsl:if>
	</xsl:template>
	
	<!-- main rule {{{1-->
	<xsl:template match="istlab">
		<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<link href="../images/styles.css" type="text/css" rel="stylesheet" />
			<link rel="shortcut icon" href="../images/favicon.ico" />
			<title>ISTLab brochure</title>
		</head>
		<body margin-left="0" margin-top="0">
			<div class="logo"><a href="http://istlab.dmst.aueb.gr/"><img src="../images/istlab-s.jpg" alt="ISTLab" align="middle" border="0" /></a></div>
			<div class="projecttitle">ISTLab &#8212; Information Systems Technology Laboratory</div>
			
			<!-- introduction -->
			<div class="title">Introduction</div>
			<div class="content">
				<xsl:for-each select="current()/group_list/group[@id = 'g_istlab']">
					<xsl:apply-templates select="current()" />
				</xsl:for-each>
			</div>
			
			<!-- groups -->
			<div class="title">Groups</div>
			<div class="content">
				<xsl:for-each select="current()/group_list/group[@id != 'g_istlab']">
					<h2><xsl:value-of select="current()/shortname" /><xsl:text> &#8212; </xsl:text><xsl:value-of select="current()/grouptitle" /></h2>
					<xsl:apply-templates select="current()" />
				</xsl:for-each>
			</div>
			
			<!-- Members -->
			<div class="title">Current Members</div>
			<div class="content">
				<ul>
				<xsl:for-each select="current()/member_list/member">
					<xsl:apply-templates select="current()">
						<xsl:sort select="givenname" order="ascending" />
					</xsl:apply-templates>
				</xsl:for-each>
				</ul>
			</div>
			
			<!-- Current Projects -->
			<div class="title">Current Projects</div>
			<div class="content">
				<ul>
				<xsl:apply-templates select="current()/project_list/project [enddate &gt;= $today]">
					<xsl:sort select="shortname" order="ascending"/>
				</xsl:apply-templates>
				</ul>
			</div>
			
			<!-- publications -->
			<div class="title">Recent Publications</div>
			<div class="content">

			<xsl:text>&#10;[book]&#10;</xsl:text>

			<xsl:text>&#10;[article]&#10;</xsl:text>

			<xsl:text>&#10;[incollection]&#10;</xsl:text>

			<xsl:text>&#10;[inproceedings]&#10;</xsl:text>

			<xsl:text>&#10;[techreport]&#10;</xsl:text>

			<xsl:text>&#10;[whitepaper]&#10;</xsl:text>

			<xsl:text>&#10;[workingpaper]&#10;</xsl:text>

			</div>
			
			<!-- Contact -->
			<div class="title">Contact Details</div>
			<div class="content">
				<xsl:apply-templates select="current()/page_list/page [@id = 'istlab-contact']" />
			</div>
		</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
