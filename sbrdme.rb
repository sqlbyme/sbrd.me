%w(sinatra data_mapper json).each  { |lib| require lib}

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

get '/*' do redirect 'http://songbird.me', 301 end
