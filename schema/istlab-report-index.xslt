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
	<xsl:output method="html" />
	
	<xsl:template match="dir">
		<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<link href="../images/styles.css" type="text/css" rel="stylesheet" />
			<link rel="shortcut icon" href="../images/favicon.ico" />
			<title>ISTLab yearly report index page</title>
		</head>
		<body margin-left="0" margin-top="0">
		<div class="logo"><a href="http://istlab.dmst.aueb.gr/"><img src="../images/istlab-s.jpg" alt="ISTLab" align="middle" border="0" /></a></div>
		<div class="projecttitle">ISTLab Yearly Reports</div>
		<ul>
		<xsl:for-each select="f">
			<xsl:if test="starts-with(current()/@n,'istlab')">
				<li><a href="{current()/@n}"><xsl:value-of select="substring(current()/@n, 1, string-length(current()/@n) - 5)" /></a></li>
			</xsl:if>
		</xsl:for-each>
		</ul>
		</body>
		</html>
	</xsl:template>	
</xsl:stylesheet>