var incomingIps = context.getVariable("request.header.x-forwarded-for");
var custAttrIps = context.getVariable("verifyapikey.Verify-API-Key.ips");
custAttrIps = custAttrIps ? custAttrIps.split(",") : '';
var isValidIp = custAttrIps.indexOf(incomingIps) == -1 ? false : true;
context.setVariable("isValidIp", isValidIp);