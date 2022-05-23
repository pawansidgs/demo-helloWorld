var allowedOrigins = context.getVariable('private.allowed.origins');
var httpReferer = context.getVariable('request.header.HTTP-Referer');
var origin = context.getVariable('request.header.Origin');
var isValidCors = false;
allowedOrigins = allowedOrigins.split(',');
if (origin !== '' && origin !== null && httpReferer !== '' && httpReferer !== null) {
    var inc = 0;
    for (var i = 0; i < allowedOrigins.length; i++) {
        if (allowedOrigins[i].equals(origin) && allowedOrigins[i].equals(httpReferer)) {
            inc++;
        }
    }
    if (inc > 0) {
        isValidCors = true;
    }
    else {
        context.setVariable("isValidCorshttp-referer", true);
        throw 'CORS Validation Failed.';
    }
}
context.setVariable('isValidCors', isValidCors);