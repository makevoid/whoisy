path = File.expand_path "../", __FILE__
APP_PATH = path

require 'bundler/setup'
Bundler.require :default


class Whoisy < Sinatra::Base

  configure :development do
    set :public_folder, "public"
    set :static, true
  end

  require "#{APP_PATH}/config/env"
  include Voidtools::Sinatra::ViewHelpers

  require "#{APP_PATH}/config/sinatra_env"
  helpers Sinatra::ContentFor

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

  def domain_tld
    Whoiser.tld domain_name
  end

  def tld_given
    domain_name =~ /\./
  end

  def tld_matches_if_given
    tld_given ? Tld.all.include?(domain_tld) : true
  end

  def valid_domain?
    domain_name =~ /[a-z.]{3,}/ && tld_matches_if_given
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


  def domain_name
    params[:domain].to_s.downcase
  end

  get "/whois/:domain" do
    if valid_domain?
      domains = []
      results = whois domain_name
      results.each do |domain|
        domains << { name: domain.name, ext: domain.ext, available: domain.available }
      end
      { results: domains }.to_json
    else
      handle_error
    end
  end

  def handle_error
    message = if tld_matches_if_given
      "domain not valid: #{domain_name}"
    else
      "extension not found: #{domain_tld}"
    end
    { error: message }.to_json
  end

  get "/whois" do
    { results: [
      { name: "makevoid.com", ext: "com", available: true },
      { name: "makevoid.net", ext: "net", available: true },
    ] }.to_json
  end


  get "/whois/*" do |name|
    params[:domain] = name unless name == ""
    @results = whois domain_name
    haml :index
  end


  helpers do
    def partial(template, item)
      @item = item
      haml template, :layout => false
    end
  end

end