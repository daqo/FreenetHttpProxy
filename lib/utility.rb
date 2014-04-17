require_relative '../models/log'

class Utility
  def Utility.url?(url)
    !(URI.parse(url).scheme.nil?)
  end

  def Utility.get_hostname(url)
    url.split('/')[2]
  end

  def Utility.setup_db
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/proxy.db")
    DataMapper.finalize
    Log.auto_upgrade!
  end
end
