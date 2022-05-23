Feature: OTP Generation Feature 

Scenario: Success Response should come when we give valid encrypted Request Payload,Apikey and access token for OTP Generation Proxy
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
	    When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body path $.Scope should be Snehal_Test
        Then response body path $.TransactionId should be 281102020
        Then response body should contain SUCCESS
        Then response code should be 200

Scenario: 404-(Not Found) Error should occur when we are passing wrong base path
         Given I set client_credentials
         And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration           
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
	    When I POST to /API/OTP_Gen/abc/abcs;lxk
        Then response header Content-Type should be text/plain
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain Error Code : Content Not Found
        Then response code should be 404

Scenario: 400-(Bad Request) error will occur when we pass wrong payload
        Given I store the raw value ./test/integration/features/fixtures/bad_request.json as myFilePath in scenario scope
        Given I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
        And I have valid client TLS configuration
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain TH99400: Bad Request
        Then response code should be 400

Scenario: 400-(Bad Request) error will occur when Decryption Failed
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/Decryption_Fail.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
		When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain TH99400: Decryption Failed
        Then response code should be 400

Scenario: 400-(Bad request) error will be occur when code injection is performed in message payload
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/code_Injection.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`        |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json 
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body path $.Scope should be Snehal_Test
        Then response body path $.TransactionId should be 281102020
        Then response body should contain TH99400: Code Injection Detected in API Request Message Payload
        Then response code should be 400


Scenario: 401-(Unauthorized) Give a Request Payload with invalid Api key for OTP Generation Proxy
        And I set test variables
        And I have valid client TLS configuration
        And I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `InvalidVerifyAPiKey`|
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
		When I POST to /API/OTP_Gen
        Then response body should contain TH99401: Invalid API Key
        Then response header Content-Type should be application/json 
        Then response code should be 401

Scenario: 401-(Unauthorized) error will occur when we will try to access with invalid scope
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/Scope_Val_Fail.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`        |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json 
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain TH99401: Scope Validation Failed
        Then response code should be 401

Scenario: 401-(Unauthorized) error will be occur when ever Signature verification Failed
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/sign_ver_fail.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`        |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json 
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain TH99401: Signature verification Failed 
        Then response code should be 401
		
Scenario: 405-(Method Not Allowed) Error should occur when i pass wrong method type (passes GET but it was POST) 
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        Given I set test variables
        Given I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
        Given I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
       And I store new access token `Token` into the request payload `myFilePath`
       And I pipe contents of file `myFilePath` to body
       And I GET /API/OTP_Gen
       Then response header Content-Type should be application/json
       Then response header X-Quota-Remaining should exist
       Then response header X-Quota-Allowed should exist
       Then response header X-Quota-Reset-Time should exist
       Then response body should contain TH99405: Request Method Not Allowed For API Access
       Then response code should be 405

Scenario: 411-(Length_Required) Error occurs when i am passing wrong Content-Type that doesn't match's with requeat payload
        And I set test variables
        And I have valid client TLS configuration
        And I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value         |
            | Content-Type  | test/plain    |
            | apikey        | `ApiKey`      |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
		When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain TH99411: Invalid Content Type in API Request Message Payload
        Then response code should be 411

Scenario: 412-(Precondition Failed) error should occur when we try to access with same access token
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
        And I pipe contents of file `myFilePath` to body
		When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body path $.Scope should be Snehal_Test
        Then response body path $.TransactionId should be 281102020
        Then response body path $.Status should be TH99412: Oauth Token Validation failed 
        Then response code should be 412

Scenario: 412-(Precondition Failed) Error should occur when i passes invalid OAuth access token
        And I have valid client TLS configuration
        Given I set test variables
        Given I store the raw value ./test/integration/features/fixtures/invalidOAuth.json as myFilePath in scenario scope
        Given I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json 
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body should contain TH99412: Oauth Token Validation failed 
        Then response code should be 412

Scenario: 422-(SQL Injection) Error should occur whenever we finds SQL commands in api payload
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/sql_Injection.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`        |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist 
        Then response code should be 422

Scenario: 421-(Misdirect request) error will be occur when ever JSON or XML threat Detected
        Given I set client_credentials
        And I have valid client TLS configuration
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy
        And I have valid client TLS configuration
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/Doc_Structure.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`        |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
        When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json 
        Then response header X-Quota-Remaining should exist
        Then response header X-Quota-Allowed should exist
        Then response header X-Quota-Reset-Time should exist
        Then response body path $.Scope should be Snehal_Test
        Then response body path $.TransactionId should be 281102020
        Then response body should contain TH99421: Document Structure Threat in API Request Message Payload
        Then response code should be 421

Scenario: 410-(Gone) error when try to access with wrong origin CORS get failed
        Given I set client_credentials
        And I have valid client TLS configuration  
        When I POST to /auth/oauth/v2/token
        Then I store the value of body path $.access_token as Token in global scope
        Then Send request to OTP Generation Proxy      
        And I have valid client TLS configuration              
        And I set test variables
        And I store the raw value ./test/integration/features/fixtures/otp_generation.json as myFilePath in scenario scope
		Then I set headers to
            | name          | value           |
            | Content-Type  | application/json|
            | apikey        | `ApiKey`|
            | HTTP-Referer  | apiruntime.hybrid.dev.sidglobal.i |
            | origin        | apiruntime.hybrid.dev.sidglobal.io |
        And I store new access token `Token` into the request payload `myFilePath`
        And I pipe contents of file `myFilePath` to body
	    When I POST to /API/OTP_Gen
        Then response header Content-Type should be application/json
        Then response body path $.Status should be TH99410: Cross Site Forgery Detected in API Request Message Payload
        Then response code should be 410