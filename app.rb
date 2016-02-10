require 'dotenv'
require 'better_errors'
require 'sinatra/activerecord'
require './config/environments'

Dotenv.load
Bundler.require

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

configure do
  set :scss, {:style => :compressed, :debug_info => false}
  enable :sessions
  set :session_secret, ENV["SESSION_SECRET"]
end

use OmniAuth::Builder do
  provider :github, ENV["GITHUB_TOKEN"], ENV["GITHUB_SECRET"]
end

get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

get "/" do
  erb :index
end

# OAuth for Github

get "/sign-in" do
  redirect "auth/github"
end

get "/auth/github/callback" do
  oauth_attrs       = request.env['omniauth.auth']
  raise
  redirect "/"
end
