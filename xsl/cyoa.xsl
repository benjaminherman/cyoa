<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/book">
    <xsl:element name="html">
      <xsl:element name="head">
        <xsl:element name="meta">
          <xsl:attribute name="charset">utf-8</xsl:attribute>
        </xsl:element>
        <xsl:element name="title">
          <xsl:value-of select="meta/title"/>
        </xsl:element>
        <xsl:element name="meta">
          <xsl:attribute name="name">viewport</xsl:attribute>
          <xsl:attribute name="content">width=device-width, initial-scale=1.0</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates select="meta/style"/>
      </xsl:element>
      <xsl:element name="body">
        <xsl:attribute name="data-start">
          <xsl:value-of select="meta/start/@dest"/>
        </xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="id">metabar</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">title</xsl:attribute>
            <xsl:value-of select="meta/title"/>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="class">author</xsl:attribute>
            <xsl:value-of select="meta/author"/>
          </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="pages/page"/>
        <xsl:apply-templates select="meta/script"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="style">
    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="@ref"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="script">
    <xsl:element name="script">
      <xsl:attribute name="src">
        <xsl:value-of select="@ref"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="page">
    <xsl:element name="div">
      <xsl:attribute name="class">page</xsl:attribute>
      <xsl:attribute name="data-page-number">
        <xsl:value-of select="@number"/>
      </xsl:attribute>
      <xsl:apply-templates select="p"/>
      <xsl:if test="choice">
        <xsl:element name="div">
          <xsl:attribute name="class">choices</xsl:attribute>
          <xsl:apply-templates select="choice"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template match="p">
    <xsl:element name="p">
      <xsl:if test="@style">
        <xsl:attribute name="class">
          <xsl:value-of select="@style"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="format"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="choice">
    <xsl:element name="a">
      <xsl:attribute name="class">choice</xsl:attribute>
      <xsl:attribute name="data-dest">
        <xsl:value-of select="@dest"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="format"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="text()" mode="format">
    <xsl:variable name="pass1">
      <xsl:call-template name="substitute-all">
        <xsl:with-param name="text" select="."/>
        <xsl:with-param name="replace" select="'%title%'"/>
        <xsl:with-param name="with" select="/book/meta/title"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="pass2">
      <xsl:call-template name="substitute-all">
        <xsl:with-param name="text" select="$pass1"/>
        <xsl:with-param name="replace" select="'%author%'"/>
        <xsl:with-param name="with" select="/book/meta/author"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$pass2"/>
  </xsl:template>
  <xsl:template name="substitute-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="$text = ''">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text, $replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="substitute-all">
          <xsl:with-param name="text" select="substring-after($text, $replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
