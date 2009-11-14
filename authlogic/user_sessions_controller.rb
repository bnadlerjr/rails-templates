class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :user_required, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Login successful!"
      redirect_to root_url
    else
      render :action => :new
      flash[:error] = 'Invalid email or password.'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Logout successful!"
    redirect_to new_user_session_url
  end
end