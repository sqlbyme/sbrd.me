# sbrd.me - Url Minifier for Songbird.me

## Dependencies
* You will need to setup an rvm environment running ruby-1.9.3-p194.
  * You will also need to create a gemset called `sbrd.me`
    * note: make sure you remember to issue `rvm use ruby-1.9.3-p194@sbrd.me` from the command line.
  
## Setup 
1. Install the dependencies
2. Run `gem install bundler`
3. Run `bundle install`
4. Run `bundle exec rackup config.ru -p 8000`

## API Spec for Web based clients

##### Notes:

- This doc and APIs are a work in progress.  The APIs signatures and responses should not be considered final in any form.
See the section on versioning for details on currently supported versions.

- All calls will use HTTP endpoints.
- All requests are in text format and must include a valid URI string.
- All responses will be in JSON format.
- GET requests must include a url key in order for a redirect to be generated. 

#### Summary of the HTTP Status Codes:
  
    200 - OK
    400 - Bad request
    500 - Server Error
  
#### API Features

##### Url Minifier

A client may shorten any valid url by submitting a POST request to the service.  The POST request must contain 
a key labeled 'original' and the value of this key must be a valid URI.

 Sample request with curl:

    curl --data 'original=http://www.songbird.me' http://www.sbrd.me
  
 Valid Response:
 
    {
        "url" : "http://www.sbrd.me/f"
    }
    Status Code: 200
    
  Sample request with curl to Staging:
  
    curl --data 'original=http://www.songbird.me/' http://staging.sbrd.me
    
  Valid Response:
  
    {
        "url" : "http://staging.sbrd.me/1"
    }
    Status Code: 200

##### Minified Url Redirector

A client may submit a minified url back to the service in order to be redirected back to the original url contained
within the database.  Clients need only to submit a parameter with the GET request and the system will lookup the 
original URL and generate a 301 redirect to the original URL.

  Sample request with curl:
  
    curl http://sbrd.me/d -v
    
  Valid Response:
  
    < HTTP/1.1 301 Moved Permanently
    < X-Frame-Options: SAMEORIGIN
    < X-XSS-Protection: 1; mode=block
    < X-Content-Type-Options: nosniff
    < Content-Type: text/html;charset=utf-8
    < Location: http://www.feco.net/
    < Content-Length: 0
    < Connection: keep-alive
