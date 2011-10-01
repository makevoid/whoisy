path = File.expand_path "../../", __FILE__
ENV["RACK_ENV"] = ARGV[0] || "development"
APP_PATH = path 

require "#{path}/config/env"



DataMapper.auto_migrate!

dom = Domain.create name: "makevoid", ext: "com"

mkvd = User.create email: "makevoid@gmail.com"


dom.user = mkvd
dom.save

dom.results.create available: false

dom = Domain.create name: "makevoid", ext: "net"
dom.results.create available: true

sleep 2

dom = Domain.create name: "makevoid", ext: "it"
dom.results.create available: true