 var requestScope = context.getVariable("requestPayload.Scope");
 var appScopes = context.getVariable('verifyapikey.Verify-API-Key.app_scope');
 appScopes = appScopes ? appScopes.split(',') : '';
 var isValidScope = appScopes.indexOf(requestScope) == -1 ? false : true;
context.setVariable("isValidScope", isValidScope);