# sbrd.me - Url Minifier for Songbird.me

## Dependencies
* You will need to setup an rvm environment running ruby-1.9.3-p194.
  * You will also need to create a gemset called `sbrd.me`
    * note: make sure you remember to issue `rvm use ruby-1.9.3-p194@sbrd.me` from the command line.
  
## Setup 
1. Install the dependencies
2. Run `gem install bundler`
3. Run `bundle install`
4. Run `bundle exec rackup -s thin -p 8000`

## Tests
1. Run `RACK_ENV=test bundle exec rake spec`

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
    404 - Bad request - we return a custom message
    500 - Server Error
  
## API Features

##### API Endpoints

  * Staging - http://staging.sbrd.me
  
  * Production - http://www.sbrd.me

##### Url Minifier

A client may shorten any valid url by submitting a POST request to the service.  The POST request must contain 
a key labeled 'original' and the value of this key must be a valid URI.

 Sample request with curl:

    curl --data 'original=http://www.songbird.me' http://www.sbrd.me
  
 Valid Response:
 
    {
        "url" : "http://www.sbrd.me/1"
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
  
    curl http://www.sbrd.me/1 -v
    
  Valid Response:
  
    < HTTP/1.1 301 Moved Permanently
    < Content-Type: text/html;charset=utf-8
    < Location: http://www.songbird.me
    < Server: thin 1.2.7 codename No Hup
    < X-Content-Type-Options: nosniff
    < X-Frame-Options: SAMEORIGIN
    < X-Xss-Protection: 1; mode=block
    < Content-Length: 0
    < Connection: keep-alive
    < 

## Branches

This repo consist of three branches, they are:
  1. checkin
  2. 7digital
  3. birdhouse

The branches correspond to apps running at heroku, each with a slightly different version of the sbrdme.rb file.
We use the sbrdme platform to act as a router for two of the Songbird Classic Desktop legacy apps. 7digital refers 
to the old 7digital music store which used to be available to users of the Classic Desktop. Birdhouse refers to 
the old startup url for first time users of the Classic Desktop application.  Since there are specific urls which
these apps use it, was preferable to just create separate apps at heroku to handle the routing requests. Since the
base code was very similar it was simplest to just branch off of checkin and then fine tune the routes for each 
application.  Then the appropriate apps were created at heroku and each branch pushed to the master for the app.

#### Pushing
To push to each app you'll need to do the following:

##### sbrdme-staging:
      git remote add staging git@heroku.com:sbrdme-staging.git
      git push staging checkin:master
    
##### sbrdme-producion:
      git remote add production git@heroku.com:sbrdme-production.git
      git push production checkin:master
    
##### sbrdme-7digital-staging
      git remote add 7digital-staging git@heroku.com:sbrdme-7digital-staging.git
      git push 7digital-staging 7digital:master
    
##### sbrdme-7digital-production
      git remote add 7digital-production git@heroku.com:sbrdme-7digital-production.git
      git push 7digital-production 7digital:master
    
##### sbrdme-birdhouse-staging
      git remote add birdhouse-staging git@heroku.com:sbrdme-birdhouse-staging.git
      git push birdhouse-staging birdhouse:master
    
#####sbrdme-birdhouse-production
      git remote add birdhouse-production git@heroku.com:sbrdme-birdhouse-production.git
      git push birdhouse-production birdhouse:master
