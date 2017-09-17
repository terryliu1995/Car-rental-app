class SessionsController < ApplicationController
  def new
  end

  def create
    user_type = params[:session][:user_type].to_i
    @user = Customer.find_by email: params[:session][:email] if user_type == 0
    if @user && @user.authenticate(params[:session][:password])
      session[:user_type] = user_type
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to 'login'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
