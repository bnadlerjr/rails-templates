# == Description
# Handles requests for +User+ management.
class UsersController < ApplicationController
  before_filter :user_required, :only => [:show, :edit, :update]
  before_filter :admin_required, :only => [:index, :destroy, :new, :create]
  before_filter :find_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.all

    respond_to do |wants|
      wants.html 
    end
  end

  def show
    respond_to do |wants|
      wants.html 
    end
  end

  def new
    @user = User.new

    respond_to do |wants|
      wants.html 
    end
  end

  def edit
  end

  def create
    @user = User.new(params[:user])

    respond_to do |wants|
      if @user.save
        flash[:success] = 'User was successfully created.'
        wants.html { redirect_to(@user) }
      else
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |wants|
      if @user.update_attributes(params[:user])
        flash[:success] = 'User was successfully updated.'
        wants.html { redirect_to(@user) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |wants|
      flash[:success] = 'User was deleted.'
      wants.html { redirect_to(users_url) }
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
