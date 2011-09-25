path = File.expand_path "../", __FILE__
APP_PATH = path

require 'bundler/setup'
Bundler.require :default


class Whoisy < Sinatra::Base
  require "#{APP_PATH}/config/env"
  
  configure :development do
    register Sinatra::Reloader
    also_reload ["controllers/*.rb", "models/*.rb", "public/projects/*.haml"]
    set :public, "public"
    set :static, true
  end
  
  set :haml, { :format => :html5 }
  require 'rack-flash'
  enable :sessions
  use Rack::Flash
  require 'sinatra/content_for'
  helpers Sinatra::ContentFor
  set :method_override, true
  
  require "#{APP_PATH}/lib/mhash"
  Dir.glob("#{APP_PATH}/models/*.rb").each do |model|
    require model
  end

  require "#{APP_PATH}/lib/view_helpers"
  helpers ViewHelpers

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end

  get "/" do
    haml :index
  end
  
  
  # Whois
  
  MANAGER = Whoiser.new
    
      
  def whois(domain)
    MANAGER.whois domain 
  end

  def whois_results
    @name = params[:name]
    @results = whois(@name)
  end
  
  get "/tld.json" do
    { results: Tld.all.map{ {tld: i} } }.to_json  
  end

  get "/whois/:name/infos.json" do
    keys = R.hkeys params[:name]
    results = {}
    keys.each do |k|
      results[k] = R.hget params[:name],k
    end
    results.to_json 
  end
  
  get "/whois/:name.json" do
    { results: whois_results.map do |domain|
      { name: domain.name, available: domain.available}
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