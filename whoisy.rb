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
  
  set :haml, { :format => :html5 }
  require 'rack-flash'
  enable :sessions
  use Rack::Flash
  require 'sinatra/content_for'
  helpers Sinatra::ContentFor
  set :method_override, true

  require "#{APP_PATH}/lib/view_helpers"
  helpers ViewHelpers

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end

  get "/" do
    haml :index
  end
  
  
  # Whois
  
  WHOIS = Whois::Client.new
  R = Redis.new
    
  def whois(domain)
    begin
      if !R.sismember("domains", domain)
        result = WHOIS.query domain
        R.sadd "domains", domain
        R.zincrby "requests", domain, 1
        R.sadd("registered", domain) if result.registered?
        result
      else
        nil
      end
    rescue Whois::ServerNotFound
      nil
    rescue Timeout::Error
      # FIME: retry async, cache
      Thread.new {
        whois(domain)
      }
      nil 
    end
  end

  def whois_results
    @name = params[:name]
    whois(@name)
    @result = [@name, R.sismember("registered",@name)]
  end
  
  get '/migrate' do
    R.sadd "tld", "com"
    R.sadd "tld", "it"
    R.sadd "tld", "net"
    R.sadd "tld", "org"
    R.sadd "tld", "uk"
  end
  
  get "/whois/:name.json" do
    whois_results.map do |res|
      { name: res.domain, available: res.available? }
    end.to_json
  end

  get "/whois/*" do |name|
    params[:name] = name unless name == ""
    whois_results
    haml :index
  end
  

  get '/css/main.css' do
    sass :main
  end
  
end