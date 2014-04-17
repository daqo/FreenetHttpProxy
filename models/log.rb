class Log
  include DataMapper::Resource
  property :id, Serial
  property :hostname, String
  property :ip, String
  property :requested_at, DateTime
end