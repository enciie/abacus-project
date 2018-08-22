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

end
