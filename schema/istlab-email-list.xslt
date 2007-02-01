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
	<xsl:param name="ogroup"/> <!-- possible options of group -->
	<xsl:param name="what" /> 
	<!-- possible options:
	members-all (all except alumni)
	members-phd (current phd students)
	members-gl (group leader(s))
	members-alumni
	 -->
	
	<xsl:output method="text" />

	<!-- main transformation {{{1 -->
	<xsl:template match="istlab">
		<xsl:choose>
			<xsl:when test="$what = 'members-all'">
				<xsl:for-each select="current()/member_list/member[ contains(@group, $ogroup) ]">
					<xsl:if test="count(current()/alumnus) = 0">
						<xsl:value-of select="current()/email"/><xsl:text> 
</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$what = 'members-phd'">
				<xsl:for-each select="current()/member_list/member[ contains(@group, $ogroup) ]">
					<xsl:if test="count(current()/alumnus) = 0">
						<xsl:if test="count(current()/phd-info) = 1">
						<xsl:value-of select="current()/email"/><xsl:text> 
</xsl:text>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$what = 'members-alumni'">
				<xsl:for-each select="current()/member_list/member[ contains(@group, $ogroup) ]">
					<xsl:if test="count(current()/alumnus) = 1">
						<xsl:value-of select="current()/email"/><xsl:text> 
</xsl:text>
					</xsl:if>
				</xsl:for-each>			
			</xsl:when>
			<xsl:when test="$what = 'members-gl'">
				<xsl:for-each select="current()/group_list/group [ contains(@id, $ogroup) ]">
					<xsl:value-of select="/istlab/member_list/member[ @id = current()/@director ]/email" /><xsl:text> 
</xsl:text>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
