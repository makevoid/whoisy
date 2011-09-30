path = File.expand_path "../../", __FILE__

require 'bundler/setup'
Bundler.require :models

# require 'dm-core'
# require 'dm-sqlite-adapter'
# 
# DataMapper.setup :default, "sqlite://#{APP_PATH}/db/app.sqlite"
DataMapper.setup :default, "mysql://#{"root:final33man" if ENV["RACK_ENV" ]=="production"}localhost/whoisy_#{ENV["RACK_ENV"] || "development"}"
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