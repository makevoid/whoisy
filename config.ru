path = File.expand_path "../", __FILE__

#use Rack::Reloader
require "#{path}/whoisy"
run Whoisy