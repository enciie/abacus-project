require './config/environment'
require 'pry'

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
    if params[:expenses][:name] == "" || params[:expenses][:price] == ""
      redirect to '/expenses/new'
    else
      group = Group.find_by_id(session[:group_id])
      user = User.find_by_id(session[:user_id])
      @expense = Expense.create(:name => params[:expenses][:name], :price => params[:expenses][:price], :user_id => user.id, :group_id => group.id)
      redirect to "/expenses/#{@expense.id}"
    end
  end

  get '/expenses/:id' do
    @expense = Expense.find_by_id(params[:id])
    erb :'/expenses/show'
  end

  get '/expenses/:id/edit' do
    @expense = Expense.find_by_id(params[:id])
    erb :'/expenses/edit'
  end

  post '/expenses/:id' do
    @expense = Expense.find(params[:id])
    @expense.update(params[:expense])
    @expense.save
    redirect to "/expenses/#{@expense.id}"
  end

  post '/expenses/:id/delete' do
    if logged_in?
      @expense = Expense.find_by_id(params[:id])
      if @expense && @expense.user == current_user
        @expense.delete
      end
        redirect to "/groups/#{current_group.id}"
    else
      redirect to '/login'
    end
  end

end
