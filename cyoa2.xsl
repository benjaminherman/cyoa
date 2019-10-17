<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  
  <!-- Root Template -->
  <xsl:template match="/book">
    <xsl:element name="html">
      
      <!-- HTML Head -->
      <xsl:element name="head">
        <xsl:element name="meta">
          <xsl:attribute name="charset">utf-8</xsl:attribute>
        </xsl:element>
        <xsl:element name="title">
          <xsl:value-of select="meta/title"/>
        </xsl:element>
        <xsl:if test="meta/description">
          <xsl:element name="meta">
            <xsl:attribute name="description">
              <xsl:value-of select="meta/description"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:element name="meta">
          <xsl:attribute name="name">viewport</xsl:attribute>
          <xsl:attribute name="content">width=device-width, initial-scale=1.0</xsl:attribute>
        </xsl:element>
      </xsl:element>
      
      <!-- HTML Body -->
      <xsl:element name="body">

        <!-- Pages -->
        <xsl:element name="main">
          <xsl:attribute name="id">content</xsl:attribute>
          <xsl:apply-templates select="pages/page">
            <xsl:sort select="position()" data-type="number" order="descending"></xsl:sort>
          </xsl:apply-templates>
        </xsl:element>
        
        <!-- Footer -->
        <xsl:element name="footer">
          <xsl:attribute name="id">footer</xsl:attribute>
          <xsl:element name="p">
            <xsl:apply-templates select="meta/footer" mode="format"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- Page Template -->
  <xsl:template match="page">
    <xsl:element name="div">
      <xsl:attribute name="class">page</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@ref"/>
      </xsl:attribute>
      <xsl:apply-templates select="p"/>
      <xsl:if test="choice">
        <xsl:element name="ul">
          <xsl:attribute name="class">choices</xsl:attribute>
          <xsl:apply-templates select="choice"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- Paragraph Template -->
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
  
  <!-- Choice Hyperlink Template -->
  <xsl:template match="choice">
    <xsl:element name="li">
      <xsl:attribute name="class">choice</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="concat('#', @dest)"/>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="format"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- String Formatting -->
  <xsl:template match="text()" mode="format">
    
    <!-- %title% -->
    <xsl:variable name="pass1">
      <xsl:call-template name="substitute-all">
        <xsl:with-param name="text" select="."/>
        <xsl:with-param name="replace" select="'%title%'"/>
        <xsl:with-param name="with" select="/book/meta/title"/>
      </xsl:call-template>
    </xsl:variable>
    
    <!-- %author% -->
    <xsl:variable name="pass2">
      <xsl:call-template name="substitute-all">
        <xsl:with-param name="text" select="$pass1"/>
        <xsl:with-param name="replace" select="'%author%'"/>
        <xsl:with-param name="with" select="/book/meta/author"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$pass2"/>
  </xsl:template>
  
  <!-- Substring Substitution Algorithm -->
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
