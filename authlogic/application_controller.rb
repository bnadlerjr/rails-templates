# == Description
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for 
                       # details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  # Helper methods available to views
  helper_method :logged_in?, :admin_logged_in?, :current_user_session, 
                :current_user

  # Returns +true+ if a +User+ is currently logged into the application, 
  # otherwise +false+.
  def logged_in?
    !current_user_session.nil?
  end

  # Returns +true+ if a +User+ is logged into the application and the user 
  # is an administrator.
  def admin_logged_in?
    logged_in? && current_user.admin?
  end

  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def no_user_required
    if current_user
      flash[:notice] = "You must be logged out to access this page."
      redirect_to new_user_session_url
    end
  end

  def user_required
    unless current_user
      flash[:notice] = "You must be logged in to access this page."
      redirect_to new_user_session_url
    end
  end

  def admin_required
    if current_user
      unless current_user.admin?
        flash[:notice] = "Sorry, you don't have access to that."
      end
    else
      flash[:notice] = "You must be logged in to access this page."
      redirect_to new_user_session_url
    end
  end
end
