require 'haml'
require 'sass'
require 'sinatra'
require 'redis'
enable :sessions

require 'json'
require 'whois'

path = File.expand_path "../", __FILE__
APP_PATH = path

class Whoisy < Sinatra::Base
  require "#{APP_PATH}/config/env"
  
  configure :development do
    #use Rack::Reloader#, path: "#{APP_PATH}/public"
  end
  
  set :haml, { :format => :html5 }
  require 'rack-flash'
  enable :sessions
  use Rack::Flash
  require 'sinatra/content_for'
  helpers Sinatra::ContentFor
  set :method_override, true

  require "#{APP_PATH}/models/whois_manager"

  require "#{APP_PATH}/lib/view_helpers"
  helpers ViewHelpers

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end

  get "/" do
    haml :index
  end
  
  
  # Whois
  
  MANAGER = WhoisManager.new
  R = WhoisManager::R
    
      
  def whois(domain)
    MANAGER.whois domain 
  end

  def whois_results
    @name = params[:name]
    @results = whois(@name)
  end
  
  # TODO: uncomment when ready for production
  # if ENV["RACK_ENV"] == "development"
  get '/migrate' do
    R.flushdb
    R.sadd "tld", "com"
    R.sadd "tld", "it"
    R.sadd "tld", "net"
    R.sadd "tld", "org"
    R.sadd "tld", "uk"
    "redis migrated! (don't forget me :D)"
  end
  # end

  get "/whois/:name/infos.json" do
    keys = R.hkeys params[:name]
    results = {}
    keys.each do |k|
      results[k] = R.hget params[:name],k
    end
    results.to_json 
  end
  
  get "/whois/:name.json" do
    { results: whois_results.map do |res|
      { name: res[0], available: res[1]}
    end }.to_json 
  end

  get "/whois/*" do |name|
    params[:name] = name unless name == ""
    
    whois_results
    haml :index
  end
  

  get '/css/main.css' do
    sass :main
  end
  
  helpers do
    def partial(template, item)
      @item = item
      haml template, :layout => false
    end
  end
  
end