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
#DataMapper.auto_migrate!