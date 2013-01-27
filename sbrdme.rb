%w(sinatra data_mapper json).each  { |lib| require lib}

require_relative 'lib/url.rb'

DataMapper::Logger.new($stdout, :info)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://root:#{ENV['DB_PWD'] || 'password'}@localhost/sbrdme")

configure :test do
  DataMapper.setup(:default, "mysql://root:#{ENV['DB_PWD'] || 'password'}@localhost/sbrdme_test")
  DataMapper.auto_migrate!
end

#DataMapper.auto_migrate!
DataMapper.finalize

error do
  content_type :json
  status 500

  e = env['sinatra.error']
  {:status => 500, :message => e.message}.to_json
end

not_found do
  status 404
  'The page you are looking for does not exist.'
end

get '/' do redirect 'http://songbird.me', 301 end

post '/' do
  content_type :json

  host = request.host
  port = request.port
  host << ":#{port}" if port != 80

  uri = URI::parse(params[:original])
  raise "Invalid URL" unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS
  url = Url.first_or_create(:original => uri.to_s)

  { 'url' => 'http://' + host + '/' + url.out }.to_json
end

get '/:url' do
  url = Url.first(:id => params[:url].to_i(36))
  url ? redirect(url.original, 301) : raise(Sinatra::NotFound)
end
