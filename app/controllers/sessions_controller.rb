class SessionsController < ApplicationController
  def new
  end

  def create
    user_type = params[:session][:user_type].to_i
    @user = Customer.find_by email: params[:session][:email] if user_type == 0
    @user = Admin.find_by email: params[:session][:email] if (user_type == 1 || user_type==2)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_type] = user_type
      session[:user_id] = @user.id
      redirect_to customer_path(@user) if 0 == user_type
      redirect_to admin_path(@user) if (1==user_type)||(2==user_type)
    else
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
