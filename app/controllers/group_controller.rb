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

  get '/groups/:id' do #groups show page
    if logged_in?
      @group = Group.find_by_id(params[:id])
      session[:group_id] = @group.id
      erb :'groups/show'
    else
      redirect to '/login'
    end
  end

  get '/groups/:id/edit' do #load group edit form
    if logged_in?
      @group = Group.find_by_id(params[:id])
      if @group.user_id == session[:user_id]
        erb :'groups/edit'
      else
        redirect to '/groups'
      end
    else
      redirect to '/login'
    end
  end

  post '/groups/:id' do #edit action
    if params["group"]["name"] == ""
      redirect to "/groups/#{params[:id]}/edit"
    else
      @group = Group.find_by_id(params[:id])
      # @group.name = params[:group][:name]
      @group.update(params[:group])
      # @group.save
      redirect to "/groups/#{@group.id}"
    end
  end

  post '/groups/:id/delete' do
    if logged_in?
      @group = Group.find_by_id(params[:id])
      if @group && @group.user == current_user
        @group.delete
      end
        redirect to '/groups'
    else
      redirect to '/login'
    end
  end

end
