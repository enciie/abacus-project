require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "abacus-secret"
  end

  get "/" do
    if logged_in?
      redirect to '/users/:slug'
    else
      erb :index
    end
  end

  get "/signup" do
    erb :"/users/create_user"
  end

  post "/signup" do # create a new user
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/groups'
    end
  end

  get "/login" do
    erb :"/users/login"
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      sessions.clear
      redirect to '/'
    else
      redirect to '/groups'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/homepage'
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
