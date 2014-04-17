require 'sinatra'
require 'haml'
require 'sass'
require 'data_mapper'
require './lib/utility'
require './lib/mutilator'
require './models/log'

Utility.setup_db

set :haml, :format=>:html5

get '/' do
  haml :index
end

get '/admin/logs' do
  @records = Log.all(order: [:requested_at.desc])
  haml :logs
end

get('/main.css'){ sass :main }
get('/proxy.css'){ sass :proxy }

get '/serve' do
  log(params[:url])
  @site = Mutilator.new(params[:url], '/serve?url=').rewrite_page
  haml :proxy, :layout => false
end

def log(url)
 url = "http://#{url}" unless Utility.url?(url) 
 hostname = Utility.get_hostname(url)
 Log.create(hostname: hostname, ip: request.ip, requested_at: Time.now)
end
