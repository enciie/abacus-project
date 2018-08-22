require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "abacus-secret"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :"/users/new"
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
    erb :"/users/index"
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/groups'
    else
      redirect to '/signup'
    end
  end

end
