# requirements & configurations
require 'dotenv'
require 'better_errors'
require 'sinatra/activerecord'
require './config/environments'
require './models/user'
require 'octokit'
require 'json'

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

get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

# OAuth for Github

use OmniAuth::Builder do
  provider :github, ENV["GITHUB_TOKEN"], ENV["GITHUB_SECRET"]
end

get "/sign-in" do
  redirect "auth/github"
end

get "/auth/github/callback" do
  oauth_attrs       = request.env['omniauth.auth']
  @user = User.find_by(uid: oauth_attrs.uid)
  if @user.nil?
    @user = User.new
  end
  @user.uid         = oauth_attrs.uid
  @user.username    = oauth_attrs.info.nickname
  @user.email       = oauth_attrs.info.email
  @user.avatar_url  = oauth_attrs.info.image
  @user.token       = oauth_attrs.credentials.token
  @user.save
  session[:user_id] = @user.id
  redirect "/"
end

helpers do
  # helpers for sessions
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # helpers for parsing HTMl
  def link_to(text,url)
    "<a href=#{url}>#{text}</a>"
  end

  def asset_img(name)
    "<img src='images#{name}' alt='#{name}' />"
  end

  def web_img(url)
    "<img src='#{url}'/>"
  end
end

get "/sign-out" do
  session.clear
  redirect "/"
end

# Views

get "/" do
  erb :index
end

get "/gh-data/languages" do
  content_type :json
  current_user.repo_language_types.to_json
end

get "/gh-data/events" do
  content_type :json
  current_user.last_300_events.to_json
end
