<?xml version="1.0"?>
<!--
 -
 - Obtain IDs from the eltrun data
 -
 - (C) Copyright 2004 Diomidis Spinellis
 -
 - $Id$
 -
 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" />
<xsl:param name="category"/>	<!-- which category to output -->

	<!-- Output group ids -->
	<xsl:template match="group" >
		<xsl:if test="$category = 'group'">
			<xsl:value-of select="@id" />
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Output member ids -->
	<xsl:template match="member">
		<xsl:if test="$category = 'member'">
			<xsl:value-of select="@id" />
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Output project ids -->
	<xsl:template match="project">
		<xsl:if test="$category = 'project'">
			<xsl:value-of select="@id" />
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Ignore the rest -->
	<xsl:template match="publication_list">
	</xsl:template>
	<xsl:template match="publication_type_list">
	</xsl:template>
	<xsl:template match="seminar_list">
	</xsl:template>

</xsl:stylesheet>
