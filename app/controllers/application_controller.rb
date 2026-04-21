class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    redirect_to login_path, alert: "Please sign in to continue." unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def log_in(user)
    reset_session
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
