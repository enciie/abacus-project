require './config/environment'
require 'sinatra/base'
require 'rack-flash'
require 'pry'

class UserController < ApplicationController #inherits from ApplicationController
  use Rack::Flash

  get '/signup' do #loads signup page
    if logged_in?
      redirect to "/home"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do # create a new user
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      flash[:message] = "flash test 1"
      redirect to '/signup'
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      if @user.save
        session[:user_id] = @user.id
        flash[:message] = "success"
        redirect to "/home"
      else
        # flash[:message] = @user.errors.full_messages.join(", ")
        redirect to '/signup'
      end
    end
  end

  get '/login' do
    if logged_in?
      redirect to "/home"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/home"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/'
    else
      redirect to "/home"
    end
  end

  get '/home' do
    erb :'users/homepage'
  end

end
