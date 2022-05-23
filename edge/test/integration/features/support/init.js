'use strict';

const apickli = require('apickli');
const fs = require('fs');
const path = require('path');
var {Before, BeforeAll, Given, Then, When,setDefaultTimeout} = require('cucumber');
var testVariables = require('./testVariables.json');
var fixturesDirectory = './../fixtures'
Before(function() {
   process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
    this.apickli = new apickli.Apickli('https', 'api-uat.hdfcbank.com');
    this.apickli.addRequestHeader('Cache-Control', 'no-cache');
    this.apickli.clientTLSConfig = {
      valid: {
        key: './test/mock_target/certs/key.pem',
        cert: './test/mock_target/certs/cert.pem',
             // passphrase: './test/mock_target/certs/passphrase.txt'
      },
    };
   
});

Given(/^Send request to OTP Generation Proxy$/, function(){
  this.apickli = new apickli.Apickli('https', 'api-uat.hdfcbank.com');
  this.apickli.clientTLSConfig = {
    valid: {
      key: './test/mock_target/certs/key.pem',
      cert: './test/mock_target/certs/cert.pem',
           // passphrase: './test/mock_target/certs/passphrase.txt'
    },
  };
});
Given(/^I set test variables$/, function (callback) {
    let variables=testVariables
    for(var key in variables){
         this.apickli.setGlobalVariable(key,variables[key]);
    }
    callback();
});

Given(/^I set client_credentials$/, function(callback) {
  this.apickli =new apickli.Apickli('https' ,'api-uat.hdfcbank.com');
  this.apickli.clientTLSConfig = {
    valid: {
      key: './test/mock_target/certs/key.pem',
      cert: './test/mock_target/certs/cert.pem',
           // passphrase: './test/mock_target/certs/passphrase.txt'
    },
  };
  this.apickli.addHttpBasicAuthorizationHeader(testVariables.client_id, testVariables.client_secret);
  this.apickli.addRequestHeader('Content-Type', testVariables.content_type);
  this.apickli.setQueryParameters(testVariables.queryParam);
  callback();
});

Then(/^I store new access token (.*) into the request payload (.*)$/, function(token,file,callback){
  file = this.apickli.replaceVariables(file);
  token = this.apickli.replaceVariables(token);
  
  fs.readFile(path.join(this.apickli.fixturesDirectory, file), 'utf8', function(err, data) {
    if (err) {
      callback(err);
    } else {
      let dataVal = JSON.parse(data);
      dataVal.OAuthTokenValue = token;
      fs.writeFile(file, JSON.stringify(dataVal , null , 2), err => {
        if(err)
        {
          console.log(err);
        }
      })
      callback();
    }
  });
});
setDefaultTimeout(60 * 1000);