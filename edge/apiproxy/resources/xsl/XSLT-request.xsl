<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ccot="ccotpservice.xsd.hdfcbank.com">
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
    <xsl:template match="ccotpserviceRequest">
    <soapenv:Envelope>
			<soapenv:Header/>
				<soapenv:Body>
    	 <xsl:element name="ccot:{name()}" >
            <xsl:copy-of select="namespace::*"/> 
			<xsl:apply-templates select="Trace_Number"/>
			<xsl:apply-templates select="Transaction_DateTimeStamp"/>
			<xsl:apply-templates select="ATM_POS_IVR_ID"/>
			<xsl:apply-templates select="Credit_Card_Number"/>
			<xsl:apply-templates select="callerId"/>
			<xsl:apply-templates select="instanceId"/>
			<xsl:apply-templates select="linkData"/>
			<xsl:apply-templates select="messageHash"/>
			<xsl:apply-templates select="refNo"/>
			<xsl:apply-templates select="customerMobileNo"/>
			<xsl:apply-templates select="otpPasswordValue"/>
			<xsl:apply-templates select="sms_userid"/>
			<xsl:apply-templates select="sms_password"/>
			<xsl:apply-templates select="ctype"/>
			<xsl:apply-templates select="sender"/>
			<xsl:apply-templates select="mobilenumber"/>
			<xsl:apply-templates select="msgtxt"/>
			<xsl:apply-templates select="departmentcode"/>
			<xsl:apply-templates select="submitdate"/>
			<xsl:apply-templates select="author"/>
			<xsl:apply-templates select="subAuthor"/>
			<xsl:apply-templates select="broadcastname"/>
			<xsl:apply-templates select="internationalflag"/>
			<xsl:apply-templates select="msgid"/>
			<xsl:apply-templates select="drlflag"/>
			<xsl:apply-templates select="dndalert"/>
			<xsl:apply-templates select="msgtype"/>
			<xsl:apply-templates select="priority"/>
			<xsl:apply-templates select="SOAStandardElements"/>
			<xsl:apply-templates select="soafillers"/>
		</xsl:element>
			</soapenv:Body>
	</soapenv:Envelope>
	</xsl:template>
	<xsl:template match="SOAStandardElements">
		<xsl:copy>
			<xsl:apply-templates select="service_user"/>
			<xsl:apply-templates select="service_password"/>
			<xsl:apply-templates select="consumer_name"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="soafillers">
		<xsl:copy>
			<xsl:apply-templates select="filler1"/>
			<xsl:apply-templates select="filler2"/>
			<xsl:apply-templates select="filler3"/>
			<xsl:apply-templates select="filler4"/>
			<xsl:apply-templates select="filler5"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>