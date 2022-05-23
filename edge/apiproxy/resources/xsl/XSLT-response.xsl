<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:wsa="http://www.w3.org/2005/08/addressing" 
        xmlns:instra="http://xmlns.oracle.com/sca/tracking/1.0">
    
<xsl:strip-space elements="*"/>
  <!-- This will skip all SOAP-env related elements --> 
  <xsl:template match="env:*|wsa:*|instra:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <!-- this will copy all elements without the namespace declaration -->  
	<xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>