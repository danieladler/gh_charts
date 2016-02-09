require 'dotenv'

Dotenv.load
Bundler.require

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

get "/auth/github" do
end

get "/auth/github/callback" do
end
