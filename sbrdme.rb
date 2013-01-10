%w(sinatra data_mapper json ).each  { |lib| require lib}

require_relative 'lib/url.rb'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:password@localhost/sbrdme')

configure :test do
  DataMapper.setup(:default, 'mysql://root:password@localhost/sbrdme_test')
  DataMapper.auto_migrate!
end

#DataMapper.auto_migrate!
DataMapper.finalize

get '/' do redirect 'http://songbird.me', 301 end

post '/' do
  host = request.host
  
  uri = URI::parse(params[:original])
  raise "Invalid URL" unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS
  url = Url.first_or_create(:original => uri.to_s)
  
   { 'url' => 'http://' + host + '/' + url.out }.to_json

end

get '/:url' do redirect Url.first(:id => params[:url].to_i(36) ).original, 301 end 


# TODO - add custom 404 page to site to deal with error reporting to users.
#error do haml :index end


