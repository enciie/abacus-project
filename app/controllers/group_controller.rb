require './config/environment'
# require 'sinatra/base'
# require 'rack-flash'
require 'pry'
require 'sinatra/base'
require 'sinatra/flash'


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
      flash[:message] = "Group Name cannot be blank"
      redirect to '/groups/new'
    else
      user = User.find_by_id(session[:user_id])
      @group = Group.create(:name => params[:group][:name], :user_id => user.id)
      session[:group_id] = @group.id
      flash[:message] = "Successfully created a new Group"
      redirect to "/groups/#{@group.id}"
    end
  end

  get '/groups/:id' do #groups show page
    if logged_in? # redirect_if_not_logged_in
      @group = Group.find_by_id(params[:id])
      if @group.user == current_user
        session[:group_id] = @group.id
        erb :'groups/show'
      else
        flash[:message] = "This group no longer exists or it's not part of your list"
        redirect to '/groups'
      end
    else
      redirect to '/login'
    end
  end

  get '/groups/:id/edit' do #load group edit form
    if logged_in?
      @group = Group.find_by_id(params[:id])
      if @group.user == current_user
        erb :'groups/edit'
      else
        flash[:message] = "The group no longer exists or it's not part of your list"
        redirect to '/groups'
      end
    else
      redirect to '/login'
    end
  end

  patch '/groups/:id' do #edit action
    if params["group"]["name"] == ""
      flash[:message] = "Group Name cannot be blank"
      redirect to "/groups/#{params[:id]}/edit"
    else
      @group = Group.find_by_id(params[:id])
      if @group && @group.user == current_user
        @group.update_attributes(params[:group])
      end
      redirect to "/groups/#{@group.id}"
    end
  end

  delete '/groups/:id/delete' do
    if logged_in?
      @group = Group.find_by_id(params[:id])
      if @group && @group.user == current_user
        @group.expenses.destroy_all
        @group.delete
      end
        flash[:message] = "Successfully deleted group"
        redirect to '/groups'
    else
      redirect to '/login'
    end
  end

end
