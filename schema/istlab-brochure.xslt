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
	
	<!-- main rule -->
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
			<div class="projecttitle">ISTLab - Information Systems Technology Laboratory</div>
			
			<!-- introduction -->
			<div class="title">Introduction</div>
			<div class="content">
				<!-- <xsl:for-each select="current()/group_list/group[@id = 'g_istlab']">
					
				</xsl:for-each> -->
			</div>
			
			<!-- publications -->
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
		</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>