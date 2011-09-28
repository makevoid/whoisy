path = File.expand_path "../", __FILE__
APP_PATH = path

require 'bundler/setup'
Bundler.require :default


class Whoisy < Sinatra::Base
  
  configure :development do
    register Sinatra::Reloader
    also_reload ["controllers/*.rb", "models/*.rb", "public/projects/*.haml"]
    set :public, "public"
    set :static, true
  end
  
  require "#{APP_PATH}/config/env"
  include Voidtools::Sinatra::ViewHelpers

  
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
  
  WHOISER = Whoiser.new
    
      
  def whois(domain)
    WHOISER.whois domain 
  end

  def whois_results
    @name = params[:domain]
    @results = whois(@name)
  end
  
  def valid_domain?
    params[:domain] =~ /\./ && Tld.all.include?(Whoiser.tld(params[:domain]))
  end
  
  get "/tld.json" do
    { results: Tld.all.map{ {tld: i} } }.to_json  
  end

  get "/whois/:name/infos.json" do
    keys = R.hkeys params[:domain]
    results = {}
    keys.each do |k|
      results[k] = R.hget params[:domain],k
    end
    results.to_json 
  end
  
  get "/whois/:domain" do
    if valid_domain?
      domains = []
      whois_results.each do |domain|
        domains << { name: domain.name, ext: domain.ext, available: domain.available }
      end 
      { results: domains }.to_json 
    else
      { error: "domain not valid: #{params[:domain]}" }.to_json
    end
  end
  
  get "/whois" do
    { results: [
      { name: "makevoid.com", ext: "com", available: true },
      { name: "makevoid.net", ext: "net", available: true },
    ] }.to_json
  end
    
  get "/whois/*" do |name|
    params[:domain] = name unless name == ""
    
    whois_results
    haml :index
  end
  
  
  helpers do
    def partial(template, item)
      @item = item
      haml template, :layout => false
    end
  end
  
end