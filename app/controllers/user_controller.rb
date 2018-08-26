require './config/environment'
# require 'sinatra/base'
# require 'rack-flash'
require 'pry'
require 'sinatra/base'
require 'sinatra/flash'


class UserController < ApplicationController #inherits from ApplicationController


  get '/signup' do #loads signup page
    if logged_in?
      redirect to "/home"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do # create a new user
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      flash[:message] = "Please make sure all fields are filled in"
      redirect to '/signup'
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      if @user.save #validates_uniqueness_of :username, :email
        flash[:message] = "Successfully created an account!"
        session[:user_id] = @user.id
        redirect to "/home"
      else
        flash[:message] = "Please try another username or email"
        redirect to '/signup'
      end
    end
  end

  get '/login' do
    if logged_in?
      flash[:message] = "You are already logged in"
      redirect to "/home"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect to "/home"
      else
        flash[:message] = "Incorrect password, please try again"
        redirect to '/login'
      end
    else
      flash[:message] = "Account does not exist, please create a new account"
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:message] = "You have sucessfully signed out."
      redirect to '/'
    else
      redirect to "/home"
    end
  end

  get '/home' do
    if logged_in?
      erb :'users/homepage'
    else
      redirect to '/'
    end
  end

end
