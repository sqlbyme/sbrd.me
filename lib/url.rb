require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:password@localhost/snip')

class Url
  include DataMapper::Resource
  property  :id,          Serial
  property  :original,    String, :length => 255
  property  :created_at,  DateTime  
  def snipped() self.id.to_s(36) end  
end

DataMapper.finalize

# The DataMapper.auto_migrate command will only be used the first time we run the app
# on heroku in order to initialiaze the db. Once this is done we no longer need this line
# and it shoudl be removed.
#DataMapper.auto_migrate!