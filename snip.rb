%w(sinatra data_mapper json ).each  { |lib| require lib}

require_relative 'lib/url.rb'

get '/' do redirect "http://songbird.me" end

post '/' do
  uri = URI::parse(params[:original])
  raise "Invalid URL" unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS
  url = Url.first_or_create(:original => uri.to_s)
  
  content_type :json
  { 'url' => url }.to_json
end

get '/:url' do redirect Url.first(:id => params[:url] ).original end 


# TODO - add custom 404 page to site to deal with error reporting to users.
#error do haml :index end


