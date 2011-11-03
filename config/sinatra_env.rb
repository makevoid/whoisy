set :haml, { :format => :html5 }
require 'rack-flash'
enable :sessions
use Rack::Flash
require 'sinatra/content_for'
set :method_override, true