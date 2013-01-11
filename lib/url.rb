require 'data_mapper'


class Url
  include DataMapper::Resource
  property  :id,          Serial
  property  :original,    String, :length => 2048
  property  :created_at,  DateTime

  def out
    id.to_s(36)
  end
end


