require './config/environment'
# require 'sinatra/base'
# require 'rack-flash'
require 'pry'
require 'sinatra/base'
require 'sinatra/flash'


class ExpenseController < ApplicationController #inherits from ApplicationController

  get '/expenses/new' do #displays create expense form
    if logged_in?
      @user = current_user
      @group = current_group
      erb :'/expenses/new'
    else
      redirect to '/login'
    end
  end

  post '/expenses' do #creates one expense
    if params[:expense][:name] == "" || params[:expense][:price] == ""
      flash[:message] = "Please make sure all fields are filled in."
      redirect to '/expenses/new'
    else
      group = Group.find_by_id(session[:group_id])
      user = User.find_by_id(session[:user_id])
      @expense = Expense.create(:name => params[:expense][:name], :price => params[:expense][:price], :user_id => user.id, :group_id => group.id)
      flash[:message] = "Sucessfully created a new expense"
      redirect to "/expenses/#{@expense.id}"
    end
  end

  get '/expenses/:id' do #expense show page
    if logged_in?
      @expense = Expense.find_by_id(params[:id])
      if @expense && current_user == @expense.user
        erb :'/expenses/show'
      else
        flash[:message] = "This expense no longer exists or it's not part of your groups"
        redirect to '/groups'
      end
    else
      redirect to '/login'
    end
  end

  get '/expenses/:id/edit' do #load expense edit form
    if logged_in?
      @expense = Expense.find_by_id(params[:id])
      if @expense && @expense.user == current_user
        erb :'/expenses/edit'
      else
        flash[:message] = "This expense no longer exists or it's not part of your groups"
        redirect to '/groups'
      end
    else
      redirect to '/login'
    end
  end

  patch '/expenses/:id' do #expense edit action
    if params[:expense][:name] == "" || params[:expense][:price] == ""
      flash[:message] = "All fields must be filled in."
      redirect to "/expenses/#{params[:id]}/edit"
    else
      @expense = Expense.find(params[:id])
      @expense.update_attributes(params[:expense])
      flash[:message] = "Successfully updated expense"
      redirect to "/expenses/#{@expense.id}"
    end
  end

  delete '/expenses/:id/delete' do
    if logged_in?
      @expense = Expense.find_by_id(params[:id])
      if @expense && @expense.user == current_user
        @expense.delete
      end
      flash[:message] = "Successfully deleted expense"
        redirect to "/groups/#{current_group.id}"
    else
      redirect to '/login'
    end
  end

end
