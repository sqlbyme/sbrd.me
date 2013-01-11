require 'spec_helper'

describe 'App' do

  let :original do
    "http://songbird.me/"
  end
  
  describe 'GET / ' do
    it 'should redirect to songbird.me' do
      get '/' 
      last_response.should be_redirect
      follow_redirect!
      last_request.url.should == original
    end
  end

  describe 'POST /' do
    it "should create a db entry for the url" do
      post "/", :original => original
      
      Url.count(:original => original).should == 1
    end
    
    it 'should respond with a minified url' do
      post "/", :original => original
      
      res = JSON.parse(last_response.body)
      
      res["url"].should_not be_nil
    end
    
    context 'when the url already exists' do
      
      let :url do
        Url.create(:original => original)
      end
      
      before do
        url
      end
      
      it "should not create a new entry for the url" do
        Url.count(:original => original).should == 1
        
        post "/", :original => original
        
        Url.count(:original => original).should == 1
      end
      
      it "should return a short url" do
      end
    
    end
  end
end
