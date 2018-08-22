require './config/environment'
require 'pry'

class GroupController < ApplicationController #inherits from ApplicationController

  get '/groups' do #lists all groups
    if logged_in?
      @user = current_user
      erb :'groups/groups'
    else
      redirect to '/login'
    end
  end

  get '/groups/new' do #loads form to create new group
    if logged_in?
      @user = current_user
      erb :'groups/new'
    else
      redirect to '/login'
    end
  end

  post '/groups' do #create group
    if params[:group][:name] == ""
      redirect to '/groups/new'
    else
      binding.pry
      user = User.find_by_id(session[:user_id])
      @group = Group.create(:name => params[:group][:name], :user_id => user.id)
      session[:group_id] = @group.id
      binding.pry
      redirect to "/groups/#{@group.id}"
    end
  end

end
