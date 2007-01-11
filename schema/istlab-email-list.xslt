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
	<xsl:output method="text" />

	<!-- main transformation {{{1 -->
	<xsl:template match="istlab">
		<xsl:for-each select="current()/member_list/member">
		<xsl:if test="count(current()/alumnus) = 0">
			<xsl:value-of select="current()/email"/><xsl:text>
</xsl:text>
		</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
