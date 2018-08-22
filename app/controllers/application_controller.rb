require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "abacus-secret"
  end

  get '/' do
    if logged_in?
      redirect to '/users/:slug'
    else
      erb :index
    end
  end

  get '/logout' do
    if logged_in?
      sessions.clear
      redirect to '/'
    else
      redirect to "/users/#{@user.slug}"
    end
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      if logged_in?
        @user = User.find(session[:user_id])
      end
    end

  end

end
