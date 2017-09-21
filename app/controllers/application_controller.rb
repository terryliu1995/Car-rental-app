class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  
  def current_user
    if session[:user_id]
      @current_user ||= Customer.find(session[:user_id]) if 0==session[:user_type]
      @current_user ||= Admin.find(session[:user_id]) if [1, 2].include?(session[:user_type])
    end
    return @current_user
  end
  
  def require_user
    redirect_to '/login' unless current_user
  end
end
