path = File.expand_path "../../", __FILE__

require 'bundler/setup'
Bundler.require :models

# require 'dm-core'
# require 'dm-sqlite-adapter'
# 
# DataMapper.setup :default, "sqlite://#{APP_PATH}/db/app.sqlite"

env = ENV["RACK_ENV"]
if env == "production"
  pass = File.read(File.expand_path "~/.password").strip
  user = "root:#{pass}@" 
end

DataMapper.setup :default, "mysql://#{user}localhost/whoisy_#{env}"


# DataMapper::Model.raise_on_save_failure = true 
# 
# 
# Dir.glob("#{APP_PATH}/models/*").each do |model|
#   require model
# end

require "#{path}/lib/mhash"
Dir.glob("#{path}/models/*.rb").each do |model|
  require model
end
require 'voidtools'