require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "abacus-secret"
    use Rack::Flash
  end

  get '/' do
    erb :index
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def current_group
      if logged_in?
        @group = Group.find(session[:group_id])
      end
    end

  end

end
